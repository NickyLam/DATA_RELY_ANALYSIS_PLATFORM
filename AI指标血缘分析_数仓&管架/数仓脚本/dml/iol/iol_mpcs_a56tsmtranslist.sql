/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a56tsmtranslist
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
drop table ${iol_schema}.mpcs_a56tsmtranslist_ex purge;
alter table ${iol_schema}.mpcs_a56tsmtranslist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a56tsmtranslist;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a56tsmtranslist_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a56tsmtranslist where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a56tsmtranslist_ex(
    optype -- 操作类型
    ,cmdtype -- 指令类型：01-应用申请， 02-应用下载及个人化， 03-应用删除， 04-应用锁定， 05-应用解锁， 06-应用更新， 07-应用数据更新预销户退订
    ,seid -- 安全载体标识
    ,appid -- 应用ID
    ,appversion -- 应用版本
    ,processid -- 申请单号
    ,acctno -- 账号
    ,pin -- 密码
    ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,custno -- 客户号
    ,ecashbalance -- 电子现金余额
    ,idtype -- 证件类型
    ,idno -- 证件号
    ,acctname -- 姓名
    ,mobile -- 手机号
    ,smsauthcode -- 短信验证码
    ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
    ,bindacctno -- 开卡时上送的验证卡号
    ,relacctno -- TSM电子现金账户关联转出账户卡号
    ,sharedtype -- 是否共享账户（0-银行自行决定， 1-共享账户， 2-非共享账户）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,applocked -- 应用锁定：
    ,chnlid -- 渠道码
    ,opendate -- 开卡日期
    ,rspcd -- 核心返回码
    ,rspmsg -- 核心返回信息
    ,interfaceversion -- 接口版本号
    ,transtimesource -- 发起方交易时间
    ,transtimedestination -- 接收方交易时间
    ,transseqsource -- 交易发起方流水号
    ,transseqdestination -- 交易接收方流水号
    ,transtype -- 交易类型
    ,transsource -- 报文请求方
    ,transdestination -- 报文接收方
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    optype -- 操作类型
    ,cmdtype -- 指令类型：01-应用申请， 02-应用下载及个人化， 03-应用删除， 04-应用锁定， 05-应用解锁， 06-应用更新， 07-应用数据更新预销户退订
    ,seid -- 安全载体标识
    ,appid -- 应用ID
    ,appversion -- 应用版本
    ,processid -- 申请单号
    ,acctno -- 账号
    ,pin -- 密码
    ,accttype -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,custno -- 客户号
    ,ecashbalance -- 电子现金余额
    ,idtype -- 证件类型
    ,idno -- 证件号
    ,acctname -- 姓名
    ,mobile -- 手机号
    ,smsauthcode -- 短信验证码
    ,mobilestate -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-MOCAM注册通知
    ,bindacctno -- 开卡时上送的验证卡号
    ,relacctno -- TSM电子现金账户关联转出账户卡号
    ,sharedtype -- 是否共享账户（0-银行自行决定， 1-共享账户， 2-非共享账户）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,acctstate -- TSM账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,applocked -- 应用锁定：
    ,chnlid -- 渠道码
    ,opendate -- 开卡日期
    ,rspcd -- 核心返回码
    ,rspmsg -- 核心返回信息
    ,interfaceversion -- 接口版本号
    ,transtimesource -- 发起方交易时间
    ,transtimedestination -- 接收方交易时间
    ,transseqsource -- 交易发起方流水号
    ,transseqdestination -- 交易接收方流水号
    ,transtype -- 交易类型
    ,transsource -- 报文请求方
    ,transdestination -- 报文接收方
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a56tsmtranslist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a56tsmtranslist exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a56tsmtranslist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a56tsmtranslist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a56tsmtranslist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a56tsmtranslist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);