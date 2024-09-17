const graph_module = require("@arangodb/general-graph");

// Delete the graph and the collections
graph_module._drop("graph_name", true);