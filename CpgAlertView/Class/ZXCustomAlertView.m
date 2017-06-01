//
//  ZXCustomAlertView.m
//  ZXCWS
//
//  Created by 常鹏阁 on 2017/5/17.
//  Copyright © 2017年 Wanyi. All rights reserved.
//

#import "ZXCustomAlertView.h"
#import "UIView+Frame.h"

#define NAGATIONCOLOR RGB(96,146,225)
#define RGBCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define PX (SCREEN_WIDTH / 1242)
#define UIColorFromRGB(rgbValue)                            \
[UIColor                                                    \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0   \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0             \
blue:((float)(rgbValue & 0xFF))/255.0                       \
alpha:1.0]


@interface ZXCustomAlertView(){
    UIView *_bgView;
    UIView *_alertView;
}
@end

@implementation ZXCustomAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
                    WithTitle:(NSString *)title
                  WithContent:(NSString *)content
             WithSureBtnTitle:(NSString *)sureTitle
           WithCancelBtnTitle:(NSString *)cancelTitle{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgView.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
        [self addSubview:_bgView];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 930*PX, 0)];
        alertView.center = _bgView.center;
        [alertView setBackgroundColor:[UIColor whiteColor]];
        alertView.layer.cornerRadius = 6*PX;
        alertView.layer.masksToBounds = YES;
        [_bgView addSubview:alertView];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertView.frame.size.width, 138*PX)];
        titleLable.font = [UIFont systemFontOfSize:51*PX];
        titleLable.text = title;
        titleLable.textColor = UIColorFromRGB(0x333333);
        titleLable.textAlignment = NSTextAlignmentCenter;
        [alertView addSubview:titleLable];
        
        UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLable.frame.origin.y + titleLable.frame.size.height, alertView.frame.size.width, 0.5)];
        upLineView.backgroundColor = UIColorFromRGB(0xcccccc);
        [alertView addSubview:upLineView];
        
        CGSize size = [self labelAutoCalculateRectWith:content FontSize:48*PX MaxSize:CGSizeMake(alertView.width - 114*PX, MAXFLOAT)];
        
        CGFloat maxFloat = SCREEN_HEIGHT - 4 * 138 * PX;
        CGFloat height = MAX((size.height + 60*PX), 309*PX);
        
        UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, upLineView.MaxY, alertView.width, MIN(maxFloat, height))];
        contentView.contentSize = CGSizeMake(alertView.width, height);
        contentView.backgroundColor = [UIColor clearColor];
        [alertView addSubview:contentView];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(57*PX, 30*PX, contentView.width - 114*PX, size.height)];
        contentLabel.text = content;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:48*PX];
        contentLabel.textColor = UIColorFromRGB(0x333333);
        [contentView addSubview:contentLabel];
        
        UIView *downLineView = [[UIView alloc]initWithFrame:CGRectMake(0, contentView.MaxY, alertView.width, 0.5)];
        downLineView.backgroundColor = UIColorFromRGB(0xcccccc);
        [alertView addSubview:downLineView];
        
        NSMutableArray *btnArr = [NSMutableArray array];
        if (![self isBlankString:sureTitle]) [btnArr addObject:sureTitle];
        if (![self isBlankString:cancelTitle]) [btnArr addObject:cancelTitle];
        
        CGFloat width = alertView.width/(CGFloat)btnArr.count;
        for (NSInteger i = 0; i < btnArr.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(width * i, downLineView.MaxY, width, 138*PX);
            btn.tag = i;
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [btn setTitleColor:UIColorFromRGB(0x6092e1) forState:UIControlStateNormal];
            }else
                [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [btn setTitle:btnArr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:51*PX];
            [alertView addSubview:btn];
            
            if (i == 0 && btnArr.count > 1) {
                UIView *speLineView = [[UIView alloc]initWithFrame:CGRectMake(btn.width - 0.5, 0, 0.5, btn.height)];
                speLineView.backgroundColor = UIColorFromRGB(0xcccccc);
                [btn addSubview:speLineView];
            }
           
        }
        alertView.height = downLineView.MaxY + 138*PX;
        alertView.center = _bgView.center;
        _alertView = alertView;
    }
    return self;
}
- (ZXCustomAlertView *)initWithTitle:(NSString *)title
    WithContentString:(NSString *)content
        WithSureTitle:(NSString *)sureTitle
      WithCancelTitle:(NSString *)cancelTitle
        WithSureBlock:(void (^)())sureBlock
      WithCancelBlock:(void (^)())cancelBlock{
    ZXCustomAlertView *alretView = [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithTitle:title WithContent:content WithSureBtnTitle:sureTitle WithCancelBtnTitle:cancelTitle];
    _sureActionBlock = sureBlock;
    _cancelActionBlock = cancelBlock;
    return alretView;
}
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[self class] animationAlert:_alertView];
}
+(void) animationAlert:(UIView *)view
{
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}
- (void)selectAction:(UIButton *)btn{
    if (btn.tag == 0) {
        _sureActionBlock();
    }
    [self removeFromSuperview];
}
- (BOOL) isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    if ([string isEqualToString:@""] || string == nil || string == NULL || [string isEqualToString :@"null" ]|| [string isEqualToString:@"<null>"]) {
        
        return YES;
        
    }
    
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}
- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    //    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    //
    //    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    //    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine:attributes context:nil].size;
    CGSize labelSize = [text boundingRectWithSize:maxSize options:(NSStringDrawingOptions)(NSStringDrawingUsesLineFragmentOrigin) attributes:attributes context:nil].size;
    //    [paragraphStyle release];
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}

@end
