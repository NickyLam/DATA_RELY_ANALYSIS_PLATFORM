/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_payoff_withhold_tran_info_ncbsi1
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
drop table ${iml_schema}.evt_batch_payoff_withhold_tran_info_ncbsi1_tm purge;
alter table ${iml_schema}.evt_batch_payoff_withhold_tran_info add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_payoff_withhold_tran_info modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_payoff_withhold_tran_info_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_batch_no -- 业务批次号
    ,dep_agt_id -- 存款协议编号
    ,payoff_withhold_idf_cd -- 代发代扣标识代码
    ,batch_proc_begin_tm -- 批次处理起始时间
    ,batch_proc_termnt_tm -- 批次处理终止时间
    ,batch_proc_status_cd -- 批次处理状态代码
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,batch_fail_rs -- 批处理失败原因
    ,fail_rs -- 失败原因
    ,tran_teller_id -- 交易柜员编号
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_payoff_withhold_tran_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_agency_info-1
insert into ${iml_schema}.evt_batch_payoff_withhold_tran_info_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_batch_no -- 业务批次号
    ,dep_agt_id -- 存款协议编号
    ,payoff_withhold_idf_cd -- 代发代扣标识代码
    ,batch_proc_begin_tm -- 批次处理起始时间
    ,batch_proc_termnt_tm -- 批次处理终止时间
    ,batch_proc_status_cd -- 批次处理状态代码
    ,acct_id -- 账户编号
    ,lmt_id -- 限制编号
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,batch_fail_rs -- 批处理失败原因
    ,fail_rs -- 失败原因
    ,tran_teller_id -- 交易柜员编号
    ,cust_id -- 客户编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101049'||P1.BATCH_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.BATCH_NO -- 业务批次号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.AGENCY_TYPE -- 代发代扣标识代码
    ,to_timestamp(trim(P1.BATCH_START_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 批次处理起始时间
    ,to_timestamp(trim(P1.BATCH_END_TIME),'yyyy-mm-dd hh24:mi:ss.ff6') -- 批次处理终止时间
    ,P1.BATCH_STATUS -- 批次处理状态代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.CCY -- 币种代码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.BATCH_FAILURE_REASON -- 批处理失败原因
    ,P1.FAILURE_REASON -- 失败原因
    ,P1.USER_ID -- 交易柜员编号
    ,P1.CLIENT_NO -- 客户编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agency_info' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agency_info p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_payoff_withhold_tran_info truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_payoff_withhold_tran_info exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_batch_payoff_withhold_tran_info_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_payoff_withhold_tran_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_payoff_withhold_tran_info_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_payoff_withhold_tran_info', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);