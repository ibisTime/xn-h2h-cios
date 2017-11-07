//
//  SellFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/23.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "SellFooterView.h"

@interface SellFooterView ()

//取消订单
@property (nonatomic, strong) UIButton *cancelBtn;
//发货
@property (nonatomic, strong) UIButton *sendGoodBtn;
//确认退款
@property (nonatomic, strong) UIButton *confirmRefundBtn;
//查看评价
@property (nonatomic, strong) UIButton *lookCommentBtn;
//订单状态
@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation SellFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithTitle:@"" titleColor:kThemeColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        [self addSubview:btn];
        self.statusBtn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return self;
}
#pragma mark - 懒加载

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithTitle:@"取消订单" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _cancelBtn;
}

- (UIButton *)sendGoodBtn {
    
    if (!_sendGoodBtn) {
        
        _sendGoodBtn = [UIButton buttonWithTitle:@"发货" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _sendGoodBtn.layer.borderWidth = 1;
        _sendGoodBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_sendGoodBtn addTarget:self action:@selector(sendGood) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_sendGoodBtn];
        
        [_sendGoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _sendGoodBtn;
}

- (UIButton *)confirmRefundBtn {
    
    if (!_confirmRefundBtn) {
        
        _confirmRefundBtn = [UIButton buttonWithTitle:@"确认退款" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _confirmRefundBtn.layer.borderWidth = 1;
        _confirmRefundBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_confirmRefundBtn addTarget:self action:@selector(confirmRefund) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_confirmRefundBtn];
        
        [_confirmRefundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _confirmRefundBtn;
}

- (UIButton *)lookCommentBtn {
    
    if (!_lookCommentBtn) {
        
        _lookCommentBtn = [UIButton buttonWithTitle:@"查看评价" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _lookCommentBtn.layer.borderWidth = 1;
        _lookCommentBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_lookCommentBtn addTarget:self action:@selector(lookComment) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_lookCommentBtn];
        
        [_lookCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _lookCommentBtn;
}

- (void)setOrder:(OrderModel *)order {
    
    _order = order;
    
    //按钮状态
    [self.statusBtn setTitle:[_order getSellStatusName] forState:UIControlStateNormal];
    //根据状态添加按钮
    NSInteger status = [_order.status integerValue];
    
    switch (status) {
        case 1:
        {
            self.cancelBtn.hidden = NO;
            
        }break;
            
        case 2:
        {
            self.sendGoodBtn.hidden = NO;

        }break;
            
        case 5:
        {
            self.lookCommentBtn.hidden = NO;
        }break;
            
        case 6:
        {
            self.confirmRefundBtn.hidden = NO;
            
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Events
//取消订单
- (void)cancel {
    
    if (_sellBlock) {
        
        _sellBlock(SellEventsTypeCancel);
    }
    
}

//发货
- (void)sendGood {
    
    if (_sellBlock) {
        
        _sellBlock(SellEventsTypeSendGood);
    }
    
}

//确认退款
- (void)confirmRefund {
    
    if (_sellBlock) {
        
        _sellBlock(SellEventsTypeConfirmRefund);
    }
    
}

//查看评价
- (void)lookComment {
    
    if (_sellBlock) {
        
        _sellBlock(SellEventsTypeLookComment);
    }
}

@end
