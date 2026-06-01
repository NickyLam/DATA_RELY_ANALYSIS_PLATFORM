/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_manual_entry_evt_ibmsi1
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
drop table ${iml_schema}.evt_ibank_manual_entry_evt_ibmsi1_tm purge;
alter table ${iml_schema}.evt_ibank_manual_entry_evt add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ibank_manual_entry_evt modify partition p_ibmsi1
    add subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_manual_entry_evt_ibmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rec_id -- 记录ID
    ,entry_dt -- 记账日期
    ,bus_org_id -- 业务机构编号
    ,entry_flow_num -- 分录流水号
    ,core_flow_num -- 核心流水号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_teller_name -- 登记柜员名称
    ,entry_teller_id -- 记账柜员编号
    ,entry_teller_name -- 记账柜员名称
    ,rgst_tm -- 登记时间
    ,entry_tm -- 记账时间
    ,entry_status_cd -- 记账状态代码
    ,remark -- 备注
    ,check_teller_id -- 复核柜员编号
    ,check_teller_name -- 复核柜员名称
    ,entry_type_cd -- 记账类型代码
    ,tran_id -- 交易编号
    ,entry_idf_cd -- 记账标识代码
    ,accti_bal_id -- 核算余额ID
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_manual_entry_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ibms_ttrd_manual_bk_record-1
insert into ${iml_schema}.evt_ibank_manual_entry_evt_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rec_id -- 记录ID
    ,entry_dt -- 记账日期
    ,bus_org_id -- 业务机构编号
    ,entry_flow_num -- 分录流水号
    ,core_flow_num -- 核心流水号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_teller_name -- 登记柜员名称
    ,entry_teller_id -- 记账柜员编号
    ,entry_teller_name -- 记账柜员名称
    ,rgst_tm -- 登记时间
    ,entry_tm -- 记账时间
    ,entry_status_cd -- 记账状态代码
    ,remark -- 备注
    ,check_teller_id -- 复核柜员编号
    ,check_teller_name -- 复核柜员名称
    ,entry_type_cd -- 记账类型代码
    ,tran_id -- 交易编号
    ,entry_idf_cd -- 记账标识代码
    ,accti_bal_id -- 核算余额ID
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105007'||P1.RECORD_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.RECORD_ID -- 记录ID
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ACCOUNT_DATE) -- 记账日期
    ,P1.BKKPG_ORG_ID -- 业务机构编号
    ,P1.FLOW_ID -- 分录流水号
    ,P1.HOSTFLOW_NO -- 核心流水号
    ,P1.CREATE_USER -- 登记柜员编号
    ,P1.CREATE_USER_NAME -- 登记柜员名称
    ,P1.ACCT_USER -- 记账柜员编号
    ,P1.ACCT_USER_NAME -- 记账柜员名称
    ,${iml_schema}.TIMEFORMAT_MIN(P1.CREATE_TIME) -- 登记时间
    ,${iml_schema}.TIMEFORMAT_MIN(P1.ACCOUNT_TIME) -- 记账时间
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STATE END -- 记账状态代码
    ,P1.REMARK -- 备注
    ,P1.ACCT_REVIEW_USER -- 复核柜员编号
    ,P1.ACCT_REVIEW_USER_NAME -- 复核柜员名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCT_TYPE END -- 记账类型代码
    ,p1.TRADE_ID -- 交易编号
    ,P1.BK_FLAG -- 记账标识代码
    ,P1.OBJ_ID -- 核算余额ID
    ,P1.PARTY_ID -- 交易对手编号
    ,P1.PARTY_NAME -- 交易对手名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_manual_bk_record' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_manual_bk_record p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STATE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_MANUAL_BK_RECORD'
        AND R1.SRC_FIELD_EN_NAME= 'STATE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_MANUAL_ENTRY_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCT_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IBMS'
        AND R2.SRC_TAB_EN_NAME= 'IBMS_TTRD_MANUAL_BK_RECORD'
        AND R2.SRC_FIELD_EN_NAME= 'ACCT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_IBANK_MANUAL_ENTRY_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD'
where  1 = 1 
    AND TO_DATE(P1.account_date,'YYYY-MM-DD') = TO_DATE('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ibank_manual_entry_evt truncate subpartition p_ibmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ibank_manual_entry_evt exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_manual_entry_evt_ibmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_manual_entry_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ibank_manual_entry_evt_ibmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_manual_entry_evt', partname => 'p_ibmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);