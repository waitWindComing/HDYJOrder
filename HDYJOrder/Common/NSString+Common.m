//
//  NSString+Common.m
//  HDYJOrder
//
//  Created by libertyAir on 2017/11/21.
//  Copyright © 2017年 gwl. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

+(NSMutableAttributedString *)getAttriWith:(NSString *)text{

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\[默认地址\\]"
                                  options:0 error:nil];
    
    NSArray *numArr = [regex matchesInString:text
                                     options:0
                                       range:NSMakeRange(0, [text length])];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString
                                                    alloc]
                                                   initWithString:text
                                                   attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12]
                             range:NSMakeRange(0,[text length])];
    
    for (NSTextCheckingResult *attirbute in numArr) {
        [attributedString setAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(255, 164, 0)}
                                  range:attirbute.range];
    }
    
    return attributedString;
}
@end
