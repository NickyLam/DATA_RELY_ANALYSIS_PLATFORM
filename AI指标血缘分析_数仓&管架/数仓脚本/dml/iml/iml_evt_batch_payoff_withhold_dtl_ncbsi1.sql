/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_payoff_withhold_dtl_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_batch_payoff_withhold_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_batch_payoff_withhold_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_payoff_withhold_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_payoff_withhold_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_batch_no -- 业务批次号
    ,seq_num -- 序号
    ,payoff_withhold_idf_cd -- 代发代扣标识代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,tran_amt -- 交易金额
    ,cust_addr -- 客户地址
    ,postsc -- 附言
    ,batch_proc_status_cd -- 批次处理状态代码
    ,fail_rs -- 失败原因
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_payoff_withhold_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_agency_details-1
insert into ${iml_schema}.evt_batch_payoff_withhold_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_batch_no -- 业务批次号
    ,seq_num -- 序号
    ,payoff_withhold_idf_cd -- 代发代扣标识代码
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_name -- 账户名称
    ,tran_amt -- 交易金额
    ,cust_addr -- 客户地址
    ,postsc -- 附言
    ,batch_proc_status_cd -- 批次处理状态代码
    ,fail_rs -- 失败原因
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101049'||P1.BATCH_NO||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_NO -- 业务批次号
    ,P1.SEQ_NO -- 序号
    ,P1.AGENCY_TYPE -- 代发代扣标识代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.TRAN_AMT -- 交易金额
    ,P1.ADDRESS -- 客户地址
    ,P1.COMMENTS -- 附言
    ,P1.BATCH_STATUS -- 批次处理状态代码
    ,P1.FAILURE_REASON -- 失败原因
    ,P1.CLIENT_NO -- 客户编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agency_details' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agency_details p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_payoff_withhold_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_payoff_withhold_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_batch_payoff_withhold_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_payoff_withhold_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_payoff_withhold_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_payoff_withhold_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);