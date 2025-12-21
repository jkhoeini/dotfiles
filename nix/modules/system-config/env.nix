{ ... }:
{
  environment.variables = rec {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_RUNTIME_DIR = "$TMPDIR";

    ANDROID_USER_HOME = "${XDG_DATA_HOME}/android";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    GEM_HOME = "${XDG_DATA_HOME}/gem";
    GEM_SPEC_CACHE = "${XDG_CACHE_HOME}/gem";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    LESSHISTFILE = "${XDG_STATE_HOME}/less/history";
    MINIKUBE_HOME = "${XDG_DATA_HOME}/minikube";
    TERMINFO = "${XDG_DATA_HOME}/terminfo";
    TERMINFO_DIRS = [ "${XDG_DATA_HOME}/terminfo" ];
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx";
    PKG_CACHE_PATH = "${XDG_CACHE_HOME}/pkg-cache";
    PSQL_HISTORY = "${XDG_DATA_HOME}/psql_history";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    SOLARGRAPH_CACHE = "${XDG_CACHE_HOME}/solargraph";

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
