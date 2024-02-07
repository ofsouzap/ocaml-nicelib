open Nicelib.Monad

let test_fun_return_list =
  QCheck.Test.make ~count:1000 ~name:"Return List"
  QCheck.(int)
  ( fun x ->
    return_list x = [x] )

let test_fun_return_opt =
  QCheck.Test.make ~count:1000 ~name:"Return Option"
  QCheck.(int)
  ( fun x ->
    return_opt x = Some x )

(* let test_fun_bind_list =
  QCheck.Test.make ~count:1000 ~name:"Bind List"
  QCheck.(pair (list (fun1 Observable.int int)) (list int))
  ( fun (fs',xs) ->
    let fs = List.map QCheck.Fn.apply fs' in
    failwith "TODO" ) *)

let test_fun_bind_opt =
  QCheck.Test.make ~count:1000 ~name:"Bind Option"
  QCheck.(pair (fun1 Observable.int (option int)) (option int))
  ( fun (f',x_opt) ->
    let f = QCheck.Fn.apply f' in
    match x_opt with
      | None -> None = (x_opt >>=? f)
      | Some x -> ( match f x with
        | None -> None = (x_opt >>=? f)
        | Some _ as y -> y = (x_opt >>=? f) ) )

let suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_return_list
  ; test_fun_return_opt
  (* ; test_fun_bind_list *)
  ; test_fun_bind_opt ]

let () =
  Alcotest.run "Monad"
  [ "", suite ]
