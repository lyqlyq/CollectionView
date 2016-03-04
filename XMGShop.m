//
//  XMGShop.m
//  瀑布流
//
//  Created by Mac on 16/3/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XMGShop.h"

@implementation XMGShop

+(NSMutableArray *)shop{
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
 
    NSMutableArray *shops = [NSMutableArray array];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary *dict in dictArr) {
        
        XMGShop *shop = [[XMGShop alloc] initWithDict:dict];
        [shops addObject:shop];
    }
    
    return shops;
}

-(instancetype )initWithDict:(NSDictionary *)dict{

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
    
}

@end
