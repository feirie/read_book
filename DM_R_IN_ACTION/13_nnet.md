#13神经网络#
神经网络常用于两类问题：分类和回归。   
在使用神经网络时有几点需要注意：   
1.神经网络很难解释，目前还没有能对神经网络做出显而易见解释的方法学。   
2.神经网络会学习过度，在训练神经网络时一定要恰当地使用一些能严格衡量神经网络的方法，如前面提到的测试集方法和交叉验证方法等。这主要是由于神经网络太灵活、可变参数太多，如果给足够的时间，他几乎可以"记住"任何事情。   
3.除非问题非常简单，训练一个神经网络可能需要相当可观的时间才能完成。当然，一旦神经网络建立好了，用它来预测运行还是很快的。
##R中的实现##
nnet软件包是用来建立单隐藏层的前馈人工神经网络模型，同时也能用来建立多项对数线性模型。
###核心函数###
1.class.ind函数   
class.ind函数是用来对数据进行预处理的，这也正是该函数最重要以及唯一的一项功能。更具体地说，该函数是用来对建模数据中的结果变量进行处理的。该函数对结果变量的处理，其实是通过结果变量的因子变量来生成一个类指标矩阵。    
class.ind(cl) 
>* cl可以是一个因子向量，也可以是一个类别向量。

```r
v1<-c("a","b","a","c")
v2<-c(1,2,1,3)
class.ind(v1)
class.ind(v2)
```
2.nnet函数   
函数nnet是实现神经网络的核心函数，它主要用来建立单隐藏层的前馈人工神经网络模型，同时也可以用该函数建立无隐藏层的前馈人工神经网络模型。    
nnet(formula, data, weights, ...,subset, na.action, contrasts = NULL)    
nnet(x, y, weights, size, Wts, mask,linout = FALSE, entropy = FALSE, softmax = FALSE,censored = FALSE, skip = FALSE, rang = 0.7, decay = 0,maxit = 100, Hess = FALSE, trace = TRUE, MaxNWts = 1000,abstol = 1.0e-4, reltol = 1.0e-8, ...)
>* formula代表的是函数模型的形式
>* data代表的是模型中包含有变量的一组可选格式数据
>* weights代表的是各样本在模型中所占的权重，该参数的默认值为1，即各类样本按原始比例建立模型
>* subset主要用于抽取样本数据中的部分样本作为训练集，该参数所使用的数据格式为一向量，向量中的每个数代表所需要抽取样本的行数
>* x为一个矩阵或者一个格式化数据集，是建立人工神经网络模型所需要的自变量数据
>* y是建立人工神经网络模型中所需要的类别变量数据。这里的类别变量y是class.ind处理后生成的类指标矩阵
>* size代表的是隐藏层中的节点个数。该隐藏层的节点个数通常为输入层节点个数的1.2倍至1.5倍，即自变量个数的1.2倍至1.5倍。这里如果将参数值设定为0，则表示建立的模型为无隐藏的人工神经网络模型。
>* rang指的是初始随机权重的范围是[-rang,rang]。通常情况下，该参数的值只有在输入变量很大的情况下才会取到0.5左右，而一般对于确定该参数的值时存在一个公式的，即rang与x的绝对值中的最大值的乘积大约等于1。
>* decay是指在模型建立过程中，模型权重值得衰减精度，即当模型的权重值每次衰减小于该参数值时，模型将不再进行迭代。
>* maxit控制的是模型的最大迭代次数，即在模型迭代过程中，如果一直没有触碰模型迭代停止的其他条件，那么模型将会在迭代达到该最大次数后停止模型迭代，这个参数的设置主要是为了防止模型的死循环或者是一些没必要的迭代。

nnet函数的输出结果
>* 输出结果wts。该结果中包含了在模型迭代过程中所寻找到的最优权重值，我们也可以将其理解为模型的最优系数。
>* 输出结果residuals。该结果包含了训练集的残差值。
>* 输出结果convergence。该结果表示在模型建立的迭代过程中，迭代次数是否达到最大迭代次数。如果结果为1，则表明迭代次数达到最大迭代次数；如果结果为0则表明没有达到最大迭代次数。如果结果达到了最大迭代次数，我们就应该对模型的建立进行进一步分析，因为模型建立过程中是因为达到最大迭代次数才停止迭代的，则说明迭代过程中没有触碰到其他决定模型精度的条件，这就很可能会导致我们建立出来的模型精度并不高，并不是最优模型，所以应考虑是否提高最大迭代次数后再次进行模型估计。   
总的说来，如果模型中的类别变量为一个含有因子的变量，则我们将建立的人工网络模型就是一个分类模型。而如果类别变量不是一个含有因子的变量，则模型将无法建立。    
3.nnetHess函数   
该函数用来估计人工神经网络模型中的黑塞矩阵（即二次导数矩阵）。   
nnetHess(net, x, y, weights)

##应用案例##
###数据处理###
作为建立人工神经网络模型的处理方式主要进行数据的归一化。数据归一化方法是神经网络预测前对数据常做的一种处理方法，即将所有数据都转化为[0,1]之间的数，其目的是取消各维度数据间数量级的差别，避免因为输入输出数据数量级差别较大而造成网络预测误差较大。   
数据归一化的方法主要有以下两种：    
1.最大最小法，函数形式为
x<sub>k</sub>=(x<sub>k</sub>-x<sub>min</sub>)/(x<sub>max</sub>-x<sub>min</sub>)   
x<sub>min</sub>为数据序列中的最小数，x<sub>max</sub>为数据序列中的最大数   
2.平均数方差法，函数形式为
x<sub>k</sub>=(x<sub>k</sub>-x<sub>mean</sub>)/x<sub>var</sub>   
x<sub>mean</sub>为数据序列的均值，x<sub>var</sub>为数据的方差
```r
scale01=function(x){
	ncol<-dim(x)[2]-1 #
	nrow<-dim(x)[1]
	new_scale<-matrix(0,nrow,ncol)
	for(i in 1:ncol){
		max<-max(x[,i])
		min<-min(x[,i])
		for(j in 1:nrow){
			new_scale[j,i]<-(x[j,i]-min)/(max-min)
		}
	}
	new_scale
}
```
###建立模型###
```r
wine<-read.csv("winequality-white.csv",sep = ";")
wine$quality.factor<-NA
wine$quality.factor[which(wine$quality<6)]<-"bad"
wine$quality.factor[which(wine$quality>6)]<-"good"
wine$quality.factor[which(wine$quality==6)]<-"mid"
wine$quality.factor<-factor(wine$quality.factor)
wine$quality<-NULL
set.seed(71)
samp<-sample(1:nrow(wine),3000)
wine[samp,1:11]<-scale01(wine[samp,])
r<-1/max(abs(wine[samp,1:11]))
set.seed(101)
model1<-nnet(quality.factor~.,data=wine,subset=samp,size=4,rang=r,decay=5e-4,maxit=200)

x<-subset(wine,select=-quality.factor)
y<-wine[,12]
y<-class.ind(y)
set.seed(101)
model2<-nnet(x,y,size=4,rang=r,decay=5e-4,maxit=200)
```
权重衰减速度最小值为5e-4，最大迭代次数为200，隐藏层的节点数为4个，最终我们建立出来的模型是一个11-4-3的网络神经网络模型，即输入层是11个节点，隐藏层是4个节点，输出层是3个节点。
###预测判别###
```r
x<-wine[,1:11]
pred<-predict(model1,x,type="class")
set.seed(110)
pred[sample(1:nrow(wine),8)]

xt<-wine[,1:11]
pred<-predict(model2,xt)
dim(pred)
pred[sample(1:4898,4),]

name<-c("bad","good","mid")
pred_max_col<-max.col(pred)
pred_name<-name[pred_max_col]  #将预测结果转换为类别名称
table(max.col(y),pred_max_col)
```

###模型差异分析###
在利用nnet函数建立模型的过程时，其中参数Wts的值我们通常默认为原始值。但是在nnet函数中，参数Wts的值在建立模型过程中用于迭代的权重初始值，该参数的默认值为系统随机生成，换而言之就是，我们每次建立模型所使用的迭代初始值都是不相同的。因此我们在实际建模过程中会遇到这样的现象：我们使用同样的数据，采用同样的节点，设定同样的参数，但是最后会得到两个不同的模型，甚至是天壤之别的两个模型。

```r
data(iris)
x<-iris[,-5]
y<-class.ind(iris[,5])
model1<-nnet(x,y,rang=1/max(abs(x)),size=4,maxit=500,decay=5e-4)
model2<-nnet(x,y,rang=1/max(abs(x)),size=4,maxit=500,decay=5e-4)
```
从3个方面对模型差异进行分析   
1.模型是否因为迭代次数达到最大值而停止   
```r
model1$convergence
model2$convergence
```
俩个模型的迭代结果都为0，说明了在建立模型过程中，迭代的停止并非是因为模型的迭代次数达到了最大迭代次数。所以说明模型的最大迭代次数并不是影响两个模型不同的主要原因。    
2.模型迭代的最终值    
```r
model1$value
model2$value
```
模型迭代的最终值即为模型拟合标准同模型权重衰减值的和。value值越小说明模型拟合效果越好。因为初始迭代值不同导致的模型不同的情况，我们应该多运行几次nnet函数，而选择所有模型中该结果值最小的一个模型作为最理想的模型。   
3.观察两个模型的预测效果   
```r
name<-c("setosa","versicolor","virginica")
pred1<-name[max.col(predict(model1,x))]
pred2<-name[max.col(predict(model2,x))]
table(iris$Species,pred1)
table(iris$Species,pred2)
```
人工神经网络模型的预测效果是该模型最重要最核心的作用，如果两个模型在预测能力上显示不出任何差异，那么我们讨论两个模型不同也就失去了意义，因为我们所追求的是模型的预测能力。

###优化建模###
确定出隐藏层最优节点的数目
```r
set.seed(71)
wine<-wine[sample(1:nrow(wine),3000),]
nrow.wine<-dim(wine)[1]
set.seed(444)
samp<-sample(1:nrow.wine,nrow.wine*0.7)
wine[samp,1:11]<-scale01(wine[samp,]) #对训练集样本进行预处理
wine[-samp,1:11]<-scale01(wine[-samp,]) #对测试集样本进行预处理
r<-1/max(abs(wine[samp,1:11]))
n<-length(samp)
err1<-0
err2<-0
for(i in 1:17){
	set.seed(111)
	model<-nnet(quality.factor~.,data=wine,maxit=400,rang=r,size=i,subset=samp,decay=5e-4)
	err1[i]<-sum(predict(model,wine[samp,1:11],type='class')!=wine[samp,12])/n
	err2[i]<-sum(predict(model,wine[-samp,1:11],type='class')!=wine[-samp,12])/(nrow.wine-n)
}
plot(1:17,err1,'l',col=1,lty=1,ylab="模型误判率",xlab="隐藏层节点个数",ylim=c(min(min(err1),min(err2)),max(max(err1),max(err2))))
lines(1:17,err2,col=1,lty=3)
points(1:17,err1,col=1,pch="+")
points(1:17,err2,col=1,pch="o")
legend(1,0.53,"测试集误判率",bty="n",cex=1.5)
legend(1,0.35,"训练集误判率",bty="n",cex=1.5)
```
由图示可以看出，训练集样本错误跟随隐藏层节点数的增加而下降，但是与此同时，测试集样本错误却未随着隐藏层节点的增加而下降，这种现象是由于模型中隐藏层节点数增加而引起的模型过度拟合导致的。模型针对测试集误判率大概在模型隐藏层节点数为3时取到最小点，所以我们将隐藏层节点数确定为3.  
从前文中我们分析到，当神经网络模型训练周期过长的时候，建立出的人工神经网络模型将会记录下训练集中几乎全部信息，这将会产生过度拟合的问题。即该模型针对于训练集的时候会体现出非常优异的预测能力，但是由于该模型记录下训练集中的全部信息，即该模型也将训练集中许多特有信息记录下来，所以当模型用于其他样本集的时候，模型的预测能力将会大大下降，即模型的泛化能力非常弱。    
在确定出最优隐藏层节点后，再确定出最优的迭代次数。
```r
err11<-0
err12<-0
for(i in 1:500){
	set.seed(111)
	model<-nnet(quality.factor~.,data=wine,maxit=i,rang=r,size=3,subset=samp,decay=5e-4)
	err11[i]<-sum(predict(model,wine[samp,1:11],type='class')!=wine[samp,12])/n
	err12[i]<-sum(predict(model,wine[-samp,1:11],type='class')!=wine[-samp,12])/(nrow.wine-n)
}
plot(1:length(err11),err11,'l',col=1,lty=1,ylab="模型误判率",xlab="训练周期",ylim=c(min(min(err11),min(err12)),max(max(err11),max(err12))))
lines(1:length(err11),err12,col=1,lty=3)

legend(250,0.47,"测试集误判率",bty="n",cex=1.5)
legend(250,0.35,"训练集误判率",bty="n",cex=1.5)
```
图中，模型针对于训练集和测试集的误判率均同时随训练周期的增大而降低。在前文理论部分中，谈论到当模型训练周期过长时，模型应该会出现过度拟合的问题，即在训练周期达到一定程度时，测试集误差将会反向变化，训练集误差将会随着模型训练周期的增大而增大。   
对于这个问题，当使用R软件进行模型构建时会经常遇到，但这并非说明理论出现了错误。对该问题进行进一步分析可以得知出现该问题存在两个原因。    
首先，在R软件的nnet程序包中，函数在构建模型时将会设定一个条件值以避免函数进入死循环。即在默认情况下，当函数计算值变化为零时模型将会停止运转，所以很多时候模型将不会运行到过高的训练周期。   
其次，由于训练集样本同测试集样本的相似度过高，所以训练集中的特征同样为测试集中的特征，所以即使在过度拟合的情况下，所构建的模型同样能很好地适用于与训练集相似度很高的数据集。   
尽管该图有一定问题，但是仍然具有一定的参考价值。训练集误差随着训练周期的增大而不断减小；但是对于测试集，当训练周期达到一定程度后，模型的误判率将会趋于平稳，模型的误判率将不再下降。根据上面分析，决定将模型的训练周期确定为300。   
