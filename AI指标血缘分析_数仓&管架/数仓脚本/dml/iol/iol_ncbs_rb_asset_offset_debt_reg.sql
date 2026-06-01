/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_asset_offset_debt_reg
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
drop table ${iol_schema}.ncbs_rb_asset_offset_debt_reg_ex purge;
alter table ${iol_schema}.ncbs_rb_asset_offset_debt_reg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_asset_offset_debt_reg truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_asset_offset_debt_reg_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_asset_offset_debt_reg where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_asset_offset_debt_reg_ex(
    base_acct_no -- 交易账号/卡号
    ,acct_desc -- 账户描述
    ,prod_type -- 产品编号
    ,ccy -- 账户币种
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,individual_flag -- 对公对私标志
    ,branch -- 开户机构编号
    ,amt_type -- 金额类型
    ,balance -- 金额
    ,cr_dr_ind -- 借贷标志
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_tran_name -- 真实交易对手名称
    ,reference -- 交易参考号
    ,channel_seq_no -- 全局流水号
    ,reversal_flag -- 交易是否已冲正
    ,gl_posted_flag -- 过账标记
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no -- 交易账号/卡号
    ,acct_desc -- 账户描述
    ,prod_type -- 产品编号
    ,ccy -- 账户币种
    ,internal_key -- 账户内部键值
    ,client_no -- 客户编号
    ,individual_flag -- 对公对私标志
    ,branch -- 开户机构编号
    ,amt_type -- 金额类型
    ,balance -- 金额
    ,cr_dr_ind -- 借贷标志
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_tran_name -- 真实交易对手名称
    ,reference -- 交易参考号
    ,channel_seq_no -- 全局流水号
    ,reversal_flag -- 交易是否已冲正
    ,gl_posted_flag -- 过账标记
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_asset_offset_debt_reg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_asset_offset_debt_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_asset_offset_debt_reg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_asset_offset_debt_reg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_asset_offset_debt_reg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_asset_offset_debt_reg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);