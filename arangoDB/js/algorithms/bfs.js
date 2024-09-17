// Write in AQL, so the format is different from others via Pregel.
const fs = require('fs');

// Change
const output_name = "output/graph_name-BFS-ArangoDB.txt";
// Change
const query = 
`
FOR vertex,edge,path IN 0..100000000 OUTBOUND "graph_name_v/bfs_id" GRAPH \`graph_name\`
    OPTIONS {order: "bfs", uniqueVertices: "global"}
    SORT TO_NUMBER(vertex._key)
    RETURN {"vertex": vertex._key, "depth": LENGTH(path.edges)}
`;
console.log("BFS is running...");

var query_result = db._query(query);

var stats = query_result.getExtra().stats;
console.log("BFS time: " + stats.executionTime + " seconds");

// Transfer to string and store the output into a file.
var jsonStringArray = query_result.toArray().map(JSON.stringify);
fs.writeFileSync(output_name, jsonStringArray.join('\n'));