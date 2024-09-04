// only correct for undirected graph
var pregel = require("@arangodb/pregel");

// for small output
// var handle = pregel.start("connectedcomponents", graph_name, { store: false});

// for persistant store
var handle = pregel.start("connectedcomponents", "graph_name", {resultField: "component"});
var cnt = 0;
while (!["done", "canceled"].includes(pregel.status(handle).state)) {
    cnt++;
    console.log(`wait for result:${cnt}s`)
    require("internal").wait(1);
}

var status = pregel.status(handle);
print(status);

// for small output
// if (status.state == "done") {
//     var query = db._query("FOR doc IN PREGEL_RESULT(@handle) RETURN doc", {handle: handle});
//     print(query.toArray());
// }