//
//  ViewController.m
//  HxwLeaksDemo
//
//  Created by BTI-HXW on 2019/5/7.
//  Copyright © 2019 BTI-HXW. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor greenColor]];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(toTestViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 300, 100, 47);
}

- (void)toTestViewController:(id)sender{
    [self.navigationController pushViewController:[TestViewController new] animated:YES];
}
@end
