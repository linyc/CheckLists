//
//  CheckListItem.h
//  CheckLists
//
//  Created by CY on 14/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckListItem : NSObject<NSCoding>//<NSCoding>表示：让ChecklistItem对象遵从NSCoding协议

@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL checked;

-(void)toggleChecked;

@property (nonatomic,copy) NSDate *dueDate;
@property (nonatomic,assign) BOOL shouldRemind;
@property (nonatomic,assign) NSInteger itemId;

-(void)scheduleNotification;

@end
