pos(boss,15,15).
checking_cells.
resource_needed(1).

+my_pos(X,Y)
   :  checking_cells & not building_finished
   <- !warn_others_about_resource;                          // check if there is any resources
      !check_for_resources.
   

+!warn_others_about_resource : found(R) & my_pos(X,Y)       // if any resource is found at (X,Y)
   <- +resource_location((math.abs(15-X)+math.abs(15-Y)), R,X,Y);                            // saves location
      .print("Warning others about Resource ",R," found at (",X,",",Y,") with distance (",(math.abs(15-X)+math.abs(15-Y)),")");
      .broadcast(tell, resource_location((math.abs(15-X)+math.abs(15-Y)), R,X,Y)).           // warn others about the location


//+resource_location(R,X,Y,D) : true.

+resource_location(R,X,Y,D)[source (A)] : true <- .print("Colector ",A," found something").


// If the miner receives a message warning that the resource finished at (X,Y),
// and it has variable 'back' stored, it goes back and looks for more resources
-resource_location(D,R,X,Y) : pos(back,X,Y)
	<-  +pos(back,X,Y);
      +checking_cells;
      !check_for_resources.
   
+!warn_others_about_resource : not found(R) // if it tries to warn others but nothing was found, just pass
   <- true.

// If miner finds current needed resource
+!check_for_resources
   :  resource_needed(R) & found(R)
   <- !stop_checking;
      !take(R,boss);
      !continue_mine.
	  
// If miner dont find current needed resource, and there is no known location of it
+!check_for_resources
   :  resource_needed(R) & not found(R) & not resource_location(D,R,X,Y)
   <- .wait(200);
   		move_to(next_cell).


// If miner doesnt find current needed resource at the current cell but there is
// a known location of it elsewhere
+!check_for_resources
   :  resource_needed(R) & not found(R) & resource_location(D,R,P,Q)
   <- ?my_pos(X,Y);
   	  +pos(back,P,Q);
      -checking_cells;
	    !continue_mine.

//+!check_for_resources
//   :  resource_needed(R) & not found(R) & resource_location(D,R,P,Q)
//   <-
//   .findall(locs(D,X,Y), resource_location(D,R,X,Y), T);  // adds to T all known locations for resource R
//   .sort(T,V);                                           // adds to V the ordered list T
//      ?my_pos(X,Y);
//  	  +pos(back,P,Q);
//      -checking_cells;
//	    !continue_mine.

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
	<- -resource_location(D,R,X,Y);
	.broadcast(untell, resource_location(D,R,X,Y)).
	
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
      .print("Finished! Boss, here I come!");
      !go(boss).
