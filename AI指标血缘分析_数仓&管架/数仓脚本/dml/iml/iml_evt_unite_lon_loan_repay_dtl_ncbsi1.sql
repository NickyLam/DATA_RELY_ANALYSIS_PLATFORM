/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_unite_lon_loan_repay_dtl_ncbsi1
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
drop table ${iml_schema}.evt_unite_lon_loan_repay_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_unite_lon_loan_repay_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_unite_lon_loan_repay_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_unite_lon_loan_repay_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    
    ,callbk_id -- 回收编号
    ,cust_id -- 客户编号
    ,batch_no -- 批次号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,pric_amt -- 本金金额
    ,int_amt -- 利息金额
    ,comp_int_amt -- 复利金额
    ,pnlt_amt -- 罚息金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_unite_lon_loan_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_ul_receipt_detail-1
insert into ${iml_schema}.evt_unite_lon_loan_repay_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    
    ,callbk_id -- 回收编号
    ,cust_id -- 客户编号
    ,batch_no -- 批次号
    ,dubil_id -- 借据编号
    ,curr_pd -- 当前期次
    ,pric_amt -- 本金金额
    ,int_amt -- 利息金额
    ,comp_int_amt -- 复利金额
    ,pnlt_amt -- 罚息金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102003'||P1.RECEIPT_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.RECEIPT_NO -- 回收编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BATCH_NO -- 批次号
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.STAGE_NO -- 当前期次
    ,P1.PRI_AMT -- 本金金额
    ,P1.INT_AMT -- 利息金额
    ,P1.ODI_AMT -- 复利金额
    ,P1.ODP_AMT -- 罚息金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ul_receipt_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ul_receipt_detail p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_unite_lon_loan_repay_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_unite_lon_loan_repay_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_unite_lon_loan_repay_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_unite_lon_loan_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_unite_lon_loan_repay_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_unite_lon_loan_repay_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);