//
//  DataModel.m
//  CheckLists
//
//  Created by CY on 27/12/14.
//  Copyright (c) 2014年 CY. All rights reserved.
//

#import "DataModel.h"
#import "Checklist.h"

@implementation DataModel

//给 NSUserDefaults 的键设置默认值，否则第一次运行应用会在 AllListsViewController 的 viewDidAppear 方法出错，因为NSUserDefaults的integerForKey默认返回0
-(void)registerDefaults
{
    NSDictionary *dictionary = @{@"ChecklistIndex":@-1,@"FirstTime":@YES,@"ChecklistItemId":@0};
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

-(id)init
{
    if (self = [super init]) {
        [self loadChecklist];
        [self registerDefaults];
        [self handleFirstTimeRun];
    }
    NSLog(@"%@",[self documentsDirectory]);
    NSLog(@"%@",[self dataFilePath]);
    return self;
}

-(NSInteger)indexOfSelectedChecklist
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"ChecklistIndex"];
}
-(void)setIndexOfSelectedChecklist:(NSInteger)index
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"ChecklistIndex"];
}

-(void)handleFirstTimeRun
{
    BOOL firstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"FirstTime"];
    if (firstTime) {
        Checklist *defaultList = [[Checklist alloc] init];
        defaultList.name = @"Default List";
        [self.lists addObject:defaultList];
        [self setIndexOfSelectedChecklist:0];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTime"];
    }
}

#pragma mark - 数据加载及保存
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
-(void)saveChecklists
{
    NSMutableData *data = [[NSMutableData alloc] init];
    //NSKeyedArchiver,是用于创建plist文件的NSCoder的⼀种形式,它可以对数组进行编码, 然后将所有的ChecklistItems写入到某种二进制数据格式中
    //数据会被保存在一个NSMutableData对象中,它可以将自身写入到通过dataFilePath所获取的完整路径的文件中
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_lists forKey:@"Checklists"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}
-(void)loadChecklist
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.lists = [unarchive decodeObjectForKey:@"Checklists"];
        [unarchive finishDecoding];
    }
    else{
        self.lists = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

//有了这个compare:方法,NSMutableArray的sortWithSelector方法就会重复询问某个Checklist对象,它和另一个Checklist对象的⽐较结果是怎样的,然后根据比较结果来调整它们的顺序,直到整个数组排序完成。在Checklist对象的compare⽅法中,我们简单比较了两个对象的name属性。如果我们想基于其它要素进行排序,只需要更改这个compare⽅法就好了
-(void)sortChecklists
{
    [self.lists sortUsingSelector:@selector(compare:)];//compare:方法写在Checklist.m中
}

//我们⾸先从NSUserDefaults中获取了当前的ChwecklistItemId值,然后在该值的基础上加1,然后重新保存到NSUserDefaults中。最后将该值返回到调用该⽅法的对象。
+(NSInteger)nextChecklistItemId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger itemId = [userDefaults integerForKey:@"ChecklistItemId"];
    
    [userDefaults setInteger:itemId+1 forKey:@"ChecklistItemId"];
    //强制要求NSUserDefaults将这些改⽴即写⼊入磁盘。这样当应⽤被强关时信息就不可能丢失了
    [userDefaults synchronize];
    
    return itemId;
    
}

@end
