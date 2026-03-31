# Defined via `source`
function sorted
    if isatty stdin
        sort -u -s -f $argv | sponge $argv
    else
        cat - | string trim | sort -u -s -f | strip
    end
end
