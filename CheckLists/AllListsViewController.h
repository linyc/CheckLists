//
//  AllListsViewController.h
//  CheckLists
//
//  Created by CY on 23/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDetailViewController.h"

@class DataModel;

@interface AllListsViewController : UITableViewController<ListDetailViewControllerDelegate,UINavigationControllerDelegate>
//-(void)saveChecklists;
@property (nonatomic,strong) DataModel *dataModel;
@end
