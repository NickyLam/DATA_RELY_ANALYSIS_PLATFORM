/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_eqpt_cash_tran_hist
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
drop table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist_ex(
    amount -- 金额
    ,branch -- 机构编号
    ,ccy -- 币种
    ,company -- 法人
    ,reserve_flag -- 冲正标志
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,eqpt_seq_no -- 自助设备交易编号
    ,virtual_user_id -- 虚拟柜员代号
    ,virtual_tailbox_id -- 虚拟柜员柜员尾箱id
    ,teller_user_id -- 自助设备出库真实柜员
    ,teller_trailbox_id -- 自助设备出库真实柜员尾箱
    ,rec_amount -- 收入金额
    ,pay_amount -- 付出金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amount -- 金额
    ,branch -- 机构编号
    ,ccy -- 币种
    ,company -- 法人
    ,reserve_flag -- 冲正标志
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,eqpt_seq_no -- 自助设备交易编号
    ,virtual_user_id -- 虚拟柜员代号
    ,virtual_tailbox_id -- 虚拟柜员柜员尾箱id
    ,teller_user_id -- 自助设备出库真实柜员
    ,teller_trailbox_id -- 自助设备出库真实柜员尾箱
    ,rec_amount -- 收入金额
    ,pay_amount -- 付出金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_tb_eqpt_cash_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_eqpt_cash_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);