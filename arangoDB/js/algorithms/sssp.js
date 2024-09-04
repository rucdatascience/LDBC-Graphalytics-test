var query = 
`
FOR target IN \`graph_name_v\`
    LET sum = (
        FOR vetex, edge IN OUTBOUND SHORTEST_PATH "graph_name_v/sssp_id" TO target._id GRAPH "graph_name"
            OPTIONS {weightAttribute: 'weight', defaultWeight: 1}
            COLLECT AGGREGATE total_weight = SUM(edge.weight)
            RETURN total_weight
    )
    SORT TO_NUMBER(target._key)
    RETURN {"vertex": target._key, "total_weight": sum[0]}
`

query_result = db._query(query)
var stats = query_result.getExtra().stats;
console.log("SSSP time: " + stats.executionTime + " seconds");

// transfer to string
const fs = require('fs')
var jsonStringArray = query_result.toArray().map(JSON.stringify);
var output_name = graph_name+"-SSSP-Arangodb.txt"
fs.writeFileSync(output_name, jsonStringArray.join('\n'));