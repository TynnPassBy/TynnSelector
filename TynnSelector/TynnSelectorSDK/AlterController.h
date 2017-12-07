//
//  AlterController.h
//  LoansDemo
//
//  Created by 刘庆贺 on 2017/10/26.
//  Copyright © 2017年 huiranwangluo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kTypeOfCity,        //城市类型
    kTypeOfDate,        //日期类型
    kTypeOfSingleLine,  //单行数据类型
} type;

@protocol AlterControllerProtocol<NSObject>

@optional

-(void)getResultFromPickView:(NSString *)result;

@end

@interface AlterController : UIAlertController

/**
 数据源
 */
@property (strong,nonatomic) NSArray *dataArray;

/**
 选择器类型
 */
@property (assign,nonatomic) type type;

/**
 代理,通过代理传值
 */
@property (weak,nonatomic) id<AlterControllerProtocol> delegate;

/**
 初始化方法

 @param title 弹出的pickView的标题
 @param type 弹出的pickView的类型
 @return 返回pickViewController对象
 */
- (instancetype)initWithTitle:(NSString *)title type:(type)type;

@end
