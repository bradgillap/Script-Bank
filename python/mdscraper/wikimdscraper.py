import requests
from bs4 import BeautifulSoup
import os
from urllib.parse import urljoin, urlparse

# Base URL of the wiki
BASE_URL = "https://"
START_PAGE = "/docs/index.html"
OUTPUT_DIR = "wiki_content"

# Set to track visited pages
visited_pages = set()

# Maximum recursion depth
MAX_DEPTH = 5

def save_content(url, depth=0):
    """Scrape and save content from a wiki page."""
    if url in visited_pages or depth > MAX_DEPTH:
        return  # Skip if already scraped or exceeded max depth

    print(f"Scraping: {url} (Depth: {depth})")
    visited_pages.add(url)

    response = requests.get(url)
    
    # Check if request was successful
    if response.status_code != 200:
        print(f"Failed to retrieve {url}: {response.status_code}")
        return

    # Ensure the response is HTML content
    if 'text/html' not in response.headers.get('Content-Type', ''):
        print(f"Skipping non-HTML content at {url}")
        return

    soup = BeautifulSoup(response.content, 'html.parser')

    # Extract page content
    content = soup.find('body', class_='article')
    if not content:
        print(f"Warning: No article content found on {url}")
        return

    # Generate a sanitized page name
    page_name = urlparse(url).path.strip('/').replace('/', '_')
    if not page_name:
        page_name = "index"  # Fallback for the main page

    page_dir = os.path.join(OUTPUT_DIR, page_name)
    os.makedirs(page_dir, exist_ok=True)

    # Save text content using the page name as the filename
    content_path = os.path.join(OUTPUT_DIR, f"{page_name}.md")
    if os.path.exists(content_path):
        print(f"Content for {url} already saved at {content_path}. Skipping.")
    else:
        # Save text content
        with open(content_path, 'w', encoding="utf-8") as f:
            f.write(content.get_text())

        # Download and update images
        images = content.find_all('img')
        for img in images:
            img_src = img.get('src')
            if not img_src:
                continue

            img_url = urljoin(url, img_src)  # Resolve relative path
            img_filename = os.path.basename(img_src)
            img_path = os.path.join(page_dir, img_filename)

            # Skip downloading image if already exists
            if os.path.exists(img_path):
                print(f"Image {img_filename} already downloaded at {img_path}. Skipping.")
                img['src'] = img_filename  # Update image source to local path
                continue  # Skip downloading this image

            # Download image
            try:
                img_data = requests.get(img_url).content
                with open(img_path, 'wb') as img_file:
                    img_file.write(img_data)
                img['src'] = img_filename  # Update image source to local path
            except Exception as e:
                print(f"Failed to download image {img_url}: {e}")

        # Save updated HTML as Markdown
        with open(content_path, 'w', encoding="utf-8") as f:
            f.write(str(content))

    # Find and crawl links
    links_to_scrape = []
    links = content.find_all('a', href=True)
    for link in links:
        next_page = urljoin(url, link['href'])  # Resolve relative path
        if BASE_URL in next_page and next_page not in visited_pages and not next_page.startswith('mailto:'):
            links_to_scrape.append(next_page)  # Add link to scrape later

    # Recursively scrape links
    for next_page in links_to_scrape:
        print(f"Adding link to scrape: {next_page}")
        save_content(next_page, depth + 1)  # Recursively scrape linked pages

def main():
    """Start scraping from the main page and follow links."""
    start_url = urljoin(BASE_URL, START_PAGE)
    save_content(start_url)

if __name__ == "__main__":
    main()
