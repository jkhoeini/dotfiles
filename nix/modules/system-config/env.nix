{ ... }:
{
  environment.variables = {
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
    PUPPETEER_EXECUTABLE_PATH = "`which chromium`";
    EDITOR = "ec";
    LUA_PATH = "/opt/homebrew/Cellar/luarocks/3.12.2/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;/opt/homebrew/lib/lua/5.4/?.lua;/opt/homebrew/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;$HOME/.luarocks/share/lua/5.4/?.lua;$HOME/.luarocks/share/lua/5.4/?/init.lua";
    LUA_CPATH = "/opt/homebrew/lib/lua/5.4/?.so;/opt/homebrew/lib/lua/5.4/loadall.so;./?.so;$HOME/.luarocks/lib/lua/5.4/?.so";
    # help cursor-ide detect command is finished
    PROMPT_EOL_MARK = "“”";
    GEMINI_API_KEY = "$(security find-generic-password -a $USER -s GEMINI_API_KEY -w)";
  };
}
