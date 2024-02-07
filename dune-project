(lang dune 3.13)

(name nicelib)

(generate_opam_files true)

(source
 (github Ofsouzap/ocaml-nicelib))

(authors "Ofsouzap")

(maintainers "Ofsouzap")

(license MIT)

(package
 (name nicelib)
 (synopsis "Helpful stuff to make stuff easier")
 (depends ocaml dune alcotest qcheck qcheck-alcotest))
