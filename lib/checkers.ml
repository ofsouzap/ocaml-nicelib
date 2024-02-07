open Utils
open Applicative

(* Monoid laws found at https://wiki.haskell.org/Monoid *)

let monoid_id_l mempty mappend arb =
  QCheck.Test.make ~name:"Monoid - left identity"
  arb
  ( fun mx ->
    mappend mempty mx = mx )

let monoid_id_r mempty mappend arb =
  QCheck.Test.make ~name:"Monoid - right identity"
  arb
  ( fun mx ->
    mappend mx mempty = mx )

let monoid_associativity _ mappend arb =
  QCheck.Test.make ~name:"Monoid - associativity"
  QCheck.(triple arb arb arb)
  ( fun (mx,my,mz) ->
    mappend (mappend mx my) mz = mappend mx (mappend my mz) )

let monoid_suite mempty mappend arb = List.map QCheck_alcotest.to_alcotest
  [ monoid_id_l mempty mappend arb
  ; monoid_id_r mempty mappend arb
  ; monoid_associativity mempty mappend arb ]

(* Functor laws found at https://wiki.haskell.org/Functor#Functor_Laws *)

let functor_id fmap arb _ =
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
  [ functor_id fmap arb f_arb
  ; functor_compose fmap arb f_arb ]

(* Applicative laws found at https://hackage.haskell.org/package/base-4.19.0.0/docs/Control-Applicative.html *)

let applicative_id pure ap a_arb _ =
  QCheck.Test.make ~name:"Applicative - identity"
  a_arb
  ( fun ax ->
    ap (pure id) ax = ax )

let applicative_composition _ _ arb f_arb =
  QCheck.Test.make ~name:"Applicative - composition"
  QCheck.(triple arb f_arb f_arb)
  ( const true ) (* TODO - make this test *)

let applicative_homomorphism_list arb f_arb =
  QCheck.Test.make ~name:"Applicative - homomorphism"
  QCheck.(pair arb f_arb)
  ( fun (x,f') ->
    let f = QCheck.Fn.apply f' in
    (pure_list f <*>.. [x]) = [f x] )

let applicative_homomorphism_opt arb f_arb =
  QCheck.Test.make ~name:"Applicative - homomorphism"
  QCheck.(pair arb f_arb)
  ( fun (x,f') ->
    let f = QCheck.Fn.apply f' in
    (pure_opt f <*>? Some x) = Some (f x) )

let applicative_list_suite arb f_arb = List.map QCheck_alcotest.to_alcotest
  [ applicative_id pure_list ( <*>.. ) arb f_arb
  ; applicative_composition pure_list ( <*>.. ) arb f_arb
  ; applicative_homomorphism_list arb f_arb ]

let applicative_opt_suite arb f_arb = List.map QCheck_alcotest.to_alcotest
  [ applicative_id pure_opt ( <*>? ) arb f_arb
  ; applicative_composition pure_opt ( <*>? ) arb f_arb
  ; applicative_homomorphism_opt arb f_arb ]
