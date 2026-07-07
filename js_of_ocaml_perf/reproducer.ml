module Poly = struct
  external ( < ) : 'a -> 'a -> bool = "%lessthan"

  external ( <= ) : 'a -> 'a -> bool = "%lessequal"

  external ( <> ) : 'a -> 'a -> bool = "%notequal"

  external ( = ) : 'a -> 'a -> bool = "%equal"

  external ( > ) : 'a -> 'a -> bool = "%greaterthan"

  external ( >= ) : 'a -> 'a -> bool = "%greaterequal"

  external compare : 'a -> 'a -> int = "%compare"

  external equal : 'a -> 'a -> bool = "%equal"
end

module Int_replace_polymorphic_compare = struct
  external ( < ) : int -> int -> bool = "%lessthan"

  external ( <= ) : int -> int -> bool = "%lessequal"

  external ( <> ) : int -> int -> bool = "%notequal"

  external ( = ) : int -> int -> bool = "%equal"

  external ( > ) : int -> int -> bool = "%greaterthan"

  external ( >= ) : int -> int -> bool = "%greaterequal"

  external compare : int -> int -> int = "%compare"

  external equal : int -> int -> bool = "%equal"

  let max (x : int) y = if x >= y then x else y

  let min (x : int) y = if x <= y then x else y
end

module String = struct
  include String

  let equal (x : string) (y : string) = Poly.equal x y
end

module Char = struct
  include Char

  let equal (x : char) (y : char) = Poly.equal x y
end

include Int_replace_polymorphic_compare




module Js_of_ocaml = struct
  module Js = Js
  module Dom = Dom
end
open Js
open XmlHttpRequest

module Lwt = struct
    type +'a t
    type 'a u
    let task: unit -> 'a t * 'a u = fun () -> assert false
    let wakeup_exn: 'a u -> exn -> unit = fun _ _ -> assert false
    let wakeup: 'a u -> 'a -> unit = fun _ _ -> assert false
    let on_cancel: 'a t -> (unit -> unit) -> unit = fun _ _ -> assert false
  end

let encode_url l =
  String.concat "&"
    (List.map
       (function
        | (name, `String s) ->
            (Url.urlencode name) ^ ("=" ^ (Url.urlencode (to_string s)))
        | (name, `File s) ->
            (Url.urlencode name) ^
              ("=" ^
                 (Url.urlencode
                    (to_string
                       ((fun (type res) (type t0) (t0 : t0 Js.t)
                           (_ :
                             t0 ->
                               < get: res   ;.. >  Js.gen_prop)
                           : res->
                           Js.Unsafe.get t0
                             (Js.string "name"))
                          (s : < .. >  Js.t) (fun x -> x#name))))))
       l)
type 'response generic_http_frame =
  {
  url: string ;
  code: int ;
  headers: string -> string option ;
  content: 'response ;
  content_xml: unit -> Dom.element Dom.document t option }[@@ocaml.doc
                                                            " type of the http headers "]
type http_frame = string generic_http_frame
exception Wrong_headers of (int * (string -> string option))
let default_response url code headers req =
  {
    url;
    code;
    content =
      (Js.Opt.case
         ((fun (type res) (type t1) (t1 : t1 Js.t)
             (_ : t1 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t1
               (Js.string "responseText"))
            (req : < .. >  Js.t) (fun x -> x#responseText))
         (fun () -> "") (fun x -> Js.to_string x));
    content_xml =
      (fun () ->
         match Js.Opt.to_option
                 ((fun (type res) (type t2) (t2 : t2 Js.t)
                     (_ : t2 -> < get: res   ;.. >  Js.gen_prop)
                     : res->
                     Js.Unsafe.get t2
                       (Js.string "responseXML"))
                    (req : < .. >  Js.t) (fun x -> x#responseXML))
         with
         | None -> None
         | Some doc ->
             if
               (Js.some
                  ((fun (type res) (type t3) (t3 : t3 Js.t)
                      (_ : t3 -> < get: res   ;.. >  Js.gen_prop)
                      : res->
                      Js.Unsafe.get t3
                        (Js.string "documentElement"))
                     (doc : < .. >  Js.t)
                     (fun x -> x#documentElement)))
                 == Js.null
             then None
             else Some doc);
    headers
  }
let text_response url code headers req =
  {
    url;
    code;
    content =
      (Js.Opt.case
         ((fun (type res) (type t4) (t4 : t4 Js.t)
             (_ : t4 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t4
               (Js.string "responseText"))
            (req : < .. >  Js.t) (fun x -> x#responseText))
         (fun () -> Js.string "") (fun x -> x));
    content_xml = (fun () -> None);
    headers
  }
let document_response url code headers req =
  {
    url;
    code;
    content =
      (File.CoerceTo.document
         ((fun (type res) (type t5) (t5 : t5 Js.t)
             (_ : t5 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t5 (Js.string "response"))
            (req : < .. >  Js.t) (fun x -> x#response)));
    content_xml = (fun () -> None);
    headers
  }
let json_response url code headers req =
  {
    url;
    code;
    content =
      (File.CoerceTo.json
         ((fun (type res) (type t6) (t6 : t6 Js.t)
             (_ : t6 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t6 (Js.string "response"))
            (req : < .. >  Js.t) (fun x -> x#response)));
    content_xml = (fun () -> None);
    headers
  }
let blob_response url code headers req =
  {
    url;
    code;
    content =
      (File.CoerceTo.blob
         ((fun (type res) (type t7) (t7 : t7 Js.t)
             (_ : t7 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t7 (Js.string "response"))
            (req : < .. >  Js.t) (fun x -> x#response)));
    content_xml = (fun () -> None);
    headers
  }
let arraybuffer_response url code headers req =
  {
    url;
    code;
    content =
      (File.CoerceTo.arrayBuffer
         ((fun (type res) (type t8) (t8 : t8 Js.t)
             (_ : t8 -> < get: res   ;.. >  Js.gen_prop) : 
             res->
             Js.Unsafe.get t8 (Js.string "response"))
            (req : < .. >  Js.t) (fun x -> x#response)));
    content_xml = (fun () -> None);
    headers
  }
let has_get_args url =
  try ignore (String.index url '?'); true with | Not_found -> false
let perform_raw ?(headers= []) ?content_type ?(get_args= []) ?(check_headers=
  fun _ _ -> true) ?progress ?upload_progress ?contents ?override_mime_type
  ?override_method ?with_credentials (type resptype)
  ~response_type:(response_type : resptype response) url =
  let contents_normalization =
    function
    | `POST_form args ->
        let only_strings =
          List.for_all
            (fun x -> match x with | (_, `String _) -> true | _ -> false)
            args in
        let form_contents =
          if only_strings
          then `Fields (ref [])
          else Form.empty_form_contents () in
        (List.iter
           (fun (name, value) -> Form.append form_contents (name, value))
           args;
         `Form_contents form_contents)
    | `String _ | `Form_contents _ as x -> x
    | `Blob b -> `Blob (b : #File.blob Js.t  :> File.blob Js.t) in
  let contents =
    match contents with
    | None -> None
    | Some c -> Some (contents_normalization c) in
  let method_to_string m =
    match m with
    | `GET -> "GET"
    | `POST -> "POST"
    | `HEAD -> "HEAD"
    | `PUT -> "PUT"
    | `DELETE -> "DELETE"
    | `OPTIONS -> "OPTIONS"
    | `PATCH -> "PATCH" in
  let (method_, content_type) =
    let override_method m =
      match override_method with | None -> m | Some v -> method_to_string v in
    let override_content_type c =
      match content_type with | None -> Some c | Some _ -> content_type in
    match contents with
    | None -> ((override_method "GET"), content_type)
    | Some (`Form_contents form) ->
        (match form with
         | `Fields _strings ->
             ((override_method "POST"),
               (override_content_type "application/x-www-form-urlencoded"))
         | `FormData _ -> ((override_method "POST"), content_type))
    | Some (`String _ | `Blob _) -> ((override_method "POST"), content_type) in
  let url =
    if let open Poly in get_args = []
    then url
    else
      url ^
        ((if has_get_args url then "&" else "?") ^
           (Url.encode_arguments get_args)) in
  let ((res : resptype generic_http_frame Lwt.t), w) = Lwt.task () in
  let req = create () in
  (((fun (type res) (type t9) (type t10) (type t11) (type t12)
       (t9 : t9 Js.t) (t10 : t10) (t11 : t11) (t12 : t12)
       (_ : t9 -> t10 -> t11 -> t12 -> res Js.meth) : res->
       Js.Unsafe.meth_call t9 "open"
         [|(Js.Unsafe.inject t10);(Js.Unsafe.inject
                                                 t11);(Js.Unsafe.inject
                                                         t12)|]))
    [@merlin.hide ]) (((req : < .. >  Js.t))[@merlin.hide ])
    (Js.string method_) (Js.string url) Js._true (fun x -> x#_open);
  (match override_mime_type with
   | None -> ()
   | Some mime_type ->
       (((fun (type res) (type t13) (type t14) (t13 : t13 Js.t)
            (t14 : t14) (_ : t13 -> t14 -> res Js.meth) : 
            res->
            Js.Unsafe.meth_call t13 "overrideMimeType"
              [|(Js.Unsafe.inject t14)|]))[@merlin.hide ])
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string mime_type) (fun x -> x#overrideMimeType));
  (match response_type with
   | ArrayBuffer ->
       ((fun (type res) (type t16) (type t15) (t16 : t16 Js.t)
           (t15 : t15)
           (_ : t16 -> < set: t15 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t16
             (Js.string "responseType")
             (Js.Unsafe.inject t15)))
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "arraybuffer") (fun x -> x#responseType)
   | Blob ->
       ((fun (type res) (type t18) (type t17) (t18 : t18 Js.t)
           (t17 : t17)
           (_ : t18 -> < set: t17 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t18
             (Js.string "responseType")
             (Js.Unsafe.inject t17)))
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "blob") (fun x -> x#responseType)
   | Document ->
       ((fun (type res) (type t20) (type t19) (t20 : t20 Js.t)
           (t19 : t19)
           (_ : t20 -> < set: t19 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t20
             (Js.string "responseType")
             (Js.Unsafe.inject t19)))
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "document") (fun x -> x#responseType)
   | JSON ->
       ((fun (type res) (type t22) (type t21) (t22 : t22 Js.t)
           (t21 : t21)
           (_ : t22 -> < set: t21 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t22
             (Js.string "responseType")
             (Js.Unsafe.inject t21)))
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "json") (fun x -> x#responseType)
   | Text ->
       ((fun (type res) (type t24) (type t23) (t24 : t24 Js.t)
           (t23 : t23)
           (_ : t24 -> < set: t23 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t24
             (Js.string "responseType")
             (Js.Unsafe.inject t23)))
         (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "text") (fun x -> x#responseType)
   | Default ->
       ((fun (type res) (type t26) (type t25) (t26 : t26 Js.t)
           (t25 : t25)
           (_ : t26 -> < set: t25 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t26
             (Js.string "responseType")
             (Js.Unsafe.inject t25)))
         (((req : < .. >  Js.t))[@merlin.hide ]) (Js.string "")
         (fun x -> x#responseType));
  (match with_credentials with
   | Some c ->
       ((fun (type res) (type t28) (type t27) (t28 : t28 Js.t)
           (t27 : t27)
           (_ : t28 -> < set: t27 -> unit   ;.. >  Js.gen_prop) :
           unit->
           Js.Unsafe.set t28
             (Js.string "withCredentials")
             (Js.Unsafe.inject t27)))
         (((req : < .. >  Js.t))[@merlin.hide ]) (Js.bool c)
         (fun x -> x#withCredentials)
   | None -> ());
  (match content_type with
   | Some content_type ->
       (((fun (type res) (type t29) (type t30) (type t31)
            (t29 : t29 Js.t) (t30 : t30) (t31 : t31)
            (_ : t29 -> t30 -> t31 -> res Js.meth) : res->
            Js.Unsafe.meth_call t29 "setRequestHeader"
              [|(Js.Unsafe.inject t30);(Js.Unsafe.inject
                                                      t31)|]))
         [@merlin.hide ]) (((req : < .. >  Js.t))[@merlin.hide ])
         (Js.string "Content-type") (Js.string content_type)
         (fun x -> x#setRequestHeader)
   | _ -> ());
  List.iter
    (fun (n, v) ->
       ((fun (type res) (type t32) (type t33) (type t34)
           (t32 : t32 Js.t) (t33 : t33) (t34 : t34)
           (_ : t32 -> t33 -> t34 -> res Js.meth) : res->
           Js.Unsafe.meth_call t32 "setRequestHeader"
             [|(Js.Unsafe.inject t33);(Js.Unsafe.inject
                                                     t34)|])[@merlin.hide ])
         (((req : < .. >  Js.t))[@merlin.hide ]) (Js.string n)
         (Js.string v) (fun x -> x#setRequestHeader)) headers;
  (let headers s =
     Opt.case
       (((fun (type res) (type t35) (type t36) (t35 : t35 Js.t)
            (t36 : t36) (_ : t35 -> t36 -> res Js.meth) : 
            res->
            Js.Unsafe.meth_call t35 "getResponseHeader"
              [|(Js.Unsafe.inject t36)|])[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ])
          (Js.bytestring s) (fun x -> x#getResponseHeader)) (fun () -> None)
       (fun v -> Some (Js.to_string v)) in
   let do_check_headers =
     let st = ref `Not_yet in
     fun () ->
       if (let open Poly in (!st) = `Not_yet)
       then
         (if
            check_headers
              ((fun (type res) (type t37) (t37 : t37 Js.t)
                  (_ : t37 -> < get: res   ;.. >  Js.gen_prop) :
                  res->
                  Js.Unsafe.get t37
                    (Js.string "status"))
                 (req : < .. >  Js.t) (fun x -> x#status))
              headers
          then st := `Passed
          else
            (Lwt.wakeup_exn w
               (Wrong_headers
                  (((fun (type res) (type t38) (t38 : t38 Js.t)
                       (_ :
                         t38 -> < get: res   ;.. >  Js.gen_prop)
                       : res->
                       Js.Unsafe.get t38
                         (Js.string "status"))
                      (req : < .. >  Js.t) (fun x -> x#status)),
                    headers));
             st := `Failed;
             (((fun (type res) (type t39) (t39 : t39 Js.t)
                  (_ : t39 -> res Js.meth) : res->
                  Js.Unsafe.meth_call t39 "abort" [||]))
               [@merlin.hide ]) (((req : < .. >  Js.t))
               [@merlin.hide ]) (fun x -> x#abort)));
       (let open Poly in (!st) <> `Failed) in
   ((fun (type res) (type t48) (type t47) (t48 : t48 Js.t)
       (t47 : t47)
       (_ : t48 -> < set: t47 -> unit   ;.. >  Js.gen_prop) :
       unit->
       Js.Unsafe.set t48
         (Js.string "onreadystatechange")
         (Js.Unsafe.inject t47)))
     (((req : < .. >  Js.t))[@merlin.hide ])
     (Js.wrap_callback
        (fun _ ->
           match (fun (type res) (type t40) (t40 : t40 Js.t)
                    (_ : t40 -> < get: res   ;.. >  Js.gen_prop)
                    : res->
                    Js.Unsafe.get t40
                      (Js.string "readyState"))
                   (req : < .. >  Js.t) (fun x -> x#readyState)
           with
           | HEADERS_RECEIVED -> ignore (do_check_headers ())
           | DONE ->
               if do_check_headers ()
               then
                 let response : resptype generic_http_frame =
                   match response_type with
                   | ArrayBuffer ->
                       arraybuffer_response url
                         ((fun (type res) (type t41)
                             (t41 : t41 Js.t)
                             (_ :
                               t41 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t41
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req
                   | Blob ->
                       blob_response url
                         ((fun (type res) (type t42)
                             (t42 : t42 Js.t)
                             (_ :
                               t42 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t42
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req
                   | Document ->
                       document_response url
                         ((fun (type res) (type t43)
                             (t43 : t43 Js.t)
                             (_ :
                               t43 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t43
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req
                   | JSON ->
                       json_response url
                         ((fun (type res) (type t44)
                             (t44 : t44 Js.t)
                             (_ :
                               t44 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t44
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req
                   | Text ->
                       text_response url
                         ((fun (type res) (type t45)
                             (t45 : t45 Js.t)
                             (_ :
                               t45 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t45
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req
                   | Default ->
                       default_response url
                         ((fun (type res) (type t46)
                             (t46 : t46 Js.t)
                             (_ :
                               t46 ->
                                 < get: res   ;.. >  Js.gen_prop)
                             : res->
                             Js.Unsafe.get t46
                               (Js.string "status"))
                            (req : < .. >  Js.t)
                            (fun x -> x#status)) headers req in
                 Lwt.wakeup w response
           | _ -> ())) (fun x -> x#onreadystatechange);
   (match progress with
    | Some progress ->
        ((fun (type res) (type t52) (type t51) (t52 : t52 Js.t)
            (t51 : t51)
            (_ : t52 -> < set: t51 -> unit   ;.. >  Js.gen_prop)
            : unit->
            Js.Unsafe.set t52
              (Js.string "onprogress")
              (Js.Unsafe.inject t51)))
          (((req : < .. >  Js.t))[@merlin.hide ])
          (Dom.handler
             (fun e ->
                progress
                  ((fun (type res) (type t49) (t49 : t49 Js.t)
                      (_ :
                        t49 -> < get: res   ;.. >  Js.gen_prop)
                      : res->
                      Js.Unsafe.get t49
                        (Js.string "loaded"))
                     (e : < .. >  Js.t) (fun x -> x#loaded))
                  ((fun (type res) (type t50) (t50 : t50 Js.t)
                      (_ :
                        t50 -> < get: res   ;.. >  Js.gen_prop)
                      : res->
                      Js.Unsafe.get t50
                        (Js.string "total"))
                     (e : < .. >  Js.t) (fun x -> x#total));
                Js._true)) (fun x -> x#onprogress)
    | None -> ());
   (match upload_progress with
    | Some upload_progress ->
        ((fun (type res) (type t57) (type t56) (t57 : t57 Js.t)
            (t56 : t56)
            (_ : t57 -> < set: t56 -> unit   ;.. >  Js.gen_prop)
            : unit->
            Js.Unsafe.set t57
              (Js.string "onprogress")
              (Js.Unsafe.inject t56)))
          ((((fun (type res) (type t53) (t53 : t53 Js.t)
                (_ : t53 -> < get: res   ;.. >  Js.gen_prop) :
                res->
                Js.Unsafe.get t53
                  (Js.string "upload"))
               (req : < .. >  Js.t) (fun x -> x#upload) : 
          < .. >  Js.t))[@merlin.hide ])
          (Dom.handler
             (fun e ->
                upload_progress
                  ((fun (type res) (type t54) (t54 : t54 Js.t)
                      (_ :
                        t54 -> < get: res   ;.. >  Js.gen_prop)
                      : res->
                      Js.Unsafe.get t54
                        (Js.string "loaded"))
                     (e : < .. >  Js.t) (fun x -> x#loaded))
                  ((fun (type res) (type t55) (t55 : t55 Js.t)
                      (_ :
                        t55 -> < get: res   ;.. >  Js.gen_prop)
                      : res->
                      Js.Unsafe.get t55
                        (Js.string "total"))
                     (e : < .. >  Js.t) (fun x -> x#total));
                Js._true)) (fun x -> x#onprogress)
    | None -> ());
   (match contents with
    | None ->
        (((fun (type res) (type t58) (type t59) (t58 : t58 Js.t)
             (t59 : t59) (_ : t58 -> t59 -> res Js.meth) : 
             res->
             Js.Unsafe.meth_call t58 "send"
               [|(Js.Unsafe.inject t59)|]))[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ]) Js.null
          (fun x -> x#send)
    | Some (`Form_contents (`Fields l)) ->
        (((fun (type res) (type t60) (type t61) (t60 : t60 Js.t)
             (t61 : t61) (_ : t60 -> t61 -> res Js.meth) : 
             res->
             Js.Unsafe.meth_call t60 "send"
               [|(Js.Unsafe.inject t61)|]))[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ])
          (Js.some (string (encode_url (!l)))) (fun x -> x#send)
    | Some (`Form_contents (`FormData f)) ->
        (((fun (type res) (type t62) (type t63) (t62 : t62 Js.t)
             (t63 : t63) (_ : t62 -> t63 -> res Js.meth) : 
             res->
             Js.Unsafe.meth_call t62 "send"
               [|(Js.Unsafe.inject t63)|]))[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ]) f
          (fun x -> x#send_formData)
    | Some (`String s) ->
        (((fun (type res) (type t64) (type t65) (t64 : t64 Js.t)
             (t65 : t65) (_ : t64 -> t65 -> res Js.meth) : 
             res->
             Js.Unsafe.meth_call t64 "send"
               [|(Js.Unsafe.inject t65)|]))[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ])
          (Js.some (Js.string s)) (fun x -> x#send)
    | Some (`Blob b) ->
        (((fun (type res) (type t66) (type t67) (t66 : t66 Js.t)
             (t67 : t67) (_ : t66 -> t67 -> res Js.meth) : 
             res->
             Js.Unsafe.meth_call t66 "send"
               [|(Js.Unsafe.inject t67)|]))[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ]) b
          (fun x -> x#send_blob));
   Lwt.on_cancel res
     (fun () ->
        ((fun (type res) (type t68) (t68 : t68 Js.t)
            (_ : t68 -> res Js.meth) : res->
            Js.Unsafe.meth_call t68 "abort" [||])[@merlin.hide ])
          (((req : < .. >  Js.t))[@merlin.hide ])
          (fun x -> x#abort));
   res)
let perform_raw_url ?(headers= []) ?content_type ?(get_args= [])
  ?check_headers ?progress ?upload_progress ?contents ?override_mime_type
  ?override_method ?with_credentials url =
  perform_raw ~headers ?content_type ~get_args ?contents ?check_headers
    ?progress ?upload_progress ?override_mime_type ?override_method
    ?with_credentials ~response_type:Default url
let perform ?(headers= []) ?content_type ?(get_args= []) ?check_headers
  ?progress ?upload_progress ?contents ?override_mime_type ?override_method
  ?with_credentials url =
  perform_raw ~headers ?content_type ~get_args ?contents ?check_headers
    ?progress ?upload_progress ?override_mime_type ?override_method
    ?with_credentials ~response_type:Default (Url.string_of_url url)
let get s = perform_raw_url s
