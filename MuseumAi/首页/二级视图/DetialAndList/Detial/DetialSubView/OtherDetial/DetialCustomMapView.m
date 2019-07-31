//
//  DetialCustomMapView.m
//  MuseumAi
//
//  Created by 何学杰 on 2019/7/19.
//  Copyright © 2019 Weizh. All rights reserved.
//

#import "DetialCustomMapView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface DetialCustomMapView ()<BMKMapViewDelegate>

//当前界面的mapView
@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) UIButton *reduiceButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic) float zoomLevel;
@end
@implementation DetialCustomMapView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _zoomLevel = 17.0;
    _mapView = [[BMKMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    [self addSubview:_mapView];
    [_mapView setZoomLevel:_zoomLevel];
    [_mapView setShowMapPoi:YES];
    [_mapView setShowMapScaleBar:YES];
    _mapView.showsUserLocation = YES;
    
    
    _reduiceButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-38-10, self.bounds.size.height-38-30, 38, 38)];
    [self addSubview:_reduiceButton];
    [_reduiceButton setImage:[UIImage imageNamed:@"map_reduce"] forState:UIControlStateNormal];
    [_reduiceButton addTarget:self action:@selector(reduiceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-38-10 , self.bounds.size.height-38-30  -4-38, 38, 38)];
    [self addSubview:_addButton];
    [_addButton setImage:[UIImage imageNamed:@"map_add"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)reduiceButtonClick{
    _zoomLevel = _zoomLevel-0.5;
    [_mapView zoomOut];
}
- (void)addButtonClick{
    _zoomLevel = _zoomLevel+0.5;
    [_mapView zoomIn];
}

- (void)setStrTitle:(NSString *)strTitle{
    _strTitle = strTitle;
    
    [_mapView setCenterCoordinate:self.coordinate];
    
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    
    displayParam.locationViewOffsetX=0;//定位偏移量(经度)
    
    displayParam.locationViewOffsetY=0;//定位偏移量（纬度）
    
    displayParam.isAccuracyCircleShow=NO;//经度圈是否显示
    
    [_mapView updateLocationViewWithParam:displayParam];
    
    
    BMKPointAnnotation* userAnnotation = [[BMKPointAnnotation alloc]init];
    userAnnotation.coordinate = self.coordinate;
    userAnnotation.title = _strTitle;
    //    userAnnotation.subtitle = @"this is a test!this is a test!";
    
    [_mapView addAnnotation:userAnnotation];
    [_mapView selectAnnotation:userAnnotation animated:YES];
    
    BMKCoordinateRegion theRegin;
    theRegin.center = self.coordinate;
    
    BMKCoordinateSpan theSpan;
    
    theSpan.latitudeDelta = 0.1;
    theSpan.longitudeDelta = 0.1;
    theRegin.span = theSpan;
    [_mapView setRegion:theRegin];
    [_mapView regionThatFits:theRegin];
}



- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    
    CGFloat whidth =  [self calculateRowWidth:_strTitle];
    
    BMKAnnotationView *annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    annotationView.image = [UIImage imageNamed:@"pin_red"];   //把大头针换成别的图片
    
    UIView *areaPaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, whidth+20, 60)];
    
    areaPaoView.layer.contents =(id)[UIImage imageNamed:@"map_11"].CGImage;
    
    UILabel * labelNo = [[UILabel alloc]init];
    labelNo.textColor = kUIColorFromRGB(0x444444);
    labelNo.font = [UIFont systemFontOfSize:16];
    labelNo.text = _strTitle;
    //    labelNo.lineBreakMode = NSLineBreakByWordWrapping;
    labelNo.textAlignment = NSTextAlignmentCenter;
    [areaPaoView addSubview:labelNo];
    
    [labelNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.bottom.mas_equalTo(-16);
    }];
    
    [labelNo layoutIfNeeded];
    
    BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc]initWithCustomView:areaPaoView];
    annotationView.paopaoView = paopao;
    [_mapView setZoomLevel:_zoomLevel];
    return annotationView;
}

- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}


@end
