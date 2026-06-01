/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_tranflow
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
drop table ${iol_schema}.tbps_cpr_tranflow_ex purge;
alter table ${iol_schema}.tbps_cpr_tranflow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tbps_cpr_tranflow;

-- 2.3 insert data to ex table
create table ${iol_schema}.tbps_cpr_tranflow_ex nologging
compress
as
select * from ${iol_schema}.tbps_cpr_tranflow where 0=1;

insert /*+ append */ into ${iol_schema}.tbps_cpr_tranflow_ex(
    ctl_flowno -- 流水号
    ,ctl_ecifno -- 全行统一客户号
    ,ctl_userno -- 用户顺序号
    ,ctl_transcode -- 交易码
    ,ctl_payeracc -- 付款账号
    ,ctl_payeracname -- 付款账号名称
    ,ctl_payerdeptid -- 付款账号开户行
    ,ctl_currency -- 币种
    ,ctl_crflag -- 钞汇标志：C：钞；R：汇；X：不适用
    ,ctl_rcvciftype -- 收款人类型：1：企业；2：个人
    ,ctl_rcvacc -- 收款账号
    ,ctl_rcvaccname -- 收款人户名
    ,ctl_savercvflag -- 保存收款人：1：是；2：否
    ,ctl_notifyrcvflag -- 通知收款人：1：是；2：否
    ,ctl_rcvmobile -- 收款人号码
    ,ctl_rcvbankid -- 收款人银行号
    ,ctl_provincecode -- 省
    ,ctl_citycode -- 市
    ,ctl_uniondeptid -- 联行号
    ,ctl_uniondeptname -- 联行名
    ,ctl_amount -- 金额
    ,ctl_fee -- 手续费
    ,ctl_groundflag -- 落地标志
    ,ctl_notecode -- 通知码
    ,ctl_remark -- 附言：ET和EU，按核心的枚举值送
    ,ctl_priority -- 加急标志
    ,ctl_productcode -- 产品代码（理财交易填写）
    ,ctl_productname -- 产品名称（理财交易填写）
    ,ctl_cancelflow -- 被撤单流水号（理财交易填写）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ctl_flowno -- 流水号
    ,ctl_ecifno -- 全行统一客户号
    ,ctl_userno -- 用户顺序号
    ,ctl_transcode -- 交易码
    ,ctl_payeracc -- 付款账号
    ,ctl_payeracname -- 付款账号名称
    ,ctl_payerdeptid -- 付款账号开户行
    ,ctl_currency -- 币种
    ,ctl_crflag -- 钞汇标志：C：钞；R：汇；X：不适用
    ,ctl_rcvciftype -- 收款人类型：1：企业；2：个人
    ,ctl_rcvacc -- 收款账号
    ,ctl_rcvaccname -- 收款人户名
    ,ctl_savercvflag -- 保存收款人：1：是；2：否
    ,ctl_notifyrcvflag -- 通知收款人：1：是；2：否
    ,ctl_rcvmobile -- 收款人号码
    ,ctl_rcvbankid -- 收款人银行号
    ,ctl_provincecode -- 省
    ,ctl_citycode -- 市
    ,ctl_uniondeptid -- 联行号
    ,ctl_uniondeptname -- 联行名
    ,ctl_amount -- 金额
    ,ctl_fee -- 手续费
    ,ctl_groundflag -- 落地标志
    ,ctl_notecode -- 通知码
    ,ctl_remark -- 附言：ET和EU，按核心的枚举值送
    ,ctl_priority -- 加急标志
    ,ctl_productcode -- 产品代码（理财交易填写）
    ,ctl_productname -- 产品名称（理财交易填写）
    ,ctl_cancelflow -- 被撤单流水号（理财交易填写）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tbps_cpr_tranflow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tbps_cpr_tranflow exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_tranflow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_tranflow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tbps_cpr_tranflow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_tranflow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);