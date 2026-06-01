/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_out_acct_appl_h_icmsf1
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
alter table ${iml_schema}.agt_loan_out_acct_appl_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_appl_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_appl_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_appl_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_out_acct_appl_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_putout-1
insert into ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm(
    agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206001'||P1.SERIALNO -- 申请编号
    ,P1.SERIALNO -- 出账流水号
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.CONTRACTSUM -- 合同金额
    ,P1.BUSINESSSUM -- 本次放款金额
    ,nvl(trim(P1.OCCURTYPE),'-') -- 贷款发放类型代码
    ,P1.OCCURDATE -- 发生日期
    ,P1.PUTOUTDATE -- 发放日期
    ,P1.MATURITY -- 到期日期
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,P1.FIXEDRATE -- 固定利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动类型代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,P1.FLOATRANGE -- 利率浮动值
    ,P1.EXECUTERATE -- 执行利率
    ,P1.SETTLEMENTACCOUNT -- 结算账户编号
    ,P1.LOANACCOUNTNO -- 入账账户编号
    ,P1.SECONDPAYACCOUNT -- 第二还款账户编号
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,nvl(trim(P1.APPLYTYPE),'-') -- 申请方式代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(trim(P1.BELONGDEPT),'-') -- 所属条线代码
    ,nvl(trim(P1.OFFSHEETFLAG),'-') -- 表外标志
    ,nvl(trim(P1.ISLOWRISK),'-') -- 低风险标志
    ,P1.CLNO -- 额度编号
    ,nvl(trim(P1.PAYFREQUENCYUNIT),'-') -- 指定周期单位代码
    ,nvl(trim(P1.PAYFREQUENCY),'-') -- 指定周期代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,case when P1.REPAYCYCLE='06' then '1'  else to_char(nvl(substr( P1.REPAYCYCLE,2,1),0)) end -- 还款周期
    ,case when P1.REPAYCYCLE='06' then 'O' else nvl(trim(substr(P1.REPAYCYCLE,1,1)),'-') end -- 还款周期单位代码
    ,P1.REPAYDATE -- 默认还款日
    ,P1.OVERDUERATE -- 逾期执行利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEDATE -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,'9999' -- 法人编号
    ,P1.ARTIFICIALNO -- 文本合同编号
    ,P1.BAILACCOUNT -- 保证金账户编号
    ,P1.BAILTRANSACCOUNT -- 保证金转出账户编号
    ,nvl(trim(P1.BAILCURRENCY),'-') -- 保证金币种代码
    ,P1.BAILRATIO -- 保证金比例
    ,P1.BAILSUBACCOUNT -- 保证金子账号
    ,P1.BAILSUM -- 保证金金额
    ,P1.DUEBILLSERIALNO -- 借据编号
    ,P1.SUBJECTNO -- 科目编号
    ,P1.PUTOUTORGID -- 出账机构编号
    ,P1.LENDINGORGID -- 贷款机构编号
    ,nvl(trim(P1.INTERESTREPAYCYCLE),'-') -- 结息频率代码
    ,P1.LOANACCOUNTORGID -- 入账账户开户机构编号
    ,P1.LOANACCOUNTNAME -- 入账账户名称
    ,P1.LOANACCOUNTNOSUB -- 入账账户子账号
    ,nvl(trim(P1.PDGPAYMETHOD),'-') -- 手续费计收方式代码
    ,P1.PDGACCOUNTNO -- 手续费扣费账户编号
    ,P1.PDGAMORFG -- 手续费摊销标志
    ,P1.PDGPAYPERCENT -- 手续费率
    ,P1.PDGSUM -- 手续费金额
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,P1.COMMISSIONPAYSUM -- 受托支付金额
    ,P1.ZFTRANSSERIALNO -- 受托支付止付流水号
    ,${iml_schema}.dateformat_max2(P1.PIGEONHOLEDATE) -- 归档日期
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主要担保方式代码
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,nvl(trim(P1.EXCHANGESTATE),'-') -- 交易状态代码
    ,${iml_schema}.timeformat_min(P1.EXCHANGETIME) -- 交易时间
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE) -- 核心交易日期
    ,P1.TRANSSERIALNO -- 核心交易流水号
    ,P1.SETTLEMENTACCOUNTNAME -- 结算账户名称
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.MIGTFLAG -- 迁移备注
    ,nvl(trim(P1.ISPENSIONINDUSTRY),'-') -- 养老产业标志
    ,P1.OTHCUSTOMERID -- 对手客户编号
    ,P1.OTHCUSTOMERNAME -- 对手客户名称
    ,P1.HANGSEQNO -- 挂账账户序列号
    ,P1.LOANACCOUNTBANKNAME -- 结算账户开户银行
    ,P1.JXHJDUEBILLNO -- 借新还旧借据编号
    ,P1.BPSPREADS -- 合同点差
    ,nvl(trim(P1.RATEFLOATRATIOORBP),'-') -- 利率浮动方式代码
    ,nvl(trim(P1.LPRREFERTYPE),'-') -- LPR参照方式代码
    ,nvl(trim(P1.ISFIRSTLOANS),'-') -- 首次放款标志
    ,${iml_schema}.dateformat_max2(P1.NEXTSETTLEMENTDATE) -- 下一结息日期
    ,P1.RELACONTRACTNO -- 占用承兑行额度编号
    ,P1.FLOWTYPE -- 流程类型代码
    ,nvl(trim(P1.ENTSCALE),'0') -- 企业规模代码
    ,nvl(trim(P1.PUTOUTCONTROL),'-') -- 允许到期超批复半年标志
    ,nvl(trim(P1.ECODEPARTMENTCODE),'000') -- 国民经济类型代码
    ,nvl(trim(P1.remart),'XXX') -- 资产三分类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_putout p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,out_acct_flow_num
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
        into ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl(
            agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op(
            agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 申请编号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.ths_tm_distr_amt, o.ths_tm_distr_amt) as ths_tm_distr_amt -- 本次放款金额
    ,nvl(n.loan_distr_type_cd, o.loan_distr_type_cd) as loan_distr_type_cd -- 贷款发放类型代码
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 发生日期
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 发放日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.fix_int_rat, o.fix_int_rat) as fix_int_rat -- 固定利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_flo_val, o.int_rat_flo_val) as int_rat_flo_val -- 利率浮动值
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.secd_repay_acct_id, o.secd_repay_acct_id) as secd_repay_acct_id -- 第二还款账户编号
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.appl_way_cd, o.appl_way_cd) as appl_way_cd -- 申请方式代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.off_bs_flg, o.off_bs_flg) as off_bs_flg -- 表外标志
    ,nvl(n.low_risk_flg, o.low_risk_flg) as low_risk_flg -- 低风险标志
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.spec_ped_corp_cd, o.spec_ped_corp_cd) as spec_ped_corp_cd -- 指定周期单位代码
    ,nvl(n.spec_ped_cd, o.spec_ped_cd) as spec_ped_cd -- 指定周期代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped, o.repay_ped) as repay_ped -- 还款周期
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期单位代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.ovdue_exec_int_rat, o.ovdue_exec_int_rat) as ovdue_exec_int_rat -- 逾期执行利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.bus_oper_teller_id, o.bus_oper_teller_id) as bus_oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.text_cont_id, o.text_cont_id) as text_cont_id -- 文本合同编号
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_tran_out_acct_id, o.margin_tran_out_acct_id) as margin_tran_out_acct_id -- 保证金转出账户编号
    ,nvl(n.margin_curr_cd, o.margin_curr_cd) as margin_curr_cd -- 保证金币种代码
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_sub_acct_num, o.margin_sub_acct_num) as margin_sub_acct_num -- 保证金子账号
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.subj_id, o.subj_id) as subj_id -- 科目编号
    ,nvl(n.out_acct_org_id, o.out_acct_org_id) as out_acct_org_id -- 出账机构编号
    ,nvl(n.loan_org_id, o.loan_org_id) as loan_org_id -- 贷款机构编号
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 结息频率代码
    ,nvl(n.enter_open_acct_org_id, o.enter_open_acct_org_id) as enter_open_acct_org_id -- 入账账户开户机构编号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_sub_acct_num, o.enter_sub_acct_num) as enter_sub_acct_num -- 入账账户子账号
    ,nvl(n.comm_fee_collect_way_cd, o.comm_fee_collect_way_cd) as comm_fee_collect_way_cd -- 手续费计收方式代码
    ,nvl(n.comm_fee_deduct_acct_id, o.comm_fee_deduct_acct_id) as comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,nvl(n.comm_fee_amort_flg, o.comm_fee_amort_flg) as comm_fee_amort_flg -- 手续费摊销标志
    ,nvl(n.comm_fee_rat, o.comm_fee_rat) as comm_fee_rat -- 手续费率
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.entr_pay_amt, o.entr_pay_amt) as entr_pay_amt -- 受托支付金额
    ,nvl(n.entr_pay_stop_pay_flow_num, o.entr_pay_stop_pay_flow_num) as entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,nvl(n.file_dt, o.file_dt) as file_dt -- 归档日期
    ,nvl(n.major_guar_way_cd, o.major_guar_way_cd) as major_guar_way_cd -- 主要担保方式代码
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.core_tran_dt, o.core_tran_dt) as core_tran_dt -- 核心交易日期
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 核心交易流水号
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.provi_for_aged_property_flg, o.provi_for_aged_property_flg) as provi_for_aged_property_flg -- 养老产业标志
    ,nvl(n.cntpty_cust_id, o.cntpty_cust_id) as cntpty_cust_id -- 对手客户编号
    ,nvl(n.cntpty_cust_name, o.cntpty_cust_name) as cntpty_cust_name -- 对手客户名称
    ,nvl(n.on_acct_acct_ser_num, o.on_acct_acct_ser_num) as on_acct_acct_ser_num -- 挂账账户序列号
    ,nvl(n.stl_acct_open_acct_bank, o.stl_acct_open_acct_bank) as stl_acct_open_acct_bank -- 结算账户开户银行
    ,nvl(n.brw_new_return_old_dubil_id, o.brw_new_return_old_dubil_id) as brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,nvl(n.cont_spread, o.cont_spread) as cont_spread -- 合同点差
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.lpr_ref_way_cd, o.lpr_ref_way_cd) as lpr_ref_way_cd -- LPR参照方式代码
    ,nvl(n.fir_distr_flg, o.fir_distr_flg) as fir_distr_flg -- 首次放款标志
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.ocup_acpt_bank_lmt_id, o.ocup_acpt_bank_lmt_id) as ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,nvl(n.flow_type_cd, o.flow_type_cd) as flow_type_cd -- 流程类型代码
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.allow_exp_reply_half_y_flg, o.allow_exp_reply_half_y_flg) as allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,nvl(n.natnal_econ_type_cd, o.natnal_econ_type_cd) as natnal_econ_type_cd -- 国民经济类型代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,case when
            n.agt_id is null
            and n.out_acct_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.out_acct_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.out_acct_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.out_acct_flow_num = n.out_acct_flow_num
where (
        o.agt_id is null
        and o.out_acct_flow_num is null
    )
    or (
        n.agt_id is null
        and n.out_acct_flow_num is null
    )
    or (
        o.cont_id <> n.cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.cont_amt <> n.cont_amt
        or o.ths_tm_distr_amt <> n.ths_tm_distr_amt
        or o.loan_distr_type_cd <> n.loan_distr_type_cd
        or o.happ_dt <> n.happ_dt
        or o.distr_dt <> n.distr_dt
        or o.exp_dt <> n.exp_dt
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.fix_int_rat <> n.fix_int_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_flo_val <> n.int_rat_flo_val
        or o.exec_int_rat <> n.exec_int_rat
        or o.stl_acct_id <> n.stl_acct_id
        or o.enter_id <> n.enter_id
        or o.secd_repay_acct_id <> n.secd_repay_acct_id
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.appl_way_cd <> n.appl_way_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.off_bs_flg <> n.off_bs_flg
        or o.low_risk_flg <> n.low_risk_flg
        or o.lmt_id <> n.lmt_id
        or o.spec_ped_corp_cd <> n.spec_ped_corp_cd
        or o.spec_ped_cd <> n.spec_ped_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped <> n.repay_ped
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.ovdue_exec_int_rat <> n.ovdue_exec_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.oper_org_id <> n.oper_org_id
        or o.bus_oper_teller_id <> n.bus_oper_teller_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.lp_id <> n.lp_id
        or o.text_cont_id <> n.text_cont_id
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_tran_out_acct_id <> n.margin_tran_out_acct_id
        or o.margin_curr_cd <> n.margin_curr_cd
        or o.margin_ratio <> n.margin_ratio
        or o.margin_sub_acct_num <> n.margin_sub_acct_num
        or o.margin_amt <> n.margin_amt
        or o.dubil_id <> n.dubil_id
        or o.subj_id <> n.subj_id
        or o.out_acct_org_id <> n.out_acct_org_id
        or o.loan_org_id <> n.loan_org_id
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.enter_open_acct_org_id <> n.enter_open_acct_org_id
        or o.enter_name <> n.enter_name
        or o.enter_sub_acct_num <> n.enter_sub_acct_num
        or o.comm_fee_collect_way_cd <> n.comm_fee_collect_way_cd
        or o.comm_fee_deduct_acct_id <> n.comm_fee_deduct_acct_id
        or o.comm_fee_amort_flg <> n.comm_fee_amort_flg
        or o.comm_fee_rat <> n.comm_fee_rat
        or o.comm_fee_amt <> n.comm_fee_amt
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.entr_pay_amt <> n.entr_pay_amt
        or o.entr_pay_stop_pay_flow_num <> n.entr_pay_stop_pay_flow_num
        or o.file_dt <> n.file_dt
        or o.major_guar_way_cd <> n.major_guar_way_cd
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_tm <> n.tran_tm
        or o.core_tran_dt <> n.core_tran_dt
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.stl_acct_name <> n.stl_acct_name
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.move_remark <> n.move_remark
        or o.provi_for_aged_property_flg <> n.provi_for_aged_property_flg
        or o.cntpty_cust_id <> n.cntpty_cust_id
        or o.cntpty_cust_name <> n.cntpty_cust_name
        or o.on_acct_acct_ser_num <> n.on_acct_acct_ser_num
        or o.stl_acct_open_acct_bank <> n.stl_acct_open_acct_bank
        or o.brw_new_return_old_dubil_id <> n.brw_new_return_old_dubil_id
        or o.cont_spread <> n.cont_spread
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.lpr_ref_way_cd <> n.lpr_ref_way_cd
        or o.fir_distr_flg <> n.fir_distr_flg
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.ocup_acpt_bank_lmt_id <> n.ocup_acpt_bank_lmt_id
        or o.flow_type_cd <> n.flow_type_cd
        or o.corp_size_cd <> n.corp_size_cd
        or o.allow_exp_reply_half_y_flg <> n.allow_exp_reply_half_y_flg
        or o.natnal_econ_type_cd <> n.natnal_econ_type_cd
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl(
            agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op(
            agt_id -- 申请编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,ths_tm_distr_amt -- 本次放款金额
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,distr_dt -- 发放日期
    ,exp_dt -- 到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,stl_acct_id -- 结算账户编号
    ,enter_id -- 入账账户编号
    ,secd_repay_acct_id -- 第二还款账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,appl_way_cd -- 申请方式代码
    ,apv_status_cd -- 审批状态代码
    ,belong_strip_line_cd -- 所属条线代码
    ,off_bs_flg -- 表外标志
    ,low_risk_flg -- 低风险标志
    ,lmt_id -- 额度编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,oper_org_id -- 经办机构编号
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,lp_id -- 法人编号
    ,text_cont_id -- 文本合同编号
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_sub_acct_num -- 保证金子账号
    ,margin_amt -- 保证金金额
    ,dubil_id -- 借据编号
    ,subj_id -- 科目编号
    ,out_acct_org_id -- 出账机构编号
    ,loan_org_id -- 贷款机构编号
    ,int_accr_way_cd -- 结息频率代码
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,enter_name -- 入账账户名称
    ,enter_sub_acct_num -- 入账账户子账号
    ,comm_fee_collect_way_cd -- 手续费计收方式代码
    ,comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,comm_fee_amort_flg -- 手续费摊销标志
    ,comm_fee_rat -- 手续费率
    ,comm_fee_amt -- 手续费金额
    ,loan_usage_cd -- 贷款用途代码
    ,entr_pay_amt -- 受托支付金额
    ,entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,file_dt -- 归档日期
    ,major_guar_way_cd -- 主要担保方式代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,tran_status_cd -- 交易状态代码
    ,tran_tm -- 交易时间
    ,core_tran_dt -- 核心交易日期
    ,core_tran_flow_num -- 核心交易流水号
    ,stl_acct_name -- 结算账户名称
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,cntpty_cust_id -- 对手客户编号
    ,cntpty_cust_name -- 对手客户名称
    ,on_acct_acct_ser_num -- 挂账账户序列号
    ,stl_acct_open_acct_bank -- 结算账户开户银行
    ,brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,cont_spread -- 合同点差
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,lpr_ref_way_cd -- LPR参照方式代码
    ,fir_distr_flg -- 首次放款标志
    ,next_int_set_dt -- 下一结息日期
    ,ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,flow_type_cd -- 流程类型代码
    ,corp_size_cd -- 企业规模代码
    ,allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,natnal_econ_type_cd -- 国民经济类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 申请编号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.cont_id -- 合同编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.cont_amt -- 合同金额
    ,o.ths_tm_distr_amt -- 本次放款金额
    ,o.loan_distr_type_cd -- 贷款发放类型代码
    ,o.happ_dt -- 发生日期
    ,o.distr_dt -- 发放日期
    ,o.exp_dt -- 到期日期
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.fix_int_rat -- 固定利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_flo_val -- 利率浮动值
    ,o.exec_int_rat -- 执行利率
    ,o.stl_acct_id -- 结算账户编号
    ,o.enter_id -- 入账账户编号
    ,o.secd_repay_acct_id -- 第二还款账户编号
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.appl_way_cd -- 申请方式代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.off_bs_flg -- 表外标志
    ,o.low_risk_flg -- 低风险标志
    ,o.lmt_id -- 额度编号
    ,o.spec_ped_corp_cd -- 指定周期单位代码
    ,o.spec_ped_cd -- 指定周期代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped -- 还款周期
    ,o.repay_ped_cd -- 还款周期单位代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.ovdue_exec_int_rat -- 逾期执行利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.oper_org_id -- 经办机构编号
    ,o.bus_oper_teller_id -- 业务经办人编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.lp_id -- 法人编号
    ,o.text_cont_id -- 文本合同编号
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_tran_out_acct_id -- 保证金转出账户编号
    ,o.margin_curr_cd -- 保证金币种代码
    ,o.margin_ratio -- 保证金比例
    ,o.margin_sub_acct_num -- 保证金子账号
    ,o.margin_amt -- 保证金金额
    ,o.dubil_id -- 借据编号
    ,o.subj_id -- 科目编号
    ,o.out_acct_org_id -- 出账机构编号
    ,o.loan_org_id -- 贷款机构编号
    ,o.int_accr_way_cd -- 结息频率代码
    ,o.enter_open_acct_org_id -- 入账账户开户机构编号
    ,o.enter_name -- 入账账户名称
    ,o.enter_sub_acct_num -- 入账账户子账号
    ,o.comm_fee_collect_way_cd -- 手续费计收方式代码
    ,o.comm_fee_deduct_acct_id -- 手续费扣费账户编号
    ,o.comm_fee_amort_flg -- 手续费摊销标志
    ,o.comm_fee_rat -- 手续费率
    ,o.comm_fee_amt -- 手续费金额
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.entr_pay_amt -- 受托支付金额
    ,o.entr_pay_stop_pay_flow_num -- 受托支付止付流水号
    ,o.file_dt -- 归档日期
    ,o.major_guar_way_cd -- 主要担保方式代码
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_tm -- 交易时间
    ,o.core_tran_dt -- 核心交易日期
    ,o.core_tran_flow_num -- 核心交易流水号
    ,o.stl_acct_name -- 结算账户名称
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.move_remark -- 迁移备注
    ,o.provi_for_aged_property_flg -- 养老产业标志
    ,o.cntpty_cust_id -- 对手客户编号
    ,o.cntpty_cust_name -- 对手客户名称
    ,o.on_acct_acct_ser_num -- 挂账账户序列号
    ,o.stl_acct_open_acct_bank -- 结算账户开户银行
    ,o.brw_new_return_old_dubil_id -- 借新还旧借据编号
    ,o.cont_spread -- 合同点差
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.lpr_ref_way_cd -- LPR参照方式代码
    ,o.fir_distr_flg -- 首次放款标志
    ,o.next_int_set_dt -- 下一结息日期
    ,o.ocup_acpt_bank_lmt_id -- 占用承兑行额度编号
    ,o.flow_type_cd -- 流程类型代码
    ,o.corp_size_cd -- 企业规模代码
    ,o.allow_exp_reply_half_y_flg -- 允许到期超批复半年标志
    ,o.natnal_econ_type_cd -- 国民经济类型代码
    ,o.asset_thd_cls_cd -- 资产三分类代码
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
from ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.out_acct_flow_num = d.out_acct_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_out_acct_appl_h;
--alter table ${iml_schema}.agt_loan_out_acct_appl_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_out_acct_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_out_acct_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_out_acct_appl_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_out_acct_appl_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_out_acct_appl_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_out_acct_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_out_acct_appl_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_out_acct_appl_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
