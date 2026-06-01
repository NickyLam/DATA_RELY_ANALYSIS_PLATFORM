/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ibank_acct_ety_evt_ibmsi1
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
drop table ${iml_schema}.evt_ibank_acct_ety_evt_ibmsi1_tm purge;
alter table ${iml_schema}.evt_ibank_acct_ety_evt add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ibank_acct_ety_evt modify partition p_ibmsi1
    add subpartition p_ibmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ibank_acct_ety_evt_ibmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,task_id -- 任务编号
    ,vouch_dt -- 凭证日期
    ,entry_flow_num -- 分录流水号
    ,chg_id -- 变动编号
    ,instr_id -- 指令编号
    ,bus_org_id -- 业务机构编号
    ,entry_org_id -- 记账机构编号
    ,subj_id -- 科目编号
    ,intnal_acct_seq_num -- 内部账序号
    ,core_acct_id -- 核心账户编号
    ,entry_type_cd -- 记账类型代码
    ,rbw_flg_cd -- 红蓝字标志代码
    ,suspd_wrtoff_way_cd -- 挂销账方式代码
    ,curr_cd -- 币种代码
    ,entry_amt -- 记账金额
    ,sys_status_cd -- 系统状态代码
    ,send_core_acct_flg -- 发送核心账号标志
    ,accti_type_cd -- 核算类型代码
    ,remark -- 备注
    ,core_acct_name -- 核心账户名称
    ,merge_flow_num -- 合并流水号
    ,accti_obj_id -- 核算对象编号
    ,chg_type_cd -- 变动类型代码
    ,dtl_flg -- 明细标志
    ,src_data_type_cd -- 源数据类型代码
    ,send_accti_status_cd -- 发送核算状态代码
    ,manual_vouch_flg -- 手工凭证标志
    ,tax_type_cd -- 征税类型代码
    ,tax_fee -- 税费
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,prod_id	 -- 产品编号
    ,free_tax_id	 -- 免税编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ibank_acct_ety_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ibms_ttrd_bookkeeping_entry_his-
insert into ${iml_schema}.evt_ibank_acct_ety_evt_ibmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,task_id -- 任务编号
    ,vouch_dt -- 凭证日期
    ,entry_flow_num -- 分录流水号
    ,chg_id -- 变动编号
    ,instr_id -- 指令编号
    ,bus_org_id -- 业务机构编号
    ,entry_org_id -- 记账机构编号
    ,subj_id -- 科目编号
    ,intnal_acct_seq_num -- 内部账序号
    ,core_acct_id -- 核心账户编号
    ,entry_type_cd -- 记账类型代码
    ,rbw_flg_cd -- 红蓝字标志代码
    ,suspd_wrtoff_way_cd -- 挂销账方式代码
    ,curr_cd -- 币种代码
    ,entry_amt -- 记账金额
    ,sys_status_cd -- 系统状态代码
    ,send_core_acct_flg -- 发送核心账号标志
    ,accti_type_cd -- 核算类型代码
    ,remark -- 备注
    ,core_acct_name -- 核心账户名称
    ,merge_flow_num -- 合并流水号
    ,accti_obj_id -- 核算对象编号
    ,chg_type_cd -- 变动类型代码
    ,dtl_flg -- 明细标志
    ,src_data_type_cd -- 源数据类型代码
    ,send_accti_status_cd -- 发送核算状态代码
    ,manual_vouch_flg -- 手工凭证标志
    ,tax_type_cd -- 征税类型代码
    ,tax_fee -- 税费
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,prod_id	 -- 产品编号
    ,free_tax_id	 -- 免税编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
     '105001'||replace(P1.ENTRY_DATE,'-','')||P1.TSK_ID||P1.ENTRY_ID -- 事件编号
    ,'9999' -- 法人编号
    ,replace(P1.ENTRY_DATE,'-','')||P1.TSK_ID||P1.ENTRY_ID -- 凭证编号
    ,P1.TSK_ID -- 任务编号
    ,${iml_schema}.dateformat_max(P1.ENTRY_DATE) -- 凭证日期
    ,P1.FLOW_ID -- 分录流水号
    ,P1.CHG_ID -- 变动编号
    ,P1.INST_ID -- 指令编号
    ,P1.BKKPG_ORG_ID -- 业务机构编号
    ,P1.SUBJ_ORG_ID -- 记账机构编号
    ,P1.SUBJ_CODE -- 科目编号
    ,P1.INNER_ACCT_SN -- 内部账序号
    ,P1.CORE_ACCT_CODE -- 核心账户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.STEP END -- 记账类型代码
    ,nvl(trim(P1.RED_BLUE_FLAG_M),'-') -- 红蓝字标志代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PENDING_CANCEL_FLAG END -- 挂销账方式代码
    ,P1.CURRENCY -- 币种代码
    ,P1.VALUE -- 记账金额
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STATE END -- 系统状态代码
    ,P1.IS_SENDING_CORE -- 发送核心账号标志
    ,P1.ESTD_OR_REAL -- 核算类型代码
    ,P1.MEMO -- 备注
    ,P1.CORE_ACCT_NAME -- 核心账户名称
    ,P1.GRP_FLOW_ID -- 合并流水号
    ,P1.ACCTG_OBJ_ID -- 核算对象编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CHG_TYPE END -- 变动类型代码
    ,P1.DETAIL_FLAG -- 明细标志
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SRC_TYPE END -- 源数据类型代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.SEND_STATE END -- 发送核算状态代码
    ,P1.IS_MANUAL -- 手工凭证标志
    ,P1.TAX_TYPE -- 征税类型代码
    ,P1.TAX_VALUE -- 税费
    ,nvl(trim(p1.debit_credit_flag_m),'-') -- 借贷方向代码
    ,p1.ext_dim6	 -- 产品编号
    ,p1.ext_value1	 -- 免税编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_bookkeeping_entry_his' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_bookkeeping_entry_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.STEP= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IBMS'
        AND R1.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'STEP'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PENDING_CANCEL_FLAG= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'IBMS'
        AND R3.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R3.SRC_FIELD_EN_NAME= 'PENDING_CANCEL_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'SUSPD_WRTOFF_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STATE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'IBMS'
        AND R4.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R4.SRC_FIELD_EN_NAME= 'STATE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'SYS_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CHG_TYPE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'IBMS'
        AND R5.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R5.SRC_FIELD_EN_NAME= 'CHG_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CHG_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SRC_TYPE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'IBMS'
        AND R6.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R6.SRC_FIELD_EN_NAME= 'SRC_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'SRC_DATA_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SEND_STATE= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'IBMS'
        AND R7.SRC_TAB_EN_NAME= 'IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'
        AND R7.SRC_FIELD_EN_NAME= 'SEND_STATE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_IBANK_ACCT_ETY_EVT'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'SEND_ACCTI_STATUS_CD'
  where 1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ibank_acct_ety_evt truncate subpartition p_ibmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ibank_acct_ety_evt exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.evt_ibank_acct_ety_evt_ibmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ibank_acct_ety_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ibank_acct_ety_evt_ibmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ibank_acct_ety_evt', partname => 'p_ibmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);