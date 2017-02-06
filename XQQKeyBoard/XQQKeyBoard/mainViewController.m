//
//  mainViewController.m
//  XQQKeyBoard
//
//  Created by XQQ on 16/9/5.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "mainViewController.h"
#import "XQQKeyBoardView.h"
@interface mainViewController ()
/**
 *  键盘View
 */
@property(nonatomic, strong)  XQQKeyBoardView * keyBoard;

@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"戴眼镜的胖超人";
    _keyBoard = [[XQQKeyBoardView alloc]init];
    [self.view addSubview:_keyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
