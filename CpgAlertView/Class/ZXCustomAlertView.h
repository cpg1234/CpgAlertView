//
//  ZXCustomAlertView.h
//  ZXCWS
//
//  Created by 常鹏阁 on 2017/5/17.
//  Copyright © 2017年 Wanyi. All rights reserved.
//
typedef void(^SureActionBlock)();
typedef void(^CancelActionBlock)();

#import <UIKit/UIKit.h>

@interface ZXCustomAlertView : UIView
@property (nonatomic,copy)SureActionBlock sureActionBlock;
@property (nonatomic,copy)CancelActionBlock cancelActionBlock;
/**
 * 创建弹出视图
 * @param title 标题
 * @param content 弹出视图内容
 * @param sureTitle 确定按钮标题
 * @param cancelTitle 取消按钮标题
 * @param sureBlock 确定按钮block
 * @param cancelBlock 取消按钮block
 */
- (ZXCustomAlertView * )initWithTitle:(NSString *)title
    WithContentString:(NSString *)content
        WithSureTitle:(NSString *)sureTitle
      WithCancelTitle:(NSString *)cancelTitle
        WithSureBlock:(void(^)())sureBlock
      WithCancelBlock:(void(^)())cancelBlock;
/**
 * 视图弹出
 */
- (void)show;
@end
