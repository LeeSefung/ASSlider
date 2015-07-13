//
//  ViewController.m
//  ASSlider
//
//  Created by rimi on 15/7/13.
//  Copyright (c) 2015年 LeeSefung. All rights reserved.
//  https://github.com/LeeSefung/ASSlider.git
//

#import "ViewController.h"
#import "ASValueTrackingSlider.h"

@interface ViewController () <ASValueTrackingSliderDataSource>

@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider1;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider2;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider3;

@property (weak, nonatomic) IBOutlet UISwitch *animateSwitch;
@end

@implementation ViewController

{
    NSArray *_sliders;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // customize slider 1
    //设置进度条最大值
    self.slider1.maximumValue = 255.0;
    //设置进度条提示框幅度
    self.slider1.popUpViewCornerRadius = 0.0;
    //设置提示数字的小数位数，此处设为正数，即设为0
    [self.slider1 setMaxFractionDigitsDisplayed:0];
    //设置进度条左侧颜色
    self.slider1.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    //设置进度条提示框字体大小
    self.slider1.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    //设置进度条提示字体颜色
    self.slider1.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    
    
    // customize slider 2
    //设置进度条提示数值为百分比样式（NSNumberFormatterPercentStyle）
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [self.slider2 setNumberFormatter:formatter];
    //设置进度条提示框字体大小
    self.slider2.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26];
    //设置进度条为动态色，即根据进度条的进度显示对应的颜色
    self.slider2.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
    
    
    // customize slider 3
    //设置进度条提示数值为温度类型
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"°C"];
    [tempFormatter setNegativeSuffix:@"°C"];
    //设置代理，一边当数值达到一定条件后显示其他的提示信息（如此处为文字而非温度数值）
    self.slider3.dataSource = self;
    [self.slider3 setNumberFormatter:tempFormatter];
    //设置数值范围
    self.slider3.minimumValue = -20.0;
    self.slider3.maximumValue = 60.0;
    //设置进度条提示框幅度
    self.slider3.popUpViewCornerRadius = 16.0;
    //设置进度条提示框字体大小
    self.slider3.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    self.slider3.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //设置进度条为动态色，即根据进度条的进度显示对应的颜色
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    [self.slider3 setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
                               withPositions:@[@-20, @0, @5, @25, @60]];
    
    //存放进度条数组
    _sliders = @[_slider1, _slider2, _slider3];
}

#pragma mark - ASValueTrackingSliderDataSource
//温度进度条的代理方法，用于修改进度条的显示值
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    //获取进度条的数值
    value = roundf(value);
    NSString *s;
    //修改进度条提示文字的数值
    if (value < -10.0) {
        s = @"❄️Brrr!⛄️";
    } else if (value > 29.0 && value < 50.0) {
        s = [NSString stringWithFormat:@"😎 %@ 😎", [slider.numberFormatter stringFromNumber:@(value)]];
    } else if (value >= 50.0) {
        s = @"I’m Melting!";
    }
    return s;
}

#pragma mark - IBActions

//导航栏Show PopUps点击事件，用于显示与影藏进度条的进度提示信息
- (IBAction)toggleShowHide:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //遍历进度条数组
    for (ASValueTrackingSlider *slider in _sliders) {
        sender.selected ? [slider showPopUpView] : [slider hidePopUpView];
    }
}

//导航栏按钮Min点击事件，移动进度条到最小值
- (IBAction)moveSlidersToMinimum:(UIButton *)sender
{
    //遍历进度条数组
    for (ASValueTrackingSlider *slider in _sliders) {
        //进度条Min/Max事件动画效果受动画开关控制Animate slider min/max movement
        if (self.animateSwitch.on) {
            [self animateSlider:slider toValue:slider.minimumValue];
        }
        else {
            slider.value = slider.minimumValue;
        }
    }
}

//导航栏按钮Max点击事件，移动进度条到最大值
- (IBAction)moveSlidersToMaximum:(UIButton *)sender
{
    //遍历进度条数组
    for (ASValueTrackingSlider *slider in _sliders) {
        //进度条Min/Max事件动画效果受动画开关控制Animate slider min/max movement
        if (self.animateSwitch.on) {
            [self animateSlider:slider toValue:slider.maximumValue];
        }
        else {
            slider.value = slider.maximumValue;
        }
    }
}

// the behaviour of setValue:animated: is different between iOS6 and iOS7
// need to use animation block on iOS7
//设置动画时间（Min/Max动画时间）
- (void)animateSlider:(ASValueTrackingSlider*)slider toValue:(float)value
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [UIView animateWithDuration:0.5 animations:^{
            [slider setValue:value animated:YES];
        }];
    }
    else {
        [slider setValue:value animated:YES];
    }
}

@end
