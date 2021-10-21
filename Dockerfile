FROM fedora:34

RUN dnf upgrade -y && \
    dnf install -y findutils \
                   gcc \
                   gcc-c++ \
                   linkchecker \
                   make \
                   redhat-rpm-config \
                   ruby-devel \
                   rubygem-asciidoctor \
                   rubygem-asciidoctor-pdf && \
    dnf groupinstall -y development-tools

RUN gem install compass:0.12.7 \
                zurb-foundation:4.3.2

WORKDIR /foreman-documentation/guides
