/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_attach_info_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_acct_attach_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_attach_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_attach_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_attach_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_attach_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_loan-1
insert into ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.LOAN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.RELATED_LOAN_NO -- 关联贷款号
    ,P1.SIGN_DATE -- 交易签约日期
    ,decode(trim(P1.ANYTIME_REC_FLAG),'Y','1','N','0','','-') -- 随借随还标志
    ,decode(trim(P1.RECEIVE_ANYTIME_FLAG),'Y','1','N','0','-') -- 随还标志
    ,nvl(trim(P1.ENTRUST_SETTLE_FLAG),'-') -- 委托贷款结算标识代码
    ,P1.ORIG_LOAN_AMT -- 贷款签约合同金额
    ,P1.GRACE_PERIOD -- 宽限期
    ,nvl(trim(P1.GRACE_TYPE),'-') -- 宽限期单位代码
    ,decode(trim(P1.PRI_PENALTY_FLAG),'Y','1','N','0','','-') -- 收取罚息标志
    ,decode(trim(P1.INT_PENALTY),'Y','1','N','0','','-') -- 收取复利标志
    ,decode(trim(P1.OD_PRI_PENALTY_FLAG),'Y','1','N','0','','-') -- 收取罚息的复利标志
    ,decode(trim(P1.OD_INT_PENALTY_FLAG),'Y','1','N','0','','-') -- 收取复利的复利标志
    ,decode(trim(P1.SYNC_FINAL_BILLING_FLAG),'Y','1','N','0','','-') -- 利随本清标志
    ,P1.PRE_PAY_RATE -- 提前还本补偿金额
    ,P1.DD_END_DATE -- 发放截止日期
    ,decode(trim(P1.PAUSE_INT_IND),'Y','1','N','0','','-') -- 贷款停息标志
    ,P1.UI_MIN_AMT -- 折扣贷款提前还款最低罚金
    ,P1.PR_MIN_AMT -- 提前还款最低补偿金
    ,P1.MAX_EXTEND_TIMES -- 最大展期次数
    ,P1.CONTRACT_NO -- 合同编号
    ,nvl(trim(P1.HUNTING_STATUS),'-') -- 持续扣款标识代码
    ,decode(trim(P1.DD_INC_IND),'Y','1','N','0','','-') -- 增量发放标志
    ,nvl(trim(P1.LOAN_CLASS),'-') -- 贷款类别代码
    ,decode(trim(P1.FORCE_GRACE_FLAG),'Y','1','N','0','','-') -- 宽限期遇节假日顺延标志
    ,decode(trim(P1.GRACE_CHARGE_INT_FLAG),'Y','1','N','0','','-') -- 到期本金在宽限期收息标志
    ,decode(trim(P1.GRACE_PRI_FLAG),'Y','1','N','0','','-') -- 宽限本金标志
    ,decode(trim(P1.GRACE_INT_FLAG),'Y','1','N','0','','-') -- 宽限利息标志
    ,decode(trim(P1.STAMP_TAX_FLAG),'Y','1','N','0','','-') -- 收取贷款印花税标志
    ,P1.CONTRIBUTE_AMT -- 参与行出资金额
    ,nvl(trim(P1.TAXABLE_IND),'-') -- 收税标识代码
    ,P1.SYN_DD_TIMES -- 银团贷款发放次数
    ,nvl(trim(P1.GRACE_TERM_TYPE),'-') -- 宽限期次类型代码
    ,decode(trim(P1.GRACE_CHARGE_ODI_FLAG),'Y','1','N','0','','-') -- 宽限期内收复利标志
    ,nvl(trim(P1.CROSS_PERIOD_FLAG),'-') -- 跨月标识代码
    ,P1.OD_GRACE_PERIOD_DAYS -- 免息期天数
    ,decode(trim(P1.BEFORE_INCOME_FLAG),'Y','1','N','0','','-') -- 提前收息标志
    ,P1.AMOUNT_NATURE -- 资金性质代码
    ,DECODE(trim(P1.AUTO_SETTLE_FLAG),'Y','1','N','0','-') -- 自动结清标志
    ,P1.CLIENT_SHORT -- 客户简称
    ,nvl(trim(P1.PURPOSE),'000000') -- 贷款用途代码
    ,P1.COMMIT_AMT -- 承诺额
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.COMPENSATE_RATIO -- 理赔比例
    ,P1.DUE_COMPENSATE_PERIOD -- 逾期理赔天数
    ,nvl(trim(P1.CORP_SIZE),'0') -- 企业规模代码
    ,nvl(trim(P1.ECON_DEPARTMENT_TYPE),'000') -- 国民经济部门类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_loan' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,loan_num
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.rela_loan_num, o.rela_loan_num) as rela_loan_num -- 关联贷款号
    ,nvl(n.tran_sign_dt, o.tran_sign_dt) as tran_sign_dt -- 交易签约日期
    ,nvl(n.bar_flg, o.bar_flg) as bar_flg -- 随借随还标志
    ,nvl(n.repay_flg, o.repay_flg) as repay_flg -- 随还标志
    ,nvl(n.entr_loan_stl_idf_cd, o.entr_loan_stl_idf_cd) as entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,nvl(n.loan_sign_cont_amt, o.loan_sign_cont_amt) as loan_sign_cont_amt -- 贷款签约合同金额
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期
    ,nvl(n.grace_period_corp_cd, o.grace_period_corp_cd) as grace_period_corp_cd -- 宽限期单位代码
    ,nvl(n.coll_pnlt_flg, o.coll_pnlt_flg) as coll_pnlt_flg -- 收取罚息标志
    ,nvl(n.coll_comp_int_flg, o.coll_comp_int_flg) as coll_comp_int_flg -- 收取复利标志
    ,nvl(n.coll_pnlt_comp_int_flg, o.coll_pnlt_comp_int_flg) as coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,nvl(n.coll_comp_int_comp_flg, o.coll_comp_int_comp_flg) as coll_comp_int_comp_flg -- 收取复利的复利标志
    ,nvl(n.mpr_flg, o.mpr_flg) as mpr_flg -- 利随本清标志
    ,nvl(n.adv_rpp_compst_amt, o.adv_rpp_compst_amt) as adv_rpp_compst_amt -- 提前还本补偿金额
    ,nvl(n.distr_closing_dt, o.distr_closing_dt) as distr_closing_dt -- 发放截止日期
    ,nvl(n.loan_stop_accr_int_flg, o.loan_stop_accr_int_flg) as loan_stop_accr_int_flg -- 贷款停息标志
    ,nvl(n.dis_loan_adv_repay_low_fine, o.dis_loan_adv_repay_low_fine) as dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,nvl(n.adv_repay_low_compst_gold, o.adv_repay_low_compst_gold) as adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,nvl(n.max_renew_cnt, o.max_renew_cnt) as max_renew_cnt -- 最大展期次数
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.subtn_deduct_idf_cd, o.subtn_deduct_idf_cd) as subtn_deduct_idf_cd -- 持续扣款标识代码
    ,nvl(n.incremt_distr_flg, o.incremt_distr_flg) as incremt_distr_flg -- 增量发放标志
    ,nvl(n.loan_cate_cd, o.loan_cate_cd) as loan_cate_cd -- 贷款类别代码
    ,nvl(n.force_grace_flag, o.force_grace_flag) as force_grace_flag -- 宽限期遇节假日顺延标志
    ,nvl(n.grace_charge_int_flag, o.grace_charge_int_flag) as grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,nvl(n.grace_pric_flg, o.grace_pric_flg) as grace_pric_flg -- 宽限本金标志
    ,nvl(n.grace_int_flg, o.grace_int_flg) as grace_int_flg -- 宽限利息标志
    ,nvl(n.coll_loan_stamp_tax_flg, o.coll_loan_stamp_tax_flg) as coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,nvl(n.prtcpt_bk_contri_amt, o.prtcpt_bk_contri_amt) as prtcpt_bk_contri_amt -- 参与行出资金额
    ,nvl(n.tax_idf_cd, o.tax_idf_cd) as tax_idf_cd -- 收税标识代码
    ,nvl(n.syn_loan_distr_cnt, o.syn_loan_distr_cnt) as syn_loan_distr_cnt -- 银团贷款发放次数
    ,nvl(n.grace_period_minor_type_cd, o.grace_period_minor_type_cd) as grace_period_minor_type_cd -- 宽限期次类型代码
    ,nvl(n.grace_charge_odi_flag, o.grace_charge_odi_flag) as grace_charge_odi_flag -- 宽限期内收复利标志
    ,nvl(n.acrs_mon_idf_cd, o.acrs_mon_idf_cd) as acrs_mon_idf_cd -- 跨月标识代码
    ,nvl(n.free_int_term_days, o.free_int_term_days) as free_int_term_days -- 免息期天数
    ,nvl(n.adv_col_int_flg, o.adv_col_int_flg) as adv_col_int_flg -- 提前收息标志
    ,nvl(n.cap_char_cd, o.cap_char_cd) as cap_char_cd -- 资金性质代码
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.cust_abbr, o.cust_abbr) as cust_abbr -- 客户简称
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.promis_lmt, o.promis_lmt) as promis_lmt -- 承诺额
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.soc_ratio, o.soc_ratio) as soc_ratio -- 理赔比例
    ,nvl(n.ovdue_soc_days, o.ovdue_soc_days) as ovdue_soc_days -- 逾期理赔天数
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.natnal_econ_dept_type_cd, o.natnal_econ_dept_type_cd) as natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loan_num = n.loan_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.loan_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.loan_num is null
    )
    or (
        o.rela_loan_num <> n.rela_loan_num
        or o.tran_sign_dt <> n.tran_sign_dt
        or o.bar_flg <> n.bar_flg
        or o.repay_flg <> n.repay_flg
        or o.entr_loan_stl_idf_cd <> n.entr_loan_stl_idf_cd
        or o.loan_sign_cont_amt <> n.loan_sign_cont_amt
        or o.grace_period <> n.grace_period
        or o.grace_period_corp_cd <> n.grace_period_corp_cd
        or o.coll_pnlt_flg <> n.coll_pnlt_flg
        or o.coll_comp_int_flg <> n.coll_comp_int_flg
        or o.coll_pnlt_comp_int_flg <> n.coll_pnlt_comp_int_flg
        or o.coll_comp_int_comp_flg <> n.coll_comp_int_comp_flg
        or o.mpr_flg <> n.mpr_flg
        or o.adv_rpp_compst_amt <> n.adv_rpp_compst_amt
        or o.distr_closing_dt <> n.distr_closing_dt
        or o.loan_stop_accr_int_flg <> n.loan_stop_accr_int_flg
        or o.dis_loan_adv_repay_low_fine <> n.dis_loan_adv_repay_low_fine
        or o.adv_repay_low_compst_gold <> n.adv_repay_low_compst_gold
        or o.max_renew_cnt <> n.max_renew_cnt
        or o.cont_id <> n.cont_id
        or o.subtn_deduct_idf_cd <> n.subtn_deduct_idf_cd
        or o.incremt_distr_flg <> n.incremt_distr_flg
        or o.loan_cate_cd <> n.loan_cate_cd
        or o.force_grace_flag <> n.force_grace_flag
        or o.grace_charge_int_flag <> n.grace_charge_int_flag
        or o.grace_pric_flg <> n.grace_pric_flg
        or o.grace_int_flg <> n.grace_int_flg
        or o.coll_loan_stamp_tax_flg <> n.coll_loan_stamp_tax_flg
        or o.prtcpt_bk_contri_amt <> n.prtcpt_bk_contri_amt
        or o.tax_idf_cd <> n.tax_idf_cd
        or o.syn_loan_distr_cnt <> n.syn_loan_distr_cnt
        or o.grace_period_minor_type_cd <> n.grace_period_minor_type_cd
        or o.grace_charge_odi_flag <> n.grace_charge_odi_flag
        or o.acrs_mon_idf_cd <> n.acrs_mon_idf_cd
        or o.free_int_term_days <> n.free_int_term_days
        or o.adv_col_int_flg <> n.adv_col_int_flg
        or o.cap_char_cd <> n.cap_char_cd
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.cust_abbr <> n.cust_abbr
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.promis_lmt <> n.promis_lmt
        or o.tran_teller_id <> n.tran_teller_id
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.soc_ratio <> n.soc_ratio
        or o.ovdue_soc_days <> n.ovdue_soc_days
        or o.corp_size_cd <> n.corp_size_cd
        or o.natnal_econ_dept_type_cd <> n.natnal_econ_dept_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,rela_loan_num -- 关联贷款号
    ,tran_sign_dt -- 交易签约日期
    ,bar_flg -- 随借随还标志
    ,repay_flg -- 随还标志
    ,entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,grace_period -- 宽限期
    ,grace_period_corp_cd -- 宽限期单位代码
    ,coll_pnlt_flg -- 收取罚息标志
    ,coll_comp_int_flg -- 收取复利标志
    ,coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,coll_comp_int_comp_flg -- 收取复利的复利标志
    ,mpr_flg -- 利随本清标志
    ,adv_rpp_compst_amt -- 提前还本补偿金额
    ,distr_closing_dt -- 发放截止日期
    ,loan_stop_accr_int_flg -- 贷款停息标志
    ,dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,max_renew_cnt -- 最大展期次数
    ,cont_id -- 合同编号
    ,subtn_deduct_idf_cd -- 持续扣款标识代码
    ,incremt_distr_flg -- 增量发放标志
    ,loan_cate_cd -- 贷款类别代码
    ,force_grace_flag -- 宽限期遇节假日顺延标志
    ,grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,grace_pric_flg -- 宽限本金标志
    ,grace_int_flg -- 宽限利息标志
    ,coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,prtcpt_bk_contri_amt -- 参与行出资金额
    ,tax_idf_cd -- 收税标识代码
    ,syn_loan_distr_cnt -- 银团贷款发放次数
    ,grace_period_minor_type_cd -- 宽限期次类型代码
    ,grace_charge_odi_flag -- 宽限期内收复利标志
    ,acrs_mon_idf_cd -- 跨月标识代码
    ,free_int_term_days -- 免息期天数
    ,adv_col_int_flg -- 提前收息标志
    ,cap_char_cd -- 资金性质代码
    ,auto_payoff_flg -- 自动结清标志
    ,cust_abbr -- 客户简称
    ,loan_usage_cd -- 贷款用途代码
    ,promis_lmt -- 承诺额
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,soc_ratio -- 理赔比例
    ,ovdue_soc_days -- 逾期理赔天数
    ,corp_size_cd -- 企业规模代码
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.loan_num -- 贷款号
    ,o.rela_loan_num -- 关联贷款号
    ,o.tran_sign_dt -- 交易签约日期
    ,o.bar_flg -- 随借随还标志
    ,o.repay_flg -- 随还标志
    ,o.entr_loan_stl_idf_cd -- 委托贷款结算标识代码
    ,o.loan_sign_cont_amt -- 贷款签约合同金额
    ,o.grace_period -- 宽限期
    ,o.grace_period_corp_cd -- 宽限期单位代码
    ,o.coll_pnlt_flg -- 收取罚息标志
    ,o.coll_comp_int_flg -- 收取复利标志
    ,o.coll_pnlt_comp_int_flg -- 收取罚息的复利标志
    ,o.coll_comp_int_comp_flg -- 收取复利的复利标志
    ,o.mpr_flg -- 利随本清标志
    ,o.adv_rpp_compst_amt -- 提前还本补偿金额
    ,o.distr_closing_dt -- 发放截止日期
    ,o.loan_stop_accr_int_flg -- 贷款停息标志
    ,o.dis_loan_adv_repay_low_fine -- 折扣贷款提前还款最低罚金
    ,o.adv_repay_low_compst_gold -- 提前还款最低补偿金
    ,o.max_renew_cnt -- 最大展期次数
    ,o.cont_id -- 合同编号
    ,o.subtn_deduct_idf_cd -- 持续扣款标识代码
    ,o.incremt_distr_flg -- 增量发放标志
    ,o.loan_cate_cd -- 贷款类别代码
    ,o.force_grace_flag -- 宽限期遇节假日顺延标志
    ,o.grace_charge_int_flag -- 到期本金在宽限期收息标志
    ,o.grace_pric_flg -- 宽限本金标志
    ,o.grace_int_flg -- 宽限利息标志
    ,o.coll_loan_stamp_tax_flg -- 收取贷款印花税标志
    ,o.prtcpt_bk_contri_amt -- 参与行出资金额
    ,o.tax_idf_cd -- 收税标识代码
    ,o.syn_loan_distr_cnt -- 银团贷款发放次数
    ,o.grace_period_minor_type_cd -- 宽限期次类型代码
    ,o.grace_charge_odi_flag -- 宽限期内收复利标志
    ,o.acrs_mon_idf_cd -- 跨月标识代码
    ,o.free_int_term_days -- 免息期天数
    ,o.adv_col_int_flg -- 提前收息标志
    ,o.cap_char_cd -- 资金性质代码
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.cust_abbr -- 客户简称
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.promis_lmt -- 承诺额
    ,o.tran_teller_id -- 交易柜员编号
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.soc_ratio -- 理赔比例
    ,o.ovdue_soc_days -- 逾期理赔天数
    ,o.corp_size_cd -- 企业规模代码
    ,o.natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loan_num = n.loan_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.loan_num = d.loan_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_attach_info_h;
--alter table ${iml_schema}.agt_loan_acct_attach_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_acct_attach_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_attach_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_attach_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_attach_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_attach_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
