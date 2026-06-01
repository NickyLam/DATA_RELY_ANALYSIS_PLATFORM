/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_drawdown
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
drop table ${iol_schema}.ncbs_cl_drawdown_ex purge;
alter table ${iol_schema}.ncbs_cl_drawdown add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_cl_drawdown;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_drawdown_ex nologging
compress
as
select * from ${iol_schema}.ncbs_cl_drawdown where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_drawdown_ex(
    ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,cmisloan_no -- 客户借据编号
    ,company -- 法人
    ,counter -- 序号
    ,dac_value -- dac值防篡改加密
    ,dd_method -- 发放方式
    ,event_type -- 事件类型
    ,is_one_dd_flag -- 是否一次性开立发放
    ,lender -- 贷款人
    ,reversal -- 是否冲正标志
    ,dd_date -- 贷款发放日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,dd_amt -- 发放金额
    ,distinct_int -- 贷款贴现利息
    ,loan_no -- 贷款号
    ,reversal_reason -- 冲正原因
    ,reversal_user_id -- 冲正柜员
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,cmisloan_no -- 客户借据编号
    ,company -- 法人
    ,counter -- 序号
    ,dac_value -- dac值防篡改加密
    ,dd_method -- 发放方式
    ,event_type -- 事件类型
    ,is_one_dd_flag -- 是否一次性开立发放
    ,lender -- 贷款人
    ,reversal -- 是否冲正标志
    ,dd_date -- 贷款发放日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,dd_amt -- 发放金额
    ,distinct_int -- 贷款贴现利息
    ,loan_no -- 贷款号
    ,reversal_reason -- 冲正原因
    ,reversal_user_id -- 冲正柜员
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_drawdown
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_drawdown exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_drawdown_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_drawdown to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_drawdown_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_drawdown',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);