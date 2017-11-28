//
//  HomeLeftCell.h
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/14.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLeftModel.h"

@interface HomeLeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) HomeLeftModel *model;
@end
