type core_flow5 =
  [
    | `Wbr of (int -> int)
    | `Header of (float -> float)
  ]

type flow5_without_interactive =
  [
    core_flow5
  |  `Noscript of (string -> string)
  ]


type flow5 =
  [
    | core_flow5
    | `A of flow5_without_interactive
    | `Noscript of (string -> string)
  ]

type flow5_without_interactive_header_footer =
  [
    | `Wbr of (int -> int)
    | `Noscript of (string -> string)
  ]

type flow5_without_header_footer =
  [
    | `Wbr of (int -> int)
    | `A of flow5_without_interactive_header_footer
    | `Noscript of (string -> string)
  ]

type +'a inbetween =
  [< flow5  > `Noscript `Wbr] as 'a


type ('a,'b) t = 'a -> 'b

type f = { f: 'a. ('a inbetween, 'a) t }

let id = { f = Fun.id }

let wrong = (id.f :> (flow5, flow5_without_header_footer) t)

let crash = match wrong (`A (`Header ((+.) 1.))) with
  | `Wbr _ -> ()
  | `Noscript _ -> ()
  | `A `Wbr f -> Format.eprintf "%d@." (f 2)
  | `A (`Noscript s) -> Format.eprintf "%s@." (s "hi")
