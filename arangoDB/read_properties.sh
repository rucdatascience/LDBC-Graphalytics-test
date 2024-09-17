properties_file="${DATA_HOME}/${graph_name}.properties"
if grep -q "weight-property" ${properties_file}; then {
    weighted=true
} else {
    weighted=false
}
fi
directed_str=$(grep "\.directed =" ${properties_file} | cut -d '=' -f 2)
if [ $directed_str == "true" ]; then {
    directed=true
} else {
    directed=false
}
fi
bfs_id=$(grep "bfs\.source-vertex =" ${properties_file} | cut -d '=' -f 2 | tr -d '[:space:]')
cdlp_max_it=$(grep "cdlp\.max-iterations =" ${properties_file} | cut -d '=' -f 2 | tr -d '[:space:]')
pr_df=$(grep "pr\.damping-factor =" ${properties_file} | cut -d '=' -f 2 | tr -d '[:space:]')
pr_it=$(grep "pr\.num-iterations =" ${properties_file} | cut -d '=' -f 2 | tr -d '[:space:]')
if $weighted; then {
    sssp_id=$(grep "sssp\.source-vertex =" ${properties_file} | cut -d '=' -f 2 | tr -d '[:space:]')
}
fi
echo "weighted: $weighted"
echo "directed: $directed"
echo "bfs_id: $bfs_id"
echo "cdlp_max_it: $cdlp_max_it"
echo "pr_df: $pr_df pr_it: $pr_it"
if $weighted; then {
    echo "sssp_id: $sssp_id"
} else {
    echo "This graph doesn't support SSSP algorithm."
}
fi
