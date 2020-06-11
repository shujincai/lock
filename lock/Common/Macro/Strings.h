//
//  Strings.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#ifndef Strings_h
#define Strings_h

//公共
#define STR_TIMEOUT                         L(@"网络连接超时")
#define STR_PARSE_FAILURE                   L(@"解析失败")
#define STR_LOADING                         L(@"加载中")
#define STR_SAVE                            L(@"保 存")
#define STR_PHOTO                           L(@"相册")
#define STR_TIPS                            L(@"提示")
#define STR_KNOW                            L(@"知道了")
#define STR_TIME                            L(@"时间")
#define STR_REGISTER                        L(@"注册")
#define STR_SUBMIT_DATA_FAIL                L(@"提交数据失败")
#define STR_NO_DATA                         L(@"暂无数据")
#define STR_BE_CAREFUL                      L(@"注意")
#define STR_CANCEL                          L(@"取消")
#define STR_DEFINE                          L(@"确定")

//设置服务器地址
#define STR_SET_ADDRESS                     L(@"设置服务器地址")
#define STR_ADDRESS_PLACEHOLER              L(@"请输入服务器地址")
#define STR_QR_CODE                         L(@"二维码")
#define STR_QR_CODE_TIPS                    L(@"将取景框对准二维码,即可自动扫描")
#define STR_BAR_CODE                        L(@"条码")
#define STR_BAR_CODE_TIPS                   L(@"将取景框对准条码,即可自动扫描")
#define STR_NO_QR_CODE                      L(@"图片中未识别到二维码")
#define STR_PHOTO_NO_POWER                  L(@"相册读取权限未开启")
#define STR_PHOTO_SET                       L(@"请到手机系统的\n【设置】->【隐私】->【相册】\n对%@开启相机的访问权限")
#define STR_CAMERA_NO_POWER                 L(@"相机权限未开启")
#define STR_CAMERA_SET                      L(@"请到手机系统的\n【设置】->【隐私】->【相机】\n对%@开启相机的访问权限")
#define STR_SUPPORT_EIGHT_SYSTEM            L(@"只支持iOS8.0以上系统")

//登录界面
#define STR_ACCOUNT                         L(@"帐号")
#define STR_PASSWORD                        L(@"密码")
#define STR_LOGIN                           L(@"登 录")
#define STR_SETTING                         L(@"设置")
#define STR_ADDRESS_TIPS                    L(@"请设置服务器地址")
#define STR_ACCOUNT_TIPS                    L(@"请输入账户")
#define STR_PASSWORD_TIPS                   L(@"请输入密码")

//首页
#define STR_HOMEPAGE                        L(@"主页")
#define STR_MAP                             L(@"地图")
#define STR_MY_TASK                         L(@"我的任务")
#define STR_WORK_RECORD                     L(@"工作记录")
#define STR_REG_LOCK                        L(@"注册锁")
#define STR_REG_KEY                         L(@"注册钥匙")
#define STR_SYSTEM_PARAMETER                L(@"系统参数")

//搜索蓝牙钥匙
#define STR_SEARCH_BLUETOOTH                L(@"搜索蓝牙钥匙")
#define STR_NO_BLUETOOTH                    L(@"暂无蓝牙")
#define STR_NO_CONNECT                      L(@"未连接")
#define STR_CONNECTING                      L(@"连接中")
#define STR_CONNECTED                       L(@"已连接")
#define STR_DISCONNECTING                   L(@"断开中")

//注册钥匙
#define STR_CONNECT_KEY_FAIL                L(@"连接钥匙失败")
#define STR_KEY_NAME                        L(@"名称")
#define STR_KEY                             L(@"钥匙")
#define STR_KEY_NUMBER                      L(@"钥匙序号")
#define STR_REG_KEY_SUCCESS                 L(@"注册钥匙成功")

//注册锁
#define STR_PLEASE_CONNECT_LOCK             L(@"请连锁，读取锁id...")
#define STR_CONNECT_LOCK_FAIL               L(@"连接锁失败")
#define STR_LOCK_ID                         L(@"锁ID")
#define STR_LOCK_NAME_TIPS                  L(@"请输入锁名称")
#define STR_RE_LOCK_SUCCESS                 L(@"注册锁成功")

//工作记录
#define STR_DATE_SELECT                     L(@"日期选择")
#define STR_SELECT_START_TIME               L(@"请选择开始时间")
#define STR_SELECT_END_TIME                 L(@"请选择结束时间")
#define STR_FORMATTER_YM                    L(@"yyyy年MM月")
#define STR_QUERY                           L(@"查询")
#define STR_FORMATTER_YMD                   L(@"yyyy年MM月dd日")
#define STR_OPEN_CLOSE_LOCK_RECORD          L(@"开关锁记录")
#define STR_OPEN_LOCK_SUCCESS               L(@"开锁成功")
#define STR_SETTING_SUCCESS                 L(@"设置成功")
#define STR_SETTING_FAIL                    L(@"设置失败")
#define STR_OVERSTEP_TERM_VALIDITY          L(@"超出有效期")
#define STR_NO_POWER                        L(@"没有权限")
#define STR_OVERSTEP_TIME_RANGE             L(@"超出时间范围")
#define STR_BLUETOOTH_OPEN_LOCK_SUCCESS     L(@"蓝牙钥匙开锁成功")
#define STR_BLUETOOTH_CLOSE_LOCK_SUCCESS    L(@"蓝牙钥匙关锁成功")

//我的任务
#define STR_WORK_TASK                       L(@"工作任务")
#define STR_SWITH_LOCK                      L(@"开关锁")
#define STR_INIT_SUCCESS                    L(@"初始化成功")
#define STR_CONNECT_KEY_SUCCESS             L(@"连接钥匙成功")
#define STR_KEY_NUMBER_NO_MATE              L(@"钥匙号码不匹配")
#define STR_PLEASE_SWITH_LOCK               L(@"请开关锁")
#define STR_CLOSE_LOCK_SUCCESS              L(@"关锁成功")

//系统参数
#define STR_QUIT                            L(@"退 出")
#define STR_DEFINE_QUIT                     L(@"确定退出当前帐号吗")
#define STR_DEVICE_NUMBER                   L(@"设备号码")
#define STR_SERVER_ADDRESS                  L(@"服务器地址")
#define STR_VERSION_NUMBER                  L(@"版本号")
#define STR_CHANGE_PASSWORD                 L(@"修改密码")
#define STR_CLICK_CHANGE                    L(@"点击修改")
#define STR_QUIT_SUCCESS                    L(@"退出成功")

//修改密码
#define STR_OLD_PASSWORD                    L(@"原密码")
#define STR_NEWS_PASSWORD                   L(@"新密码")
#define STR_CONFIRM_PASSWORD                L(@"确认密码")
#define STR_PLEASE_OLD_PWD                  L(@"请输入原密码")
#define STR_PLEASE_NEWS_PWD                 L(@"请输入新密码")
#define STR_PLEASE_CONFIRM_PWD              L(@"请输入确认密码")
#define STR_PASSWORD_ATYPISM                L(@"两次密码不一致")
#define STR_DEFINE_CHANGE_PWD               L(@"确定修改密码吗")
#define STR_CHANGE_PWD_SUCCESS              L(@"修改成功，请重新登录")

#endif /* Strings_h */
