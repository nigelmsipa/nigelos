# Entry 4: Python - The Scripting Superpower

### What IS Python? (Unveiling the Mystery)

**Simple answer**: Python is a programming language that lets you tell the computer what to do using human-readable text.

**Better answer**: Python is an interpreted, high-level language that sits on top of C, which sits on top of assembly, which sits on top of machine code, which controls transistors.

**The key insight**: When you write Python, you're standing on top of the entire computing tower we've been exploring. Python hides ALL the complexity—no pointers, no memory management, no hardware registers. Just clear, readable instructions.

---

### The Philosophy: Why Python Exists

**The problem in the 1980s**:
- C was powerful but dangerous (manual memory management, easy to crash)
- Shell scripts were limited (string manipulation, no real data structures)
- Perl existed but was cryptic ("Write-only language")

**Guido van Rossum's vision (1991)**:
- "I want a language that's READABLE"
- "Code should look like pseudocode"
- "Make the easy things easy, and the hard things possible"

**The result**: Python

```python
# This Python code reads itself:
if temperature > 30:
    print("It's hot outside")
```

Compare to C:
```c
if (temperature > 30) {
    printf("It's hot outside\n");
}
```

**Python's secret**: It's not faster or more powerful—it's just CLEARER. And clarity is a superpower when you're trying to get things done.

---

### How Python Actually Runs: The Interpreter

**When you run a Python script, here's what happens:**

#### Step 1: You write code
```python
print("Hello, world")
```

#### Step 2: Python reads your code
- The Python interpreter (a program written in C) reads your .py file
- Parses it (checks syntax, builds a structure)

#### Step 3: Compiles to bytecode
- Converts your code to bytecode (.pyc files)
- Bytecode = intermediate language (not machine code, not Python)
- Stored in `__pycache__/` directory
- This is why the second run is slightly faster—bytecode is cached

#### Step 4: Python Virtual Machine executes bytecode
- The PVM (written in C) reads bytecode instructions
- Translates each instruction to C function calls
- C code compiles to machine code
- CPU executes machine code

#### The Tower (Again!)

```
Your Python code: print("Hello")
        ↓
Python interpreter (parser)
        ↓
Bytecode (.pyc)
        ↓
Python Virtual Machine (PVM)
        ↓
C code (CPython implementation)
        ↓
Machine code
        ↓
CPU instructions
        ↓
Transistors switching
        ↓
Electrons flowing
```

**Why this matters**: Python is SLOW compared to C because it has so many layers. But it's FAST to write and debug. Trade-off: development speed vs. execution speed.

For scripting (renaming files, automating tasks): Python's execution speed is MORE than fast enough, and you'll write the script in 5 minutes instead of an hour.

---

### The Basics: Python Fundamentals for Scripting

#### Variables (No Declaration Needed!)

```python
# In C, you declare types:
# int age = 30;
# char* name = "Nigel";

# In Python, just assign:
age = 30
name = "Nigel"
path = "/home/nigel/Suno/sleepy fish"

# Python figures out the type automatically (dynamic typing)
```

**What's happening underneath**: Python creates objects in memory, and variables are just labels pointing to those objects.

#### Data Types You'll Actually Use

```python
# Strings (text)
filename = "01 - Butterfly.mp3"

# Integers (whole numbers)
count = 68

# Floats (decimals)
temperature = 98.6

# Booleans (True/False)
is_done = True

# Lists (ordered collection)
files = ["song1.mp3", "song2.mp3", "song3.mp3"]

# Dictionaries (key-value pairs)
file_info = {
    "name": "Butterfly.mp3",
    "size": 2715140,
    "artist": "Unknown"
}

# None (like null/nil in other languages)
result = None
```

#### Strings: The Scripting Workhorse

```python
# Creating strings
name = "Butterfly.mp3"
path = '/home/nigel/Music'  # Single or double quotes work

# String formatting (f-strings - USE THESE!)
number = 5
filename = f"{number:02d} - Butterfly.mp3"  # "05 - Butterfly.mp3"
# :02d means "integer, at least 2 digits, pad with zeros"

# String methods
name = "  Hello World  "
name.strip()        # "Hello World" (remove whitespace)
name.lower()        # "hello world"
name.upper()        # "HELLO WORLD"
name.startswith("Hello")  # True
name.endswith(".mp3")     # False
name.replace("World", "Python")  # "Hello Python"

# Splitting and joining
path = "/home/nigel/Music"
parts = path.split("/")  # ['', 'home', 'nigel', 'Music']
joined = "-".join(["01", "Butterfly", "mp3"])  # "01-Butterfly-mp3"

# Checking contents
"nigel" in path     # True
"windows" in path   # False
```

#### Lists: Collections You Can Change

```python
# Creating lists
files = ["song1.mp3", "song2.mp3"]

# Adding items
files.append("song3.mp3")           # Add to end
files.insert(0, "song0.mp3")        # Insert at position 0

# Accessing items
first = files[0]                     # "song0.mp3"
last = files[-1]                     # "song3.mp3"
some = files[1:3]                    # ["song1.mp3", "song2.mp3"] (slice)

# Removing items
files.remove("song1.mp3")            # Remove by value
popped = files.pop()                 # Remove and return last item

# Checking
len(files)                           # Number of items
"song2.mp3" in files                 # True/False

# Sorting
files.sort()                         # Sort in place
sorted_files = sorted(files)         # Return sorted copy

# Looping
for file in files:
    print(file)
```

#### Dictionaries: Labeled Data

```python
# Creating dictionaries
file_info = {
    "name": "Butterfly.mp3",
    "size": 2715140,
    "path": "/home/nigel/Music"
}

# Accessing values
name = file_info["name"]             # "Butterfly.mp3"
size = file_info.get("size")         # 2715140
artist = file_info.get("artist", "Unknown")  # "Unknown" (default if key missing)

# Adding/updating
file_info["artist"] = "Various"
file_info["duration"] = 180

# Checking
"name" in file_info                  # True
"album" in file_info                 # False

# Looping
for key, value in file_info.items():
    print(f"{key}: {value}")
```

---

### Control Flow: Making Decisions

#### If Statements

```python
# Basic if
if temperature > 30:
    print("Hot!")

# If-else
if count > 0:
    print("We have files")
else:
    print("No files")

# If-elif-else
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
else:
    grade = "F"

# Conditions you'll use:
# ==  (equal)
# !=  (not equal)
# >   (greater than)
# <   (less than)
# >=  (greater than or equal)
# <=  (less than or equal)
# in  (membership)
# not (negation)
# and (both conditions)
# or  (either condition)

if file.endswith(".mp3") and "Butterfly" in file:
    print("Found the butterfly song!")
```

**IMPORTANT**: Python uses INDENTATION instead of braces `{}`. This is not cosmetic—it's syntax. Get the indentation wrong = syntax error.

```python
# Correct:
if True:
    print("Indented")
    print("Also indented")

# Wrong (mixing tabs and spaces = disaster):
if True:
    print("Spaces")
	print("Tab - will cause error!")
```

**Pro tip**: Use 4 spaces for indentation. Configure your editor to convert tabs to 4 spaces.

#### Loops: Doing Things Repeatedly

**For loops** (when you know what to iterate over):

```python
# Loop over a list
files = ["song1.mp3", "song2.mp3", "song3.mp3"]
for file in files:
    print(file)

# Loop over a range
for i in range(5):           # 0, 1, 2, 3, 4
    print(i)

for i in range(1, 6):        # 1, 2, 3, 4, 5
    print(i)

for i in range(0, 10, 2):    # 0, 2, 4, 6, 8 (step by 2)
    print(i)

# Enumerate (when you need the index)
files = ["song1.mp3", "song2.mp3"]
for index, file in enumerate(files):
    print(f"{index}: {file}")

# Even better: Start counting from 1
for index, file in enumerate(files, start=1):
    print(f"{index}: {file}")
```

**While loops** (when you don't know how many iterations):

```python
# Loop until condition is false
count = 0
while count < 5:
    print(count)
    count += 1

# Infinite loop (use with caution!)
while True:
    user_input = input("Enter 'quit' to exit: ")
    if user_input == "quit":
        break  # Exit the loop
```

**Loop control**:
```python
# break - exit the loop immediately
for i in range(10):
    if i == 5:
        break  # Stop at 5
    print(i)

# continue - skip to next iteration
for i in range(10):
    if i % 2 == 0:  # If even
        continue    # Skip even numbers
    print(i)        # Only prints odd numbers
```

---

### File Operations: The Heart of Scripting

This is where Python becomes your Linux automation tool.

#### Reading Files

```python
# Method 1: The safe way (automatically closes file)
with open("/path/to/file.txt", "r") as f:
    content = f.read()  # Read entire file as string
    print(content)

# Method 2: Read line by line
with open("/path/to/file.txt", "r") as f:
    for line in f:
        print(line.strip())  # strip() removes trailing newline

# Method 3: Read all lines into a list
with open("/path/to/file.txt", "r") as f:
    lines = f.readlines()  # List of strings
    print(lines[0])        # First line
```

**Why `with open()`?** It automatically closes the file when done, even if an error occurs. This prevents file handle leaks.

#### Writing Files

```python
# Write mode (overwrites existing file)
with open("/path/to/output.txt", "w") as f:
    f.write("Hello, world!\n")
    f.write("Another line\n")

# Append mode (adds to end of file)
with open("/path/to/output.txt", "a") as f:
    f.write("Appended line\n")

# Writing multiple lines
lines = ["Line 1\n", "Line 2\n", "Line 3\n"]
with open("/path/to/output.txt", "w") as f:
    f.writelines(lines)
```

#### Checking if Files/Directories Exist

```python
import os

# Check if file exists
if os.path.exists("/home/nigel/file.txt"):
    print("File exists")

# Check if it's a file
if os.path.isfile("/home/nigel/file.txt"):
    print("It's a file")

# Check if it's a directory
if os.path.isdir("/home/nigel/Music"):
    print("It's a directory")
```

---

### Working with Paths: The Right Way

**NEVER manually concatenate paths with `/`**. Use `os.path` or `pathlib`.

```python
import os

# Join path components (handles / automatically)
music_dir = "/home/nigel/Music"
filename = "song.mp3"
full_path = os.path.join(music_dir, filename)
# Result: "/home/nigel/Music/song.mp3"

# Get the directory name
path = "/home/nigel/Music/song.mp3"
directory = os.path.dirname(path)   # "/home/nigel/Music"

# Get the filename
filename = os.path.basename(path)   # "song.mp3"

# Split path into directory and filename
directory, filename = os.path.split(path)

# Get file extension
name, ext = os.path.splitext("song.mp3")
# name = "song", ext = ".mp3"

# Expand ~ to home directory
home_path = os.path.expanduser("~/Music")
# Result: "/home/nigel/Music"

# Get absolute path
abs_path = os.path.abspath("../relative/path")
```

**Modern way: pathlib** (Python 3.4+)

```python
from pathlib import Path

# Create path object
music_dir = Path("/home/nigel/Music")
song_file = music_dir / "song.mp3"  # Use / operator to join!

# Check existence
if song_file.exists():
    print("File exists")

# Check if directory
if music_dir.is_dir():
    print("It's a directory")

# Get parts
print(song_file.name)       # "song.mp3"
print(song_file.stem)       # "song" (without extension)
print(song_file.suffix)     # ".mp3"
print(song_file.parent)     # Path("/home/nigel/Music")

# Read/write files directly
content = song_file.read_text()
song_file.write_text("New content")
```

**Pro tip**: Use `pathlib` for new code—it's cleaner and more intuitive.

---

### Directory Operations

```python
import os

# List files in directory
files = os.listdir("/home/nigel/Music")
# Returns: ['song1.mp3', 'song2.mp3', 'song3.mp3']

# List files with full paths
import os
directory = "/home/nigel/Music"
for filename in os.listdir(directory):
    full_path = os.path.join(directory, filename)
    print(full_path)

# Filter by extension
mp3_files = [f for f in os.listdir(directory) if f.endswith('.mp3')]

# Change directory
os.chdir("/home/nigel/Music")
current = os.getcwd()  # Get current working directory

# Create directory
os.mkdir("/home/nigel/NewFolder")          # Create one directory
os.makedirs("/home/nigel/a/b/c")           # Create nested directories

# Remove directory
os.rmdir("/home/nigel/EmptyFolder")        # Only works if empty
import shutil
shutil.rmtree("/home/nigel/NonEmptyFolder") # Removes directory and contents
```

**Using pathlib for directories:**

```python
from pathlib import Path

music_dir = Path("/home/nigel/Music")

# List all files
for file in music_dir.iterdir():
    print(file)

# List only .mp3 files (using glob pattern)
for mp3 in music_dir.glob("*.mp3"):
    print(mp3)

# Recursive search (all .mp3 in subdirectories too)
for mp3 in music_dir.rglob("*.mp3"):
    print(mp3)

# Create directory
new_dir = Path("/home/nigel/NewFolder")
new_dir.mkdir(exist_ok=True)  # exist_ok=True means no error if exists

# Create nested directories
nested = Path("/home/nigel/a/b/c")
nested.mkdir(parents=True, exist_ok=True)
```

---

### Moving, Copying, Renaming Files

```python
import os
import shutil

# Rename file (os.rename)
os.rename("old_name.txt", "new_name.txt")

# Move file to different directory (shutil.move)
shutil.move("file.txt", "/home/nigel/Documents/file.txt")

# Copy file
shutil.copy("source.txt", "destination.txt")
shutil.copy("source.txt", "/home/nigel/Documents/")  # Copy to directory

# Copy file with metadata (permissions, timestamps)
shutil.copy2("source.txt", "destination.txt")

# Copy entire directory
shutil.copytree("source_dir", "destination_dir")

# Remove file
os.remove("file.txt")

# Check before removing (safe)
if os.path.exists("file.txt"):
    os.remove("file.txt")
```

---

### THE SCRIPT: Renaming MP3 Files (Your Goal)

Now let's build the script we used earlier, step by step, so you understand every piece.

#### Version 1: Basic Renaming

```python
import os

# Set the directory
directory = "/home/nigel/Suno/sleepy fish"

# Change to that directory
os.chdir(directory)

# Get all .mp3 files
files = [f for f in os.listdir('.') if f.endswith('.mp3')]

# Sort them (alphabetically)
files.sort()

# Rename each file with a number prefix
for index, file in enumerate(files, start=1):
    # Create new name: "01 - filename.mp3"
    new_name = f"{index:02d} - {file}"

    # Rename the file
    os.rename(file, new_name)

    # Print confirmation
    print(f"Renamed: {file} -> {new_name}")

print(f"\nRenamed {len(files)} files")
```

**What this does**:
1. Changes to the directory
2. Gets list of all .mp3 files
3. Sorts them alphabetically
4. Loops through with index starting at 1
5. Creates new name with zero-padded number (01, 02, etc.)
6. Renames each file
7. Prints progress

#### Version 2: Removing Existing Number Prefixes First

```python
import os
import re  # Regular expressions

directory = "/home/nigel/Suno/sleepy fish"
os.chdir(directory)

# Get all .mp3 files
files = [f for f in os.listdir('.') if f.endswith('.mp3')]

# Step 1: Remove any existing number prefixes
for file in files:
    # Remove patterns like "01 - " from the beginning
    # \d+ means "one or more digits"
    # ^ means "start of string"
    new_name = re.sub(r'^\d+ - ', '', file)

    if new_name != file:  # Only rename if changed
        os.rename(file, new_name)
        print(f"Cleaned: {file} -> {new_name}")

# Step 2: Get fresh list and sort
files = sorted([f for f in os.listdir('.') if f.endswith('.mp3')])

# Step 3: Add new number prefixes
for index, file in enumerate(files, start=1):
    new_name = f"{index:02d} - {file}"
    os.rename(file, new_name)
    print(f"Numbered: {file} -> {new_name}")

print(f"\nProcessed {len(files)} files")
```

**New concepts here**:
- `re.sub()` - Regular expression substitution
- `r'^\d+ - '` - Pattern meaning "digits at start followed by space-dash-space"
- Two-pass process: clean first, then number

#### Version 3: Safe Version with Error Handling

```python
import os
import re
from pathlib import Path

def rename_music_files(directory):
    """Rename all .mp3 files in directory with number prefixes."""

    # Convert to Path object
    dir_path = Path(directory)

    # Check if directory exists
    if not dir_path.exists():
        print(f"Error: Directory '{directory}' not found")
        return

    if not dir_path.is_dir():
        print(f"Error: '{directory}' is not a directory")
        return

    # Get all .mp3 files
    files = [f for f in dir_path.iterdir() if f.suffix == '.mp3']

    if not files:
        print("No .mp3 files found")
        return

    print(f"Found {len(files)} MP3 files\n")

    # Step 1: Clean existing prefixes
    for file in files:
        # Get just the filename
        original = file.name

        # Remove number prefixes
        cleaned = re.sub(r'^\d+ - ', '', original)

        if cleaned != original:
            new_path = file.parent / cleaned
            file.rename(new_path)
            print(f"Cleaned: {original}")

    # Step 2: Get fresh list and sort
    files = sorted([f for f in dir_path.iterdir() if f.suffix == '.mp3'])

    # Step 3: Number them
    print(f"\nNumbering {len(files)} files...\n")

    for index, file in enumerate(files, start=1):
        original = file.name
        new_name = f"{index:02d} - {original}"
        new_path = file.parent / new_name

        try:
            file.rename(new_path)
            print(f"{index:02d}: {original}")
        except Exception as e:
            print(f"Error renaming {original}: {e}")

    print(f"\nDone! Processed {len(files)} files")

# Run the function
if __name__ == "__main__":
    directory = "/home/nigel/Suno/sleepy fish"
    rename_music_files(directory)
```

**New concepts**:
- Functions (`def function_name():`)
- Docstrings (""" description """)
- Error handling (`try/except`)
- `if __name__ == "__main__":` - only runs if script is executed directly
- Using pathlib throughout

---

### Running Shell Commands from Python

Sometimes you need to run Linux commands from Python.

```python
import subprocess

# Method 1: Run command, capture output
result = subprocess.run(['ls', '-la'], capture_output=True, text=True)
print(result.stdout)  # The output

# Method 2: Run command, check if successful
result = subprocess.run(['mkdir', 'new_folder'])
if result.returncode == 0:
    print("Success!")
else:
    print("Failed!")

# Method 3: Run shell command (with shell=True, be careful!)
subprocess.run('ls -la | grep mp3', shell=True)

# Method 4: Get output as string
output = subprocess.check_output(['git', 'status']).decode('utf-8')
print(output)

# Practical example: Get list of running processes
result = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
for line in result.stdout.split('\n'):
    if 'python' in line.lower():
        print(line)
```

**When to use subprocess**:
- When you need to call existing Linux tools
- When the task is easier in bash than Python
- When you're wrapping system utilities

**When NOT to use subprocess**:
- File operations (use Python's os/pathlib instead)
- Text processing (use Python's string methods)
- Most things Python can already do

---

### Script Structure: Best Practices

#### The Standard Python Script Template

```python
#!/usr/bin/env python3
"""
Script description: What this script does
Author: Your name
Date: 2025-12-09
"""

import os
import sys
from pathlib import Path

# Constants (UPPERCASE naming convention)
DEFAULT_DIRECTORY = "/home/nigel/Music"
MAX_FILES = 1000

# Functions (lowercase with underscores)
def process_files(directory):
    """Process all files in the given directory."""
    # Function implementation
    pass

def validate_input(value):
    """Check if input is valid."""
    if not value:
        return False
    return True

# Main execution
if __name__ == "__main__":
    print("Starting script...")

    # Your main logic here
    directory = DEFAULT_DIRECTORY
    process_files(directory)

    print("Done!")
```

**Why this structure?**:
- Shebang (`#!/usr/bin/env python3`) - tells Linux this is a Python script
- Docstring - explains what the script does
- Imports at top - all dependencies visible at a glance
- Constants - values that don't change
- Functions - reusable pieces of logic
- `if __name__ == "__main__":` - main execution block

---

### Making Your Script Executable

```bash
# Make script executable
chmod +x my_script.py

# Run it directly (thanks to shebang)
./my_script.py

# Or run with python explicitly
python3 my_script.py
```

---

### Common Patterns for Linux Automation

#### Pattern 1: Process all files in a directory

```python
from pathlib import Path

directory = Path("/home/nigel/Documents")

for file in directory.iterdir():
    if file.is_file():
        print(f"Processing: {file.name}")
        # Do something with file
```

#### Pattern 2: Find files matching a pattern

```python
from pathlib import Path

directory = Path("/home/nigel")

# Find all .txt files
for txt_file in directory.rglob("*.txt"):
    print(txt_file)

# Find files with "report" in name
for file in directory.rglob("*report*"):
    print(file)
```

#### Pattern 3: Process text file line by line

```python
with open("logfile.txt", "r") as f:
    for line in f:
        line = line.strip()  # Remove whitespace

        if line.startswith("ERROR"):
            print(f"Found error: {line}")
```

#### Pattern 4: Build a list of file info

```python
import os
from pathlib import Path

directory = Path("/home/nigel/Music")
file_info = []

for file in directory.glob("*.mp3"):
    info = {
        "name": file.name,
        "size": file.stat().st_size,
        "path": str(file)
    }
    file_info.append(info)

# Sort by size
file_info.sort(key=lambda x: x["size"], reverse=True)

# Print largest files
for info in file_info[:10]:  # Top 10
    size_mb = info["size"] / (1024 * 1024)
    print(f"{info['name']}: {size_mb:.2f} MB")
```

#### Pattern 5: User input and validation

```python
def get_user_input():
    """Get and validate user input."""

    while True:
        directory = input("Enter directory path: ")

        if not directory:
            print("Directory cannot be empty")
            continue

        if not os.path.exists(directory):
            print("Directory does not exist")
            continue

        if not os.path.isdir(directory):
            print("Path is not a directory")
            continue

        # Valid input
        return directory

directory = get_user_input()
print(f"Processing: {directory}")
```

#### Pattern 6: Command-line arguments

```python
import sys

# Script called like: python3 script.py /home/nigel/Music

if len(sys.argv) < 2:
    print("Usage: python3 script.py <directory>")
    sys.exit(1)

directory = sys.argv[1]
print(f"Processing directory: {directory}")

# Or use argparse for more complex arguments:
import argparse

parser = argparse.ArgumentParser(description="Rename music files")
parser.add_argument("directory", help="Directory containing music files")
parser.add_argument("--dry-run", action="store_true", help="Show what would be done")

args = parser.parse_args()

print(f"Directory: {args.directory}")
if args.dry_run:
    print("DRY RUN MODE - no changes will be made")
```

---

### Debugging: When Things Go Wrong

#### Print debugging (the classic)

```python
# Add print statements to see what's happening
for index, file in enumerate(files):
    print(f"DEBUG: index={index}, file={file}")  # Debug line
    new_name = f"{index:02d} - {file}"
    print(f"DEBUG: new_name={new_name}")  # Debug line
    os.rename(file, new_name)
```

#### Using Python's interactive mode

```bash
# Run Python interactively
python3

>>> import os
>>> os.listdir('/home/nigel/Music')
['song1.mp3', 'song2.mp3']
>>> # Test your code here
>>> exit()
```

#### Common errors and what they mean

```python
# FileNotFoundError - file/directory doesn't exist
# Check: Does the path exist? Did you spell it right?

# PermissionError - don't have permission to read/write
# Fix: Check file permissions, maybe need sudo

# IndexError - tried to access list item that doesn't exist
# Fix: Check list length before accessing

# KeyError - tried to access dictionary key that doesn't exist
# Fix: Use .get() method instead

# IndentationError - mixed tabs/spaces or wrong indentation
# Fix: Use 4 spaces consistently

# SyntaxError - typo in Python code
# Fix: Check the line number in error message
```

---

### The Python Philosophy: The Zen of Python

Open a Python interpreter and type:

```python
import this
```

You'll see:
```
Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Readability counts.
...
```

**What this means for scripting**:

1. **Readability counts** - Code is read more than written. Make it clear.

```python
# Bad (cryptic)
f=[x for x in os.listdir('.') if x[-4:]=='.mp3']

# Good (clear)
mp3_files = [file for file in os.listdir('.') if file.endswith('.mp3')]
```

2. **Explicit is better than implicit** - Don't make the reader guess.

```python
# Bad
from os import *  # Imports everything, unclear what you're using

# Good
import os  # Clear that we're using os module
from pathlib import Path  # Explicit about what we need
```

3. **Simple is better than complex** - Don't over-engineer.

```python
# Bad (over-engineered for simple task)
class FileRenamer:
    def __init__(self, directory):
        self.directory = directory

    def rename_files(self):
        # ... complex implementation

# Good (simple function is enough)
def rename_files(directory):
    # ... straightforward implementation
```

---

### Practical Exercise: Your Turn

Here's a script challenge to solidify your learning:

**Task**: Write a script that:
1. Takes a directory path as input
2. Finds all .txt files in that directory
3. Counts the number of lines in each file
4. Prints a report showing filename and line count
5. Prints the total number of lines across all files

**Hints**:
```python
# Get command line argument
import sys
directory = sys.argv[1]

# Find .txt files
from pathlib import Path
txt_files = Path(directory).glob("*.txt")

# Count lines in a file
with open(file, 'r') as f:
    lines = len(f.readlines())

# Loop and accumulate
total = 0
for file in files:
    count = count_lines(file)
    total += count
```

**Try it yourself before looking at the solution!**

<details>
<summary>Solution (click to expand)</summary>

```python
#!/usr/bin/env python3
"""Count lines in all .txt files in a directory."""

import sys
from pathlib import Path

def count_lines(file_path):
    """Count lines in a file."""
    with open(file_path, 'r') as f:
        return len(f.readlines())

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 count_lines.py <directory>")
        sys.exit(1)

    directory = Path(sys.argv[1])

    if not directory.exists():
        print(f"Error: '{directory}' does not exist")
        sys.exit(1)

    if not directory.is_dir():
        print(f"Error: '{directory}' is not a directory")
        sys.exit(1)

    # Find all .txt files
    txt_files = list(directory.glob("*.txt"))

    if not txt_files:
        print("No .txt files found")
        return

    print(f"\nLine count report for: {directory}\n")
    print(f"{'Filename':<30} {'Lines':>10}")
    print("-" * 42)

    total_lines = 0

    for file in sorted(txt_files):
        try:
            line_count = count_lines(file)
            total_lines += line_count
            print(f"{file.name:<30} {line_count:>10}")
        except Exception as e:
            print(f"{file.name:<30} {'ERROR':>10}")

    print("-" * 42)
    print(f"{'TOTAL':<30} {total_lines:>10}")
    print(f"\nProcessed {len(txt_files)} files")

if __name__ == "__main__":
    main()
```
</details>

---

### Python for System Administration: Common Tasks

#### 1. Clean up old files

```python
from pathlib import Path
from datetime import datetime, timedelta

def delete_old_files(directory, days_old):
    """Delete files older than specified days."""
    cutoff = datetime.now() - timedelta(days=days_old)

    for file in Path(directory).iterdir():
        if file.is_file():
            modified_time = datetime.fromtimestamp(file.stat().st_mtime)

            if modified_time < cutoff:
                print(f"Deleting old file: {file.name}")
                file.unlink()

delete_old_files("/tmp/cache", days_old=30)
```

#### 2. Check disk usage

```python
import shutil

def check_disk_usage(path):
    """Check disk usage for a path."""
    usage = shutil.disk_usage(path)

    total_gb = usage.total / (1024 ** 3)
    used_gb = usage.used / (1024 ** 3)
    free_gb = usage.free / (1024 ** 3)
    percent = (usage.used / usage.total) * 100

    print(f"Disk usage for {path}:")
    print(f"  Total: {total_gb:.2f} GB")
    print(f"  Used:  {used_gb:.2f} GB ({percent:.1f}%)")
    print(f"  Free:  {free_gb:.2f} GB")

check_disk_usage("/home")
```

#### 3. Backup files

```python
import shutil
from datetime import datetime
from pathlib import Path

def backup_directory(source, backup_base):
    """Create timestamped backup of directory."""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_name = f"backup_{timestamp}"
    backup_path = Path(backup_base) / backup_name

    print(f"Backing up {source} to {backup_path}")
    shutil.copytree(source, backup_path)
    print("Backup complete!")

backup_directory("/home/nigel/Documents", "/home/nigel/Backups")
```

#### 4. Monitor log files

```python
import time

def tail_log(log_file, keyword=None):
    """Monitor log file for new entries (like tail -f)."""
    with open(log_file, 'r') as f:
        # Go to end of file
        f.seek(0, 2)

        while True:
            line = f.readline()

            if line:
                if keyword is None or keyword in line:
                    print(line.strip())
            else:
                time.sleep(0.1)  # Wait a bit before checking again

# Usage:
# tail_log("/var/log/syslog", keyword="ERROR")
```

#### 5. Batch rename files

```python
from pathlib import Path

def batch_rename(directory, old_pattern, new_pattern):
    """Replace pattern in all filenames."""
    for file in Path(directory).iterdir():
        if old_pattern in file.name:
            new_name = file.name.replace(old_pattern, new_pattern)
            new_path = file.parent / new_name

            print(f"{file.name} -> {new_name}")
            file.rename(new_path)

# Example: Change all "draft" to "final"
# batch_rename("/home/nigel/Documents", "draft", "final")
```

---

### Where to Learn More

#### Official Documentation
- Python Tutorial: https://docs.python.org/3/tutorial/
- Python Standard Library: https://docs.python.org/3/library/

#### For Scripting Specifically
- "Automate the Boring Stuff with Python" (free online book)
- Real Python tutorials: https://realpython.com

#### Practice
- Write small scripts for your daily tasks
- Every time you do something manually, ask: "Could I script this?"
- Start simple, add features as you learn

---

### The Python Prayer for Linux Sysadmins

> "Lord, thank You for Guido van Rossum who gave us Python. Thank You for readable code, automatic memory management, and not having to compile. Thank You for the standard library that has everything I need to automate my life. Grant me wisdom to write clear scripts, patience to debug when I inevitably get the indentation wrong, and the discipline to add proper error handling. May my automation be robust, my code be maintainable, and my scripts save me hours of manual work. And when I'm tempted to write a bash script with 47 nested if statements, remind me that Python exists. Amen."

---

### The Rubber Meets the Road

**You now know enough Python to**:
- Write the MP3 renaming script we used earlier
- Automate file operations
- Process text files
- Build system administration scripts
- Navigate directories and manipulate paths
- Handle errors gracefully
- Write clean, readable code

**The path forward**:
1. Type out the examples (don't just read them)
2. Modify them to do something slightly different
3. Write small scripts for real tasks you face
4. Read error messages carefully—they tell you exactly what's wrong
5. When stuck, break the problem into smaller pieces
6. Use print statements to debug
7. Read the documentation for modules you use

**The secret**: Programming is not about memorizing syntax. It's about:
- Breaking problems into steps
- Knowing what's possible
- Reading documentation
- Experimenting until it works

You have the foundation. Now build.

---

## Coming Next...

Future mysteries to unlock:
- How does Linux actually boot? (GRUB, kernel, init, systemd)
- What ARE processes and threads?
- How do databases actually work?
- What's version control and why Git?
- How do package managers work behind the scenes?

---

*This document grows with each new understanding. The cathedral of computing reveals itself, one layer at a time.*