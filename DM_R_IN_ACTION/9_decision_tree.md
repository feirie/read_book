## 9决策树 ##

### 常用算法 ###
1. 分类回归树CART(Classification and Regression Trees)，顾名思义是既可以建立分类树，也可以构建回归树的算法。它是许多集成分类算法的基分类器，如在后面介绍的Bossting以及Random Forest等都以此为基础。虽然各式分类算法不断涌现，单CART仍是使用最为广泛的分类技术。
2. C4.5(successor of ID3)是ID3(Iterative Dichotomiser3)的改进算法，俩者都以熵(Entropy)理论和信息增益(Information Gain)理论为基础。其算法的精髓所在，即是使用熵值或者信息增益值来确定使用哪个变量作为各节点的判定变量。而C4.5是为了解决ID3只能用于离散型变量，即仅可以构建分类树，且确定判定变量时偏向于选择取值较多的变量这俩项主要缺陷而提出的。虽然目前已有在运行效率等方面进一步完善的算法C5.0，但由于C5.0多用于商业用途，C4.5仍是最为常见的决策树算法。 

### R中软件包 ###
rpart主要用于建立分类树及相关递归划分算法的实现;rpart.plot专用来对rpart模型绘制决策树;maptree则用来修剪、绘制不仅仅局限于rpart模型的树形结构;RWeka包提供了R与Weka的连接，Weka中集合了用Java编写的一系列机器学习算法。

<table>
  <tr>
    <td>算法名称</td>
    <td>软件包</td>
    <td>核心函数</td>
  </tr>
  <tr>
    <td rowspan="3">CART</td>
    <td>rpart</td>
    <td>rpart()、prune.rpart()、post()</td>
  </tr>
  <tr>
    <td>rpart.plot</td>
    <td>rpart.plot()</td>
  </tr>
  <tr>
    <td>maptree</td>
    <td>draw.tree()</td>
  </tr>
  <tr>
    <td>C4.5</td>
    <td>RWeka</td>
	<td>J48()</td>
  </tr>
</table>

### 核心函数 ###
1. rpart函数

rpart(formula, data, weights, subset, na.action = na.rpart, method, model = FALSE, x = FALSE, y = TRUE, parms, control, cost, ...)
formula中填写想要建立模型的公式
data为待训练数据集
subset可以选择出data中若干行样本来建立模型
na.action用来处理缺失值，其


