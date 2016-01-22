## 2数据概览 ##

### 数据抽样 ###
1.简单随机抽样

sample(x, size, replace = FALSE, prob = NULL)  
>* x表示待抽样对象，一般以向量形式表示
>* size表示想要抽取样本的个数
>* replace表示是否为可放回抽样，默认情况下为无放回
>* prob用于设置各抽样样本的抽样概率，默认情况下无取值，即为等概率抽样

```r
#可放回抽样
sub1<-sample(nrow(iris),10,replace = T)
sub1
iris[sub1,]
#更改prob参数测试
sub2<-sample(nrow(iris),10,replace = T,prob=c(rep(0,nrow(iris)-1),1))
sub2
#无放回抽样
sub3<-sample(nrow(iris),10,replace = F)
```

2.分层抽样
strata(data, stratanames=NULL, size, method=c("srswor","srswr","poisson",
"systematic"), pik,description=FALSE)  
>* data为待抽样数据集
>* stratanames中放置进行分层所依据的变量名称
>* size用于设置各层中将要抽出的观测样本数，其顺序应当与数据集中该变量各水平出现顺序一致，且在使用该函数前，应当先对数据集按照该变量进行升序排序
>* method用于选择其中列示的4种抽样方法，分别为无放回、有放回、泊松、系统抽样，默认情况下为srswor
>* pik用于设置各层中各样本的抽样概率
>* description用于选择是否输出含有各层基本信息的结果

```r
library(sampling) 
library(MASS)
sub4<-strata(Insurance,stratanames = "District",size = c(1,2,3,4),method = "srswor") #按街区District进行分层，且1~4街区中分别无放回抽取1~4个样本
getdata(Insurance,sub4)  #获取分层抽样所得的数据集
sub6<-strata(Insurance,stratanames = "District",size = c(1,2,3,4),method = "systematic",pik=Insurance$Claims) #选择系统抽样方法，并以Claims变量控制各层中的抽样概率
```

> 在某变量的各个水平下，数据集中其他变量的取值有明显差异时，分层抽样是一个非常合适的选择。这样可以保持数据总体与样本数据集的分布一致性，在后续的数据分析和数据挖掘过程中能够避免数据不平衡等问题。

3.整群抽样
cluster(data, clustername, size, method=c("srswor","srswr","poisson",
"systematic"),pik,description=FALSE)
>* clustername指用来划分群的变量名称
>* size不再为分层抽样中的一个向量，此处仅为一个正整数，表示要抽取的群数。
>* 其他参数和strata相同

```r
sub7<-cluster(Insurance,clustername = "District",size = 2,method = "srswor",description = T)
```

>在考虑使用整群抽样时，一般要求各群对数据总体有较好的代表性，即群内各样本的差异要大，而群间的差异要小。因此，当群间差距较大时，整群抽样往往具有样本分布面不广、样本对总体的代表性相对较差等缺点。



