// For small output.
const algorithm = ""
const graph_name = ""
// Should adjust the parameters in {}!

var handle = pregel.start(algorithm, graph_name, {store: false}); // Change the parameters here!

var cnt = 0;
while (!["done", "canceled"].includes(pregel.status(handle).state)) {
    cnt++;
    console.log(`wait for ` + algorithm + ` result:${cnt}s`);
    require("internal").wait(1);
}
var status = pregel.status(handle);
console.log(algorithm + "time: " + status.computationTime + " seconds");

if (status.state == "done") {
    var query = db._query("FOR doc IN PREGEL_RESULT(@handle) RETURN doc", {handle: handle});
    print(query.toArray());
}