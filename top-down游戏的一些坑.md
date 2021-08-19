# top-down游戏的一些坑（一）
## 什么是top-down？
俯视视角的游戏。
## 案例一：2D人物 3D场景 [鹰角网络CEO黄一峰谈《明日方舟》3D和2D的结合方案](https://zhuanlan.zhihu.com/p/329988294?utm_source=wechat_session&utm_medium=social&utm_oi=1343661238379950080&utm_campaign=shareopn)
### 问题一：空间关系错误
* 尝试关闭ZTest或者使用多个摄像机进行渲染  
  ZTest:  
  ![ZTest](https://raw.githubusercontent.com/kovit1995/IsometricGame/master/rUeLv3v.png)  
  从流程图中可以看出：  
在开启ZTest下，没有通过测试的片元部分是直接被舍弃，通过测试的片元被保留下来  
在关闭ZTest下，不存在片元被舍弃的情况，也就是说，关闭深度测试，整个片元是被保留下来的  
在ZWrite开启状态下，只有保留下来片元深度值才能被写入深度缓冲  
>* 无法被前面的场景正确的遮挡
* 解决方案  
  使用斜着的2D模型经过MVP变化后的结果进行渲染，但是在顶点变换的最后，需要用上面竖立时所处的深度值修改顶点的深度值，就能欺骗过VertShader与FragmentShader之间的深度检测环节，就可以达到预期想要的遮挡关系，防止前后穿模。  
