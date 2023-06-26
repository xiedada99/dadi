//
//  HNTHomeController.m
//  demo
//
//  Created by 东哥 on 2022/4/19.
//

#import "HNTHomeController.h"
#import "HNTHomeHeaderView.h"
#import "HNTHomeCell.h"
#import "HNTDetailsTabController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface HNTHomeController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,strong)UITableView         *tabView;

@property (nonatomic ,strong)NSDecimalNumber    *nonceEarnings;

@property (nonatomic ,strong)NSDecimalNumber    *yesEarnings;

@property (nonatomic ,strong)NSArray            *listAccount;


@end

@implementation HNTHomeController


- (UITableView *)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStyleGrouped];
        [_tabView registerNib:[UINib nibWithNibName:@"HNTHomeCell" bundle:nil] forCellReuseIdentifier:@"HNTHomeCell"];
        [_tabView registerNib:[UINib nibWithNibName:@"HNTHomeHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HNTHomeHeaderView"];
        _tabView.delegate = self;
        _tabView.dataSource = self;
    }
    return _tabView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"首页";
    [self.contentView addSubview:self.tabView];
    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    self.rightButton.hidden = NO;
    self.backButton.hidden = NO;
    [self.backButton setImage:nil forState:UIControlStateNormal];
    
    NSTimer *temTimer = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:temTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_listAccount || _listAccount.count < 2 ) {
        [self loadData];
    }
}




- (void)loadData
{
    
    __weak typeof(self) weakself = self;
    
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载";
    
    [HNTTool getAccountsInfoWithAccountArr:[self walletAddCompanyArr] progress:^(CGFloat progress) {
        
    }  FinishedInfo:^(NSArray * _Nonnull obj) {
        weakself.listAccount = obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tabView reloadData];
            [hud hideAnimated:YES];
            
            NSDictionary *dic = [HNTTool getSumAmountWithListAccount:obj];
            NSString *totalAmount = [NSString stringWithFormat:@"  %@",dic[@"totalAmount"]];
            
            weakself.rightButton.titleLabel.text = totalAmount;
            [weakself.rightButton setTitle:totalAmount forState:UIControlStateNormal];
                
            NSString *offNum = [NSString stringWithFormat:@"  离线：%@",dic[@"offNumber"]];
            weakself.backButton.titleLabel.text = offNum;
            [weakself.backButton setTitle:offNum forState:UIControlStateNormal];
            
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.listAccount.count > 0) {
        HNTAccountModel *model = self.listAccount[section];
        return model.listHotspot.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listAccount.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  56;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00006;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

return nil;

}

-(HNTHomeCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNTHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNTHomeCell" forIndexPath:indexPath];
    HNTAccountModel *model = self.listAccount[indexPath.section];
    
    cell.hotspotModel = model.listHotspot[indexPath.row];


    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HNTHomeHeaderView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HNTHomeHeaderView"];
    [head.backgroundView setBackgroundColor:UIColor.whiteColor];
    head.indexNumbet = section;
    head.infoModel = self.listAccount[section];
    
    return head;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    NSString *idfaStr = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    
                    UIPasteboard *board = [UIPasteboard generalPasteboard];
                    board.string = idfaStr;
                    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"复制成功"];
                }
            }];

//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    HNTDetailsTabController* dvc = [[HNTDetailsTabController alloc]init];
//    dvc.accountArr = self.listAccount ;
//    dvc.totalAmount = self.nonceEarnings;
//    [self.navigationController pushViewController:dvc animated:YES];
}


-(NSArray *)walletAddCompanyArr{
    
    return @[@"134sutgJA9DbRzYWecBYvtnrrov91MREJs7MkPUEGiHUCEJwVfE",
             @"135v1Xea1sZC2EMTZZVNexCbS3fhvcy81gM3p87c3LmyaCvQt6e",
             @"14QRh3cUVNpBp43ZwRhx1VC4t6U14F46UBTAR5tXkGCQVkMihKB",
             @"14WaivUi3SKimVK4cySxsEYax6ToQdF9396JVAhHvhs5oc99mqb",
             @"14XW3HRNDbHXCeDU7yxkhw1amfNE6pFB6QCsHGW2bh4bcWcyYdR"];
    
}


- (NSArray *)hotspotCompanyArr{
    
    return @[@"1129X3jcF14Jcoy7Np6pmoqBLrmVLg8iM7sxfruyuDHpjeNUru11",
             @"11eGZDP7xTkPyjizwg3jDh8J4q4NZefj47fmAFcTn78KQS6ciZ5",
             @"1183So5oXKktx56Zisz622vN7ZnR85uixRWrjmVesrLxY6aLJ5j",
             @"1129pcgg68th1vXUjCuAEhScchBbTVpRXwQRhGX5zdomXtXmMURD",
             @"112mHhUB3bv3P2QjDz6HVc5Mj4a6gszhpMzyoaW168pnnQNZY8qz",
             @"11269BErAcZUERARVDjCBAHtteM3X7Edb3wTnXbwUtgN8KXtxHwM",
             @"112nF9WA7ozMPnRHxLZzfvtxP1dHoWw5gmroqPJTR4wCdD5R9gpS",
             @"11K9R4FtZKE7Qzg36Xr7St3Prz1WHLsVN5iDneu1FKnBt2Js2Fj"];
    
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
