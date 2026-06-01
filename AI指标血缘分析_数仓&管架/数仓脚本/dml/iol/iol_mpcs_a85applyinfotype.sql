/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a85applyinfotype
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a85applyinfotype_ex purge;
alter table ${iol_schema}.mpcs_a85applyinfotype add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a85applyinfotype truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a85applyinfotype_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a85applyinfotype where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a85applyinfotype_ex(
    transtime -- 操作时间
    ,custno -- 客户号
    ,serviceid -- 卡产品标识
    ,userid -- 用户UserID
    ,username -- 用户姓名
    ,idtype -- 证件类型
    ,idvalue -- 证件号码
    ,msisdn -- 手机号
    ,email -- 邮箱
    ,pan -- 主账号
    ,validdate -- 有效期
    ,cvn2 -- CVN2（信用卡）
    ,pin -- PIN（借记卡）
    ,state -- 初始00000000从左到右为云卡激活,挂失/冻结,锁定,换卡,注销 0初始化 1处理中 2成功 3失败 4解挂/解锁中
    ,cpsid -- cpsId
    ,applydate -- 申请日期
    ,activatedate -- 激活日期
    ,validatelukcount -- 当前已下载的LUK数量
    ,tokenpan -- 云卡标记
    ,expiredate -- 云卡有效期
    ,status -- 云卡状态 1-初始化 21 可用 22暂停 31注销
    ,statustime -- 
    ,panstatus -- 操作标识 0 正常 1主帐号挂失 2主账号锁定 3主帐号注销
    ,locked -- 发卡行锁定标志，true为发卡行锁定，false为未锁定
    ,lost -- 持卡人挂失标志，true为已挂失，false为未挂失
    ,devicemodel -- 设备型号
    ,devicesn -- 设备序列号
    ,ostype -- 操作系统类型
    ,osversion -- 操作系统版本
    ,deviceid -- 安卓ID
    ,imei -- IMEI
    ,walletname -- 移动应用名称
    ,walletsignature -- 移动应用签名
    ,walletversion -- 移动应用版本
    ,ifpwd -- 小额免密标识 0-免密 1-验密
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transtime -- 操作时间
    ,custno -- 客户号
    ,serviceid -- 卡产品标识
    ,userid -- 用户UserID
    ,username -- 用户姓名
    ,idtype -- 证件类型
    ,idvalue -- 证件号码
    ,msisdn -- 手机号
    ,email -- 邮箱
    ,pan -- 主账号
    ,validdate -- 有效期
    ,cvn2 -- CVN2（信用卡）
    ,pin -- PIN（借记卡）
    ,state -- 初始00000000从左到右为云卡激活,挂失/冻结,锁定,换卡,注销 0初始化 1处理中 2成功 3失败 4解挂/解锁中
    ,cpsid -- cpsId
    ,applydate -- 申请日期
    ,activatedate -- 激活日期
    ,validatelukcount -- 当前已下载的LUK数量
    ,tokenpan -- 云卡标记
    ,expiredate -- 云卡有效期
    ,status -- 云卡状态 1-初始化 21 可用 22暂停 31注销
    ,statustime -- 
    ,panstatus -- 操作标识 0 正常 1主帐号挂失 2主账号锁定 3主帐号注销
    ,locked -- 发卡行锁定标志，true为发卡行锁定，false为未锁定
    ,lost -- 持卡人挂失标志，true为已挂失，false为未挂失
    ,devicemodel -- 设备型号
    ,devicesn -- 设备序列号
    ,ostype -- 操作系统类型
    ,osversion -- 操作系统版本
    ,deviceid -- 安卓ID
    ,imei -- IMEI
    ,walletname -- 移动应用名称
    ,walletsignature -- 移动应用签名
    ,walletversion -- 移动应用版本
    ,ifpwd -- 小额免密标识 0-免密 1-验密
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a85applyinfotype
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a85applyinfotype exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a85applyinfotype_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a85applyinfotype to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a85applyinfotype_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a85applyinfotype',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);