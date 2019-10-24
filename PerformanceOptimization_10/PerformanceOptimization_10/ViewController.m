//
//  ViewController.m
//  PerformanceOptimization_10
//
//  Created by chenshuang on 2019/10/21.
//  Copyright © 2019 chenshuang. All rights reserved.
//  性能优化

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource>
/** items */
@property(nonatomic, strong)NSArray *items;
/** tableView */
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawUI];
}

- (void)drawUI {
    [self.view addSubview:self.tableView];
}

- (NSString *)randomName {
    NSArray *first = @[@"Alice", @"Bob", @"Bill", @"Charles", @"Dan", @"Dave", @"Ethan", @"Frank"];
    NSArray *last = @[@"Appleseed", @"Bandicoot", @"Caravan", @"Dabble", @"Ernest", @"Fortune"];
    NSUInteger index1 = (rand()/(double)INT_MAX) * [first count];
    NSUInteger index2 = (rand()/(double)INT_MAX) * [last count];
    
    return [NSString stringWithFormat:@"%@ %@", first[index1], last[index2]];
}

- (NSString *)randomAvatar {
    NSArray *images = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    NSUInteger index = (rand()/(double)INT_MAX) * [images count];
    return images[index];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //dequeue cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //load image
    NSDictionary *item = self.items[indexPath.row];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:item[@"image"] ofType:@"jpeg"];
    //set image and text
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    cell.textLabel.text = item[@"name"];
    cell.textLabel.textColor = [UIColor blackColor];
    //set image shadow
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 0.75;
    
    // rasterize
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    cell.clipsToBounds = YES;
    //set text shadow
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.shadowOpacity = 0.5;
    return cell;
}

#pragma mark - lazy

- (NSArray *)items {
    if (!_items) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 1000; i++) {
            [array addObject:@{@"name": [self randomName], @"image": [self randomAvatar]}];
        }
        _items = array.copy;
    }
    return _items;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.rowHeight = 50;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
