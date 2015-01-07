//
//  TSCycleScrollView.m
//  TSCycleScrollView
//
//  Created by Tassel on 15/1/6.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import "TSCycleScrollView.h"

@interface TSCycleScrollView()<UIScrollViewDelegate>

//当前页码
@property (nonatomic,assign) NSInteger currentPage;
//总页码
@property (nonatomic,assign) NSInteger totalPages;
//页面view集合
@property (nonatomic,strong) NSMutableArray *views;
//定时器
@property (nonatomic,strong) NSTimer *animationTimer;

@end

@implementation TSCycleScrollView

- (instancetype) initWithFrame:(CGRect)frame
{
   
    self=[super initWithFrame:frame];
    if (self) {
        
        self.animationDuration = 0;
        self.direction = TSCycleScrollViewDirectionRight;
        [self initScrollView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{

    self=[super initWithCoder:aDecoder];
    if (self) {
        
        self.animationDuration = 0;
        self.direction = TSCycleScrollViewDirectionRight;
        [self initScrollView];
    }
    return self;


}

/**
 *  初始化ScrollView
 */
- (void) initScrollView
{

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 25;
    rect.size.height = 25;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.userInteractionEnabled = NO;
    
    [self addSubview:self.pageControl];
    
    self.currentPage = 0;
    
    
}

/**
 *  设置自动滚动间隔时间,以秒为单位,时间大于0
 *
 *  @param animationDuration 间隔时间
 */
- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{

    _animationDuration = animationDuration;
    
    if (animationDuration > 0.0) { //时间间隔大于0创建NSTimer
    
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:_animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
        
    }


}

- (void)setDataSource:(id<TSCycleScrollViewDataSource>)dataSource
{

    _dataSource = dataSource;
    [self reloadData];

}

/**
 *  刷新scrollView
 */

- (void)reloadData
{
 
    self.totalPages = [self.dataSource numberOfPages];
    
    if (self.totalPages == 0) {
        
        return;
    }
    
    self.pageControl.numberOfPages = self.totalPages;
    
    [self loadData];


}

/**
 *  创建View
 */
- (void)loadData
{

    self.pageControl.currentPage = self.currentPage;
    
    NSArray *subViews = [self.scrollView subviews];
   
    if ([subViews count] != 0) {
        
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayViewsWithCurrentPage:self.currentPage];
    
    /**
     *  填充ScrollView
     */
    for (NSInteger i = 0; i < 3;i++ ) {
        
        UIView *contentView = [self.views objectAtIndex:i];
        contentView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [contentView addGestureRecognizer:singelTap];
        contentView.frame = CGRectOffset(contentView.frame, CGRectGetWidth(contentView.frame) * i, 0);
        [self.scrollView addSubview:contentView];
        
        
    }
    
    /**
     *  设置ScrollView的contentSize
     *  设置offset为当前滚动到的CurrentPage页
     */
    if (self.totalPages == 1) {
        
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }else
    {
    
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) *3, CGRectGetHeight(self.bounds));
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        
    
    }


}

/**
 *  获取将要显示到的ScrollView内容
 *
 *  @param page 当前所在的页码
 */
- (void)getDisplayViewsWithCurrentPage:(NSInteger)page
{

    NSInteger prePage =  [self validPageValue:self.currentPage -1];
    NSInteger lastPage = [self validPageValue:self.currentPage +1];
    
    if (!self.views) {
        
        self.views =[[NSMutableArray alloc] initWithCapacity:0];
        
    }
    [self.views removeAllObjects];
    
    CGSize size = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    [self.views addObject:[self.dataSource pageAtIndex:prePage size:size]];
    [self.views addObject:[self.dataSource pageAtIndex:page size:size]];
    [self.views addObject:[self.dataSource pageAtIndex:lastPage size:size]];


}

- (NSInteger)validPageValue:(NSInteger)value
{

    if (value == -1) {
        
        value = self.totalPages -1;
    
    }else if (value == self.totalPages)
    {
        value = 0;
    
    }
    return value;
}


- (void)handleTap:(UITapGestureRecognizer *)tap
{

    if ([self.delegate respondsToSelector:@selector(scrollView:didClickPage:atIndex:)]) {
        
        [self.delegate scrollView:self didClickPage: tap.view atIndex:self.currentPage];
    }

    
    
}

- (void)animationTimerDidFired:(NSTimer *)timer
{

    if (self.totalPages >1) {
        
        if (self.direction == TSCycleScrollViewDirectionLeft) {
            
            NSLog(@"-------%f",self.scrollView.contentOffset.x);
            CGPoint offset = CGPointMake(self.scrollView.contentOffset.x - CGRectGetWidth(self.scrollView.frame),self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:offset animated:YES];

        }else
        {
            NSLog(@"-------%f",self.scrollView.contentOffset.x);

            CGPoint offset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame),self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:offset animated:YES];
            
        }
        
    }

   
}

#pragma mark - UIScrollViewDelegate 

-  (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    if (self.animationTimer) {
        
        [self.animationTimer setFireDate:[NSDate distantFuture]];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{


    if (self.animationTimer) {
        
        [self performSelector:@selector(timerFire) withObject:nil afterDelay:self.animationDuration];
    }

}

- (void)timerFire
{
    [self.animationTimer setFireDate:[NSDate date]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat x =scrollView.contentOffset.x;
    
    //往后翻一张
    if (x >= (2*CGRectGetWidth(self.scrollView.frame))) {
        
        self.currentPage =[self validPageValue:self.currentPage +1];
        [self loadData];
    }
    
    if (x <=0) {
        
        self.currentPage = [self validPageValue:self.currentPage -1];
        [self loadData];
    }


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame), 0) animated:YES];
}






@end
