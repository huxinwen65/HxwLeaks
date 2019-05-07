//
//  TestViewController.m
//  HxwLeaksDemo
//
//  Created by BTI-HXW on 2019/5/7.
//  Copyright © 2019 BTI-HXW. All rights reserved.
//

#import "TestViewController.h"
typedef void(^block)(void);
@interface TestViewController ()
/**
 
 */
@property (nonatomic, copy) block block;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.block = ^{
        NSLog(@"这样写肯定是会内存泄漏的%@",self);
    };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
