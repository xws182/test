//
//  NSObject+WSKeyValue.h
//  Runtime
//
//  Created by 科技 on 2017/2/28.
//  Copyright © 2017年 科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WSKeyValue)

+ (instancetype)ws_objectWithKeyValues:(NSDictionary *)dict context:(BOOL)context;

@end
