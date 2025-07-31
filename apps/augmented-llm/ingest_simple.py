# ingest_simple.py - Using sentence-transformers instead of Ollama embeddings
from pathlib import Path
from pypdf import PdfReader
import chromadb

BOOK_DIR = "books"
DB_DIR = "chroma"

def read_any(fp: Path) -> str:
    if fp.suffix.lower() == ".pdf":
        text = []
        try:
            pdf = PdfReader(str(fp))
            for p in pdf.pages:
                text.append(p.extract_text() or "")
            return "\n".join(text)
        except:
            print(f"Failed to read PDF: {fp}")
            return ""
    try:
        return fp.read_text(errors="ignore")
    except:
        print(f"Failed to read file: {fp}")
        return ""

def chunk(txt: str, size=1000, overlap=150):
    if len(txt) < size:
        return [txt]
    
    out, i = [], 0
    while i < len(txt):
        end = min(i + size, len(txt))
        out.append(txt[i:end])
        if end >= len(txt):
            break
        i += size - overlap
    return out

def main():
    client = chromadb.PersistentClient(path=DB_DIR)
    
    # Use default sentence-transformers embedding (runs locally)
    try:
        client.delete_collection("library")
    except:
        pass
    
    col = client.create_collection("library")  # Uses default embeddings

    ids, docs, metas = [], [], []
    
    for fp in Path(BOOK_DIR).rglob("*"):
        if not fp.is_file():
            continue
            
        print(f"Processing: {fp.name}")
        txt = read_any(fp)
        
        if not txt.strip():
            print(f"No text extracted from {fp.name}")
            continue
            
        pieces = chunk(txt)
        for j, ch in enumerate(pieces):
            if ch.strip():
                ids.append(f"{fp.name}-{j}")
                docs.append(ch)
                metas.append({"filename": fp.name, "chunk": j})
    
    if ids:
        print(f"Adding {len(ids)} chunks to database...")
        col.add(ids=ids, documents=docs, metadatas=metas)
        print("✅ Done!")
    else:
        print("❌ No valid content found in books folder")

if __name__ == "__main__":
    main()
