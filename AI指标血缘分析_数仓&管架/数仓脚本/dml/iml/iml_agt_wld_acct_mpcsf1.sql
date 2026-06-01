/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_acct_mpcsf1
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
drop table ${iml_schema}.agt_wld_acct_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_acct_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_wld_acct add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_acct modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_acct_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_acct partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_acct_mpcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 客户额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,fir_consm_dt -- 首次消费日期
    ,last_repay_amt -- 上笔还款金额
    ,fir_consm_amt -- 首次消费金额
    ,min_second_marke -- 最小还款额
    ,currt_min_second_marke -- 当期最小还款额
    ,currt_cash_amt -- 当期取现金额
    ,currt_cash_cnt -- 当期取现笔数
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,currt_rtn_goods_amt -- 当期退货金额
    ,currt_rtn_goods_cnt -- 当期退货笔数
    ,currt_higt_over_lmt_amt_lmt -- 当期最高超限金额
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,acct_ovdue_amt -- 账户逾期金额
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,ext_cust_id -- 外部客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_wld_acct_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_wld_acct partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a0ntm_account-
insert into ${iml_schema}.agt_wld_acct_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 客户额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,fir_consm_dt -- 首次消费日期
    ,last_repay_amt -- 上笔还款金额
    ,fir_consm_amt -- 首次消费金额
    ,min_second_marke -- 最小还款额
    ,currt_min_second_marke -- 当期最小还款额
    ,currt_cash_amt -- 当期取现金额
    ,currt_cash_cnt -- 当期取现笔数
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,currt_rtn_goods_amt -- 当期退货金额
    ,currt_rtn_goods_cnt -- 当期退货笔数
    ,currt_higt_over_lmt_amt_lmt -- 当期最高超限金额
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,acct_ovdue_amt -- 账户逾期金额
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,ext_cust_id -- 外部客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '131010'||TO_CHAR(P1.ACCT_NO)||P1.ACCT_TYPE -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.ACCT_NO) -- 账户编号
    ,NVL(TRIM(P1.ACCT_TYPE),'-') -- 账户类型代码
    ,NVL(TRIM(P2.cbscustno),' ') -- 客户编号
    ,P1.NAME -- 姓名
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.GENDER END -- 性别代码
    ,TO_CHAR(P1.CUST_LIMIT_ID) -- 客户额度编号
    ,P1.PRODUCT_CD -- 贷款产品编号
    ,P1.BANK_GROUP_ID -- 银团编号
    ,P1.DEFAULT_LOGICAL_CARD_NO -- 卡号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CURR_CD  END -- 币种代码
    ,P1.CREDIT_LIMIT -- 额度
    ,P1.CURR_BAL -- 当前余额
    ,P1.PRINCIPAL_BAL -- 本金余额
    ,P1.BEGIN_BAL -- 上一到期日余额
    ,TO_NUMBER(TRIM(P1.AGE_CD)) -- 拖欠月数
    ,P1.UNMATCH_DB -- 未入账借记金额
    ,P1.UNMATCH_CR -- 未入账贷记金额
    ,NVL(TRIM(P1.DD_IND),'-') -- 约定还款类型代码
    ,P1.DD_BANK_NAME -- 约定还款银行名称
    ,P1.DD_BANK_BRANCH -- 约定还款开户行号
    ,P1.DD_BANK_ACCT_NO -- 约定还款扣款账号
    ,P1.DD_BANK_ACCT_NAME -- 约定还款扣款账户名称
    ,P1.BILLING_CYCLE -- 还款日
    ,P1.LAST_SYNC_DATE -- 上一次入账的批量日期
    ,P1.LAST_PMT_DATE -- 上个还款日期
    ,P1.LAST_STMT_DATE -- 上个到期还款日期
    ,P1.LAST_PMT_DUE_DATE -- 上个逾期还款日期
    ,P1.LAST_AGING_DATE -- 上个逾期月数提升日期
    ,P1.COLLECT_DATE -- 入催日期
    ,P1.COLLECT_OUT_DATE -- 出催收队列日期
    ,P1.NEXT_STMT_DATE -- 下个到期还款日期
    ,P1.PMT_DUE_DATE -- 到期还款日期
    ,P1.DD_DATE -- 约定还款日期
    ,P1.GRACE_DATE -- 宽限日期
    ,P1.FIRST_STMT_DATE -- 首个到期还款日期
    ,P1.CANCEL_DATE -- 销户日期
    ,P1.CHARGE_OFF_DATE -- 转呆账日期
    ,P1.FIRST_PURCHASE_DATE -- 首次消费日期
    ,P1.LAST_PMT_AMT -- 上笔还款金额
    ,P1.FIRST_PURCHASE_AMT -- 首次消费金额
    ,P1.TOT_DUE_AMT -- 最小还款额
    ,P1.CURR_DUE_AMT -- 当期最小还款额
    ,P1.CTD_CASH_AMT -- 当期取现金额
    ,P1.CTD_CASH_CNT -- 当期取现笔数
    ,P1.CTD_RETAIL_AMT -- 当期消费金额
    ,P1.CTD_RETAIL_CNT -- 当期消费笔数
    ,P1.CTD_PAYMENT_AMT -- 当期还款金额
    ,P1.CTD_PAYMENT_CNT -- 当期还款笔数
    ,P1.CTD_DB_ADJ_AMT -- 当期借记调整金额
    ,P1.CTD_DB_ADJ_CNT -- 当期借记调整笔数
    ,P1.CTD_CR_ADJ_AMT -- 当期贷记调整金额
    ,P1.CTD_CR_ADJ_CNT -- 当期贷记调整笔数
    ,P1.CTD_FEE_AMT -- 当期费用金额
    ,P1.CTD_FEE_CNT -- 当期费用笔数
    ,P1.CTD_INTEREST_AMT -- 当期利息金额
    ,P1.CTD_INTEREST_CNT -- 当期利息笔数
    ,P1.CTD_REFUND_AMT -- 当期退货金额
    ,P1.CTD_REFUND_CNT -- 当期退货笔数
    ,P1.CTD_HI_OVRLMT_AMT -- 当期最高超限金额
    ,P1.MTD_RETAIL_AMT -- 本月消费金额
    ,P1.MTD_RETAIL_CNT -- 本月消费笔数
    ,P1.YTD_RETAIL_AMT -- 本年消费金额
    ,P1.YTD_RETAIL_CNT -- 本年消费笔数
    ,P1.MTD_PAYMENT_AMT -- 当月还款金额
    ,P1.MTD_PAYMENT_CNT -- 当月还款笔数
    ,P1.YTD_PAYMENT_AMT -- 当年还款金额
    ,P1.YTD_PAYMENT_CNT -- 当年还款笔数
    ,P1.LTD_PAYMENT_AMT -- 历史还款金额
    ,P1.LTD_PAYMENT_CNT -- 历史还款笔数
    ,P1.DELAY_BAL -- 账户逾期金额
    ,P1.BANK_PROPORTION -- 银行出资比例
    ,P1.BATCHFILENAME -- 批量文件名称
    ,P1.SEQNO -- 序列号
    ,P1.CUST_ID -- 外部客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0ntm_account' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_account p1
    left join ${iol_schema}.mpcs_a0ntm_customer p2 on P1.CUST_ID=P2.CUST_ID AND  P2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND P2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GENDER = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A0NTM_ACCOUNT'
        AND R1.SRC_FIELD_EN_NAME= 'GENDER'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WLD_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GENDER_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CURR_CD  = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A0NTM_ACCOUNT'
        AND R2.SRC_FIELD_EN_NAME= 'CURR_CD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_WLD_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_acct_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_wld_acct_mpcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cust_id -- 客户编号
    ,name -- 姓名
    ,gender_cd -- 性别代码
    ,cust_lmt_id -- 客户额度编号
    ,loan_prod_id -- 贷款产品编号
    ,syn_id -- 银团编号
    ,card_no -- 卡号
    ,curr_cd -- 币种代码
    ,lmt -- 额度
    ,curr_bal -- 当前余额
    ,pric_bal -- 本金余额
    ,last_exp_day_bal -- 上一到期日余额
    ,duf_mons -- 拖欠月数
    ,unbd_debit_amt -- 未入账借记金额
    ,unbd_crdt_amt -- 未入账贷记金额
    ,apot_repay_type_cd -- 约定还款类型代码
    ,apot_repay_bank_name -- 约定还款银行名称
    ,apot_repay_open_bank_num -- 约定还款开户行号
    ,apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,repay_day -- 还款日
    ,last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,prev_repay_dt -- 上个还款日期
    ,prev_exp_repay_dt -- 上个到期还款日期
    ,prev_ovdue_repay_dt -- 上个逾期还款日期
    ,prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,in_coll_dt -- 入催日期
    ,out_coll_que_dt -- 出催收队列日期
    ,next_exp_repay_dt -- 下个到期还款日期
    ,exp_repay_dt -- 到期还款日期
    ,apot_repay_dt -- 约定还款日期
    ,grace_dt_term -- 宽限日期
    ,fir_exp_repay_dt -- 首个到期还款日期
    ,clos_acct_dt -- 销户日期
    ,tran_bad_debt_acct_dt -- 转呆账日期
    ,fir_consm_dt -- 首次消费日期
    ,last_repay_amt -- 上笔还款金额
    ,fir_consm_amt -- 首次消费金额
    ,min_second_marke -- 最小还款额
    ,currt_min_second_marke -- 当期最小还款额
    ,currt_cash_amt -- 当期取现金额
    ,currt_cash_cnt -- 当期取现笔数
    ,currt_consm_amt -- 当期消费金额
    ,currt_consm_cnt -- 当期消费笔数
    ,currt_repay_amt -- 当期还款金额
    ,currt_repay_cnt -- 当期还款笔数
    ,currt_debit_adj_amt -- 当期借记调整金额
    ,currt_debit_adj_cnt -- 当期借记调整笔数
    ,currt_crdt_adj_amt -- 当期贷记调整金额
    ,currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,currt_fee_amt -- 当期费用金额
    ,currt_fee_cnt -- 当期费用笔数
    ,currt_int_amt -- 当期利息金额
    ,currt_int_cnt -- 当期利息笔数
    ,currt_rtn_goods_amt -- 当期退货金额
    ,currt_rtn_goods_cnt -- 当期退货笔数
    ,currt_higt_over_lmt_amt_lmt -- 当期最高超限金额
    ,th_mon_consm_amt -- 本月消费金额
    ,th_mon_consm_cnt -- 本月消费笔数
    ,th_year_consm_amt -- 本年消费金额
    ,th_year_consm_cnt -- 本年消费笔数
    ,curr_mon_repay_amt -- 当月还款金额
    ,curr_mon_repay_cnt -- 当月还款笔数
    ,th_year_repay_amt -- 当年还款金额
    ,th_year_repay_cnt -- 当年还款笔数
    ,h_repay_amt -- 历史还款金额
    ,h_repay_cnt -- 历史还款笔数
    ,acct_ovdue_amt -- 账户逾期金额
    ,bank_contri_ratio -- 银行出资比例
    ,batch_doc_name -- 批量文件名称
    ,ser_num -- 序列号
    ,ext_cust_id -- 外部客户编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 客户额度编号
    ,nvl(n.loan_prod_id, o.loan_prod_id) as loan_prod_id -- 贷款产品编号
    ,nvl(n.syn_id, o.syn_id) as syn_id -- 银团编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.lmt, o.lmt) as lmt -- 额度
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 当前余额
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.last_exp_day_bal, o.last_exp_day_bal) as last_exp_day_bal -- 上一到期日余额
    ,nvl(n.duf_mons, o.duf_mons) as duf_mons -- 拖欠月数
    ,nvl(n.unbd_debit_amt, o.unbd_debit_amt) as unbd_debit_amt -- 未入账借记金额
    ,nvl(n.unbd_crdt_amt, o.unbd_crdt_amt) as unbd_crdt_amt -- 未入账贷记金额
    ,nvl(n.apot_repay_type_cd, o.apot_repay_type_cd) as apot_repay_type_cd -- 约定还款类型代码
    ,nvl(n.apot_repay_bank_name, o.apot_repay_bank_name) as apot_repay_bank_name -- 约定还款银行名称
    ,nvl(n.apot_repay_open_bank_num, o.apot_repay_open_bank_num) as apot_repay_open_bank_num -- 约定还款开户行号
    ,nvl(n.apot_repay_deduct_acct_num, o.apot_repay_deduct_acct_num) as apot_repay_deduct_acct_num -- 约定还款扣款账号
    ,nvl(n.apot_repay_deduct_acct_name, o.apot_repay_deduct_acct_name) as apot_repay_deduct_acct_name -- 约定还款扣款账户名称
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.last_enter_acct_batch_dt, o.last_enter_acct_batch_dt) as last_enter_acct_batch_dt -- 上一次入账的批量日期
    ,nvl(n.prev_repay_dt, o.prev_repay_dt) as prev_repay_dt -- 上个还款日期
    ,nvl(n.prev_exp_repay_dt, o.prev_exp_repay_dt) as prev_exp_repay_dt -- 上个到期还款日期
    ,nvl(n.prev_ovdue_repay_dt, o.prev_ovdue_repay_dt) as prev_ovdue_repay_dt -- 上个逾期还款日期
    ,nvl(n.prev_ovdue_mons_promt_dt, o.prev_ovdue_mons_promt_dt) as prev_ovdue_mons_promt_dt -- 上个逾期月数提升日期
    ,nvl(n.in_coll_dt, o.in_coll_dt) as in_coll_dt -- 入催日期
    ,nvl(n.out_coll_que_dt, o.out_coll_que_dt) as out_coll_que_dt -- 出催收队列日期
    ,nvl(n.next_exp_repay_dt, o.next_exp_repay_dt) as next_exp_repay_dt -- 下个到期还款日期
    ,nvl(n.exp_repay_dt, o.exp_repay_dt) as exp_repay_dt -- 到期还款日期
    ,nvl(n.apot_repay_dt, o.apot_repay_dt) as apot_repay_dt -- 约定还款日期
    ,nvl(n.grace_dt_term, o.grace_dt_term) as grace_dt_term -- 宽限日期
    ,nvl(n.fir_exp_repay_dt, o.fir_exp_repay_dt) as fir_exp_repay_dt -- 首个到期还款日期
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.tran_bad_debt_acct_dt, o.tran_bad_debt_acct_dt) as tran_bad_debt_acct_dt -- 转呆账日期
    ,nvl(n.fir_consm_dt, o.fir_consm_dt) as fir_consm_dt -- 首次消费日期
    ,nvl(n.last_repay_amt, o.last_repay_amt) as last_repay_amt -- 上笔还款金额
    ,nvl(n.fir_consm_amt, o.fir_consm_amt) as fir_consm_amt -- 首次消费金额
    ,nvl(n.min_second_marke, o.min_second_marke) as min_second_marke -- 最小还款额
    ,nvl(n.currt_min_second_marke, o.currt_min_second_marke) as currt_min_second_marke -- 当期最小还款额
    ,nvl(n.currt_cash_amt, o.currt_cash_amt) as currt_cash_amt -- 当期取现金额
    ,nvl(n.currt_cash_cnt, o.currt_cash_cnt) as currt_cash_cnt -- 当期取现笔数
    ,nvl(n.currt_consm_amt, o.currt_consm_amt) as currt_consm_amt -- 当期消费金额
    ,nvl(n.currt_consm_cnt, o.currt_consm_cnt) as currt_consm_cnt -- 当期消费笔数
    ,nvl(n.currt_repay_amt, o.currt_repay_amt) as currt_repay_amt -- 当期还款金额
    ,nvl(n.currt_repay_cnt, o.currt_repay_cnt) as currt_repay_cnt -- 当期还款笔数
    ,nvl(n.currt_debit_adj_amt, o.currt_debit_adj_amt) as currt_debit_adj_amt -- 当期借记调整金额
    ,nvl(n.currt_debit_adj_cnt, o.currt_debit_adj_cnt) as currt_debit_adj_cnt -- 当期借记调整笔数
    ,nvl(n.currt_crdt_adj_amt, o.currt_crdt_adj_amt) as currt_crdt_adj_amt -- 当期贷记调整金额
    ,nvl(n.currt_crdt_adj_cnt, o.currt_crdt_adj_cnt) as currt_crdt_adj_cnt -- 当期贷记调整笔数
    ,nvl(n.currt_fee_amt, o.currt_fee_amt) as currt_fee_amt -- 当期费用金额
    ,nvl(n.currt_fee_cnt, o.currt_fee_cnt) as currt_fee_cnt -- 当期费用笔数
    ,nvl(n.currt_int_amt, o.currt_int_amt) as currt_int_amt -- 当期利息金额
    ,nvl(n.currt_int_cnt, o.currt_int_cnt) as currt_int_cnt -- 当期利息笔数
    ,nvl(n.currt_rtn_goods_amt, o.currt_rtn_goods_amt) as currt_rtn_goods_amt -- 当期退货金额
    ,nvl(n.currt_rtn_goods_cnt, o.currt_rtn_goods_cnt) as currt_rtn_goods_cnt -- 当期退货笔数
    ,nvl(n.currt_higt_over_lmt_amt_lmt, o.currt_higt_over_lmt_amt_lmt) as currt_higt_over_lmt_amt_lmt -- 当期最高超限金额
    ,nvl(n.th_mon_consm_amt, o.th_mon_consm_amt) as th_mon_consm_amt -- 本月消费金额
    ,nvl(n.th_mon_consm_cnt, o.th_mon_consm_cnt) as th_mon_consm_cnt -- 本月消费笔数
    ,nvl(n.th_year_consm_amt, o.th_year_consm_amt) as th_year_consm_amt -- 本年消费金额
    ,nvl(n.th_year_consm_cnt, o.th_year_consm_cnt) as th_year_consm_cnt -- 本年消费笔数
    ,nvl(n.curr_mon_repay_amt, o.curr_mon_repay_amt) as curr_mon_repay_amt -- 当月还款金额
    ,nvl(n.curr_mon_repay_cnt, o.curr_mon_repay_cnt) as curr_mon_repay_cnt -- 当月还款笔数
    ,nvl(n.th_year_repay_amt, o.th_year_repay_amt) as th_year_repay_amt -- 当年还款金额
    ,nvl(n.th_year_repay_cnt, o.th_year_repay_cnt) as th_year_repay_cnt -- 当年还款笔数
    ,nvl(n.h_repay_amt, o.h_repay_amt) as h_repay_amt -- 历史还款金额
    ,nvl(n.h_repay_cnt, o.h_repay_cnt) as h_repay_cnt -- 历史还款笔数
    ,nvl(n.acct_ovdue_amt, o.acct_ovdue_amt) as acct_ovdue_amt -- 账户逾期金额
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.batch_doc_name, o.batch_doc_name) as batch_doc_name -- 批量文件名称
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.ext_cust_id, o.ext_cust_id) as ext_cust_id -- 外部客户编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_id <> n.acct_id
                or o.acct_type_cd <> n.acct_type_cd
                or o.cust_id <> n.cust_id
                or o.name <> n.name
                or o.gender_cd <> n.gender_cd
                or o.cust_lmt_id <> n.cust_lmt_id
                or o.loan_prod_id <> n.loan_prod_id
                or o.syn_id <> n.syn_id
                or o.card_no <> n.card_no
                or o.curr_cd <> n.curr_cd
                or o.lmt <> n.lmt
                or o.curr_bal <> n.curr_bal
                or o.pric_bal <> n.pric_bal
                or o.last_exp_day_bal <> n.last_exp_day_bal
                or o.duf_mons <> n.duf_mons
                or o.unbd_debit_amt <> n.unbd_debit_amt
                or o.unbd_crdt_amt <> n.unbd_crdt_amt
                or o.apot_repay_type_cd <> n.apot_repay_type_cd
                or o.apot_repay_bank_name <> n.apot_repay_bank_name
                or o.apot_repay_open_bank_num <> n.apot_repay_open_bank_num
                or o.apot_repay_deduct_acct_num <> n.apot_repay_deduct_acct_num
                or o.apot_repay_deduct_acct_name <> n.apot_repay_deduct_acct_name
                or o.repay_day <> n.repay_day
                or o.last_enter_acct_batch_dt <> n.last_enter_acct_batch_dt
                or o.prev_repay_dt <> n.prev_repay_dt
                or o.prev_exp_repay_dt <> n.prev_exp_repay_dt
                or o.prev_ovdue_repay_dt <> n.prev_ovdue_repay_dt
                or o.prev_ovdue_mons_promt_dt <> n.prev_ovdue_mons_promt_dt
                or o.in_coll_dt <> n.in_coll_dt
                or o.out_coll_que_dt <> n.out_coll_que_dt
                or o.next_exp_repay_dt <> n.next_exp_repay_dt
                or o.exp_repay_dt <> n.exp_repay_dt
                or o.apot_repay_dt <> n.apot_repay_dt
                or o.grace_dt_term <> n.grace_dt_term
                or o.fir_exp_repay_dt <> n.fir_exp_repay_dt
                or o.clos_acct_dt <> n.clos_acct_dt
                or o.tran_bad_debt_acct_dt <> n.tran_bad_debt_acct_dt
                or o.fir_consm_dt <> n.fir_consm_dt
                or o.last_repay_amt <> n.last_repay_amt
                or o.fir_consm_amt <> n.fir_consm_amt
                or o.min_second_marke <> n.min_second_marke
                or o.currt_min_second_marke <> n.currt_min_second_marke
                or o.currt_cash_amt <> n.currt_cash_amt
                or o.currt_cash_cnt <> n.currt_cash_cnt
                or o.currt_consm_amt <> n.currt_consm_amt
                or o.currt_consm_cnt <> n.currt_consm_cnt
                or o.currt_repay_amt <> n.currt_repay_amt
                or o.currt_repay_cnt <> n.currt_repay_cnt
                or o.currt_debit_adj_amt <> n.currt_debit_adj_amt
                or o.currt_debit_adj_cnt <> n.currt_debit_adj_cnt
                or o.currt_crdt_adj_amt <> n.currt_crdt_adj_amt
                or o.currt_crdt_adj_cnt <> n.currt_crdt_adj_cnt
                or o.currt_fee_amt <> n.currt_fee_amt
                or o.currt_fee_cnt <> n.currt_fee_cnt
                or o.currt_int_amt <> n.currt_int_amt
                or o.currt_int_cnt <> n.currt_int_cnt
                or o.currt_rtn_goods_amt <> n.currt_rtn_goods_amt
                or o.currt_rtn_goods_cnt <> n.currt_rtn_goods_cnt
                or o.currt_higt_over_lmt_amt_lmt <> n.currt_higt_over_lmt_amt_lmt
                or o.th_mon_consm_amt <> n.th_mon_consm_amt
                or o.th_mon_consm_cnt <> n.th_mon_consm_cnt
                or o.th_year_consm_amt <> n.th_year_consm_amt
                or o.th_year_consm_cnt <> n.th_year_consm_cnt
                or o.curr_mon_repay_amt <> n.curr_mon_repay_amt
                or o.curr_mon_repay_cnt <> n.curr_mon_repay_cnt
                or o.th_year_repay_amt <> n.th_year_repay_amt
                or o.th_year_repay_cnt <> n.th_year_repay_cnt
                or o.h_repay_amt <> n.h_repay_amt
                or o.h_repay_cnt <> n.h_repay_cnt
                or o.acct_ovdue_amt <> n.acct_ovdue_amt
                or o.bank_contri_ratio <> n.bank_contri_ratio
                or o.batch_doc_name <> n.batch_doc_name
                or o.ser_num <> n.ser_num
                or o.ext_cust_id <> n.ext_cust_id
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_acct_mpcsf1_tm n
    full join ${iml_schema}.agt_wld_acct_mpcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wld_acct truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_wld_acct exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_wld_acct_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wld_acct drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wld_acct_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_acct_mpcsf1_ex purge;
drop table ${iml_schema}.agt_wld_acct_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_acct', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);