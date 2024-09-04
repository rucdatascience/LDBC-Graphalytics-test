CALL gds.labelPropagation.stream('graph',{maxIterations:cdlp_max_it})
YIELD nodeId, communityId AS Community
RETURN gds.util.asNode(nodeId).ID AS ID, Community
ORDER BY ID;
