"""."""

import sys
from browser_use import Agent


def search_google(search_term):
    """."""
    task = "search"
    llm = None
    agent = Agent(task=task, llm=llm)
    search_url = f"https://www.google.com/search?q={search_term}"

    page = agent.get_next_action(search_url)
    links = page.find_all("a")

    result_urls = []
    for link in links:
        href = link.get_attribute("href")
        if href and "google.com" not in href:  # 不要なGoogle内部リンクを除外
            result_urls.append(href)

    agent.close()
    return result_urls


if __name__ == "__main__":
    keyword = sys.argv[1]
    urls = search_google(keyword)  # Pass the global 'keyword' to the function

    # URLを標準出力に出力
    for url in urls:
        print(url)
