open Nicelib

let test_fun_compose =
  QCheck.Test.make ~count:1000 ~name:"Function composition"
  QCheck.(triple (fun1 Observable.int int) (fun1 Observable.int int) int)
  ( fun (f',g',x) ->
    let f,g = QCheck.Fn.apply f', QCheck.Fn.apply g' in
    (f -.- g) x = f (g (x)) )

let suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_compose ]

let () =
  Alcotest.run "Nicelib"
  [ "", suite ]