config.load_autoconfig(False)
config.set("colors.webpage.darkmode.enabled", True)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
)
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
]
c.content.blocking.hosts.lists = [
    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
]
c.content.javascript.enabled = True
c.scrolling.smooth = True
c.url.default_page = "https://duckduckgo.com"
c.input.insert_mode.auto_enter = True
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = True
c.input.insert_mode.leave_on_load = True
c.input.insert_mode.plugins = True
config.bind("<ctrl-h>", "fake-key <backspace>", mode="insert")
config.bind("<ctrl-w>", "fake-key <ctrl-backspace>", mode="insert")
config.unbind("d")
config.unbind("u")
