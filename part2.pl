:-consult(data).
:-consult(impl_predicates).
:- dynamic item/3. 
:- dynamic alternative/2.
:- dynamic boycott_company/2.


% pbl 5
calcPriceOfOrder(CustomerName, OrderId, TotalPrice) :-
    customer(CustomerId, CustomerName),
    order(CustomerId, OrderId, Items),
    calcPriceOfItems(Items, TotalPrice).

calcPriceOfItems([Item|Rest], TotalPrice) :-
    item(Item, _, Price),
    calcPriceOfItems(Rest, SubTotal),
    TotalPrice is Price + SubTotal.

calcPriceOfItems([], 0).



% pbl6
isBoycott(Company) :-
    boycott_company(Company, _), !.

isBoycott(Item) :-
    item(Item, Company, _),
    isBoycott(Company), !.



% pbl 8
removeBoycottItemsFromAnOrder(CustomerName, OrderId, NewList) :-
    customer(CustomerId, CustomerName),
    order(CustomerId, OrderId, Items),
    removeBoycottItemsFromList(Items, NewList, []).

removeBoycottItemsFromList([Item|Rest], NewList, PlaceHolder) :-
    isBoycott(Item), !,
    removeItemFromList(Item, [Item|Rest], TempNewList1),
    removeBoycottItemsFromList(TempNewList1, TempNewList2, PlaceHolder),
    %NewList is TempNewList2.
    assignList(assign, NewList, TempNewList2),
    !.

removeBoycottItemsFromList([Item|Rest], NewList, PlaceHolder) :-
    \+ isBoycott(Item),
    removeBoycottItemsFromList(Rest, TempNewList, PlaceHolder),
    %NewList is [Item|TempNewList].
    assignList(assign, NewList, [Item|TempNewList]).

removeBoycottItemsFromList([], PlaceHolder, PlaceHolder).

removeItemFromList(Item, [Head|Rest], [Head|NewList]) :-
    removeItemFromList(Item, Rest, NewList).

removeItemFromList(Item, [Item|NewList], NewList).


% pbl 10
calcPriceAfterReplacingBoycottItemsFromAnOrder(CustomerName, OrderId, NewList, TotalPrice) :- 
    customer(CustomerId, CustomerName),
    order(CustomerId, OrderId, Items),
    replaceBoycottItemsInList(Items, NewList),
    calcPriceOfItems(NewList, TotalPrice).


replaceBoycottItemsInList([Item|Rest], NewList) :- 
    isBoycott(Item),
    removeItemFromList(Item, [Item|Rest], ListAfterRemove),
    alternative(Item, AlternativeItem),
    assignList(assign, [AlternativeItem|ListAfterRemove], ListAfterReplace),
    replaceBoycottItemsInList(ListAfterReplace, NewList),
    !.


replaceBoycottItemsInList([Item|Rest], NewList) :-
    \+ isBoycott(Item),
    replaceBoycottItemsInList(Rest, TempNewList),
    assignList(assign, NewList, [Item|TempNewList]),
    !.


replaceBoycottItemsInList([Item|Rest], NewList) :-
    isBoycott(Item),
    removeItemFromList(Item, [Item|Rest], ListAfterRemove),
    \+ alternative(Item, AlternativeItem),
    replaceBoycottItemsInList(ListAfterRemove, NewList).


replaceBoycottItemsInList([], NewList) :-
    assignList(assign, NewList, []).



% pbl 12
add_item(ItemName, Company, Price) :-
    assertz(item(ItemName, Company, Price)).

remove_item(ItemName, Company, Price) :-
    retract(item(ItemName, Company, Price)).


add_alternative(ItemName, AlternativeName) :-
    assertz(alternative(ItemName, AlternativeName)).

remove_alternative(ItemName, AlternativeName) :- 
    retract(alternative(ItemName, AlternativeName)).


add_boycott_company(Company, Justification) :- 
    assertz(boycott_company(Company, Justification)).

remove_boycott_company(Company, Justification) :-
    retract(boycott_company(Company, Justification)).
