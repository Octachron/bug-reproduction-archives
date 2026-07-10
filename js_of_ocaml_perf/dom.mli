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

(** DOM binding

This is a partial binding to the DOM Core API.
*)

open Js

(** Specification of [Node] objects. *)
class type node = object
  method parentElement : element t opt readonly_prop
  method previousSibling : node t opt prop
  method nextSibling : node t opt prop
  method insertBefore : node t -> node t opt -> node t meth
  method replaceChild : node t -> node t -> node t meth
  method removeChild : node t -> node t meth
  method appendChild : node t -> node t meth
  method contains : node t -> bool t meth
  method getRootNode : node t meth
  method isEqualNode : node t -> bool t meth
  method isSameNode : node t -> bool t meth
end

(** Specification of [Attr] objects. *)
and attr = object
  inherit node
  method ownerElement : element t opt readonly_prop
end

(** Specification of [Element] objects. *)
and element = object
  inherit node

  method setAttributeNode : attr t -> attr t opt meth
  method removeAttributeNode : attr t -> attr t meth
  method getAttributeNodeNS : js_string t -> js_string t -> attr t opt meth
  method setAttributeNodeNS : attr t -> attr t opt meth
  method firstElementChild : element t opt readonly_prop
  method lastElementChild : element t opt readonly_prop
  method previousElementSibling : element t opt readonly_prop
  method nextElementSibling : element t opt readonly_prop
end



(** Specification of [Document] objects. *)
class type ['element] document = object
  inherit node

  method documentElement : 'element t readonly_prop

end
