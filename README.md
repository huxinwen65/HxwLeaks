# HxwLeaks
自定义内存检测工具（UIViewController）
直接导入项目中既可以使用
只能监听UIViewController的内存问题
UIViewController是我们在iOS开发中用的最频繁的类，是一个iOS app界面骨架，在mvc的框架下，v就是指UIViewController，几乎所有的业务逻辑都在这里面完成，因此在这种模式下，UIViewController的代码量比较大，进而出现内存泄漏的风险也比较大，因此很有必要在开发的过程中，对其进内存泄漏的检测。

内存泄漏的工具有很多，Xcode就自带了集中方式，例如analyze，instrument中的leaks，还有第三方工具MLeakFinder等等。在检测的时候，虽然不是100%能够检测出来，但是大部分都是没问题的，本文就是在研究MLeakFinder第三方库的基础上，根据据自己的理解，自己写的一个关于UIViewController的自定义内存检测工具。

原理分析：

dispatch_after这个是GCD提供的一个延时处理事物的方式，只需要将延时的任务放到block中，设置好时长即可，而我们将一个弱引用对象放到block中，不会影响对象的释放，就有如下的代码：
```
///延时处理，如果释放，不会走 [strongSelf showMsg:msg];
- (void) willDealloc{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSString* msg = [NSString stringWithFormat:@"%@__存在内存泄漏",[weakSelf class]];
            [strongSelf showMsg:msg];
        }
    });
}
```
延时任务
通常情况下，UIViewController的释放都是在被UINavigationController pop或者presenter出来后自身dismiss这两个时机后，而且一定会走viewDidDisappear这个方法，但是不是所有的viewWillDisappear都是这两个时机，所以需要区分标记。
```
/**
 标记是否是从控制器栈中移除，准备释放
 */
@property (nonatomic, assign) BOOL isDeallocDisappear;

标记区分
另外，为了做到不侵入式，需要用到分类，通过runtime动态交换这些时机方法。

代码实现：

UINavigationController（HxwLeak）时机方式扑捉并处理：
///pop 设置标识
-(UIViewController *)hxw_popViewControllerAnimated:(BOOL)animated{
    
    UIViewController* viewController = [self hxw_popViewControllerAnimated:animated];
    viewController.isDeallocDisappear = YES;
    return viewController;
}
/// 拿到被pop的viewControllers，依次调用延时任务
-(NSArray<UIViewController *> *)hxw_popToRootViewControllerAnimated:(BOOL)animated{
    
    NSArray<UIViewController *> * viewControllers = [self hxw_popToRootViewControllerAnimated:animated];
    for (UIViewController* vc in viewControllers) {
        [vc willDealloc];
    }
    return viewControllers;
}
/// 拿到被pop的viewControllers，依次调用延时任务
-(NSArray<UIViewController *> *)hxw_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray<UIViewController *> * viewControllers = [self hxw_popToViewController:viewController animated:animated];
    for (UIViewController* vc in viewControllers) {
        [vc willDealloc];
    }
    return viewControllers;
}

扑捉释放时机
UIViewController(HxwLeak)  dismiss时机及处理延时任务
///进入界面，初始化标志
-(void)hxw_viewWillAppear:(BOOL)animated{
    [self hxw_viewWillAppear:animated];
    self.isDeallocDisappear = NO;
}
///dismiss时机扑捉并设置标志
-(void)hxw_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [self hxw_dismissViewControllerAnimated:flag completion:completion];
    self.isDeallocDisappear = YES;
}
///即将释放时调用延时任务
- (void)hxw_viewDidDisappear:(BOOL)animated{
    [self hxw_viewDidDisappear:animated];
    BOOL isDeallocDis = self.isDeallocDisappear;
    if (isDeallocDis) {
        [self willDealloc];
    }
}
```
