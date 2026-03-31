function apkuninstall --wraps='apk del'
    for arg in $argv
        filterfile ~/.github/apk_installed $arg
    end
    apk del $argv
end
