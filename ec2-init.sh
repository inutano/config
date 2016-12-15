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

# path to config files
config_path="${HOME}/.config"
ohmyzsh_path="${HOME}/.oh-my-zsh"
nanoconfig_path="${HOME}/.nano"
rbenv_path="${HOME}/.rbenv"

# setup dotfiles
if [ ! -e "${config_path}" ]; then
  git clone https://github.com/inutano/config.git ${config_path}
  sh ${HOME}/.config/copy.sh
fi

# setup zsh
if [ ! -e "${ohmyzsh_path}" ]; then
  git clone https://github.com/inutano/oh-my-zsh.git ${ohmyzsh_path}
  cp ${HOME}/.oh-my-zsh/.zshrc ${HOME}
  source ${HOME}/.zshrc
fi

# setup nano
if [ ! -e "${nanoconfig_path}" ]; then
  git clone https://github.com/inutano/nanorc.git ${nanoconfig_path}
  cp ${HOME}/.nano/.nanorc ${HOME}
fi

# install ruby
if [ ! -e "${rbenv_path}" ]; then
  git clone https://github.com/rbenv/rbenv.git ${rbenv_path}
  git clone https://github.com/rbenv/ruby-build.git ${rbenv_path}/plugins/ruby-build
  rbenv install 2.3.0
  rbenv rehash
  rbenv global 2.3.0
  gem install bundler
fi


# interactive setup

cat << EOS
Automatic configuration done. Your next step is:

- setup root

$ sudo useradd <admin name>
$ sudo su <admin name>
$ echo <ssh-publickey> ${HOME}/.ssh/authorized_keys
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
