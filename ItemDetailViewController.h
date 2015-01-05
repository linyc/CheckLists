//
//  AddItemViewController.h
//  CheckLists
//
//  Created by CY on 14/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@class CheckListItem;
@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller;
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(CheckListItem *)item;
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(CheckListItem *)item;

@end

@interface ItemDetailViewController : UITableViewController<UITextFieldDelegate>

- (IBAction)cancelClick:(id)sender;
- (IBAction)doneClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtNewItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;


@property (weak,nonatomic) id <ItemDetailViewControllerDelegate> delegate;

@property (strong,nonatomic) CheckListItem *itemToEdit;
@end
