import tkinter as tk
from tkinter import messagebox, filedialog
import requests
import time
import threading
from urllib.parse import urlparse
import os

class WebDownloaderApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Web Downloader")
        self.root.geometry("550x300")
        self.root.resizable(False, False)
        
        # Center window on screen
        self.root.update_idletasks()
        x = (self.root.winfo_screenwidth() // 2) - (self.root.winfo_width() // 2)
        y = (self.root.winfo_screenheight() // 2) - (self.root.winfo_height() // 2)
        self.root.geometry(f"+{x}+{y}")
        
        # Main frame
        main_frame = tk.Frame(root, bg="#f0f0f0", padx=20, pady=20)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Title
        title_label = tk.Label(main_frame, text="Web Downloader", font=("Arial", 16, "bold"), bg="#f0f0f0")
        title_label.pack(pady=(0, 20))
        
        # URL Input Section
        url_label = tk.Label(main_frame, text="Enter Website URL:", font=("Arial", 11), bg="#f0f0f0")
        url_label.pack(anchor=tk.W, pady=(0, 5))
        
        self.url_entry = tk.Entry(main_frame, width=50, font=("Arial", 11))
        self.url_entry.pack(fill=tk.X, pady=(0, 15), ipady=5)
        self.url_entry.insert(0, "https://example.com")
        
        # Output directory Section
        output_label = tk.Label(main_frame, text="Save Location:", font=("Arial", 11), bg="#f0f0f0")
        output_label.pack(anchor=tk.W, pady=(0, 5))
        
        output_subframe = tk.Frame(main_frame, bg="#f0f0f0")
        output_subframe.pack(fill=tk.X, pady=(0, 15))
        
        self.output_path = tk.StringVar()
        self.output_path.set(os.path.expanduser("~/Downloads"))
        
        self.output_entry = tk.Entry(output_subframe, textvariable=self.output_path, state="readonly", width=35, font=("Arial", 10))
        self.output_entry.pack(side=tk.LEFT, padx=(0, 5), ipady=3)
        
        browse_btn = tk.Button(output_subframe, text="Browse", command=self.select_directory, bg="#e0e0e0", font=("Arial", 10), padx=10)
        browse_btn.pack(side=tk.LEFT)
        
        # Status label
        self.status_label = tk.Label(main_frame, text="Ready", font=("Arial", 10), bg="#f0f0f0", fg="blue")
        self.status_label.pack(fill=tk.X, pady=(0, 15))
        
        # Progress bar - simple canvas
        self.progress = tk.Canvas(main_frame, height=20, bg="#e0e0e0", highlightthickness=0)
        self.progress.pack(fill=tk.X, pady=(0, 20))
        
        # Buttons frame
        button_frame = tk.Frame(main_frame, bg="#f0f0f0")
        button_frame.pack(fill=tk.X)
        
        # START BUTTON - Large and prominent
        self.download_btn = tk.Button(
            button_frame, 
            text="START DOWNLOAD", 
            command=self.start_download,
            bg="#4CAF50",
            fg="white",
            font=("Arial", 12, "bold"),
            padx=20,
            pady=10,
            relief=tk.RAISED,
            bd=2,
            cursor="hand2",
            activebackground="#45a049"
        )
        self.download_btn.pack(side=tk.LEFT, padx=(0, 10))
        
        # Clear button
        clear_btn = tk.Button(
            button_frame, 
            text="Clear", 
            command=self.clear_fields,
            bg="#f0f0f0",
            font=("Arial", 11),
            padx=15,
            pady=8,
            relief=tk.RAISED,
            bd=1,
            cursor="hand2"
        )
        clear_btn.pack(side=tk.LEFT)
    
    def select_directory(self):
        directory = filedialog.askdirectory(title="Select Output Directory")
        if directory:
            self.output_path.set(directory)
    
    def clear_fields(self):
        self.url_entry.delete(0, tk.END)
        self.url_entry.insert(0, "https://example.com")
        self.status_label.config(text="Ready", fg="blue")
        self.progress.delete("all")
    
    def get_filename_from_url(self, url):
        try:
            parsed = urlparse(url)
            domain = parsed.netloc.replace("www.", "")
            domain = domain.split('.')[0]
            return domain
        except:
            return "downloaded_website"
    
    def download_website(self, url, output_dir):
        try:
            print(f"[DEBUG] Starting download of {url}")
            self.status_label.config(text="Validating URL...", fg="orange")
            self.root.update()
            
            if not url.startswith(('http://', 'https://')):
                url = 'https://' + url
            
            print(f"[DEBUG] Connecting to {url}")
            self.status_label.config(text="Connecting to site...", fg="orange")
            self.root.update()
            
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
            }
            response = requests.get(url, headers=headers, timeout=15)
            response.raise_for_status()
            
            print("[DEBUG] Download complete, waiting 10 seconds...")
            self.status_label.config(text="Waiting 10 seconds...", fg="orange")
            self.root.update()
            
            for i in range(10):
                time.sleep(1)
                remaining = 10 - i - 1
                self.status_label.config(text=f"Waiting {remaining} seconds...", fg="orange")
                self.progress.delete("all")
                self.progress.create_rectangle(0, 0, (i+1)*50, 20, fill="#4CAF50")
                self.root.update()
            
            print("[DEBUG] Saving file...")
            self.status_label.config(text="Saving file...", fg="orange")
            self.root.update()
            
            filename = self.get_filename_from_url(url)
            filepath = os.path.join(output_dir, f"{filename}.html")
            
            counter = 1
            base_filepath = filepath
            while os.path.exists(filepath):
                filepath = base_filepath.replace(".html", f"_{counter}.html")
                counter += 1
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(response.text)
            
            print(f"[DEBUG] File saved to {filepath}")
            saved_filename = os.path.basename(filepath)
            self.status_label.config(text=f"✓ Success! {saved_filename}", fg="green")
            messagebox.showinfo("Success", f"Downloaded successfully!\n\nFile: {saved_filename}\nLocation: {output_dir}")
            
        except Exception as e:
            print(f"[DEBUG] Error: {e}")
            self.status_label.config(text=f"Error: {str(e)[:50]}", fg="red")
            messagebox.showerror("Error", f"Error:\n\n{str(e)}")
        finally:
            self.download_btn.config(state="normal")
            self.progress.delete("all")
    
    def start_download(self):
        print("[DEBUG] >>> START DOWNLOAD BUTTON CLICKED <<<")
        url = self.url_entry.get().strip()
        output_dir = self.output_path.get()
        
        print(f"[DEBUG] URL: '{url}'")
        print(f"[DEBUG] Output: '{output_dir}'")
        
        if not url or url == "https://example.com":
            print("[DEBUG] URL validation failed - using default")
            messagebox.showwarning("Warning", "Please enter a different website URL!")
            return
        
        if not os.path.exists(output_dir):
            print(f"[DEBUG] Directory doesn't exist: {output_dir}")
            messagebox.showerror("Error", f"Directory doesn't exist:\n{output_dir}")
            return
        
        print("[DEBUG] Validation passed - starting download thread")
        self.download_btn.config(state="disabled")
        
        thread = threading.Thread(target=self.download_website, args=(url, output_dir), daemon=True)
        thread.start()
        print("[DEBUG] Thread started")


if __name__ == "__main__":
    root = tk.Tk()
    app = WebDownloaderApp(root)
    root.mainloop()
