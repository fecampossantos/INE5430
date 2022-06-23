// Beliefs
position(builder,10,10).
looking_for_gold.
resource_needed(1).


!look_for_gold.


// Plans
+current_miner_position(X,Y)
   :  looking_for_gold & not finished_collecting
   <- !look_for_gold.


+!look_for_gold[source(ME)]
   :  found
   <- !stop_looking; // saves current position at 'back' and stops looking
      ?current_miner_position(X,Y);
      .broadcast(tell, miner_found_gold(X,Y)); // tells other miners that gold was found at (X,Y)
      !take_to(builder);
      !keep_mining.
  
+!look_for_gold
   :  not found
   <- !check_for_known_gold_location.
   

+!check_for_known_gold_location
    : .count(gold_location(_,_)) > 0 & .setof(st(X,Y), gold_location(X,Y), T)
      & .sort(T, S) & .nth(0, S, B)
    <- .print(B);
       .print("-> ",P,",",Q);
       //!move_to_gold_cell(B.X,B.Y); // COMO PEGAR X E Y DE B (st(X,Y))
       !look_for_gold.


+!check_for_known_gold_location
    : not .count(gold_location(_,_)) > 0
    <- move_to(next_cell).

+miner_found_gold(X,Y)[source(MINER)]
    <- .print("Adding gold (",X, ",",Y, ") place to memory, found by ", MINER);
       +gold_location(X,Y).

// move to cell that miner found gold
+!move_to_gold_cell(X,Y)
    <- +position(gold_cell,X,Y);
    !go(gold_cell).
    -position(gold_cell,X,Y).

+!stop_looking : true
   <- ?current_miner_position(X,Y);
      +position(back,X,Y);                           
      -looking_for_gold.

+!take_to(B) : true
   <- mine;
      !go(B);
      drop.

+!keep_mining : true
   <- !go(back);
      -position(back,X,Y);
      +looking_for_gold;
      !look_for_gold.

+!go(Position)
   :  position(Position,X,Y) & current_miner_position(X,Y)
   <- true.

+!go(Position) : true
   <- ?position(Position,X,Y);
      move_towards(X,Y);
      !go(Position).

@psf[atomic]
+!search_for(NewResource) : resource_needed(OldResource)
   <- +resource_needed(NewResource);
      -resource_needed(OldResource).

@pbf[atomic]
+finished_collecting : true
   <- .drop_all_desires;
      !go(builder).