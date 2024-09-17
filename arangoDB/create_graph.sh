create_graph_js=$(mktemp)
sed "s/graph_name/${graph_name}/g" js/manipulate_graph/create_graph.js > $create_graph_js
arangosh --server.database ${DATABASE_NAME} --server.password ${PASSWORD} --javascript.execute ${create_graph_js}