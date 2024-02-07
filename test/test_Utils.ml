open Nicelib.Utils

let test_fun_compose =
  QCheck.Test.make ~count:1000 ~name:"Function composition"
  QCheck.(triple (fun1 Observable.int int) (fun1 Observable.int int) int)
  ( fun (f',g',x) ->
    let f,g = QCheck.Fn.apply f', QCheck.Fn.apply g' in
    (f -.- g) x = f (g (x)) )

let test_id =
  QCheck.Test.make ~count:1000 ~name:"Identity function"
  QCheck.(int)
  ( fun x ->
    x = id x )

let test_const =
  QCheck.Test.make ~count:1000 ~name:"Constant function"
  QCheck.(pair int int)
  ( fun (x,y) ->
    x = const x y )

let test_flip =
  QCheck.Test.make ~count:1000 ~name:"Flip function"
  QCheck.(triple (fun2 Observable.int Observable.int int) int int)
  ( fun (f',x,y) ->
    let f = QCheck.Fn.apply f' in
    flip f x y = f y x )

let suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_compose
  ; test_id
  ; test_const
  ; test_flip ]

let () =
  Alcotest.run "Nicelib"
  [ "", suite ]
