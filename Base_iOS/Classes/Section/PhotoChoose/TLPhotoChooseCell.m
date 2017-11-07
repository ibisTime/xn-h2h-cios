//
//  TLPhotoChooseCell.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPhotoChooseCell.h"

@interface TLPhotoChooseCell()

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation TLPhotoChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoImageView = [[UIImageView alloc] init];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoImageView];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
            
        }];
        
        //删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
//        deleteBtn.backgroundColor = [UIColor orangeColor];
        [deleteBtn setImage:[UIImage imageNamed:@"图片删除"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        
        [deleteBtn setEnlargeEdge:10];
        
        [self.contentView addSubview:deleteBtn];
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
        self.deleteBtn = deleteBtn;

        //
        self.addPhotoBtn = [UIButton buttonWithTitle:@"添加照片" titleColor:kTextColor backgroundColor:kWhiteColor titleFont:12.0];;
        
        self.addPhotoBtn.frame = self.contentView.bounds;

        [self.addPhotoBtn setImage:kImage(@"添加照片_小") forState:UIControlStateNormal];
        
        self.addPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"#f3f4f8"];

        [self.addPhotoBtn setTitleEdgeInsets:UIEdgeInsetsMake(50, -self.addPhotoBtn.imageView.width, 0, 0)];

        [self.addPhotoBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -self.addPhotoBtn.titleLabel.width)];
        //禁用
        self.addPhotoBtn.userInteractionEnabled = NO;
        
        [self.contentView addSubview:self.addPhotoBtn];

    }
    return self;
}


- (void)setPhotoItem:(TLPhotoChooseItem *)photoItem {

    _photoItem = photoItem;
    
    if (_photoItem.isAdd) {//添加按钮
        
        self.addPhotoBtn.hidden = NO;
        
        self.photoImageView.hidden = YES;
        self.deleteBtn.hidden = YES;
        
    } else {//显示
        
        self.addPhotoBtn.hidden = YES;
        self.photoImageView.hidden = NO;
        self.deleteBtn.hidden = NO;
        self.photoImageView.image = _photoItem.thumbnailImg;
        
    }

}


//- (void)setphotoItem:(TLPhotoItem *)photoItem {
//
//    _photoItem = photoItem;
//    
//    if (_photoItem.isAdd) {//添加按钮
//        
//        
//        self.addPhotoBtn.hidden = NO;
//        
//        self.photoImageView.hidden = YES;
//        self.deleteBtn.hidden = YES;
//        self.backgroundColor = [UIColor whiteColor];
//    
//
//    } else {//显示
//
//        
//        self.addPhotoBtn.hidden = YES;
//        self.photoImageView.hidden = NO;
//        self.deleteBtn.hidden = NO;
//        self.photoImageView.image = _photoItem.img;
//        
//    }
//
//}


//- (void)addPhoto {
//
//    if (self.add) {
//        self.add();
//    }
//
//}

- (void)delete {

    if (self.deleteItem) {
        
        self.deleteItem(self.photoItem);
    }


}
@end
