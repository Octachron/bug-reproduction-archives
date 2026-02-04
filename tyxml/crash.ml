type a = [ `A of (int -> int)]
type b = [ `B ]

type core = [ a | b ]
type extended = [ core | `N of core]
type restricted = [ a | `N of [ | a ] ]

type +'a inbetween = [< extended  > `A ] as 'a

type x = { x: 'a. 'a inbetween }

let f {x} = (x : [ | a] :> restricted)


type f = { f: 'a. 'a inbetween -> 'a }
let id = { f = Fun.id }

let example = (id.f :> restricted -> restricted)
let wrong = (id.f:> extended -> restricted)

let ok = (id.f:> extended -> restricted)


let crash = match wrong (`N `B) with
  | `A _ -> ()
  | `N `A f -> Format.eprintf "%d@." (f 2)

