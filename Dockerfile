FROM fedora:40

RUN dnf install -y \
        findutils \
        gcc \
        gcc-c++ \
        linkchecker \
        make \
        redhat-rpm-config \
        ruby-devel \
        rubygem-asciidoctor \
        rubygem-bundler && \
    dnf groupinstall -y development-tools && \
    gem install \
        asciidoctor-tabs:1.0.0.beta.6 \
        ffi:1.16.3 \
        nokogiri:1.16.5 \
        racc:1.8.0 \
        rb-fsevent:0.11.2 \
        rb-inotify:0.10.1 \
        sass-listen:4.0.0 \
        sass:3.7.4

WORKDIR /foreman-documentation/guides
