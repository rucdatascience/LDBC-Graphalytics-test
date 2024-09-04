source config.sh
source dataset.sh
> benchmark.log
echo "===================================== START ========================================" >> benchmark.log
for graph in "${dataset[@]}"; do
    echo "Testing graph: $graph" >> benchmark.log
    # 设置当前图名称
    graph_name="$graph"
    source read_properties.sh >> benchmark.log
    source clear.sh
    source import.sh
    source init.sh
    source run_test.sh >> benchmark.log
    echo "===================================== Next Graph ========================================" >> benchmark.log
done
echo "===================================== END ========================================" >> benchmark.log