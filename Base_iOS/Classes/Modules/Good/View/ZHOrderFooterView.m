//
//  ZHOrderFooterView.m
//  ZHCustomer
//
//  Created by  tianlei on 2016/12/31.
//  Copyright © 2016年  tianlei. All rights reserved.
//

#import "ZHOrderFooterView.h"

@interface ZHOrderFooterView()
//支付
@property (nonatomic, strong) UIButton *payBtn;
//取消订单
@property (nonatomic, strong) UIButton *cancelBtn;
//申请退款
@property (nonatomic, strong) UIButton *applyRefundBtn;
//催货
@property (nonatomic, strong) UIButton *urgeSendGoodBtn;
//确认收货
@property (nonatomic, strong) UIButton *receiptBtn;
//评价
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic,strong) UIButton *statusBtn;

@end

@implementation ZHOrderFooterView

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
- (UIButton *)payBtn {
    
    if (!_payBtn) {
        
        _payBtn = [UIButton buttonWithTitle:@"立即支付" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _payBtn.layer.borderWidth = 1;
        _payBtn.layer.borderColor = kAppCustomMainColor.CGColor;

        [_payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_payBtn];
        
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _payBtn;
}

- (UIButton *)cancelBtn {
    
    if (!_cancelBtn) {
        
        _cancelBtn = [UIButton buttonWithTitle:@"取消订单" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = kTextColor2.CGColor;
        
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_payBtn.mas_left).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _cancelBtn;
}

- (UIButton *)urgeSendGoodBtn {
    
    if (!_urgeSendGoodBtn) {
        
        _urgeSendGoodBtn = [UIButton buttonWithTitle:@"催货" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _urgeSendGoodBtn.layer.borderWidth = 1;
        _urgeSendGoodBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_urgeSendGoodBtn addTarget:self action:@selector(urgeSendGood) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_urgeSendGoodBtn];
        
        [_urgeSendGoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _urgeSendGoodBtn;
}

- (UIButton *)applyRefundBtn {
    
    if (!_applyRefundBtn) {
        
        _applyRefundBtn = [UIButton buttonWithTitle:@"申请退款" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _applyRefundBtn.layer.borderWidth = 1;
        _applyRefundBtn.layer.borderColor = kTextColor2.CGColor;
        
        [_applyRefundBtn addTarget:self action:@selector(applyRefund) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_applyRefundBtn];
        
        [_applyRefundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_urgeSendGoodBtn.mas_left).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    
    return _applyRefundBtn;
}

- (UIButton *)receiptBtn {
    
    if (!_receiptBtn) {
        
        _receiptBtn = [UIButton buttonWithTitle:@"确认收货" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _receiptBtn.layer.borderWidth = 1;
        _receiptBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_receiptBtn addTarget:self action:@selector(confirmReceive) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_receiptBtn];
        
        [_receiptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _receiptBtn;
}

- (UIButton *)commentBtn {
    
    if (!_commentBtn) {
        
        _commentBtn = [UIButton buttonWithTitle:@"评价" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _commentBtn.layer.borderWidth = 1;
        _commentBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_commentBtn addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_commentBtn];
        
        [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
    }
    return _commentBtn;
}

- (void)setOrder:(OrderModel *)order {

    _order = order;
    
    //按钮状态
    [self.statusBtn setTitle:[_order getStatusName] forState:UIControlStateNormal];
    //根据状态添加按钮
    NSInteger status = [_order.status integerValue];
    
    switch (status) {
        case 1:
        {
            self.payBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            
        }break;
            
        case 2:
        {
            self.urgeSendGoodBtn.hidden = NO;
            self.applyRefundBtn.hidden = NO;
            
        }break;
            
        case 3:
        {
            self.receiptBtn.hidden = NO;
            
        }break;
            
        case 4:
        {
            self.commentBtn.hidden = NO;
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - Events
//取消订单
- (void)cancel {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeCancel);
    }
    
}

- (void)pay {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypePay);
    }
    
}

//申请退款
- (void)applyRefund {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeApplyRefund);
    }
}

//催货
- (void)urgeSendGood {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeUrgeSendGood);
    }
    
}

//收货
- (void)confirmReceive {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeConfirmReceiptGood);
    }
    
}

//评价
- (void)comment {
    
    if (_orderBlock) {
        
        _orderBlock(OrderEventsTypeComment);
    }
}

@end
