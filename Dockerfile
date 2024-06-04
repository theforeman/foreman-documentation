FROM fedora:40

RUN dnf install -y \
        findutils \
        gcc \
        gcc-c++ \
        linkchecker \
        make \
        redhat-rpm-config \
        ruby-devel \
        rubygem-asciidoctor && \
    dnf groupinstall -y development-tools && \
    gem install \
        ffi:1.16.3 \
        nokogiri \
        rb-inotify:0.10.1 \
        sass

WORKDIR /foreman-documentation/guides
