/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_entry_bdmsi1
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
drop table ${iml_schema}.evt_entry_bdmsi1_tm purge;
alter table ${iml_schema}.evt_entry add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_entry modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entry_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 记账分录编号
    ,belong_hq_bank_no -- 所属总行行号
    ,tran_org_id -- 交易机构编号
    ,entry_tran_id -- 记账交易编号
    ,tran_attr_string -- 交易属性字符串
    ,prod_id -- 产品编号
    ,batch_id -- 批次编号
    ,cont_id -- 合同编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,fac_val_amt -- 票面金额
    ,entry_seq_num -- 分录顺序号
    ,get_val_field -- 取值字段
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,prtcptr_role_cd -- 参与方角色代码
    ,prtcptr_amt -- 参与方金额
    ,entry_flg -- 分录标志
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,cust_id -- 客户编号
    ,target_acct_num -- 目标账户号
    ,prtcptr_acct_type_cd -- 参与方账户类型代码
    ,org_id -- 机构编号
    ,prtcptr_type_cd -- 参与方类型代码
    ,prtcptr_ext -- 参与方扩展
    ,ext_amt_1 -- 扩展金额1
    ,ext_amt_2 -- 扩展金额2
    ,ext_amt_3 -- 扩展金额3
    ,batch_entry_flg -- 批次记账标志
    ,dtl_status_flg -- 明细状态标志
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,final_modif_operr_id -- 最后修改操作员编号
    ,sys_id -- 系统编号
    ,acct_instit_id -- 账务机构编号
    ,init_bill_sys_rgst_cter_id -- 原票据系统登记中心编号
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_entry
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_bms_trade_detail-
insert into ${iml_schema}.evt_entry_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,entry_id -- 记账分录编号
    ,belong_hq_bank_no -- 所属总行行号
    ,tran_org_id -- 交易机构编号
    ,entry_tran_id -- 记账交易编号
    ,tran_attr_string -- 交易属性字符串
    ,prod_id -- 产品编号
    ,batch_id -- 批次编号
    ,cont_id -- 合同编号
    ,dtl_id -- 明细编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,fac_val_amt -- 票面金额
    ,entry_seq_num -- 分录顺序号
    ,get_val_field -- 取值字段
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,prtcptr_role_cd -- 参与方角色代码
    ,prtcptr_amt -- 参与方金额
    ,entry_flg -- 分录标志
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,cust_id -- 客户编号
    ,target_acct_num -- 目标账户号
    ,prtcptr_acct_type_cd -- 参与方账户类型代码
    ,org_id -- 机构编号
    ,prtcptr_type_cd -- 参与方类型代码
    ,prtcptr_ext -- 参与方扩展
    ,ext_amt_1 -- 扩展金额1
    ,ext_amt_2 -- 扩展金额2
    ,ext_amt_3 -- 扩展金额3
    ,batch_entry_flg -- 批次记账标志
    ,dtl_status_flg -- 明细状态标志
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,final_modif_operr_id -- 最后修改操作员编号
    ,sys_id -- 系统编号
    ,acct_instit_id -- 账务机构编号
    ,init_bill_sys_rgst_cter_id -- 原票据系统登记中心编号
    ,h_data_flg -- 历史数据标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101007'||TO_CHAR(P1.CREATE_TIME,'YYYYMMDD')||P1.TRADE_DETAIL_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRADE_DETAIL_ID -- 记账分录编号
    ,P1.TOP_BANK_NO -- 所属总行行号
    ,P1.TRANS_BRANCH_NO -- 交易机构编号
    ,P1.TRADE_NO -- 记账交易编号
    ,P1.TRADE_ATTR_STR -- 交易属性字符串
    ,P1.PRODUCT_NO -- 产品编号
    ,P1.CONTRACT_ID -- 批次编号
    ,P1.PROTOCOL_NO -- 合同编号
    ,P1.DETAIL_ID -- 明细编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.DRAFT_AMOUNT -- 票面金额
    ,to_number(nvl(trim(P1.CODE_NO),0)) -- 分录顺序号
    ,P1.TAKE -- 取值字段
    ,NVL(TRIM(P1.DR_CR),'-') -- 借贷方向代码
    ,P1.PARTY_ROLE -- 参与方角色代码
    ,P1.AMOUNT -- 参与方金额
    ,NVL(TRIM(P1.FLAG),'-'） -- 分录标志
    ,CASE WHEN SUB_NO= 'AB2001' THEN '20111003' WHEN SUB_NO= 'IA2011010101' THEN '20110101' ELSE  NVL(P2.SUBJ_NO,' ') END -- 科目编号
    ,P1.NAME -- 科目名称
    ,CASE WHEN P3.CUST_NO IS NULL  THEN P1.CUSTOMER_ID ELSE  P3.CUST_NO END -- 客户编号
    ,P1.ACCOUNT_NO -- 目标账户号
    ,P1.ACCOUNT_TYPE -- 参与方账户类型代码
    ,P1.INST_CODE -- 机构编号
    ,P1.PARTY_TYPE -- 参与方类型代码
    ,P1.EXTENSION -- 参与方扩展
    ,P1.AMOUNT_RESERVE1 -- 扩展金额1
    ,P1.AMOUNT_RESERVE2 -- 扩展金额2
    ,P1.AMOUNT_RESERVE3 -- 扩展金额3
    ,NVL(TRIM(P1.IS_BATCH_ACCT),'-'） -- 批次记账标志
    ,NVL(TRIM(P1.STATUS),'-'） -- 明细状态标志
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_TIME -- 更新时间
    ,P1.LAST_UPD_OPER_NO -- 最后修改操作员编号
    ,P1.RESERVE1 -- 系统编号
    ,P1.ACCT_BRANCH_NO -- 账务机构编号
    ,P1.BMS_DRAFT_ID -- 原票据系统登记中心编号
    ,P1.RESERVE4 -- 历史数据标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_trade_detail' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_trade_detail p1
    left join ${iol_schema}.bdms_cpes_subj_busicode p2 on P1.SUB_NO=P2.BUSI_CODE AND P2.start_dt <= TO_DATE('${batch_date}','yyyymmdd') and P2.END_DT > TO_DATE('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_customer_info p3 on P1.CUSTOMER_ID=P3.ID AND P3.START_DT <= TO_DATE('${batch_date}','yyyymmdd') and P3.END_DT > TO_DATE('${batch_date}','yyyymmdd')
where  1 = 1 
    AND to_char(P1.CREATE_TIME,'yyyymmdd')='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_entry truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_entry exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_entry_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_entry to ${iml_schema};

-- 4.2 drop tm table
--drop table ${iml_schema}.evt_entry_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_entry', partname => 'p_bdmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);