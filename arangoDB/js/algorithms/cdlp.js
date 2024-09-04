var store = false   // whether store into database

var pregel = require("@arangodb/pregel");

if(!store) {
    var handle = pregel.start("labelpropagation", "graph_name", {maxGSS: cdlp_max_it, store: false});
    var cnt = 0;
    while (!["done", "canceled"].includes(pregel.status(handle).state)) {
        cnt++;
        console.log(`wait for result:${cnt}s`)
        require("internal").wait(1);
    }
    var status = pregel.status(handle);
    print(status);
    //store as file (convenient for validation)
    const fs = require('fs')
    if (status.state == "done") {
        var query = db._query("FOR doc IN PREGEL_RESULT(@handle) RETURN doc", {handle: handle});
        // transfer to string
        var jsonStringArray = query.toArray().map(JSON.stringify);
        var output_name = "graph_name"+"-CDLP-Arangodb.txt"
        fs.writeFileSync(output_name, jsonStringArray.join('\n'));
    }
}

if(store) {
    var handle = pregel.start("labelpropagation", "graph_name", { maxGSS: cdlp_max_it, resultField: "community" });
    var cnt = 0;
    while (!["done", "canceled"].includes(pregel.status(handle).state)) {
        cnt++;
        console.log(`wait for result:${cnt}s`)
        require("internal").wait(1);
    }
    var status = pregel.status(handle);
    print(status);
}





