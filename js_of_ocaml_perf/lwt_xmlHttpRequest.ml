[@@@warning "-a"]
open Js_of_ocaml
type ('a,'b) prop = (< get:'a; .. > as 'b) Js.gen_prop
let default_response:   < responseXML : < get : (< documentElement : ('res, _) prop;
                             .. >
                           as 'a)
                          Js.t Js.Opt.t;
                    .. >
                  Js.gen_prop;
    .. >
  Js.t -> 'a Js.t option
 = fun _ -> assert false

let perform_raw url (type resptype)
  ~response_type:(response_type : resptype XmlHttpRequest.response) =
  let req = XmlHttpRequest.create () in
  let response : Dom.element Dom.document Js.t option =
    match response_type with | Default -> default_response req in
  ()
