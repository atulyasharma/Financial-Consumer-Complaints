CREATE CONSTRAINT ON (complaint:Complaint) ASSERT complaint.ComplaintId IS UNIQUE;
CREATE CONSTRAINT ON (company:Company) ASSERT company.name IS UNIQUE;
CREATE CONSTRAINT ON (response:Response) ASSERT response.companyResponse IS UNIQUE;
CREATE CONSTRAINT ON (product:Product) ASSERT product.ProductName IS UNIQUE;
CREATE CONSTRAINT ON (state:State) ASSERT state.StateName IS UNIQUE;
CREATE CONSTRAINT ON (zipcode:Zipcode) ASSERT zipcode.ZipId IS UNIQUE;
CREATE CONSTRAINT ON (subProduct:SubProduct) ASSERT subProduct.SubProductName IS UNIQUE;
CREATE CONSTRAINT ON (issue:Issue) ASSERT issue.IssueName IS UNIQUE;
CREATE CONSTRAINT ON (subIssue:SubIssue) ASSERT subIssue.SubIssueName IS UNIQUE;


//Create Node Complaint
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
ON CREATE SET complaint.DateReceived = row.Date_Received;

//Create Node Company
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (company:Company {name:row.Company});

//Create Relationship complaint-against-company
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (company:Company {name:row.Company})
MERGE (complaint)-[:AGAINST]->(company);

//Create Node Response
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (response:Response {companyResponse:row.Company_Response_To_Consumer});

//Create Relationship response-from-company
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (company:Company {name:row.Company})
MATCH (response:Response {companyResponse:row.Company_Response_To_Consumer})
MERGE (response)-[:FROM]->(company);

//Create Node Product
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (product:Product {ProductName:row.Product});

//Create Relationship complaint-about-product
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (product:Product {ProductName:row.Product})
MERGE (complaint)-[:ABOUT]->(product);

//Create Node SubProduct
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (subProduct:SubProduct {SubProductName:row.Sub_Product});

//Create Relationship complaint-about-subproduct
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (subProduct:SubProduct {SubProductName:row.Sub_Product})
MERGE (complaint)-[:ABOUT]->(subProduct);

//Create Relationship product-contains-subproduct
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (product:Product {ProductName:row.Product})
MATCH (subProduct:SubProduct {SubProductName:row.Sub_Product})
MERGE (product)-[:CONTAINS]->(subProduct);

//Create Node State
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (state:State {StateName:row.State});

//Create Node Zip
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (zipcode:Zipcode {ZipId:toInteger(row.Zip_Code)});

//Create Relationship complaint-originatedfrom-state
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (state:State {StateName:row.State})
MERGE (complaint)-[:ORIGINATED_FROM]->(state);

//Create Relationship complaint-originatedfrom-zip
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (zipcode:Zipcode {ZipId:toInteger(row.Zip_Code)})
MERGE (complaint)-[:ORIGINATED_FROM]->(zipcode);

//Create Relationship Zip-fallsunder-State
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (state:State {StateName:row.State})
MATCH (zipcode:Zipcode {ZipId:toInteger(row.Zip_Code)})
MERGE (zipcode)-[:FALLS_UNDER]->(state);

//Create Node Issue
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (issue:Issue {IssueName:row.Issue});

//Create Relationship complaint-with-issue
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (issue:Issue {IssueName:row.Issue})
MERGE (complaint)-[:WITH]->(issue);

//Create Node SubIssue
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MERGE (subIssue:SubIssue {SubIssueName:row.Sub_Issue});

//Create Relationship complaint-with-subissue
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (complaint:Complaint {ComplaintId:toInteger(row.Complaint_ID)})
MATCH (subIssue:SubIssue {SubIssueName:row.Sub_Issue})
MERGE (complaint)-[:WITH]->(subIssue);

//Create Relationship subissue-incategory-issue
:auto USING PERIODIC COMMIT 500 
LOAD CSV WITH HEADERS FROM 'file:///Post_EDA.csv' AS row
MATCH (issue:Issue {IssueName:row.Issue})
MATCH (subIssue:SubIssue {SubIssueName:row.Sub_Issue})
MERGE (subIssue)-[:IN_CATEGORY]->(issue);


//View Schema Visualization
call db.schema.visualization();









