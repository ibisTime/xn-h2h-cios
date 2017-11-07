//
//  TLPhotoChooseView.m
//  CityBBS
//
//  Created by  tianlei on 2017/3/12.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLPhotoChooseView.h"
#import "TLPhotoChooseCell.h"
//#import "TLImagePicker.h"
#import "ZipImg.h"

@interface TLPhotoChooseView()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *photoChooseCollectionView;

@property (nonatomic, strong) NSMutableArray <TLPhotoChooseItem *> *truePhotoItems;

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation TLPhotoChooseView
{
    dispatch_group_t _group;

}

- (NSArray *)getPhotoItems {

    //有添加按钮，进行去除
   __block TLPhotoChooseItem *addItem = nil;
    [self.truePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.isAdd) {
            addItem = obj;
        }
    }];
    
    if (addItem) {
        
      return  [self.truePhotoItems subarrayWithRange:NSMakeRange(1, self.truePhotoItems.count - 1)];
        
    } else {
    
      return self.truePhotoItems;
    }

}

- (void)getImgs:(void (^)(NSArray<UIImage *> *))imgsBLock {

    NSMutableArray <UIImage *>*imgs = [[NSMutableArray alloc] initWithCapacity:self.truePhotoItems.count];
    
    NSMutableArray <NSDictionary *>*dicArr = [[NSMutableArray alloc] initWithCapacity:self.truePhotoItems.count];
    
    [self.truePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.isAdd &&obj.asset) {
            
            dispatch_group_enter(_group);
            
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.networkAccessAllowed = YES;
            option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            //异步获取
            [[PHImageManager defaultManager] requestImageForAsset:obj.asset
                                                       targetSize:PHImageManagerMaximumSize
                                                      contentMode:PHImageContentModeAspectFill
                                                          options:option
                                                    resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                        
                                                        //压缩图片
                                                        ZipImg *zipImg = [[ZipImg alloc] init];
                                                        
                                                        [zipImg zipImg:result begin:^{
                                                            
                                                            
                                                        } end:^(UIImage *img) {
                                                            
                                                            //图片排序
                                                            [dicArr addObject:@{info[@"PHImageResultRequestIDKey"]: img}];
                                                            
                                                            dispatch_group_leave(_group);
                                                        }];
                                                        
                                                    }];
        }
    }];
    
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        
        NSArray *arr = [dicArr copy];
        
        if (arr.count > 0) {
            
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                
                if (obj1.allKeys[0] > obj2.allKeys[0]) {
                    
                    return NSOrderedDescending;
                    
                } else {
                    
                    return NSOrderedAscending;
                }
            }];
            
            for (NSDictionary *dic in arr) {
                
                [imgs addObject:dic.allValues[0]];
            }
        }
        
        if (imgsBLock) {
            
            imgsBLock(imgs);
        }
    });

}

- (instancetype)initWithFrame:(CGRect)frame type:(PhotoSortType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sortType = type;
        [self photoChooseWithFrame:frame];
        _group = dispatch_group_create();
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}

- (void)photoChooseWithFrame:(CGRect)frame {
    
    //九宫格
    if (_sortType == PhotoSortTypeSquared) {
        
        //取短边
        CGFloat w = frame.size.width > frame.size.height ? frame.size.height : frame.size.width;
        
        //布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //
        CGFloat itemWidth = (w - 2*5)/3.0;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        //  flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, w, w) collectionViewLayout:flowLayout];
        photoCollectionView.backgroundColor = [UIColor whiteColor];
        photoCollectionView.delegate = self;
        photoCollectionView.dataSource = self;
        photoCollectionView.showsVerticalScrollIndicator = NO;
        photoCollectionView.showsHorizontalScrollIndicator = NO;
        
        [photoCollectionView registerClass:[TLPhotoChooseCell class] forCellWithReuseIdentifier:@"photoCell"];

        [self addSubview:photoCollectionView];
        
        self.photoChooseCollectionView = photoCollectionView;
        
    } else if (_sortType == PhotoSortTypeScroll) {
        
        //布局对象
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //
        CGFloat itemWidth = 87.5;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
//        flowLayout.minimumLineSpacing = 5;
//        flowLayout.minimumInteritemSpacing = 10;
          flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) collectionViewLayout:flowLayout];
        photoCollectionView.backgroundColor = [UIColor whiteColor];
        photoCollectionView.delegate = self;
        photoCollectionView.dataSource = self;
        photoCollectionView.showsVerticalScrollIndicator = NO;
        photoCollectionView.showsHorizontalScrollIndicator = NO;
        
        [photoCollectionView registerClass:[TLPhotoChooseCell class] forCellWithReuseIdentifier:@"photoCell"];
        
        [self addSubview:photoCollectionView];
        
        self.photoChooseCollectionView = photoCollectionView;
        
    }
    
}

- (void)finishChooseWithImgs:(NSArray <TLPhotoChooseItem *>*)imgs {

    if (!imgs || imgs.count > 12) {
        
        NSLog(@"图片数组不符合要求");
        return;
    }
    
    if (_sortType == PhotoSortTypeSquared) {
        
        if (imgs.count == 0) {
            
            self.truePhotoItems = [NSMutableArray array];
            
            TLPhotoChooseItem *addItem = [TLPhotoChooseItem new];
            addItem.isAdd = YES;
            
            //添加
            [self.truePhotoItems addObjectsFromArray:@[addItem]];
            
            [self.photoChooseCollectionView reloadData];
            return;
        }
        
        //--//
        self.truePhotoItems = [imgs mutableCopy];
        
        [self.truePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.isAdd = NO;
            
        }];
        
        if (imgs.count <=  11) {
            
            //11张一下
            TLPhotoChooseItem *addItem = [TLPhotoChooseItem new];
            addItem.isAdd = YES;
            
            //添加
            [self.truePhotoItems addObjectsFromArray:@[addItem]];
            
        } else {
            //12 张
            TLPhotoChooseItem *addItem = [TLPhotoChooseItem new];
            addItem.isAdd = YES;
            
            //添加
            [self.truePhotoItems addObjectsFromArray:@[addItem]];
        }
        
        [self.photoChooseCollectionView reloadData];
        
    } else if (_sortType == PhotoSortTypeScroll) {
        
        self.truePhotoItems = [NSMutableArray array];
        
        TLPhotoChooseItem *addItem = [TLPhotoChooseItem new];
        addItem.isAdd = YES;
        
        //添加
        [self.truePhotoItems addObject:addItem];
        //加入选择的图片
        [self.truePhotoItems addObjectsFromArray:imgs];

        [self.truePhotoItems enumerateObjectsUsingBlock:^(TLPhotoChooseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx != 0) {
                
                obj.isAdd = NO;
            }
            
        }];
        
        [self.photoChooseCollectionView reloadData];
    }
}


#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if(self.truePhotoItems[indexPath.row].isAdd && self.addAction) {
    
        self.addAction();
    }
}

#pragma mark- collectionView-DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //--//
    return self.truePhotoItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    
    TLPhotoChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

    [cell setDeleteItem:^(TLPhotoChooseItem *deleteItem){

        [weakself.truePhotoItems removeObject:deleteItem];
        [weakself.photoChooseCollectionView reloadData];

    }];
    
    cell.backgroundColor = RANDOM_COLOR;
    cell.photoItem  = self.truePhotoItems[indexPath.row];
    
    return cell;
}

#pragma mark- 手势代理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    NSLog(@"%@",NSStringFromSelector(_cmd));

    return YES;
}

//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    
    return YES;
    
}

#pragma mark- 手势失败
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
    
    return NO;
}


#pragma mark- 以下关于图片 拖拽重排


@end
