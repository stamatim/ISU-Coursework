:- [’airlines.pl’].

airport(newyork, 50, 1).
airport(london, 75, 2).
airport(madrid, 75, 0.75).
airport(barcelona, 40, 0.5).
airport(valencia, 40, 0.33).
airport(malaga, 50, 0.5).

%% london <-> newyork
flight(aircanada, london, newyork, 500, 6).
flight(united, london, newyork, 650, 7).

%% newyork <-> madrid
flight(iberia, newyork, madrid, 800, 8).
flight(united, madrid, newyork, 950, 9).
flight(aircanada, newyork, madrid, 900, 8).

%% madrid <-> barcelona
flight(aircanada, madrid, barcelona, 100, 1).
flight(iberia, madrid, barcelona, 120, 1.1).

%% london <-> barcelona
flight(iberia, london, barcelona, 220, 4).

%% madrid <-> valencia
flight(iberia, valencia, madrid, 40, 0.9).

%% valencia <-> barcelona
flight(iberia, valencia, barcelona, 110, 1.25).

%% valencia <-> malaga
flight(iberia, valencia, malaga, 80, 2).

%% madrid <-> malaga
flight(iberia, madrid, malaga, 50, 0.5).

%% add more flight legs as well.

leg(A,X,Y,P,T) :- flight(A,X,Y,P,T) ; flight(A,Y,X,P,T).

conc([],L,L).
conc([X|L1],L2,[X|L3]) :- conc(L1,L2,L3).

second([_,H,_,_],H).

trip(O,D,R) :-
    travel(O,D,T,P,Tr,Path,[O],[D]), R = [P, T, Tr, [Path]].

travel(Start,Destination,Time,Price,Trips,Path,_,A) :-
    leg(Airline,Start,Destination,P,FlightDuration),
    airport(Start,Tax, WaitTime),
    Time is FlightDuration + WaitTime,
    constraint(Airline,A,Tr),
    Trips is  Tr,
    Price is P + Tax,
    conc([Start, Airline, Destination],[],Path).

travel(Start,Destination,Time,Price, Trips, Path, V, A) :-
    leg(Airline,Start,X,P,FlightDuration),
    airport(Start, Tax, WaitTime),
    X \== Destination,
    not(member(X,V)),
    travel(X,Destination,TimeX,PriceX,TripsX,PathX,[X|V], [Airline|A]),
    Time is FlightDuration + TimeX + WaitTime,
    Price is P + PriceX + Tax,
    constraint(Airline,A,Tr),
    Trips is Tr + TripsX,
    conc([[Start,Airline,X]],PathX,Path).

tripk(O,D,K,R) :-
    trip(O,D,R),
    second(R,T),
    T < K.

multicitytrip(O,D,I,R) :-
    trip(O,D,R),
    flatten(R,F),
    member(I,F).

constraint(X,Y,Z) :-
    (  member(X,Y)
    -> Z is 0
    ;  Z is 1
     ).
