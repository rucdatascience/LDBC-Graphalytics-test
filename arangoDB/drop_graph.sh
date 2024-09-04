drop_graph_js=$(mktemp)
sed "s/graph_name/${graph_name}/g" js/create_graph/drop_graph.js > $drop_graph_js
arangosh --server.database ${DATABASE_NAME} --server.password ${PASSWORD} --javascript.execute ${drop_graph_js}