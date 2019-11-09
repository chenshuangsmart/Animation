//
//  ViewController.m
//  AnimationIO_12
//
//  Created by chenshuang on 2019/10/31.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "ViewController.h"

static CGFloat kMagin = 10.f;

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CALayerDelegate>
@property (nonatomic, copy) NSArray *imagePaths;
@property (nonatomic, strong) UICollectionView *collectionView;
/** imgView */
@property(nonatomic, strong)UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *imgPath1 = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"jpg"];
    NSString *imgPath3 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"];
    NSString *imgPath4 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"jpg"];
    NSString *imgPath5 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"jpeg"];
    NSString *imgPath7 = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"jpeg"];
    self.imagePaths = @[imgPath1, imgPath3, imgPath4, imgPath5, imgPath7];
    
//    [self.view addSubview:self.collectionView];
    
    // 从PNG遮罩和JPEG创建的混合图片
    [self mixColor];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagePaths count];
}

/**
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // add image view
    const NSInteger imageTag = 99;
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:imageTag];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame: cell.contentView.bounds];
        imgView.tag = imageTag;
        [cell.contentView addSubview:imgView];
    }
    
    // 第一种 set image
//    NSString *imgPath = self.imagePaths[indexPath.row];
//    imgView.image = [UIImage imageWithContentsOfFile:imgPath];
//    return cell;
    
    // 第二种 使用GCD加载传送图片
    // tag cell with index and clear current image
    cell.tag = indexPath.row;
    imgView.image = nil;
    
    // switch to background thread
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // load image
//        NSInteger index = indexPath.row;
//        NSString *imgPath = self.imagePaths[index];
//        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
//        // set image on main thread, but only if index still matches up
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (index == cell.tag) {
//                imgView.image = img;
//            }
//        });
//    });
//    return cell;
    
    // 第三种方式就是绕过UIKit，像下面这样使用ImageIO框架
//    NSInteger index  = indexPath.row;
//    NSURL *imgUrl = [NSURL fileURLWithPath:self.imagePaths[index]];
//    NSDictionary *options = @{(__bridge id)kCGImageSourceShouldCache : @(YES)};
//    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)imgUrl, NULL);
//    CGImageRef imgRef = CGImageSourceCreateImageAtIndex(source, 0, (__bridge CFDictionaryRef)options);
//    UIImage *img = [UIImage imageWithCGImage:imgRef];
//    CGImageRelease(imgRef);
//    CFRelease(source);
//    imgView.image = img;
//    return cell;
    
    // 第四种 强制图片解压显示
    // switch to background thread
    CGRect bounds = imgView.bounds;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // load image
        NSInteger index = indexPath.row;
        NSString *imgPath = self.imagePaths[index];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        
        // redraw img using device context
        UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0);
        [img drawInRect:bounds];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // set image on main thread, buy only if index still matches up
        dispatch_async(dispatch_get_main_queue(), ^{
            if (index == cell.tag) {
                imgView.image = img;
            }
        });
    });
    return cell;
}
 */

/// 第五种 使用CATiledLayer的图片传送器
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // dequeue cell
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//
//    // add the tiled layer
//    CATiledLayer *tileLayer = [cell.contentView.layer.sublayers lastObject];
//    if (!tileLayer) {
//        tileLayer = [CATiledLayer layer];
//        tileLayer.frame = cell.bounds;
//        tileLayer.contentsScale = [UIScreen mainScreen].scale;
//        tileLayer.tileSize = CGSizeMake(cell.bounds.size.width * [UIScreen mainScreen].scale, cell.bounds.size.height * [UIScreen mainScreen].scale);
//        tileLayer.delegate = self;
//        [tileLayer setValue:@(indexPath.row) forKey:@"index"];
//        [cell.contentView.layer addSublayer:tileLayer];
//    }
//    // tag the layer with the correct index and reload
//    tileLayer.contents = nil;
//    [tileLayer setValue:@(indexPath.row) forKey:@"index"];
//    [tileLayer setNeedsDisplay];
//    return cell;
//}

/// 第六种 添加cache缓存
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    // add image view
    UIImageView *imgView = [cell.contentView.subviews lastObject];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgView];
    }
    // set or load img for this index
    imgView.image = [self loadImageAtIndex:indexPath.item];
    
    // preload image for previous and next index
    if (indexPath.item < self.imagePaths.count - 1) {
        [self loadImageAtIndex:indexPath.item + 1];
    }
    if (indexPath.item > 0) {
        [self loadImageAtIndex:indexPath.item - 1];
    }
    
    return cell;
}

- (UIImage *)loadImageAtIndex:(NSUInteger)index {
    // set up cache
    static NSCache *cache = nil;
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
    
    // if already cached, return immediately
    UIImage *img = [cache objectForKey:@(index)];
    if (img) {
        return [img isKindOfClass:[NSNull class]] ? nil : img;
    }
    
    // set placeholder to avoid reloading image multiple times
    [cache setObject:[NSNull null] forKey:@(index)];
    
    // switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // load image
        NSString *imgPath = self.imagePaths[index];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        
        // redraw image using device context
        UIGraphicsBeginImageContextWithOptions(img.size, YES, 0);
        [img drawAtPoint:CGPointZero];
        UIGraphicsEndImageContext();
        
        // set image for correct image view
        // cache the image
        dispatch_async(dispatch_get_main_queue(), ^{
            [cache setObject:img forKey:@(index)];
            // display the image
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imgView = [cell.contentView.subviews lastObject];
            imgView.image = img;
        });
    });
    // not loaded yet
    return nil;
}

#pragma mark - CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    // get image index
    NSInteger index = [[layer valueForKey:@"index"] integerValue];
    
    // load tile image
    NSString *imgPath = self.imagePaths[index];
    UIImage *tileImg = [UIImage imageWithContentsOfFile:imgPath];
    
    // calculate img rect
    CGFloat aspectRatio = tileImg.size.height / tileImg.size.width;
    CGRect imgRect = CGRectZero;
    imgRect.size.width = layer.bounds.size.width;
    imgRect.size.height = layer.bounds.size.height * aspectRatio;
    imgRect.origin.y = (layer.bounds.size.height - imgRect.size.height) * 0.5;
    
    // draw tile
    UIGraphicsPushContext(ctx);
    [tileImg drawInRect:imgRect];
    UIGraphicsPopContext();
}

#pragma mark - 从PNG遮罩和JPEG创建的混合图片

- (void)mixColor {
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imgView.center = self.view.center;
    [self.view addSubview:self.imgView];
    
    // load color image
    UIImage *img = [UIImage imageNamed:@"0.jpg"];
    // load mask image
    UIImage *mask = [UIImage imageNamed:@"1.png"];
    // convert mask to correct format
    CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray();
    CGImageRef maskRef = CGImageCreateCopyWithColorSpace(mask.CGImage, graySpace);
    CGColorSpaceRelease(graySpace);
    // comine images
    CGImageRef resultRef = CGImageCreateWithMask(img.CGImage, maskRef);
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    CGImageRelease(resultRef);
    CGImageRelease(maskRef);
    // display result
    self.imgView.image = result;
    
//    self.imgView.image = [UIImage imageNamed:@"0"];
}

#pragma mark - lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (self.view.frame.size.width - 2 * kMagin);
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        //最小行间距(默认为10)
        flowLayout.minimumLineSpacing = 10;
        //最小item间距（默认为10）
        flowLayout.minimumInteritemSpacing = 10;
        //设置senction的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);
        //设置UICollectionView的滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
        flowLayout.headerReferenceSize = CGSizeMake(kMagin,0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
