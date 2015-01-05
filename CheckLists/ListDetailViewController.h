//
//  ListDetailViewController.h
//  CheckLists
//
//  Created by CY on 23/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconPickerViewController.h"
@class Checklist;
@class ListDetailViewController;

@protocol ListDetailViewControllerDelegate <NSObject>

-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller;
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface ListDetailViewController : UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>

@property (nonatomic,weak) IBOutlet UITextField *textField;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic,weak) id <ListDetailViewControllerDelegate> delegate;

@property (nonatomic,strong) Checklist *checklistToEdit;

-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;

@end
