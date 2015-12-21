# Liquibase utils

## Prerequisits

A linux box with bash.
Everything is documented for linux.
If you use Windows, you will have to adapt.

You need the following programs installed:

- [Basex](http://basex.org/)
- [GraphVis](http://graphviz.org/)
- [Swi prolog](http://www.swi-prolog.org/)

## General notes
for each `basex` command you can pass the following parameters 

* `-bproject=...` : base directory
* `-brelativeDir=...` : dir relative to base
* `-btables=...` : tables to take into account

## Generating diagrams
This will create a diagram in PNG where arrows indicates references.

    basex liqui2dot.xq | dot -Tpng -o diagram.png
    
## Generating SQL92 (without DB)
This will create SQL92 files suitable for IntelliJ DDL data source

    basex liqui2sql.xq > ddl.sql
    
## Computing "insert" order
This will list tables in correct order
So yo can INSERT data without violating foreign keys.

    echo "main(X),write(X)." | prolog -q -s <(basex liqui2pl.xq)