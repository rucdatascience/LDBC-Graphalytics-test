bfs_cypher=$(mktemp)
sed "s/bfs_id/${bfs_id}/g" cypher/algorithms/bfs.cypher > $bfs_cypher
cypher-shell -f $bfs_cypher > output/${graph_name}-BFS-Neo4j
time_flag="BFS"
source calculate_time.sh

cdlp_cypher=$(mktemp)
sed "s/cdlp_max_it/${cdlp_max_it}/g" cypher/algorithms/cdlp.cypher > $cdlp_cypher
cypher-shell -f $cdlp_cypher > output/${graph_name}-CDLP-Neo4j
time_flag="Label Propagation"
source calculate_time.sh

pagerank_cypher=$(mktemp)
sed -e "s/pr_it/${pr_it}/g" -e "s/pr_df/${pr_df}/g" cypher/algorithms/pagerank.cypher > $pagerank_cypher
cypher-shell -f $pagerank_cypher > output/${graph_name}-PR-Neo4j
time_flag="PageRank"
source calculate_time.sh

if $weighted; then {
    sssp_cypher=$(mktemp)
    sed "s/sssp_id/${sssp_id}/g" cypher/algorithms/sssp.cypher > $sssp_cypher
    cypher-shell -f $sssp_cypher > output/${graph_name}-SSSP-Neo4j
    time_flag="All Shortest Paths"
    source calculate_time.sh
}
fi

cypher-shell -f cypher/algorithms/wcc.cypher > output/${graph_name}-WCC-Neo4j
time_flag="WCC"
source calculate_time.sh
