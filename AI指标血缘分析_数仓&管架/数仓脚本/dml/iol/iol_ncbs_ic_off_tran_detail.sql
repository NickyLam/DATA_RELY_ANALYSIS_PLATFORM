/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ic_off_tran_detail
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
drop table ${iol_schema}.ncbs_ic_off_tran_detail_ex purge;
alter table ${iol_schema}.ncbs_ic_off_tran_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ic_off_tran_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ic_off_tran_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_off_tran_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ic_off_tran_detail_ex(
    batch_no -- 脱机批次号
    ,off_tran_seq -- 脱机流水号
    ,internal_key -- 顺序号
    ,card_no -- 卡号
    ,tran_amt -- 交易金额
    ,merch_no -- 商户编号
    ,merch_type -- 商户类型
    ,tran_date -- 平台交易日期
    ,time_stamp -- 交易时间
    ,cups_date -- 银联清算日期
    ,ret_code -- 交易状态码
    ,ret_msg -- 服务状态描述
    ,tran_type -- 交易类型
    ,line -- 行记录
    ,tran_address -- 交易地址
    ,flag -- 调账标志
    ,acct_flag -- 记账标志
    ,settle_date -- 入账日期
    ,term_no -- 交易终端编号
    ,term_seq -- 终端流水号
    ,ic_card_seq -- 卡序列号
    ,ic_aid -- 应用标识符
    ,other_amt -- 其他金额
    ,app_cry -- 应用密文（卡片生成的交易证书tc）
    ,term_coun_code -- 终端国家代码
    ,cups_ccy -- 银联币种
    ,tvr -- 终端验证结果
    ,app_count_num -- 应用交易计数器
    ,not_foreknow_num -- 不可预知数
    ,app_alter_spe -- 应用交互特征
    ,ic_act_bal -- 电子现金账户余额
    ,app_data -- 发卡行应用数据（卡片验证结果cvr在该字段中）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    batch_no -- 脱机批次号
    ,off_tran_seq -- 脱机流水号
    ,internal_key -- 顺序号
    ,card_no -- 卡号
    ,tran_amt -- 交易金额
    ,merch_no -- 商户编号
    ,merch_type -- 商户类型
    ,tran_date -- 平台交易日期
    ,time_stamp -- 交易时间
    ,cups_date -- 银联清算日期
    ,ret_code -- 交易状态码
    ,ret_msg -- 服务状态描述
    ,tran_type -- 交易类型
    ,line -- 行记录
    ,tran_address -- 交易地址
    ,flag -- 调账标志
    ,acct_flag -- 记账标志
    ,settle_date -- 入账日期
    ,term_no -- 交易终端编号
    ,term_seq -- 终端流水号
    ,ic_card_seq -- 卡序列号
    ,ic_aid -- 应用标识符
    ,other_amt -- 其他金额
    ,app_cry -- 应用密文（卡片生成的交易证书tc）
    ,term_coun_code -- 终端国家代码
    ,cups_ccy -- 银联币种
    ,tvr -- 终端验证结果
    ,app_count_num -- 应用交易计数器
    ,not_foreknow_num -- 不可预知数
    ,app_alter_spe -- 应用交互特征
    ,ic_act_bal -- 电子现金账户余额
    ,app_data -- 发卡行应用数据（卡片验证结果cvr在该字段中）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ic_off_tran_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ic_off_tran_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ic_off_tran_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ic_off_tran_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ic_off_tran_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ic_off_tran_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);