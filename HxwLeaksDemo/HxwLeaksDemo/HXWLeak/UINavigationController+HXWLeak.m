//
//  UINavigationController+HXWLeak.m
//  Test
//
//  Created by BTI-HXW on 2019/5/6.
//  Copyright © 2019 BTI-HXW. All rights reserved.
//

#import "UINavigationController+HXWLeak.h"
#import "SwizzManager.h"
#import "UIViewController+HXWLeak.h"

@implementation UINavigationController (HXWLeak)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{///交换时机方法pop
        SEL originSel = @selector(popViewControllerAnimated:);
        SEL newSel = @selector(hxw_popViewControllerAnimated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel newSel:newSel];
        SEL originSel1 = @selector(popToViewController:animated:);
        SEL newSel1 = @selector(hxw_popToViewController:animated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel1 newSel:newSel1];
        SEL originSel2 = @selector(popToRootViewControllerAnimated:);
        SEL newSel2 = @selector(hxw_popToRootViewControllerAnimated:);
        [SwizzManager swizzMethodForClass:[self class] originSel:originSel2 newSel:newSel2];
        
    });
}
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
@end
