listLength([], 0).

listLength([_| Tail], Length) :-
    listLength(Tail, TailLength),
    Length is TailLength + 1.

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


