//
//  AllListsViewController.m
//  CheckLists
//
//  Created by CY on 23/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "AllListsViewController.h"
#import "Checklist.h"
#import "ChecklistViewController.h"
#import "CheckListItem.h"
#import "DataModel.h"

#define ShowChecklist "ShowChecklist"
#define AddChecklist "AddChecklist"

@interface AllListsViewController ()

@end

@implementation AllListsViewController{
//    NSMutableArray *_lists;
}



#pragma mark - 初始化
/*
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
 
//        _lists = [[NSMutableArray alloc] initWithCapacity:20];
//        Checklist *list;
//        
//        list = [[Checklist alloc] init];
//        list.name = @"娱乐";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"学习";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"工作";
//        [_lists addObject:list];
//        
//        list = [[Checklist alloc] init];
//        list.name = @"家庭";
//        [_lists addObject:list];
//        
//        
//        for (Checklist *list in _lists) {
//            CheckListItem *item = [[CheckListItem alloc] init];
//            item.text = [NSString stringWithFormat:@"Item for :%@",list.name];
//            [list.items addObject:item];
//        }
 
        [self loadChecklist];
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//界面加载完执行
//viewDidAppear并非当应用启动的时候会调用,⽽是每次当导航控制器切换回主界面的时候都会调⽤
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    NSInteger index = [self.dataModel indexOfSelectedChecklist];//[[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
    
    //防止应用崩溃还没保存到Checklist.plist文件，而NSUserDefault确保存了当前选中的list
    if(index >= 0 && index < self.dataModel.lists.count) //if (index != -1)
    {
        Checklist *checklist = self.dataModel.lists[index];
        //手动触发segue
        [self performSegueWithIdentifier:@ShowChecklist sender:checklist];
    }
    
    //[self.tableView reloadData];
}
//界面加载前执行
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - NavigationControllerDelegate
//每当导航控制器让应⽤切换到一个新的界面时都会调用该方法。如果用户触碰了back按钮,那么新的视图控制器就是AllListsViewController⾃身,此时我们可以设置NSUserDefaults中的 ChecklistIndex值为-1,也就意味着没有选择任何的checklist
//当⽤户触碰back按钮的时候,导航控制器会在调用viewDidAppear⽅法前调用 willShowViewController⽅法。因为”ChecklistIndex”的值此时将始终是-1,viewDidAppear方法就不会再触发segue了
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        //[[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"ChecklistIndex"];
        [self.dataModel setIndexOfSelectedChecklist:-1];
    }
}


#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //实际上每个视图控制器都有一个self.storyboard属性,指向加载该视图控制器的storyboard
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *listDetailController = (ListDetailViewController *)navController.topViewController;
    listDetailController.delegate = self;
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    listDetailController.checklistToEdit = checklist;
    
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将所选择行的编号保存到NSUserDefaults中,其对应的键是”ChecklistIndex”
    //[[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"ChecklistIndex"];
    [self.dataModel setIndexOfSelectedChecklist:indexPath.row];
    
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    //手动触发segue
    [self performSegueWithIdentifier:@ShowChecklist sender:checklist];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 3;
//    return _lists.count;
    return self.dataModel.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifier = @"allList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    //下面的代码用来创建可重用的 UITableViewCell －initWithStyle
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"清单：%ld",(long)indexPath.row];
    Checklist *checklist = self.dataModel.lists[indexPath.row];
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    int count = [checklist countUncheckItems];
    NSString *result = @"";
    
    if (count==0 && checklist.items.count==0) {
        result = @"(No items)";
    }
    else if (count>0){
        result = [NSString stringWithFormat:@"%d Remaining",count];
    }
    else if (count==0 && checklist.items.count>0){
        result = @"All done";
    }
    
    cell.detailTextLabel.text = result;
    cell.detailTextLabel.textColor = cell.detailTextLabel.;
    
    cell.imageView.image = [UIImage imageNamed:checklist.iconName];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@ShowChecklist]) {
        ChecklistViewController *controller = [segue destinationViewController];
        controller.checklist = sender;
    }
    else if ([segue.identifier isEqualToString:@AddChecklist]){
        UINavigationController *navController = segue.destinationViewController;
        ListDetailViewController *listDetailController = (ListDetailViewController *)navController.topViewController;
        listDetailController.delegate = self;
        listDetailController.checklistToEdit = nil;
    }
}


#pragma mark - listDetailViewControllerDelegate
-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist
{
    /* 原方法
    NSInteger newRowIndex = self.dataModel.lists.count;
    [self.dataModel.lists addObject:checklist];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    */
    
    /* 现方法 */
    [self.dataModel.lists addObject:checklist];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist
{
    /* 原方法
    NSInteger index = [self.dataModel.lists indexOfObject:checklist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = checklist.name;
     */
    
    /* 现方法 */
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
