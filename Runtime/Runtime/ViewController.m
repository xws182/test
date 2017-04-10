//
//  ViewController.m
//  Runtime
//
//  Created by 科技 on 2017/2/28.
//  Copyright © 2017年 科技. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "NSObject+WSKeyValue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* 创建一个字典 */
    NSDictionary *dict = @{
                           @"name":@"小明",
                           @"age":@18,
                           @"title":@"master",
                           @"height":@1.7,
                           @"person":@{
                                   @"name":@"小红"
                                }
                           };
    
    User *user = [User ws_objectWithKeyValues:dict context:NO];
    
//    NSLog(@"name=%@\n age=%ld\n message=%@\n height=%.2f", user.name, user.age, user.title, user.height);
    
    NSLog(@"%@\n%@\n", @"qq", user.person.name);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
