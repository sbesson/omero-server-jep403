FROM ubuntu:22.04

# Base dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt -y install \
    git \
    openjdk-11-jdk \
    wget \
    unzip

# Ice dependencies
RUN apt install -y openssl libdb5.3++
RUN cd /tmp && \
    wget -q https://github.com/glencoesoftware/zeroc-ice-ubuntu2204-x86_64/releases/download/20221004/Ice-3.6.5-ubuntu2204-x86_64.tar.gz && \
    tar xf Ice-3.6.5-ubuntu2204-x86_64.tar.gz && \
    mv Ice-3.6.5 /opt/ice-3.6.5 && \
    echo /opt/ice-3.6.5/lib64 > /etc/ld.so.conf.d/ice-x86_64.conf && \
    ldconfig

# PSQL client dependencies
RUN apt -y install postgresql

# Python dependencies
RUN apt -y install python3-venv

RUN useradd -r -c "OMERO user" -d /opt/omero -m omero
RUN mkdir -p /OMERO
RUN chown omero:omero /OMERO

USER omero
WORKDIR /opt/omero
RUN wget https://github.com/ome/openmicroscopy/releases/download/v5.6.10/OMERO.server-5.6.10-ice36.zip && \
  unzip OMERO.server-5.6.10-ice36.zip && rm OMERO.server-5.6.10-ice36.zip
RUN ln -sf OMERO.server-5.6.10-ice36 OMERO.current
RUN python3 -mvenv OMERO.venv && OMERO.venv/bin/pip install -U pip wheel
RUN OMERO.venv/bin/pip install https://github.com/glencoesoftware/zeroc-ice-py-ubuntu2204-x86_64/releases/download/20221004/zeroc_ice-3.6.5-cp310-cp310-linux_x86_64.whl
RUN OMERO.venv/bin/pip install \
    click \
    omero-py \
    omero-certificates

ENV OMERODIR /opt/omero/OMERO.current
ENV PATH "/opt/ice-3.6.5/bin:$PATH"
EXPOSE 4063 4064

ADD init.sh /opt/omero/
ADD connect.py /opt/omero/
