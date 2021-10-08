//
//  Strings.h
//  lock
//
//  Created by admin on 2020/5/20.
//  Copyright © 2020 li. All rights reserved.
//

#ifndef Strings_h
#define Strings_h

#pragma mark NSNotificationCenter key
#define NF_KEY_FOREGROUND                   @"enterForeground"//进入前台
#define NF_KEY_BACKGROUND                   @"houmeBackGround"//退出后台
#define NF_KEY_APPLY_OPEN_LOCK_SUCCESS      @"applyOpenLockTaskSuccess"//申请开锁任务成功
#define NF_KEY_KEY_RELIEVE_SUCCESS          @"keyRelieveSuccess"//钥匙解除挂失成功
#define NF_KEY_LOCK_REPLACE_SUCCESS         @"lockReplaceSuccess"//锁替换成功

//公共
#define STR_TIMEOUT                         L(@"网络连接超时")
#define STR_PARSE_FAILURE                   L(@"解析失败")
#define STR_LOADING                         L(@"加载中")
#define STR_SAVE                            L(@"保存")
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
#define STR_LOGIN                           L(@"登录")
#define STR_SETTING                         L(@"设置")
#define STR_ADDRESS_TIPS                    L(@"请设置服务器地址")
#define STR_ACCOUNT_TIPS                    L(@"请输入账户")
#define STR_PASSWORD_TIPS                   L(@"请输入密码")
#define STR_WRONG_ACCOUNT_PASSWORD          L(@"账号或密码错误")
#define STR_USER_NAME_ERROR                 L(@"用户名错误")
#define STR_PASSWORD_ERROR                  L(@"密码错误")
#define STR_USER_NON_EXISTENT               L(@"用户不存在")

//首页
#define STR_HOMEPAGE                        L(@"主页")
#define STR_MAP                             L(@"地图")
#define STR_MY_TASK                         L(@"我的任务")
#define STR_WORK_RECORD                     L(@"工作记录")
#define STR_REG_LOCK                        L(@"注册锁")
#define STR_REG_KEY                         L(@"注册钥匙")
#define STR_SYSTEM_PARAMETER                L(@"系统参数")
#define STR_APPLY_OPEN_LOCK                 L(@"申请开锁")
#define STR_OPEN_LOCK_AUDIT                 L(@"开锁审核")

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
#define STR_PLEASE_CONNECT_LOCK             L(@"请连接锁")
#define STR_INIT_LOCK_CODE                  L(@"设置初始化锁系统码钥匙")
#define STR_KEY_HARDWARE_VERSION            L(@"钥匙硬件版本")
#define STR_CHANGE_KEY_ID                   L(@"修改钥匙ID")
#define STR_CHANGE_KEY_ID_FAIL              L(@"修改钥匙ID失败")
#define STR_KEY_INFO_NO_EXISTENT            L(@"该钥匙信息不存在")
#define STR_KEY_NUMBER_EMPTY                L(@"钥匙编号为空")
#define STR_KEY_NAME_EMPTY                  L(@"钥匙名称为空")
#define STR_KEY_NUMBER_REPEAT               L(@"钥匙编号重复")
#define STR_KEY_NAME_REPEAT                 L(@"钥匙名称重复")
#define STR_KEY_HARDWARE_NUMBER_REPEAT      L(@"钥匙硬件编号重复")
#define STR_KEY_NUMBER_RANGE                L(@"钥匙编号已超出范围")
#define STR_KEY_NAME_TIPS                   L(@"请输入钥匙名称")
#define STR_KEY_FACTORY_REPEAT_TIPS         L(@"钥匙已存在，请勿重复注册")
#define STR_KEY_LOSE                        L(@"该钥匙已丢失")
#define STR_KEY_DAMAGED                     L(@"该钥匙已损坏")
#define STR_KEY_TASK_OUT                    L(@"该钥匙已领出")
#define STR_KEY_NO_DEPT_POWER               L(@"无部门权限可以操作该钥匙")

//注册锁
#define STR_PLEASE_CONNECT_LOCK_READ        L(@"请连锁，读取锁id...")
#define STR_CONNECT_LOCK_FAIL               L(@"连接锁失败")
#define STR_LOCK_ID                         L(@"锁ID")
#define STR_LOCK_NAME_TIPS                  L(@"请输入锁名称")
#define STR_RE_LOCK_SUCCESS                 L(@"注册锁成功")
#define STR_CHANGE_LOCK_ID                  L(@"修改锁ID")
#define STR_CHANGE_LOCK_ID_FAIL             L(@"修改锁ID失败")
#define STR_LOCK_NUMBER_EMPTY               L(@"锁编号为空")
#define STR_LOCK_NAME_EMPTY                 L(@"锁名称为空")
#define STR_LOCK_NUMBER_REPEAT              L(@"与本部门的锁编号重复")
#define STR_LOCK_NAME_REPEAT                L(@"与本部门的锁名称重复")
#define STR_LOCK_NUMBER_REPEAT_OTHER        L(@"与其他部门的锁编号重复")
#define STR_LOCK_NUMBER_RANGE               L(@"锁编号已超出范围")
#define STR_LOCK_HARDWARE_NUMBER_REPEAT     L(@"锁硬件编号重复")

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
#define STR_VERIFY_FINGERPRINT_SWITH_LOCK   L(@"请按指纹进行身份确认，然后开关锁")
#define STR_CLOSE_LOCK_SUCCESS              L(@"关锁成功")
#define STR_MY_TASK_INVALID                 L(@"任务已失效")
#define STR_LOCK_LIST                       L(@"锁列表")
#define STR_NO_YET                          L(@"暂无")
#define STR_PASSWORD_MISMATCH               L(@"密码不匹配")
#define STR_OPERAT_DISTURBANCE              L(@"操作中断")
#define STR_KEY_LOCK_MATCH_FAIL             L(@"钥匙与锁密钥匹配失败")
#define STR_BLACKLIST_KEY                   L(@"黑名单钥匙")
#define STR_OPEN_LOCK_FAIL                  L(@"开锁失败")
#define STR_CLOSE_LOCK_FAIL                 L(@"关锁失败")
#define STR_VALIDATION_FAILED               L(@"验证失败")
#define STR_FINGERPRINT_AUTHORIZE_SUCCESS   L(@"指纹授权成功")
#define STR_FINGERPRINT_AUTHORIZE_FAIL      L(@"指纹授权失败")

//系统参数
#define STR_QUIT                            L(@"退出")
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
#define STR_OLD_PASSWORD_ERROR              L(@"原密码错误")
#define STR_NEW_OLD_EQUAL                   L(@"新密码和旧密码相同")

//申请开锁
#define STR_PLEASE_SELECT_DELETE_OPEN_LOCK  L(@"请选择要删除的开锁申请")
#define STR_SURE_DELETE_OPEN_LOCK           L(@"确定要删除开锁申请？")
#define STR_DELETE_SUCCESS                  L(@"删除成功")
#define STR_NEW_APPLY_UNLOCK                L(@"新建申请开锁")
#define STR_DATE                            L(@"日期")
#define STR_PLEASE_SELECT_OPEN_LOCK         L(@"请选择要开的锁")
#define STR_PENDING_APPROVAL                L(@"待审批")
#define STR_REJECTED                        L(@"已驳回")
#define STR_TASK_ALREADY_EXIST              L(@"任务已存在")
#define STR_TASK_SUBJECT                    L(@"主题")
#define STR_TASK_SUBJECT_TIPS               L(@"请输入主题")

//开锁审核
#define STR_AGREE                           L(@"同意")
#define STR_REJECT                          L(@"驳回")
#define STR_APPLICANT                       L(@"申请人")
#define STR_AGREE_UNLOCK_APPLY              L(@"确定要同意开锁申请？")
#define STR_REJECT_UNLOCK_APPLY             L(@"确定要驳回开锁申请？")

//黑名单
#define STR_BLACKLIST                       L(@"黑名单")
#define STR_BLACKLIST_KEY                   L(@"黑名单钥匙")
#define STR_RELIEVE                         L(@"解除")
#define STR_BLACK_KEY_TIPS                  L(@"黑：下载黑名单到锁内以防止被丢失的钥匙开锁")
#define STR_WHITE_KEY_TIPS                  L(@"白：将黑名单从锁中移除")
#define STR_BLACK_KEY                       L(@"黑钥匙")
#define STR_SELECT_LOSS_KEY                 L(@"请选择丢失的钥匙")
#define STR_WHITE_KEY                       L(@"白钥匙")
#define STR_OPERATION_USER                  L(@"操作用户")
#define STR_BLACKOUT_TIME                   L(@"拉黑时间")
#define STR_REMOVE_LOSS                     L(@"解除挂失")
#define STR_PLEASE_REMOVE_LOSS              L(@"请解除挂失")
#define STR_REMOVE_LOSS_TIPS                L(@"重要！解除挂失后，务必创建新的白钥匙将此钥匙从关联锁的黑名单中移除，否则可能会出现再次标记为黑名单而无法开锁的情况")
#define STR_REMOVE_LOSS_SUCCESS             L(@"解除挂失成功")
#define STR_CREATE_BLACK_KEY                L(@"创建黑钥匙")
#define STR_PLEASE_CREATE_BLACK_KEY         L(@"请创建黑钥匙")
#define STR_CREATE                          L(@"创建")
#define STR_CREATE_BLACK_KEY_FAIL           L(@"创建黑钥匙失败")
#define STR_CREATE_BLACK_KEY_SUCCESS        L(@"创建黑钥匙成功")
#define STR_CREATE_WHITE_KEY                L(@"创建白钥匙")
#define STR_PLEASE_CREATE_WHITE_KEY         L(@"请创建白钥匙")
#define STR_CREATE_WHITE_KEY_FAIL           L(@"创建白钥匙失败")
#define STR_CREATE_WHITE_KEY_SUCCESS        L(@"创建白钥匙成功")

//钥匙挂失
#define STR_KEY_LOSS                        L(@"钥匙挂失")
#define STR_LOSS                            L(@"丢失")
#define STR_DEPT                            L(@"部门")
#define STR_USER                            L(@"使用人")
#define STR_UPDATE_TIME                     L(@"更新时间")
#define STR_DEFINE_LOSS_KEY                 L(@"确定要挂失钥匙")
#define STR_LOSS_SUCCESS                    L(@"挂失成功")

//锁替换
#define STR_LOCK_REPLACE                    L(@"锁替换")
#define STR_REPLACE                         L(@"替换")
#define STR_STATUS                          L(@"状态")
#define STR_NO_INSTALL                      L(@"未安装")
#define STR_ALREADY_INSTALL                 L(@"已安装")
#define STR_DAMAGE                          L(@"损坏")
#define STR_REPAIR                          L(@"维修")
#define STR_REPLACE_MINE_TPS                L(@"您想用自己替换自己吗?")
#define STR_REPLACE_LOCK_EXIT               L(@"使用已存在系统内的锁[%@]替换?")
#define STR_REPLACE_LOCK_NEW                L(@"使用此新锁进行替换?")
#define STR_PLEASE_REPLACE_REASON           L(@"请输入替换原因")
#define STR_REPLACE_REASON_EMPTY            L(@"替换原因不能为空")
#define STR_REPLACE_SUCCESS                 L(@"替换锁成功")



#endif /* Strings_h */
