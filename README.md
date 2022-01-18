# memory-test

prerequisite pins:
```sh
opam pin memtrace-mirage git+https://github.com/hannesm/memtrace-mirage.git
ocaml-freestanding git+https://github.com/winux138/ocaml-freestanding#footprint_alt
opam pin mirage-solo5 git+https://github.com/palainp/mirage-solo5#footprint_alt
```

compile and run:
```sh
mirage configure -t spt && make depend && make && \
sudo ip tuntap add tap100 mode tap && \
sudo ip addr add 10.0.0.1/24 dev tap100 && \
sudo ip link set dev tap100 up && \
solo5-spt --net:service=tap100 memtest.spt
```
