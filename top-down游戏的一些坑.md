# top-down游戏的一些坑（一）
## 什么是top-down？
俯视视角的游戏。
## 案例一：2D人物 3D场景 [鹰角网络CEO黄一峰谈《明日方舟》3D和2D的结合方案](https://zhuanlan.zhihu.com/p/329988294?utm_source=wechat_session&utm_medium=social&utm_oi=1343661238379950080&utm_campaign=shareopn)
### 问题一：空间关系错误
* 尝试关闭ZTest或者使用多个摄像机进行渲染  
  ZTest:  
  
>* 无法被前面的场景正确的遮挡