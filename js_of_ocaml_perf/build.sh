OCAMLC=ocamlc

function compile_mli {
   $OCAMLC -c $1.mli -o $1.cmi
}

function compile_ml {
   $OCAMLC -c $1.ml -o $1.cmo
}

mls=lwt_xmlHttpRequest
mlis="js dom url typed_array file promise fontFace dom_html form abort fetch xmlHttpRequest $mls"
for i in $mlis
do
    if [ ! -f $i.cmi ];  then
       echo "$i(mli)";
       compile_mli $i;
    fi
done

for i in $mls
do
    if [ ! -f $i.cmo ];  then
       echo "$i(ml)";
       compile_ml $i;
    fi
done
