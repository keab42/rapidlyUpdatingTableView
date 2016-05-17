//
//  ViewController.m
//  RapidlyUpdatingTableTest
//
//  Created by Matthew Keable on 07/05/2016.
//  Copyright © 2016 Matthew Keable. All rights reserved.
//

#import "ViewController.h"
#import "ConversationListTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *section1Slider;
@property (weak, nonatomic) IBOutlet UILabel *section1ValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *section2Slider;
@property (weak, nonatomic) IBOutlet UILabel *section2ValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *numberUpdatesSlider;
@property (weak, nonatomic) IBOutlet UILabel *numberUpdatesValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.section1Slider.value = 0;
    self.section1ValueLabel.text = @"0";
    self.section2Slider.value = 0;
    self.section2ValueLabel.text = @"0";
    self.numberUpdatesSlider.value = 0;
    self.numberUpdatesValueLabel.text = @"0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)section1SliderValueChanged:(id)sender {
    int roundedVal = round(self.section1Slider.value);
    self.section1ValueLabel.text = [NSString stringWithFormat:@"%d",roundedVal];
    self.section1Slider.value = roundedVal;
}

- (IBAction)section2SliderValueChanged:(id)sender {
    int roundedVal = round(self.section2Slider.value);
    self.section2ValueLabel.text = [NSString stringWithFormat:@"%d",roundedVal];
    self.section2Slider.value = roundedVal;
}

- (IBAction)updatesSliderValueChanged:(id)sender {
    int roundedVal = round(self.numberUpdatesSlider.value);
    self.numberUpdatesValueLabel.text = [NSString stringWithFormat:@"%d",roundedVal];
    self.numberUpdatesSlider.value = roundedVal;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainToTableSegue"]) {
        NSArray *sectionData = @[@(_section1Slider.value), @(_section2Slider.value)];
        ConversationListTableViewController *dest = (ConversationListTableViewController *)segue.destinationViewController;
        //Set the information we need
        [dest generateMessagesInSections:sectionData];
        dest.updatesPerMinute = @(self.numberUpdatesSlider.value);
    }
}

@end
