# server.py
from fastapi import FastAPI, Form
from fastapi.responses import JSONResponse, HTMLResponse
import requests
import chromadb

OLLAMA_URL = "http://127.0.0.1:11434"
MODEL = "phi3:latest"
DB_DIR = "chroma"

app = FastAPI()

client = chromadb.PersistentClient(path=DB_DIR)

try:
    col = client.get_collection("library")
    print(f"✅ Loaded library with {col.count()} chunks")
except:
    print("❌ No library found")
    col = None

@app.get("/", response_class=HTMLResponse)
def index():
    return """
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>My Augmented Phi-3</title>
    <style>
        body { 
            font-family: 'Fira Code', 'SF Mono', monospace; 
            background: #0a0a0a; 
            color: #f0f0f0; 
            margin: 0; 
            padding: 2rem;
            line-height: 1.6;
        }
        .container { max-width: 900px; margin: 0 auto; }
        h1 { color: #00ff88; margin-bottom: 1rem; }
        .chat-box { 
            background: #1a1a1a; 
            border: 1px solid #333; 
            border-radius: 8px; 
            padding: 1rem; 
            margin: 1rem 0;
            min-height: 300px;
            white-space: pre-wrap;
            font-family: inherit;
            overflow-y: auto;
            max-height: 500px;
        }
        textarea { 
            width: 100%; 
            background: #1a1a1a; 
            color: #f0f0f0; 
            border: 1px solid #333; 
            border-radius: 4px;
            padding: 1rem;
            font-family: inherit;
            resize: vertical;
        }
        button { 
            background: #00ff88; 
            color: #0a0a0a; 
            border: none; 
            border-radius: 4px; 
            padding: 0.7rem 1.5rem; 
            font-weight: bold;
            cursor: pointer;
            margin: 0.5rem 0.5rem 0.5rem 0;
        }
        button:hover { background: #00cc66; }
        .toggle { display: flex; align-items: center; margin: 1rem 0; }
        .toggle input { margin-right: 0.5rem; }
        .status { color: #888; font-size: 0.9em; }
        .stats { color: #666; font-size: 0.8em; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 My Augmented Phi-3</h1>
        <div class="stats">Library: 1,908 chunks from Desire of Ages</div>
        
        <div class="toggle">
            <input type="checkbox" id="use_rag" checked>
            <label for="use_rag">Use my books (RAG)</label>
        </div>
        
        <textarea id="prompt" rows="4" placeholder="Ask me about Ellen White's Desire of Ages..."></textarea>
        <br>
        <button onclick="sendMessage()">Send</button>
        <button onclick="clearChat()">Clear</button>
        
        <div id="response" class="chat-box"></div>
        <div id="status" class="status"></div>
    </div>

    <script>
        const responseDiv = document.getElementById('response');
        const statusDiv = document.getElementById('status');
        const promptInput = document.getElementById('prompt');
        
        function clearChat() {
            responseDiv.textContent = '';
        }
        
        async function sendMessage() {
            const prompt = promptInput.value.trim();
            if (!prompt) return;
            
            const useRag = document.getElementById('use_rag').checked;
            
            responseDiv.textContent += '🧑 You: ' + prompt + '\n\n🤖 Assistant: ';
            statusDiv.textContent = 'Thinking...';
            
            const formData = new FormData();
            formData.append('prompt', prompt);
            formData.append('use_rag', useRag ? 'true' : 'false');
            
            try {
                const response = await fetch('/chat', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                
                if (data.error) {
                    responseDiv.textContent += '❌ Error: ' + data.error;
                } else {
                    responseDiv.textContent += data.response;
                }
                
                responseDiv.textContent += '\n\n';
                responseDiv.scrollTop = responseDiv.scrollHeight;
                statusDiv.textContent = 'Ready';
                
            } catch (error) {
                responseDiv.textContent += '❌ Error: ' + error + '\n\n';
                statusDiv.textContent = 'Error occurred';
            }
        }
        
        promptInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    </script>
</body>
</html>
"""

def retrieve_context(query: str, k=8):
    if not col or col.count() == 0:
        return ""
    
    try:
        results = col.query(query_texts=[query], n_results=k)
        docs = results["documents"][0]
        metas = results["metadatas"][0]
        
        context_parts = []
        for i, (doc, meta) in enumerate(zip(docs, metas)):
            filename = meta.get("filename", "unknown")
            chunk_num = meta.get("chunk", 0)
            context_parts.append(f"[Source: {filename} #chunk-{chunk_num}]\n{doc}")
        
        return "\n\n".join(context_parts)
    except Exception as e:
        print(f"Retrieval error: {e}")
        return ""

@app.post("/chat")
def chat(prompt: str = Form(...), use_rag: str = Form("true")):
    context = ""
    if use_rag.lower() == "true":
        context = retrieve_context(prompt)
    
    system_msg = "You are a helpful assistant. If context is provided from the user's library, use it to answer accurately and cite sources like [Source: filename #chunk-N]. Be concise and helpful."
    
    if context:
        full_prompt = f"{system_msg}\n\nContext from user's library:\n{context}\n\nUser: {prompt}\nAssistant:"
    else:
        full_prompt = f"{system_msg}\n\nUser: {prompt}\nAssistant:"
    
    try:
        payload = {
            "model": MODEL,
            "prompt": full_prompt,
            "stream": False,
            "options": {"temperature": 0.7}
        }
        
        response = requests.post(f"{OLLAMA_URL}/api/generate", json=payload)
        data = response.json()
        
        if "response" in data:
            return JSONResponse({"response": data["response"]})
        else:
            return JSONResponse({"error": "No response from model"})
            
    except Exception as e:
        return JSONResponse({"error": str(e)})

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
