//
//  TableViewController.m
//  AnimationIO_12
//
//  Created by chenshuang on 2019/11/7.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "TableViewController.h"

static NSString *kImageFolder = @"img";

@interface TableViewController ()<UITableViewDataSource>
/** imgPaths */
@property (nonatomic, copy) NSArray *imagePaths;
/** items */
@property(nonatomic, strong)NSArray *items;
/** tableView */
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation TableViewController

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
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imagePaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    // set up cell
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.detailTextLabel.text = @"Loading...";
    // load image
    [self loadImageAtIndex:indexPath.row];
    
    return cell;
}

- (void)loadImageAtIndex:(NSUInteger)index {
    // load on background thread so as not to
    // prevent the UI from updating between runs
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // setup
        NSString *fileName = self.items[index];
        NSString *pngPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png" inDirectory:kImageFolder];
        NSString *jpgPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg" inDirectory:kImageFolder];
        
        // load
        NSInteger pngTime = [self loadImageForOneSec:pngPath] * 1000;
        NSInteger jpgTime = [self loadImageForOneSec:jpgPath] * 1000;
        
        // updated UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // find table cell and update
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"PNG: %03ims JPG: %03ims", pngTime, jpgTime];
        });
    });
}

- (CFTimeInterval)loadImageForOneSec:(NSString *)path {
    // create drawing context to use for decompression
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    // start timing
    NSInteger imgLoaded = 0;
    CFTimeInterval endTime = 0;
    CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    
    while (endTime - startTime < 1) {
        // load image
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        // decompress image by drawing it
        [img drawAtPoint:CGPointZero];
        // update totals
        imgLoaded++;
        endTime = CFAbsoluteTimeGetCurrent();
    }
    // close context
    UIGraphicsEndImageContext();
    // calculate time per image
    return (endTime - startTime) / imgLoaded;
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
