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
>* formula中填写想要建立模型的公式
>* data为待训练数据集
>* subset可以选择出data中若干行样本来建立模型
>* na.action用来处理缺失值，其默认选择为na.rpart,即仅剔除缺失y值，或缺失所有输入变量值得样本数据，这是rpart模型很有用的一项功能
>* method参数用于选择决策树的类型，包括anova、poisson、class和exp4种类型，在不进行设置的默认情况下，R会自己来猜测，比如当y为因子型变量时，默认取class型。其中，anova对应于我们所说的回归树，而class型则为分类树。
>* control参数可以参照rpart.control，即：   
   rpart.control(minsplit = 20, minbucket = round(minsplit/3), cp = 0.01, 
              maxcompete = 4, maxsurrogate = 5, usesurrogate = 2, xval = 10,
              surrogatestyle = 0, maxdepth = 30, ...)   
   其中，minsplit表示每个节点中所含样本数的最小值；minbucket则表示每个叶节点中所含样本数的最小值;cp指复杂度参数(complexity parameter)，假设我们设置了cp=0.03,则表明在建模过程中仅保留可以使的模型拟合程度提升0.03及以上的节点，该参数的作用在于可以通过剪去对模型贡献不大的分支，来提高算法效率；maxdepth可控制节点层次的最大值，其中根节点的高度为0，依次类推。

2.prune.rpart函数  
函数prune.rpart可根据cp值对决策树进行剪枝，即剪去cp值较小的不重要分支。其格式为prune(tree,cp,...)，放入决策树名称及cp值即可。

3.rpart.plot、post即draw.tree函数
绘制分类树/回归树的制图函数

4.J48函数


### 数据集 ###
1.数据集概况

```r
library("rpart")  
data(car.test.frame)  
head(car.test.frame)
car.test.frame$Mileage<-100*4.546/(1.6*car.test.frame$Mileage) #将英里数的取值换算为"油耗"指标
names(car.test.frame)<-c("价格","产地","可靠性","油耗","类型","车重","发动机功率","净马力") 
head(car.test.frame)
str(car.test.frame)
summary(car.test.frame)
```
数据集的行名为各种车型的名称，且共有8个变量，分别为价格Price、产地Country、可靠性Reliability、英里数Mileage、类型Type、车重Weight、发动机功率Disp.以及净马力HP。

2.数据预处理
将油耗变量划分为三个组别，A:11.6~15.8,B:9~11.6,c:7.7~9，成为含有3个水平A、B、C的因子变量。
```r
car.test.frame$"水平油耗"<-NA
car.test.frame$"水平油耗"[which(car.test.frame$"油耗">11.6)]<-"A"
car.test.frame$"水平油耗"[which(car.test.frame$"油耗"<9)]<-"C"
car.test.frame$"水平油耗"[which(is.na(car.test.frame$"水平油耗"))]<-"B"
car.test.frame[1:10,c(4,9)]
```

为了评价比较各决策树算法，及体现构造决策树的目的所在，我们通过抽样将数据集分为训练集和测试集，俩者间比例为3：1，即通过3/4的样本建立起决策树模型，来预测另外1/4样本的油耗/分组的取值。并且为保持数据集分布，使用sampling软件包中的strata函数来进行分层抽样，即在A、B、C组的样本中分别抽取1/4作为测试集。
```r
round(table(car.test.frame$"水平油耗")/4)
library(sampling)
set.seed(1234)
car_order<-car.test.frame[order(car.test.frame$"水平油耗",decreasing=F),]
sub=strata(car.test.frame,size = c(2,4,9),method = "srswor",stratanames = "水平油耗")
train_car<-car.test.frame[-sub$ID_unit,]
test_car<-car.test.frame[sub$ID_unit,]
nrow(train_car)
nrow(test_car)
```
### CART应用 ###
1.对"油耗"变量建立回归树--数字结果
用除"分组油耗"以外的所有变量来对"油耗"变量建立决策树，且选择树的类型为回归树
```r
library(rpart)
formula_car_reg<-油耗~价格+产地+可靠性+油耗+类型+车重+发动机功率+净马力  #设定模型公式
rp_car_reg<-rpart(formula_car_reg,data = train_car,method = "anova")  #按照公式对训练集train_car构建回归树
printcp(rp_car_reg) #导出回归树的cp表格
#由此可以看到，在建树过程中用到的变量有"发动机功率"和"车重"这两种，且各节点的CP值、节点序号nsplit、错误率rel error、交互验证错误率xerror等也被列出，其中CP值对于选择控制树的复杂程度十分重要。
#若想获得每个节点更详细的信息，可以对已有决策树模型rp_car_reg使用summary()函数，所得输出结果除了与上面printcp()给出值相同的部分外，另有变量重要程度(variable importance）、每一个分支变量对生成树的提升程度(improve)等信息。
summary(rp_car_reg)

rp_car_reg1<-rpart(formula_car_reg,data = train_car,method = "anova",minsplit=10)
#将分支包含最小样本数minsplit从默认值20更改为10
print(rp_car_reg1)
printcp(rp_car_reg1)
summary(rp_car_reg1)
#当minsplit减少为10后，满足条件的节点包括根节点在内，从4个增加为6个。且在生成树过程中用到了"产地"、"车重"、"发动机功率"、"价格"和"类型"5个变量，相对于更改minsplit前多用到了三个变量。 

rp_car_reg2<-rpart(formula_car_reg,data = train_car,method = "anova",cp=0.1)
#将CP值从默认值0.01改为0.1
print(rp_car_reg2)
printcp(rp_car_reg2)
summary(rp_car_reg2)
#想较于CP取默认值0.01的决策树rp_car_reg，CP值为0.1的新决策树rp_car_reg2中包含根节点在内仅含有2个节点，且节点2的CP值为0.1，改过程中仅用到了"发动机功率"这一个变量。另外我们也可以通过剪枝函数prune.rpart来实现同样效果。
rp_car_reg3<-prune.rpart(rp_car_reg,cp=0.1)
print(rp_car_reg3)
printcp(rp_car_reg3)

#对所生成树的大小也可以通过深度参数maxdepth来控制，以下我们设置深度为1。从输出结果中各节点输出信息的缩进量可以看出，除了根节点外，新的决策树仅有一个层次，这与我们之前调节cp参数的效果相同。
rp_car_reg4<-rpart(formula_car_reg,data = train_car,method = "anova",maxdepth=1)
printcp(rp_car_reg4)
```
2.对"油耗"变量建立回归树--树形结果
```r
rp_car_plot<-rpart(formula_car_reg,data = train_car,method = "anova",minsplit=10)
print(rp_car_plot)
library(rpart.plot)
rpart.plot(rp_car_plot)
```