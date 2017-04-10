//
//  NSObject+WSKeyValue.m
//  Runtime
//
//  Created by 科技 on 2017/2/28.
//  Copyright © 2017年 科技. All rights reserved.
//

#import "NSObject+WSKeyValue.h"
#import <objc/message.h>
#import <CoreData/CoreData.h>
#import "WSProperty.h"

static NSSet *foundationClasses_;

static const char *kPropertyListKey = "YFPropertyListKey";
static const char *kPropertyClass = "kPropertyClass";
static const char *kPropertyName = "kPropertyName";
static const char *kPropertyName1 = "kPropertyName1";

@implementation NSObject (WSKeyValue)

+ (NSArray *)ws_properties:(BOOL)context {
    
    NSArray *propertyList = objc_getAssociatedObject(self, kPropertyListKey);
    
    if (propertyList) {
        return propertyList;
    }
    
    unsigned int count = 0;
    
    objc_property_t *ptyList = class_copyPropertyList([self class], &count);
    
    NSMutableArray *mtArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = ptyList[i];
        // 1.属性名
//        const char *propertyName_C = property_getName(property);
        
//        NSString *propertyName_OC = [NSString stringWithCString:propertyName_C encoding:NSUTF8StringEncoding];
//        NSString *propertyName_OC = [NSString stringWithUTF8String:propertyName_C];
        
        NSString *propertyName_OC  = @(property_getName(property));
        
        // 2.成员类型
        NSString *attrs = @(property_getAttributes(property));
        NSUInteger dotLoc = [attrs rangeOfString:@","].location;
        NSString *code = nil;
        NSUInteger loc = 1;
        if (dotLoc == NSNotFound) { // 没有,
            code = [attrs substringFromIndex:loc];
        } else {
            code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
        }
        
        if (code.length > 3 && [code hasPrefix:@"@\""]) {
            // 去掉@"和"，截取中间的类型名称
            NSString *code1 = [code substringWithRange:NSMakeRange(2, code.length - 3)];
            Class typeClass = NSClassFromString(code1);
            
            NSLog(@"%@", typeClass);
            if (![self isClassFromFoundation:typeClass]) {
//                [typeClass ws_objectWithKeyValues:];
                NSLog(@"%@", typeClass);
                objc_setAssociatedObject(self, kPropertyClass, typeClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(self, kPropertyName, propertyName_OC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            if (context) {
                
                objc_setAssociatedObject(self, kPropertyName1, propertyName_OC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        
        [mtArray addObject:propertyName_OC];
    }
    
    objc_setAssociatedObject(self, kPropertyListKey, mtArray.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    free(ptyList);
    
    return mtArray.copy;
};

+ (instancetype)ws_objectWithKeyValues:(NSDictionary *)dict context:(BOOL)context{
    /** 实例化对象 */
    id objc = [[self alloc] init];
    /** 获得属性列表 */
    NSArray *propertyList = [self ws_properties:context];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //        NSLog(@"key = %@", key);
        
        NSString *propertyName = objc_getAssociatedObject(self, kPropertyName);
        if ([propertyList containsObject:key]) {
            NSString *propertyName1 = objc_getAssociatedObject(self, kPropertyName1);
            if (context) {
                propertyName = propertyName1;
            }
            if ([key isEqualToString:propertyName]) {
                if (propertyName1) {
                    
                    [objc setValue:obj forKey:key];
                    return;
                }
                Class typeClass = objc_getAssociatedObject(self, kPropertyClass);
                [typeClass ws_objectWithKeyValues:dict[propertyName] context:YES];
                
            }else {
                
                [objc setValue:obj forKey:key];
            }
        }
    }];
    //返回对象
    return objc;
}

+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

@end

















