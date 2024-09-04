MATCH (source:Node {ID: sssp_id})
CALL gds.allShortestPaths.dijkstra.stream('graph', {
sourceNode: source,
relationshipWeightProperty: 'weight'
})
YIELD targetNode, totalCost
RETURN
    gds.util.asNode(targetNode).ID AS ID,
    totalCost
ORDER BY ID;
