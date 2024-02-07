open Nicelib.Applicative

let rec my_ap_list fs xs = match (fs,xs) with
  | fh::fts, xh::xts -> fh xh :: my_ap_list fts xts
  | _, _ -> []

let test_fun_pure_list =
  QCheck.Test.make ~count:1000 ~name:"Pure List"
  QCheck.(int)
  ( fun x ->
    pure_list x = [x] )

let test_fun_pure_opt =
  QCheck.Test.make ~count:1000 ~name:"Pure Option"
  QCheck.(int)
  ( fun x ->
    pure_opt x = Some x )

let test_fun_ap_list =
  QCheck.Test.make ~count:1000 ~name:"Ap List"
  QCheck.(pair (list (fun1 Observable.int int)) (list int))
  ( fun (fs',xs) ->
    let fs = List.map QCheck.Fn.apply fs' in
    my_ap_list fs xs = (fs <*>.. xs) )

let test_fun_ap_opt =
  QCheck.Test.make ~count:1000 ~name:"Ap Option"
  QCheck.(pair (option (fun1 Observable.int int)) (option int))
  ( fun (f_opt',x_opt) ->
    match (f_opt',x_opt) with
      | Some f', Some x -> let f = QCheck.Fn.apply f' in Some (f x) = (Some f <*>? Some x)
      | _, x_opt -> None = (None <*>? x_opt) )

let suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_pure_list
  ; test_fun_pure_opt
  ; test_fun_ap_list
  ; test_fun_ap_opt ]

let () =
  Alcotest.run "Applicative"
  [ "", suite ]
