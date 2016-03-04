//
//  XMGWaterLayout.h
//  瀑布流
//
//  Created by Mac on 16/3/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGWaterLayout;
@protocol XMGWaterLayoutDelegate <NSObject>

@required
-(CGFloat )waterlayout:(XMGWaterLayout *)waterlayout heightForItemAtIndex:(NSUInteger )index itemWidth:(CGFloat)itemWidth;

@optional
-(CGFloat)columCountInwaterlayout:(XMGWaterLayout *)waterlayout;
-(CGFloat)columMarginInwaterlayout:(XMGWaterLayout *)waterlayout;
-(CGFloat)rowMarginInwaterlayout:(XMGWaterLayout *)waterlayout;
-(UIEdgeInsets )edgeInsetsInwaterlayout:(XMGWaterLayout *)waterlayout;



@end

@interface XMGWaterLayout : UICollectionViewLayout

/**代理*/
@property (nonatomic ,weak) id <XMGWaterLayoutDelegate> delegate;

@end
