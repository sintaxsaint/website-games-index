import requests
import time
import os

url = "https://storage.googleapis.com/web1-11a/run3/index.html"
output_path = r"G:\My Drive\unblocked games\website-games-index\games\run3\index.html"

print("Starting download of Run 3...")
print(f"URL: {url}")
print(f"Output: {output_path}")

try:
    print("Waiting 2 seconds for page to load...")
    time.sleep(2)
    
    print("Downloading...")
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
    }
    response = requests.get(url, headers=headers, timeout=30)
    response.raise_for_status()
    
    print("Saving file...")
    # Ensure directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(response.text)
    
    print(f"✓ SUCCESS! Downloaded to: {output_path}")
    print(f"File size: {len(response.text)} bytes")
    
except Exception as e:
    print(f"✗ ERROR: {e}")
