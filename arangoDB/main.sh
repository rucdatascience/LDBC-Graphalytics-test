source config.sh
source dataset.sh
> benchmark.log
echo "===================================== START ========================================" >> benchmark.log
for graph in "${dataset[@]}"; do
    echo "Testing graph: $graph" >> benchmark.log
    graph_name="$graph"
    source drop_graph.sh    # To avoid import the data repeatedly, we drop the graph first.
    source read_properties.sh >> benchmark.log
    source import.sh
    source create_graph.sh
    source run_test.sh >> benchmark.log
    source drop_graph.sh
    echo "===================================== Next Graph ========================================" >> benchmark.log
done
echo "===================================== END ========================================" >> benchmark.log