open Nicelib.Functor

let test_fun_fmap_list =
  QCheck.Test.make ~count:1000 ~name:"Fmap List"
  QCheck.(pair (fun1 Observable.int int) (list int))
  ( fun (f',xs) ->
    let f = QCheck.Fn.apply f' in
    List.map f xs = (f <$>.. xs) )

let test_fun_fmap_opt =
  QCheck.Test.make ~count:1000 ~name:"Fmap Option"
  QCheck.(pair (fun1 Observable.int int) (option int))
  ( fun (f',x_opt) ->
    let f = QCheck.Fn.apply f' in
    let exp = match x_opt with
      | None -> None
      | Some x -> Some (f x)
    in
    exp = (f <$>? x_opt) )

let suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_fmap_list
  ; test_fun_fmap_opt ]

let () =
  Alcotest.run "Functor"
  [ "", suite ]
