// Write in AQL, so the format is different from others via Pregel.
const fs = require('fs');

// Change
const output_name = "output/graph_name-SSSP-ArangoDB.txt" ;
// Change
const query = 
`
FOR target IN \`graph_name_v\`
    LET sum = (
        FOR vetex, edge IN OUTBOUND SHORTEST_PATH "graph_name_v/sssp_id" TO target._id GRAPH \`graph_name\`
            OPTIONS {weightAttribute: 'weight', defaultWeight: 1}
            COLLECT AGGREGATE total_weight = SUM(edge.weight)
            RETURN total_weight
    )
    SORT TO_NUMBER(target._key)
    RETURN {"vertex": target._key, "total_weight": sum[0]}
`;
console.log("SSSP is running...");

query_result = db._query(query);
var stats = query_result.getExtra().stats;
console.log("SSSP time: " + stats.executionTime + " seconds");

// Transfer to string and store the output into a file.
var jsonStringArray = query_result.toArray().map(JSON.stringify);
fs.writeFileSync(output_name, jsonStringArray.join('\n'));