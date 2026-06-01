/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cpes_provi_dtl_bdmsi1
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
drop table ${iml_schema}.evt_cpes_provi_dtl_bdmsi1_tm purge;
alter table ${iml_schema}.evt_cpes_provi_dtl add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cpes_provi_dtl modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cpes_provi_dtl_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_dtl_id -- 计提明细编号
    ,provi_mtbl_id -- 计提主表编号
    ,provi_entry_id -- 计提记账编号
    ,bill_id -- 票据编号
    ,td_provi_int -- 当日计提利息
    ,entry_sucs_flg -- 记账成功标志
    ,entry_dt -- 记账日期
    ,org_id -- 机构编号
    ,bus_prod_id -- 业务产品编号
    ,int_income_subj_id -- 利息收入科目编号
    ,provi_post_subj_id -- 计提后科目编号
    ,sys_track_no -- 系统跟踪号
    ,provi_type_cd -- 计提类型代码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cpes_provi_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_bms_provision_detail-
insert into ${iml_schema}.evt_cpes_provi_dtl_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,provi_dtl_id -- 计提明细编号
    ,provi_mtbl_id -- 计提主表编号
    ,provi_entry_id -- 计提记账编号
    ,bill_id -- 票据编号
    ,td_provi_int -- 当日计提利息
    ,entry_sucs_flg -- 记账成功标志
    ,entry_dt -- 记账日期
    ,org_id -- 机构编号
    ,bus_prod_id -- 业务产品编号
    ,int_income_subj_id -- 利息收入科目编号
    ,provi_post_subj_id -- 计提后科目编号
    ,sys_track_no -- 系统跟踪号
    ,provi_type_cd -- 计提类型代码
    ,bill_sub_intrv_id -- 票据子区间编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104008'||P1.ACCT_DT||P1.PROV_DE_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.PROV_DE_ID -- 计提明细编号
    ,P1.PROV_ID -- 计提主表编号
    ,P1.PROV_ACCT_ID -- 计提记账编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.TPROV_INTEREST -- 当日计提利息
    ,nvl(trim(P1.IS_SUCCESS),'-') -- 记账成功标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCT_DT) -- 记账日期
    ,P1.BRCH_NO -- 机构编号
    ,P1.PRODUCT_NO -- 业务产品编号
    ,CASE WHEN P1.IT_IN_SUBJECT_NO= 'AB2001' THEN '20111003' WHEN P1.IT_IN_SUBJECT_NO= 'IA2011010101' THEN '20110101' ELSE NVL(P2.SUBJ_NO,' ') END -- 利息收入科目编号
    ,CASE WHEN P1.IT_BACK_SUBJECT_NO= 'AB2001' THEN '20111003' WHEN P1.IT_BACK_SUBJECT_NO= 'IA2011010101' THEN '20110101' ELSE NVL(P3.SUBJ_NO,' ') END -- 计提后科目编号
    ,P1.RESERVE3 -- 系统跟踪号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.JITI_TYPE END -- 计提类型代码
    ,P1.CD_RANGE -- 票据子区间编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_provision_detail' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_provision_detail p1
    left join ${iol_schema}.bdms_cpes_subj_busicode p2 on P1.IT_IN_SUBJECT_NO=P2.BUSI_CODE AND P2.start_dt <= TO_DATE('${batch_date}','yyyymmdd') and P2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_subj_busicode p3 on P1.IT_BACK_SUBJECT_NO=P3.BUSI_CODE AND P3.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P3.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.JITI_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_PROVISION_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'JITI_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CPES_PROVI_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROVI_TYPE_CD'
where  1 = 1 
    and p1.acct_dt='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_cpes_provi_dtl truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cpes_provi_dtl exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_cpes_provi_dtl_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cpes_provi_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cpes_provi_dtl_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cpes_provi_dtl', partname => 'p_bdmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);