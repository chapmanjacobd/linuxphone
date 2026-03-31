function apkinstall --wraps='apk add'
    apk add $argv
    and echo $argv | string split ' ' >>~/.github/apk_installed
    sort -u -f ~/.github/apk_installed | sponge ~/.github/apk_installed
end
