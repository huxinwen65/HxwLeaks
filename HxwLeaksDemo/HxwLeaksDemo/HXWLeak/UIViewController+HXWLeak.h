//
//  UIViewController+HXWLeak.h
//  Test
//
//  Created by BTI-HXW on 2019/5/6.
//  Copyright © 2019 BTI-HXW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HXWLeak)
/**
 标记是否是从控制器栈中移除，准备释放
 */
@property (nonatomic, assign) BOOL isDeallocDisappear;
- (void) willDealloc;
@end

NS_ASSUME_NONNULL_END
