/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_int_provi_dtl_myjbi2
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
drop table ${iml_schema}.agt_ajb_int_provi_dtl_myjbi2_tm purge;
alter table ${iml_schema}.agt_ajb_int_provi_dtl add partition p_myjbi2 values ('myjbi2')(
        subpartition p_myjbi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_int_provi_dtl modify partition p_myjbi2
    add subpartition p_myjbi2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_int_provi_dtl_myjbi2_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,int_accr_dt -- 计息日期
    ,acru_non_acru_idf -- 应计非应计标识
    ,ovdue_int_bal -- 逾期利息余额
    ,loan_pnlt_day_int_rat -- 贷款罚息日利率
    ,nomal_int_amt -- 正常利息金额
    ,ovdue_pric_pnlt -- 逾期本金罚息
    ,ovdue_int_pnlt -- 逾期利息罚息
    ,wrt_off_flg -- 核销标志
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_int_provi_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_myjb_loan_calc-
insert into ${iml_schema}.agt_ajb_int_provi_dtl_myjbi2_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,int_accr_dt -- 计息日期
    ,acru_non_acru_idf -- 应计非应计标识
    ,ovdue_int_bal -- 逾期利息余额
    ,loan_pnlt_day_int_rat -- 贷款罚息日利率
    ,nomal_int_amt -- 正常利息金额
    ,ovdue_pric_pnlt -- 逾期本金罚息
    ,ovdue_int_pnlt -- 逾期利息罚息
    ,wrt_off_flg -- 核销标志
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222620'||P1.CONTRACT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTRACT_NO -- 借据编号
    ,${iml_schema}.dateformat_max2(P1.CALC_DATE) -- 计息日期
    ,P1.ACCRUED_STATUS -- 应计非应计标识
    ,P1.OVD_INT_BAL/100 -- 逾期利息余额
    ,P1.REAL_RATE*100 -- 贷款罚息日利率
    ,P1.INT_AMT/100 -- 正常利息金额
    ,P1.OVD_PRIN_PNLT_AMT/100 -- 逾期本金罚息
    ,P1.OVD_INT_PNLT_AMT/100 -- 逾期利息罚息
    ,P1.WRITE_OFF -- 核销标志
    ,P1.PRIN_BAL/100 -- 正常本金余额
    ,P1.OVD_PRIN_BAL/100 -- 逾期本金余额
    ,P1.REAL_RATE*100 -- 贷款实际日利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myjb_loan_calc' -- 源表名称
    ,'myjbi2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myjb_loan_calc p1
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
and P1.calc_date='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_ajb_int_provi_dtl truncate subpartition p_myjbi2_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_int_provi_dtl exchange subpartition p_myjbi2_${batch_date} with table ${iml_schema}.agt_ajb_int_provi_dtl_myjbi2_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_int_provi_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ajb_int_provi_dtl_myjbi2_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_int_provi_dtl', partname => 'p_myjbi2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);