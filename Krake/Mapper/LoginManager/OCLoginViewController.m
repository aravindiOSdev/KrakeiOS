//
//  OCLoginViewController.m
//  KLoginManager
//
//  Created by Patrick on 20/02/15.
//  Copyright (c) 2015 Laser Group. All rights reserved.
//

#import "OCLoginViewController.h"
#import "NBPhoneNumberUtil.h"
#import "MBProgressHUD.h"
#import "NSString+OrchardMapping.h"
#import "OGLCoreDataMapper.h"
#import <Krake/Krake-Swift.h>
@import LaserFloatingTextField;

#define LOGIN_DOMAIN_TAG 100
#define REGISTER_DOMAIN_TAG 101
#define LOSTPASS_DOMAIN_TAG 102


@interface RegisterPolicyView ()
{
    NSDictionary *policy;
    NSMutableDictionary *responseType;
}

@property (weak, nonatomic) UIViewController *fromViewController;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchFlag;

@end

@interface OCLoginViewController () <UITextFieldDelegate, UIAdaptivePresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    id openObserver;
    id closeObserver;
    NSDictionary *mainParams;
    NSMutableDictionary *responseType;
    NSArray *policies;
    UIInterfaceOrientationMask orientationMask;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIStackView *loginMainStackView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *baseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *policiesTableHeight;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *loginWithLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerx;

@property (weak, nonatomic) IBOutlet UIStackView *socialToolbar;

@property (weak, nonatomic) IBOutlet EGFloatingTextField *username;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *password;
@property (nonatomic, strong) IBOutletCollection(EGFloatingTextField) NSArray *domains;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *lostPassword;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

//registerView
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *usernameRegistration;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *passwordRegistration;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *confirmRegistration;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *numberRegistration;
@property (weak, nonatomic) IBOutlet UIStackView *registerStackView;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRegisterView;


//LOST PASSWORD
@property (weak, nonatomic) IBOutlet UIView *lostpwdView;
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;
@property (weak, nonatomic) IBOutlet UILabel *lostPasswordLabel;
@property (weak, nonatomic) IBOutlet EGFloatingTextField *emailsmsTextField;

@end

@implementation RegisterPolicyView


- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *title = [[UILabel alloc] init];
        [title setTranslatesAutoresizingMaskIntoConstraints:false];
        title.numberOfLines = 0;
        [self addSubview:title];
        
        UILabel *subtitle = [[UILabel alloc] init];
        [subtitle setTranslatesAutoresizingMaskIntoConstraints:false];
        [subtitle setFont:[UIFont systemFontOfSize:10.0]];
        [self addSubview:subtitle];
        
        UISwitch *switcher = [[UISwitch alloc] init];
        [switcher setTranslatesAutoresizingMaskIntoConstraints:false];
        [switcher setOn: false];
        [switcher addTarget:self action:@selector(changeValueSwitcher:) forControlEvents:UIControlEventValueChanged];
        [[KTheme currentObjc] applyThemeToSwitch:switcher style:SwitchStyleLogin];
        [self addSubview:switcher];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[title]-(8)-[switcher(51)]-(0)-|" options:0 metrics:nil views:@{@"title":title, @"switcher" : switcher}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[subtitle]" options:0 metrics:nil views:@{@"subtitle":subtitle}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[title]-[subtitle]-(8)-|" options:0 metrics:nil views:@{@"title":title,@"subtitle":subtitle}]];
        [self addConstraint: [NSLayoutConstraint constraintWithItem:switcher attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        
        
        self.titleLabel = title;
        self.subtitleLabel = subtitle;
        self.switchFlag = switcher;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentPolicy)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)presentPolicy
{
    [self.fromViewController presentPolicyViewControllerWithPolicyEndPoint:nil policyTitle:self->policy[@"Title"] policyText:self->policy[@"Body"] largeMargin:false];
}

-(void)configure:(NSDictionary *)policy responseType:(NSMutableDictionary*)responseType fromViewController:(UIViewController*)vc
{
    self->policy = policy;
    self->responseType = responseType;
    self.fromViewController = vc;
    _titleLabel.text = self->policy[@"Title"];
    [[KTheme login] applyThemeToLabel:_titleLabel style:KLoginLabelStylePolicyTitle];
    [_switchFlag setOn:false];
    
    if ([self->policy[@"UserHaveToAccept"] integerValue] == 1)
        _subtitleLabel.text = Policies.required;
    else
        _subtitleLabel.text = nil;
    
    [[KTheme login] applyThemeToLabel:_subtitleLabel style:KLoginLabelStylePolicySubtitle];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)changeValueSwitcher:(UISwitch*)switcher{
    for (NSMutableDictionary *policy in responseType[@"PolicyAnswers"]) {
        if ([self->policy[@"PolicyId"] longValue] == [policy[@"PolicyId"] longValue]) {
            policy[@"PolicyAnswer"] = [NSNumber numberWithBool:switcher.on];
        }
    }
}
@end

@implementation OCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.registerButton setEnabled: false];
    
    self.closeButton.clipsToBounds = YES;
    self.closeButton.layer.cornerRadius = 22.0;
    [self.closeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    NSString * bundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"KrakeImages" ofType:@"bundle"];
    [self.closeButton setImage:[UIImage imageNamed:@"scroll_bottom" inBundle:[NSBundle bundleWithPath:bundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    
    self.backButton.clipsToBounds = YES;
    self.backButton.layer.cornerRadius = 22.0;
    [self.backButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.backButton setImage:[UIImage imageNamed:@"indietro" inBundle:[NSBundle bundleWithPath:bundlePath] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    self.backButton.alpha = 0.0;
    
    self.loginWithLabel.text = UserAccess.loginWith;
    
    if(!Login.canUserCancelLogin)
    {
        self.closeButton.hidden = true;
    }
    
    if (!Login.canUserLoginWithKrake)
    {
        [self.username setHidden:true];
        for (EGFloatingTextField *domain in self.domains)
        {
            [domain setHidden:true];
        }
        [self.password setHidden:true];
        [self.lostPassword setHidden:true];
        [self.registerButton setHidden:true];
    }
    else
    {
        [self loadRegisterData];
        
        self.username.IBPlaceholder = NSLocalizedStringWithDefaultValue(@"e_mail", nil, [NSBundle mainBundle], Commons.eMail, "");
        self.usernameRegistration.IBPlaceholder = NSLocalizedStringWithDefaultValue(@"e_mail", nil, [NSBundle mainBundle], Commons.eMail, "");
        if (Login.canUserRecoverPasswordWithSMS){
            self.emailsmsTextField.IBPlaceholder = UserAccess.placeholderSmsOrMailRestorePassword;
        }else{
            self.emailsmsTextField.IBPlaceholder = UserAccess.placeholderMailRestorePassword;
        }
        
        if (Login.domainsAccepted.count > 0){
            for (EGFloatingTextField *domain in self.domains)
            {
                domain.IBPlaceholder = NSLocalizedStringWithDefaultValue(@"domain", nil, [NSBundle mainBundle], UserAccess.domain, "");
                UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                pickerView.showsSelectionIndicator = YES;
                pickerView.dataSource = self;
                pickerView.delegate = self;
                pickerView.tag = domain.tag;
                [domain setInputView:pickerView];
                UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
                UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyBoard:)];
                [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
                domain.inputAccessoryView = toolBar;
                [domain setClearButtonMode:UITextFieldViewModeNever];
                [domain setHidden:false];
                NSString *domainString = [[NSUserDefaults standardUserDefaults] stringForConstantKey:OMStringConstantKeyDomain];
                [domain setText:[NSString stringWithFormat:@"@%@", [Login.domainsAccepted objectAtIndex:0]]];
                if (domainString.length > 0){
                    long index = [Login.domainsAccepted indexOfObject:[domainString stringByReplacingOccurrencesOfString:@"@" withString:@""]];
                    if (index != NSNotFound)
                    {
                        domain.text = domainString;
                        [pickerView selectRow:index inComponent:0 animated:false];
                    }
                }
                [[KTheme login] applyThemeTo:domain];
                [domain setTintColor:[UIColor clearColor]];
            }
            [self.username setIBPlaceholder:@"Username"];
            [self.usernameRegistration setIBPlaceholder:@"Username"];
            [self.emailsmsTextField setIBPlaceholder:@"Username"];
        }else{
            for (EGFloatingTextField *domain in self.domains)
            {
                [domain setHidden:true];
            }
        }
        self.password.IBPlaceholder = UserAccess.password;
        self.passwordRegistration.IBPlaceholder = UserAccess.password;
        self.confirmRegistration.IBPlaceholder = UserAccess.confirmPassword;
        self.numberRegistration.IBPlaceholder = UserAccess.phoneNumber;

        self.registrationLabel.text = UserAccess.registration;
        
        [self.lostPassword setTitle:UserAccess.lostPwd forState:UIControlStateNormal];
        [self.registerButton setTitle:UserAccess.registration forState:UIControlStateNormal];
        [self.loginButton setTitle:UserAccess.login forState:UIControlStateNormal];
        [self.registrationButton setTitle:UserAccess.doRegistration forState:UIControlStateNormal];

        self.lostPasswordLabel.text = UserAccess.lostPwd;
        
        if (!Login.userHaveToRegisterWithSMS){
            [self.numberRegistration setHidden:true];
        }
        [self.recoverButton setTitle:UserAccess.recoverPassword forState:UIControlStateNormal];
    }
    
    self.view.backgroundColor = [KTheme.login color:KLoginColorTypeBackground];
    self.baseView.effect = [UIBlurEffect effectWithStyle:KTheme.login.centerViewStyle];
    
    [[KTheme login] applyThemeToImageView:self.backgroundImageView];
    
    [[KTheme login] applyThemeTo:self.username];
    [[KTheme login] applyThemeTo:self.password];
    [[KTheme login] applyThemeTo:self.usernameRegistration];
    [[KTheme login] applyThemeTo:self.passwordRegistration];
    [[KTheme login] applyThemeTo:self.confirmRegistration];
    [[KTheme login] applyThemeTo:self.numberRegistration];
    [[KTheme login] applyThemeTo:self.emailsmsTextField];
    
    [[KTheme login] applyThemeTo:self.closeButton style:KLoginButtonStyleClose];
    [[KTheme login] applyThemeTo:self.backButton style:KLoginButtonStyleBack];
    
    [[KTheme login] applyThemeTo:self.lostPassword style:KLoginButtonStyleSmall];
    [[KTheme login] applyThemeTo:self.registerButton style:KLoginButtonStyleSmall];
    [[KTheme login] applyThemeTo:self.loginButton style:KLoginButtonStyleDefault];
    [[KTheme login] applyThemeTo:self.registrationButton style:KLoginButtonStyleDefault];
    [[KTheme login] applyThemeTo:self.recoverButton style:KLoginButtonStyleDefault];

    [[KTheme login] applyThemeToLabel:self.registrationLabel style:KLoginLabelStyleTitle];
    [[KTheme login] applyThemeToLabel:self.loginWithLabel style:KLoginLabelStyleTitle];
    [[KTheme login] applyThemeToLabel:self.lostPasswordLabel style:KLoginLabelStyleTitle];

    BOOL registerWithKrake = Login.canUserRegisterWithKrake;

    [self.registerButton setHidden:!registerWithKrake];
    [self.registerButton setEnabled:registerWithKrake];

    BOOL recoverPassword = Login.canUserRecoverPassword;

    [self.lostPassword setHidden:!recoverPassword];
    [self.lostPassword setEnabled:recoverPassword];
    
    NSArray<Class<KLoginProviderProtocol>> * items;
    items = [[KLoginManager shared] socials];
    for (Class<KLoginProviderProtocol> item in items) {
        UIStackView *rightStackView;
        if ([[item shared] loginStackPosition] == KLoginStackPositionVertical) {
            rightStackView = self.loginMainStackView;
        } else {
            rightStackView = self.socialToolbar;
        }
        [rightStackView addArrangedSubview:[[item shared] getLoginView]];
    }
    if ([self.socialToolbar.arrangedSubviews count] == 0 ){
        self.socialToolbar.hidden = true;
    }
    
    self.baseView.layer.cornerRadius = 10.0;
    self.baseView.clipsToBounds = true;
    
    if (@available(iOS 13.0, *)) {
        self.presentationController.delegate = self;
//        [self setModalInPresentation:true];
    }
}

-(BOOL)prefersStatusBarHidden{
    return true;
}

-(BOOL) isLightColor:(UIColor*)clr {
    CGFloat white = 0;
    [clr getWhite:&white alpha:nil];
    return (white >= 0.2);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    orientationMask = [(OGLAppDelegate*)[[UIApplication sharedApplication] delegate] lockInterfaceOrientationMask];
    [(OGLAppDelegate*)[[UIApplication sharedApplication] delegate] setLockInterfaceOrientationMask: UIInterfaceOrientationMaskPortrait];
    openObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [UIView animateWithDuration:0.3 animations:^{
            //TODO: gestire allineamento tastiera
        
            if (self.registerView.isHidden){
                for (UIView *subV in self.loginView.subviews[0].subviews){
                    if ([subV isFirstResponder]){
                        self.centerx.constant = -subV.frame.origin.y/2;
                        break;
                    }
                }
            }else{
                for (UIView *subV in self.registerView.subviews[0].subviews){
                    if ([subV isFirstResponder]){
                        self.centerx.constant = -subV.frame.origin.y/2;
                        break;
                    }
                }
            }
            [self.view layoutIfNeeded];
        }];
    }];
    
    closeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidHideNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [UIView animateWithDuration:0.3 animations:^{
            self.centerx.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }];
    
    NSString *numero = [[NSUserDefaults standardUserDefaults] stringForConstantKey:OMStringConstantKeyUserPhoneNumber];
    if (numero.length > 0)
    {
        (void)[self.numberRegistration becomeFirstResponder];
        self.numberRegistration.text = numero;
        (void)[self.numberRegistration resignFirstResponder];
    }
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForConstantKey:OMStringConstantKeyUserEmail];
    if (email.length > 0){
        (void)[self.username becomeFirstResponder];
        self.username.text = email;
        (void)[self.username resignFirstResponder];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:openObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:closeObserver];
    openObserver = nil;
    closeObserver = nil;
    
    [(OGLAppDelegate*)[[UIApplication sharedApplication] delegate] setLockInterfaceOrientationMask: orientationMask];
}

-(void)loadRegisterData{
    responseType = [[NSMutableDictionary alloc] init];
    
    [[KNetworkManager defaultManager: true checkHeaderResponse:false] policiesRegistration:^(BOOL success, id response, NSError *error) {
        if (success){
            self->policies = response;
            NSMutableArray *policyAnswers = [[NSMutableArray alloc] init];
            for (NSDictionary *policy in self->policies){
                [policyAnswers addObject: [[NSMutableDictionary alloc] initWithDictionary: @{
                                            @"PolicyId": policy[@"PolicyId"],
                                            @"UserHaveToAccept": policy[@"UserHaveToAccept"],
                                            @"PolicyAnswer": @(FALSE)
                                            }]
                 ];
            }
            self->responseType[@"PolicyAnswers"] = policyAnswers;
            [self loadPoliciesOnStackView];
        }else{
            if (error){
                [[KLoginManager shared] showMessage:error.localizedDescription withType:ModeError];
            }
        }
    }];
}

-(void)loadPoliciesOnStackView
{
    for (NSDictionary *policy in self->policies)
    {
        RegisterPolicyView *newView = [[RegisterPolicyView alloc] init];
        [newView configure:policy responseType:responseType fromViewController:self];
        [self.registerStackView insertArrangedSubview:newView atIndex:(self.registerStackView.arrangedSubviews.count-2)];
    }
}

-(IBAction)registerNewUser:(id)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NSString *number = self.numberRegistration.text;
    if (number != nil){
        if ([number hasPrefix:@"00"]) {
            number = [@"+" stringByAppendingString:[number substringFromIndex:2]];
        }
        if (![number hasPrefix:@"+"]) {
            number = [@"+39" stringByAppendingString:number];
        }
    }
    NBPhoneNumber *myNumber = [phoneUtil parseWithPhoneCarrierRegion:number error:&anError];
    if ([phoneUtil isValidNumber:myNumber] || !Login.userHaveToRegisterWithSMS) {
        NSString *nationalNumber = nil;
        NSString *countryCode = [NSString stringWithFormat:@"%@",[phoneUtil extractCountryCode:number nationalNumber:&nationalNumber]];
        nationalNumber = [nationalNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *domainText = nil;
        if(Login.domainsAccepted.count > 0)
        {
            for (EGFloatingTextField *domain in self.domains)
            {
                if (domain.tag == REGISTER_DOMAIN_TAG)
                {
                    NSString *email = [NSString stringWithFormat: @"%@%@", self.usernameRegistration.text, domain.text];
                    responseType[@"Email"] = email;
                    responseType[@"Username"] = email;
                    domainText = domain.text;
                    break;
                }
            }
        }else{
            responseType[@"Email"] = self.usernameRegistration.text;
            responseType[@"Username"] = self.usernameRegistration.text;
        }
        responseType[@"Password"] = self.passwordRegistration.text;
        responseType[@"ConfirmPassword"] = self.confirmRegistration.text;
        responseType[@"Culture"] = Core.language;
        [[KNetworkManager defaultManager:true checkHeaderResponse:true] krakeRegisterUser:responseType completion:^(BOOL success, NSDictionary * _Nullable response, NSError * _Nullable message) {
            if (success) {
                [[NSUserDefaults standardUserDefaults] setStringAndSync:self.usernameRegistration.text forConstantKey:OMStringConstantKeyUserEmail];
                [[NSUserDefaults standardUserDefaults] setStringAndSync:self.usernameRegistration.text forConstantKey:OMStringConstantKeyUserName];
                if (domainText!= nil)
                {
                [[NSUserDefaults standardUserDefaults] setStringAndSync:domainText forConstantKey:OMStringConstantKeyDomain];
                }
                if (nationalNumber.length>3 && countryCode>0) {
                    [[KNetworkManager defaultManager:true checkHeaderResponse:false] updateUserProfile:@{@"UserPwdRecoveryPart.InternationalPrefix" : countryCode, @"UserPwdRecoveryPart.PhoneNumber" : nationalNumber} completion:^(BOOL success, id responseObject, NSError *error) {
                        [[NSUserDefaults standardUserDefaults] setStringAndSync:number forConstantKey:OMStringConstantKeyUserPhoneNumber];
                        [[KLoginManager shared] makeCompletion:success response:response error:message];
                    }];
                    
                }else{
                    [[KLoginManager shared] makeCompletion:success response:response error:message];
                }
            }
            else {
                if ([message code] == 1003) {
                    [[KLoginManager shared] userRegisteredWaitingEmailVerificationWithResponse:message];
                }
                else if (message){
                    [[KLoginManager shared] showMessage:message.localizedDescription withType:ModeError];
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:true];
        }];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [[KLoginManager shared] showMessage:UserAccess.smsNotValid withType:ModeError];
    }
}

-(IBAction)dismissKeyBoard:(id)sender{
    [self.view endEditing:true];
}

-(IBAction)closeMe:(id)sender{
    [[KLoginManager shared] userClosePresentedLoginViewController];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)loginToOrchard:(id)sender{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(Login.domainsAccepted.count > 0)
    {
        for (EGFloatingTextField *domain in self.domains)
        {
            if (domain.tag == LOGIN_DOMAIN_TAG)
            {
                params[@"Username"] = [NSString stringWithFormat: @"%@%@", self.username.text, domain.text];
                [[NSUserDefaults standardUserDefaults] setStringAndSync:self.username.text forConstantKey:OMStringConstantKeyUserEmail];
                [[NSUserDefaults standardUserDefaults] setStringAndSync:domain.text forConstantKey:OMStringConstantKeyDomain];
                break;
            }
        }
    }
    else
    {
        params[@"Username"] = self.username.text;
        [[NSUserDefaults standardUserDefaults] setStringAndSync:self.username.text forConstantKey:OMStringConstantKeyUserEmail];
    }
    params[@"Password"] = self.password.text;

    [[KLoginManager shared] objc_loginWith:[KrakeAuthenticationProvider orchard] params:params saveTokenParams: false];
}

-(IBAction)openRegisterView:(id)sender{
    self.loginView.hidden = true;
    self.lostpwdView.hidden = true;
    self.registerView.hidden = false;
    CGFloat dim = self.registerStackView.frame.size.height;
    if (dim > self.view.frame.size.height/3*2)
    {
        dim = self.view.frame.size.height/3*2;
    }
    self.heightRegisterView.constant = dim;
    [UIView animateWithDuration:0.5 animations:^{
        self.backButton.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)openLostpwdView:(id)sender{
    self.loginView.hidden = true;
    self.registerView.hidden = true;
    self.lostpwdView.hidden = false;
    [UIView animateWithDuration:0.5 animations:^{
        self.backButton.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)closeRegisterView:(id)sender{
    
    self.registerView.hidden = true;
    self.lostpwdView.hidden = true;
    self.loginView.hidden = false;
    [UIView animateWithDuration:0.5 animations:^{
        self.backButton.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)requestLostPassword:(id)sender{
    [self openLostpwdView:nil];
}

-(IBAction)userRequestLostPassword:(id)sender{
    
    NSString *emailString = self.emailsmsTextField.text;
    if(Login.domainsAccepted.count > 0)
    {
        for (EGFloatingTextField *domain in self.domains)
        {
            if (domain.tag == LOSTPASS_DOMAIN_TAG)
            {
                emailString = [emailString stringByAppendingString:domain.text];
                break;
            }
        }
    }
    
    NSString *emailRegEx = @"^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL result = [predicate evaluateWithObject:emailString];
    if (result){
        [[KLoginManager shared] callRequestPasswordLostWithQueryString:@"RequestLostPasswordAccountOrEmailSsl" params:@{@"username" : emailString}];
        [self closeRegisterView:nil];
    }else{
        NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
        NSError *anError = nil;
        NSString *number = emailString;
        if ([number hasPrefix:@"00"]) {
            number = [@"+" stringByAppendingString:[number substringFromIndex:2]];
        }
        if (![number hasPrefix:@"+"]) {
            number = [@"+39" stringByAppendingString:number];
        }
        NBPhoneNumber *myNumber = [phoneUtil parseWithPhoneCarrierRegion:number error:&anError];
        if ([phoneUtil isValidNumber:myNumber]) {
            NSString *nationalNumber = nil;
            NSNumber *countryCode = [phoneUtil extractCountryCode:number nationalNumber:&nationalNumber];
            nationalNumber = [nationalNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            mainParams = @{ @"phoneNumber" : @{@"internationalPrefix": [NSString stringWithFormat:@"%@", countryCode], @"phoneNumber" : nationalNumber}};
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:KInfoPlist.appName message:[NSString stringWithFormat:@"%@ +%@ %@", UserAccess.checkYourNumber, countryCode, nationalNumber] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:Commons.cancel style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:Commons.ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self->mainParams){
                    [[KLoginManager shared] callRequestPasswordLostWithQueryString:@"RequestLostPasswordSmsSsl" params:[self->mainParams copy]];
                    self->mainParams = nil;
                    [self closeRegisterView:nil];
                }else{
                    [[KLoginManager shared] showMessage:UserAccess.emptyField withType:ModeError];
                }
            }]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:true completion:nil];
            });
        }else{
            [[KLoginManager shared] showMessage:UserAccess.smsNotValid withType:ModeError];
        }
    }
    
}


//MARK: - UITextField DELEGATE

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameRegistration)
    {
        (void)[self.passwordRegistration becomeFirstResponder];
    }
    else if(textField == self.passwordRegistration)
    {
        (void)[self.confirmRegistration becomeFirstResponder];
    }
    else if(textField == self.confirmRegistration && self.numberRegistration.superview != nil)
    {
        (void)[self.numberRegistration becomeFirstResponder];
    }
    else if(textField == self.username)
    {
        (void)[self.password becomeFirstResponder];
    }
    else if(textField == self.password)
    {
        [self loginToOrchard:self.loginButton];
    }
    else
    {
        [self.view endEditing:true];
    }
    return true;
}

- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController {
    [[KLoginManager shared] userClosePresentedLoginViewController];
}


//MARK: - UIPckerView DELEGATE - DATASOURCE

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return Login.domainsAccepted.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"@%@", [Login.domainsAccepted objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    for (EGFloatingTextField *domain in self.domains)
    {
        if (domain.tag == pickerView.tag)
        {
            [domain setText:[NSString stringWithFormat:@"@%@", [Login.domainsAccepted objectAtIndex:row]]];
            break;
        }
    }
}

@end
