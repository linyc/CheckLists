//
//  IconPickerViewController.h
//  CheckLists
//
//  Created by CY on 29/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName;

@end

@interface IconPickerViewController : UITableViewController

@property (nonatomic,weak) id <IconPickerViewControllerDelegate> delegate;

@end
