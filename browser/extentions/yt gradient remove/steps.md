### 📂 **Step-by-Step to Create and Load Your Extension:**

1. **Create the Directory Structure:**

   ```bash
   ├── ytex/
       ├── content.js
       └── manifest.json
   ```

2. **Inside `manifest.json`**  
   Here’s the manifest to define your extension.

   ```json
   {
     "manifest_version": 3,
     "name": "No More YouTube Gradients",
     "version": "1.0",
     "description": "Deletes top and bottom gradients on YouTube.",
     "content_scripts": [
       {
         "matches": ["*://www.youtube.com/*"],
         "js": ["content.js"],
         "run_at": "document_idle"
       }
     ],
     "permissions": ["scripting"]
   }
   ```

3. **Inside `content.js`**  
   The magic JavaScript that removes the gradients.

   ```js
   function removeGradients() {
     const top = document.querySelector('.ytp-gradient-top');
     const bottom = document.querySelector('.ytp-gradient-bottom');
     if (top) top.remove();
     if (bottom) bottom.remove();
   }

   // Run the function once and observe DOM changes
   removeGradients();
   const observer = new MutationObserver(removeGradients);
   observer.observe(document.body, { childList: true, subtree: true });
   ```

---

### 🖥 **How to Load Your Extension:**

1. **Go to Extensions Page:**

   - For **Chrome**: `chrome://extensions/`
   - For **Edge**: `edge://extensions/`

2. **Enable Developer Mode**  
   Toggle the **Developer mode** switch in the top right corner to **ON**.

3. **Click "Load Unpacked"**  
   - Hit the **"Load unpacked"** button.

4. **Select Your Extension Folder**  
   Choose the `ytex` folder where `content.js` and `manifest.json` are located.

5. **Reload or Refresh the Page**  
   If it's not working immediately, **reload the page**. 

6. **Restart the Browser**  
   If it still doesn’t work, **restart the browser** for good measure. 🌀
