//
//  XWCountryCodeController.m
//  XWCountryCodeDemo
//
//  Created by 邱学伟 on 16/4/19.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWCountryCodeController.h"


@interface CountryCodeHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) UILabel *headerLabel;

@end

@implementation CountryCodeHeader

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup {

    // Initialization code
    self.backgroundColor = kUIColorFromRGB(0xF0F0F0);
    self.contentView.backgroundColor = kUIColorFromRGB(0xF0F0F0);

    self.headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH, 24)];
    [self addSubview:self.headerLabel];
    self.headerLabel.font = kSysFont(15.0);
    self.headerLabel.textColor = kUIColorFromRGB(0xC0905D);
}

@end


//判断系统语言
#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
#define LanguageIsEnglish ([CURR_LANG isEqualToString:@"en-US"] || [CURR_LANG isEqualToString:@"en-CA"] || [CURR_LANG isEqualToString:@"en-GB"] || [CURR_LANG isEqualToString:@"en-CN"] || [CURR_LANG isEqualToString:@"en"])

@interface XWCountryCodeController () <UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating> {
    UITableView *_tableView;
    UISearchController *_searchController;
    NSDictionary *_sortedNameDict;
    NSArray *_indexArray;
    NSMutableArray *_results;
}
@end

@implementation XWCountryCodeController

#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择国家";
    [self creatSubviews];
}

#pragma mark - private
 //创建子视图
- (void)creatSubviews{
    _results = [NSMutableArray arrayWithCapacity:1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44.0;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tableView.sectionIndexColor = kUIColorFromRGB(0xC0905D);
    [_tableView registerClass:[CountryCodeHeader class] forHeaderFooterViewReuseIdentifier:@"CountryCodeHeader"];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, _searchController.searchBar.bounds.size.height)];
    [headerView addSubview:_searchController.searchBar];
    _tableView.tableHeaderView = headerView;
    _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;

    
//    //判断当前系统语言
//    if (LanguageIsEnglish) {
//        NSString *plistPathEN = [[NSBundle mainBundle] pathForResource:@"sortedNameEN" ofType:@"plist"];
//        _sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathEN];
//    } else {
        NSString *plistPathCH = [[NSBundle mainBundle] pathForResource:@"sortedNameCH" ofType:@"plist"];
        _sortedNameDict = [[NSDictionary alloc] initWithContentsOfFile:plistPathCH];
//    }
    
    _indexArray = [[NSArray alloc] initWithArray:[[_sortedNameDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }]];
}

- (NSString *)showCodeStringIndex:(NSIndexPath *)indexPath {
    NSString *showCodeSting;
    if (_searchController.isActive) {
        if (_results.count > indexPath.row) {
            showCodeSting = [_results objectAtIndex:indexPath.row];
        }
    } else {
        if (_indexArray.count > indexPath.section) {
            NSArray *sectionArray = [_sortedNameDict valueForKey:[_indexArray objectAtIndex:indexPath.section]];
            if (sectionArray.count > indexPath.row) {
                showCodeSting = [sectionArray objectAtIndex:indexPath.row];
            }
        }
    }
    
    return showCodeSting;
}

- (void)selectCodeIndex:(NSIndexPath *)indexPath {
    
    NSString * originText = [self showCodeStringIndex:indexPath];
    NSArray  * array = [originText componentsSeparatedByString:@"+"];
    NSString * countryName = [array.firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * code = array.lastObject;
    
    if (self.deleagete && [self.deleagete respondsToSelector:@selector(returnCountryName:code:)]) {
        [self.deleagete returnCountryName:countryName code:code];
    }
    
    if (self.returnCountryCodeBlock != nil) {
        self.returnCountryCodeBlock(countryName,code);
    }
    
    _searchController.active = NO;
    [_searchController.searchBar resignFirstResponder];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    NSLog(@"选择国家: %@   代码: %@",countryName,code);
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (_results.count > 0) {
        [_results removeAllObjects];
    }
    NSString *inputText = searchController.searchBar.text;
    __weak __typeof(self)weakSelf = self;
    [_sortedNameDict.allValues enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj containsString:inputText]) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf->_results addObject:obj];
            }
        }];
    }];
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchController.isActive) {
        return 1;
    } else {
        return [_sortedNameDict allKeys].count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.isActive) {
         return [_results count];
    } else {
        if (_indexArray.count > section) {
            NSArray *array = [_sortedNameDict objectForKey:[_indexArray objectAtIndex:section]];
            return array.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [self showCodeStringIndex:indexPath];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _indexArray;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == _tableView) {
        return index;
    } else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return 0;
        }
        return 24;
    } else {
        return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_indexArray.count && _indexArray.count > section) {
        
        CountryCodeHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CountryCodeHeader"];
        header.headerLabel.text = [_indexArray objectAtIndex:section];
        return header;
    }
    return nil;
}

#pragma mark - 选择国际获取代码
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCodeIndex:indexPath];
}

@end
