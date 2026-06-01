/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_repay_flow_ncbsi1
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
drop table ${iml_schema}.evt_repay_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_repay_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_repay_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_repay_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,callbk_id -- 回收编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,loan_repay_dt -- 贷款还款日期
    ,loan_repay_type_cd -- 贷款还款类型代码
    ,pay_cust_id -- 付款客户编号
    ,curr_cd -- 币种代码
    ,cny_exch_rat -- 对人民币汇率
    ,exch_way_cd -- 汇兑方式代码
    ,callbk_pric -- 回收金额
    ,bus_tran_dt -- 业务交易日期
    ,callbk_prod_way_cd -- 回收产生方式代码
    ,tran_ref_no -- 交易参考号
    ,tran_org_id -- 交易机构编号
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,adv_repay_fee_amt -- 提前还款费用金额
    ,adv_repay_pric_amt -- 提前还款本金金额
    ,loan_rs_cd -- 贷款原因代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_stl_flg -- 交易结算标志
    ,tran_stl_dt -- 交易结算日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,revs_flg -- 冲正标志
    ,tran_revs_rs_descb -- 交易冲正原因描述
    ,sellout_flg -- 卖断式标志
    ,evt_cate_id -- 事件类别编号
    ,tran_cd -- 交易码
    ,adv_bf_repay_repay_plan_modif_way_cd -- 提前还款前还款计划变更方式代码
    ,adv_bf_repay_exp_dt -- 提前还款前到期日期
    ,nomal_repay_eh_issue_repay_amt -- 正常还款每期还款金额
    ,stl_teller_id -- 结算柜员编号
    ,acct_apv_teller_id -- 账户审批柜员编号
    ,ba_auth_teller_id -- 银承授权柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,repay_rstrct_cd -- 还款约束代码
    ,callbk_rs -- 回收原因
    ,check_entry_code -- 对账编码
    ,callbk_mode_cd -- 回收模式代码
    ,revs_dt -- 冲正日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_repay_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ncbs_cl_receipt-1
insert into ${iml_schema}.evt_repay_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,callbk_id -- 回收编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,loan_repay_dt -- 贷款还款日期
    ,loan_repay_type_cd -- 贷款还款类型代码
    ,pay_cust_id -- 付款客户编号
    ,curr_cd -- 币种代码
    ,cny_exch_rat -- 对人民币汇率
    ,exch_way_cd -- 汇兑方式代码
    ,callbk_pric -- 回收金额
    ,bus_tran_dt -- 业务交易日期
    ,callbk_prod_way_cd -- 回收产生方式代码
    ,tran_ref_no -- 交易参考号
    ,tran_org_id -- 交易机构编号
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,adv_repay_fee_amt -- 提前还款费用金额
    ,adv_repay_pric_amt -- 提前还款本金金额
    ,loan_rs_cd -- 贷款原因代码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_stl_flg -- 交易结算标志
    ,tran_stl_dt -- 交易结算日期
    ,acct_aldy_check_flg -- 账户已复核标志
    ,acct_check_dt -- 账户复核日期
    ,revs_flg -- 冲正标志
    ,tran_revs_rs_descb -- 交易冲正原因描述
    ,sellout_flg -- 卖断式标志
    ,evt_cate_id -- 事件类别编号
    ,tran_cd -- 交易码
    ,adv_bf_repay_repay_plan_modif_way_cd -- 提前还款前还款计划变更方式代码
    ,adv_bf_repay_exp_dt -- 提前还款前到期日期
    ,nomal_repay_eh_issue_repay_amt -- 正常还款每期还款金额
    ,stl_teller_id -- 结算柜员编号
    ,acct_apv_teller_id -- 账户审批柜员编号
    ,ba_auth_teller_id -- 银承授权柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,repay_rstrct_cd -- 还款约束代码
    ,callbk_rs -- 回收原因
    ,check_entry_code -- 对账编码
    ,callbk_mode_cd -- 回收模式代码
    ,revs_dt -- 冲正日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101070'||RECEIPT_NO -- 事件编号
    ,P1.RECEIPT_NO -- 回收编号
    ,'9999' -- 法人编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.RECEIPT_DATE -- 贷款还款日期
    ,P1.RECEIPT_TYPE -- 贷款还款类型代码
    ,P1.PAYER_CLIENT_NO -- 付款客户编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.LOCAL_XRATE -- 对人民币汇率
    ,nvl(trim(P1.XRATE_ID),'-') -- 汇兑方式代码
    ,P1.REC_AMT -- 回收金额
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.RECEIPT_GEN_CODE -- 回收产生方式代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,nvl(trim(P1.PRE_REPAY_DEAL),'-') -- 还款计划变更方式代码
    ,P1.PRE_FEE_AMT -- 提前还款费用金额
    ,P1.PRE_PRI_AMT -- 提前还款本金金额
    ,nvl(trim(P1.REASON_CODE),'000000') -- 贷款原因代码
    ,P1.NARRATIVE -- 交易摘要描述
    ,decode(trim(P1.SETTLE),'','-','Y','1','N','0',P1.SETTLE) -- 交易结算标志
    ,P1.SETTLE_DATE -- 交易结算日期
    ,decode(trim(P1.APPR_FLAG),'','-','Y','1','N','0',P1.APPR_FLAG) -- 账户已复核标志
    ,P1.APPROVAL_DATE -- 账户复核日期
    ,decode(trim(P1.REVERSAL),'','-','Y','1','N','0',P1.REVERSAL) -- 冲正标志
    ,P1.REVERSAL_REASON -- 交易冲正原因描述
    ,DECODE(TRIM(P1.SELL_NOT_FLAG),'','-','Y','1','N','0',P1.SELL_NOT_FLAG) -- 卖断式标志
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.TRAN_TYPE -- 交易码
    ,nvl(trim(P1.LAST_PRE_REPAY_DEAL),'-') -- 提前还款前还款计划变更方式代码
    ,P1.LAST_CONTRACTION_DATE -- 提前还款前到期日期
    ,P1.LAST_FORMULA_AMT -- 正常还款每期还款金额
    ,P1.SETTLE_USER_ID -- 结算柜员编号
    ,P1.APPR_USER_ID -- 账户审批柜员编号
    ,P1.AUTH_USER_ID -- 银承授权柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(P1.REPAY_RESTRAINT),'-') -- 还款约束代码
    ,P1.RECEIPT_REASON -- 回收原因
    ,P1.REACCOUNT_CD -- 对账编码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REC_MODE END -- 回收模式代码
    ,P1.REVERSAL_DATE -- 冲正日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_receipt' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_receipt p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REC_MODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_RECEIPT'
        AND R1.SRC_FIELD_EN_NAME= 'REC_MODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_REPAY_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CALLBK_MODE_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_repay_flow truncate partition p_ncbsi1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_repay_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_repay_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_repay_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_repay_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_repay_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);