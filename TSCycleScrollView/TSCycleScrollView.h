//
//  TSCycleScrollView.h
//  TSCycleScrollView
//
//  Created by Tassel on 15/1/6.
//  Copyright (c) 2015年 Tassel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSCycleScrollView;

/**
 *  滚动方向
 */

typedef NS_ENUM(NSInteger, TSCycleScrollViewDirection) {
    
    TSCycleScrollViewDirectionLeft,
    TSCycleScrollViewDirectionRight
   
};

@protocol TSCycleScrollViewDelegate <NSObject>

@optional

/**
 *  点击scrollView当前视图的View
 *
 *  @param scrollView 所在的ScrollView
 *  @param view       点击的View
 *  @param index      当前页码
 */
- (void)scrollView:(TSCycleScrollView *)scrollView didClickPage:(UIView *)view atIndex:(NSInteger)index;

@end


@protocol TSCycleScrollViewDataSource <NSObject>

/**
 *  返回的总页码
 *
 *  @return 总页码
 */
- (NSInteger)numberOfPages;


/**
 *  返回每一个页面的View
 *
 *  @param index 当前index
 *  @param size  当前页面的Size
 *
 *  @return UIView
 */
- (UIView *)pageAtIndex:(NSInteger)index size:(CGSize)size;

@end

/**
 *  循环滚动ScrollView
 *
 */
@interface TSCycleScrollView : UIView

/** UIScrollView **/
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,assign) NSTimeInterval animationDuration;

/** 滚动方向,默认为TSCycleScrollViewDirectionRight **/
@property (nonatomic,assign) TSCycleScrollViewDirection direction;

@property (nonatomic,weak,setter = setDataSource:) id<TSCycleScrollViewDataSource> dataSource;
@property (nonatomic,weak,setter = setDelegate:)   id<TSCycleScrollViewDelegate>   delegate;


/**
 *  重新加载数据
 */
- (void)reloadData;


@end
