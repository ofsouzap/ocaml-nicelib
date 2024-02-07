open Utils

let functor_id fmap arb =
  QCheck.Test.make ~name:"Functor - identity"
  arb
  ( fun fx ->
    (fmap id fx) = fx )

let functor_compose fmap arb f_arb =
  QCheck.Test.make ~name:"Functor - composition"
  QCheck.(triple arb f_arb f_arb)
  ( fun (fx,f',g') ->
    let f, g = QCheck.Fn.apply f', QCheck.Fn.apply g' in
    (fmap f -.- fmap g) fx = fmap (f -.- g) fx  )

let functor_suite fmap arb f_arb = List.map QCheck_alcotest.to_alcotest
  [ functor_id fmap arb
  ; functor_compose fmap arb f_arb ]
