/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifds_card_bind_history
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
drop table ${iol_schema}.ifds_card_bind_history_ex purge;
alter table ${iol_schema}.ifds_card_bind_history add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ifds_card_bind_history;

-- 2.3 insert data to ex table
create table ${iol_schema}.ifds_card_bind_history_ex nologging
compress
as
select * from ${iol_schema}.ifds_card_bind_history where 0=1;

insert /*+ append */ into ${iol_schema}.ifds_card_bind_history_ex(
    tran_seq_no -- 交易流水
    ,billing_account_id -- e账户编号
    ,card_no -- 卡号
    ,card_name -- 户名
    ,customer_no -- 客户号
    ,card_type_id -- 卡类型
    ,other_bank_flag -- 本他行标志
    ,bank_offices_no -- 绑卡开户网点
    ,bind_date -- 绑定时间
    ,operate_time -- 操作时间
    ,status_id -- 状态
    ,amount -- 预绑金额
    ,simp_pay_flag -- 是否快捷支付
    ,bank_number -- 归属行
    ,bank_name -- 行名
    ,third_party_id -- 商户号
    ,third_party_name -- 商户名称
    ,channel -- 通道
    ,cancel_date -- 状态结束日期
    ,account_type -- 账户类型
    ,card_flag -- 卡类型
    ,limited_amount -- 限额
    ,is_limiteo -- 是否限额
    ,default_card -- 是否默认卡
    ,business_type -- 业务类型
    ,financial_institution_code -- 开户银行金融机构编码
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tran_seq_no -- 交易流水
    ,billing_account_id -- e账户编号
    ,card_no -- 卡号
    ,card_name -- 户名
    ,customer_no -- 客户号
    ,card_type_id -- 卡类型
    ,other_bank_flag -- 本他行标志
    ,bank_offices_no -- 绑卡开户网点
    ,bind_date -- 绑定时间
    ,operate_time -- 操作时间
    ,status_id -- 状态
    ,amount -- 预绑金额
    ,simp_pay_flag -- 是否快捷支付
    ,bank_number -- 归属行
    ,bank_name -- 行名
    ,third_party_id -- 商户号
    ,third_party_name -- 商户名称
    ,channel -- 通道
    ,cancel_date -- 状态结束日期
    ,account_type -- 账户类型
    ,card_flag -- 卡类型
    ,limited_amount -- 限额
    ,is_limiteo -- 是否限额
    ,default_card -- 是否默认卡
    ,business_type -- 业务类型
    ,financial_institution_code -- 开户银行金融机构编码
    ,last_updated_stamp -- 最后更新时间
    ,last_updated_tx_stamp -- 最后更新事务时间
    ,created_stamp -- 创建时间
    ,created_tx_stamp -- 创建事务时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifds_card_bind_history
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifds_card_bind_history exchange partition p_${batch_date} with table ${iol_schema}.ifds_card_bind_history_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifds_card_bind_history to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifds_card_bind_history_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifds_card_bind_history',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);