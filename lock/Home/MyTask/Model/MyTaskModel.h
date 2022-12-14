//
//  MyTaskModel.h
//  lock
//
//  Created by admin on 2020/5/27.
//  Copyright © 2020 li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 获取任务数
 */
@interface MyTaskNumberRequest : RequestBean

@end

@interface MyTaskNumberResponse : ResponseBean

@property (nonatomic,assign)int data;

@end
/*
 获取任务列表
 */
@interface MyTaskListRequest : RequestBean
@property (nonatomic,assign)NSInteger page;//页码
@property (nonatomic,assign)NSInteger pagesize;//每页条数
@property(nonatomic,copy)NSString * approved;//0-待审核，1-已通过，2-已驳回
@end

@protocol MyTaskTimeRangeListBean
@end
@interface MyTaskTimeRangeListBean : BaseBean
@property(nonatomic,copy)NSString * timeid;//时间段id
@property(nonatomic,copy)NSString * begintime;//开始时间
@property(nonatomic,copy)NSString * endtime;//结束时间
@property(nonatomic,copy)NSString * keydataid;//任务id
@property(nonatomic,copy)NSString * rangeid;//区间id
@end

@protocol UnlockListBean
@end
@interface UnlockListBean : BaseBean
@property(nonatomic,copy)NSString * lockid;//锁id
@property(nonatomic,copy)NSString * deptid;//部门id
@property(nonatomic,copy)NSString * lockno;//锁编号
@property(nonatomic,copy)NSString * keydataid;//任务id
@property(nonatomic,copy)NSString * listid;//id//列表ID
@property(nonatomic,copy)NSString * locknohm;//
@property(nonatomic,copy)NSString * deptname;//部门名称
@property(nonatomic,copy)NSString * lockname;//锁名称
@property(nonatomic,copy)NSString * deptcode;//锁编码
@property(nonatomic,copy)NSString * rangeid;//区间id
@end

@protocol MyTaskListBean
@end
@interface MyTaskListBean : BaseBean
@property(nonatomic,copy)NSString * userid;//用户id
@property(nonatomic,copy)NSString * opttype;//操作类型
@property(nonatomic,copy)NSString * workername;//工作名称
@property(nonatomic,copy)NSString * updatetime;//更新时间
@property(nonatomic,copy)NSString * begindate;//开始日期
@property(nonatomic,copy)NSString * keyname;//钥匙名称
@property(nonatomic,copy)NSString * endtime;//结束时间
@property(nonatomic,copy)NSString * enddatetime;//结束日期
@property(nonatomic,copy)NSString * begintime;//开始时间
@property(nonatomic,copy)NSString * enddate;//结束日期
@property(nonatomic,copy)NSString * backid;//id
@property(nonatomic,copy)NSString * workerid;//工作记录id
@property(nonatomic,copy)NSString * taskid;//任务id
@property(nonatomic,copy)NSString * keyid;//钥匙id
@property(nonatomic,copy)NSString * begindatetime;//结束日期
@property(nonatomic,copy)NSString * keyno;//钥匙编号
@property(nonatomic,strong)NSMutableArray<UnlockListBean> * unlocklist;//锁列表
@property(nonatomic,copy)NSString * keytype;//钥匙类型
@property(nonatomic,copy)NSString * createtime;//创建时间
@property(nonatomic,copy)NSString * opttime;//操作时间
@property(nonatomic,copy)NSString * keymode;//钥匙
@property(nonatomic,copy)NSString * username;//用户名称
@property(nonatomic,strong)NSMutableArray<MyTaskTimeRangeListBean> * timerangelist;//时间段
@property(nonatomic,strong)NSMutableArray<UserKeyInfoList> * keylist;//钥匙列表
@property(nonatomic,copy)NSString * subject;//任务名称
@property(nonatomic,copy)NSString * approved;//状态 0-待审核，1-已通过，2-已驳回
@property(nonatomic,assign)BOOL remotefingerprint; // true无线模式 false有线模式

@end

@interface MyTaskListPage : BaseBean
@property (nonatomic,assign)NSInteger pagesize;//每页数量
@property (nonatomic,assign)NSInteger totalcount;//总数
@property (nonatomic,assign)NSInteger page;//当前页
@property (nonatomic,strong)NSMutableArray<MyTaskListBean> * content;//开锁
@end

@interface MyTaskListResponse : ResponseBean
@property (nonatomic,strong)MyTaskListPage * data;
@end

//根据任务ID判断任务是否有效（data:true,表示有效；data:false,表示无效）
@interface MyTaskValidRequest : RequestBean
@property (nonatomic,copy)NSString * keydataid;
@end

@interface MyTaskValidResponse : ResponseBean
@property (nonatomic,assign)BOOL data;
@end

@interface MyTaskSwitchLockInfoBean : BaseBean
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,copy)NSString * iamgeName;
@property (nonatomic,copy)NSString * eventtype;
@property (nonatomic,assign)NSInteger opttype;
@end

//上传开关锁记录

@interface MyTaskUploadKeyDataReqest : RequestBean
@property (nonatomic,copy)NSString * eventtype;//锁状态
@property (nonatomic,copy)NSString * keyno;//钥匙号
@property (nonatomic,copy)NSString * lockno;//锁号
@property (nonatomic,assign)NSInteger opttype;//0
@property (nonatomic,copy)NSString * time;//时间
@property (nonatomic,copy)NSString * fingerid;//C锁要上传指纹id
@end

/*
 获取任务指纹列表
 */
@interface MyTaskFingerprintListRequest : RequestBean
@property (nonatomic,copy)NSString * keydataid;//任务id
@end

@protocol MyTaskFingerprintListBean
@end
@interface MyTaskFingerprintListBean : BaseBean
@property(nonatomic,assign)int fid;//指纹id
@property(nonatomic,copy)NSString * fea;//指纹数据
@end

@interface MyTaskFingerprintListResponse : ResponseBean
@property (nonatomic,strong)NSMutableArray<MyTaskFingerprintListBean> * data;
@end

NS_ASSUME_NONNULL_END
