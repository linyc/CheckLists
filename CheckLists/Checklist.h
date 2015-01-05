//
//  Checklist.h
//  CheckLists
//
//  Created by CY on 23/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checklist : NSObject<NSCoding>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,copy) NSString *iconName;

-(int)countUncheckItems;


@end
