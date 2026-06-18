# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

ZSH_DISABLE_COMPFIX=true

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/jasperhuang/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# -------------------------------- Shortcuts --------------------------------

# # ---- Opens PhpStorm
# function phpstorm {
#   if [ $# -eq 0 ]; then
#     echo "=> Opening current directory in PhpStorm..."
#     open -na "/Applications/PhpStorm.app" --args "."
#   else 
#     echo "=> Opening ${1} in PhpStorm..."
#     open -na "/Applications/PhpStorm.app" --args "${1}"
#   fi
# }

# function androidstudio {
#   if [ $# -eq 0 ]; then
#     echo "=> Opening current directory in Android Studio..."
#     open -na "/Applications/Android\ Studio.app" --args "."
#   else 
#     echo "=> Opening ${1} in Android Studio..."
#     open -na "/Applications/Android\ Studio.app" --args "${1}"
#   fi
# }

# function xcode {
#   if [ $# -eq 0 ]; then
#     echo "=> Opening current directory in Xcode..."
#     open -na "/Applications/Xcode.app" --args "."
#   else 
#     echo "=> Opening ${1} in Xcode..."
#     open -na "/Applications/Xcode.app" --args "${1}"
#   fi
# }

# function clion {
#   if [ $# -eq 0 ]; then
#     echo "=> Opening current directory in CLion..."
#     open -na "/Applications/CLion.app" --args "."
#   else 
#     echo "=> Opening ${1} in CLion..."
#     open -na "/Applications/CLion.app" --args "${1}"
#   fi
# }

function mainBranch() {
     git branch | grep -q " master" && echo master || echo main
}

function revertPR {
    cd ~/Expensidev/App
    echo "Fetching merge commit for ${1}..."
    MERGE_COMMIT=`gh pr view ${1} --json mergeCommit -q .mergeCommit.oid`
    echo "=> Got merge commit: $MERGE_COMMIT"
    git checkout staging && git reset --hard origin/staging && git revert "$MERGE_COMMIT" -m 1
}

# function gicof {
#   parts=("${(@s/:/)${1}}")
#   contributorUsername=${parts[@]:0:1}
#   branchName=${parts[@]:1:1}

#   echo "=> Checking out ${branchName} from ${contributorUsername}'s fork of Expensify.cash..."

#   cash && gico main
#   git remote add ${contributorUsername} git@github.com:${contributorUsername}/Expensify.cash.git
#   git fetch ${contributorUsername} && git checkout -b ${contributorUsername}-${branchName} ${contributorUsername}/${branchName}
# }

# ---- git
function gia {
  if [ $# -eq 0 ]; then
    git add .
  else
    git add "${1}"
  fi
}
alias gic="git commit -v"
alias gip="git push"
alias gis="git status"
alias gico="git checkout"
alias gicom="echo '\n=> Checking out main branch...\n' && git checkout $(mainBranch)"
alias gicob="git checkout -b"
alias gibr="git branch"
alias giplom="echo '\n=> Pulling from origin/$(mainBranch)...\n' && git pull origin $(mainBranch)"
alias girbm="git rebase $(mainBranch)"
alias gicomf="git checkout origin/main -- "
alias girhard="git reset --hard"
alias girsoft="git reset --soft HEAD~1"

# same as git add * && git commit -m "<message>" && git push
function giacp {
if [ $# -eq 0 ]; then
    echo "=> Please provide a commit message"
  else 
    git add * && git commit -m "${1}" && git push
  fi
}

# ---- nav
alias web="cd ~/Expensidev/Web-Expensify"
alias mobile="cd ~/Expensidev/Mobile-Expensify"
alias secure="cd ~/Expensidev/Web-Secure"
alias cash="cd ~/Expensidev/Expensify.cash"
alias app="cd ~/Expensidev/App"
alias salt="cd ~/Expensidev/Salt"
alias auth="cd ~/Expensidev/Auth"
alias bedrock="cd ~/Expensidev/Bedrock"
alias bedrockphp="cd ~/Expensidev/Bedrock-PHP"
alias scrapers="cd ~/Expensidev/Server-Scraper"
alias static="cd ~/Expensidev/Web-Static"
alias IS="cd ~/Expensidev/Integration-Server"
alias comp="cd ~/Expensidev/Comp"
alias cdc="cd ~/Expensidev"
alias isl="cd ~/Documents/ISL"

# ---- dev workflow
alias gruntwatch="web && vssh ../script/grunt.sh --watch"
alias hosts="code /etc/hosts"
# alias ps="phpstorm"
alias fixbedrock="vssh \"sudo sqlite3 /tmp/localJobsDB.sql 'delete from localjobs;'\""
alias updateAndMake="~/Expensidev/script/updateRepos.sh && ~/Expensidev/script/makeAll.sh --clean && ~/Expensidev/script/makeAll.sh && vssh sudo service bedrock restart && vssh sudo service auth restart"
alias fixBankImport="vssh cd /tmp/www-cache; sudo curl -o newbanklist.json https://www.expensify.com/_utilities/banklist/bankListCache.php; (sudo grep -q banklist newbanklist.json && sudo mv newbanklist.json banklist.json) || sudo rm newbanklist.json"
alias ngrokstart="cdc && ./script/ngrok.sh jasper"
alias notifyall="web && vssh php ./script/notifyall.php"
alias vmlogs="~/Expensidev/script/tail.sh"
alias cleanmakeauth="auth && vssh make clean && vssh time ./make.sh -j10 && vssh printf '\a' && vssh sudo service auth restart && vssh sudo service auth status"
alias makeauth="auth && vssh time ./make.sh -j10 && vssh printf '\a' && vssh sudo service auth restart && vssh sudo service auth status"
alias compdb="comp && sqlite3 data/comp.db"
alias androidemulator="mobile && ./tools/android-emulator-setup.sh"
alias appinstall="app && nvm i && npm i"
alias emulatorlocalhost="echo 'HTTP://10.0.2.2:8080'"
alias validatetestaccounts="cdc && ./script/clitools.sh validator:account"
alias ioscerts="xcrun simctl keychain booted add-root-cert ~/Expensidev/config/ssl/rootCA.crt && xcrun simctl keychain booted add-cert ~/Expensidev/config/ssl/expensify.com.dev.pem"
alias fab="fab -u jasper"
alias phpTests="web && ~/Expensidev/script/phpTests.sh"
alias fixPHP="~/Expensidev/script/fixPHP.sh"
alias fixphp="fixPHP"
alias sshaj="saltfab && ssh -A -J bastion1.sjc"
alias buildis="IS && vssh mvn -DskipTests package"
alias fixsshkey="ssh-add --apple-use-keychain ~/.ssh/id_ed25519"
alias killbedrockprocesses="vssh sudo killall -9 bedrock && vssh sudo service auth start && vssh sudo service bedrock start"
alias openauthbedrock="cdc && code Auth-Bedrock.code-workspace"
alias updatepinecone="vssh sudo php /git/expensify.com/script/manual/SetupPineconeDatabase.php --docPath=../App/docs/articles/"
alias startapp="app && giplom && appinstall && npm run web"

# rbenv used for mobile development
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"


# React Native Android Env Setup
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/tools/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH=~/Library/Android/sdk/platform-tools:$PATH
source ~/powerlevel10k/powerlevel10k.zsh-theme
source /Users/jasperhuang/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=/usr/local/bin:$PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# llvm
export CC=/opt/homebrew/opt/llvm/bin/clang
export CXX=/opt/homebrew/opt/llvm/bin/clang++
export GPG_TTY=$(tty)
alias cursor-mem="open /Applications/Cursor.app --args --max-old-space-size=8192"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# Fix libclang.dylib resolution for iOS builds
export DYLD_LIBRARY_PATH="/usr/local/lib:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib:$DYLD_LIBRARY_PATH"
export LIBRARY_PATH="/usr/local/lib:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib:$LIBRARY_PATH"

export CA_CERT_PATH="${HOME}/Expensidev/Ops-Configs/src/saltfab/cacert.pem"

if [ -f "$CA_CERT_PATH" ]; then
    export NODE_EXTRA_CA_CERTS="$CA_CERT_PATH"
    export AWS_CA_BUNDLE="$CA_CERT_PATH"
    export SSL_CERT_FILE="$CA_CERT_PATH"
    export CURL_CA_BUNDLE="$CA_CERT_PATH"
    export BUNDLE_SSL_CA_CERT="$CA_CERT_PATH"
    export REQUESTS_CA_BUNDLE="$CA_CERT_PATH"
fi
