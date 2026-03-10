
import os
from supabase import create_client, Client

class StorageService:
    def __init__(self):
        self.url = os.getenv("SUPABASE_URL")
        self.key = os.getenv("SUPABASE_KEY")
        self.bucket = os.getenv("SUPABASE_BUCKET", "crop-images")
        
        if self.url and self.key:
            self.supabase: Client = create_client(self.url, self.key)
            print("STORAGE: Using Supabase Storage")
        else:
            self.supabase = None
            print("STORAGE: Using Local Storage (Images will not persist on Render restart)")

    async def upload_file(self, file_path: str, filename: str):
        if not self.supabase:
            return file_path # Already saved locally by upload.py
            
        try:
            with open(file_path, 'rb') as f:
                self.supabase.storage.from_(self.bucket).upload(
                    path=filename,
                    file=f.read(),
                    file_options={"content-type": "image/jpeg"}
                )
            
            # Return the public URL
            res = self.supabase.storage.from_(self.bucket).get_public_url(filename)
            print(f"STORAGE: Uploaded to Supabase: {res}")
            return res
        except Exception as e:
            print(f"STORAGE ERROR: {e}")
            return file_path # Fallback to local path

storage_service = StorageService()
