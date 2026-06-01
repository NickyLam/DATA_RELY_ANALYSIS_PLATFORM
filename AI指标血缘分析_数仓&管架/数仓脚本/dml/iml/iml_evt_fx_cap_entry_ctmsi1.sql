/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_fx_cap_entry_ctmsi1
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
drop table ${iml_schema}.evt_fx_cap_entry_ctmsi1_tm purge;
alter table ${iml_schema}.evt_fx_cap_entry add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_fx_cap_entry modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fx_cap_entry_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,bal_chg_dtl_id -- 余额变动明细编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,rela_tran_table_name -- 关联交易表名称
    ,out_acct_dt -- 出账日期
    ,entry_def_id -- 分录定义编号
    ,entry_type_cd -- 分录类型代码
    ,acct_b_id -- 账簿编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,curr_cd -- 币种代码
    ,curr_name -- 币种名称
    ,in_out_tab_flg -- 表内外标志
    ,offset_entry_id -- 冲回分录编号
    ,amt -- 金额
    ,tran_id -- 交易编号
    ,strk_bal_flg -- 冲账标志
    ,acctnt_evt_name -- 会计事件名称
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,curr_descb -- 币种描述
    ,ib_lend_type_cd -- 拆借类型代码
    ,prod_type_cd -- 产品类型代码
    ,bag_id -- 成交编号
    ,end_day_dt -- 日终日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_fx_cap_entry
where 0=1;

-- 3.1 truncate target table
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_fx_cap_entry truncate partition p_ctmsi1;

-- 3.2 insert data to tm table
-- ctms_fbs_v_accentry2-
insert into ${iml_schema}.evt_fx_cap_entry_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 分录编号
    ,bal_chg_dtl_id -- 余额变动明细编号
    ,dept_id -- 部门编号
    ,org_id -- 机构编号
    ,rela_tran_table_name -- 关联交易表名称
    ,out_acct_dt -- 出账日期
    ,entry_def_id -- 分录定义编号
    ,entry_type_cd -- 分录类型代码
    ,acct_b_id -- 账簿编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,curr_cd -- 币种代码
    ,curr_name -- 币种名称
    ,in_out_tab_flg -- 表内外标志
    ,offset_entry_id -- 冲回分录编号
    ,amt -- 金额
    ,tran_id -- 交易编号
    ,strk_bal_flg -- 冲账标志
    ,acctnt_evt_name -- 会计事件名称
    ,cntpty_id -- 交易对手编号
    ,cntpty_name -- 交易对手名称
    ,curr_descb -- 币种描述
    ,ib_lend_type_cd -- 拆借类型代码
    ,prod_type_cd -- 产品类型代码
    ,bag_id -- 成交编号
    ,end_day_dt -- 日终日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104016'||to_char(P1.ACCENTRY2_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ACCENTRY2_ID -- 分录编号
    ,P1.ALTERBALANCE_ID -- 余额变动明细编号
    ,P1.CUSNUMBER -- 部门编号
    ,TO_CHAR(P1.BRANCH_NUMBER) -- 机构编号
    ,P1.VIEW_TABLE -- 关联交易表名称
    ,${iml_schema}.dateformat_min(TO_CHAR(P1.SETTLEDATE)) -- 出账日期
    ,P1.ACCCODE -- 分录定义编号
    ,P1.ACCTYPE -- 分录类型代码
    ,P1.KEEPFOLDER_ID -- 账簿编号
    ,P1.ACCOUNTINGCODE -- 科目编号
    ,P1.ACCOUNTINGDESC -- 科目名称
    ,P1.DEBITCREDIT -- 借贷方向代码
    ,P1.CRNCY_CODE -- 币种代码
    ,P1.ALD_CRNCY_ENAME -- 币种名称
    ,P1.INOUTTYPE -- 表内外标志
    ,P1.ACCENTRY2_ID_REV -- 冲回分录编号
    ,P1.AMOUNT -- 金额
    ,P1.DEALSQNO -- 交易编号
    ,TO_CHAR(P1.REV_FLAG) -- 冲账标志
    ,P1.EVENT_NAME -- 会计事件名称
    ,TO_CHAR(P1.COUNTER_PARTY_ID) -- 交易对手编号
    ,P1.COUNTER_PARTY_SCNAME -- 交易对手名称
    ,P1.CURRENCY -- 币种描述
    ,TO_CHAR(P1.IBO_TYPE) -- 拆借类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRODUCT END -- 产品类型代码
    ,P1.CLIENT_DEAL_SQNO -- 成交编号
    ,${iml_schema}.dateformat_max(TO_CHAR(P1.DAY_END_DATE)) -- 日终日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_accentry2' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_accentry2 p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRODUCT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_FBS_V_ACCENTRY2'
        AND R2.SRC_FIELD_EN_NAME= 'PRODUCT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_FX_CAP_ENTRY'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROD_TYPE_CD'
where  1 = 1 
;
commit;



-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_fx_cap_entry exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_fx_cap_entry_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_fx_cap_entry to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_fx_cap_entry_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_fx_cap_entry', partname => 'p_ctmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);