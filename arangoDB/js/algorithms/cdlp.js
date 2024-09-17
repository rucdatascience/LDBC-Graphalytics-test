// Write via Pregel.
const pregel = require("@arangodb/pregel");
// Whether store into database.
const store = false;

const algorithm = "labelpropagation";
const g_name = "graph_name";
const output_name = "output/" + g_name + "-CDLP-ArangoDB.txt";

const result_field = "community";

console.log(algorithm + " is running...");
if(!store) {
    // Change
    var handle = pregel.start(algorithm, g_name, {maxGSS: cdlp_max_it, store: false});
    var cnt = 0;
    while (!["done", "canceled"].includes(pregel.status(handle).state)) {
        cnt++;
        if(cnt % 10 == 0) {
            console.log(`wait for `+ algorithm + ` result:${cnt}s`);
        }
        require("internal").wait(1);
    }
    var status = pregel.status(handle);
    // Change
    console.log("CDLP computationTime: " + status.computationTime + " seconds");
    //Store as a file, which is convenient for validation.
    const fs = require('fs');
    if (status.state == "done") {
        var query = db._query("FOR doc IN PREGEL_RESULT(@handle) RETURN doc", {handle: handle});
        var jsonStringArray = query.toArray().map(JSON.stringify);
        fs.writeFileSync(output_name, jsonStringArray.join('\n'));
    }
} else {
    // Change
    var handle = pregel.start(algorithm, g_name , { maxGSS: cdlp_max_it, resultField: result_field });
    var cnt = 0;
    while (!["done", "canceled"].includes(pregel.status(handle).state)) {
        cnt++;
        if(cnt % 10 == 0) {
            console.log(`wait for `+ algorithm + ` result:${cnt}s`);
        }
        require("internal").wait(1);
    }
    var status = pregel.status(handle);
    // Change
    console.log("CDLP computationTime: " + status.computationTime + " seconds");
}