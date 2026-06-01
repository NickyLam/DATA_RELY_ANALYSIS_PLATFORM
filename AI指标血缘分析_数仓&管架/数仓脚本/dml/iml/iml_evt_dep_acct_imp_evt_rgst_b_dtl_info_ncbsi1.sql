/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1
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
drop table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1_tm purge;
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dtl_seq_num -- 批次明细序号
    ,flow_num -- 流水号
    ,tran_seq_num -- 交易序号
    ,redt_type_cd -- 转存类型代码
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,tax_amt -- 税金
    ,int_rat_type_cd -- 利率类型代码
    ,exec_int_rat -- 执行利率
    ,next_get_int_dt -- 下一取息日期
    ,cntpty_acct_id -- 交易对手账户编号
    ,int_status_cd -- 利息状态代码
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_acct_event_register_dtls-1
insert into ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_dtl_seq_num -- 批次明细序号
    ,flow_num -- 流水号
    ,tran_seq_num -- 交易序号
    ,redt_type_cd -- 转存类型代码
    ,cust_id -- 客户编号
    ,tran_dt -- 交易日期
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,tax_amt -- 税金
    ,int_rat_type_cd -- 利率类型代码
    ,exec_int_rat -- 执行利率
    ,next_get_int_dt -- 下一取息日期
    ,cntpty_acct_id -- 交易对手账户编号
    ,int_status_cd -- 利息状态代码
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101047'||P1.INTERNAL_KEY||P1.BATCH_SEQ_NO||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_SEQ_NO -- 批次明细序号
    ,P1.SEQ_NO -- 流水号
    ,P1.TRAN_SEQ_NO -- 交易序号
    ,P1.MOVT_STATUS -- 转存类型代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.TAX_AMT -- 税金
    ,P1.INT_TYPE -- 利率类型代码
    ,P1.INT_RATE -- 执行利率
    ,P1.INT_END_DATE -- 下一取息日期
    ,P1.THIRD_PARTY_INTERNAL_KEY -- 交易对手账户编号
    ,P1.INT_STATUS -- 利息状态代码
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_event_register_dtls' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_event_register_dtls p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_dep_acct_imp_evt_rgst_b_dtl_info_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_dep_acct_imp_evt_rgst_b_dtl_info', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);