[@@@warning "-A"]


module R = struct
  type msg = [ `Msg of string ]
  let (>>=) x f = match x with
    | Error (`Msg _) as e -> e
    | Error _ as e -> e
    | Ok x -> f x
end

let make_fail: 'a. 'a -> ('a, [> R.msg]) result = fun x ->
  if Random.bool () then Error (`Msg "random failure") else Ok x

let of_file path = make_fail []

let produce _ database = Ok ()

let produce2 () = if Random.bool () then Ok () else Error (`Msg "p")

let test a f x =
  let open R in
  f a x >>= fun x -> make_fail x


 module LOS = struct
    module File: sig
       val with_oc:       ?mode:int ->unit ->
      (out_channel -> 'a -> (('c, 'd) result as 'b)) ->
      'a -> ('b, 'e) result
    end = struct
      let with_oc ?mode () x = assert false
    end
end



let parse destination =
  let open R in
  make_fail [] >>= fun src ->
  make_fail () >>= fun maps ->
(*  test destination produce maps
  make_fail (test produce2) *)
  Bos.OS.File.with_oc destination produce maps

module App: sig
  type 'a t
  val const: 'a -> 'a t
  val ($): ('a -> 'b) t -> 'a t -> 'b t
  val magic: 'a t
end = struct
   type 'a t = unit -> 'a
   let const x () = x
   let ($) f x () = (f ()) (x ())
  let magic () = assert false
end
open App

let fpath = const Fpath.of_string

let destination = magic

let cmd =
  const parse $ destination
