//
//  ViewController.m
//  CheckLists
//
//  Created by CY on 9/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "ChecklistViewController.h"
#import "CheckListItem.h"
#import "Checklist.h"

@interface ChecklistViewController ()

@end

@implementation ChecklistViewController
//{
//    NSMutableArray *_items;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    _items = [[NSMutableArray alloc] initWithCapacity:20];
    CheckListItem *_item;
    
    _item = [[CheckListItem alloc] init];
    _item.text = @"第一行，写啥呢";
    _item.checked = NO;
    [_items addObject:_item];
    
    _item = [[CheckListItem alloc] init];
    _item.text = @"第二行，还是不知写啥";
    _item.checked = NO;
    [_items addObject:_item];
    
    _item = [[CheckListItem alloc] init];
    _item.text = @"第三行，还是不知写啥";
    _item.checked = YES;
    [_items addObject:_item];
    
    _item = [[CheckListItem alloc] init];
    _item.text = @"第四行，还是不知写啥";
    _item.checked = NO;
    [_items addObject:_item];
    
    _item = [[CheckListItem alloc] init];
    _item.text = @"第五行，还是不知写啥";
    _item.checked = NO;
    [_items addObject:_item];
     

     NSLog(@"%@",[self documentsDirectory]);
     NSLog(@"%@",[self dataFilePath]);
     
     */
    
    self.title = self.checklist.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 5;
    return self.checklist.items.count; //_items.count;
}

//custom func
-(void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(CheckListItem *)item
{
//    if (item.checked) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    UILabel *label = (UILabel*)[cell viewWithTag:1001];
    if (item.checked) {
        label.text = @"√";
    }
    else{
        label.text = @"";
    }
    label.textColor = self.view.tintColor;
}
//custom func
-(void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(CheckListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:1024];
//    label.text = item.text;
    label.text = [NSString stringWithFormat:@"%ld: %@",(long)item.itemId,item.text];
    
    UILabel *lblDueDate = (UILabel *)[cell viewWithTag:1010];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateFormat=@"yy-MM-dd hh:mm:ss";
    lblDueDate.text = [NSString stringWithFormat:@"Due Date: %@",[dateFormatter stringFromDate:item.dueDate]];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取可重用的 UITableViewCell －需要先把 “ck” 这个标识写在storyboard的对应视图上
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ck"];
    
    CheckListItem *item = self.checklist.items[indexPath.row]; //_items[indexPath.row];
    
    [self configureTextForCell:cell withChecklistItem:item];
    
    [self configureCheckmarkForCell:cell withChecklistItem:item]; //[self configureCheckmarkForCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    CheckListItem *item = self.checklist.items[indexPath.row]; //_items[indexPath.row];
    
    [item toggleChecked];
    
    
    [self configureCheckmarkForCell:selectedCell withChecklistItem:item];
    
//    [self saveChecklistsItems];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.checklist.items removeObjectAtIndex:indexPath.row];//[_items removeObjectAtIndex:indexPath.row];
    
//    [self saveChecklistsItems];
    
    NSArray *indexPaths = @[indexPath];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
-(IBAction)addItem:(id)sender {
    NSInteger newRowIndex = _items.count;
    
    CheckListItem *newItem = [[CheckListItem alloc] init];
    newItem.text = @"俺是新来的，欢迎来战";
    newItem.checked = NO;
    [_items addObject:newItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}
 */

#pragma mark -AddItem delegate
-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(CheckListItem *)item
{
    /* 之前的方法
    NSInteger newRowIndex = self.checklist.items.count;//_items.count;
    [self.checklist.items addObject:item]; //[_items addObject:item];
    [self sortItemWithDueDate];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    */
    
    //现方法
    [self.checklist.items addObject:item];
    [self sortItemWithDueDate];
    [self.tableView reloadData];
    
//    [self saveChecklistsItems];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(CheckListItem *)item
{
    /* 之前的方法
    NSInteger currentIndex = [self.checklist.items indexOfObject:item];//[_items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
     */
    
//    [self saveChecklistsItems];
    
    //现方法
    [self sortItemWithDueDate];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sortItemWithDueDate
{
    [self.checklist.items sortUsingSelector:@selector(compare:)];
}

//当界面跳转的时候,UIKit会触发segue的prepareForSegue⽅法。segue是storyboard中两个视图控制器之间的那个箭头。prepareForSegue允许我们向新的视图控制器传递数据。
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //1、新的视图控制器可以在segue.destinationViewController中找到。对于我们这款应⽤,目标视图控制器不是AddItemViewController,⽽是包含了它的导航控制器
    UINavigationController *navigationController = segue.destinationViewController;
    
    //2、为了获取AddItemViewController对象,我们可以查看导航控制器的topViewController属性,该属性指向导航控制器中的当前活跃界⾯面
    ItemDetailViewController *controller = (ItemDetailViewController*)navigationController.topViewController;
    
    //3、一旦我们获得了到AddItemViewController对象的引⽤用,就需要将delegate属性设置为self,⽽self 这⾥其实是ChecklistsViewController
    [controller setDelegate:self];
    
    //通过上面这三个步骤,ChecklistsViewController正式成为AddItemViewController的代理。
    
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        
    }
    else if([segue.identifier isEqualToString:@"EditItem"]){
        //这⾥的sender参数其实指的就是触发了该segue的控件,在这里就是table view cell中的细节显⽰按钮。通过它可以找到对应的index-path,然后获取要编辑的ChecklistItem对象的⾏编号。
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.itemToEdit = self.checklist.items[indexPath.row]; //_items[indexPath.row];
    }
}

/*

//获取应用的沙盒目录
-(NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return documentsDirectory;
}
//返回沙盒目录中的plist文件
-(NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}
-(void)saveChecklistsItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    //NSKeyedArchiver,是用于创建plist文件的NSCoder的⼀种形式,它可以对数组进行编码, 然后将所有的ChecklistItems写入到某种二进制数据格式中
    //数据会被保存在一个NSMutableData对象中,它可以将自身写入到通过dataFilePath所获取的完整路径的文件中
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}
-(void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _items = [unarchive decodeObjectForKey:@"ChecklistItems"];
        [unarchive finishDecoding];
    }
    else{
        _items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}
 
 -(id)initWithCoder:(NSCoder *)aDecoder
 {
 if (self = [super initWithCoder:aDecoder]) {
 [self loadChecklistItems];
 }
 return self;
 }
 */
@end
