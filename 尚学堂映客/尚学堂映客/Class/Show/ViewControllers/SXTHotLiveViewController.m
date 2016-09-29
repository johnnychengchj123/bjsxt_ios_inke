//
//  SXTHotLiveViewController.m
//  尚学堂映客
//
//  Created by 大欢 on 16/8/22.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTHotLiveViewController.h"
#import "SXTHotLiveHandler.h"
#import "SXTHotLiveCell.h"
#import "SXTPlayerViewController.h"
#import "SXTLiveChatViewController.h"
#import "AppDelegate.h"

static NSString * identifier = @"SXTHotLiveCell";
int _lastPosition;    //A variable define in headfile

@interface SXTHotLiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation SXTHotLiveViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SXTHotLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.live = self.dataList[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70 + self.view.bounds.size.width + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SXTPlayerViewController * playerVC = [[SXTPlayerViewController alloc] init];
    
    playerVC.live = self.dataList[indexPath.row];

    [self.navigationController pushViewController:playerVC animated:YES];
    
    
    /*
     
     系统自带的播放器解码能力不够，播放不了直播
    
    SXTLive * live = self.dataList[indexPath.row];
    
    MPMoviePlayerViewController * mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:live.streamAddr]];

    [self.tabBarController presentViewController:mp animated:YES completion:nil];
    */

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
    
}

- (void)initUI {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SXTHotLiveCell" bundle:nil] forCellReuseIdentifier:identifier];
    
}

- (void)loadData {
    
    [SXTHotLiveHandler executeGetHotLiveTaskWithPage:0 success:^(id obj) {
        [self.dataList addObjectsFromArray:obj];
        [self.tableView reloadData];
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
}



//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//
//    UIWindow * window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
//    window.rootViewController.hidesBottomBarWhenPushed = YES;
//
//    
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"开始滚动");
    int currentPostion = scrollView.contentOffset.y;
    
    if (currentPostion - _lastPosition > 20  && currentPostion >0) {
        
        _lastPosition = currentPostion;
        
        NSLog(@"ScrollUp now");
        
        self.tabBarController.tabBar.hidden =YES;
        
//        [self.navigationControllersetNavigationBarHidden:YESanimated:YES];
        
    }
    else if ((_lastPosition - currentPostion >20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) )
    {
        
        _lastPosition = currentPostion;
        
        NSLog(@"ScrollDown now");
        
        self.tabBarController.tabBar.hidden =NO;//隐藏时，没有动画效果
//        [self.navigationControllersetNavigationBarHidden:NOanimated:YES];
        
    }
}



- (NSMutableArray *)dataList {
    
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
