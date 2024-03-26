listLength([], 0).
listLength([_| Tail], Length) :-
    listLength(Tail, TailLength),
    Length is TailLength + 1.


isMember(X, [X|_]).
isMember(X, [_|Tail]):-
    isMember(X, Tail).


%pb1

list_orders(CustUsername, L):-
    customer(CustID, CustUsername),
    getListOfOrders(CustID, [], L),!.

getListOfOrders(CustID, CurrL, [ResH|ResT]):-
    order(CustID, OrderID, Items),
    \+ isMember(OrderID, CurrL),
    ResH = order(CustID, OrderID, Items),
    getListOfOrders(CustID, [OrderID|CurrL], ResT).

getListOfOrders(_, _, []).

%pb2
countOrdersOfCustomer(CustUsername, Count):-
    list_orders(CustUsername, L),
    listLength(L, Count).
%pb3
getItemsInOrderById(CustUsername, OrderID, Items):-
    customer(CustID, CustUsername),
    order(CustID, OrderID, Items), !.

%pb4
getNumOfItems(CustUsername, OrderID, Count):-
    customer(CustID, CustUsername),
    order(CustID, OrderID, L),
    listLength(L, Count).

%pb7
whyToBoycott(Item, Justification):-
    \+ boycott_company(Item, _),
    item(Item, Company, _),
    boycott_company(Company, Justification), !.

whyToBoycott(Company, Justification):-
    boycott_company(Company, Justification).


%pb9
replaceBoycottItemsFromAnOrder(CustUsername, OrderID, NewList):-
    customer(CustID, CustUsername),
    order(CustID, OrderID, OldList),
    replaceBoycottItems(OldList, NewList), !.

replaceBoycottItems([], []).

replaceBoycottItems([Item|Rest], [NewItem|NewRest]) :-
    (isBoycotted(Item) -> (alternative(Item, NewItem) -> true ; NewItem = Item); NewItem = Item),
    replaceBoycottItems(Rest, NewRest).

isBoycotted(Item) :-
    item(Item, Company, _),
    boycott_company(Company, _).


%pb11
getTheDifferenceInPriceBetweenItemAndAlternative(ItemA, ItemB, Diff):-
    alternative(ItemA, ItemB),
    item(ItemA, _, P1),
    item(ItemB, _, P2),
    Diff is P1 - P2.

