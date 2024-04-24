FROM alpine:latest

RUN apk --update --no-cache add gcc g++ make cmake pkgconf sqlite-dev curl ca-certificates nginx tar libxml2-dev openssl-dev curl-dev oniguruma-dev

ENV HOME /home/container
WORKDIR /home/container

RUN wget https://www.php.net/distributions/php-8.3.0.tar.gz --directory-prefix "$HOME"
RUN tar -xvf /home/container/php-8.3.0.tar.gz --directory "$HOME"

WORKDIR $HOME/php-8.3.0

RUN ./configure --prefix=/usr/bin/php \
  --with-openssl \
  --with-curl \
  --with-zlib \
  --with-mysqli \
  --with-ctype \
  --with-pcre \
  --with-session \
  --with-pdo-mysql \
  --with-tokenizer \
  --with-iconv \
  --enable-cli \
  --enable-fpm \
  --enable-xml \
  --enable-mbstring

RUN make
RUN make install

USER container
ENV USER container

COPY --from=composer:latest  /usr/bin/composer /usr/bin/composer
COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/ash", "/entrypoint.sh"]
