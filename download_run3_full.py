import requests
import time
import os
from urllib.parse import urljoin, urlparse
from bs4 import BeautifulSoup

base_url = "https://storage.googleapis.com/web1-11a/run3/"
output_dir = r"G:\My Drive\unblocked games\website-games-index\games\run3"

print("Starting complete Run 3 download...")
print(f"Base URL: {base_url}")
print(f"Output: {output_dir}")

# Clear old files except .git
print("\nCleaning old files...")
for root, dirs, files in os.walk(output_dir):
    # Skip .git folder
    dirs[:] = [d for d in dirs if d != '.git']
    for file in files:
        if not file.startswith('.'):
            try:
                os.remove(os.path.join(root, file))
            except:
                pass

downloaded_files = set()
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}

def download_file(url, local_path):
    """Download a single file"""
    if url in downloaded_files:
        return
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            os.makedirs(os.path.dirname(local_path), exist_ok=True)
            with open(local_path, 'wb') as f:
                f.write(response.content)
            print(f"✓ Downloaded: {os.path.basename(local_path)}")
            downloaded_files.add(url)
            return True
    except Exception as e:
        print(f"✗ Failed to download {url}: {e}")
    return False

print("\nWaiting 3 seconds for page to load...")
time.sleep(3)

print("Downloading main HTML...")
main_html_url = base_url + "index.html"
main_html_path = os.path.join(output_dir, "index.html")
download_file(main_html_url, main_html_path)

print("\nParsing HTML to find resources...")
time.sleep(1)

try:
    response = requests.get(main_html_url, headers=headers, timeout=10)
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Find all script tags
    print("\nDownloading scripts...")
    for script in soup.find_all('script', src=True):
        src = script['src']
        script_url = urljoin(base_url, src)
        script_path = os.path.join(output_dir, src.lstrip('/'))
        download_file(script_url, script_path)
        time.sleep(0.1)
    
    # Find all link tags (CSS, etc)
    print("\nDownloading stylesheets...")
    for link in soup.find_all('link', href=True):
        href = link['href']
        link_url = urljoin(base_url, href)
        link_path = os.path.join(output_dir, href.lstrip('/'))
        download_file(link_url, link_path)
        time.sleep(0.1)
    
    # Find all img tags
    print("\nDownloading images...")
    for img in soup.find_all('img', src=True):
        src = img['src']
        img_url = urljoin(base_url, src)
        img_path = os.path.join(output_dir, src.lstrip('/'))
        download_file(img_url, img_path)
        time.sleep(0.1)
    
except Exception as e:
    print(f"Error parsing HTML: {e}")

# Try to download common directories
print("\nDownloading common resource directories...")
common_dirs = ['img', 'images', 'js', 'css', 'assets', 'font', 'fonts', 'audio', 'music', 'model', 'text']

for dir_name in common_dirs:
    print(f"\nTrying to download {dir_name}/ directory...")
    try:
        # Try to list directory (may not work with Google Storage)
        list_url = base_url + f"{dir_name}/"
        response = requests.get(list_url, headers=headers, timeout=5)
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser')
            # Look for links to files
            for link in soup.find_all('a', href=True):
                file_url = link['href']
                if not file_url.startswith('/'):
                    full_url = urljoin(list_url, file_url)
                    file_path = os.path.join(output_dir, dir_name, file_url)
                    download_file(full_url, file_path)
                    time.sleep(0.05)
    except:
        pass

print(f"\n✓ Download complete!")
print(f"Total files downloaded: {len(downloaded_files)}")
