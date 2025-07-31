#!/usr/bin/env python3
import requests
import chromadb

OLLAMA_URL = "http://127.0.0.1:11434"
MODEL = "phi"
DB_DIR = "chroma"

# Load your library
client = chromadb.PersistentClient(path=DB_DIR)
try:
    col = client.get_collection("library")
    print(f"📚 Loaded {col.count()} chunks from Desire of Ages")
except:
    print("❌ No library found")
    col = None

def retrieve_context(query, k=6):
    if not col: return ""
    try:
        results = col.query(query_texts=[query], n_results=k)
        docs = results["documents"][0]
        metas = results["metadatas"][0]
        context_parts = []
        for doc, meta in zip(docs, metas):
            filename = meta.get("filename", "unknown")
            chunk_num = meta.get("chunk", 0)
            context_parts.append(f"[Source: {filename} #chunk-{chunk_num}]\n{doc}")
        return "\n\n".join(context_parts)
    except: return ""

def ask_llm(prompt, use_rag=True):
    context = retrieve_context(prompt) if use_rag else ""
    
    if context:
        full_prompt = f"You are a helpful assistant. Use the provided context to answer accurately and cite sources.\n\nContext:\n{context}\n\nUser: {prompt}\nAssistant:"
    else:
        full_prompt = f"You are a helpful assistant.\n\nUser: {prompt}\nAssistant:"
    
    try:
        response = requests.post(f"{OLLAMA_URL}/api/generate", json={
            "model": MODEL, "prompt": full_prompt, "stream": False
        })
        data = response.json()
        return data.get("response", "No response")
    except Exception as e:
        return f"Error: {e}"

print("🤖 Augmented Phi-3 Terminal Chat")
print("Commands: 'rag on/off' to toggle, 'quit' to exit")
print("-" * 50)

use_rag = True
while True:
    try:
        prompt = input(f"\n🧑 You {'(RAG ON)' if use_rag else '(RAG OFF)'}: ").strip()
        
        if prompt.lower() == 'quit':
            break
        elif prompt.lower() == 'rag on':
            use_rag = True
            print("✅ RAG enabled")
            continue
        elif prompt.lower() == 'rag off':
            use_rag = False
            print("✅ RAG disabled")
            continue
        elif not prompt:
            continue
            
        print("\n🤖 Assistant:", end=" ")
        response = ask_llm(prompt, use_rag)
        print(response)
        
    except KeyboardInterrupt:
        print("\n\nGoodbye! 👋")
        break
