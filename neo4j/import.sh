title_v=$(mktemp)
echo | sed -e 's/.*/ID:ID/' > "$title_v"
title_e_weighted=$(mktemp)
echo | sed -e 's/.*/:START_ID :END_ID weight:double/' > "$title_e_weighted"
title_e_unweighted=$(mktemp)
echo | sed -e 's/.*/:START_ID :END_ID/' > "$title_e_unweighted"

if $directed; then {
echo "Directed" >> benchmark.log;
} else {
echo "Indirected" >> benchmark.log;
}
fi

if $weighted; then {
echo "Weighted" >> benchmark.log;
neo4j-admin database import full --delimiter=' ' \
--nodes=Node=${title_v},\
${DATA_HOME}/${graph_name}.v \
--id-type=integer \
--relationships=Edge=${title_e_weighted},\
${DATA_HOME}/${graph_name}.e
} else {
echo "Unweighted" >> benchmark.log;
neo4j-admin database import full --delimiter=' ' \
--nodes=Node=${title_v},\
${DATA_HOME}/${graph_name}.v \
--id-type=integer \
--relationships=Edge=${title_e_unweighted},\
${DATA_HOME}/${graph_name}.e
}
fi