#
# init.sh - initialize script for AWS EC2 instance, amazon linux
#

# update yum and install packages
sudo yum update -y && sudo yum install -y curl zsh git nano tmux nginx

# setup dotfiles
git clone https://github.com/inutano/config.git $HOME/.config
sh $HOME/.config/copy.sh

# setup zsh
git clone https://github.com/inutano/oh-my-zsh.git $HOME/.oh-my-zsh
cp $HOME/.oh-my-zsh/.zshrc $HOME
source $HOME/.zshrc

# setup nano
git clone https://github.com/inutano/nanorc.git $HOME/.nano
cp $HOME/.nano/.nanorc $HOME

# install ruby
git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
rbenv install 2.3.0
rbenv rehash
gem install bundler