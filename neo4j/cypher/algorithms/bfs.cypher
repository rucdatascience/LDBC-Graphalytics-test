MATCH (source:Node{ID: bfs_id})
CALL gds.bfs.stream(
'graph',
{
sourceNode: source
})
YIELD sourceNode, nodeIds
RETURN gds.util.asNode(sourceNode).ID AS sourceID, size(nodeIds) AS nodeNumber;
