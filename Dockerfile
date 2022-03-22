FROM alpine AS builder

ARG PREFIX=/home/drh/tcl

RUN apk add bsd-compat-headers build-base fossil zlib-static \
  && wget https://prdownloads.sourceforge.net/tcl/tcl8.7a5-src.tar.gz \
  && tar -xzf tcl8.7a5-src.tar.gz \
  && cd tcl8.7a5/unix \
  && ./configure --disable-shared --prefix=$PREFIX \
  && make && make install \
  && ln -s $PREFIX/bin/tclsh8.7 $PREFIX/bin/tclsh \
  && export PATH=$PATH:$PREFIX/bin \
  && cd / \
  && fossil clone --user root https://wapp.tcl.tk \
  && cd wapp \
  && make


FROM alpine

COPY --from=builder /wapp/wapptclsh /usr/bin/wapptclsh

ENTRYPOINT ["/bin/sh"]
