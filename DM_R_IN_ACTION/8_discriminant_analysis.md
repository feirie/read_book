#8判别分析#
##1概述##
本章我们将介绍三大类主流的判别分析算法，分别为费希尔(Fisher)判别、贝叶斯(Bayes)判别和距离判别。具体的，在费希尔判别中我们将主要讨论线性判别分析(Linear Discriminant Analysis,简称LDA)及其原理一般化后的衍生算法，即二次判别算法(Quadratic Discriminant Analysis,简称QDA);而在贝叶斯判别中将介绍朴素贝叶斯分类(Naive Bayes Classification)算法；距离判别将介绍最为广泛的K最近邻(k-Nearest Neighbor,简称kNN)及有权重的K最近邻(Weighted k-Nearest Neighbor)算法。    
###费希尔判别###
费希尔判别的基本思想是“投影”，即将高维空间的点向低维空间投影，进而简化问题进行处理。费希尔判别最重要的就是选择出适当的投影轴，对该投影轴方向上的要求是：保证投影后，使每一类之间的投影值所形成的类内离差尽可能小，而不同类之间的投影值所形成的类间离差尽可能大，即在该空间中有最佳的可分离性以此获得较高的判别效果。   
具体的，对于线性判别，一般来说，可以先将样本点投影到一维空间，即直线上，若效果不明显，则可以考虑增加一个维度，即投影到二维空间中，依次类推。而二次判别与线性判别的区别在于投影面的形状不同，二次判别使用若干二次曲面，而非直线或平面来将样本划分至相应的类别中。    
相比较来说，二次判别的适用面比线性判别函数要广。这是因为，在实际的模式识别问题中，各类别样本在特征空间中的分布往往比较复杂，因此往往无法用线性分类的方式得到令人满意的效果。这就必须使用非线性的分类方法，而二次判别函数就是一种常用的非线性判别函数，尤其是类域的形状接近二次超曲面体时效果更优。
###贝叶斯判别###
理论上来说，它就是根据已知的先验概率P(A|B),利用贝叶斯公式
P(B|A)=P(B)*P(A|B)/P(A)
求出后验概率P(B|A)，即该样本属于某一类的概率，然后选择具有最大后验概率的类作为该样本所属的类。通俗的说，就是对于给出的待分类样本，求出在此样本出现条件下各个类别出现的概率，哪个最大，就认为此样本属于哪个类别。    
就像我们在听一位素未谋面的历史人物的事迹时，起先我们对他的态度是中立的，但若听到一些他的善言善行，这一信息就会使我们将他判断为功臣的概率大一些，当然这些信息也可能是片面的，也许他同时做了很多恶事，但在没有其他可用信息的情况下，我们会选择条件概率最大的类别。    
朴素贝叶斯的算法虽然“朴素”，但用起来却很有效，其优势在于不怕噪声和无关变量。而明显的不足之处则在于，它假设各特征属性之间是无关的，当这个条件成立时，朴素贝叶斯的判别正确率很高，但不幸的是，在现实中各个特征属性间往往并非独立，而是具有强相关性的，这样就限制了朴素贝叶斯分类的能力。
###距离判别###
距离判别的基本思想，就是根据待判定样本与已知类别样本之间的距离远近做出判别。
K最近邻算法则是距离判别中使用最为广泛的，它的思路十分易于理解，即如果一个样本在特征空间中的K个最相似/最近邻的样本中的大多数属于某一个类别，则该样本也属于这个类别。    
而有权重的K最近邻算法则在kNN基础之上，对各已知类别样本点根据其距离未知样本点的远近，赋予了不同的权重，即距离越近的权重越大。如此即可更充分地利用待分类样本点周围样本的信息，一般来说，加入权重后的kNN算法判别效果更优。
##2R中的实现##
###相关软件包###
<table>
  <tr>
    <td width="160px">判别算法</td>
    <td>软件包</td>
    <td>主要函数</td>
  </tr>
  <tr>
    <td>线性判别分析(LDA)</td>
    <td rowspan=2>MASS为Modern Applied Statistics with S的缩写，是S语言的现代应用统计，该包中含有大量实用而先进的统计技术函数及适用数据集</td>
	<td>ldq()</td>
  </tr>
  <tr>
    <td>二次判别分析(QDA)</td>
	<td>qda()</td>
  </tr>
  <tr>
    <td>朴素贝叶斯分类</td>
    <td>klaR</td>
	<td>NaiveBayes()</td>
  </tr>
  <tr>
    <td>K最近邻(kNN)</td>
    <td>class</td>
	<td>knn()</td>
  </tr>
  <tr>
    <td>有权重的K最近邻</td>
    <td>kknn</td>
	<td>kknn()</td>
  </tr>
</table>
###核心函数###
####1.lda函数####
lda(x, grouping, prior = proportions, tol = 1.0e-4,method, CV = FALSE, nu, ...) 
lda(formula, data, ..., subset, na.action)
lda(x, grouping, ..., subset, na.action)
>* x为该函数要处理的数据框或数据矩阵
>* formula放置生成判别规则的公式
>* data和subset都用于以formula为对象的函数格式中，分别用于指明该formula中变量所来自的数据集名称及所纳入规则建立过程的样本
>* grouping指明每个观测样本所属类别
>* prior可设置各类别的先验概率，在无设置情况下，R默认取训练集中各类别样本的比例
>* tol用于保证判别效果，可通过设置筛选变量，默认取0.0001
>* na.action用于选择对于缺失值的处理，默认情况下，若有缺失值，则该函数无法运行，当更改设置为na.omit时，则自动删除在用于判别的特征变量中含有缺失值的观测样本。 
   
####2.qda函数####
qda(x, grouping, prior = proportions,method, CV = FALSE, nu, ...)
qda(formula, data, ..., subset, na.action)
qda(x, grouping, ..., subset, na.action)    

####3.NaiveBayes函数####
NaiveBayes(formula, data, ..., subset, na.action = na.pass)
NaiveBayes(x, grouping, prior, usekernel = FALSE, fL = 0, ...)
>* na.action为na.pass时，表示不将缺失值纳入计算，并不会导致函数无法运行
>* usekernel参数用于选择函数计算过程中，密度估计所采用的算法，默认时取FALSE，表示使用标准密度估计，也可以修改为TRUE，选择使用核密度估计法
>* fL用于设置进行拉普拉斯修正(Laplace Correction)的参数值，默认取0，即不进行修正，该修正过程在数据量较小的情况下十分必要。这是因为朴素贝叶斯方法的一个致命缺点在于对稀疏数据问题过于敏感，它以各特征变量条件独立为前提，因此使用相乘的方式来计算所需结果，若其中任一项由于数据集中不存在满足条件的样本，使得该项等于0，都会导致整体乘积结果为0，得到无效判别结果。因此，为了解决这个问题，拉普拉斯修正就可以给未出现的特征值，赋予一个“小”的值而不是0    

####4.knn函数####
knn(train, test, cl, k = 1, l = 0, prob = FALSE, use.all = TRUE)
>* train和test参数分别代表训练集和测试集
>* cl用于放置训练集中各已知类别样本的类别取值
>* k为控制最近邻域大小的参数
>* l设置得到确切判别结果所需满足的最小票数
>* prob控制输出“胜出”类别的得票比例，比如k=10时，若其中有8个属于类别1，2个属于类别2，类别1则为“胜出”类别，且prob取TRUE时，可输出该待判样本所对应的prob值为8/10=0.8
>* use.all用于选择再出现“结点”时的处理方式，所谓结点即指距离待判样本第K近的已知样本不止一个，比如，已知样本i和j与待判样本n的距离相等，都刚好第K近，那么当use.all默认取TRUE时就将i和j都纳入判别过程，这时n的K近邻就有K+1个样本，若use.all取FALSE时，则R软件会在i和j中随机选出一个以保证K近邻中刚好有K个样本
 
####5.kknn函数####
kknn(formula = formula(train), train, test, na.action = na.omit(), k = 7, distance = 2, kernel = "optimal", ykernel = NULL, scale=TRUE,contrasts = c('unordered' = "contr.dummy", ordered = "contr.ordinal"))    
>* distance参数用于设定选择计算样本间距离的具体方法，通过设定明氏距离(Minkowski Distance)中的参数来实现，取1或2时的明氏距离是最为常用的，参数取2时即为欧式距离，取1时为曼哈顿距离，当取无穷时的极限情况下，可以得到切比雪夫距离。
###数据集###
kknn软件包中的miete数据集，该数据集记录了1994年慕尼黑的住房租金标准中的一些有趣变量，比如房子的面积、是否有浴室等，这些都影响并决定着租金的高低。
####数据概况####    

```r
library(kknn)
data(miete)
head(miete)
dim(miete)
summary(miete)
```
nmkat共含有5个类等级别，每一个类的样本量都为200多个，分布较为均匀。
<table>
	<tr>
		<td>变量名称</td>
		<td>变量类型</td>
		<td>实际含义</td>
		<td>是否使用</td>
		<td>不适用原因</td>
	</tr>
	<tr>
		<td>nm</td>
		<td>定量</td>
		<td>净租金(单位：德国马克)</td>
		<td>否</td>
		<td>使用相应的定性变量nmkat</td>
	</tr>
	<tr>
		<td>wfl</td>
		<td>定量</td>
		<td>占地面积(单位：平方米)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>bj</td>
		<td>定量</td>
		<td>建造年份</td>
		<td>否</td>
		<td>使用相应的定性变量bjkat</td>
	</tr>
	<tr>
		<td>bad0</td>
		<td>定性</td>
		<td>是否有浴室(1无，0有)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>zh</td>
		<td>定性</td>
		<td>是否有中央供暖(1有，0无)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>ww0</td>
		<td>定性</td>
		<td>是否有提供热水(1无，0有)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>badkach</td>
		<td>定性</td>
		<td>是否有铺瓷砖的浴室(1有，0无)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>fenster</td>
		<td>定性</td>
		<td>窗户类型(1普通，0优质)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>kueche</td>
		<td>定性</td>
		<td>厨房类型(1设施齐全，0普通)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>mvdauer</td>
		<td>定量</td>
		<td>可租赁期(单位：年)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>bjkat</td>
		<td>定性</td>
		<td>按区间划分的建造年代（1：1919年前；2：1919-1948年；3：1945-1965年；4：1966-1977年；5：1978-1983年；6：1983年后）</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>wflkat</td>
		<td>定性</td>
		<td>按区间划分的占地面积(1：少于50平方米；2：51-80平方米；3：至少81平方米)</td>
		<td>否</td>
		<td>使用相应的定量变量wfl</td>
	</tr>
	<tr>
		<td>nmqm</td>
		<td>定量</td>
		<td>净租金/平方米</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>rooms</td>
		<td>定性</td>
		<td>房间数</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>nmkat</td>
		<td>定性</td>
		<td>按区间划分的净租金(1：少于500马克；2：500-675马克；3：675-850马克；4：850-1150马克；5：至少1150马克)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>adr</td>
		<td>定性</td>
		<td>地理位置(1：差；2：中；3：优)</td>
		<td>是</td>
		<td>--</td>
	</tr>
	<tr>
		<td>wohn</td>
		<td>定性</td>
		<td>住宅环境(1：差；2：中；3：优)</td>
		<td>是</td>
		<td>--</td>
	</tr>
</table>

####数据预处理####
```r
library(sampling)
set.seed(1234)
n<-round(2/3*nrow(miete)/5) #按照训练集占数据总量2/3的比例，计算每一等级中应抽取的样本量
sub_train<-strata(miete,stratanames = "nmkat",size = rep(n,5),method = "srswor")  #以nmkat变量的5个等级划分层次，进行分层抽样
head(sub_train)
data_train<-getdata(miete[,c(-1,-3,-12)],sub_train$ID_unit)
data_test<-getdata(miete[,c(-1,-3,-12)],-sub_train$ID_unit)
```

##3应用案例##
###线性判别分析###
1.公式formula格式
```r
library(MASS)
fit_lda1<-lda(nmkat~.,data_train)
names(fit_lda1)  
fit_lda1$prior #查看本次执行过程中所使用的先验概率
fit_lda1$counts #查看各类别的样本量
fit_lda1$means #查看各变量在每一类别中的均值
```
2.数据框data.frame及矩阵matrix格式
```r
fit_lda2<-lda(data_train[,-12],data_train[,12])
fit_lda2
```
3.判别规则可视化
```r
win.graph(width=45, height=22,pointsize=8)
plot(fit_lda1,dimen=1) #输出1个判别式的图形
plot(fit_lda1,dimen=2)  #输出2个判别式的图形
```
从图中可看到，租金等级从1至5的样本点在图中基本呈现从左往右依次散开的趋势，这与租金额依次增加的趋势是一致的；且1与5等级的样本点较为分散，2、3、4这三个中等租金额的样本点则聚集在一起。

4.对测试集判别变量取值进行预测
```r
pre_lda1<-predict(fit_lda1,data_test)
pre_lda1$class  #输出各样本的预测结果
pre_lda1$posterior #输出各样本属于后一类别的后验概率,每一样本属于各类别的后验概率最高者为该样本被判定的类别。
pre_lda1$x #
table(data_test$nmkat,pre_lda1$class) #生成nmkat变量的预测值与实际值的混淆值
#混淆矩阵中属于第3类的样本被错分的个数最多，这很可能是由于类别3与类别2、4的样本之间的相似度太高，表现在图形中即为有较大的重叠区域所导致的分类困难，这和前面图形中看到的结果相符。
error_lda1<-sum(as.numeric(pre_lda1$class)!=as.numeric(data_test$nmkat))/nrow(data_test) #计算错误率
```
###朴素贝叶斯分类###
1.公式formula格式
```r
fit_bayes1<-NaiveBayes(nmkat~.,data = data_train)
names(fit_bayes1)
fit_bayes1$apriori #先验概率
fit_bayes1$tables #用于建立判别规则的所有变量在各类别下的条件概率
fit_bayes1$levels #判别变量等级项
fit_bayes1$call #判别命令项
fit_bayes1$usekernel
fit_bayes1$varnames
```
如上，我们可以从tables项的输出结果中挖掘出很多有意思的信息。   
比如，变量bad0部分记录了“是否有浴室”变量在各租金等级下，取0(有浴室)和1(无浴室)的概率。具体的，在等级1(不足500马克)的租金水平下，有浴室的占到约90.97%，无浴室的占9%，而且我们看到这两列数据在各租金水平下的取值差异并不大，最贵的房子(等级5)中有100%有浴室，而最便宜的房子(等级1)中也约有91%配有浴室。因此，我们可以认为浴室基本是出租房屋的必备部件，是一种硬要求，对租金水平的高低并没有决定性作用。   
而地理位置adr和住宅环境wohn变量的情况就与bad0变量不太相同，这两个变量的取值有着明显的趋势：随着租金水平的提高（等级1至等级5），地理位置/住宅环境较差(取1)的房子越来越少，地段较好（取3）的房子越来越多。可见，像地段、环境这种软需求对于房价的影响是不可忽视的，一个优良的环境和便利的地段往往可以提升租金。   
2.各类别下变量密度可视化
```r
plot(fit_bayes1,vars="wfl",n=50) #对占地面积wfl绘制各类别下的密度图
plot(fit_bayes1,vars="mvdauer",n=50) #对租赁期mvdauer绘制各类别下的密度图
plot(fit_bayes1,vars="nmqm",n=50) #对每平方米净租金nmqm绘制各类别下的密度图
```
对于占地面积wfl变量，我们可以看到分别对应于5个租金等级的5条曲线的最高点从1至5依次右移，即所对应的占地面积水平依次提高，这是复合常识理解的，面积越大的房屋租金往往越高。具体的，可以观察到，1至3租金等级的样本多集中于40至60平方米的占地面积水平，而4、5等级，即租金高于850马克的房屋则在70-90平方米左右。     
租赁期mvdauer变量在各租金等级下的5条曲线有着一个极为明显的特征--租金等级为5的房租的租赁年限远低于其他4个等级，前4个等级的租赁期多为2、3年至30、40年不等，而等级5的租赁期则基本都集中于2年左右。   
每平米净租金nmqm变量在各租金水平下的分布看起来要均匀一些，即租金越高的房屋每平方米租金就越高，5条曲线按照等级顺序平稳依次右移，这也是符合我们理解的，单位面积租金高则总租金会高。    
3.默认格式
```r
fit_bayes2<-NaiveBayes(data_train[,-12],data_train[,12])
```
4.对测试集待判别变量取值进行预测
```r
pre_bayes1<-predict(fit_bayes1,data_test)
table(data_test$nmkat,pre_bayes1$class)
error_bayes1<-sum(as.numeric(pre_bayes1$class)!=as.numeric(data_test$nmkat))/nrow(data_test) #计算错误率
```
预测错误率约为50%，可以说判别效果不佳，基本等于纯猜测所得到的正确程度。这很可能是由于该数据集变量不符合朴素贝叶斯判别执行的前提条件--各变量条件独立，即参与建立判别规则的这些变量是有着较显著的相关性的，这就很大程度上影响了预测效果的好坏。    
而在实际数据中，变量间往往都多多少少有着相互关联性，因此，同样基于贝叶斯原理的贝叶斯网络（又称贝叶斯信念网络或信念网络）是贝叶斯判别中更高级、应用范围更广的一种算法。它放宽了变量无关的这一假设，将贝叶斯原理和图论想结合，建立起一种基于概率推理的数学模型，对于解决复杂的不确定性和关联性问题有很强的优势。

###K最近邻###
K最近邻和有权重K最近邻算法在R中的实现，与前面几种有着明显不同，其核心函数knn与kknn判别规则的“建立”和“预测”这两个步骤于一体，即不需在规则建立后再使用predict函数来进行预测。
```r
library(class)
fit_pre_knn<-knn(data_train[,-12],data_test[,-12],cl=data_train[,12])
table(data_test$nmkat,fit_pre_knn)
error_knn<-sum(as.numeric(fit_pre_knn)!=as.numeric(data_test$nmkat))/nrow(data_test) #计算错误率为0.298，判别效果较前几种算法都要好。这与数据集的特点密不可分，在其他的数据中也可能是另一种算法表现更优，在实际中需注意针对不同数据集选取使用不同的挖掘算法。
error_knn<-rep(0,20)
for(i in 1:20){
	fit_pre_knn<-knn(data_train[,-12],data_test[,-12],cl=data_train[,12],k=i)
	error_knn[i]<-sum(as.numeric(fit_pre_knn)!=as.numeric(data_test$nmkat))/nrow(data_test)
}
error_knn
plot(error_knn,type="l",xlab="K")#由图中可以看到，当K取3时预测效果最佳，此时错误率为0.284
```
但K近邻算法也有其缺陷，当样本不平衡，即某些类的样本容量很大，而其他类样本容量很小时，有可能导致当输入一个新样本时，该样本的K个最近邻样本中大容量类别的样本占多数，在这种情况下就可以使用有权重的K最近邻算法来改进。
###有权重的K最近邻###
```r
fit_pre_kknn<-kknn(nmkat~.,data_train,data_test[,-12],k=5)
summary(fit_pre_kknn)
fit<-fitted(fit_pre_kknn)
table(data_test$nmkat,fit)
error_kknn<-sum(as.numeric(fit)!=as.numeric(data_test$nmkat))/nrow(data_test)
```

##推荐系统综合实例##
MovieLens是一个推荐系统和虚拟社区网站，它的主要功能是运用协同过滤技术，以及所收集到的用户对电影的喜好信息，来向用户推荐电影。具体来说，MovieLens可根据用户对一部分电影的评分，预测出该用户对其他电影的评分情况。当一个新用户进入MovieLens，他需要对15部电影评分，评分范围为1~5分，评分间隔为0.5分。这样一来，当用户查看某部电影时，MovieLens的推荐系统就可以根据之前获取的该用户电影偏好信息，即以往的评分来预测其对该部电影的评分。   
###kNN与推荐###
首先，kNN的基本思想简单来说就是，要评价一个未知的东西U，就去找K个与U相似的已知的东西，看看这些已知的东西大多数是属于什么水平、什么程度、什么类别，据此就可以估计出U的水平、程度、类别。就像我们平常所说的，要看出一个人的性格，就去看看他周围朋友们都是怎样的一些人，这与kNN的原理是一个道理。    
而运用于推荐系统中，我们以电影为例，假如我们现在想要预测一位注册名为A的用户对电影M的评价。根据kNN的思想，我们就可以找出K个与A对其他电影给予相似评分，且对电影M已经进行评分的用户，然后再用这K个用户对M的评分来预测A对M的评分。这种找相似用户的方法被称之为基于用户的kNN(User-based kNN)。    
另外，我们也可以先找出K个与电影相似的，并且A评价过的电影，然后再用这K部电影的评分来预测A对M的评分。这种找相似物品的方法叫做基于项目的kNN(Item-based kNN)。
###MovieLens数据集说明###
http://www.grouplens.org/node/73    
u.data:含有943位用户对1682部电影总计10万条评分，且每位用户至少记录了其对20部电影的评分。格式上，每条数据按照用户ID(userid)、电影ID(itemid)、评分(rating)以及时间戳(timestamp)4个变量列示，样本排列是无序的，其中我们将主要用到前三个变量信息。   
u.item:记录每部电影的信息，包括电影ID(itemid)、电影名称(movie title)、上映时间(release date)、视频发布时间(video release date)、网络电影资料库的网址(IMDb URL)，以及是否为某类型电影的一系列二分变量，如是否为动作片(Action)、冒险片(Adventure)、动画片(Animation)等。这是探究各电影间相似性的重要数据资料。   
u.user:记录每位用户的基本信息，包括用户ID(user id)、年龄(age)、性别(gender)、职业(occupation)以及邮编(zip code)。这是探究各用户间相似性的重要信息来源。
###综合运用###
####1.整体思路####
User-based kNN算法    
目的：预测某位用户(其用户ID为U<sub>0</sub>)对某部电影(其电影ID为M<sub>0</sub>)的评分。    
步骤：1：选择用户U<sub>0</sub>已经给出评分的若干部电影，假设选择n部，并获取其电影ID，记为M<sub>1</sub>-M<sub>n</sub>    
2：再找出对电影M<sub>0</sub>已经给出评分的用户，假设有m位符合的用户，并获取其用户ID，记为U<sub>1</sub>-U<sub>m</sub>    
3:构造训练集和测试集
<table>
	<tr>
		<td rowspan=2 colspan=2></td>
		<td>待评分电影</td>
		<td colspan=3>已评分电影</td>
	</tr>
	<tr>
		<td>M<sub>0</sub></td>
		<td>M<sub>1</sub></td>
		<td>...</td>
		<td>M<sub>n</sub></td>
	</tr>
	<tr>
		<td>待评分用户</td>
		<td>U<sub>0</sub></td>
		<td>测试集(data_test_y)</td>
		<td colspan=3>测试集(data_test_y)</td>
	</tr>
	<tr>
		<td rowspan=3>已知评分用户</td>
		<td>U<sub>1</sub></td>
		<td rowspan=3>训练集(data_train_y)</td>
		<td rowspan=3 colspan=3>训练集(data_train_x)</td>
	</tr>
	<tr>
		<td>...</td>
	</tr>
	<tr>
		<td>U<sub>n</sub></td>
	</tr>
</table>
4:将相应的训练集与测试集按顺序放入knn函数，即可预测出用户U<sub>0</sub>对电影M<sub>0</sub>的评分值。
####2.数据集信息####
```r
data<-read.table("u.data")
data<-data[,-4]  #删除第4列，时间戳变量
names(data)<-c("userid","itemid","rating") #命名各变量名
dim(data)
```
####3.MovieLens_KNN函数的输入输出####
```r
MovieLens_KNN=function(Userid,Itemid,n,K){
	sub<-which(data$userid==Userid)  #获取待预测用户U<sub>0</sub>在数据集中各条信息所在的行标签，存于sub
	if(length(sub)>=n) sub_n<-sample(sub,n)
	if(length(sub)<n) sub_n<-sample(sub,length(sub))
	#获取随机抽出的n个U<sub>0</sub>已评分电影M<sub>1</sub>-M<sub>n</sub>的行标签，存于sub_n
	known_itemid<-data$itemid[sub_n]  #获取U<sub>0</sub>已评分电影M<sub>1</sub>-M<sub>n</sub>的电影ID
	unknown_itemid<-Itemid #获取待预测电影M<sub>0</sub>的ID号
	unknown_sub<-which(data$itemid==unknown_itemid)
	user<-data$userid[unknown_sub[-1]]
	data_all<-matrix(0,1+length(user),2+length(known_itemid))
	data_all<-data.frame(data_all)
	names(data_all)<-c("userid",paste("unkown_itemid_",Itemid),paste("itemid_",known_itemid,sep=""))
	item<-c(unknown_itemid,known_itemid)
	data_all$userid<-c(Userid,user)
	for(i in 1:nrow(data_all)){
		data_temp<-data[which(data$userid==data_all$userid[i]),]
		for(j in 1:length(item)){
			if(sum(as.numeric(data_temp$itemid==item[j]))!=0){
				data_all[i,j+1]<-data_temp$rating[which(data_temp$itemid==item[j])]
			}
		}
	}
	data_test_x<-data_all[1,c(-1,-2)]
	data_test_y<-data_all[1,2]
	data_train_x<-data_all[-1,c(-1,-2)]
	data_train_y<-data_all[-1,2]
	fit<-knn(data_train_x,data_test_x,cl=data_train_y,k=K)
	return list("data_all:"=data_all,"True Rating:"=data_test_y,"Predict Rating:"=fit,"User Id:"=Userid,"Item ID:"=Itemid)
}
```