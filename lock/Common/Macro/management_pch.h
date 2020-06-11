//
//  management_pch.h
//  lock
//
//  Created by 李金洋 on 2020/3/20.
//  Copyright © 2020 li. All rights reserved.
//

#ifndef management_pch_h
#define management_pch_h


#endif /* management_pch_h */
#define UIColorFromRGBA(v)  [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
//无广告模式 1 无 0 有
#define NOLIMITMODE  0
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define ios11  ([UIDevice currentDevice].systemVersion.floatValue > 11.0)

#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height


#define UIScreenWidthSP [UIScreen mainScreen].bounds.size.width/375
#define UIScreenHeightSP [UIScreen mainScreen].bounds.size.height/667


#define UIScreenFrame  [UIScreen mainScreen].bounds
#define UINavigationBarHeight 64


#define TM_firstTextColor       UIColorFromRGBA(0x333333)
#define TM_secendTextColor      UIColorFromRGBA(0x666666)
#define TM_thirdTextColor       UIColorFromRGBA(0x999999)
#define TM_lineColor            UIColorFromRGBA(0xd9d9d9)
#define TM_backgroundColor      UIColorFromRGBA(0xf1f2f7)

#define TM_redColor             UIColorFromRGBA(0xf03611)
#define TM_grayBackGroundColor  UIColorFromRGBA(0xB3B3B3)
#define TM_BlueBackGroundColor   UIColorFromRGBA(0x2a92ea)
#define TM_DimGray UIColorFromRGBA(0x0000CD)
#define TM_placeHoderImage      [UIImage new]
//主题色
#define TM_ThemeBackGroundColor  FlatRed
#define TM_YellowBackGroundColor  UIColorFromRGBA(0xF56187)
#define TM_YellowTitleGroundColor  UIColorFromRGBA(0xF6A520)

#define TM_YellowItemColor  [UIColor colorWithRed:204/255.0 green:146/255.0 blue:47/255.0 alpha:1]


#define TM_anlvse  UIColorFromRGBA(0xCB9230)
#define TM_HomeTableViewCollor  [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]

#define TM_PAGE_DIC     \
[paramDic setObject:@(self.page) forKey:@"page"];\
[paramDic setObject:@"100" forKey:@"page_size"];\

#define pageNum  10

#define BGCOLOR [UIColor colorWithRed:17/255.0 green:19/255.0 blue:40/255.0 alpha:1]
#define BGTABCOLOR [UIColor colorWithRed:37/255.0 green:42/255.0 blue:76/255.0 alpha:1]
#define NUMBERCOLOR [UIColor colorWithRed:75/255.0 green:186/255.0 blue:255/255.0 alpha:1]

#define SELECTCOLOR [UIColor colorWithRed:62/255.0 green:142/255.0 blue:255/255.0 alpha:1]
#define NOTCOLOR         UIColorFromRGBA(0x708090)

#define COLLECTIONCOLOR  UIColorFromRGBA(0x696969)
#define COLL  UIColorFromRGBA(0x111329)
#define LINECOLLOR  UIColorFromRGBA(0x414252)


#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define SmartTopSpaceHigh ((Device_Is_iPhoneX||IS_IPHONE_Xs||IS_IPHONE_Xr||IS_IPHONE_Xs_Max)?84:64)
#define SYRealValueW(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)

//适配的高

#define SYRealValueH(value) ((value)/667.0f*[UIScreen mainScreen].bounds.size.height)

#define kFont(a) [UIFont systemFontOfSize:(a/ 375.0 * UIScreenWidth)] //字体大小
/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
/** define:屏幕的宽高比 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_SIZE.width
/**
 *define:颜色设置的宏定义
 *prame: _r -- RGB的红
 *parma: _g -- RGB的绿
 *parma: _g -- RGB的蓝
 *parma: _alpha -- RGB的透明度
 */
#define SELECT_COLOR(_r,_g,_b,_alpha) [UIColor colorWithRed:_r / 255.0 green:_g / 255.0 blue:_b / 255.0 alpha:_alpha]
/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

#define NSLocalizedString(key, comment) \
[NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
#define L(key)   NSLocalizedString(key, nil)
//存
#define kSaveMyDefault(A,B) [[NSUserDefaults standardUserDefaults] setObject:B forKey:A]
//取值
#define kFetchMyDefault(A) [[NSUserDefaults standardUserDefaults] objectForKey:A]
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
