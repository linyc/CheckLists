//
//  CheckListItem.m
//  CheckLists
//
//  Created by CY on 14/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "CheckListItem.h"
#import "DataModel.h"
#import <UIKit/UIKit.h>

@implementation CheckListItem

-(id)init
{
    if (self = [super init]) {
        self.itemId = [DataModel nextChecklistItemId];
    }
    return self;
}


-(void)toggleChecked
{
    self.checked = !self.checked;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemId forKey:@"ItemId"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemId = [aDecoder decodeIntegerForKey:@"ItemId"];
    }
    return self;
}

-(NSComparisonResult)compare:(CheckListItem *)otherChecklistItem
{
    return [self.dueDate compare:otherChecklistItem.dueDate];
}

-(void)scheduleNotification
{
    UILocalNotification *existNotification = [self notificationForThisItem];
    if (existNotification != nil) {
        NSLog(@"Existing notification");
        [[UIApplication sharedApplication] cancelLocalNotification:existNotification];
    }
    
    
    //设置了提醒，并且提醒时间不能在当前时间之前，那么就需要进行通知
    if (self.shouldRemind && [self.dueDate compare:[NSDate date]] != NSOrderedAscending) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.userInfo = @{@"itemId":@(_itemId)};
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSLog(@"Schedule Notification %@ for itemId %ld",localNotification,_itemId);
    }
}
-(UILocalNotification *)notificationForThisItem
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notifi in notifications) {
        NSNumber *num = [notifi.userInfo objectForKey:@"itemId"];
        if (num != nil && [num integerValue]==_itemId) {
            return notifi;
        }
    }
    return nil;
}
//在iOS中,当某个对象将被dealloc消息来删除的时候会得到通知
//当用户删除的是整个Checklist的时候，所有子项也会一个个调用该方法，所以Checklist 中不需要做其他事
-(void)dealloc
{
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if (existingNotification != nil) {
        NSLog(@"item delete: %ld",_itemId);
        [[UIApplication sharedApplication] cancelLocalNotification:existingNotification];
    }
}
@end
