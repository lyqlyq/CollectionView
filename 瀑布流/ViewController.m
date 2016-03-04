//
//  ViewController.m
//  瀑布流
//
//  Created by Mac on 16/3/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "XMGWaterLayout.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,XMGWaterLayoutDelegate>


/**collectionView*/
@property (nonatomic ,weak) UICollectionView *collectionView;


/**data*/
@property (nonatomic ,strong) NSMutableArray *shops;



@end

@implementation ViewController


static NSString *const XGShopID = @"shop";

-(NSMutableArray *)shops{
 
    if (_shops == nil) {
        _shops = [NSMutableArray array];
        
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpCollectionView];
    
    [self setUpRefresh];
    

}

-(void)setUpRefresh{

    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    
}

-(void)loadNewShops{
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *shop = [XMGShop shop];
        
        [self.shops removeAllObjects];
        
        [self.shops addObjectsFromArray:shop];
        
        [self.collectionView reloadData];
                
        [self.collectionView.header endRefreshing];
    });
    
}

-(void)loadMoreShops{
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shops addObjectsFromArray:[XMGShop shop]];
        
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
        
    });

}


-(void)setUpCollectionView{
    
    XMGWaterLayout *layout = [[XMGWaterLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    
    collectionView.dataSource =self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor  =[UIColor whiteColor];
    
   
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:XGShopID];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.shops.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XGShopID forIndexPath:indexPath];
    
    XMGShop *shop = self.shops[indexPath.item];
    
    cell.shop = shop;
    
    return cell;

}
-(CGFloat)waterlayout:(XMGWaterLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    
    XMGShop *shop = self.shops[index];
    
    return itemWidth * shop.h / shop.w;
}
-(CGFloat)columCountInwaterlayout:(XMGWaterLayout *)waterlayout{

    return 2;
}


@end
