#!/usr/bin/bash

DIR=.
SWH=/home/angeletti/.opam/5.6.0+tests
CC=$SWH/bin/ocamlc.opt
CCOPT=$SWH/bin/ocamlopt.opt
FLAGS=" -w -a -no-alias-deps"

BUILD=_build

clean () {
mkdir -p $DIR/$BUILD

rm -rf $DIR/$BUILD/*
}
clean
echo Start!
$CC $FLAGS -I $BUILD -o $BUILD/js_of_ocaml_lwt.cmo -c -impl js_of_ocaml_lwt.ml-gen
$CC $FLAGS -I $BUILD -o $BUILD/js_of_ocaml__.cmo -c -impl js_of_ocaml__.ml-gen
$CC $FLAGS -I $BUILD -open Js_of_ocaml__ -o $BUILD/js_of_ocaml__Js.cmi -c -intf js.mli
$CC $FLAGS -I $BUILD -open Js_of_ocaml__ -o $BUILD/js_of_ocaml__Dom.cmi -c -intf dom.mli
$CC $FLAGS -I $BUILD -open Js_of_ocaml__ -o $BUILD/js_of_ocaml__XmlHttpRequest.cmi -c -intf xmlHttpRequest.mli
$CC $FLAGS -I $BUILD -open Js_of_ocaml__ -o $BUILD/js_of_ocaml.cmo -c -impl js_of_ocaml.ml
$CC $FLAGS -I $BUILD -open Js_of_ocaml_lwt -o $BUILD/js_of_ocaml_lwt__Lwt_xmlHttpRequest.cmi -c -intf lwt_xmlHttpRequest.mli


echo "Troubles start now"

time $CC $FLAGS3 -I $BUILD -I $SWH/lib/lwt -I $BUILD -cmi-file $BUILD/js_of_ocaml_lwt__Lwt_xmlHttpRequest.cmi -open Js_of_ocaml_lwt -o $BUILD/js_of_ocaml_lwt__Lwt_xmlHttpRequest.cmo -c -impl lwt_xmlHttpRequest.ml -i
