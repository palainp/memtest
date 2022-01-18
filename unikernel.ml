open Lwt.Infix

module MemTest (S: Tcpip.Stack.V4) = struct

  module Memtrace = Memtrace.Make(Pclock)(S.TCPV4)

  let memory_usage =
    Lwt.async (fun () ->
      let rec aux () =
        let mallinfo = OS.Memory.stat () in
        let { OS.Memory.free_words; heap_words; _ } = mallinfo in
        let mallinfo_free_words = free_words in
        let quick_stat_alt = OS.Memory.quick_stat_alt () in
        let { OS.Memory.free_words; heap_words; _ } = quick_stat_alt in
        let quick_stat_alt_free_words = free_words in
        Logs.info (fun f -> f "Difference in bytes: (%d)" (quick_stat_alt_free_words-mallinfo_free_words));
        OS.Time.sleep_ns (Duration.of_f 1.0) >>= fun () ->
        aux ()
      in
      aux ()
    )

  let start s =
    S.TCPV4.create_connection (S.tcpv4 s) (Ipaddr.V4.of_string_exn "10.0.0.1", 1234) >|= function
    | Ok flow -> Memtrace.start_tracing ~sampling_rate:1e-4 ~context:"my unikernel" flow
    | Error _ -> ()
    memory_usage ;
    Lwt.return_unit

end
