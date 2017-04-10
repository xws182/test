//
//  User.h
//  Runtime
//
//  Created by 科技 on 2017/2/28.
//  Copyright © 2017年 科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface User : NSObject

@property(nonatomic, strong) Person *person;

//@property(nonatomic, assign) NSInteger age;

@property(nonatomic, copy) NSString *title;

//@property(nonatomic, assign) double height;

@end
