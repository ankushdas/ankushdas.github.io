type prop =
  | And of prop * prop
  | Impl of prop * prop
  | Or of prop * prop
  | Top
  | Bot
  | Atom of string

let rec equal gamma gamma' =
  match gamma with
  | a::tl -> List.exists (fun a' -> a = a') gamma' && equal tl gamma'
  | [] -> true

let loop memo (gamma, prop) =
  List.exists (fun (gamma', prop') -> prop = prop' && equal gamma gamma' && equal gamma' gamma) memo

let rec invR memo gamma omega prop =  (* gamma ; omega --R--> prop *)
  match prop with
  | And(a, b) -> invR memo gamma omega a && invR memo gamma omega b
  | Impl(a, b) -> invR memo gamma (a::omega) b
  | Top -> true
  | x -> invL memo gamma omega x

and invL memo gamma omega c =     (* gamma ; omega  --L--> c *)
  match omega with
  | And(a, b)::omega' -> invL memo gamma (a::b::omega') c
  | Or(a, b)::omega' -> invL memo gamma (a::omega') c && invL memo gamma (b::omega') c
  | Top::omega' -> invL memo gamma omega' c
  | Bot::_omega' -> true
  | x::omega' -> invL memo (x::gamma) omega' c
  | [] -> choice memo gamma c

and choice memo gamma prop =     (* gamma --C--> prop *)
  if loop memo (gamma, prop) then false
  else choiceR ((gamma, prop)::memo) gamma prop || choiceL ((gamma, prop)::memo) gamma prop

and choiceR memo gamma prop =
  match prop with
  | Or(a, b) -> invR memo gamma [] a || invR memo gamma [] b
  | Atom(p) -> List.exists (fun q -> q = Atom(p)) gamma
  | _ -> false    (* dead code *)

and choiceL memo gamma prop =
  List.exists
    (fun p -> match p with
              | Impl(a, b) -> invR memo gamma [] a && invL memo gamma [b] prop
              | Atom(_p) -> false
              | _ -> false
    )
  gamma