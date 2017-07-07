FROM rajivmr/workspace-rust-base:latest

CMD ["/sbin/my_init"]

COPY [ \
  "./docker-extras/home-ll-user-.gitconfig", \
  "./docker-extras/home-ll-user-.spacemacs", \
  "./docker-extras/home-ll-user-.zshrc", \
  "/tmp/docker-build/" \
]

RUN \
  # yum
  yum update && \
  yum install aspell && \
  yum install aspell-en && \
  yum install diffutils && \
  yum install file && \
  yum install git && \
  yum install less && \
  yum install patch && \
  yum install procps && \
  yum install tree && \
  yum install vim && \
  yum install which && \
  yum install zsh && \
  \
  # setup oh-my-zsh
  su -l ll-user -c "git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh" && \
  su -l ll-user -c "cp /tmp/docker-build/home-ll-user-.zshrc ~/.zshrc" && \
  \
  # setup epll repository
  curl -X GET -o /tmp/docker-build/RPM-GPG-KEY-lambda-epll https://lambda-linux.io/RPM-GPG-KEY-lambda-epll && \
  rpm --import /tmp/docker-build/RPM-GPG-KEY-lambda-epll && \
  curl -X GET -o /tmp/docker-build/epll-release-2017.03-1.2.ll1.noarch.rpm https://lambda-linux.io/epll-release-2017.03-1.2.ll1.noarch.rpm && \
  yum install /tmp/docker-build/epll-release-2017.03-1.2.ll1.noarch.rpm && \
  \
  # install colordiff
  yum --enablerepo=epll install colordiff && \
  \
  # install stgit
  su -l ll-user -c "cp /tmp/docker-build/home-ll-user-.gitconfig ~/.gitconfig" && \
  yum --enablerepo=epll install stgit && \
  \
  # install emacs, spacemacs
  su -l ll-user -c "cp /tmp/docker-build/home-ll-user-.spacemacs ~/.spacemacs" && \
  su -l ll-user -c "git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d" && \
  yum --enablerepo=epll install emacs24 && \
  su -l ll-user -c "SHELL=/bin/zsh emacs -nw -batch -u '${UNAME}' -q -kill" && \
  \
  # cleanup
  rm -rf /tmp/docker-build && \
  yum clean all && \
  rm -rf /var/cache/yum/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*
