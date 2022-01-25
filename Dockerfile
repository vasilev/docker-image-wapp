FROM alpine AS builder

RUN apk add build-base fossil tcl-dev \
  && fossil clone --user root https://wapp.tcl.tk \
  && cd wapp \
  && sed -i.bak -e 's| -static||;s|/home/drh/tcl|/usr|;s|libtcl8.7.a|libtcl'$(echo 'puts $tcl_version' | tclsh)'.so|' Makefile \
  && make


FROM alpine

RUN apk add --no-cache tcl

COPY --from=builder /wapp/wapptclsh /usr/bin/wapptclsh

ENTRYPOINT ["/bin/sh"]
