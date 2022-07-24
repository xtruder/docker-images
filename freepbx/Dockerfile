#### Base Image ######################################################

ARG IMAGE_FROM=rockylinux/rockylinux:8
FROM ${IMAGE_FROM} AS base

## install epel repository and dnf plugins
RUN dnf -y install epel-release dnf-plugins-core

## Add rpmfusion repos (needed for ffmpeg)
RUN rpm -Uhv https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm && \
    rpm -Uhv https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm 

## Add centos OKay's additional repos (needed for lame command)
RUN rpm -Uhv http://repo.okay.com.mx/centos/8/x86_64/release/okay-release-1-5.el8.noarch.rpm

## enable extra repositories
RUN dnf config-manager --set-enabled \
    powertools \
    rpmfusion-free-updates \
    rpmfusion-nonfree-updates \
    okay

#### Builder image ######################################################

## docker layer that builds asterisk and its dependencies
FROM base AS builder

## install build dependencies
RUN dnf install -y \
    gcc-c++ \
    bzip2 \
    dmidecode \
    autoconf \
    automake \
    ncurses-devel \
    libxml2-devel \
    openssl-devel \
    newt-devel \
    kernel-devel \
    sqlite-devel \
    libuuid-devel \
    jansson-devel \
    binutils-devel \
    libedit-devel \
    svn \
    opus-devel \
    opusfile-devel \
    unixODBC-devel \
    ncurses-devel \
    libtermcap-devel \
    libtiff-devel \
    libjpeg-turbo-devel \
    audiofile-devel \
    uuid-devel \
    libtool-ltdl-devel \
    libsamplerate-devel \
    patch \
    libsndfile-devel \
    doxygen \
    bison \
    fftw-devel \
    flex \
    graphviz \
    libpq-devel \
    libxslt-devel \
    net-snmp-devel \
    unbound-devel \
    libcurl-devel \
    openldap-devel \
    popt-devel \
    bluez-libs-devel \
    gsm-devel \
    libsrtp-devel \
    libvorbis-devel \
    lua-devel \
    neon-devel \
    speex-devel \
    speexdsp-devel \
    codec2-devel \
    freetds-devel \
    portaudio-devel \
    radcli-devel \
    uriparser-devel \
    uw-imap-devel \
    xmlstarlet \
    sox-devel \
    ilbc-devel \
    python2-devel \
    python3-devel \
    libtool \
    cmake \
    libresample-devel \
    mariadb-devel \
    libuv-devel \
    libpcap \
    libpcap-devel


## build snapdsp (http://sources.buildroot.net/spandsp)
ARG SPANDSP_VER=3.0.0-6ec23e5a7e
WORKDIR /usr/src/spandsp
RUN curl -fSL --connect-timeout 30 http://sources.buildroot.net/spandsp/spandsp-${SPANDSP_VER}.tar.gz | tar xz --strip 1 -C . 
RUN ./configure --prefix=/usr && make && make install && ldconfig

## build iksemel (https://github.com/holme-r/iksemel)
ARG IKSEMEL_VER=1.5.1.3
WORKDIR /usr/src/iksemel
RUN curl -fSL --connect-timeout 30 https://github.com/holme-r/iksemel/archive/${IKSEMEL_VER}.tar.gz | tar xz --strip 1 -C . 
RUN ./configure --prefix=/usr && make && make install && ldconfig

## build asterisk (https://downloads.asterisk.org/pub/telephony/asterisk/releases)
ARG ASTERISK_VER=18.13.0
WORKDIR /usr/src/asterisk
RUN curl -fSL --connect-timeout 30 https://github.com/asterisk/asterisk/archive/refs/tags/${ASTERISK_VER}.tar.gz | tar xz --strip 1 -C .
RUN \
  ./contrib/scripts/get_mp3_source.sh && \
  ./configure --prefix=/usr --libdir=/usr/lib64 --with-pjproject-bundled --with-jansson-bundled --with-resample --with-ssl=ssl --with-srtp && \
  \
  make menuselect/menuselect menuselect-tree menuselect.makeopts && \
  \
  menuselect/menuselect \
    --enable-category MENUSELECT_ADDONS \
    --enable-category MENUSELECT_CHANNELS \
    --enable-category MENUSELECT_APPS \
    --enable-category MENUSELECT_CDR \
    --enable-category MENUSELECT_FORMATS \
    --enable-category MENUSELECT_FUNCS \
    --enable-category MENUSELECT_PBX \
    --enable-category MENUSELECT_RES \
    --enable-category MENUSELECT_CEL \
    --enable-category MENUSELECT_MOH \ 
  \
  menuselect/menuselect \
    --enable BETTER_BACKTRACES \
    --enable DONT_OPTIMIZE \
    --enable app_confbridge \
    --enable app_macro \
    --enable app_mysql \
    --enable app_page \
    --enable binaural_rendering_in_bridge_softmix \
    --enable chan_motif \
    --enable codec_silk \
    --enable codec_opus \
    --enable format_mp3 \
    --enable res_ari \
    --enable res_chan_stats \
    --enable res_calendar \
    --enable res_calendar_caldav \
    --enable res_calendar_icalendar \
    --enable res_endpoint_stats \
    --enable res_fax \
    --enable res_fax_spandsp \
    --enable res_pktccops \
    --enable res_snmp \
    --enable res_srtp \
    --enable res_xmpp \
    --disable-category MENUSELECT_CORE_SOUNDS \
    --disable-category MENUSELECT_EXTRA_SOUNDS \
    --disable BUILD_NATIVE \
    --disable app_meetme \
    --disable app_ivrdemo \
    --disable app_saycounted \
    --disable app_skel \
    --disable app_voicemail_imap \
    --disable cdr_pgsql \
    --disable cel_pgsql \
    --disable cdr_sqlite3_custom \
    --disable cel_sqlite3_custom \
    --disable cdr_mysql \
    --disable cdr_tds \
    --disable cel_tds \
    --disable cdr_radius \
    --disable cel_radius \
    --disable cdr_syslog \
    --disable chan_alsa \
    --disable chan_console \
    --disable chan_oss \
    --disable chan_mgcp \
    --disable chan_skinny \
    --disable chan_ooh323 \
    --disable chan_mobile \
    --disable chan_unistim \
    --disable res_ari_mailboxes \
    --disable res_digium_phone \
    --disable res_calendar_ews \
    --disable res_calendar_exchange \
    --disable res_stasis_mailbox \
    --disable res_mwi_external \
    --disable res_mwi_external_ami \
    --disable res_config_pgsql \
    --disable res_config_mysql \
    --disable res_config_ldap \
    --disable res_config_sqlite3 \
    --disable res_phoneprov \
    --disable res_pjsip_phoneprov_provider \
  && \
  make && \
  make install && \
  make install-headers && \
  make config && \
  make samples && \
  ldconfig 

## build bcg729 audio codec (https://github.com/BelledonneCommunications/bcg729/tags)
ARG BCG729_VER=1.1.1
WORKDIR /usr/src/bcg729
RUN curl -fSL --connect-timeout 30 https://github.com/BelledonneCommunications/bcg729/archive/${BCG729_VER}.tar.gz | tar xz --strip 1 -C .
RUN cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_PREFIX_PATH=/usr && \
    make && make install && ldconfig

##  build asterisk-chan-dongle (https://github.com/shalzz/asterisk-chan-dongle)
ARG ASTERISK_CHAN_DONGLE_VER=master
WORKDIR /usr/src/asterisk-chan-dongle
RUN curl -fSL --connect-timeout 30 https://github.com/shalzz/asterisk-chan-dongle/archive/${ASTERISK_CHAN_DONGLE_VER}.tar.gz | tar xz --strip 1 -C . 
RUN ./bootstrap && \
    ./configure --with-astversion=${ASTERISK_VER} && \
    make && make install && ldconfig && \
    cp ./etc/dongle.conf /etc/asterisk/dongle.conf

## build sngrep (https://github.com/irontec/sngrep/releases)
ARG SNGREP_VER=1.5.0
WORKDIR /usr/src/sngrep
RUN curl -fSL --connect-timeout 30 https://github.com/irontec/sngrep/archive/v${SNGREP_VER}.tar.gz | tar xz --strip 1 -C .
RUN ./bootstrap.sh && \
    ./configure --prefix=/usr && \
    make && make install && ldconfig

## install freepbx sources (https://github.com/FreePBX/core/tags)
ARG FREEPBX_VER=16
WORKDIR /usr/src/freepbx
RUN curl -fSL --connect-timeout 30 http://mirror.freepbx.org/modules/packages/freepbx/freepbx-${FREEPBX_VER}.0-latest.tgz | tar xz --strip 1 -C .

## install freepbx modules

#### Asterisk install ######################################################

FROM base AS asterisk

## install asterisk runtime dependencies
RUN dnf install -y \
    iptables \
    libnetfilter_conntrack \
    libnfnetlink \
    conntrack-tools \
    libnetfilter_cthelper \
    libnetfilter_cttimeout \
    libnetfilter_queue \
    curl \
    opus \
    unixODBC \
    sox \
    libxml2 \
    openssl \
    newt \
    sqlite \
    libuuid \
    jansson \
    binutils \
    libedit \
    libtool \
    ncurses \
    libtiff \
    libjpeg-turbo \
    audiofile \
    uuid \
    libtool-ltdl \
    libsndfile \
    wget \
    bzip2 \
    file \
    ilbc \
    mariadb \
    mariadb-connector-odbc \
    mpg123 \
    libtiff-tools \
    cronie \
    diffutils \
    unzip \
    zip \
    uriparser \
    speex \
    speexdsp \
    portaudio \
    libsrtp \
    unbound-libs \
    freetds \
    freetds-libs \
    libevent \
    net-snmp-libs \
    codec2 \
    neon \
    pakchois \
    libmodman \
    libproxy \
    net-snmp-agent-libs \
    lm_sensors-libs \
    libical \
    libical-devel \
    icu \
    python2 \
    libnsl \
    which \
    fftw-libs \
    sudo \
    glibc-langpack-en \
    libresample \
    ffmpeg \
    lame \
    libuv \
    patch

## copy asterisk binaries
COPY --from=builder /usr/lib64/asterisk /usr/lib64/asterisk
COPY --from=builder /usr/lib64/libasterisk* /usr/lib64/libbcg729* /usr/lib64/libiksemel* /usr/lib64/libspandsp* /usr/lib64/
COPY --from=builder /usr/lib64/pkgconfig/asterisk.pc /usr/lib64/pkgconfig/iksemel.pc /usr/lib64/pkgconfig/libbcg729.pc /usr/lib64/pkgconfig/spandsp.pc /usr/lib64/pkgconfig/
COPY --from=builder /usr/include/asterisk /usr/include/asterisk
COPY --from=builder /usr/include/asterisk* /usr/include/iksemel* /usr/include/spandsp* /usr/include/bcg729* /usr/include/
COPY --from=builder /etc/asterisk /etc/asterisk
COPY --from=builder /etc/sngreprc /etc/sngreprc
COPY --from=builder /usr/bin/sngrep /usr/bin/
COPY --from=builder /usr/sbin/ast* /usr/sbin/*asterisk /usr/sbin/
COPY --from=builder /usr/share/man/man8/ast* /usr/share/man/man8/sngrep.* /usr/share/man/man8/
COPY --from=builder /var/lib/asterisk /var/lib/asterisk
COPY --from=builder /var/log/asterisk /var/log/asterisk
COPY --from=builder /var/spool/asterisk /var/spool/asterisk

# fix mysql odbc inst file path
RUN sed -i 's/\/lib64\/libmyodbc5.so/\/lib64\/libmaodbc.so/' /etc/odbcinst.ini

#### FreePBX install ######################################################

FROM asterisk AS freepbx

# enable php 7.4
RUN dnf module reset php -y && \
    dnf module enable php:7.4 -y

## install freepbx dependencies
RUN dnf install -y \
    nodejs \
    httpd \
    mod_ssl \
    php \
    php-mysqlnd \
    php-process \
    php-pear \
    php-mbstring \
    php-xml \
    php-json \
    php-gd \
    php-curl \
    php-ldap \
    perl-DBI \
    perl-DBD-mysql \
    cyrus-sasl-plain \
    cyrus-sasl-md5 \
    incron

# install PHP IonCube loader
RUN curl -fSL --connect-timeout 30 https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz | \
        tar xz --strip 1 --no-same-owner -C /usr/lib64/php/modules/ ioncube/ioncube_loader_lin_7.4.so && \
    chmod 755 /usr/lib64/php/modules/ioncube_loader_lin_7.4.so && \
    echo "zend_extension=ioncube_loader_lin_7.4.so" >> /etc/php.ini

# copy freepbx sources
COPY --from=builder /usr/src/freepbx /usr/src/freepbx

## reconfigure apache modules
RUN sed "s/#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/" -i /etc/httpd/conf.modules.d/00-mpm.conf && \
    sed "s/LoadModule mpm_event_module/#LoadModule mpm_event_module/" -i /etc/httpd/conf.modules.d/00-mpm.conf && \
    sed "s/^User .*/User asterisk/" -i /etc/httpd/conf/httpd.conf && \
    sed "s/^Group .*/Group asterisk/" -i /etc/httpd/conf/httpd.conf && \
    rm /etc/httpd/conf.d/ssl.conf

#### Final image ######################################################

FROM freepbx

## install extra dependencies
RUN dnf install -y chrony postfix procps iproute socat

### prep users
RUN groupadd -g 1000 asterisk && \
    useradd -u 1000 -g asterisk -G wheel,apache,dialout -s /sbin/nologin asterisk

## create asterisk default selfsigned certs
RUN mkdir /etc/asterisk/keys && \
    openssl req -x509 -nodes -newkey rsa:2048 -subj '/CN=localhost' \
    -keyout /etc/asterisk/keys/default.key \
    -out /etc/asterisk/keys/default.crt

## add files to container
ADD rootfs /

## set pemissions and sudo
RUN chown -R asterisk:asterisk /etc/asterisk /var/*/asterisk /run/lock
RUN chmod +x /install.sh
RUN ln -s /var/lib/asterisk/bin/fwconsole /usr/sbin/fwconsole && \
    ln -s /var/lib/asterisk/bin/amportal /usr/sbin/amportal

## setup volumes
VOLUME /var/lib/asterisk
VOLUME /var/log/asterisk
VOLUME /var/run/asterisk
VOLUME /var/spool/asterisk
VOLUME /var/spool/cron
VOLUME /etc
VOLUME /var/www
