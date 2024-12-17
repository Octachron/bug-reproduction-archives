dune:
	dune build
manual:
	mkdir -p _build_manual
	ocamlopt -I +compiler-libs ocamlcommon.cmxa manual_ppx/identity.ml -o _build_manual/identity
	ocamlopt -ppx ./_build_manual/identity src/value.mli -c -o _build_manual/value.cmi
	ocamlopt -ppx ./_build_manual/identity -I _build_manual  src/symbol.mli -c -o _build_manual/symbol.cmi
	ocamlopt -I _build_manual -ppx ./_build_manual/identity src/form.ml -o _build_manual/test
	ocamlopt -I _build_manual -ppx "_build/default/.ppx/39fb6e3a696afc8cdb3e70e6d147d02b/ppx.exe -as-ppx" src/form.ml -o _build_manual/test
