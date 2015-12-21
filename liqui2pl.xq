declare variable $project as xs:string external := "file:///path/to/your/project";
declare variable $relativeDir as xs:string external := "/path/to/your/liquibase/changelog/directory";
declare variable $tables as xs:string* external := ('TABLE 1','TABLE 2','TABLE 3');

let $i:=
    let $d:=collection(fn:string-join(($project,$relativeDir)))
    return
    for $f in $d
    return (
        for $fk in $f//*:addForeignKeyConstraint
        where $fk/(@baseTableName|@referencedTableNam)=$tables
        return (<table>{string-join(("table(&apos;",string($fk/@baseTableName),"&apos;)."))}</table>,<table>{string-join(("table(&apos;",string($fk/@referencedTableName),"&apos;)."))}</table>)
        ,
        for $fk in $f//*:addForeignKeyConstraint
        where $fk/(@baseTableName|@referencedTableNam)=$tables
        return <ref>{string-join(("ref(&apos;",$fk/(string(@baseTableName),'&apos;,&apos;',string(@referencedTableName),"&apos;).")))}</ref>
    )
    return (for $k in distinct-values($i[name()="table"]/text()) return $k,for $k in distinct-values($i[name()="ref"]/text()) return $k)
,
"
tableList(X,L,N):-
    (length(L,N),X=L);(
    pickNotInList(Y,L),
    L2=[Y|L],
    insertOrder(L2),
    tableList(X,L2,N)).


tableList(X):-
    findall(X,table(X),L),
    length(L,N),
    tableList(X,[],N).

pickNotInList(X,Y):- table(X), notInList(X,Y).

inList(X,[X|_]).
    inList(X,[_|T]) :- inList(X,T).

notInList(X,[Y|T]):- X\==Y, notInList(X,T).
    notInList(_,[]).

insertOrder([H|T]):-
    findall(X,ref(H,X),L),
    containsAll(T,L),
    insertOrder(T).

insertOrder([]).

accRev([H|T],A,R):- accRev(T,[H|A],R).
    accRev([],A,A).

rev(L,R):-  accRev(L,[],R).

containsAll(L,[H|T]):-
    inList(H,L),
    containsAll(L,T).

containsAll(_,[]).

main(X):-
    tableList(Y),
    %!	rev(Y,Z),
    insertOrder(Y),
    rev(Y,Z),
    !,
    X=Z.

"