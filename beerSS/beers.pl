% reference:
% https://www.bjcp.org/beer-styles
% organization:
% https://docs.google.com/spreadsheets/d/10-HcrYnJYhnwA7zPuetxf1LHuU76keefFe7vyGb8TcM/edit?usp=sharing

%% THIS IS A SIMPLIFIED SPECIALIST SYSTEM

% % % % % % % % % % % % % % % %
%           BEER NAMES        %
% % % % % % % % % % % % % % % %
name(al,"American Lager").
name(ca,"Cream Ale").
name(wb,"Weissbier").
name(ra,"Red Ale").
name(ba,"Blonde Ale").
name(pa,"Pale Ale").
name(is,"Imperial Stout").
name(ip,"IPA").
name(go,"Gose").
name(wi,"Witbier").
name(cs,"Catharina Sour").
name(mb,"Malzbier").


% % % % % % % % % % % % % % % %
%       CHARACTERISTICS       %
%   aroma, flavor and body    %
% % % % % % % % % % % % % % % %

aroma(sweet).
aroma(malted).
aroma(fruity).
aroma(hop).
aroma(dry).

flavor(crisp).
flavor(sweet).
flavor(malty).
flavor(dry).

body(smooth).
body(creamy).
body(light).


% % % % % % % % % % % % % % % %
%     BEER CHARACTERISTICS    %
% % % % % % % % % % % % % % % %
characteristics(al, Aroma, Flavor, Body, IBU) :- (Aroma = sweet),   (Flavor = crisp), (Body = smooth),!.
characteristics(ca, Aroma, Flavor, Body, IBU) :- (Aroma = malted),  (Flavor = sweet), (Body = creamy),!.
characteristics(wb, Aroma, Flavor, Body, IBU) :- (Aroma = fruity),  (Flavor = sweet), (Body = creamy),!.
characteristics(ra, Aroma, Flavor, Body, IBU) :- (Aroma = malted),  (Flavor = sweet), (Body = smooth),!.
characteristics(mb, Aroma, Flavor, Body, IBU) :- (Aroma = malted),  (Flavor = sweet), (Body = creamy),!.
characteristics(ba, Aroma, Flavor, Body, IBU) :- (Aroma = malted),  (Flavor = malty), (Body = smooth),!.
characteristics(pa, Aroma, Flavor, Body, IBU) :- (Aroma = hop),     (Flavor = malty), (Body = smooth),!.
characteristics(is, Aroma, Flavor, Body, IBU) :- (Aroma = dry),     (Flavor = dry),   (Body = creamy),!.
characteristics(ip, Aroma, Flavor, Body, IBU) :- (Aroma = dry),     (Flavor = dry),   (Body = light), !.
characteristics(go, Aroma, Flavor, Body, IBU) :- (Aroma = fruity),  (Flavor = crisp), (Body = light), !.
characteristics(wi, Aroma, Flavor, Body, IBU) :- (Aroma = sweet),   (Flavor = sweet), (Body = light), !.
characteristics(cs, Aroma, Flavor, Body, IBU) :- (Aroma = fruity),  (Flavor = crisp), (Body = light), !.


% % % % % % % % % % % % % % % %
%             FOOD            %
% % % % % % % % % % % % % % % %

pasta(tomato).
pasta(garlic).
pasta(pesto).

meat(chicken).
meat(pork).
meat(beef).

appetizer(ham).
appetizer(peanuts).
appetizer(chips).
appetizer(nachos).
appetizer(pizza).

dessert(chocolate).
dessert(cake).
dessert(fruits).

food(pasta).
food(meat).
food(appetizer).
food(dessert).

% % % % % % % % % % % % % % % %
%             CHOICE          %
% % % % % % % % % % % % % % % %
% best_choice() :-


% % % % % % % % % % % % % % % %
%          BEER RULES         %
% % % % % % % % % % % % % % % %


%% SPECIFICS %%

% Pale Ale
%   if aroma = hop and
%     flavor = malty and
%     body = smooth
%   THEN
%     best_beer = Pale Ale
best_beer(pa, Aroma, Flavor, Body) :- (Aroma = hop), (Flavor = malty), (Body = smoot),!.

% WitBier
%   if aroma = sweet and
%     flavor = sweet and
%     body = light
%   THEN
%     best_beer = WitBier
best_beer(wi, Aroma, Flavor, Body) :- (Aroma = sweet), (Flavor = sweet), (Body = light),!.

% Cream Ale or Malzbier
%   if aroma = malted and
%     flavor = sweet and
%     body = creamy
%   THEN
%     best_beer = Cream Ale or
%     best_beer = Malzbier
best_beer(ca, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweet), (Body = creamy).
best_beer(mb, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweet), (Body = creamy),!.

% IPA
%   if aroma = dry and
%     flavor = dry and
%     body = light
%   THEN
%     best_beer = IPA
best_beer(ip, Aroma, Flavor, Body) :- (Aroma = dry), (Flavor = dry), (Body = light),!.

% Catharina Sour or Gose
%   if aroma = fruity and
%     flavor = crisp and
%     body = light
%   THEN
%     best_beer = Catharina Sour or
%     best_beer = Gose
best_beer(cs, Aroma, Flavor, Body) :- (Aroma = fruity), (Flavor = crisp), (Body = light).
best_beer(go, Aroma, Flavor, Body) :- (Aroma = fruity), (Flavor = crisp), (Body = light),!.

% Red Ale
%   if aroma = malted and
%     flavor = sweet and
%     body = smooth
%   THEN
%     best_beer = Red Ale
best_beer(ra, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweeet), (Body = smooth),!.


% Weissbier
%   if aroma = fruity and
%     flavor = sweet and
%     body = creamy
%   THEN
%     best_beer = Weissbier
best_beer(wb, Aroma, Flavor, Body) :- (Aroma = fruity), (Flavor = sweet), (Body = creamy),!.

% American Lager
%   if aroma = sweet and
%     flavor = crisp and
%     body = smooth
%   THEN
%     best_beer = American Lager
best_beer(al, Aroma, Flavor, Body) :- (Aroma = sweet), (Flavor = crisp), (Body = smooth),!.

% Imperial Stout
%   if aroma = dry and
%     flavor = dry and
%     body = creamy
%   THEN
%     best_beer = Imperial Stour
best_beer(is, Aroma, Flavor, Body) :- (Aroma = dry), (Flavor = dry), (Body = creamy),!.

% Blonde Ale
%   if aroma = malted and
%     flavor = malty and
%     body = smooth
%   THEN
%     best_beer = Blonde Ale
best_beer(ba, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = malty), (Body = smooth),!.



%% EXTRA %%

%% aroma and flavor
% aroma = malted and flavor = sweet
best_beer(ca, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweet).
best_beer(ra, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweet).
best_beer(mb, Aroma, Flavor, Body) :- (Aroma = malted), (Flavor = sweet),!.

% aroma = dry and flavor = dry
best_beer(is, Aroma, Flavor, Body) :- (Aroma = dry), (Flavor = dry).
best_beer(ip, Aroma, Flavor, Body) :- (Aroma = dry), (Flavor = dry),!.

%% aroma and body %%

% aroma = malted and body = creamy
best_beer(ca, Aroma, Flavor, Body) :- (Aroma = malted), (Body = creamy).
best_beer(mb, Aroma, Flavor, Body) :- (Aroma = malted), (Body = creamy),!.

%% flavor and body %%

% flavor = sweet and body = creamy
best_beer(ca, Aroma, Flavor, Body) :- (Flavor = sweet), (Body = creamy).
best_beer(wb, Aroma, Flavor, Body) :- (Flavor = sweet), (Body = creamy).
best_beer(mb, Aroma, Flavor, Body) :- (Flavor = sweet), (Body = creamy),!.

% flavor = malty and body = smooth
best_beer(ba, Aroma, Flavor, Body) :- (Flavor = malty), (Body = smooth).
best_beer(pa, Aroma, Flavor, Body) :- (Flavor = malty), (Body = smooth),!.

% flavor = crispy and body = light
best_beer(go, Aroma, Flavor, Body) :- (Flavor = crisp), (Body = light).
best_beer(cs, Aroma, Flavor, Body) :- (Flavor = crisp), (Body = light),!.


% % % % % % % % % % % % % % % %
%          FOOD RULES         %
% % % % % % % % % % % % % % % %

% RULE : Pale Ale
%   if food == pasta
%     and plate = tomato
%   THEN
%     flavor = malty and
%     body = smooth
pairing(Beer_Name, pasta, tomato) :- best_beer(Beer_Code, _, malty, smooth), name(Beer_Code, Beer_Name).

% RULE : WitBier
%   if food == pasta
%     and plate = garlic
%   THEN
%     aroma = sweet and
%     body = light
pairing(Beer_Name, pasta, garlic) :- best_beer(Beer_Code, sweet, _, light), name(Beer_Code, Beer_Name).


% RULE : Cream Ale or Malzbier
%   if food == pasta
%     and plate = pesto
%   THEN
%     aroma = malted and
%     flavor = sweet and
%     body = creamy
pairing(Beer_Name, pasta, pesto) :- best_beer(Beer_Code, malted, sweet, creamy), name(Beer_Code, Beer_Name).

% RULE :
%   if food == meat
%     and plate = chicken
%   THEN
%     body = light
pairing(Beer_Name, meat, chicken) :- best_beer(Beer_Code, _, _, light), name(Beer_Code, Beer_Name).

% RULE : Catharina Sour or Gose
%   if food == meat
%     and plate = pork
%   THEN
%     aroma = fruity and
%     flavor = crisp
pairing(Beer_Name, meat, pork) :- best_beer(Beer_Code, fruity, crisp, _), name(Beer_Code, Beer_Name).

% RULE :IPA
%   if food == meat
%     and plate = beef
%   THEN
%     aroma = dry and
%     flavor = dry and
%     body = light
pairing(Beer_Name, meat, beef) :- best_beer(Beer_Code, dry, dry, light), name(Beer_Code, Beer_Name).

% RULE : Red Ale
%   if food == appetizer
%     and plate = ham
%   THEN
%     aroma = malted and
%     body = smooth
pairing(Beer_Name, appetizer, ham) :- best_beer(Beer_Code, malted, _, smooth), name(Beer_Code, Beer_Name).


% RULE : Weissbier
%   if food == appetizer
%     and plate = peanuts
%   THEN
%     aroma = fruity and
%     flavor = sweet andr
%     body = creamy
pairing(Beer_Name, appetizer, peanuts) :- best_beer(Beer_Code, fruity, sweet, creamy), name(Beer_Code, Beer_Name).

% RULE :American Lager
%   if food == appetizer
%     and plate = chips
%   THEN
%     aroma = sweet and
%     flavor = crisp and
%     body = smooth
pairing(Beer_Name, appetizer, chips) :- best_beer(Beer_Code, sweet, crisp, smooth), name(Beer_Code, Beer_Name).

% RULE :American Lager
%   if food == appetizer
%     and plate = nachos
%   THEN
%     aroma = sweet and
%     flavor = crisp and
%     body = smooth
pairing(Beer_Name, appetizer, nachos) :- best_beer(Beer_Code, sweet, crisp, smooth), name(Beer_Code, Beer_Name).

% RULE : Pale Ale
%   if food == appetizer
%     and plate = pizza
%   THEN
%     aroma = hop and
%     flavor = malty and
%     body = smooth
pairing(Beer_Name, appetizer, pizza) :- best_beer(Beer_Code, hop, malty, smooth), name(Beer_Code, Beer_Name).

% RULE : Imperial Stout
%   if food == dessert
%     and plate = chocolate
%   THEN
%     aroma = dry and
%     flavor = dry and
%     body = creamy
pairing(Beer_Name, dessert, chocolate) :- best_beer(Beer_Code, dry, dry, craemy), name(Beer_Code, Beer_Name).

% RULE : Gose
%   if food == dessert
%     and plate = cake
%   THEN
%     aroma = fruity and
%     flavor = crisp and
%     body = light
pairing(Beer_Name, dessert, cake) :- best_beer(Beer_Code, fruits, crisp, light), name(Beer_Code, Beer_Name).

% RULE : Blonde Ale
%   if food == dessert
%     and plate = fruits
%   THEN
%     flavor = malty and
%     body = smooth
pairing(Beer_Name, dessert, fruits) :- best_beer(Beer_Code, _, malty, smooth), name(Beer_Code, Beer_Name).



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                          HOW TO USE                         %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% To ask for the best pairing of your meal with some beer
% use the instruction pairing(Beer, <type of plate>, <specific plate>)
% If there is more than on pairing and you wish to keep receiving
% recommendations, if there is any, use the ";" char

% TYPES OF PLATE AND ITS SPECIFICS
% - pasta
%   - tomato
%   - garlic
%   - pesto
% 
% - meat
%   - chicken
%   - pork
%   - beef
% 
%  - appetizer
%   - ham
%   - peanuts
%   - chips
%   - nachos
%   - pizza
%
% - dessert
%   - chocolate
%   - cake
%   - cakefruits


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                       USAGE EXAMPLE                         %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Suppose you are having garlic pasta for dinner, and you wish
% to pair with some beer, but you go to the market and there are
% too many options. Which one do you choose?

pairing(Beer, pasta, garlic).
% and the answer is:
% Beer = "Witbier"