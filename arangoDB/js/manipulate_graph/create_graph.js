var graph_module = require("@arangodb/general-graph");
var edgeDefinitions = graph_module._edgeDefinitions();
graph_module._extendEdgeDefinitions(edgeDefinitions, graph_module._relation("graph_name"+"_e", "graph_name"+"_v", "graph_name"+"_v"));
var log = graph_module._create("graph_name", edgeDefinitions);
console.log(log)