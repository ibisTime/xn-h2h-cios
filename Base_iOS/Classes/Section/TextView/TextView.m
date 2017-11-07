//
//  TextView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TextView.h"
#import "TLTextStorage.h"

#define TEXT_MARGIN 5

@interface TextView ()<UITextViewDelegate>

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, assign) CGFloat titleWidth;

@end

@implementation TextView

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder
{
    
    if (self = [super init]) {
        
        self.placeHolder = placeholder;
        
        self.titleWidth = titleWidth;
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleWidth, frame.size.height)];
        
        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleWidth - 20, frame.size.height)];
        leftLbl.text = leftTitle;
        leftLbl.textAlignment = NSTextAlignmentLeft;
        leftLbl.font = [UIFont secondFont];
        leftLbl.textColor = [UIColor colorWithHexString:@"#484848"];
        [leftBgView addSubview:leftLbl];
        [self addSubview:leftBgView];
        
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];

        self.textView.placeholderLbl.textColor = [UIColor colorWithHexString:@"#999999"];
        self.textView.font = FONT(15);
        self.textView.textColor = [UIColor textColor];
        self.textView.textContainerInset = UIEdgeInsetsMake(TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN, TEXT_MARGIN);
        
        [self addSubview:self.textView];
        
        
    }
    return self;
    
}

- (TLComposeTextView *)textView {
    
    if (!_textView) {
        
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
        TLComposeTextView *editTextView = [[TLComposeTextView alloc] initWithFrame:CGRectMake(_titleWidth - 10, 10, self.width - self.titleWidth - 15, COMPOSE_ORG_HEIGHT) textContainer:textContainer];
        //        editTextView.scrollEnabled = NO;
        editTextView.keyboardType = UIKeyboardTypeTwitter;
        editTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);
        editTextView.delegate = self;
        editTextView.font = [UIFont systemFontOfSize:15];
        editTextView.placholder = self.placeHolder;
        editTextView.backgroundColor = kClearColor;
        _textView = editTextView;
        
        textStorage.textView = editTextView;
    }
    
    return _textView;
    
}

- (void)setContent:(NSString *)content {

    _content = content;
    
    _textView.text = _content;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        self.clearButtonMode = UITextFieldViewModeWhileEditing;
//        //        self.textAlignment = NSTextAlignmentRight;
//        self.font = [UIFont secondFont];
//        
    }
    
    return self;
    
}

#pragma mark --处理复制粘贴事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.isSecurity){
        
        return NO;
        
    } else{
        return [super canPerformAction:action withSender:sender];
    }
    //    if (action == @selector(paste:))//禁止粘贴
    //        return NO;
    //    if (action == @selector(select:))// 禁止选择
    //        return NO;
    //    if (action == @selector(selectAll:))// 禁止全选
    //        return NO;
}

@end
