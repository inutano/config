# .zshenv
export PATH=$HOME/local/bin:/opt/local/bin:/usr/local/bin:/usr/X11R6/bin:/usr/bin:/bin:/opt:local/sbin:/usr/local/sbin:/usr/sbin:/sbin
export MANPATH=$HOME/local/man:/opt/local/man:/usr/local/man:/usr/share/man:/usr/X11R6/man
export BAM_ROOT=$HOME/local/include/bam

export LANG=ja_JP.UTF-8
export LC_ALL="$LANG"
export EDITOR=nano
export LS_COLORS='no=0:fi=37:di=32:ln=33:ex=35'
export C_INCLUDE_PATH=/opt/local/include:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/opt/local/include:$CPLUS_INCLUDE_PATH

# (I never use perl, but) for CPAN
export PATH=$HOME/local/perl/current/bin:$PATH
export MANPATH=$HOME/local/perl/current/man:$MANPATH
export PERL5LIB=$HOME/local/perl/current/lib/perl5:/System/Library/Perl/Extras/5.8.8:$PERL5LIB

# for RVM
if [[ -s /Users/iNut/.rvm/scripts/rvm ]] ; then source /Users/iNut/.rvm/scripts/rvm ; fi

# for gisty
export GISTY_DIR="$HOME/togofarm/gist"
