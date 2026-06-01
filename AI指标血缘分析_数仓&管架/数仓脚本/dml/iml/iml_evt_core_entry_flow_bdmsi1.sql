/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_core_entry_flow_bdmsi1
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
drop table ${iml_schema}.evt_core_entry_flow_bdmsi1_tm purge;
alter table ${iml_schema}.evt_core_entry_flow add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_core_entry_flow modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_core_entry_flow_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,entry_cancel_flg -- 记账取消标志
    ,entry_flow_num -- 记账流水号
    ,hxp_tran_flg -- 补记交易标志
    ,msg_send_status_cd -- 报文发送状态代码
    ,err_cd -- 错误代码
    ,err_rs -- 错误原因
    ,bus_type_cd -- 业务类型代码
    ,buy_dtl_id -- 买入明细编号
    ,bill_id -- 票据编号
    ,cont_id -- 合同编号
    ,entry_way_cd -- 记账方式代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,forgn_sys_bill_uniq_ind_no -- 对外系统票据唯一标识号
    ,entry_step_seq_num -- 记账步骤序号
    ,sugst_pay_appl_flow_num -- 提示付款申请流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_core_entry_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_account_log-
insert into ${iml_schema}.evt_core_entry_flow_bdmsi1_tm(
    evt_id -- 事件编号
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,entry_cancel_flg -- 记账取消标志
    ,entry_flow_num -- 记账流水号
    ,hxp_tran_flg -- 补记交易标志
    ,msg_send_status_cd -- 报文发送状态代码
    ,err_cd -- 错误代码
    ,err_rs -- 错误原因
    ,bus_type_cd -- 业务类型代码
    ,buy_dtl_id -- 买入明细编号
    ,bill_id -- 票据编号
    ,cont_id -- 合同编号
    ,entry_way_cd -- 记账方式代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,bill_uniq_ind_no -- 票据唯一标识号
    ,forgn_sys_bill_uniq_ind_no -- 对外系统票据唯一标识号
    ,entry_step_seq_num -- 记账步骤序号
    ,sugst_pay_appl_flow_num -- 提示付款申请流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101003'||P1.TXDATE||TO_CHAR(P1.ID) -- 事件编号
    ,TO_CHAR(P1.ID) -- 交易编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXDATE) -- 交易日期
    ,'9999' -- 法人编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.HCODE -- 记账取消标志
    ,P1.SEQNO -- 记账流水号
    ,P1.ISAGNSTAT -- 补记交易标志
    ,NVL(TRIM(P1.SNDSTAT),'0') -- 报文发送状态代码
    ,P1.ERRCD -- 错误代码
    ,P1.ERRRSN -- 错误原因
    ,NVL(TRIM(P1.BIZ_TYPE),'00') -- 业务类型代码
    ,TO_CHAR(P1.DETAIL_ID) -- 买入明细编号
    ,TO_CHAR(P1.DRAFT_ID) -- 票据编号
    ,TO_CHAR(P1.CONTRACT_ID) -- 合同编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_MODE END -- 记账方式代码
    ,NVL(TO_CHAR(P2.OPR_NO),' ') -- 最后修改操作员编号
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,P1.DATA_ID -- 票据唯一标识号
    ,P1.ORDA_ID -- 对外系统票据唯一标识号
    ,P1.SUBSTEP -- 记账步骤序号
    ,TO_CHAR(P1.SWT_BIZ_ID) -- 提示付款申请流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_account_log' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_account_log p1
    left join ${iol_schema}.bdms_operator p2 on P1.LAST_UPD_OPER_ID=P2.ID AND P2.start_dt <= TO_DATE('${batch_date}','yyyymmdd') and P2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_MODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_ACCOUNT_LOG'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_MODE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_CORE_ENTRY_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_WAY_CD'
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_core_entry_flow truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_core_entry_flow exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_core_entry_flow_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_core_entry_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_core_entry_flow_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_core_entry_flow', partname => 'p_bdmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);