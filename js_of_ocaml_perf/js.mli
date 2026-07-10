(* Js_of_ocaml library
 * http://www.ocsigen.org/js_of_ocaml/
 * Copyright (C) 2010 Jérôme Vouillon
 * Laboratoire PPS - CNRS Université Paris Diderot
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

(** Javascript binding

    This module provides types and functions to interoperate with
    Javascript values, and gives access to Javascript standard
    objects.
*)

(* Setup for the checked examples in this file (not rendered by odoc): the
   examples below read as if written inside this module, i.e. with [open Js].
{@ocaml prelude[
open Js_of_ocaml.Js
let id = string "my-id"
]} *)




(** {2 Dealing with [null] and [undefined] values.} *)

type +'a opt
(** Type of possibly null values. *)

type +'a optdef
(** Type of possibly undefined values. *)

val null : 'a opt
(** The [null] value. *)

val some : 'a -> 'a opt
(** Consider a value into a possibly null value. *)

val undefined : 'a optdef
(** The [undefined] value *)

val def : 'a -> 'a optdef
(** Consider a value into a possibly undefined value. *)

(** Signatures of a set of standard functions for manipulating
    optional values. *)
module type OPT = sig
  type 'a t

end

module Opt : OPT with type 'a t = 'a opt
(** Standard functions for manipulating possibly null values. *)

module Optdef : OPT with type 'a t = 'a optdef
(** Standard functions for manipulating possibly undefined values. *)

(** {2 Types for specifying method and properties of Javascript objects} *)

type +'a t
(** Type of Javascript objects.  The type parameter is used to
      specify more precisely an object.  *)

(** Unsafe Javascript operations *)
module Unsafe : sig
  type top

  type any = top t
  (** Top type.  Used for putting values of different types
        in a same array. *)

  type any_js_array = any
end

(** Specification of Javascript regular arrays.
    Use [Js.array_get] and [Js.array_set] to access and set array elements. *)
class type ['a] js_array = object
end


type +'a meth
(** Type used to specify method types:
      a Javascript object
        [<m : t1 -> t2 -> ... -> tn -> t Js.meth> Js.t]
      has a Javascript method [m] expecting {i n} arguments
      of types [t1] to [tn] and returns a value of type [t]. *)

type +'a gen_prop
(** Type used to specify the properties of Javascript
      objects.  In practice you should rarely need this type directly,
      but should rather use the type abbreviations below instead. *)

type 'a readonly_prop = < get : 'a > gen_prop
(** Type of read-only properties:
      a Javascript object
        [<p : t Js.readonly_prop> Js.t]
      has a read-only property [p] of type [t]. *)

type 'a writeonly_prop = < set : 'a -> unit > gen_prop
(** Type of write-only properties:
      a Javascript object
        [<p : t Js.writeonly_prop> Js.t]
      has a write-only property [p] of type [t]. *)

type 'a prop = < get : 'a ; set : 'a -> unit > gen_prop
(** Type of read/write properties:
      a Javascript object
        [<p : t Js.prop> Js.t]
      has a read/write property [p] of type [t]. *)

type 'a optdef_prop = < get : 'a optdef ; set : 'a -> unit > gen_prop
(** Type of read/write properties that may be undefined:
      you can set them to a value of some type [t], but if you read
      them, you will get a value of type [t optdef] (that may be
      [undefined]). *)

(** Specification of Javascript string objects. *)
class type js_string = object
  method replace_string : js_string t -> js_string t -> js_string t meth
end