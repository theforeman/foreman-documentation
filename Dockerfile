FROM fedora:38

RUN dnf upgrade -y && \
    dnf install -y findutils \
                   gcc \
                   gcc-c++ \
                   linkchecker \
                   make \
                   redhat-rpm-config \
                   ruby-devel \
                   rubygem-asciidoctor \
                   rubygem-nokogiri && \
    dnf groupinstall -y development-tools && \
    gem install sass

WORKDIR /foreman-documentation/guides
