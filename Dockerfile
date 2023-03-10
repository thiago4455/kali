FROM kalilinux/kali-rolling:arm64
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt -y install wget iputils-ping git vim nano

WORKDIR /tmp
RUN wget https://go.dev/dl/go1.20.linux-arm64.tar.gz
RUN tar -C /usr/local -xzf go1.20.linux-arm64.tar.gz
RUN cp /usr/local/go/bin/go /usr/bin
ENV GOROOT="/usr/local/go"
ENV GOPATH="$HOME/go"
ENV PATH="$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH"

RUN go install -v github.com/OWASP/Amass/v3/...@master
COPY configs/amass.ini "$HOME/.config/amass/config.ini"
RUN GO111MODULE=on go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder...@master
COPY configs/subfinder_provider_config.yaml "$HOME/.config/subfinder/provider-config.yaml"
RUN go install github.com/tomnomnom/assetfinder/...@master
RUN go install -v github.com/tomnomnom/waybackurls/...@master
RUN go install github.com/lc/gau/v2/cmd/gau@latest
RUN go install github.com/ffuf/ffuf@latest

WORKDIR /work
ENV HISTFILE=/work/.bash_history
ENV TERM=xterm-256color