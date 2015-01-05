//
//  DataModel.h
//  CheckLists
//
//  Created by CY on 27/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,strong) NSMutableArray *lists;

-(void)saveChecklists;

-(NSInteger)indexOfSelectedChecklist;
-(void)setIndexOfSelectedChecklist:(NSInteger)index;

-(void)sortChecklists;

+(NSInteger)nextChecklistItemId;

@end
