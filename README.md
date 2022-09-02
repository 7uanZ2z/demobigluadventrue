# biglulu

Developed with Unreal Engine 4

demo2 做了一个地牢地图生成器，主要生成算法写在cpp中，而其他的gameplay基本写到lua(unlua插件练练手)，除了AI用的是蓝图编写，
启动关卡是LEVEL/Test2

在gamemode之中有三个可调节参数 1.mainlength 设置主干道的长度 2.branchsum 设置枝干生成的数量 3.bisvisitor设置为true的时候可以俯瞰整个地图全貌
按下M可以看大地图情况，

该地图的实现在mapsubsystem中， 该算法简单来说， 先一个随机深度遍历出主干道，然后给每个点每个方向加权，并把二维地图flatten成一维数组，进行随机采样（采样优化用的是树状数组），这样的带权采样能够个性化的调节地图生成的倾向和偏重

此外还给地牢生成后写了简单的gameplay机制，如下

1.第三人称射击，长按左键达到一定时间可以发射弹药，时间越长发射力度越大

2.地图随机生成鸡腿奖励block用于加血， 或者敌人block用于挑战

3.地牢模式，以地牢block，只有打完当前block才能前往下一个block，除非是奖励block

4.敌人有两种，青蛙能够吐水泡攻击，主角受到水泡伤害则会扣血， boss熊能跳起来直接踩死主角

5.boss一定在mainlength最深层，打完boss则结束

