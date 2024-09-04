CALL gds.wcc.stream('graph')
YIELD nodeId, componentId
RETURN gds.util.asNode(nodeId).ID AS ID, componentId
ORDER BY ID;