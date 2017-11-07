//
//  SendCommentVC.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/20.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "SendCommentVC.h"
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

@interface SendCommentVC ()

//@property (nonatomic, strong) TLEmoticonInputView *emoticonInputView;
@property (nonatomic, strong) TLComposeToolBar *toolBar;

@property (nonatomic, strong) TLComposeTextView *composeTextView;
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIButton *titleBtn;//顶部板块吊起
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation SendCommentVC

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
    
    [UIBarButtonItem addRightItemWithTitle:self.titleStr titleColor:kTextColor frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(send)];

    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _uploadGroup = dispatch_group_create();
    
    //
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:kCancelIcon] forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeScaleToFill;
    btn.frame = CGRectMake(0, 0, 16, 16);
    [btn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //背景
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - TOOLBAR_EFFECTIVE_HEIGHT)];
    self.bgScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.bgScrollView];
    //    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight - 0 + 10);
    
    
    //板块选择
    self.navigationItem.titleView = self.titleBtn;
    
    //-----//
    //内容栏
    self.composeTextView.y = 0;
    self.composeTextView.font = FONT(15);
    self.composeTextView.textColor = [UIColor textColor];
    self.composeTextView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
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
    
    if (!self.toObjCode) {
        [TLAlert alertWithInfo:@"填写操作对象"];
        return;
    }
    
    if (![[self.composeTextView.attributedText string] valid]) {
        [TLAlert alertWithInfo:[NSString stringWithFormat:@"请输入%@内容", self.titleStr]];
        return ;
    }
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;
    //    1 帖子的留言 2 留言的留言
    
    NSString *plainStr = [self.composeTextView.attributedText string];
    
    if (self.type == SendCommentActionTypeLeaveMessage) {
        
        http.code = @"801020";
        
        http.parameters[@"content"] = plainStr;
        http.parameters[@"entityCode"] = self.toObjCode;
        http.parameters[@"commenter"] = [TLUser user].userId;
        
    } else {
        
        http.code = @"808059";
        http.parameters[@"orderCode"] = self.toObjCode;
        http.parameters[@"commenter"] = [TLUser user].userId;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"content"] = plainStr;
        dic[@"productCode"] = self.productCode;
        dic[@"score"] = @"0";
        
        http.parameters[@"commentList"] = @[dic];
    }
    
    
    CommentModel *commentModel = nil;

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd, yyyy hh:mm:ss aa";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    //
    [http postWithSuccess:^(id responseObject) {
        
        NSString *code;
        
        if (self.type == SendCommentActionTypeLeaveMessage) {
            
           code = responseObject[@"data"][@"code"];

        } else {
            
            code = responseObject[@"data"][0];

        }
        
        if ([code containsString:@"filter"]) {
            
            [TLAlert alertWithInfo:[NSString stringWithFormat:@"%@成功, 您的%@包含敏感字符,我们将进行审核", self.titleStr, self.titleStr]];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

            return ;
        }
        
        [self.view endEditing:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshCommentList" object:nil];
        
        [TLAlert alertWithSucces:[NSString stringWithFormat:@"%@成功", self.titleStr]];
        
        if (self.commentSuccess) {
            
            self.commentSuccess(commentModel);
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark- 取消发布
- (void)cancle {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

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
        editTextView.placholder = [NSString stringWithFormat:@"请输入%@内容", self.titleStr];
        editTextView.placeholderLbl.font = Font(15.0);
        editTextView.placeholderLbl.textColor = [UIColor colorWithHexString:@"#999999"];
        
        _composeTextView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _composeTextView;
    
}


- (UIButton *)titleBtn {
    
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 120, 30)];
        _titleBtn.enabled = NO;
        UILabel *titlelbl = [UILabel labelWithFrame:CGRectZero
                                       textAligment:NSTextAlignmentCenter
                                    backgroundColor:[UIColor clearColor]
                                               font:FONT(18)
                                          textColor:kTextColor];
        [_titleBtn addSubview:titlelbl];
        [titlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleBtn.mas_centerX);
            make.bottom.equalTo(_titleBtn.mas_bottom).offset(-4);
            
        }];
        titlelbl.text = [NSString stringWithFormat:@"发布%@", self.titleStr];
        self.titleLbl = titlelbl;
        
        
    }
    return _titleBtn;
    
}


@end
