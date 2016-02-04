#7聚类分析#
##1概述##
###K-均值聚类###
K-均值聚类(K-Means)是最早出现的聚类分析算法之一，它是一种快速聚类方法，但对于异常值或极值敏感，稳定性差，因此较适合处理分布集中的大样本数据集。   
它的思路是以随机选择的k(预设类别数)个样本作为起始中心点，将其余样本归入相似度最高中心点所在的簇(cluster)，再确立当前簇中样本坐标的均值为新的中心点，依次循环迭代下去，直至所有样本所属类别不再变动。
###K-中心点聚类###
K-中心点聚类(K-Medoids)与K-均值聚类在原理上十分相近，它是针对于K-均值聚类易受极值影响这一缺点的改进算法。在原理上的差异在于选择各类别中心点时不取样本均值点，而在类别内选取到其余样本距离之和最小的样本为中心。
###系谱聚类###
系谱聚类的名称来自于，其聚类的过程可以通过类似于系谱图的形式呈现出来。相对于K-中心点聚类和K-均值聚类，系谱算法的突出特点在于，不需要事先设定类别数k，这是因为它每次迭代过程仅将距离最近的俩个样本/簇聚为一类，其运作过程自然得到k=1至k=n（n为待分类样本总数）个类别的聚类结果。
###密度聚类(DBSCAN,Densit-based Spatial Clustering of Application with Noise)###
DBSCAN算法是基于密度的聚类算法(Densit-based Methods)中最常用的代表算法之一，另外还有OPTICS算法、DENCLUE算法等。   
基于密度的聚类算法相对于以上三种基于距离的的聚类算法，其优势在于弥补了他们只能发现"类圆形"聚类簇的缺陷，该算法由于是基于"密度"来聚类的，可以在具有噪声的空间数据库中发现任意形状的簇。
###期望最大化聚类(EM,Expectation Maximization)###
EM算法的思路十分巧妙，在使用该算法进行聚类时，它将数据集看做一个含有隐形变量的概率模型，并以实现模型最优化，即获取与数据本身性质最契合的聚类方式为目的，通过“反复估计”模型参数找出最优解，同时给出相应的最优类别数k。而“反复估计”的过程即是EM算法的精华所在，这一过程由E-step(Expection)和M-step(Maximization)这俩个步骤交替进行来实现。
##2R中的实现##
###相关软件包###

<table>
  <tr>
    <td>聚类算法</td>
    <td>软件包</td>
    <td>主要函数</td>
  </tr>
  <tr>
    <td>K-均值</td>
    <td>stats(主要包含一些基本的统计函数，如用于统计计算和随机数生成等)</td>
	<td>kmeans()</td>
  </tr>
  <tr>
    <td>K-中心点</td>
    <td>cluster(专用于聚类分析，含有很多聚类相关的函数及数据集)</td>
	<td>pam()</td>
  </tr>
  <tr>
    <td>系谱聚类</td>
    <td>stats</td>
	<td>hclust(),cutree(),rect.hclust()</td>
  </tr>
  <tr>
    <td>密度聚类</td>
    <td>fpc(含有若干聚类算法函数，如固定点聚类、线性回归聚类、DBSCAN聚类等)</td>
	<td>dbscan()</td>
  </tr>
  <tr>
    <td>期望最大化聚类</td>
    <td>mclust(主要用来处理基于高斯混合模型，通过EM算法实现的聚类、分类以及密度估计等问题)</td>
	<td>Mclust()、clustBIC()、mclust2Dplot()、densityMclust()</td>
  </tr>
</table>

###核心函数###
####1.kmeans函数####
kmeans(x, centers, iter.max = 10, nstart = 1,algorithm = c("Hartigan-Wong", "Lloyd", "Forgy","MacQueen"), trace=FALSE)
>* x为进行聚类的数据集
>* centers为预设类别数k
>* iter.max为迭代的最大数，且默认值为10
>* nstart为选择随机起始中心点的次数，默认取1
>* algorithm则提供了4种算法选择，默认为Hartigan-Wong

####2.pam函数####
```r
pam(x, k, diss = inherits(x, "dist"), metric = "euclidean",
    medoids = NULL, stand = FALSE, cluster.only = FALSE,
    do.swap = TRUE,
    keep.diss = !diss && !cluster.only && n < 100,
    keep.data = !diss && !cluster.only,
    pamonce = FALSE, trace.lev = 0)
```
>* x与k分别表示待处理数据及类别数
>* metric参数用于选择样本点间距离测算的方式，可供选择的有"euclidean"与"manhattan"
>* medoids默认取NULL,即由软件选择初始中心点样本，也可认为设定一个k维向量来指定初始点
>* stand用于选择对数据进行聚类前是否需要进行标准化
>* cluster.only用于选择是否仅获取各样本所归属的类别这一项聚类结果，若选择TRUE，则聚类过程效率更高
>* keep.data选择是否在聚类结果中保留数据集

####3.dbscan函数####

###数据集###
```r
countries<-read.csv("birth.csv",header = F)
dim(countries)
head(countries)
names(countries)<-c("country","birth","death")
countries_rowname<-as.character(countries$country)
for(i in 1:68) row.names(countries)[i]<-countries_rowname[i]

plot(countries$birth,countries$death)
#关注的国家
attention_countries<-c("CHINA","TAIWAN","HONG KONG","INDIA","UNITED STATES","JAPAN")
attention_countries<-c(attention_countries,as.character(countries[which.max(countries$birth),1]))
for(i in 1:length(attention_countries)){
	c<-which(countries$country==attention_countries[i])
	points(countries[c,-1],pch=16) 
	legend(countries$birth[c],countries$death[c],as.character(countries[c,1]),bty="n",xjust=0.5,yjust=1,cex=0.8)
}
```

##3应用案例##
###K-均值聚类###
```r
set.seed(123)
fit_km1<-kmeans(countries[,-1],centers = 3)
print(fit_km1)
#3个类别所含样本数，分布为15，17和36；以及各类别中心点坐标(Cluster means),即第1类可以认为是中等出生率、低死亡率，第2类为低出生率、低死亡率，而第3类为高出生率、高死亡率。从聚类向量(Clustering vector)一栏看到中国大陆及港台都归属于第1类，这之后，软件给出了各类别的组内平方和，1至3类依次升高，即第1类样本点间的差异性最小，第三类最大，且组间平方和占总平方和的81%，该值可用于与类别数取不同值时的聚类结果进行比较，从而找出最优聚类结果，该百分数越大表明组内差距越小、组间差距越大，即聚类效果最好；最后，还可根据获得结果(Available components)部分来分别获取聚类的各项输出结果。
#组间平方和+组内平方和=总平方和
#绘制聚类结果
plot(countries[,-1],pch=(fit_km1$cluster-1))  #将countries数据集中聚为3类的样本点以3种不同形状表示
points(fit_km1$centers,pch=8) #将3类别的中心点以星号标示
legend(fit_km1$centers[1,1],fit_km1$centers[1,2],legend = "Center_1",bty = "n",xjust = 1,yjust = 0,cex = 0.8) 
legend(fit_km1$centers[2,1],fit_km1$centers[2,2],legend = "Center_2",bty = "n",xjust = 1,yjust = 0,cex = 0.8) 
legend(fit_km1$centers[3,1],fit_km1$centers[3,2],legend = "Center_3",bty = "n",xjust = 1,yjust = 0,cex = 0.8) 
#从图中可以看到，中国大陆及港台聚于第1类，即中等出生率、低死亡率，美国、日本和印度都属于低出生率、低死亡率的第2类。

#接下来，我们来调节类别参数center的取值，并通过前面所讨论的组间平方和占总平方和的百分比值(以下简称为“聚类优度”)，来比较选择出最优类别数。
result<-rep(0,67)
for(k in 1:67){
	fit_km<-kmeans(countries[,-1],centers = k)
	result[k]<-fit_km$betweenss/fit_km$totss
}
round(result,2) #在类别约小于10时，随着类别数的增加而聚类效果越来越好(result值从0.72快速提高至0.97左右)；但当类别数超过10之后再增加时，聚类效果基本不再提高(result值在0.97至1.00之间浮动)。这是符合我们理解的，当类别数基本接近样本点数，即接近于形成每个样本自成一类的情形时，聚类效果肯定是最好的，但却是无意义的。
```

