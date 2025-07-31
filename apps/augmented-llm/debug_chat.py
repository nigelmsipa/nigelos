#!/usr/bin/env python3
import requests
import chromadb

OLLAMA_URL = "http://127.0.0.1:11434"
MODEL = "phi"
DB_DIR = "chroma"

# Load library
client = chromadb.PersistentClient(path=DB_DIR)
try:
    col = client.get_collection("library")
    print(f"📚 Loaded {col.count()} chunks from Desire of Ages")
except:
    print("❌ No library found")
    col = None

def debug_retrieval(query):
    if not col: 
        print("❌ No collection loaded")
        return ""
    
    print(f"\n🔍 Searching for: '{query}'")
    try:
        results = col.query(query_texts=[query], n_results=3)
        docs = results["documents"][0]
        metas = results["metadatas"][0]
        
        print(f"✅ Found {len(docs)} relevant chunks:")
        for i, (doc, meta) in enumerate(zip(docs, metas)):
            filename = meta.get("filename", "unknown")
            chunk_num = meta.get("chunk", 0)
            print(f"\n--- Chunk {i+1}: {filename} #chunk-{chunk_num} ---")
            print(doc[:200] + "..." if len(doc) > 200 else doc)
        
        context_parts = []
        for doc, meta in zip(docs, metas):
            filename = meta.get("filename", "unknown")
            chunk_num = meta.get("chunk", 0)
            context_parts.append(f"[Source: {filename} #chunk-{chunk_num}]\n{doc}")
        return "\n\n".join(context_parts)
    except Exception as e:
        print(f"❌ Retrieval error: {e}")
        return ""

# Test some searches
test_queries = ["Jesus", "Christ", "temple", "love"]
print("\n=== TESTING RETRIEVAL ===")
for query in test_queries:
    context = debug_retrieval(query)
    print(f"\nContext length for '{query}': {len(context)} characters")
    print("-" * 50)

# Interactive mode
print("\n=== INTERACTIVE MODE ===")
print("Type a question to see what chunks are retrieved...")

while True:
    try:
        prompt = input(f"\n🧑 Test question: ").strip()
        if prompt.lower() == 'quit': break
        
        context = debug_retrieval(prompt)
        if context:
            print(f"\n📝 Would send this context to model:")
            print(f"Context: {context[:300]}...")
        else:
            print("❌ No relevant context found")
            
    except KeyboardInterrupt:
        break
