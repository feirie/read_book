#8判别分析#
##1概述##
本章我们将介绍三大类主流的判别分析算法，分别为费希尔(Fisher)判别、贝叶斯(Bayes)判别和距离判别。具体的，在费希尔判别中我们将主要讨论线性判别分析(Linear Discriminant Analysis,简称LDA)及其原理一般化后的衍生算法，即二次判别算法(Quadratic Discriminant Analysis,简称QDA);而在贝叶斯判别中将介绍朴素贝叶斯分类(Naive Bayes Classification)算法；距离判别将介绍最为广泛的K最近邻(k-Nearest Neighbor,简称kNN)及有权重的K最近邻(Weighted k-Nearest Neighbor)算法。    
###费希尔判别###
费希尔判别的基本思想是“投影”，即将高维空间的点向低维空间投影，进而简化问题进行处理。费希尔判别最重要的就是选择出适当的投影轴，对该投影轴方向上的要求是：保证投影后，使每一类之间的投影值所形成的类内离差尽可能小，而不同类之间的投影值所形成的类间离差尽可能大，即在该空间中有最佳的可分离性以此获得较高的判别效果。   
具体的，对于线性判别，一般来说，可以先将样本点投影到一维空间，即直线上，若效果不明显，则可以考虑增加一个维度，即投影到二维空间中，依次类推。而二次判别与线性判别的区别在于投影面的形状不同，二次判别使用若干二次曲面，而非直线或平面来将样本划分至相应的类别中。    
相比较来说，二次判别的适用面比线性判别函数要广。这是因为，在实际的模式识别问题中，各类别样本在特征空间中的分布往往比较复杂，因此往往无法用线性分类的方式得到令人满意的效果。这就必须使用非线性的分类方法，而二次判别函数就是一种常用的非线性判别函数，尤其是类域的形状接近二次超曲面体时效果更优。
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
fit_lda1<-lda(nmkat~.,data_train)
names(fit_lda1)  
fit_lda1$prior #查看本次执行过程中所使用的先验概率
fit_lda1$counts #查看各类别的样本量
fit_lda1$means #查看各变量在每一类别中的均值
```
2.数据框data.frame及矩阵matrix格式
```r
fit_lda2<-lda(data_train[,-12],data_train[,12])
```