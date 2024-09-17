# LDBC-Graphalytics-test

## 测试环境准备

### 测试平台

* `CPU，Intel(R) Xeon(R) Platinum 8360Y(36核)*2`

* `GPU，A6000`

* `CentOS Linux 7`

### 测试图数据下载

1. 进入拥有足够空闲空间的目录，如等待下载图数据的空目录为`/home/abc/data`，则终端输入`cd /home/abc/data`（建议拥有`2T`以上的剩余存储空间）。

   * 查看目录存储空间消耗：`du -sh /home/abc/data `
   * 查看`/home`剩余存储空间：`df -h | grep /home`

2. 终端输入`wget https://ldbcouncil.org/scripts/download-graphalytics-data-sets-r2.sh`，获取图数据下载脚本。

3. 终端输入`chmod +x *.sh`将下载脚本权限改为可执行。

4. 终端输入`screen -S download_data `，打开一个名为`download_data`的新页面用于下载图数据（这是为了在用户登出时，仍然能继续下载，而避免下载中断带来的麻烦）。

   * 如果没有安装`screen`，则输入以下内容，按照指示进行安装 ：

   * `sudo yum makecache fast`

     `sudo yum install screen`

   * 安装后再次执行创建页面指令。

5. 终端输入`./download-graphalytics-data-sets-r2.sh`，确保网络通畅，较快网速下载及解压需要大约数小时时间。

6. 按住`ctrl+A+D`，将页面挂起，不必保持终端打开进行等待，允许断开用户与服务器连接，不会中断下载。

7. 随时可以终端输入`screen -r download_data`重新回到下载页面，可以查看下载进度。

8. 待确定下载完毕后，终端输入`screen -X -S download_data quit`，可以清除页面，可以通过`screen -ls`验证是否成功清除。

## Neo4j测试

### 软件安装

> 若有`root`权限和外网环境，可以使用包管理器的方式直接下载安装，更为便捷。但是在用户目录下安装也可以便于独立测试。
>
> 以下是无`root`权限，无外网环境如何进行软件安装。

* Neo4j依赖的java环境：

  * jdk最新版(截至2024.8)下载链接：https://www.oracle.com/java/technologies/downloads/#java17。


  * 方法：在本地下载好之后，确保本地和服务器在一个内网环境中，使用`scp`指令进行传递。


  * 本地下载：直接浏览器下载对应版本的`tar`包。`tar`包不需要`root`权限即可完成安装。

  * 拷贝：
    * `scp 本地下载路径 用户名@服务器ip:服务器目标路径`，输入密码后即可拷贝。
    * 若使用`vscode`，可以直接拖拽进文件目录，即可实现拷贝。


  * 安装：在用户根目录下新建一个空目录，使用`cd`进入后，执行`tar -axvf 包名`。

* `Neo4j`社区版:

  * 访问下载官网：https://neo4j.com/download/other-releases/#releases。

  * 下滑，选择`COMMUNITY`社区版，选择`Neo4j 5.22.0`，选择`Linux/Mac Executable`，点击`Download`进行本地下载。

  * 上传与安装方式与`jdk`下载类似，建议与`jdk`的目录放置在一个父目录下，便于环境变量配置。

* `Neo4j`官方图形计算库`Neo4j GDS`：

  * 下载链接：https://neo4j.com/deployment-center/?gds-selfmanaged#gds-tab。

  * 下滑，所选择内容与下载`Neo4j`数据库时一致，会自动匹配相适应的`GDS`版本，本地下载。

  * 上传服务器：步骤类似。
  * 安装：参考官方文档：https://neo4j.com/docs/graph-data-science/current/installation/neo4j-server/，从第`3`条开始，将`Neo4j`的配置文件进行修改，打开`GDS`插件功能。

* 配置环境变量：

  将下载好的jdk、Neo4j目录下的bin目录加入环境变量。

  * `vim ~/.bashrc`。（如使用`vscode`可直接修改，不必使用`vim`）

  * 按`i`进入编辑模式。

  * 在末尾添加：

    ```cmd
    export OPT_HOME=这里是jdk与neo4j的父目录
    
    export JAVA_HOME=$OPT_HOME/jdk-17.0.11
    export PATH=$JAVA_HOME/bin:$PATH
    
    export NEO4J_HOME=$OPT_HOME/neo4j-community-5.22.0
    export PATH=$NEO4J_HOME/bin:$PATH
    ```

    注意修改`OPT_HOME`为实际的路径。

  * 按`ESC`进入普通模式，输入`:wq`保存并退出`vim`

  * 执行`source ~/.bashrc`刷新终端配置。

### 如何验证环境和修改配置文件

* 联系管理员，或者使用root权限，修改单进程文件数目上限：`ulimit -n 40000`。

* 修改Neo4j根目录下的`conf/neo4j.conf`文件，建议修改前备份：

  * 确保环境变量配置，终端任意目录下执行：`neo4j-admin server memory-recommendation`，查看当前系统推荐的内存配置。

    如果要测试L以上的数据，需要增大堆的大小，推荐的堆大小最多只会为31g。

    > 系统内存参考：`free -g`              
    >
    > total,used,free,shared,buff/cache,available
    >
    > Mem,1007,132,228,3,646,869
    >
    > Swap,0,0,0

    ```cmd
    # 参考内存配置
    server.memory.heap.initial_size=200g
    server.memory.heap.max_size=200g
    server.memory.pagecache.size=760g
    ```

  * 修改`conf/neo4j.conf`中相应配置。

  * 再修改其中的`dbms.security.auth_enabled`为`false`，取消密码验证，方便测试。

  * 修改`conf/neo4j.conf`中的`server.logs.gc.rotation.size`的`20m`为`200m`，增大单个log文件的大小限制，防止log文件更换导致测试运行脚本出错。

* 终端执行`neo4j start`，等待片刻启动数据库。

* 终端执行`cypher-shell`，开启交互。若需要输入初始账号和密码，均为`neo4j`，并修改密码，要求8位以上（配置了`dbms.security.auth_enabled`，应当初始状态也不用验证）。

* 终端输入`:exit`退出`cypher-shell`。

* 以上步骤均按照预期执行，即表明环境配置成功。

### 如何执行测试

> 此处若需要脱离登录状态时也能执行，可以仿照下载数据时的方式使用`screen`指令。

1. 在测试脚本中的`neo4j/config.sh`中写入实际的`DATA_HOME`、`NEO4J_HOME`、`LOG_FILE`，第一个路径为LDBC数据存放的目录，第二个路径为Neo4j数据库的根目录，第三个路径为Neo4j的debug.log的路径。
2. 在`neo4j/dataset.sh`中设置需要测试的图的名称，注意要用引号包围，且不同图名称之间以空格间隔。
3. 在测试脚本目录下执行`chmod +x *.sh`，使得所有脚本有可执行权限。
4. 在测试脚本目录下执行`./main.sh`，即可开始测试。
5. 在测试脚本运行过程中，可以打开`LOG_FILE`监测算法实际执行进度，也可以打开`neo4j/benchmark.log`查看每个图数据的各个算法的实际执行时间。
6. 最终耗时结果保存在`neo4j/benchmark.log`中，可供查看。

### 测试补充说明

#### 正确性验证

1. `BFS`：经过调研，`Neo4j GDS BFS`返回的只有源节点、抵达节点总数、访问的`Path`，`Path`是指按照访问节点的顺序形成的路径，并不能间接得到每个节点的深度，因此无法进行`LDBC`正确性验证。

   但是为了确保结果的准确与调用无误，首先在小图上进行测试，对比`Path`，得到的深度结果一致；大图上如`cit-Patents`上通过`grep -v 9223372036854775807 cit-Patents-BFS | wc -l 298159`确认BFS抵达的节点数目一致，均为`298159`，可以近似核验正确性。

   参考链接：https://neo4j.com/docs/graph-data-science/current/algorithms/bfs/#algorithms-bfs-syntax

2. `CDLP`：在无向图上不一致，有向图上也不一致。经过对比发现`LDBC`的标签传播与`Neo4j`的标签传播标准不一致，但算法步骤基本相同。以下是参考链接：

   `LDBC`：https://arxiv.org/pdf/2011.15028 `Page 14~15 of 43`

   `Neo4j`：https://neo4j.com/docs/graph-data-science/2.8/algorithms/label-propagation/

3. `PageRank`：有向图和无向图上均无法满足`LDBC`要求的分数近似相等，但是页面的排名是一致的，即按照得分大小排序后，每个位次的节点一致，也是因为`Neo4j`的计算公式略有不同。

   `LDBC`：https://arxiv.org/pdf/2011.15028 `Page 14 of 43`

   `Neo4j`：https://neo4j.com/docs/graph-data-science/current/algorithms/page-rank

4. `WCC`：满足`LDBC`要求的一一对应正确性验证。

5. `SSSP`：满足`LDBC`要求的近似相等正确性验证。

#### 执行算法选取

`Neo4j`可选图算子执行方案有：

1. 自行编写`Cypher`语句。
2. 使用`APOC`库中的`BFS、PageRank`等算法。
3. 使用`Neo4j Graph Data Science`执行。

选取的是在大型图数据上表现最为优异的`GDS`算子进行测试。

#### 测试方案选择

> 参考：https://stackoverflow.com/questions/66271919/what-is-exact-time-in-neo4j-execution-time

* 选择`cypher-shell`直接与数据库交互。
* 选择`Neo4j GDS`中算法的`stream`执行模式，避免更新原来的图数据耗时，同时可以导出结果至文件系统，便于直接查看算法执行结果。
* 选择查看`log`文件，计算时间戳之差的方式统计算子实际执行时间，排除了数据库返回结果所需时间，也没有依赖`Neo4j`本身返回算法执行时间的函数，测试更为准确。

## ArangoDB测试

### 软件安装

> 有root权限和外网环境，系统级安装。用户级安装较为繁琐且易出错，故采用系统级安装。

```cmd
sudo cd /etc/yum.repos.d/
sudo curl -OL https://download.arangodb.com/arangodb312/RPM/arangodb.repo
sudo yum -y install arangodb3-3.11.10-1.1
```

安装期间会需要设置登录密码，原始密码在安装的提示信息中会被给出。这里可以随意输入新密码，建议直接以`root`作为密码。

### 修改配置

1. 输入`arangod`，直接启动数据库，会提示需要修改的配置，以达到较好性能, 根据要求输入指令进行配置的修改。

2. 关闭执行`arangod`指令的终端，`ArangoDB`也随之关闭， 后续我们将改用 `systemctl` 进行数据库的启动。

### 开始测试

> 此处若需要脱离登录状态时也能执行，可以仿照下载数据时的方式使用`screen`指令。
> 由于`SSSP`算子执行过于缓慢，默认将`arangoDB/run_test.sh`中有关`SSSP`测试的部分注释掉了，如需尝试测试，可取消注释。

1. `sudo systemctl start arangodb3`，启动`ArangoDB`。
2. 创建一个空的数据库：
   * 输入`arangosh`。
   * 输入`db._createDatabase("rucgraph");`其中`rucgraph`是要创建数据库的名字。
   * 输入`exit`退出。
3. 在测试脚本中的`arangoDB/config.sh`中配置好`LDBC`图数据所在的目录，创建的数据库名称，密码，若前面使用的是`rucgraph`作为数据库名，`root`作为密码，则不需要修改这两项。
4. 在`arangoDB/dataset.sh`中修改给定需要测试的图名称列表，注意格式。
5. 在测试脚本目录下执行`chmod +x *.sh`，使得所有脚本有可执行权限。
6. 在测试脚本目录下执行`./main.sh`即可开始测试。
7. 测试过程中可以查看`arangoDB/benchmark.log`的变化，最终测试结果存放在此文件中。

### 测试补充说明

#### 测试中可能遇见的问题及解决方案

1. 可能遇到`SSSP`算法`request`请求超时，此时无法正确结束`SSSP`算法执行的问题。
   * 解决方案：
     * 执行`top`指令，查看`arangod`对应的`pid`；
     * 执行`kill -15 对应的pid`，关闭进程，并允许进程进行清理，防止数据不一致等问题。
2. 可能遇到导入图数据时中断了程序执行，导致再次测试同一张图的点与边的时候产生数据重复导入的错误。
   * 解决方案：
     * 打开`ArangoDB`的WebUI，默认地址为`localhost:8529`，登陆账户，选择对应的数据库，点击左侧的`collections`删除对应的集合即可；
     * 如果是图重复创建，那么点击左侧的`graphs`，删除对应的图即可（注意勾选同时删除包含的集合）。

#### 正确性验证

1. `BFS`：满足`LDBC`要求的精确匹配正确性验证。

2. `CDLP`：在有向图上不正确，在无向图上只能映射相等，而`LDBC`要求完全一致。查阅资料推测是因为`ArangoDB`在标签扩散前进行频率计算时没有考虑出边，只考虑了入边；而`LDBC`文档算法介绍将出边和入边算作两次。

   `LDBC`：https://arxiv.org/pdf/2011.15028 `Page 14~15 of 43`

   `ArangoDB`：https://docs.arangodb.com/3.11/data-science/pregel/algorithms/#label-propagation

3. `PageRank`：结果差异很大。应当也是计算公式不一样的缘故。

   `LDBC`：https://arxiv.org/pdf/2011.15028 `Page 14 of 43`

   `ArangoDB`：https://docs.arangodb.com/3.11/data-science/pregel/algorithms/#pagerank

4. `WCC`：满足`LDBC`要求的一一对应正确性验证。

5. `SSSP`：满足`LDBC`要求的近似相等正确性验证，但是算子执行速度过慢，只在小图上进行了测试。

#### 执行算法选取

`ArangoDB`可选图算子执行方案有：

1. 自行编写`AQL`语句。
2. 使用自带的`Pregel API`执行各种分布式图算子。
3. 使用`Graph Analytics`执行各种图算子（3.11版本不支持单服务器部署，详见 https://docs.arangodb.com/3.11/data-science/graph-analytics/#workflow）。

由于`3`不适用于待测试版本，且`1`性能较差，所以我们尽量采用`2`进行测试。但是由于`ArangoDB`的`Pregel API`并不直接支持`BFS`与带权的`SSSP`，因此这两种算子分别采用`AQL`语句中的`order: "bfs"`与`SHORTEST_PATH`进行执行。结果表示：其中`BFS`的性能能够忍受，而`SSSP`仅能在很小的测试图上在合理时间（30min）内得到结果，`kgs`这种`XS`大小的图就无法在合理时间内得到结果。

#### 测试方案选择

1. 对于`AQL`语句的算子执行，我们使用`db._query(query).getExtra().stats.executionTime`获取算子实际的计算时间（排除导入图等过程的时间）。
2. 对于`Pregel API`的算子执行，我们使用`pregel.status(handle).computationTime`获取算子实际的计算时间。