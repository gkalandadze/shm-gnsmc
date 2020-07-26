FROM ubuntu:16.04
LABEL maintainer "Giorgi Kalandadze <giorgi.kalandadze@iliauni.edu.ge>"

SHELL ["/bin/bash", "-c"]


# shm is dependencebis dayeneba
RUN apt-get update && apt-get install -y make libmotif-dev \
    libc6-dev tcsh xterm rlwrap \
    x11proto-core-dev x11proto-print-dev \
    x11proto-xext-dev libxt-dev libx11-dev \
    xutils-dev libxext-dev libxpm-dev \
    xfonts-100dpi xfonts-75dpi

# shm is 32bitiani dependencebis dayeneba
RUN dpkg --add-architecture i386 && apt update && \
    apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386

# google chromis da sachiro programebis dayeneba
RUN apt-get install -y \
    sudo \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpangox-1.0-0 \
    libpulse0 \
    libv4l-0 \
    fonts-symbola \
    --no-install-recommends \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /var/lib/apt/lists/*


RUN groupadd -r sysop && useradd -s /bin/bash -r -m -g sysop -G audio,video,sudo sysop \
    && mkdir -p /home/sysop/Downloads && chown -R sysop:sysop /home/sysop


RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


COPY local.conf /etc/fonts/local.conf


COPY sh64.tar.gz updateconf.bash /tmp/
COPY shm_install_docker.sh /home/sysop/

RUN chown sysop:sysop /tmp/sh64.tar.gz \
    /tmp/updateconf.bash /home/sysop/shm_install_docker.sh && \
    chmod +x /tmp/updateconf.bash /home/sysop/shm_install_docker.sh


USER sysop


WORKDIR /home/sysop


RUN /home/sysop/shm_install_docker.sh

