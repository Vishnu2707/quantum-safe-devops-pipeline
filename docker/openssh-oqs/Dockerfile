FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential git cmake pkg-config autoconf automake libtool \
    libssl-dev zlib1g-dev wget curl openssh-client openssh-server \
    ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DOQS_USE_OPENSSL=OFF .. && \
    make -j$(nproc) && make install

WORKDIR /opt
RUN git clone https://github.com/open-quantum-safe/openssh.git && \
    cd openssh && \
    autoreconf && ./configure --with-ldflags="-L/usr/local/lib" --with-cflags="-I/usr/local/include" && \
    make -j$(nproc) && make install

RUN mkdir -p /var/run/sshd /root/.ssh
RUN /usr/local/bin/ssh-keygen -t falcon512 -f /etc/ssh/ssh_host_falcon_key -N "" || true
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""

RUN printf "%s\n" \
    "Port 22" \
    "HostKey /etc/ssh/ssh_host_falcon_key" \
    "HostKey /etc/ssh/ssh_host_rsa_key" \
    "PubkeyAuthentication yes" \
    "PasswordAuthentication yes" \
    "PermitRootLogin yes" \
    "Subsystem sftp /usr/lib/openssh/sftp-server" \
    > /etc/ssh/sshd_config

RUN echo 'root:root' | chpasswd

EXPOSE 22
CMD ["/usr/local/sbin/sshd","-D","-e"]
