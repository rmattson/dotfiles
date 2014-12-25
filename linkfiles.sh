NOW=$(date +"%y_%m_%d")

files=(
    "bash_profile"
    "bashrc"
    "vimrc"
    "tmux.conf"
)

for file in "${files[@]}"
do
    :
    if [ -e ~/.$file ]; then
        # rename the file if it exists
        mv ~/.$file ~/.$file.backup.$NOW
    fi
    # symlink the repo files to home
    ln -s $PWD/$file ~/.$file
done
