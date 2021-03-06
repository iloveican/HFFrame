//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"
@implementation CycleScrollView
@synthesize delegate;
@synthesize scrollView;
@synthesize imagesArray;               // 存放所有需要滚动的图片 UIImage
@synthesize curImages;
@synthesize curImageView;
@synthesize timer;
NSTimeInterval timeinterval;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSMutableArray *)pictureArray TimeInterval:(NSTimeInterval)timeInterval
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSMutableArray alloc] initWithArray:pictureArray];
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动 
        if(scrollDirection == CycleDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        if (timeInterval>0 && !timer)
		{
			self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateScrollWithTimer:) userInfo:nil repeats:YES];
			NSRunLoop *main=[NSRunLoop currentRunLoop];
			[main addTimer:timer forMode:NSRunLoopCommonModes];
		}
        [self addSubview:scrollView];
        [self refreshScrollView];
    }
    
    return self;
}


- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction picturesUrl:(NSMutableArray *)pictureArrayUrl  TimeInterval:(NSTimeInterval)timeInterval
{
   manager = [[SDWebImageManager alloc]init];
    
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = pictureArrayUrl.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        
        imagesArray = [[NSMutableArray alloc]init];

        for (int i=0; i<totalPage;i++)
        {
            [imagesArray addObject:[UIImage imageNamed:@"default"]];
        }
        
        for (int i=0; i<totalPage; i++)
        {
            [manager downloadWithURL:[NSURL URLWithString:[pictureArrayUrl objectAtIndex:i]]  delegate:self options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached)
             {
                 if (cached)
                 {
                 }
                 [imagesArray replaceObjectAtIndex:i withObject:image];
                 [self refreshScrollView];
             }
            failure:^(NSError *error)
             {
                 NSLog(@"%d error %@",i,[error localizedDescription]);
             }
             ];
        }
                
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动
        if(scrollDirection == CycleDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        if (timeInterval>0 && !timer)
		{
            timeinterval = timeInterval;
			self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateScrollWithTimer:) userInfo:nil repeats:YES];
			NSRunLoop *main=[NSRunLoop currentRunLoop];
			[main addTimer:timer forMode:NSRunLoopCommonModes];
		}
        [self addSubview:scrollView];
        [self refreshScrollView];
    }

    return self;
}


-(void)removeFromSuperview
{
    [self.scrollView setDelegate:nil];
    [timer invalidate];
    [super removeFromSuperview];
}


-(void)updateScrollWithTimer:(id)sender
{
	 if(scrollDirection == CycleDirectionLandscape)
	 { 
		 [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x+scrollView.width,self.scrollView.contentOffset.y) animated:YES];
	}
	else
	{
		[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,self.scrollView.contentOffset.y+scrollView.height)  animated:YES];
	}
}

- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        imageView.image = [curImages objectAtIndex:i];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
        [singleTap release];
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        }
        [scrollView addSubview:imageView];
        [imageView release];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSMutableArray *)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (  timer ) {
        [timer invalidate];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate && timer )
    {
        timer = nil;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:timeinterval target:self selector:@selector(updateScrollWithTimer:) userInfo:nil repeats:YES];
        NSRunLoop *main=[NSRunLoop currentRunLoop];
        [main addTimer:timer forMode:NSRunLoopCommonModes];
    }
};

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    NSLog(@"did  x=%d  y=%d", x, y);
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)] )
     {
        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
      }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    NSLog(@"--end  x=%d  y=%d", x, y);
    
    if (scrollDirection == CycleDirectionLandscape) {
            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}


- (void)dealloc
{
	if (timer)
	{
        [timer invalidate];
		RELEASE_SAFELY(timer);
	}
    [manager release];
    RELEASE_SAFELY(imagesArray);
    RELEASE_SAFELY(curImages);
    RELEASE_SAFELY(scrollView);
    RELEASE_SAFELY(curImageView);
    [super dealloc];
}

@end
