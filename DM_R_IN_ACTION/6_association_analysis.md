#6关联分析#
经典例子：啤酒与尿布   
20世纪90年代的时候，一位沃尔玛的超市管理员在分析销售数据时发现了一个“奇异”的现象：啤酒与尿布这俩件看起来毫无关系的商品，在某些情况下会经常出现在同一个购物篮中，经调查发现，这种现象多出现在年轻父亲身上。其背后的原因在于，在美国有婴儿的家庭中，一般是母亲在家中照看婴儿，父亲被派出去超市购买尿布。而年轻的父亲在购买尿布的同时，往往会顺便为自己购买爱喝的啤酒，因此出现了“啤酒”配“尿布”的奇异现象。此后，沃尔玛便开始在卖场尝试将其摆放在相同的区域，以此带来了可观的营业额增收。    
这一故事中的“啤酒”与“尿布”的 关系即为所谓的“关联性”。
##概述##
###1、项集(Itemset)###
这是一个集合的概念，在一篮子商品中一件消费品即为一项(Item），则若干项的集合称为项集，如{啤酒，尿布}即构成一个二元项集。   
###2、关联规则（Association Rule）###
一般记为X->Y的形式，称关联规则左侧的项集X为先决条件，右侧项集为相应的关联结果，用于表示出数据内隐含的关联性。入：关联规则尿布->啤酒成立则表示购买了尿布的消费者往往也会购买啤酒这一商品，即这俩个购买行为之间具有一定关联性。  
至于关联性的强度如何，则由关联分析中的三个核心概念--支持度、置信度和提升度来控制和评价。
下面我们以一组具体的数据来对这“三度”进行说明。  
假设有10000个消费者购买了商品，其中购买尿布的有1000个，购买啤酒的有2000个，购买面包的有500个，且同时购买尿布与啤酒的有800个，同时购买尿布与面包的有100个。
###3、支持度（Support）###
支持度是指在所有项集中{X,Y}出现的可能性，即项集中同时含有X和Y的概率：   
Support(X->Y)=P(X,Y)   
该指标作为建立强关联规则的第一个门槛，衡量了所考察关联规则在“量”上的多少。其意义在于通过最小阀值（minsup，Minimum Support）的设定，来剔除那些“出境率”较低的无意义规则，而相应地保留下出现较为频繁的项集所隐含的规则。上述过程用公式表示，即是筛选出满足：   
Support(Z)>=minsup   
的项集Z，被称为频繁项集（Frequent Itemset）。  
在上述的具体数据中，当我们设定最小阀值为5%，由于{尿布，啤酒}的支持度为800/10000=8%，而{尿布，面包}的支持度为100/10000=1%，则{尿布，啤酒}由于满足了基本的数据要求，成为频繁项集，则规则尿布->啤酒、啤酒->尿布同时被保留，而{尿布，面包}所对应的俩条规则都被排除。
###4、置信度（Confidence）###
置信度表示在关联规则的先决条件X发生的条件下，关联结果Y发生的概率，即含有X的项集中，同时含有Y的可能性：  
Confidence(X->Y)=P(Y|X)=P(XY)/P(X)  
这是生成强关联规则的第二道门槛，衡量了所考察关联规则的可靠性。相似的，我们需要对置信度设定最小阀值（mincon,Minimum Confidence)来实现进一步筛选，从而最终生成满足需要的强关联规则。因此，继筛选出频繁项集后，需从中进而选取满足：   
Confidence(X->Y)>=mincon   
的规则，至此完成所需关联规则的生成。   
具体的，当设定置信度的最小阀值为70%时，尿布->啤酒的置信度为800/1000=80%,而规则啤酒->尿布的置信度为800/2000=40%,被剔除。至此，我们根据需要筛选出了一条强关联规则--尿布->啤酒。
###5.提升度(lift)###
提升度表示在含有X的条件下同时含有Y的可能性与没有这个条件下项集中含有Y的可能性之比，即在Y自身出现可能性P(Y)的基础上，X的出现对于Y的“出镜率”P(Y|X)的提升程度。   
Lift(X->Y)=P(Y|X)/P(Y)   
该指标与置信度同样用于衡量规则的可靠性，可以看作是置信度的一种互补指标。   
举例来说，我们考虑1000个消费者，发现有500人购买了茶叶，其中有450人同时购买了咖啡，另50人没有，由于规则茶叶->咖啡的置信度高达450/500=90%,因此我们可能会认为喜欢喝茶的人往往喜欢喝咖啡。但当我们来看另外没有购买茶叶的500人，其中同样有450人也买了咖啡，且同样是很高的置信度90%，因此，我们看到不喝茶叶的人也爱喝咖啡。这样看来，其实是否购买咖啡，与有没有购买茶叶并没有关联，俩者是相互独立的，其提升度为90%/((450+450)/1000)=1.    
由此可见，提升度正是弥补了置信度的这一缺陷，当lift值为1时表示X与Y相互独立，X对Y出现的可能性没有提升作用，而其值越大（>1)则表明X对Y的提升程度越大，也即表明关联性越强。    
通过以上概念，我们可总结出关联分析的基本算法步骤。    
（1）选出满足支持度最小阀值的所有项集，即频繁项集。    
一般来说，由于所研究的数据集往往是海量的，我们想要考察的规则不可能占有其中的绝大部分。就像如果要考察买了啤酒的消费者还会购买哪些商品时，我们把阀值设置为50%，就基本已经提出了所有含有“啤酒”的 项，因为不可能去超市的消费者一半都买了啤酒。因此该阀值一般设定为5%~10%就足够了。   
（2）从频繁项集中找出满足最小置信度的所有规则。   
而置信度的阀值往往设定得较高，如70%~90%，因为这是我们剔除无意义的项集，获取强关联规则的重要步骤。当然，这也是依情况而定，如果想要获取大量关联规则，该阀值则可以设为较低的值。    
##R中实现##
###1.相关软件包###
本章将介绍R中俩个专用于关联分析的软件包--arules和arulesViz。其中，arules用于关联规则的数字化生成，提供了Apriori和Eclat这俩种快速挖掘频繁项集和关联规则算法的实现函数；而aruelsViz软件包作为arules的扩展包，提供了几种实用而新颖的关联规则可视化技术，使得关联分析从算法运行到结果呈现一体化。
###2.核心函数###
Apriori是最经典的关联分析挖掘算法，原理清晰且实现方便，可以说是学习关联分析的入门算法，但效率低；而Eclat算法则在运行效率方面有所提升。除此之外，还有FP-Growth等高效优化算法。
a.Apriori算法
在R中实现Apriori算法，其核心函数为apriori()。函数的基本格式为：
apriori(data,parameter=NULL,appearance=NULL,control=NULL)
当放置相应的数据集，并设置各个参数值（如：支持度和置信度的阀值）后，运行该函数即可生成满足需求的频繁项集或关联规则等结果。
>* 下面我们来具体说明其中parameter、appearance以及control的用途，三者分别包含若干可由人为设置的参数。
>* parameter参数可以对支持度、置信度、每个项集所含项数的最大值/最小值(maxlen/minlen)，以及输出结果（target）等重要参数进行设置。如果没有对其进行设值，函数将对各参数取默认值：support=0.1，confidence=0.8，maxlen=10，minlen=1，target="rules"/"frequent itemsets"(输出关联规则/频繁项集）。
>* 而参数appearance可以对先决条件X(lhs)和关联结果(rhs)中具体包含哪些项进行限制，如：设置lhs=beer,将仅输出lhs中含有“啤酒”这一项的关联规则，在默认情况下，所有项都将无限制出现。
>* control参数则用来控制函数性能，如可以设定对项集进行升序（sort=1）还是降序（sort=-1）排序，是否向使用者报告进程（verbose=TRUE/FALSE)等。
b.eclat函数
eclat(data,parameter=NULL,control=NULL)
>* 与apriori()相比，我们看到参数parameter和control被保留，而不含有appearance参数。其中parameter与control的作用与apriori()中基本相同，但需要注意的是，parameter中的输出结果(target）一项不可设置为rules,即通过eclat()函数无法生成关联规则，并且maxlen的默认值为5.
3.数据集
我们选择arules包中Groceries数据集，该数据集市某一食品杂货店一个月的真实交易数据。
```r
library(arules)
data(Groceries)
summary(Groceries)
#获取数据后，我们来看Groceries的基本信息，它共包含9835条交易（transactions)以及169个项（items)，也就是我们通常所说的商品；并且全脂牛奶（whole milk）是最受欢迎的商品，之后依次为蔬菜（other vegetables)、面包卷（rolls/buns)等。
inspect(Groceries[1:10])  #观测数据集中前10行数据
```
##三、应用案例##
###1.数据初探###
首先，我们尝试对apriori()函数以最少的限制，来观察它可以反馈给我们哪些信息，再以此决定下一步操作。这俩将支持度的最小阀值（minsup）设置为0.001，置信度最小阀值（minicon）设为0.5，其他参数不进行设定取默认值，并将所得关联规则名记为rules0。
```r
rules0<-apriori(Groceries,parameter=list(support=0.001,confidence=0.5))
rules0
inspect(rules0[1:10])
```
我们可以看到rules0中共包含5668条关联规则，可以想象，若将如此大量的关联规则全部输出是没有意义的。
###2.对生成规则进行强度控制###
最常用的方法即是通过提高支持度和/或置信度的值来实现这一目的；这往往是一个不断调整的过程。而最终关联规则的规模大小，或者说强度高低，是根据使用者的需要决定的。但需要知道，如果阀值设定较高，容易丢失有用信息，若设定较低，则生成的规则数量将会很大。   
一般来说，我们可以选择先不对参数进行设置，直接使用apriori函数的默认值（支持度为0.1，置信度为0.8）来生成规则，再进一步调整。或者如上一节所示，先将阀值设定得很低，再逐步提高阀值，直至达到设想的规则规模或强度。

a.通过支持度、置信度共同控制
首先，我们可以考虑将支持度与置信度俩个指标共同提高来实现，如下当仅将支持度提高0.004至0.005时，规则数降为120条，进而调整置信度参数至0.64后，仅剩下4条规则。另外，在俩参数共同调整过程中，如果更注重关联项集在总体中所占的比例，则可以适当地多提高支持度的值；若是更注重规则本身的可靠性，则可多提高一些置信度值。
```r
rules1<-apriori(Groceries,parameter=list(support=0.005,confidence=0.5)) #120
rules2<-apriori(Groceries,parameter=list(support=0.005,confidence=0.6)) #22
rules3<-apriori(Groceries,parameter=list(support=0.005,confidence=0.64)) #4
inspect(rules3)
```
b.主要通过支持度控制
另外，也可以采取对其中一个指标给予固定阀值，再按照其他指标来选择前5强的关联规则。比如当我们想要按照支持度来选择，则可以运行如下程序
```r
rules.sorted_sup<-sort(rules0,by="support")
```
c.主要通过置信度控制
```r
rules.sorted_conf<-sort(rules0,by="confidence")
inspect(rules.sorted_conf[1:10])#第一条规则：购买了米和糖的消费者，都购买了全脂牛奶。这是一条相当有用的关联规则，正如这些食品在超市中往往摆放得很近。
```
d.主要通过提升度控制
```r
rules.sorted_lift<-sort(rules0,by="lift")
inspect(rules.sorted_lift[1:5])
```
由上一节的理论知识，我们知道提升度可以说是筛选关联规则最可靠的指标，且得到的结论往往也是很有趣，且有用的。由以上输出结果，我们能够清晰地看到强度最高的关联规则为{即食食品，苏打水}->{汉堡肉}，其后为{苏打水，爆米花}->{垃圾食品}。这是一个符合直观猜想的有趣结果，我们甚至可以想象出，形成如此强关联性的购物行为的消费者是一批辛苦工作一周后去超市大采购，打算周末在家好好放松，吃薯片、泡方便面、喝饮料、看电影的上班族。

###3.一个实际应用###
下面我们结合实际讨论一个例子，相信你在逛超市时一定发现过俩种商品捆绑销售的情况，这可能是因为商家想要促销其中的某件商品。比如我们现在想要促销一种比较冷门的商品--芥末(mustard)，可以通过函数apriori()中的关联结果（rhs)设置为"mustard"，来搜索出rhs中仅包含mustard的关联规则，从而有效地找到mustard的强关联商品，来作为捆绑商品。
如下输出结果显示蛋黄酱(mayonnaise)是芥末(mustard)的强关联商品，因此我们可以考虑将它们捆绑起来摆放在货架上，并制定一个合适的共同购买价格，从而对俩种商品同时产生促销效果。另外，我们还用到了参数maxlen，这里将其设为2，控制lhs中仅包含一种商品，这是因为在实际的情况中，我们一般仅将俩种商品进行捆绑，而不是一堆商品。
```r
rules4<-apriori(Groceries,parameter=list(support=0.001,confidence=0.1,maxlen=2),appearance=list(rhs="mustard",default="lhs"))
inspect(rules4)
```
###4.改变输出结果形式###
我们知道,apriori和eclat函数都可以根据需要输出频繁项集(frequent itemsets)等其他形式结果。比如我们想知道某超市这个月销量最高的商品，或者捆绑销售策略在哪些商品簇中作用最显著等，选择输出给定条件下的频繁项集即可。
如下即是将目标参数（target）设为“frequent itemsets”后的结果。
```r
itemsets_apr<-apriori(Groceries,parameter=list(support=0.001,target="frequent itemsets"),control=list(sort=-1))
inspect(itemsets_apr[1:5])
```
如上结果，我们看到以sort参数对项集频率进行降序排序后，销量前5的商品分别为全脂牛奶、蔬菜、面包卷、苏打以及酸奶。
以下我们使用eclat函数来获取最适合进行捆绑销售，或者说最近摆放的5对商品。比如，下面的输出结果中的全脂牛奶和蜂蜜，以及全脂牛奶与苏打作为共同出现最为频繁的俩种商品，则可以考虑采取相邻摆放等营销策略。
```r
itemsets_ecl<-eclat(Groceries,parameter=list(minlen=1,maxlen=3,support=0.001,target="frequent itemsets"),control=list(sort=-1))
inspect(itemsets_ecl[1:5])
```
另外，你可能注意到，在itemsets的生成代码中，我们并没有对confidence值进行设置，这里并非选择了取默认值，而是因为频繁项集的产生仅与支持度阀值有关。读者可尝试改动参数confidence的值，输出结果将不受影响。

5.关联规则的可视化
```r
library(arulesViz)
rules5<-apriori(Groceries,parameter=list(support=0.002,confidence=0.5)) #生成关联规则rules5
plot(rules5)
#从图中我们可以看出大量规则的参数取值分布情况，如提升度较高的关联规则的支持度往往较低，支持度与置信度具有明显反相关性等。但不足之处在于，并不能具体得知这些规则对应的是哪些商品，及他们的关联强度如何等信息。而这一缺陷可通过互动参数（interactive）的设置来弥补。
plot(rules5,interactive=TRUE)

#另外我们还可以将shading参数设置为“order”来绘制出一种特殊的散列图--Two-Key图。横纵坐标依然为支持度和置信度，而关联规则点的颜色深浅则表示其所代表的关联规则中含有商品的多少，商品的种类越多，点的颜色越深。
plot(rules5,shading="order",control=list(main="two-key plot"))

#从图中按照lift参数来看，关联性最强（圆点颜色最深）的俩种商品为黄油（butter）与生/酸奶油（whipped/sour cream）；而以support来看，则是热带水果（tropical fruit）与全脂牛奶（whole milk）关联性最强(圆点尺寸最大）。
plot(rules5,method="grouped")
```