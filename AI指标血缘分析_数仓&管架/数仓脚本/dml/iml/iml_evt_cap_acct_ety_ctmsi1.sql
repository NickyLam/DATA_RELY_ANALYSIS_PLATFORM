/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cap_acct_ety_ctmsi1
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
drop table ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm purge;
alter table ${iml_schema}.evt_cap_acct_ety add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cap_acct_ety modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,dc_flg -- 本币标志
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,in_bs_off_bs_cd -- 表内表外代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,subj_id -- 科目编号
    ,entry_amt -- 分录金额
    ,batch_id -- 批处理编号
    ,cntpty_name -- 交易对手名称
    ,subj_descb -- 科目描述
    ,entry_grouping_id -- 分录分组编号
    ,revs_entry_id -- 冲正分录编号
    ,entry_def_id -- 分录定义编号
    ,strk_bal_entry_flg -- 冲账分录标志
    ,bal_dtl_id -- 余额明细编号
    ,curr_cd -- 币种代码
    ,map_subj_id -- 映射科目编号
    ,map_subj_name -- 映射科目名称
    ,subj_map_flg -- 科目映射标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_acct_ety
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ctms_tbs_vs_accentry2-
insert into ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,dc_flg -- 本币标志
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,in_bs_off_bs_cd -- 表内表外代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,subj_id -- 科目编号
    ,entry_amt -- 分录金额
    ,batch_id -- 批处理编号
    ,cntpty_name -- 交易对手名称
    ,subj_descb -- 科目描述
    ,entry_grouping_id -- 分录分组编号
    ,revs_entry_id -- 冲正分录编号
    ,entry_def_id -- 分录定义编号
    ,strk_bal_entry_flg -- 冲账分录标志
    ,bal_dtl_id -- 余额明细编号
    ,curr_cd -- 币种代码
    ,map_subj_id -- 映射科目编号
    ,map_subj_name -- 映射科目名称
    ,subj_map_flg -- 科目映射标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104003'||TO_CHAR(P1.SETTLEDATE)||TO_CHAR(P1.ACCENTRY2_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ACCENTRY2_ID) -- 分录编号
    ,'1' -- 本币标志
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLEDATE) -- 结算日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.INOUTTYPE END -- 表内表外代码
    ,nvl(trim(P1.DEBITCREDIT),'-') -- 借贷方向代码
    ,P1.ACCOUNTINGCODE -- 科目编号
    ,P1.AMOUNT -- 分录金额
    ,P1.BATCHCODE -- 批处理编号
    ,P1.CPTYCODE -- 交易对手名称
    ,P1.ACCOUNTINGDESC -- 科目描述
    ,TO_CHAR(P1.BUNDLECODE) -- 分录分组编号
    ,TO_CHAR(P1.ACCENTRY2_ID_REV) -- 冲正分录编号
    ,TO_CHAR(P1.ACCCODE) -- 分录定义编号
    ,P1.REV_FLAG -- 冲账分录标志
    ,' ' -- 余额明细编号
    ,'-' -- 币种代码
    ,' ' -- 映射科目编号
    ,' ' -- 映射科目名称
    ,'-' -- 科目映射标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_accentry2' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_tbs_vs_accentry2 p1
  left join ${iml_schema}.ref_pub_cd_map r3 
    on P1.INOUTTYPE = R3.SRC_CODE_VAL
   and R3.SORC_SYS_CD= 'CTMS'
   and R3.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_ACCENTRY2'
   and R3.SRC_FIELD_EN_NAME= 'INOUTTYPE'
   and R3.TARGET_TAB_EN_NAME= 'EVT_CAP_ACCT_ETY'
   and R3.TARGET_TAB_FIELD_EN_NAME= 'IN_BS_OFF_BS_CD'
 where p1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and p1.end_dt > to_date('${batch_date}','yyyymmdd')
   and to_char(p1.settledate) = '${batch_date}'
  ;
commit;

-- ctms_fbs_vs_accentry2-
insert into ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,dc_flg -- 本币标志
    ,dept_id -- 部门编号
    ,acct_b_id -- 账簿编号
    ,stl_dt -- 结算日期
    ,in_bs_off_bs_cd -- 表内表外代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,subj_id -- 科目编号
    ,entry_amt -- 分录金额
    ,batch_id -- 批处理编号
    ,cntpty_name -- 交易对手名称
    ,subj_descb -- 科目描述
    ,entry_grouping_id -- 分录分组编号
    ,revs_entry_id -- 冲正分录编号
    ,entry_def_id -- 分录定义编号
    ,strk_bal_entry_flg -- 冲账分录标志
    ,bal_dtl_id -- 余额明细编号
    ,curr_cd -- 币种代码
    ,map_subj_id -- 映射科目编号
    ,map_subj_name -- 映射科目名称
    ,subj_map_flg -- 科目映射标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401030'||TO_CHAR(P1.SETTLEDATE)||TO_CHAR(P1.ACCENTRY2_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ACCENTRY2_ID) -- 分录编号
    ,'0' -- 本币标志
    ,' ' -- 部门编号
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLEDATE) -- 结算日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.INOUTTYPE END -- 表内表外代码
    ,nvl(trim(P1.DEBITCREDIT),'-') -- 借贷方向代码
    ,P1.ACCOUNTINGCODE -- 科目编号
    ,P1.AMOUNT -- 分录金额
    ,' ' -- 批处理编号
    ,' ' -- 交易对手名称
    ,P1.ACCOUNTINGDESC -- 科目描述
    ,' ' -- 分录分组编号
    ,' ' -- 冲正分录编号
    ,TO_CHAR(P1.ACCCODE) -- 分录定义编号
    ,' ' -- 冲账分录标志
    ,TO_CHAR(P1.ALTERBALANCE_ID) -- 余额明细编号
    ,nvl(trim(P1.CURRENCY_TYPE),'-') -- 币种代码
    ,P1.ORI_ACCOUNTING_CODE -- 映射科目编号
    ,P1.ORI_ACCOUNTING_DESC -- 映射科目名称
    ,nvl(trim(P1.IS_MAPPING),'-') -- 科目映射标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_vs_accentry2' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.ctms_fbs_vs_accentry2 p1
  left join ${iml_schema}.ref_pub_cd_map r3
    on p1.inouttype = r3.src_code_val
   and r3.sorc_sys_cd = 'CTMS'
   and r3.src_tab_en_name = 'CTMS_TBS_VS_ACCENTRY2'
   and r3.src_field_en_name = 'INOUTTYPE'
   and r3.target_tab_en_name = 'EVT_CAP_ACCT_ETY'
   and r3.target_tab_field_en_name = 'IN_BS_OFF_BS_CD'
 where to_char(p1.settledate) = '${batch_date}'
 ;
commit;





-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_cap_acct_ety truncate subpartition p_ctmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cap_acct_ety exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cap_acct_ety to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cap_acct_ety_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cap_acct_ety', partname => 'p_ctmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);