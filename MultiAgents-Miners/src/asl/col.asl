pos(boss,15,15).
checking_cells.
resource_needed(1).

+my_pos(X,Y)
   :  checking_cells & not building_finished
   <- !warn_others_about_resource;                          // check if there is any resources
      !check_for_resources.
   

+!warn_others_about_resource : found(R) & my_pos(X,Y)       // if any resource is found at (X,Y)
   <- +found_resource_at(R,X,Y);                            // saves location
      .print("Warning others about Resource ",R," found at (",X,",",Y,")");
      .broadcast(tell, found_resource_at(R,X,Y)).           // warn others about the location


+found_resource_at(R,X,Y) : true.


// If the miner receives a message warning that the resource is over at (X,Y),
// it checks if there are any other known locations. If there is,
// the miner goes to the location, otherwise it keeps looking.
-found_resource_at(R,X,Y) : pos(back,X,Y)
	<-  +pos(back,X,Y);
      +checking_cells;
      !check_for_resources.
   
+!warn_others_about_resource : not found(R)
   <- true.

// If miner finds current needed resource
+!check_for_resources
   :  resource_needed(R) & found(R)
   <- !stop_checking;
      !take(R,boss);
      !continue_mine.
	  
// If miner dont find current needed resource, and there is no known location of it
+!check_for_resources
   :  resource_needed(R) & not found(R) & not found_resource_at(R,X,Y)
   <- .wait(200);
   		move_to(next_cell).


// If miner doesnt find current needed resource at the current cell but there is
// a known location of it elsewhere
+!check_for_resources
   :  resource_needed(R) & not found(R) & found_resource_at(R,P,Q)
   <- ?my_pos(X,Y);
   	  +pos(back,P,Q);
      -checking_cells;
	    !continue_mine.

+!stop_checking : true
   <- ?my_pos(X,Y);
      +pos(back,X,Y);
      -checking_cells.

+!take(R,B) : true
   <- .wait(200);
   	  mine(R);
      !go(B);
      drop(R).

+!continue_mine : true
   <- !go(back);
   	  !check_for_remaining_resource;
      -pos(back,X,Y);
      +checking_cells;
      !check_for_resources.

// Checks if there is still R on the cell
+!check_for_remaining_resource : resource_needed(R) & found(R)
	<- true.

// If there is not is not R left on the cell, warn other about it
+!check_for_remaining_resource : resource_needed(R) & not found(R) 
	<- -found_resource_at(R,X,Y);
	.broadcast(untell,found_resource_at(R,X,Y)).
	
+!go(Position) 
   :  pos(Position,X,Y) & my_pos(X,Y)
   <- true.

+!go(Position) : true
   <- ?pos(Position,X,Y);
      .wait(100);
      move_towards(X,Y);
      !go(Position).

@psf[atomic]
+!search_for(NewResource) : resource_needed(OldResource)
   <- +resource_needed(NewResource);
      -resource_needed(OldResource).

@pbf[atomic]
+building_finished : true
   <- .drop_all_desires;
      !go(boss).
