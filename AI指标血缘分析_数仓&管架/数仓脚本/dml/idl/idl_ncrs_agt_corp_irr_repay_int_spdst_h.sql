/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ncrs_agt_corp_irr_repay_int_spdst_h
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h drop partition p_${last_date};
alter table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h (
    etl_dt --数据日期
   ,agt_id --协议编号
   ,lp_id --法人编号
   ,dubil_id --借据编号
   ,exec_dt --执行日期
   ,curr_cd --币种代码
   ,value_dt --起息日期
   ,acru_nomal_pric --应计正常本金
   ,curr_issue_recvbl_pric --本期应收本金
   ,curr_issue_int_recvbl --本期应收利息
   ,start_dt --开始时间
   ,end_dt --结束时间
   ,id_mark --增删标志
   ,src_table_name --源表名称
   ,job_cd --任务编码
   ,etl_timestamp --ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt	--数据日期
   ,P1.agt_id	--协议编号
   ,P1.lp_id	--法人编号
   ,P1.dubil_id	--借据编号
   ,P1.exec_dt	--执行日期
   ,P1.curr_cd	--币种代码
   ,P1.value_dt	--起息日期
   ,P1.acru_nomal_pric	--应计正常本金
   ,P1.curr_issue_recvbl_pric	--本期应收本金
   ,P1.curr_issue_int_recvbl	--本期应收利息
   ,P1.start_dt	--开始时间
   ,P1.end_dt	--结束时间
   ,P1.id_mark	--增删标志
   ,P1.src_table_name	--源表名称
   ,P1.job_cd	--任务编码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp	--ETL处理时间戳
from ${iml_schema}.agt_corp_irr_repay_int_spdst_h  p1   --公司不规则还款利息试算历史
where start_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ncrs_agt_corp_irr_repay_int_spdst_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);