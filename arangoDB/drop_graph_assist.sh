graph_name="datagen-7_5-fb"

drop_graph_js=$(mktemp)
sed "s/graph_name/${graph_name}/g" js/create_graph/drop_graph.js > $drop_graph_js
arangosh --server.database rucgraph --server.password root --javascript.execute ${drop_graph_js}