declare namespace file = "http://expath.org/ns/file";
declare variable $project as xs:string := "file:///path/to/your/project";
declare variable $relativeDir as xs:string external := "/path/to/your/liquibase/changelog/directory";
declare function local:quoteId($n as node()){
  if (string($n)=('USER','GROUP')) then 
    string-join(('"',string($n),'"'))
   else
     translate(string($n),'ÉÈ','EE')
};
declare function local:fk($t as xs:string,$changeLog as node()){
  for $fk in $changeLog//*:addForeignKeyConstraint[$t=@baseTableName]
  return string-join((',
  FOREIGN KEY(',string($fk/@baseColumnNames),') REFERENCES ', local:quoteId($fk/@referencedTableName),'(',string($fk/@referencedColumnNames),')'))  
};

let $d:=collection(fn:string-join(($project,$relativeDir)))

return for $f in $d
  return for $ct in $f//*:createTable
    return string-join(('CREATE TABLE ',local:quoteId($ct/@tableName),'(
      ',
      string-join(for $col in $ct/*:column
      return string-join((local:quoteId($col/@name),' ',string($col/@type))),',
      '),local:fk(string($ct/@tableName),$f)
    ,'
    );'))

