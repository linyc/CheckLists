//
//  Checklist.m
//  CheckLists
//
//  Created by CY on 23/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "Checklist.h"
#import "CheckListItem.h"

@implementation Checklist

-(id)init
{
    if (self = [super init]) {
        self.items = [[NSMutableArray alloc] initWithCapacity:20];
        self.iconName = @"No Icon";
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.items forKey:@"Items"];
    
    [aCoder encodeObject:self.iconName forKey:@"IconName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"Name"];
        self.items = [aDecoder decodeObjectForKey:@"Items"];
        
        self.iconName = [aDecoder decodeObjectForKey:@"IconName"];
    }
    return self;
}

//统计当前还有多少项没完成（打勾）
-(int)countUncheckItems
{
    int count = 0;
    for (CheckListItem *item in self.items) {
        if (!item.checked) {
            count++;
        }
    }
    return count;
}

-(NSComparisonResult)compare:(Checklist *)otherChecklist
{
    //该⽅法会⽐较两个name对象,并忽略大写和小写的区别(a和A会被认为是相同的),同时还会考虑 所在地区的规则。locale是一个对象,它会了解用户所在的国家和语法的特殊规则。比如在德语中的排序和在英⽂中会有所区别
    return [self.name localizedStandardCompare:otherChecklist.name];
}
@end
