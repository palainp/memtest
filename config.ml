open Mirage

let stack = generic_stackv4 default_network

let main =
  foreign
    ~packages:[
      package ~min:"7.0.0" "tcpip";
      package "memtrace-mirage";
    ]
    "Unikernel.MemTest" (stackv4  @-> job)

let () =
  register "memtest" [ main $ stack ]
