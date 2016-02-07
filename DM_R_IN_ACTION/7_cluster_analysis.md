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
 dbscan(data, eps, MinPts = 5, scale = FALSE, method = c("hybrid", "raw","dist"), seeds = TRUE, showplot = FALSE, countmode = NULL)
>* data为待聚类数据集或距离矩阵
>* eps为考核每一个样本点是否满足密度要求时，所划定考察邻域的半径
>* MinPts为密度阀值，当考核点eps邻域内的样本点数大于等于MinPts时，该点才被认为是核心对象，否则为边缘点
>* scale用于选择是否在聚类前先对数据集进行标准化
>* method参数用于选择如何看待data，"hybrid"表示data为距离矩阵，"raw"表示data为原始数据集,且不计算其距离矩阵,"dist"也将data视为原始数据集，但计算局部聚类矩阵
>* showplot用于选择是否输出聚类结果示意图，取值为0、1、2，分别表示不绘图、每次迭代都绘图、仅将子迭代过程绘图

###4.hclust、cutree及rect.hclust函数###
hclust(d, method = "complete", members = NULL)
>* d为待处理数据集样本间的距离矩阵，可用dist()函数计算得到
>* method参数用于选择聚类的具体算法，可供选择的有ward、single及complete等7种，默认选择complete方法
>* members用于指出每个待聚类样本点/簇是由几个单样本构成，如共有5个待聚类样本点/簇，当我们设置members=rep(2,5)则表明每个样本点/簇分别是有2个单样本聚类的结果，该参数默认为NULL，表明每个样本点本身即为单样本   

cutree()函数可以对hclust()函数的聚类结果进行剪枝，即选择输出指定类别数的系谱聚类结果。格式为：    
cutree(tree, k = NULL, h = NULL)
>* tree为hclust的聚类结果

rect.hclust()可以在plot形成的系谱聚类图中将指定类别中的样本分支用方框表示出来，十分有助于直观分析聚类结果。   
rect.hclust(tree, k = NULL, which = NULL, x = NULL, h = NULL, border = 2, cluster = NULL)
###5.Mclust、mclustBIC、mclust2Dplot###
Mclust(data, G = NULL, modelNames = NULL, prior = NULL, control = emControl(),initialization = NULL, warn = mclust.options("warn"), ...)
>* Mclust函数为进行EM聚类的核心函数
>* data为待处理数据集
>* G为预设类别数，默认值为1至9，即由软件根据BIC在1至9中选择最优值
>* modelNames用于设定模型类别，该参数和G一样也可由函数自动选择最优值
mclustBIC函数的参数设置与Mclust基本相同，用于获取数据集所对应的参数化高斯混合模型的BIC值，而BIC值的作用即是评价模型的优劣，BIC值越高模型越优。mclust2Dplot可根据EM算法所生成参数对二维数据制图。而densityMclust函数利用Mclust的聚类结果对数据集中的每个样本点进行密度估计。    

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

plot(1:67,result,type="b",main="choosing theoptimal number of cluster",xlab="number of cluster:1 to 67",ylab="betweenss/totss") #对result简单制图
points(10,result[10],pch=16) #将类别数为10的点用实心圆标出
legend(10,result[10],paste("(10,",sprintf("%.1f%%",result[10]*100),")",sep=""),bty="n",xjust=0.3,cex=0.8)
#实际上，最优类别数可以认为是10，也可以认为是9、11、12等，并无太大差别，因此，此处我们不妨取k=10为最优类别数。在实际选择过程中，如果并非要求极高的聚类效果，取k=5或6即可，较小的类别数在后续的数据分析过程中往往是更为方便、有效的。

fit_km2<-kmeans(countries[,-1],centers = 10)
cluster_CHINA<-fit_km2$cluster[which(countries$country=="CHINA")]
which(fit_km2$cluster==cluster_CHINA)  #选出与中国大陆同类别的地区
```
###K-中心点聚类###
```r
library(cluster)
fit_pam<-pam(countries[,-1],3)
print(fit_pam)
#输出结果，medoids致命了聚类完成时各类别的中心点分别是哪几个样本点，取值为多少。“Objective function”目标方程组给出了build和swap俩个过程中目标方程的值。其中，build过程用于在未指定初始中心点情况下，对于最优初始中心点的寻找；而swap过程则用于在初始中心点的基础上，对目标方程寻找使其能达到局部最优的类别划分状态，即其他划分方式都会使目标方程的取值低于该值。
```
###系谱聚类###
```r
fit_hc<-hclust(dist(countries[,-1])) #进行系谱聚类
print(fit_hc)
plot(fit_hc) #对聚类结果做系谱图
#图中与中国在出生率和死亡率方面最为相近的国家为智利(CHILE)和阿尔及利亚(ALGERIA)。在树的左侧以高度指标(Height)衡量树形图的高度，这一指标在下面将要提到的剪枝过程中将会用到。
group_k3<-cutree(fit_hc,k=3)
table(group_k3)
group_h18<-cutree(fit_hc,h=18) #利用剪枝函数中的参数h控制输出height=18时的系谱聚类结果
table(group_h18)
rect.hclust(fit_hc,k=4,border = "light gray")
rect.hclust(fit_hc,k=3,border = "dark gray")
rect.hclust(fit_hc,k=7,which=c(2,6),border = "dark gray")
```

###密度聚类###

```r
library("fpc")
ds1<-dbscan(countries[,-1],eps=1,MinPts = 5)
ds2<-dbscan(countries[,-1],eps=4,MinPts = 5)
ds3<-dbscan(countries[,-1],eps=4,MinPts = 2)
ds4<-dbscan(countries[,-1],eps=8,MinPts = 2)
par(mfcol=c(2,2))
plot(ds1,countries[,-1],main="1:MinPts=5 eps=1")
plot(ds2,countries[,-1],main="2:MinPts=5 eps=4")
plot(ds3,countries[,-1],main="3:MinPts=2 eps=4")
plot(ds4,countries[,-1],main="4:MinPts=2 eps=8")
```
ds1解释：在MinPts=5，eps=1时，样本点被聚类为两类，其中第1类中含有6个样本，即以上输出结果中标号为1所对应的列，seed所对应的行，也就是我们在理论部分所说的相互密度可达的核心对象所构成的类别，即为类别A；另有3个样本点，即border所对应的行中的数字3，也就是与类别A密度相连的边缘点所构成的类别，即为B；另外，标号0所对应列为噪声点的个数，此处为59。   
我们可以看出，在半径为1，阀值为5时，DBSCAN算法将绝大多数样本都判定位噪声点，仅9个密度极为相近(在半径为1的圆内至少含有5个其他样本)的样本点被判定为有效聚类。
ds2解释：我们尝试将半径扩大，阀值不作改变，如此一来会有较多的样本被有效分类。从输出结果中，可以看到仅有5个样本被判定为噪声点，而剩余样本都被归为相应的类别簇中。具体的，样本点被聚于4个类别中，所含样本点数分别为7、1、18、37。    
ds3解释：这一次，我们尝试不改变半径，而将阀值减小。从输出结果中，可以看到更多的样本被归入相互密度可达样本的类别，即seed行中；而边缘点总数仅为3，所有样本被聚为3类，分别含有25、3、38个样本点。    
ds4解释：保持阀值不变为2，把半径翻倍为8，由于核心对象、密度可达等概念的判定条件在很大程度上被放松，可想而知，会有大量的样本点被归为同一类中。由输出结果，在总共68个样本中，其中66个被聚为1类，仅有2个样本点由于偏离主体样本太多而被单独聚为一类。   
由以上过程，我们基本可以看出DBSCAN算法参数取值的规律：半径参数与阀值参数的取值差距越大（如情形1与4），所得类别总数越小（都为2类别）；具体的，半径参数相对于阀值参数较小时（如情形1与2），越多的样本被判定为噪声点（分别为59和5）或边缘点（分别为63和13）。   

```r
#我们考虑查看大多数样本间的距离是在怎样一个范围，再以此距离作为半径参数的取值，这样则可以很大程度上保证大部分样本被聚于类别内，而不被认为是噪声点。
d<-dist(countries[,-1])
max(d);min(d)
library(ggplot2)  #为了使用数据分段函数cut_interval()
interval<-cut_interval(d,30)
#对各样本间的距离进行分段处理，结合最大最小值相差50左右，取居中段数为30
table(interval)
which.max(table(interval))  #发现样本点的距离大多在3.51至5.16之间，因此我们考虑半径参数eps的取值为3、4、5.如下，我们对半径去3、4、5，密度阀值为1至10，作双层循环结果如下
for(i in 3:5){
	for(j in 1:10){
		ds<-dbscan(countries[,-1],eps=i,MinPts = j)
		print(ds)
	}
}
```
根据如上汇总结果来选取合适的参数值。一般来说，类别数应至少高于2类，否则进行聚类的意义不大；并且噪声点不应太多，若太多则说明参数条件过紧，参与有效聚类的样本数太少。
###期望最大化聚类###
```r
library(mclust)
fit_EM<-Mclust(countries[,-1])
summary(fit_EM) #从输出结果可以看到，根据BIC选择出的最佳模型类型为EVI，最优类别为4，且各类分别含有11、2、36、19个样本。
summary(fit_EM,parameters = T) #获取EM聚类结果的细节信息
plot(fit_EM)#当对Mclust的聚类结果直接作图，可以得到4张连续图形，分别为BIC图、分类图(Classification)、概率图(Classification Uncertainty)以及密度图(log Density Countour Plot)。    
#概率图不仅将各类别样本的主要分布区域用椭圆圈出，并标出了类别中心点，且以样本点图形的大小，来显示该样本归属于相应类别的概率大小。 

countries_BIC<-mclustBIC(countries[,-1])
countries_BICsum<-summary(countries_BIC,data=countries[,-1])
countries_BICsum  #如上我们得到BIC值最高时的模型情况及BIC取值，分别为4分类的EVI模型、3分类的EEI模型以及3分类的EII模型。

mclust2Dplot(countries[,-1],classification = countries_BICsum$classification,parameters = countries_BICsum$parameters,col="black")

countries_dens<-densityMclust(countries[,-1]) #对每一个样本进行密度估计
plot(countries_dens,countries[,-1],col="grey",nlevels=55) #做2维密度图
plot(countries_dens,type="persp",col=grey(0.8)) #做3维密度图
```
  

