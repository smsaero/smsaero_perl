FROM perl:5.40-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN cpanm --installdeps .

RUN perl Makefile.PL && make && make install

RUN mv bin/smsaero_send.pl . && chmod +x smsaero_send.pl && cp smsaero_send.pl /usr/local/bin/

ENTRYPOINT ["./smsaero_send.pl"]
