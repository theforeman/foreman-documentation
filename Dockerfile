FROM fedora:34

RUN dnf upgrade -y && \
    dnf install -y findutils \
                   linkchecker \
                   make \
                   rubygem-asciidoctor \
                   rubygem-asciidoctor-pdf

WORKDIR /foreman-documentation/guides
