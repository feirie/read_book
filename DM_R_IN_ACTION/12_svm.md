#12支持向量机#
支持向量机是数据挖掘的一项新技术，是借助于最优化方法来解决机器学习问题的新工具，开始成为克服“维数灾难”和过学习等困难的强有力的手段。它在解决小样本、非线性及高维度模式识别中表现出很多优势，并能够推广应用到函数拟合等其他机器学习问题中。   
支持向量机方法建立在统计学理论的VC维理论和结构风险最小原理基础之上，根据有限样本在模型的复杂性和学习能力之间寻求最佳折中，以期获得最好的推广能力。其中，模型的复杂性是指对特定训练样本的学习精度，学习能力是指无错误地识别任意样本的能力。
##R中的实现##
###相关软件包###
e1071软件包可以用于指出向量机建模及分析
###核心函数###
svm(formula, data = NULL, ..., subset, na.action =na.omit, scale = TRUE)   
svm(x, y = NULL, scale = TRUE, type = NULL, kernel ="radial", degree = 3, gamma = if (is.vector(x)) 1 else 1 / ncol(x),coef0 = 0, cost = 1, nu = 0.5,class.weights = NULL, cachesize = 40, tolerance = 0.001, epsilon = 0.1,shrinking = TRUE, cross = 0, probability = FALSE, fitted = TRUE,..., subset, na.action = na.omit)
>* formula代表的是函数模型的形式
>* data代表的是模型中包含有变量的一组可选格式数据
>* x可以是一个数据矩阵，也可以是一个数据向量，同时也可以是一个稀疏矩阵
>* y是对于x数据的结果标签，它既可以是字符向量也可以是数量向量
>* type是指建立模型的类别。支持向量机模型通常可以用作分类模型、回归模型或者异常检测模型。所以在svm函数中type可取值有：C-classification、nu-classification、one-classification、eps-regression、nu-regression。前三种是针对于字符型结果变量的分类方式，其中第三种方式是逻辑判别，即判别结果输出所需判别的样本是否属于该类别；而后俩种则是针对数量型结果变量的分类方式。
>* kernel是指在模型建立过程中使用的核函数。支持向量机模型的建模过程中为了解决线性不可分的问题，提高模型预测精度，通常会核函数对原始特征进行变换，提高原始特征维度，解决支持向量机模型线性不可分问题。   
svm函数的kernel参数有4个可选核函数，分别为线性核函数linear(u'u)、多项式核函数polynomial((λu'u+coef0)<sup>degree</sup>)、径向基核函数(也称高斯核函数)radial basis(exp(-λ|u-v|<sup>2</sup>))及神经网络核函数sigmoid(tanh(λu'u+coef0))。相应的研究发现，识别率最高、性能最好的是径向基核函数，其次是多项式核函数，而最差的是神经网络核函数。    
核函数有两种主要类型--局部性核函数和全局性核函数，径向基核函数是一个局部性核函数，而多项式核函数则是一个典型的全局性核函数。局部性核函数仅仅在测试点附近小领域内对数据点有影响，其学习能力强、泛化性能较弱；而全局性核函数则相对来说泛化性能较强、学习能力较弱。
>* degree参数是指函数多项式内积函数中的参数，默认值为3
>* gamma参数是指函数中除线性内积函数以外的所有函数的参数，默认值为1
>* coef0参数是指核函数中多项式内积函数与sigmoid内积函数中的参数，默认值为0
>* nu参数是指用于nu-classification、nu-regression和one-classification回归类型中的参数
svm函数在对数据建立模型后输出的结果
>* SV即support vectors,就是支持向量机模型中最核心的支持向量
>* Index所包含的结果是模型中支持向量在样本数据中的位置，简而言之就是支持向量是样本数据的第几个样本
在利用svm函数建立支持向量机模型时，使用标准化后的数据建立的模型效果更好。

plot(x,data,formula,fill=TRUE,grid=50,slice=list(),symbolPalette=palette(),svSymbol="x",dataSymbol="o",...)
>* x为支持向量机模型
>* data是指绘制支持向量机分类图所采用的数据
>* formula是用来观察任意两个特征维度对模型分类的相互影响
>* fill参数为逻辑参数，当取TRUE时，所绘制的图像具有背景色，反之没有
>* symbolPalette参数主要用于决定分类点以及支持向量的颜色
>* svSymbol参数主要决定支持向量的形状
>* dataSymbol参数主要决定数据散点图的形状


##应用案例##
###建立模型###
```r
data(iris)
summary(iris)
model<-svm(Species~.,data=iris) #
x<-iris[,-5]
y<-iris[,5]
model2<-svm(x,y,kernel = "radial",gamma = if(is.vector(x)) 1 else 1/ncol(x)) #gamma系数取值：如果特征向量是向量则gamma值取1，否则gamma值为特征向量个数的倒数。
summary(model)
```
模型结果中SVM-Type项目说明本模型的类别为C分类器模型；SVM-Kernel说明本模型所使用的核函数为高斯内积函数且核函数中参数gamma的取值为0.25；cost说明本模型确定的约束违反成本为1。对于该数据，模型找到了51个支持向量：第一类具有8个支持向量，第二类具有22个支持向量，第三类具有21个支持向量。最后说明了模型中的三个类别分别为：setosa、versicolor和virginica。
###预测判别###
```r
pred<-predict(model,x)
table(pred,y)
```
###综合建模###
支持向量分类机就有三类，同时可以选择的核函数有四类。所以在时间和精力允许的情况下，应该尽可能建立所有可能模型，最后通过比较选出判别结果最优的模型。
```r
type<-c("C-classification","nu-classification","one-classification") #确定将要使用的分类方式
kernel<-c("linear","polynomial","radial","sigmoid") #确定将要使用的核函数
pred<-array(0,dim=c(150,3,4)) #初始化预测结果矩阵的三维长度分别为150，3，4
accuracy<-matrix(0,3,4) #初始化模型精准度矩阵的维度分别为3，4
yy<-as.integer(y) #为方便模型精度计算，将结果变量数量化为1，2，3
for(i in 1:3){
	for(j in 1:4){
		pred[,i,j]<-predict(svm(x,y,type=type[i],kernel=kernel[j]),x)
		if(i>2) accuracy[i,j]<-sum(pred[,i,j]!=1)
		else accuracy[i,j]<-sum(pred[,i,j]!=yy)
	}
}
dimnames(accuracy)<-list(type,kernel) #确定模型精度变量的列名和行名
accuracy
table(pred[,1,3],y)
```
从表中的模型预测结果可以看出，利用one-classification方式无论采取何种核函数得出的结果错误都非常多。所以可以看出该方式不适合这类数据类型的判别。使用one-classification方式进行建模时，数据通常情况下为一个类别的特征，建立的模型主要用于判别其他样本是否属于这类。C-classification与高斯核函数结合的模型判别错误最小，如果我们建立模型的目的主要是为了总体误判率最低，并且各种类型判错的代价是相同的，那么就可以直接选择这个模型作为最优模型。

###可视化分析###
```r
plot(cmdscale(dist(iris[,-5])),col=c("red","black","blue")[as.integer(iris[,5])],pch=c("o","+")[1:150 %in% model$index + 1])
legend(2,0,c("setosa","versicolor","virginica"),col=c("red","black","blue"),lty=1)
```
"+"表示的是支持向量，"o"表示的是普通样本点。图中setosa类别同其他两种区别较大，而剩下的versicolor和virginica却相差很小，甚至存在交叉难以区分。这也在另一个角度解释了模型预测过程中出现的问题。

```r
plot(model,iris,Sepal.Width~Petal.Length,fill=FALSE,symbolPalette=c("red","black","blue"),svSymbol="+")
legend(2,0,c("setosa","versicolor","virginica"),col=c("red","black","blue"),lty=1)
```
从图中可以看出，virginica类别的花瓣在长度和宽度的总体水平上都高于两个类别，而versicolor类别的花瓣在长度和宽度的总体水平上处于居中位置，而setosa类别的花瓣在长度和宽度上都比另外两个类别小。
###优化建模###
针对以上情况，我们可以想到改变模型各个类别的比重来对数据进行调整，由于setosa同其他两个类别相差较大，所以我们可以考虑降低类别setosa在模型中的比重，而提高另外两个类别的比重，即适当牺牲类别setosa的精度来提高其他两个类别的精度。可以通过svm函数的class.weights参数来进行调整。
```r
wts<-c(1,1,1)  #各类别为1：1：1时，模型就是最原始的模型
names(wts)<-c("setosa","versicolor","virginica")
model1<-svm(x,y,class.weights=wts)

wts<-c(1,100,100)  
names(wts)<-c("setosa","versicolor","virginica")
model2<-svm(x,y,class.weights=wts)
pred2<-predict(model2,x)
table(pred2,y)

wts<-c(1,500,500)  
names(wts)<-c("setosa","versicolor","virginica")
model3<-svm(x,y,class.weights=wts)
pred3<-predict(model3,x)
table(pred3,y)
```
通过对权重的调整后，该模型能够将所有样本全部预测正确。所以，在实际构建模型的过程中，在必要的时候可以通过改变各样本之间的权重比例来提高模型的预测精度。