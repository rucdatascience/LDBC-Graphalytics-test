# 使用awk提取最后一行含有"WCC :: Start"的时间戳
start_time=$(awk "/$time_flag :: Start/ {start=\$2} END {print start}" "$LOG_FILE")

# 使用awk提取最后一行含有"WCC :: Finished"的时间戳
end_time=$(awk "/$time_flag :: Finished/ {end=\$2} END {print end}" "$LOG_FILE")

# 检查是否成功提取了时间戳
if [[ -z "$start_time" || -z "$end_time" ]]; then
    echo "Error: Could not find '$time_flag :: Start' or '$time_flag :: Finished' in the log file."
    exit 1
fi

# 将时间戳转换为秒（假设时间戳格式为"YYYY-MM-DD HH:MM:SS.SSS+0000"）
start_sec=$(echo $start_time | awk -F'[ :.+]' '{print ($1*3600*1000) + ($2*60*1000) + ($3*1000) + $4}')
end_sec=$(echo $end_time | awk -F'[ :.+]' '{print ($1*3600*1000) + ($2*60*1000) + ($3*1000) + $4}')

# 计算差值并转换为秒
diff_sec=$(bc <<< "scale=3; ($end_sec - $start_sec)/1000")

# 输出结果
echo "$time_flag Start time: $start_time"
echo "$time_flag Finished time: $end_time"
echo "$time_flag Runtime: ${diff_sec} seconds"