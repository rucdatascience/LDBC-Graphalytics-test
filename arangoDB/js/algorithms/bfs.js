const fs = require('fs')

var query = 
`
FOR vertex,edge,path IN 0..100000000 OUTBOUND "graph_name_v/bfs_id" GRAPH "graph_name"
    OPTIONS {order: "bfs", uniqueVertices: "global"}
    SORT TO_NUMBER(vertex._key)
    RETURN {"vertex": vertex._key, "depth": LENGTH(path.edges)}
`

var query_result = db._query(query)

var stats = query_result.getExtra().stats;
console.log("BFS time: " + stats.executionTime + " seconds");

// transfer to string
var jsonStringArray = query_result.toArray().map(JSON.stringify);
var output_name = graph_name+"-BFS-Arangodb.txt"
fs.writeFileSync(output_name, jsonStringArray.join('\n'));
