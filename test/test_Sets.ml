open Nicelib.Sets

let my_tiny_int = QCheck.int_bound 20

let test_empty_int =
  "Empty", `Quick, ( fun () -> Alcotest.(check (list int)) "" [] (list_of_set vide) )

let test_singleton =
  QCheck.Test.make ~count:1000 ~name:"Singleton"
  QCheck.int
  ( fun x -> list_of_set (singleton x) = [x])

let suite_contruction =
  test_empty_int
  :: List.map QCheck_alcotest.to_alcotest
  [ test_singleton ]

let test_add =
  QCheck.Test.make ~count:100 ~name:"Add"
  QCheck.(pair (set_arb_max 10 int) int)
  ( fun (xs, x) ->
    member x (add x xs) )

let suite_unaire = List.map QCheck_alcotest.to_alcotest
  [ test_add ]

let test_intersection_maybe_contains =
  QCheck.Test.make ~count:1000 ~name:"Intersection"
  QCheck.(triple (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int)
  ( fun (xs,ys,z) -> let zs = intersection xs ys in
    member z zs = (member z xs && member z ys) )

let test_intersection_one_or_two_contain =
  QCheck.Test.make ~count:1000 ~name:"Intersection within"
  QCheck.(quad (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int bool)
  ( fun (xs',ys',z,b) ->
    let xs = if b then add z xs' else xs' in
    let ys = if b then ys' else add z ys' in
    let zs = intersection xs ys in
    member z zs = (member z xs && member z ys) )

let test_intersection_both_contain =
  QCheck.Test.make ~count:1000 ~name:"Intersection in both"
  QCheck.(triple (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int)
  ( fun (xs',ys',z) ->
    let xs = add z xs' in
    let ys = add z ys' in
    let zs = intersection xs ys in
    member z zs )

let test_union_maybe_contains =
  QCheck.Test.make ~count:1000 ~name:"Union"
  QCheck.(triple (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int)
  ( fun (xs,ys,z) -> let zs = union xs ys in
    member z zs = (member z xs || member z ys) )

let test_union_one_or_two_contain =
  QCheck.Test.make ~count:1000 ~name:"Union within"
  QCheck.(quad (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int bool)
  ( fun (xs',ys',z,b) ->
    let xs = if b then add z xs' else xs' in
    let ys = if b then ys' else add z ys' in
    let zs = union xs ys in
    member z zs )

let test_union_both_contain =
  QCheck.Test.make ~count:1000 ~name:"Union in both"
  QCheck.(triple (set_arb_max 10 my_tiny_int) (set_arb_max 10 my_tiny_int) my_tiny_int)
  ( fun (xs',ys',z) ->
    let xs = add z xs' in
    let ys = add z ys' in
    let zs = union xs ys in
    member z zs )

let test_equal_when_equal =
  QCheck.Test.make ~count:0 ~name:"equal quand equal"
  (QCheck.make @@ QCheck.Gen.(list int >>= ( fun xs -> pair (return xs) (shuffle_l xs)) ))
  ( fun (xs',ys') ->
    let xs = set_of_list xs' in
    let ys = set_of_list ys' in
    equal xs ys )

let test_equal_not_equal =
  QCheck.Test.make ~count:0 ~name:"equal quand pas equal"
  QCheck.(triple (list int) (list int) int)
  ( fun (xs'',ys',z) -> if List.mem z ys'
    then true
    else
      let xs' = z::xs'' in
      let xs = set_of_list xs' in
      let ys = set_of_list ys' in
      not (equal xs ys) )

let binary_suite = List.map QCheck_alcotest.to_alcotest
  [ test_intersection_maybe_contains
  ; test_intersection_one_or_two_contain
  ; test_intersection_both_contain
  ; test_union_maybe_contains
  ; test_union_one_or_two_contain
  ; test_union_both_contain
  ; test_equal_when_equal
  ; test_equal_not_equal ]

let () =
  let open Alcotest in
  run "Sets"
  [ "Construction", suite_contruction
  ; "Unary operations", suite_unaire
  ; "Binary operations", binary_suite ]
