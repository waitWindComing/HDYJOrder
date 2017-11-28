//
//  ShopCartModel.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/16.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartModel : NSObject
@property(nonatomic,assign) BOOL allSelect;//选中商店下的所有商品

@property(nonatomic,copy) NSString *edition;//版本id
@property(nonatomic,copy) NSString *edition_text;//版本名字
@property(nonatomic,strong) NSMutableArray *data;//该版本下的商品
@end

@interface GoodsModel : NSObject
@property(nonatomic,assign) BOOL selected;//商品是否被选中

@property(nonatomic,copy) NSString *num;//商品数量
@property(nonatomic,copy) NSString *price;//商品单价
@property(nonatomic,copy) NSString *goods_name;//商品名称
@property(nonatomic,copy) NSString *image;//商品图片
@property(nonatomic,copy) NSString *goods_id;//商品id
@property(nonatomic,copy) NSString *stock;//库存
//@property(nonatomic,copy) NSString *edition;//商品版本
@end
