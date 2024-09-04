title_v=$(mktemp)
echo | sed -e 's/.*/_key/' > "$title_v"

title_e_weighted=$(mktemp)
echo | sed -e 's/.*/_from _to weight/' > "$title_e_weighted"

title_e_weighted_reverse=$(mktemp)
echo | sed -e 's/.*/_to _from weight/' > "$title_e_weighted_reverse"

title_e_unweighted=$(mktemp)
echo | sed -e 's/.*/_from _to/' > "$title_e_unweighted"

title_e_unweighted_reverse=$(mktemp)
echo | sed -e 's/.*/_to _from/' > "$title_e_unweighted_reverse"

if $weighted; then {
    if $directed; then {
# import nodes
arangoimport \
--file ${DATA_HOME}/${graph_name}.v \
--type tsv \
--headers-file ${title_v} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_v \
--create-collection true \
--create-collection-type document \
--server.password ${PASSWORD}

# import edges
arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_weighted} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}
    } else {
# import nodes
arangoimport \
--file ${DATA_HOME}/${graph_name}.v \
--type tsv \
--headers-file ${title_v} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_v \
--create-collection true \
--create-collection-type document \
--server.password ${PASSWORD}

# import edges
arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_weighted} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}

arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_weighted_reverse} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}
    }
    fi
} else {
    if $directed; then {
arangoimport \
--file ${DATA_HOME}/${graph_name}.v \
--type tsv \
--headers-file ${title_v} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_v \
--create-collection true \
--create-collection-type document \
--server.password ${PASSWORD}

# import edges
arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_unweighted} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}
    } else {
# import nodes
arangoimport \
--file ${DATA_HOME}/${graph_name}.v \
--type tsv \
--headers-file ${title_v}\
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_v \
--create-collection true \
--create-collection-type document \
--server.password ${PASSWORD}

# import edges
arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_unweighted} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}

arangoimport \
--file ${DATA_HOME}/${graph_name}.e \
--type tsv \
--headers-file ${title_e_unweighted_reverse} \
--server.database ${DATABASE_NAME} \
--collection ${graph_name}_e \
--create-collection true \
--create-collection-type edge \
--from-collection-prefix ${graph_name}_v \
--to-collection-prefix ${graph_name}_v \
--separator ' ' \
--server.password ${PASSWORD}
    }
    fi
}
fi