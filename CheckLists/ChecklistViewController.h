//
//  ViewController.h
//  CheckLists
//
//  Created by CY on 9/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"

@class Checklist;

@interface ChecklistViewController : UITableViewController<ItemDetailViewControllerDelegate>

@property (nonatomic,strong) Checklist *checklist;
@end

