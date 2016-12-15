#
# init.sh - initialize script for AWS EC2 instance, amazon linux
#

# update yum and install packages
sudo yum update -y && sudo yum install -y curl gcc openssl-devel readline-devel zlib-devel zsh git nano tmux nginx

# setup timezone
echo -e 'ZONE="Asia/Tokyo"\nUTC=false' | sudo tee /etc/sysconfig/clock
sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# setup language
echo "LANG=ja_JP.UTF-8" | sudo tee /etc/sysconfig/i18n

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


# interactive setup

cat << EOS
Automatic configuration done. Your next step is:

- setup root

$ sudo useradd <admin name>
$ sudo su <admin name>
$ echo <ssh-publickey> $HOME/.ssh/authorized_keys
$ sudo visudo

Defaults timestamp_timeout = 3
<admin name>  ALL = (ALL) NOPASSWD: ALL, !/bin/su

$ echo 'SU_WHEEL_ONLY yes' | sudo tee -a /etc/login.defs
$ echo 'auth required /lib64/security/pam_wheel.so use_uid' | sudo tee -a /etc/pam.d/su

- erase ec2-user

$ sudo userdel -r ec2-user

- ssh login setup

$ sudo nano /etc/ssh/sshd_config

PermitRootLogin No
PasswordAuthentication no

- setup aws command

$ aws configure

AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [None]: ap-northeast-1
Default output format [None]: 

EOS