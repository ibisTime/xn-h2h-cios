//
//  PublishFooterView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/10/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "PublishFooterView.h"

@interface PublishFooterView ()
//上架/下架
@property (nonatomic, strong) UIButton *shelvesBtn;
//编辑
@property (nonatomic, strong) UIButton *editBtn;
//删除
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation PublishFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        //删除
        _deleteBtn = [UIButton buttonWithTitle:@"删除" titleColor:kTextColor2 backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _deleteBtn.layer.borderWidth = 1;
        _deleteBtn.layer.borderColor = kTextColor2.CGColor;
        
        [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_deleteBtn];
        
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
        //编辑
        _editBtn = [UIButton buttonWithTitle:@"编辑" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _editBtn.layer.borderWidth = 1;
        _editBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_editBtn];
        
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_equalTo(@30);
            make.width.mas_equalTo(@70);
            
        }];
        
        //上架
        _shelvesBtn = [UIButton buttonWithTitle:@"" titleColor:kAppCustomMainColor backgroundColor:kClearColor titleFont:14.0 cornerRadius:3];
        
        _shelvesBtn.layer.borderWidth = 1;
        _shelvesBtn.layer.borderColor = kAppCustomMainColor.CGColor;
        
        [_shelvesBtn addTarget:self action:@selector(shelves) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_shelvesBtn];
        
    }
    return self;
}

- (void)setGood:(GoodModel *)good {
    
    _good = good;
    
    NSInteger status = [_good.status integerValue];
    
    switch (status) {
        case 3:
        {
            [self.shelvesBtn setTitle:@"下架" forState:UIControlStateNormal];

            [self.shelvesBtn setTitleColor:kTextColor2 forState:UIControlStateNormal];
            
            self.shelvesBtn.layer.borderColor = kTextColor2.CGColor;

            self.deleteBtn.hidden = YES;
            
            self.editBtn.hidden = YES;
            
            [self layoutSubviews];
            
            [_shelvesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(self.mas_centerY);
                make.height.mas_equalTo(@30);
                make.width.mas_equalTo(@70);
                
            }];
            
        }break;
            
        case 4:
        case 6:

        {
            self.shelvesBtn.hidden = YES;
            
            self.editBtn.hidden = YES;
            
            
        }break;
            
        case 5:
            
        {
            [self.shelvesBtn setTitle:@"上架" forState:UIControlStateNormal];

            [_shelvesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_editBtn.mas_left).offset(-10);
                make.centerY.equalTo(self.mas_centerY);
                make.height.mas_equalTo(@30);
                make.width.mas_equalTo(@70);
                
            }];
            
        }break;
            
        default:
            break;
    }

}

#pragma mark - Events
- (void)delete {
    
    if (_publishBlock) {
        
        _publishBlock(PublishEventsTypeDelete);
    }
}

- (void)edit {
    
    if (_publishBlock) {
        
        _publishBlock(PublishEventsTypeEdit);
    }
}

- (void)shelves {
    
    if ([_good.status isEqualToString:@"3"]) {
        
        if (_publishBlock) {
            
            _publishBlock(PublishEventsTypeOff);
        }
        
    } else if ([_good.status isEqualToString:@"5"]) {
        
        if (_publishBlock) {
            
            _publishBlock(PublishEventsTypeOn);
        }
    }
    
}

@end
