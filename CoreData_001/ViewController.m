//
//  ViewController.m
//  CoreData_001
//
//  Created by cq on 16/2/3.
//  Copyright © 2016年 songsong. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()

@property (nonatomic,strong)NSManagedObjectContext *context;

@end

@implementation ViewController

//模糊查询
- (IBAction)likeSearch:(UIButton *)sender {
    //查询ji开头的
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name BEGINSWITH %@",@"ji"];
    request.predicate=pre;
    
    NSError *error = nil;
    NSArray *emp =  [self.context executeFetchRequest:request error:&error];
    //NSLog(@"%@",emp);
    
    for (Employee *e in emp) {
        NSLog(@"%@,%@",e.name,e.height);
    }

}
- (IBAction)deleteData:(UIButton *)sender {
    
    //删除张三
    //1.查找到张三，删除张三，用context同步到数据库 && 修改员工信息和该方法基本一致
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@",@"张三"];
    request.predicate=pre;
    
    NSArray *emps =[self.context executeFetchRequest:request error:nil];
    for (Employee *emp in emps) {
        [self.context deleteObject:emp];
    }
    [self.context save:nil];
    
}




- (IBAction)findData:(UIButton *)sender {
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    //过滤查询 && 多字段查询
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name=%@ AND height > %@",@"历史",@(3)];
    //request.predicate=pre;
    
    //排序操作
    //request.sortDescriptors =@[ [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:NO]];
    //分页查询,一共13条数据，每一页5条
    request.fetchLimit=5;//每一页的数据量
    request.fetchOffset=0;//起止号
    
    
    
    //读取信息
    NSError *error = nil;
    NSArray *emp =  [self.context executeFetchRequest:request error:&error];
    //NSLog(@"%@",emp);
    
    for (Employee *e in emp) {
        NSLog(@"%@,%@",e.name,e.height);
    }
    
}

- (IBAction)addEmployee:(UIButton *)sender {
    
    Employee *emp1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:self.context];
    
    emp1.name = @"jiji";
    emp1.age = @28;
    emp1.height=@190;
    //通过上下文保存操作
    NSError *error = nil;
    [self.context save:&error];
    if (!error) {
        NSLog(@"sucess");
    }else {
        NSLog(@"error");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _context = [[NSManagedObjectContext alloc] init];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSError *error = nil;
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path  = [doc stringByAppendingPathComponent:@"company.sqlite"];
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    _context.persistentStoreCoordinator=store;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
