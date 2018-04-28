//
//  ViewController.m
//  通讯录
//
//  Created by 李荣建 on 2018/4/28.
//  Copyright © 2018年 bool. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *mytableView;
@property (nonatomic,strong) UITableView *listtableView;
@property (nonatomic,strong) NSMutableArray *dataSourceMuArr;

@property (nonatomic,strong) NSMutableArray *carArr;
@property (nonatomic,copy) NSString *initial;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic,strong) NSMutableArray *sessonArr;
@property (nonatomic,strong) NSIndexPath *lastIndexpath;
@property (nonatomic,assign) BOOL isClick;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self commonInit];
    
    [self setupUI];
    [self setupLayout];
    [self loadData];
}


-(void)commonInit{
    self.navigationItem.title = @"车辆列表";
    self.isClick = NO;
}
-(void)loadData{
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 130) {
        return 15;
    }else{
        return 0;
    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 130) {
        UILabel  *labe = [UILabel new];
        
        labe.text = self.sessonArr[section];
        
        
        return labe;
    }else{
        return nil;
    }
    
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 130) {
        return self.sessonArr.count;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 130) {
        NSMutableArray *arr = self.dataSourceMuArr[section];
        return arr.count;
    }else{
        return self.sessonArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 130) {
        return 40;
    }else{
        CGFloat height = 0.025*[[UIScreen mainScreen] bounds].size.height;
        return height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 130) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OBDCarBrandTableViewCell" forIndexPath:indexPath];
        NSMutableArray *arr = self.dataSourceMuArr[indexPath.section];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    cell.hiddenLineView = NO;
        
        
        //    if ([checkValue(cell.model.order_State) isEqualToString:@"3"]) {
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    }else{
        //        cell.selectionStyle =  UITableViewCellSelectionStyleDefault;
        //    }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        NSString *str = self.sessonArr[indexPath.row];
        cell.textLabel.text = str;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 130) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       
    }else{
        self.isClick = YES;
        
        UITableViewCell *lastcell = [tableView cellForRowAtIndexPath:self.lastIndexpath];
        lastcell.textLabel.textColor = [UIColor blueColor];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor redColor];
        NSIndexPath *scrollPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [self.mytableView scrollToRowAtIndexPath:scrollPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        self.lastIndexpath = indexPath;
        
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self selectCell:scrollView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isClick = NO;
    
}

//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//
//    [self selectCell:scrollView];
//}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!self.isClick) {
        [self selectCell:scrollView];
    }
    
}

-(void)selectCell:(UIScrollView *)scrollView{
    if (scrollView == self.listtableView) {
        
        return;
        
    }
    
    //取出当前显示的最顶部的cell的indexpath
    
    NSIndexPath *topIndexPath = [[self.mytableView indexPathsForVisibleRows]firstObject];
    
    NSIndexPath *moveIndexPath = [NSIndexPath indexPathForRow:topIndexPath.section inSection:0];
    
    //选中左边的cell
    [self.listtableView selectRowAtIndexPath:moveIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    UITableViewCell *lastcell = [self.listtableView cellForRowAtIndexPath:self.lastIndexpath];
    lastcell.textLabel.textColor = [UIColor blueColor];
    UITableViewCell *cell = [self.listtableView cellForRowAtIndexPath:moveIndexPath];
    cell.textLabel.textColor = [UIColor redColor];
    self.lastIndexpath = moveIndexPath;
}
-(void)setupUI{
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,17,17)];
    [rightButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = rightItem;
    [self.view addSubview:self.mytableView];
    [self.view addSubview:self.listtableView];
}
-(void)setupLayout{

}
-(UITableView *)mytableView{
    if (!_mytableView) {
        _mytableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
       
        [_mytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OBDCarBrandTableViewCell"];
        _mytableView.backgroundColor = [UIColor whiteColor];
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mytableView.tag = 130;
        
        //        _mytableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        //        _mytableView.showsVerticalScrollIndicator = NO;
        //        _mytableView.showsHorizontalScrollIndicator = NO;
        //        _mytableView.bounces = NO;
        //        _mytableView.scrollEnabled = NO;
    }
    return _mytableView;
}
-(UITableView *)listtableView{
    if (!_listtableView) {
        _listtableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _listtableView.frame = CGRectMake(200, 100, 40, 500);
        [_listtableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _listtableView.backgroundColor = [UIColor clearColor];
        _listtableView.delegate = self;
        _listtableView.dataSource = self;
        _listtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listtableView.tag = 131;
        //        _mytableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        //        _mytableView.showsVerticalScrollIndicator = NO;
        //        _mytableView.showsHorizontalScrollIndicator = NO;
        //        _mytableView.bounces = NO;
        //        _mytableView.scrollEnabled = NO;
    }
    return _listtableView;
}
-(NSMutableArray *)dataSourceMuArr{
    if (_dataSourceMuArr == nil) {
        _dataSourceMuArr = [NSMutableArray array];
    }
    return _dataSourceMuArr;
}
-(NSMutableArray *)sessonArr{
    if (_sessonArr == nil) {
        _sessonArr = [NSMutableArray array];
    }
    return _sessonArr;
}
-(NSMutableArray *)carArr{
    if (_carArr == nil) {
        _carArr = [NSMutableArray array];
    }
    return _carArr;
}
-(NSMutableArray *)listArr{
    if (_listArr == nil) {
        
        NSString *str= @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
        for (int i=0;i<26;i++){
            _listArr = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@" "]];
        }
    }
    return _listArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
