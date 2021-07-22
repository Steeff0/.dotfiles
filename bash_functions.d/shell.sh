# Check if this is Windows.
function isWindows() { [[ -n "$WINDIR" ]]; }

# Cross-platform symlink function. It needs two parameters.
# It will create a symlink to a file or directory, with syntax:
# link $sourceLocation $symlinkLocation
function link() {
    source=$1
    symlink=$2
    if isWindows; then

        windowsSymlink=${symlink//\//\\}
        windowsSymlink=${windowsSymlink//\\c/c\:}
        windowsSource=${source//\//\\}
        windowsSource=${windowsSource//\\c/c\:}
        # Windows needs to be told if it's a directory or not. Infer that.
        # Also: note that we convert `/` to `\`. In this case it's necessary.
        if [[ -d "$source" ]]; then
            cmd <<< "mklink /D \"${windowsSymlink}\" \"${windowsSource}\"" > /dev/null
        else
            cmd <<< "mklink \"${windowsSymlink}\" \"${windowsSource}\"" > /dev/null
        fi
        source=$windowsSource
        symlink=$windowsSymlink
    else
        # You know what? I think ln's parameters are backwards.
        ln -s "$source" "$symlink"
    fi
    if [ $? -eq 0 ]; then
        echo "Created symlink: ${source} -> ${symlink}"
    else
        echo "Something went wrong, cannot create symlink: ${source} -> ${symlink}"
    fi
}
