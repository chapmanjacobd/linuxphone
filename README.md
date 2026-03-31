# phone
Phoneware for postmarketOS Gnome Mobile

## Installation

```sh
# Update system
sudo apk update
sudo apk upgrade

# Install git
sudo apk add git

cd $HOME
git clone --no-checkout https://github.com/chapmanjacobd/linuxphone
mv linuxphone/.git/ .
git reset HEAD --hard  # mi casa, su casa? sin casa: this will delete everything in your home folder
bash setup.sh
```
