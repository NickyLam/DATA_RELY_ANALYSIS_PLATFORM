/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_cash_sign
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
drop table ${iol_schema}.ncbs_tb_cash_sign_ex purge;
alter table ${iol_schema}.ncbs_tb_cash_sign add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_tb_cash_sign;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_tb_cash_sign_ex nologging
compress
as
select * from ${iol_schema}.ncbs_tb_cash_sign where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_tb_cash_sign_ex(
    ccy -- 币种
    ,reference -- 交易参考号
    ,cash_sign_type -- 长短款标记
    ,cash_sign_id -- 现金长短款汇总编号
    ,cash_sign_status -- 现金状态
    ,company -- 法人
    ,cash_sign_amt -- 长短款金额(ovg)
    ,reserve_flag -- 冲正标志
    ,seq_no -- 序号
    ,tailbox_id -- 尾箱代号
    ,cash_sign_date -- 现金长短款挂账日期
    ,tran_timestamp -- 交易时间戳
    ,cash_sign_user -- 长短款登记柜员
    ,leaderr_cash_branch -- 导致长短钞差错机构
    ,leaderr_user_id -- 导致长短钞差错柜员
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,reference -- 交易参考号
    ,cash_sign_type -- 长短款标记
    ,cash_sign_id -- 现金长短款汇总编号
    ,cash_sign_status -- 现金状态
    ,company -- 法人
    ,cash_sign_amt -- 长短款金额(ovg)
    ,reserve_flag -- 冲正标志
    ,seq_no -- 序号
    ,tailbox_id -- 尾箱代号
    ,cash_sign_date -- 现金长短款挂账日期
    ,tran_timestamp -- 交易时间戳
    ,cash_sign_user -- 长短款登记柜员
    ,leaderr_cash_branch -- 导致长短钞差错机构
    ,leaderr_user_id -- 导致长短钞差错柜员
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_tb_cash_sign
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_tb_cash_sign exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_cash_sign_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_cash_sign to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_tb_cash_sign_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_cash_sign',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);