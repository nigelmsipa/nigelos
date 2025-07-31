#!/usr/bin/env python3
import requests
import chromadb

OLLAMA_URL = "http://127.0.0.1:11434"
MODEL = "phi"
DB_DIR = "chroma"

client = chromadb.PersistentClient(path=DB_DIR)
col = client.get_collection("library")

def get_context(query, k=8):  # Increased to 8 chunks
    results = col.query(query_texts=[query], n_results=k)
    docs = results["documents"][0]
    metas = results["metadatas"][0]
    
    context_parts = []
    for doc, meta in zip(docs, metas):
        filename = meta.get("filename", "unknown")
        chunk_num = meta.get("chunk", 0)
        context_parts.append(f"[Source: {filename} #chunk-{chunk_num}]\n{doc}")
    return "\n\n".join(context_parts)

def test_question(question):
    print(f"\n🧑 Question: {question}")
    
    # Test WITHOUT context
    prompt_no_rag = f"User: {question}\nAssistant:"
    response = requests.post(f"{OLLAMA_URL}/api/generate", json={
        "model": MODEL, "prompt": prompt_no_rag, "stream": False
    })
    no_rag_answer = response.json().get("response", "")
    print(f"\n❌ WITHOUT RAG:\n{no_rag_answer[:200]}...")
    
    # Test WITH context  
    context = get_context(question)
    prompt_with_rag = f"""You are an expert on Ellen White's writings. Use ONLY the provided context to answer. Always cite your sources.

Context from Desire of Ages:
{context}

User: {question}
Assistant: Based on Ellen White's Desire of Ages:"""
    
    response = requests.post(f"{OLLAMA_URL}/api/generate", json={
        "model": MODEL, "prompt": prompt_with_rag, "stream": False
    })
    rag_answer = response.json().get("response", "")
    print(f"\n✅ WITH RAG:\n{rag_answer[:300]}...")
    
    print(f"\n📚 Context used ({len(context)} chars):")
    print(context[:200] + "..." if len(context) > 200 else context)

# Test a specific Ellen White question
test_question("How does Ellen White describe Christ's character?")
