//
//  ViewController.m
//  TynnSelector
//
//  Created by 刘庆贺 on 2017/12/6.
//  Copyright © 2017年 huiranwangluo. All rights reserved.
//

#import "ViewController.h"
#import "AlterController.h"
@interface ViewController ()<AlterControllerProtocol>

@property (weak, nonatomic) IBOutlet UIButton *singleTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityTypeBtn;

//当前选中的按钮,做标记使用
@property (strong,nonatomic) UIButton *selectedBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (IBAction)selectSingleLineAction:(id)sender {
    
    AlterController *pickerView = [[AlterController alloc]initWithTitle:@"选择单行数据" type:kTypeOfSingleLine];
    pickerView.dataArray = @[@"波多野结衣",@"天海翼",@"小泽玛利亚",@"大桥未久"];
    pickerView.delegate = self;
    [self presentViewController:pickerView animated:YES completion:nil];
    
    //标记所选按钮
    self.selectedBtn = sender;
    
}
//选择日期
- (IBAction)selectDateAction:(id)sender {
    
    AlterController *pickerView = [[AlterController alloc]initWithTitle:@"选择日期" type:kTypeOfDate];
    pickerView.dataArray = [self getDateData];
    pickerView.delegate = self;
    [self presentViewController:pickerView animated:YES completion:nil];
    
    //标记所选按钮
    self.selectedBtn = sender;
    
}
//选择城市
- (IBAction)selectCityAction:(id)sender {
    
    AlterController *pickerView = [[AlterController alloc]initWithTitle:@"选择城市" type:kTypeOfCity];
    pickerView.dataArray = [self getCityData];
    pickerView.delegate = self;
    [self presentViewController:pickerView animated:YES completion:nil];
    
    //标记所选按钮
    self.selectedBtn = sender;
}
#pragma mark - <代理方法实现>
//实现代理方法
-(void)getResultFromPickView:(NSString *)result{
    [self.selectedBtn setTitle:result forState:UIControlStateNormal];
}


#pragma mark - <工具方法>
//获取json中的城市数据
- (NSArray *)getCityData{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString* cityNames = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (cityNames == nil) {
        NSLog(@"error:加载城市数据为空");
        return nil;
    }
    NSData *jsonData = [cityNames dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arrayCityNames = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arrayCityNames;
}
//获取日期数据
- (NSArray *)getDateData{
    NSInteger year = 1900;
    NSMutableArray *yearArray = [NSMutableArray array];
    for (NSInteger i = 0; i<130; i++) {
        NSString *newYear = [NSString stringWithFormat:@"%zd",year + i];
        [yearArray addObject:newYear];
    }
    NSInteger month = 0;
    NSMutableArray *monthArray = [NSMutableArray array];
    for (NSInteger i = 0; i<12; i++) {
        NSString *newMonth = [NSString stringWithFormat:@"%zd",month + i + 1];
        [monthArray addObject:newMonth];
    }
    NSMutableArray *totalArray = [NSMutableArray array];
    [totalArray addObject:yearArray];
    [totalArray addObject:monthArray];
    return totalArray;
}


@end
