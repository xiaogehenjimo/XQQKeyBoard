//
//  XQQKeyBoardView.m
//  XQQKeyBoard
//
//  Created by XQQ on 16/9/5.
//  Copyright © 2016年 UIP. All rights reserved.
//

#import "XQQKeyBoardView.h"

#define iphoneWidth  [UIScreen mainScreen].bounds.size.width
#define iphoneHeight [UIScreen mainScreen].bounds.size.height

// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f

// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f

// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

//#define selfHeight 320


@interface XQQKeyBoardView ()<UITextFieldDelegate>
/**
 * 底部的view
 */
@property(nonatomic, strong)  UIView  *  bottomView;
/**
 *  上部输入框的view
 */
@property(nonatomic, strong)  UIView  *  inputView;
/**
 *  发送语音的btn
 */
@property(nonatomic, strong)  UIButton  *  voiceBtn;
/**
 *  输入框
 */
@property(nonatomic, strong)  UITextField  *  textField;
/**
 *  录制音频按钮
 */
@property(nonatomic, strong)  UIButton  *  scanfVoiceBtn;
/**
 *  表情按钮
 */
@property(nonatomic, strong)  UIButton  *  faceBtn;
/**
 *  加号按钮
 */
@property(nonatomic, strong)  UIButton  *  addBtn;
/**
 *  高
 */
@property(nonatomic, assign)  CGFloat   selfHeight;
@end

@implementation XQQKeyBoardView
{
    BOOL _isShow;//右侧加号按钮点击
    BOOL _isVoice;//左侧语音按钮点击
}


- (instancetype)init{
    if (iPhone5SE) {
        _selfHeight = 253.0 + 50;
    }else if(iPhone6_6s){
        _selfHeight = 258 + 50;
    }else{
        _selfHeight = 271 + 50;
    }
    CGRect myFrame = CGRectMake(0, iphoneHeight - 50, iphoneWidth, _selfHeight);
    if (self = [super initWithFrame:myFrame])
    {
        [self registerForKeyboardNotifications];
        //初始化最底部的view
        [self initBottomView];
        //初始化上部输入View
        [self initTopInputView];
        
        //初始化下部 滚动视图
        [self initBottomViewScrollerViews];
        
    }
    return self;
}
/**
 *  初始化下部 滚动视图
 */
- (void)initBottomViewScrollerViews{
    //背景view
    CGFloat backBigViewX = 0;
    CGFloat backBigViewY = CGRectGetMaxY(self.inputView.frame);
    CGFloat backBigViewW = iphoneWidth;
    CGFloat backBigViewH = _selfHeight - self.inputView.frame.size.height;
    UIView * backBigView = [[UIView alloc]initWithFrame:CGRectMake(backBigViewX, backBigViewY, backBigViewW, backBigViewH)];
    backBigView.backgroundColor = [UIColor yellowColor];
    [_bottomView addSubview:backBigView];
    //创建滚动视图
    CGFloat bottomScrollViewX = 0;
    CGFloat bottomScrollViewY = 0;
    CGFloat bottomScrollViewW = backBigViewW;
    CGFloat bottomScrollViewH = backBigViewH;
    UIScrollView * bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(bottomScrollViewX, bottomScrollViewY, bottomScrollViewW, bottomScrollViewH)];
    bottomScrollView.backgroundColor = [UIColor grayColor];
    bottomScrollView.pagingEnabled = YES;
    bottomScrollView.showsVerticalScrollIndicator = YES;
    bottomScrollView.showsHorizontalScrollIndicator = YES;
    bottomScrollView.scrollsToTop = NO;
    bottomScrollView.contentSize = CGSizeMake(2 * backBigViewW, 0);
    //添加按钮
    UIView * leftView = nil;
    UIView * rightView = nil;
    for (NSInteger i = 0; i < 2; i ++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i * bottomScrollViewW, 0, bottomScrollViewW, bottomScrollViewH)];
        view.backgroundColor = [UIColor colorWithRed:arc4random()%100/255.0 green:arc4random()%100/255.0 blue:arc4random()%100/255.0 alpha:1];
        [bottomScrollView addSubview:view];
        if (i == 0) {
            leftView = view;
        }else{
            rightView = view;
        }
    }
    
    
    
    
    [backBigView addSubview:bottomScrollView];
    
}
/**
 *  初始化上部输入View
 */
- (void)initTopInputView{
    //背景条
    CGFloat backViewX = 0;
    CGFloat backViewY = 0;
    CGFloat backViewW = iphoneWidth;
    CGFloat backViewH = 50;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(backViewX, backViewY, backViewW, backViewH)];
    backView.backgroundColor = [UIColor colorWithRed:100/255.0 green:200/255.0  blue:150/255.0  alpha:1];
    self.inputView = backView;
    [_bottomView addSubview:backView];
    //左侧语音按钮
    CGFloat voiceBtnX = 5;
    CGFloat voiceBtnY = 5;
    CGFloat voiceBtnW = 40;
    CGFloat voiceBtnH = 40;
    UIButton * voiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(voiceBtnX, voiceBtnY, voiceBtnW, voiceBtnH)];
    voiceBtn.layer.cornerRadius = 15;
    voiceBtn.tag = 995;
    [voiceBtn setImage:[UIImage imageNamed:@"btn_voice@2x"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(inputBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    voiceBtn.layer.masksToBounds = YES;
    [backView addSubview:voiceBtn];
    
    //输入框
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(voiceBtn.frame) + 5,voiceBtnY,backViewW - 145, voiceBtnH)];
    textField.delegate = self;
    [textField setBackground:[UIImage imageNamed:@"text_bg@2x"]];
    textField.layer.cornerRadius = 13;
    textField.layer.masksToBounds = YES;
    self.textField = textField;
    textField.returnKeyType = UIReturnKeySend;
    [backView addSubview:textField];
    
    //录制语音按钮
    UIButton * scanfBtn = [[UIButton alloc]initWithFrame:textField.frame];
    scanfBtn.tag = 998;
    [scanfBtn addTarget:self action:@selector(inputBtnDidPress:) forControlEvents:UIControlEventTouchDown];
    [scanfBtn setBackgroundImage:[[UIImage imageNamed:@"enter_voicebg@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    scanfBtn.layer.cornerRadius = 13;
    scanfBtn.layer.masksToBounds = YES;
    self.scanfVoiceBtn = scanfBtn;
    scanfBtn.hidden = YES;
    [backView addSubview:scanfBtn];
    
    //表情按钮
    CGFloat faceBtnX = CGRectGetMaxX(textField.frame) + 5;
    CGFloat faceBtnY = 5;
    CGFloat faceBtnW = 40;
    CGFloat faceBtnH = 40;
    UIButton * faceBtn  =[[UIButton alloc]initWithFrame:CGRectMake(faceBtnX, faceBtnY, faceBtnW, faceBtnH)];
    faceBtn.backgroundColor = [UIColor orangeColor];
    faceBtn.layer.cornerRadius = 14;
    faceBtn.layer.masksToBounds = YES;
    faceBtn.tag = 996;
    [faceBtn addTarget:self action:@selector(inputBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:faceBtn];
    
    //加号按钮
    CGFloat addBtnX = CGRectGetMaxX(faceBtn.frame) + 5;
    CGFloat addBtnY = 5;
    CGFloat addBtnW = 40;
    CGFloat addBtnH = 40;
    UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(addBtnX, addBtnY, addBtnW, addBtnH)];
    [addBtn setImage:[UIImage imageNamed:@"btn_send@2x"] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 14;
    addBtn.layer.masksToBounds = YES;
    addBtn.tag = 997;
    [addBtn addTarget:self action:@selector(inputBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    [backView addSubview:addBtn];
}


/**
 *  初始化最底部的view
 */
- (void)initBottomView{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 300)];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomView];
}

/**
 * 按钮点击
 */
- (void)inputBtnDidPress:(UIButton*)button{
    switch (button.tag) {
        case 995:{//语音
            if (_isVoice) {//隐藏录制语音按钮
                self.scanfVoiceBtn.hidden = YES;
                //输入框成为第一响应者 弹出键盘
                [self.textField becomeFirstResponder];
                [self show];
                _isVoice = NO;
                _isShow = YES;
                [button setImage:[UIImage imageNamed:@"btn_voice@2x"] forState:UIControlStateNormal];//btn_keyboard@2x
                [UIView animateWithDuration:.1f animations:^{
                    self.addBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
                }];
            }else{//显示录制语音按钮
                self.scanfVoiceBtn.hidden = NO;
                _isVoice = YES;
                [self.textField resignFirstResponder];
                [self hide];
                _isShow = NO;
                [button setImage:[UIImage imageNamed:@"btn_keyboard@2x"] forState:UIControlStateNormal];//
                [UIView animateWithDuration:.1f animations:^{
                    self.addBtn.transform = CGAffineTransformMakeRotation(0);
                }];
            }
        }
            break;
        case 996:{//表情
            
        }
            break;
        case 997:{//加号 改变frame
            if (_isShow) {
                [self.textField resignFirstResponder];
                [UIView animateWithDuration:.1f animations:^{
                    self.addBtn.transform = CGAffineTransformMakeRotation(0);
                }];
                [self hide];
                _isShow = NO;
            }else{
                [UIView animateWithDuration:.1f animations:^{
                    self.addBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
                }];
                [self show];
                _isShow = YES;
            }
        }
            break;
        case 998:{//点击录制语音
            NSLog(@"开始录制");
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self show];
    _isVoice = NO;
    _isShow = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    textField.text = @"";
    [self.textField resignFirstResponder];
    [self hide];
    _isShow = NO;
    [UIView animateWithDuration:.1f animations:^{
        self.addBtn.transform = CGAffineTransformMakeRotation(0);
    }];
    return YES;
}

- (void)show{
    [UIView animateWithDuration:.2f animations:^{
        self.frame = CGRectMake(0, iphoneHeight - _selfHeight, iphoneWidth, _selfHeight);
    }];
}
- (void)hide{
    [UIView animateWithDuration:.2f animations:^{
        self.frame = CGRectMake(0, iphoneHeight - 50, iphoneWidth, _selfHeight);
    }];
}
//监听键盘的高度
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);//5s 253 // 6s 258 //6 plus 271
    //self.frame = CGRectMake(0, iphoneHeight - keyboardSize.height, iphoneWidth, keyboardSize.height + 50) ;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
}

@end
