//
//  RootViewController.m
//  TextMobSMSSDK
//
//  Created by 张飞 on 16/7/4.
//  Copyright © 2016年 nerv. All rights reserved.
//

#import "RootViewController.h"
#import <SMS_SDK/SMSSDK.h>


@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getVerificationCodeAction:(UIButton *)sender {
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self.phoneTextField.text];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:self.phoneTextField.text];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:self.phoneTextField.text];
    if (self.phoneTextField.text.length == 11 && (isMatch1 || isMatch2 || isMatch3)) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:+86%@",self.phoneTextField.text]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                if (!error) {
                    NSLog(@"获取验证码成功");
                } else {
                    NSLog(@"错误信息:%@",error);
                }
            }];

        }];
        UIAlertAction *clank = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:ok];
        [alertVC addAction:clank];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        } else {
        
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请正确输入手机号码"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
           
            [alertVC addAction:ok];
            [self presentViewController:alertVC animated:YES completion:nil];

        
        }
    }
    


- (IBAction)submitVerificationCode:(UIButton *)sender {
    
    [SMSSDK commitVerificationCode:self.verificationTextField.text phoneNumber:self.phoneTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交的验证码正确"  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:ok];
            [self presentViewController:alertVC animated:YES completion:nil];

        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }
    }];
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
