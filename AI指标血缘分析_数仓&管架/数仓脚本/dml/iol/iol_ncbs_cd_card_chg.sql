/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_chg
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
drop table ${iol_schema}.ncbs_cd_card_chg_ex purge;
alter table ${iol_schema}.ncbs_cd_card_chg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cd_card_chg truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cd_card_chg_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_chg where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cd_card_chg_ex(
    address -- 地址
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,card_change_reason -- 卡片更换原因
    ,change_status -- 变更类型状态
    ,company -- 法人
    ,contact_tel -- 客户联系电话
    ,gain_type -- 卡片领取方式
    ,lost_no -- 挂失编号
    ,postal_code -- 邮政编码
    ,same_no_flag -- 同号换卡标识
    ,urgent_flag -- 加急标识
    ,apply_date -- 申请日期
    ,promissory_date -- 约定的领卡日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,apply_user_id -- 申请柜员
    ,new_card_no -- 新卡号
    ,old_card_no -- 原卡号
    ,tran_branch -- 核心交易机构编号
    ,deal_status -- 处理状态
    ,msg_notice_type -- 通知类型
    ,fee_reference -- 
    ,package_no -- 
    ,apply_no -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    address -- 地址
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,card_change_reason -- 卡片更换原因
    ,change_status -- 变更类型状态
    ,company -- 法人
    ,contact_tel -- 客户联系电话
    ,gain_type -- 卡片领取方式
    ,lost_no -- 挂失编号
    ,postal_code -- 邮政编码
    ,same_no_flag -- 同号换卡标识
    ,urgent_flag -- 加急标识
    ,apply_date -- 申请日期
    ,promissory_date -- 约定的领卡日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,apply_user_id -- 申请柜员
    ,new_card_no -- 新卡号
    ,old_card_no -- 原卡号
    ,tran_branch -- 核心交易机构编号
    ,deal_status -- 处理状态
    ,msg_notice_type -- 通知类型
    ,fee_reference -- 
    ,package_no -- 
    ,apply_no -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cd_card_chg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cd_card_chg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cd_card_chg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cd_card_chg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cd_card_chg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cd_card_chg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);