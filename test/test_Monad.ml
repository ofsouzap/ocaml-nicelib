open Nicelib
open Nicelib.Monad
open Nicelib.Checkers

let my_small_list =
  let open QCheck in
  list_of_size (Gen.int_bound 20)

let my_small_set arb =
  Sets.set_arb_max 20 arb

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

let test_fun_return_set =
  QCheck.Test.make ~count:1000 ~name:"Return Set"
  QCheck.(int)
  ( fun x ->
    return_set x = Sets.singleton x )

let return_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_return_list
  ; test_fun_return_opt
  ; test_fun_return_set ]

let bind_suite = List.map QCheck_alcotest.to_alcotest
  [ test_fun_bind_list
  ; test_fun_bind_opt ]
  (* TODO - test set bind impl *)

let () =
  Alcotest.run "Monad"
  [ "Return implementation", return_suite
  ; "Bind implementation", bind_suite
  ; "Option monad", monad_suite return_opt ( >>=? ) QCheck.(option int) QCheck.(fun1 Observable.int (option int)) QCheck.int
  ; "List monad", monad_suite return_list ( >>=.. ) QCheck.(my_small_list int) QCheck.(fun1 Observable.int (my_small_list int)) QCheck.int
  ; "Set monad", monad_suite return_set ( >>=~~ ) QCheck.(my_small_set int) QCheck.(fun1 Observable.int (my_small_set int)) QCheck.int ]
