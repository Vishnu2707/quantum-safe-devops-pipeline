FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential git cmake pkg-config autoconf automake libtool \
    libssl-dev zlib1g-dev wget curl openssh-client openssh-server ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# --- liboqs (use stable release tag) ---
RUN git clone https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && git checkout 0.10.1 && \
    mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DOQS_USE_OPENSSL=OFF .. && \
    make -j$(nproc) && make install


# --- OpenSSH (OQS fork: main branch, 2025 stable) ---
RUN git clone https://github.com/open-quantum-safe/openssh.git && \
    cd openssh && \
    autoreconf && ./configure --with-ldflags="-L/usr/local/lib" --with-cflags="-I/usr/local/include" && \
    make -j$(nproc) && make install


# --- SSHD setup ---
RUN mkdir -p /var/run/sshd /root/.ssh && \
    /usr/local/bin/ssh-keygen -t falcon512 -f /etc/ssh/ssh_host_falcon_key -N "" || true && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    echo 'root:root' | chpasswd

COPY ../../configs/sshd_config /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/local/sbin/sshd","-D","-e"]
