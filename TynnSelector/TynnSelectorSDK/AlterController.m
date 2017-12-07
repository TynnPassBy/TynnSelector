//
//  AlterController.m
//  LoansDemo
//
//  Created by 刘庆贺 on 2017/10/26.
//  Copyright © 2017年 huiranwangluo. All rights reserved.
//

#import "AlterController.h"
#import "UIView+Frame.h"
@interface AlterController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong,nonatomic) UIPickerView *pickerView;
@property (strong,nonatomic) NSString *pickerTitle;
//记录返回值,向外界传递的就是这个值
@property (strong,nonatomic) NSString *name;

//记录当前选中省份的index
@property (assign,nonatomic) NSInteger selectedIndex_province;
//记录当前选中城市的index
@property (assign,nonatomic) NSInteger selectedIndex_city;
//记录当前选中区/县的index
@property (assign,nonatomic) NSInteger selectedIndex_area;

@end

@implementation AlterController

#pragma mark - <init>

- (instancetype)initWithTitle:(NSString *)title type:(type)type{
    self = [super init];
    if (self) {
        self = [AlterController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
        self.type = type;
    }
    return self;
}

#pragma mark - <lifeStyle>

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建pickView
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    
    //2.pickView设置默认值出现时的默认值
    [self setupPickViewDefult];
    //3.设置点击事件传值
    [self setupAction];
    //4.一些屏幕适配
    [self screenFit];
    
}


- (void)setupPickViewDefult{
    if(self.type == kTypeOfCity){//城市类型,设置返回的默认值为(城市json数据的第0行)
        NSString *name = [NSString stringWithFormat:@"%@%@%@",self.dataArray[0][@"name"],self.dataArray[0][@"city"][0][@"name"],self.dataArray[0][@"city"][0][@"area"][0]];
        self.name = name;
        
    }else if (self.type == kTypeOfDate){//日期类型,设置返回的默认值为当前时间
        NSString *time = [AlterController getCurrentTimes];
        NSInteger firstYear = [self.dataArray[0][0] integerValue];
        NSInteger year = [[time substringToIndex:4] integerValue];
        NSInteger month = [[time substringFromIndex:5] integerValue];
        [self.pickerView selectRow:year-firstYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month-1 inComponent:2 animated:NO];
        NSString *name = [NSString stringWithFormat:@"%@年%@月",self.dataArray[0][year-firstYear],self.self.dataArray[1][month-1]];
        self.name = name;
    }else if(self.type == kTypeOfSingleLine){
        self.name = self.dataArray.firstObject;
    }
}

- (void)setupAction{
    __weak typeof(self) weakSelf = self;
    //3.点击确定Action进行传值,代理传值
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([weakSelf.delegate respondsToSelector:@selector(getResultFromPickView:)]) {
            [weakSelf.delegate getResultFromPickView:weakSelf.name];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击取消按钮的事件处理
    }];
    
    [self addAction:sure];
    [self addAction:cancel];
}

- (void)screenFit{
    if (IPHONE6) {
        self.pickerView.x = 18;
        self.pickerView.y = 20;
    } else if (IPHONE6PLUS){
        self.pickerView.x = -8;
    } else if (IPHONE5){
        self.pickerView.x = -10;
    }else if(IPHONE4){
        self.pickerView.x = -10;
    }else{
        self.pickerView.x = -10;
    }
}


#pragma mark - <dataSource>
//列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == kTypeOfCity) {
        return 3;
    }else if (self.type == kTypeOfDate){
        return 4;
    }
    return 1;
}
//每列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    NSLog(@"这也算停止");
    if (self.type == kTypeOfCity) {
        if (component == 0) {
            return self.dataArray.count;
        }else if(component == 1){
            
            //一定要首先获取用户选择的那一行 然后才可以根据选中行获取省份 获取省份以后再去字典中加载省份对应的城市
            NSArray *city = self.dataArray[_selectedIndex_province][@"city"];
            return city.count;
        }else{
            //必须确定第一列和第二列分别选了哪一行才能确定第三行
            NSArray *province = self.dataArray[_selectedIndex_province][@"city"];
            NSArray *city = province[_selectedIndex_city][@"area"];
            return city.count;
        }
    }else if (self.type == kTypeOfDate){
        if (component == 0) {
            return 120;
        }else if (component == 2){
            return 12;
        }else{
            return 1;
        }
    }
    return self.dataArray.count;
}
//每行要显示什么数据,相当于tableView的 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 方法
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //城市类型
    if (self.type == kTypeOfCity) {
        UILabel *label = [[UILabel alloc] init];
        if (component == 0) {
           label.text = [[NSString alloc] initWithFormat:@"%@",_dataArray[row][@"name"]];
        }else if (component == 1){
            NSString *city = self.dataArray[_selectedIndex_province][@"city"][row][@"name"];
            label.text = [[NSString alloc] initWithFormat:@"%@",city];
        }else{
            
            NSArray *province = self.dataArray[_selectedIndex_province][@"city"];
            NSArray *city = province[_selectedIndex_city][@"area"];
            label.text = [[NSString alloc] initWithFormat:@"%@",city[row]];
            
        }
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    //单独一行数据
    }else if(self.type == kTypeOfSingleLine){
        UILabel *label = [[UILabel alloc] init];
        label.text = [[NSString alloc] initWithFormat:@"%@",[_dataArray objectAtIndex:row]];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    //选择日期数据类型
    }else if(self.type == kTypeOfDate){
        UILabel *label = [[UILabel alloc] init];
        if (component == 0) {
           label.text = [[NSString alloc] initWithFormat:@"%@",[_dataArray[0] objectAtIndex:row]];
        }else if(component == 1){
            label.text = @"年";
        }else if(component == 2){
            label.text = [[NSString alloc] initWithFormat:@"%@",[_dataArray[1] objectAtIndex:row]];
        }else{
            label.text = @"月";
        }
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else{
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    
}


#pragma mark - <delegate>
/**
 *  选中某一行后(pickView滚动停止时)的回调 联动的关键
 */
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.type == kTypeOfCity){
        if (component == 0) {
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_area = 0;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        if(component == 1){
            self.selectedIndex_city = row;
            self.selectedIndex_area = 0;
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        if (component == 2) {
            self.selectedIndex_area = row;
        }
        NSString *name = [NSString stringWithFormat:@"%@%@%@",self.dataArray[_selectedIndex_province][@"name"],self.dataArray[_selectedIndex_province][@"city"][_selectedIndex_city][@"name"],self.dataArray[_selectedIndex_province][@"city"][_selectedIndex_city][@"area"][self.selectedIndex_area]];
        self.name = name;
    }else if(self.type == kTypeOfSingleLine){
        self.name = self.dataArray[row];
    }else if(self.type == kTypeOfDate){
        NSInteger selRow0 = [pickerView selectedRowInComponent:0];
        NSInteger selRow1 = [pickerView selectedRowInComponent:2];
        self.name = [NSString stringWithFormat:@"%@年%@月",_dataArray[0][selRow0],_dataArray[1][selRow1]];
    }
}


- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - <一些工具方法>
//获取当前时间(日期类型用到该方法)
+(NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


@end
