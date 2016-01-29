#11随机森林#
随机森林算法的实质是基于决策树的分类器集成算法，其中每一颗树都依赖于一个随机向量，森林中的所有的向量都是独立同分布的。

##概述##
随机森林是一种比较新的机器学习模型。经典的机器学习模型是神经网络，有半个多世纪的历史了。神经网络预测准确，但是计算量很大。20世纪80年代，Breiman等人发明分类树的算法，通过反复二分数据进行分类或回归，计算量大大降低。2001年，Breiman把分类树组合成随机森林，即在变量(列)的使用和数据(行)的使用上进行随机化，生成很多分类树，再汇总分类树的结果。
随机森林在运算量没有显著提高的前提下提高了预测精度。随机森林对多元共线性不敏感，结果对缺失数据和非平衡的数据比较稳健，可以很好地预测多达几千个解释变量的作用，被誉为当前最好的算法之一。
<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
###基本原理###
1.随机森林的定义  
随机森林是一个树型分类器{h(x,β<sub>k</sub>),k=1,...}的集合。其中元分类器h(x,β<sub>k</sub>)是用CART算法构建的没有剪枝的分类决策树；x是输入变量；β<sub>k</sub>是独立同分布的随机变量，决定了单棵树的生长过程；森林的输出采用简单多数投票法，或者是单棵树输出结果的简单平均得到，其中简单多数投票法主要针对分类模型，单棵树输出结果的简单平均主要针对回归模型。  
2.随机森林的基本思想  
随机森林是通过自助法(boot-strap）重采样技术，从原始训练样本集N中有放回地重复随机抽取k个样本生成新的训练集样本集合，然后根据自助样本集生成k个决策树组成的随机森林，新数据的分类结果按决策树投票多少形成的分数而定。  
其实质是对决策树算法的一种改进，将多个决策树合并在一起，每棵树的建立依赖于一个独立抽取的样本，森林中的每棵树具有相同的分布，分类误差取决于每一颗决策树的分类能力和它们之间的相关性。
特征选择采用随机的方法去分裂每一个节点，然后比较不同情况下产生的误差，能够监测到内在估计误差、分类能力和相关性决定选择特征的数目。单棵决策树的分类能力可能很小，但在随机产生大量的决策树后，一个测试样本可以通过每一棵树的分类结果经统计后选择最可能的分类。  
3.随机森林的估计过程  
随机森林其实可以通俗地理解为由多个决策树组成的森林，而每个样本需要经过每棵树进行预测，然后根据所有决策树的预测结果最后来确定整个随机森林的预测结果。随机森林中的每一棵决策树都为二叉树，其生成遵循自顶向下的递归分裂原则，即从根节点开始依次对训练集进行划分。在二叉树中，根节点包含全部训练数据，按照节点不纯度最小原则，分裂为左节点和右节点，它们分别包含训练数据的一个子集，按照同样的规则，节点继续分裂，直到满足分支停止规则而停止生长。
随机森林在建立模型以及进行预测的具体步骤如下：  
(1)首先我们用N来表示原始训练集样本的个数，用M来表示变量的数目。  
(2)其次我们需要确定一个定值m,该值被用来决定当在一个节点上做决定时，会使用到多少个变量。确定时需要注意m应该小于M。  
(3)应用bootstrap法有放回地随机抽取k个新的自助样本集，并因此构建k棵决策树，每次未被抽到的样本组成了k个袋外数据，即out-of-bag,简称OOB。  
(4)每个自助样本集生长为单棵决策树。在树的每个节点处从M个特征中随机挑选m个特征(m小于M)，按照节点不纯度最小的原则从这m个特征中选出一个特征进行分支生长。这棵决策树进行充分生长，使每个节点的不纯度达到最小，不进行通常的剪枝操作。  
(5)根据生成的多个决策树分类器对需要进行预测的数据进行预测，根据每颗决策树的投票结果取票数最高的一个类别。  
在随机森林的构建过程中，自助样本集用于每一个树分类器的形成，每次抽样生成的袋外数据(OOB)被用来预测分类的正确率，对每次预测结果进行汇总得到错误率的OOB估计，然后评估组合分类的正确率。此外，生成每一棵决策树时，所应用的自助样本集从原始的训练样本集中随机抽取，每一棵决策树所应用的变量也是从所有变量M中随机选取，随机森林通过在每个节点处随机选择特征进行分支，最小化了每棵决策树之间的相关性，提高了分类准确度。因为每棵树的生长很快，所以随机森林的分类速度很快，并且很容易实现并行化。这也是随机森林的一个非常重要的优点和特点。
###重要参数###
1.随机森林分类性能的主要因素  
(1)森林中单棵树的分类强度:在随机森林中，每一棵树的分类强度越大，即每棵树枝叶越茂盛，则整体随机森林的分类性能越好。  
(2)森林中树之间的相关度：在随机森林中，树与树之间的相关度越大，即树与树之间的枝叶相互穿插越多，则随机森林的分类性能越差。  
2.随机森林的两个重要参数  
(1)树节点预选的变量个数   
(2)随机森林中树的个数  
以上两个参数是在构建随机森林模型过程中的两个重要参数，这也是决定随机森林预测能力的两个重要参数。其中第一个参数决定了单棵决策树的情况，而第二个参数决定了整片随机森林的总体规模。换言之，上述两个参数分别从随机森林的微观和宏观层面上决定了整片随机森林的构造。  

##R中实现##
randomForest软件包建立了随机森林模型里的分类模型与回归模型。
###核心函数###
>* 函数importance()用来提取在利用函数randomForest()建立随机森林模型过程中方程中各变量的重要性度量结果。
>* 函数MDSplot()用来绘制在利用函数randomForest()建立随机森林模型过程中所产生的临近矩阵经过标准化后的坐标图，简而言之，就是可以将高位图缩放到任意小的维度下来观看模型各个类别在不同维度下的分布情况。
>* 函数rfImpute()用来对数据中的缺失值进行插值，该函数也是随机森林模型的一个重要应用。
>* 函数treesize()用来查看随机森林模型中，每一棵树所具有的节点个数。
>* 函数randomForest()是随机森林中最核心的函数，它用来建立随机森林模型，该函数既可以建立判别模型，也可以用来建立回归模型，还可以建立无监督模型。

1.importance()函数
该函数用来提取随机森林模型中各个变量的重要性的度量结果，这也是随机森林模型的一大特点之一，这同时也是随机森林模型的一个重要应用领域。更具体地说，该函数的作用就是根据俩种不同的标准计算出各个变量对模型分类的影响程度，也就是看函数的哪个具体的特征模型类别具有重大的影响。这样就方便了我们对模型中众多的变量能够抓大放小，重点解决一些重要的变量
importance(x, type=NULL, class=NULL, scale=TRUE, ...)
>* x指代的是利用函数randomForest()生成的随机森林模型。
>* class在这里主要针对随机森林的分类问题。当type=1时，该参数的取值范围为响应变量中的样本类别，并且返回结果为该参数的取值对应类别的重要值情况。
>* type表示对于变量重要值的度量标准。type=1代表采用精度平均最小值做为度量标准;2代表采用节点不纯度的平均减少值作为度量标准。
>* scale代表是否对变量重要值进行标准化，即是否将计算而得的重要值除以他们对应的标准差。

```r
set.seed(4)
data(mtcars)
mtcars_rf<-randomForest(mpg~.,data = mtcars,ntree = 1000,importance = T)
importance(mtcars_rf)
```

2.MDSplot函数  
函数MDSplot()主要用于对随机森林模型进行可视化分析。该函数用于绘制在利用函数randomForest()建立随机森林过程中，所产生的临近矩阵经过标准化后的坐标图。这样的解释似乎过于抽象，读者可从实际应用的角度将其简单地解释为，在不同维度下各个样本点的分布情况图。  
MDSplot(rf, fac, k=2, palette=NULL, pch=20, ...)
>* rf表示随机森林模型。在构建模型时，必须在模型中包含有模型的临近矩阵。
>* fac指代在构建rf随机森林模型过程中所使用到的一个因子向量。
>* k用来决定所绘制的图像中所包含的经过缩放的维度。
>* palette用来决定所绘制的图像中各个类别的样本点的颜色。
>* pch用来决定所绘制的图像中各个类别的样本点的形状。
```r
set.seed(1)
data(iris)
iris_rf<-randomForest(Species~.,data = iris,proximity=T)
MDSplot(iris_rf,iris$Species,palette = rep(1,3),pch=as.numeric(iris$Species))
```
在缩减为二维的情况下，第一个类别的特征较为明显，然而第二个类别和第三个类别却非常相近，甚至出现了交叉的情况。这样对分类模型的构建会产生一定的不利影响。

3.rfImpute函数  
利用随机森林函数模型中的临近矩阵来对将要进行模型建立的预测数据中存在的缺失值进行插值，经过不断地迭代一次又一次地修正所插入的缺失值，尽可能得到最优的样本拟合值。

rfImpute(x, y, iter=5, ntree=300, ...)  
rfImpute(x, data, ..., subset)  
>* x为一个含有一些缺失值的预测数据集，同时x也可以为一个公式
>* y为响应变量向量，在该函数中，参数y不存在缺失值
>* iter为插值过程中的迭代次数
>* ntree为每次迭代生成的随机森林模型中的决策树数量
>* subset决定了将采用的样本集

```r
data(iris)
iris.na<-iris
iris.na[75,2]<-NA
iris.na[125,3]<-NA
set.seed(111)
iris.imputed<-rfImpute(Species~.,data=iris.na)
list("real"=iris[c(75,125),1:4],"hava-NA"=iris.na[c(75,125),1:4],"disposed"=round(iris.imputed[c(75,125),2:5],1))
```

4.treesize函数    
主要作用为查看随机森林模型中，每一棵树所具有的节点个数，它通常配合randomForest使用。
treesize(x, terminal=TRUE)
>* x为随机森林模型
>* terminal主要用于决定节点的计数方式，如果为T，则只计算最终根节点数目，如果为F,将所有的节点全部计数。
该函数所生成的是一个向量，该向量的长度等同于随机森林中决策树的数量。

```r
set.seed(1)
data(iris)
iris_rf<-randomForest(Species~.,data = iris,proximity=T)
hist(treesize(iris_rf))
```

5.randomForest()函数

```r
randomForest(formula, data=NULL, ..., subset, na.action=na.fail)
randomForest(x, y=NULL,  xtest=NULL, ytest=NULL, ntree=500,
             mtry=if (!is.null(y) && !is.factor(y))
             max(floor(ncol(x)/3), 1) else floor(sqrt(ncol(x))),
             replace=TRUE, classwt=NULL, cutoff, strata,
             sampsize = if (replace) nrow(x) else ceiling(.632*nrow(x)),
             nodesize = if (!is.null(y) && !is.factor(y)) 5 else 1,
             maxnodes = NULL,
             importance=FALSE, localImp=FALSE, nPerm=1,
             proximity, oob.prox=proximity,
             norm.votes=TRUE, do.trace=FALSE,
             keep.forest=!is.null(y) && is.null(xtest), corr.bias=FALSE,
             keep.inbag=FALSE, ...)
```
>* formula代表函数模型的形式
>* data代表的是在模型中包含的有变量的一组可选格式数据。
>* subset主要用于抽取样本数据的部分样本作为训练集，该参数所使用的数据格式为一向量，向量中的每个数代表所需要抽取样本的行数。
>* na.action主要用于设置构建模型过程中遇到数据中的缺失值时的处理方式。该参数的默认值为na.fail，即不能出现缺失值。该参数还可以取值na.omit，即忽略有缺失值的样本。
>* x为一个矩阵或者一个格式化数据集。该参数就是在建立随机森林模型中所需要的自变量数据。
>* y是建立随机森林模型中的响应变量。如果y是一个字符向量，则所构建的模型为判别模型；如果y是一个数量向量，则所构建的模型为回归模型；如果不设定y的取值，则所构建的模型为一个无监督模型。
>* xtest是一个格式数据或者矩阵。该参数所代表的是用来进行预测的测试集的预测指标。
>* ytest是参数xtest决定的测试集的真实分布情况。
>* ntree指代森林中树的数目。在这里需要强调的是，该参数的值不宜偏小，这从直观上解释就是如果树太少那就不是森林了。对于该参数的决定存在一个原则，即尽量使每一个样本都至少能进行几次预测。通常，该参数最好设定为500或者1000。但这也不是绝对的，还要根据具体情况加以判断。
>* mtry用来决定在随机森林中决策树的每次分支时所选择的变量个数。在模型构建过程中一定得通过逐次计算来挑选最优的m值。该参数的默认值在判别模型中为变量个数的二次方根，在回归模型中则为变量个数的1/3。
>* replace用来决定随机抽样的方式的。为True时，说明随机抽样是采取了有放回的随机抽样，则抽取的训练集中会出现重复样本；当为False时，则采取了无放回的随机抽样，在抽取的训练集中不会出现重复样本。
>* strata是一个因子变量，用于决定分层抽样。
>* sampsize用来决定抽样的规模的。该参数通常与参数strata联合使用，我们可以直观地将参数strata理解万岁参数sampsize的名称，即参数strata决定抽取的类别，而参数sampsize决定该类别应该抽取的样本数量。
>* nodesize用来决定随机森林中决策树的最少节点数的。该参数的默认值在判别模型中为1，在回归模型中为5.
>* maxnodes用来决定随机森林中决策树的最大节点数的。如果不设定，则决策树节点数将会尽可能地最大化。然而如果设定的最大节点数大于了决策树的最大可能节点，系统将会出现警告。
>* importance用来决定是否计算每个变量在模型中的重要性。配合importance()函数使用。
>* proximity用来决定是否计算模型的临近矩阵的。配合MDSplot()函数使用。

对于大型数据集来说，尤其是那些拥有大量变量的数据集的时候，调用函数使用公式接口是不建议的，即采用函数的第一类输入格式是不建议的，因为这样将会导致在处理公式时花费大量的时间。

###可视化分析###
```r
data(airquality)
set.seed(131)
head(airquality)
ozone.rf<-randomForest(Ozone~.,data=airquality,mtry = 3,importance =T,na.action=na.omit)
plot(ozone.rf)
```
由图可以看出，该模型中的决策树数量在100以内，模型误差会出现较大的波动，当决策树数量大于100以后，模型误差趋于稳定，但仍有少许变化。  
通过观察发现，该模型误差最小值并非出现在决策树数量为500的时候，而是出现在决策树数量为210左右。所以我们猜测模型中的最优决策树数量为210.

##应用案例##

```r
wine<-read.csv("winequality-white.csv",sep = ";")
summary(wine)
hist(wine$quality)
```
数据集中的quality为结果变量，该变量总共为11个等级，从0到11逐渐代表了白酒品质的提高，但是在本数据集中仅仅包含了3到9这7个等级。  
本数据集采集了白酒品质的11项基本特征，分别为：非挥发性酸、挥发性酸、柠檬酸、剩余糖分、氯化物、游离二氧化硫、总二氧化硫、密度、酸性、硫酸盐、酒精度。

###1数据处理###
如果直接用白酒品质进行模型构建，则建立的随机森林模型为回归模型。函数将会默认结果变量为连续变量，通过计算各个决策树的平均结果得出最后的预测结果，并且相应的预测结果为数量型变量。  
本文主要介绍随机森林判别模型，所以需要对数据集进行处理。将白酒品质分为三个等级。
```r
wine$quality.factor<-NA
wine$quality.factor[which(wine$quality<6)]<-"bad"
wine$quality.factor[which(wine$quality>6)]<-"good"
wine$quality.factor[which(wine$quality==6)]<-"mid"
wine$quality.factor<-factor(wine$quality.factor)
wine$quality<-NULL
table(wine$quality.factor)
```

###2建立模型###

```r
#使用第一种格式建立模型
set.seed(71)
samp<-sample(1:nrow(wine),3000) #抽取3000个作为训练集
set.seed(111)
wine.rf<-randomForest(quality.factor~.,data=wine,importance=T,proximity = T,ntree = 500,subset=samp)

#使用第二种格式建立模型
x<-subset(wine,select = -quality.factor)  #提取除了quality.factor之外的数据列作为自变量
y<-wine$quality.factor
set.seed(71)
samp<-sample(1:nrow(wine),3000) #抽取3000个作为训练集
xr<-x[samp,]
yr<-y[samp]
set.seed(111)
wine.rf<-randomForest(xr,yr,importance = T,proximity = T,ntree=500)
```

每次进行模型构建之前设置相应的随机数生成器初始值，这是为了保证在每次构建随机森林所使用的随机抽样样本是相同的，这也保证了每次建立的随机森林模型是一样的。还有一个问题需要强调，subset参数在第一种格式中是有效的，在第二种使用格式中却是无效的。

###3结果分析###
```r
print(wine.rf)
```
>* 结果Call中展示了模型构建的相关参数设定。
>* 结果Type中说明了所构建的模型的类别，从结果中我们得知模型为判别模型。
>* 结果Number of trees展示了所构建的随机森林模型中包含了500棵决策树。
>* 结果中No. of variables tried at each split还告知了每棵决策树节点处所选择的变量个数为3.
>* 模型基于OOB样本集进行预测得到的结果正如结果中的Confusion matrix所示，且模型总的预测误差为29.87%。
>* 结果中的Confusion matrix展示了最终模型的预测结果通训练集实际结果之间的差别情况。

###4自变量的重要程度###
```r
importance(win.rf)
```
###5优化建模###
```r
n<-ncol(wine)-1 #自变量个数
rate<-1  #设置模型误判率向量初始值
for(i in 1:n){
	set.seed(222);
	model<-randomForest(quality.factor~.,data=wine,mtry=i,importance=T,ntree=1000)
	rate[i]<-mean(model$err.rate) #计算基于OOB数据的模型误判率均值
	print(model)
}
```
从以上的输出结果中可以看到，当决策树节点所选变量数为2的时候，模型的误判率均值是最低的。

```r
set.seed(222)
model<-randomForest(quality.factor~.,data=wine,mtry=2,importance=T,ntree=1000)
plot(model,col=1:1)
legend(800,0.215,"mid",cex=0.9,bty="n")
legend(800,0.28,"bad",cex=0.9,bty="n")
legend(800,0.37,"good",cex=0.9,bty="n")
legend(800,0.245,"total",cex=0.9,bty="n")
```
从图可以看到，当决策树数量大概大于400之后，模型误差趋于稳定，所以可以将模型中的决策树数量大致确定为400左右，以此来达到最优模型。

```r
set.seed(222)
model<-randomForest(quality.factor~.,data=wine,mtry=2,importance=T,ntree=400,proximity=T)
print(model)
hist(treesize(model))
MDSplot(model,wine$quality.factor,palette = rep(1,3),pch = as.numeric(wine$quality.factor))
```
MDSplot图形中说明了数据集中的三个类别，三个类别均出现交叉，并且在部分区域，三个类别的交叉情况较为严重，这同时也解释了模型预测精度较低的原因。