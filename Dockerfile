FROM quay.io/fedora/fedora:42

# hadolint ignore=DL3041
RUN dnf group install -y development-tools && \
    dnf install -y \
        gcc-c++ \
        linkchecker \
        redhat-rpm-config \
        ruby-devel \
        rubygem-bundler && \
    dnf clean all && \
    rm -fr /var/cache/dnf && \
    gem install \
        asciidoctor-tabs:1.0.0.beta.6 \
        ffi:1.17.2 \
        nokogiri:1.18.10 \
        racc:1.8.1 \
        rb-fsevent:0.11.2 \
        rb-inotify:0.11.1 \
        sass-listen:4.0.0 \
        sass:3.7.4 && \
    asciidoctor --version

WORKDIR /foreman-documentation/guides
