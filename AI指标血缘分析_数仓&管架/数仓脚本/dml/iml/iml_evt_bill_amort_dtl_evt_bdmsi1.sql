/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_amort_dtl_evt_bdmsi1
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
drop table ${iml_schema}.evt_bill_amort_dtl_evt_bdmsi1_tm purge;
alter table ${iml_schema}.evt_bill_amort_dtl_evt add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bill_amort_dtl_evt modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_amort_dtl_evt_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,amort_dtl_id -- 摊销明细编号
    ,bill_id -- 票据编号
    ,core_entry_tran_id -- 核心记账交易编号
    ,provi_type_cd -- 计提类型代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,provi_org_id -- 计提机构编号
    ,provi_int -- 计提利息
    ,provi_int_comp_int -- 计提利息复利
    ,provi_pnlt -- 计提罚息
    ,provi_pnlt_comp_int -- 计提罚息复利
    ,amort_id -- 摊销编号
    ,core_rgst_cd -- 核心登记代码
    ,sys_track_no -- 系统跟踪号
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_amort_dtl_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_tla_lnpreintrlog-
insert into ${iml_schema}.evt_bill_amort_dtl_evt_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,amort_dtl_id -- 摊销明细编号
    ,bill_id -- 票据编号
    ,core_entry_tran_id -- 核心记账交易编号
    ,provi_type_cd -- 计提类型代码
    ,plan_pd -- 计划期次
    ,provi_dt -- 计提日期
    ,provi_org_id -- 计提机构编号
    ,provi_int -- 计提利息
    ,provi_int_comp_int -- 计提利息复利
    ,provi_pnlt -- 计提罚息
    ,provi_pnlt_comp_int -- 计提罚息复利
    ,amort_id -- 摊销编号
    ,core_rgst_cd -- 核心登记代码
    ,sys_track_no -- 系统跟踪号
    ,dr_subj_id -- 借方科目编号
    ,cr_subj_id -- 贷方科目编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102025'||TO_CHAR(P1.PRVDT)||TO_CHAR(P1.ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ID) -- 摊销明细编号
    ,TO_CHAR(P1.DRAFTID) -- 票据编号
    ,TO_CHAR(P1.ACCOUNTLOGID) -- 核心记账交易编号
    ,NVL(TRIM(P1.LNPRVTYPE),'0') -- 计提类型代码
    ,P1.PLANPERI -- 计划期次
    ,P1.PRVDT -- 计提日期
    ,P1.BRCD -- 计提机构编号
    ,P1.PRVINT -- 计提利息
    ,P1.PRVCINT -- 计提利息复利
    ,P1.PRVPINT -- 计提罚息
    ,P1.PRVCPINT -- 计提罚息复利
    ,TO_CHAR(P1.LNPREINTRID) -- 摊销编号
    ,P1.COREFLAG -- 核心登记代码
    ,P1.TRACENO -- 系统跟踪号
    ,P1.DBSUBJ -- 借方科目编号
    ,P1.CRSUBJ -- 贷方科目编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_tla_lnpreintrlog' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_tla_lnpreintrlog p1
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bill_amort_dtl_evt truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bill_amort_dtl_evt exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_amort_dtl_evt_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_amort_dtl_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bill_amort_dtl_evt_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_amort_dtl_evt', partname => 'p_bdmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);