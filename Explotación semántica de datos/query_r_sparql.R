library(SPARQL)
endpoint <- "http://dayhoff.inf.um.es:3036/blazegraph/namespace/lncrna_mus/sparql"
query1 <-"PREFIX lncrna: <http://lncrna.com/resources/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX SIO: <http://semanticscience.org/resource/SIO_>

SELECT DISTINCT ?ARN ?regulation
WHERE {
 ?instance rdfs:label ?ARN ;
 SIO:001156 ?regulation ;
 SIO:001156 'up-regulation' .
}"

qd1<- SPARQL(endpoint,query1)
qd1$results

query2 <-"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX NCIT: <http://purl.obolibrary.org/obo/NCIT_>
PREFIX BCO: <http://rs.tdwg.org/dwc/terms/>
PREFIX lncrna: <http://lncrna.com/resources/>
PREFIX SIO: <http://semanticscience.org/resource/SIO_>

SELECT ?ARN (COUNT(?ARN) As ?noOfFunctions)
WHERE {
  ?instance rdfs:label ?ARN ;
            SIO:000225 ?function .
  
  ?instance rdf:type NCIT:C1936 . 
}
GROUP BY ?ARN
HAVING (?noOfFunctions > 1)
ORDER BY DESC(?noOfFunctions)"
qd2 <- SPARQL(endpoint,query2)
qd2$results

query3 <-"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX NCIT: <http://purl.obolibrary.org/obo/NCIT_>
PREFIX BAO: <http://www.bioassayontology.org/bao#BAO_>

SELECT ?Disease 
       (COUNT(?ARN) As ?noOflncRNA)
WHERE {
 ?instance rdfs:label ?Disease ;
       	   rdf:type NCIT:C2991.
 
 ?transcript rdf:type   NCIT:C1936 ;
             BAO:0002848 ?instance ;
          	 rdfs:label ?ARN .
}
GROUP BY ?Disease
ORDER BY DESC(?noOflncRNA)"
qd3 <- SPARQL(endpoint,query3)
qd3$results

query4 <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX BCO: <http://rs.tdwg.org/dwc/terms/>
PREFIX SIO: <http://semanticscience.org/resource/SIO_>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX NCIT: <http://purl.obolibrary.org/obo/NCIT_>

SELECT DISTINCT ?function ?ARN ?year
WHERE {
 ?instance SIO:000225   ?function ;
 		   #rdf:type NCIT:C1936 ;
 		   rdfs:label   ?ARN ;
           BCO:namePublishedin ?publication .
 
  ?publication dc:date ?year .
  
  filter contains (?function,'inhibits')
}"
qd4 <- SPARQL(endpoint,query4)
qd4$results

query5 <- "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX BCO: <http://rs.tdwg.org/dwc/terms/>
PREFIX dc: <http://purl.org/dc/elements/1.1/>
PREFIX NCIT: <http://purl.obolibrary.org/obo/NCIT_>
PREFIX BAO: <http://www.bioassayontology.org/bao#BAO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>


SELECT ?title ?year ?disease ?pubmed
WHERE {
?publication dc:title ?title ;
             dc:date ?year ;
             owl:sameAs ?pubmed .
?arn BCO:namePublishedin ?publication ;
     BAO:0002848 ?dis .
?dis rdfs:label ?disease .

  filter contains (?year, '2020')
}"
qd5 <- SPARQL(endpoint,query5)
qd5$results

