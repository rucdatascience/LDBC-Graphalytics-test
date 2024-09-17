bfs_js=$(mktemp)
sed -e "s/bfs_id/${bfs_id}/g" -e "s/graph_name/${graph_name}/g" js/algorithms/bfs.js > $bfs_js
arangosh --server.database rucgraph --server.password root --javascript.execute ${bfs_js}

cdlp_js=$(mktemp)
sed -e "s/cdlp_max_it/${cdlp_max_it}/g" -e "s/graph_name/${graph_name}/g" js/algorithms/cdlp.js > $cdlp_js
arangosh --server.database rucgraph --server.password root --javascript.execute ${cdlp_js}

pagerank_js=$(mktemp)
sed -e "s/pr_it/${pr_it}/g" -e "s/graph_name/${graph_name}/g" js/algorithms/pagerank.js > $pagerank_js
arangosh --server.database rucgraph --server.password root --javascript.execute ${pagerank_js}

if $directed; then {
    wcc_js=$(mktemp)
    sed "s/graph_name/${graph_name}/g" js/algorithms/wcc.js > $wcc_js
    arangosh --server.database rucgraph --server.password root --javascript.execute $wcc_js
} else {
    cc_js=$(mktemp)
    sed "s/graph_name/${graph_name}/g" js/algorithms/cc.js > $cc_js
    arangosh --server.database rucgraph --server.password root --javascript.execute $cc_js
}
fi

# if $weighted; then {
# sssp_js=$(mktemp)
# sed -e "s/sssp_id/${sssp_id}/g" -e "s/graph_name/${graph_name}/g" js/algorithms/sssp.js > $sssp_js
# arangosh --server.database rucgraph --server.password root --javascript.execute ${sssp_js}
# }
# fi