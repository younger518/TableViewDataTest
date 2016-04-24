//
//  ViewController.m
//  tableViewDataTest
//
//  Created by yangneng on 16/4/23.
//  Copyright © 2016年 yangneng. All rights reserved.
//

#import "ViewController.h"
#import "Model.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(atomic,strong)NSMutableArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self getDataFromServer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getDataFromServer];
}

-(void)getDataFromServer{
    
    NSThread *getDataThread = [[NSThread alloc]initWithTarget:self selector:@selector(getTableData) object:nil];
    [getDataThread start];
    
}
-(void)getTableData{
    [NSThread sleepForTimeInterval:1];
    NSMutableArray *arrays = [NSMutableArray array];
    for (int  index = 0; index < 20; index++) {
        
        Model *data = [[Model alloc]init];
        data.modelTitle = [NSString stringWithFormat:@"%d",index];
        data.modelDetailTitle = [NSString stringWithFormat:@"detail--%d",index];
        [arrays addObject:data];
    }
    self.datas = [NSMutableArray arrayWithArray:arrays];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.datas addObject:@3];
        [self.tableView reloadData];
    });
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.datas.count -1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"cell";
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (![[self.datas objectAtIndex:indexPath.row]isKindOfClass:[Model class]]) {
        
        NSLog(@"------------------------------------%ld",indexPath.row);
    }
    Model *data = [self.datas objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = data.modelDetailTitle;
    cell.textLabel.text = data.modelTitle;
    return cell;
}
@end
