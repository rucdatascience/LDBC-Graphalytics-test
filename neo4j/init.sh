neo4j start
case $directed in 
    "true")
        (
            case $weighted in
            "true")
                cypher-shell -f cypher/create_graph/create_graph_d_w.cypher
                ;;
            "false")
                cypher-shell -f cypher/create_graph/create_graph_d_uw.cypher
                ;;
                esac
        )
        ;;
    "false")
        case $weighted in
            "true")
                cypher-shell -f cypher/create_graph/create_graph_ud_w.cypher
                ;;
            "false")
                cypher-shell -f cypher/create_graph/create_graph_ud_uw.cypher
                ;;
                esac
        ;;
esac
