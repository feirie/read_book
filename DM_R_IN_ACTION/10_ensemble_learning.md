# 10 集成学习 #
---
若我们以民主选举过程来比拟分类器的运作过程，则选举中每位选民的一次投票相当于一个基分类器的分类结果，而一大批选民的一次投票则可以认为是一个集成分类算法的分类结果。可以想象，如果选举仅由一个人的投票来决定，那么选举结果的稳定性、可靠性都是很值得怀疑的，因为如果换一个人来投票，或在同一个人的不同情绪状况下投票，结果将会有很大差异，正如一个基分类器的分类结果往往难以令人满意；而若是由全民投票来产生结果，则这一结果可以提现大多数人的意志，就算多举行几次投票，结果也将稳定，且可以认为该结果是正确的。这正是将基分类器进行集成的目的所在－－使分类结果稳定，且正确率高。

##10.1 概述##
###10.1.1 一个概率论小计算###
首先，我们从一个简单的概率论小计算引入，来说明"集成"的功效:设共有n个基分类器，每个基分类器的预测正确率都为0.5，即一半的正确率，相当于乱猜;但当我们考虑用这n个基分类器共同进行预测，该预测结果正确的概率P等于"1-n个分类器全部预测错误的概率"，即P=1-(1-0.5)^n。
在n=5时，P=0.96875；n=15时，P=0.99997;n=25时，P=1.00000.也就是说，25个"乱猜"的基分类器预测结果"集成"后，其预测正确率趋近于1，这就是"集成算法"的基本思想和神奇所在。
### 10.1.2 Bagging算法 ###
Bagging是Bootstrap Aggregating的缩写，简单来说，就是通过使用bootstrap抽样(bootstrap，自助抽样法是一种从给定训练集中等概率、有放回地进行重复抽样，也就是说，每当选中一个样本，它等可能地被再次选中并被再次添加到训练集中)得到若干不同的训练集，以这些训练集分别建立模型，即得到一系列基分类器，这些分类器由于来自不同的训练样本，他们对同一测试集的预测效果不一。因此，Bagging算法随后对基分类器的一系列预测结果进行投票(分类问题)或平均(回归问题)，从而得到每一个测试集样本的最终预测结果，这一集成后的结果往往是准确而稳定的。
比如现有基分类器1到10，它们对某样本的预测结果分别为类别1、2、1、1、1、1、2、1、1、2，则Bagging给出的最终结果即为"该样本属于类别1"，因为大多数基分类器将票投给了类别1.

### 10.1.3 AdaBoost算法 ###
AdaBoost相对于Bagging算法更为巧妙，且一般来说是效果更优的集成分类算法，尤其在数据集分布不平衡的情况下，其优势更为显著。该算法的提出先于Bagging，但在复杂度和效果上高于Bagging，因此考虑先行介绍Bagging算法。
AdaBoost同样是在若干基分类器基础上的一种集成算法，但不同于Bagging对一系列预测结果的简单综合，该算法在依次构建基分类器的过程中，会根据上一个基分类器对各训练集样本的预测结果，自行调整在本次基分类器构造时，各样本被抽中的概率。具体来说，如果在上一基分类器的预测中，样本i被错误分类了，那么在这一次基分类器的训练样本抽取过程中，样本i就会被赋予较高的权重，以使其能够以较大的可能被抽中，从而提高其被正确分类的概率。
这样一个实时调节权重的过程正是AdaBoost算法的优势所在，它通过将若干具有互补性质的基分类器集合于一体，显著提高了集成分类器的稳定性和准确性。另外，Bagging和AdaBoost的基分类器的选取都是任意的，但绝大多数我们使用决策树，因为决策树可以同时处理数值、类别、次序等各类型变量，且变量的选择也较容易。

##10.2 R中的实现##
adabag软件包实现了Bagging和AdaBoost这俩种算法。

###核心函数###
1.bagging函数
bagging(formula, data, mfinal = 100, control,...)
>* formula表示用于建模的公式
>* data中放置待训练数据集
>* mfinal表示算法的迭代次数，即基分类器的个数，可设置为任意整数，默认值为100
>* control参数与rpart函数中的相同

2.boosting函数
  boosting(formula, data, boos = TRUE, mfinal = 100, coeflearn = 'Breiman',control,...)
>* boos参数用于选择在当下迭代过程中，是否用各观测样本的相应权重来抽取bootstrap样本，其默认值为T，如果取F，则每个观测样本都以其相应权重在迭代过程中被使用
>* coeflearn用于选择权重更新系数alpha的计算方式，默认取Breiman，即alpha=1/2ln((1-err)/err)，另外也可更改设置为"Freund"或"Zhu"。
>* 其他参数与bagging中完全相同

###数据集###
使用UCI中的[Bank Marketing数据集](http://mlr.cs.umass.edu/ml/datasets/Bank+Marketing),该数据集来自于某葡萄牙银行机构的一个基于电话跟踪的商业营销项目，其中收录了包括银行客户个人信息与电话跟踪咨询结果有关的16个自变量，以及一个因变量--该客户是否订阅了银行的定期存款。
```r
data<-read.csv("bank.csv",header = T,sep = ";")
dim(data)
head(data)
sub<-sample(1:nrow(data),round(nrow(data)/4))
length(sub)
data_train<-data[-sub,]
data_test<-data[sub,]
```

##10.3应用案例##
###Bagging算法###
```r
library(adabag)
library(rpart)
bag<-bagging(y~.,data_train,mfinal = 5)  #为了便于说明输出结果在迭代过程中生成5颗决策树，即设mfinal=5
names(bag)  #显示模型bag所生成的输出项名称
bag1<-bagging(y~.,data_train,mfinal = 5,control=rpart.control(maxdepth=3))
#之前查看bag模型的trees输出项，得到子树过于茂盛的问题，可以通过control参数中树的深度maxdepth来控制基分类树的大小，这里设置为3，所得子树的复杂度明显降低。
```
bagging输出项解释
>* formula为建模的公式
>* trees为每颗决策树的情况
>* votes为Bagging算法对每一个观测样本关于俩个类别no和yes的投票votes情况，由于共建立了5颗决策树，且每棵树对每一样本的类别都有各自的判定，且总票数为5.Bagging算法最终即是根据某样本在各类别中所获得票数的高低来决定该样本所属的类别。
>* prob可以看做是votes结果的百分比形式。
>* class为各样本所属类别的最终判断。
>* samples为每次迭代过程中所使用的bootstrap样本。
>* importance为各输入变量在分类过程中的相对重要性。从中可以明显看到客户的工作类型job有着极高的重要性，也就是说，客户从事何种类型的工作对其是否会订阅银行的定期存款有着密切的联系。

```r
pre_bag<-predict(bag,data_test)
names(pre_bag)
pre_bag$confusion #查看混淆矩阵，可以看到属于no类的样本大部分被正确预测了，属于yes类的样本大部分被错误预测。这是不平衡数据问题，yes相对于no类别来说，是数据集中的少数类，其在分类模型中的训练不足，难以达到令人满意的预测效果。
err_bag<-sum(pre_bag$class!=data_test$y)/nrow(data_test) #总错误率
sub_minor<-which(data_test$y=="yes") #取yes类在测试集中的编号
sub_major<-which(data_test$y=="no") #取no类在测试集中的编号
err_minor_bag<-sum(pre_bag$class[sub_minor]!=data_test$y[sub_minor])/length(sub_minor)  #计算yes类的错误率
err_major_bag<-sum(pre_bag$class[sub_major]!=data_test$y[sub_major])/length(sub_major) #计算no类的错误率
```
no类的错误率仅为0.03430878，而yes类的错误率高达0.6978417，这正是由于数据的不平衡性造成的。Adaboost算法在处理不平衡数据集时具有一定优势。