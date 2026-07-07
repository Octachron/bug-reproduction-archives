OCAMLC=ocamlc

function compile {
   $OCAMLC -c $1.mli -o $1.cmi
}

for i in js dom url typed_array file promise fontFace dom_html form abort fetch xmlHttpRequest
do
    if [ ! -f $i.cmi ];  then
       echo $i;
       compile $i;
    fi
done
$OCAMLC -c reproducer.ml
