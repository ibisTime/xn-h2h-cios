//
//  IntroduceEditVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/11/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "IntroduceEditVC.h"
//#import "TLEmoticonInputView.h"
#import "TLComposeTextView.h"
#import "SVProgressHUD.h"
#import "TLComposeToolBar.h"
//#import "TLEmoticonHelper.h"
#import "TLTextStorage.h"
#import "MLLinkLabel.h"
#import "NSString+MLExpression.h"

#import "NavigationController.h"

#define TITLE_MARGIN 10
#define TEXT_MARGIN 5

@interface IntroduceEditVC ()

@property (nonatomic, strong) TLComposeToolBar *toolBar;

@property (nonatomic, strong) TLComposeTextView *composeTextView;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *titleBtn;//顶部板块吊起

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation IntroduceEditVC

{
    dispatch_group_t _uploadGroup;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIBarButtonItem addRightItemWithTitle:@"确定" titleColor:kTextColor frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(send)];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _uploadGroup = dispatch_group_create();
    
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - TOOLBAR_EFFECTIVE_HEIGHT)];
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.bgScrollView];
    //    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight - 0 + 10);
    
    
    //
    self.title = @"个人简介";
    
    //-----//
    //内容栏
    self.composeTextView.y = 0;
    self.composeTextView.font = FONT(15);
    self.composeTextView.textColor = [UIColor textColor];
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
    
    self.composeTextView.text = self.introduce;
    
    [self.bgScrollView addSubview:self.composeTextView];
    
}

#pragma mark - Setting

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
}

#pragma mark-
- (void)textViewDidChange:(UITextView *)textView {
    
    //内容
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width - 10, MAXFLOAT)];
    if (size.height + 10 > COMPOSE_ORG_HEIGHT) {
        
        textView.height = size.height + 10;
        
    } else  {
        
        textView.height = COMPOSE_ORG_HEIGHT;
    }
    
    
    if (self.composeTextView.yy + kScreenWidth - 20 > (kSuperViewHeight - TOOLBAR_EFFECTIVE_HEIGHT) + 10) {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.composeTextView.yy + kScreenWidth + 20);
        
    } else {
        
        self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.width, self.bgScrollView.height + 20);
    }
    
    
}


#pragma mark- 发布
- (void)send {
    
    if (![[self.composeTextView.attributedText string] valid]) {
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"请输入简介内容"]];
        return ;
    }
    
    if ([self.composeTextView.attributedText string].length > 70) {
        
        [TLAlert alertWithInfo:@"简介内容不超过70字"];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    
    http.showView = self.view;
    //简介
    NSString *plainStr = [self.composeTextView.attributedText string];
    
    http.code = @"805098";
    
    http.parameters[@"introduce"] = plainStr;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    //
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"个人简介修改成功"];
        
        [TLUser user].introduce = plainStr;
        
        if (_introduceSuccess) {
            
            _introduceSuccess(plainStr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChange object:nil];

    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark- 取消发布

- (void)keyboardWillAppear:(NSNotification *)notification {
    
    //获取键盘高度
    CGFloat duration =  [notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect keyBoardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    [UIView animateWithDuration:duration delay:0 options: 458752 | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.toolBar.y = CGRectGetMinY(keyBoardFrame) - TOOLBAR_EFFECTIVE_HEIGHT - 64;
        
        
    } completion:NULL];
    
}

- (TLComposeTextView *)composeTextView {
    
    if (!_composeTextView) {
        
        //textConiter
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
        
        //layoutManager
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:textContainer];
        
        //textStorage
        TLTextStorage *textStorage = [[TLTextStorage alloc] init];
        [textStorage addLayoutManager:layoutManager];
        [textStorage setAttributedString:[[NSAttributedString alloc] init]];
        
        //
        TLComposeTextView *editTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(0, 64 + 5, kScreenWidth, COMPOSE_ORG_HEIGHT) textContainer:textContainer];
        //        editTextView.scrollEnabled = NO;
        editTextView.keyboardType = UIKeyboardTypeTwitter;
        editTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);
        editTextView.delegate = self;
        editTextView.font = [UIFont systemFontOfSize:15];
        editTextView.placholder = [NSString stringWithFormat:@"请输入简介内容(限70字)"];
        editTextView.placeholderLbl.font = Font(15.0);
        editTextView.placeholderLbl.textColor = [UIColor colorWithHexString:@"#999999"];
        
        _composeTextView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _composeTextView;
    
}


@end
