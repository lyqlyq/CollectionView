
//
//  XMGWaterLayout.m
//  瀑布流
//
//  Created by Mac on 16/3/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XMGWaterLayout.h"

/** 每一列之间的间距 */

static const CGFloat  XMGDefaultColumMargin = 10;

/** 每一行之间的间距 */

static const CGFloat  XMGDefaultaRowMargin = 10;

/** 边缘间距 */

static const UIEdgeInsets  XMGDefaultaEdgeInsets = {10,10,10,10};

/** 默认的列数 */
static const NSInteger XMGDefaultaColumCount = 3;

@interface XMGWaterLayout ()

/***/
@property (nonatomic ,strong) NSMutableArray *array;

/**用来存放所有列的最大高度*/
@property (nonatomic ,strong) NSMutableArray *columnHeights;



-(CGFloat)rowMargin;
-(CGFloat)columMargin;
-(CGFloat)columCount;
-(UIEdgeInsets )edgeInsets;
@end


@implementation XMGWaterLayout

#pragma mark -- < 代理方法处理>

-(CGFloat)rowMargin{
  
    if ([self.delegate respondsToSelector:@selector(rowMarginInwaterlayout:)]) {
        return [self.delegate rowMarginInwaterlayout:self];
    }else{
        return XMGDefaultaRowMargin;
    }

}

-(CGFloat)columMargin{
    
    if ([self.delegate respondsToSelector:@selector(columMarginInwaterlayout:)]) {
        return [self.delegate columMarginInwaterlayout:self];
    }else{
        return XMGDefaultColumMargin;
    }
    
}

-(CGFloat)columCount{
    
    if ([self.delegate respondsToSelector:@selector(columCountInwaterlayout:)]) {
        return [self.delegate columCountInwaterlayout:self];
    }else{
        return XMGDefaultaColumCount;
    }
    
}
-(UIEdgeInsets )edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInwaterlayout:)]) {
        return [self.delegate edgeInsetsInwaterlayout:self];
    }else{
        return XMGDefaultaEdgeInsets;
    }
}



-(NSMutableArray *)columnHeights{
    
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
    
}
-(NSMutableArray *)array{
  
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    
    return _array;
 
}


-(void)prepareLayout{
    
    [super prepareLayout];
    
    // 清除一起计算所有高度
    [self.columnHeights removeAllObjects];
    
    for (int i = 0 ; i < self.columCount; i ++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }


    
    // 删除布局属性
    [self.array removeAllObjects];
    
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
//    for (int i = 0 ; i < count; i ++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [self.array addObject:attr];
//    }
    
    
            for (int i = 0 ; i < count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
                [self.array addObject:attr];
            }

}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.array;

}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columCount - 1) * self.columMargin) / self.columCount;

    
    
   __block NSInteger destColum = 0 ;// -----> 目标列
    
    //找出最短的那列
    __block CGFloat minColumHeight = MAXFLOAT;
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull columHeight, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (columHeight.doubleValue < minColumHeight) {
            minColumHeight = columHeight.doubleValue;
            destColum = idx;
        }
    }];

    CGFloat x = self.edgeInsets.left + destColum *(w + self.columMargin);
    CGFloat y = minColumHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    CGFloat h = [self.delegate waterlayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    attr.frame = CGRectMake(x, y, w, h);
    
    // --->更新最短列的高度
    self.columnHeights[destColum] = @(CGRectGetMaxY(attr.frame));
  
    return attr;    
   
}

-(CGSize)collectionViewContentSize{

    
    
    __block NSInteger destColum = 0 ;// -----> 目标列
    
    //找出最短的那列
    __block CGFloat maxColumHeight = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull columHeight, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (columHeight.doubleValue > maxColumHeight) {
            maxColumHeight = columHeight.doubleValue;
            destColum = idx;
        }
    }];
    
    return CGSizeMake(0, maxColumHeight + self.edgeInsets.bottom);
}


@end
