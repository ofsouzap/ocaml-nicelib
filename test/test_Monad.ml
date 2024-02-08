open Nicelib.Monad

let my_small_list =
  let open QCheck in
  list_of_size (Gen.int_bound 20)

let rec my_bind_list xs f = match xs with
  | [] -> []
  | h::ts -> f h @ my_bind_list ts f

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

let test_fun_bind_list =
  QCheck.Test.make ~count:1000 ~name:"Bind List"
  QCheck.(pair (fun1 Observable.int (my_small_list int)) (my_small_list int))
  ( fun (f',xs) ->
    let f = QCheck.Fn.apply f' in
    my_bind_list xs f = (xs >>=.. f) )

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

let return_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_return_list
  ; test_fun_return_opt ]

let bind_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_bind_list
  ; test_fun_bind_opt ]

let () =
  Alcotest.run "Monad"
  [ "Return implementation", return_suite
  ; "Bind implementation", bind_suite ]
