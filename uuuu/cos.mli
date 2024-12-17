 module OS: sig
    module File: sig
       val with_oc:       ?mode:int ->unit ->
      (out_channel -> 'a -> (('c, 'd) result as 'b)) ->
      'a -> ('b, 'e) result
    end
end
