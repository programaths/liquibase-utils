declare variable $project as xs:string external := "file:///path/to/your/project";
declare variable $relativeDir as xs:string external := "/path/to/your/liquibase/changelog/directory";
declare variable $tables as xs:string* external := ('TABLE 1','TABLE 2','TABLE 3');
let $d:=collection(fn:string-join(($project,$relativeDir)))
return string-join(('digraph{ node[shape=box];',
    for $f in $d
        for $fk in $f//*:addForeignKeyConstraint
        where $fk/(@baseTableName|@referencedTableNam)=$tables
        return $fk/(string(@baseTableName),'->',string(@referencedTableName),';')
,'}'))
