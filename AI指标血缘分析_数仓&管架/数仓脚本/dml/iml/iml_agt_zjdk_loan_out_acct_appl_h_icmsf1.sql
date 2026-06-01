/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_zjdk_loan_out_acct_appl_h_icmsf1
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
alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_business_putout-1
insert into ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206010'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.APPLYDATE -- 申请日期
    ,P1.STARTDATE -- 确认日期
    ,P1.ENDDATE -- 到期日期
    ,P1.PRODUCTID -- 产品编号
    ,P1.INTRATE -- 贷款年利率
    ,to_number(nvl(trim(P1.TERMMONTH),'0')) -- 月期限
    ,nvl(trim(P1.USAGE),'000000') -- 贷款用途代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,nvl(trim(P1.REPAYCYCLE),'-') -- 还款周期单位代码
    ,P1.PERIODS -- 贷款总期数
    ,P1.GRACEPERIOD -- 宽限天数
    ,P1.LOANID -- 借据编号
    ,P1.ACCOUNTID -- 授信编号
    ,P1.MCHID -- 商户编号
    ,P1.APPID -- 商户应用编号
    ,P1.SERIALNO -- 放款流水号
    ,P1.ORDERNO -- 放款支付订单编号
    ,${iml_schema}.dateformat_min(P1.TRADETIME) -- 放款发起日期
    ,${iml_schema}.dateformat_max2(P1.FINISHTIME) -- 放款完成日期
    ,nvl(trim(P1.STATUS),'-') -- 放款状态代码
    ,to_number(nvl(trim(P1.AMOUNT),'0')) -- 放款总金额
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.CARDID -- 放款银行卡号
    ,P1.ACCOUNTNAME -- 放款账户名称
    ,nvl(trim(P1.ACCOUNTTYPE),'-') -- 放款银行卡类型代码
    ,P1.BANKPHONE -- 放款账户预留手机号码
    ,P1.CNAPSCODE -- 放款联行号
    ,P1.TRADENO -- 平台放款订单编号
    ,${iml_schema}.dateformat_max2(P1.LOANRESPTIME) -- 放款交易成功日期
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.CURRDATE -- 财务日期
    ,P1.LEADER -- 牵头方
    ,P1.PARTNER -- 合作方
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CERTTYPE),'0000') -- 证件类型代码
    ,P1.CERTID -- 证件号码
    ,nvl(trim(P1.COUNTERPARTYACCOUNTTYPE),'-') -- 交易对手账户类型代码
    ,P1.COUNTERPARTYNAME -- 交易对手开户银行名称
    ,P1.COUNTERPARTYACCOUNTNO -- 交易对手账户编号
    ,nvl(trim(P1.BANKACCOUNTTYPE),'-') -- 交易对手银行卡类型代码
    ,P1.OUTLOANCHANNELNO -- 平台订单编号
    ,P1.EXTINFO -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_business_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_putout p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.cfm_dt, o.cfm_dt) as cfm_dt -- 确认日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.loan_year_int_rat, o.loan_year_int_rat) as loan_year_int_rat -- 贷款年利率
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_corp_cd, o.repay_ped_corp_cd) as repay_ped_corp_cd -- 还款周期单位代码
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 借据编号
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_app_id, o.mercht_app_id) as mercht_app_id -- 商户应用编号
    ,nvl(n.distr_flow_num, o.distr_flow_num) as distr_flow_num -- 放款流水号
    ,nvl(n.distr_pay_indent_id, o.distr_pay_indent_id) as distr_pay_indent_id -- 放款支付订单编号
    ,nvl(n.distr_init_dt, o.distr_init_dt) as distr_init_dt -- 放款发起日期
    ,nvl(n.distr_cmplt_dt, o.distr_cmplt_dt) as distr_cmplt_dt -- 放款完成日期
    ,nvl(n.distr_sucs_flg, o.distr_sucs_flg) as distr_sucs_flg -- 放款状态代码
    ,nvl(n.distr_tot_amt, o.distr_tot_amt) as distr_tot_amt -- 放款总金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.distr_bank_card_num, o.distr_bank_card_num) as distr_bank_card_num -- 放款银行卡号
    ,nvl(n.distr_acct_name, o.distr_acct_name) as distr_acct_name -- 放款账户名称
    ,nvl(n.distr_bank_card_type_cd, o.distr_bank_card_type_cd) as distr_bank_card_type_cd -- 放款银行卡类型代码
    ,nvl(n.distr_acct_rsrv_mobile_no, o.distr_acct_rsrv_mobile_no) as distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,nvl(n.distr_ibank_no, o.distr_ibank_no) as distr_ibank_no -- 放款联行号
    ,nvl(n.plat_distr_indent_id, o.plat_distr_indent_id) as plat_distr_indent_id -- 平台放款订单编号
    ,nvl(n.distr_tran_sucs_dt, o.distr_tran_sucs_dt) as distr_tran_sucs_dt -- 放款交易成功日期
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.fin_dt, o.fin_dt) as fin_dt -- 财务日期
    ,nvl(n.header, o.header) as header -- 牵头方
    ,nvl(n.partner, o.partner) as partner -- 合作方
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cntpty_acct_type_cd, o.cntpty_acct_type_cd) as cntpty_acct_type_cd -- 交易对手账户类型代码
    ,nvl(n.cntpty_open_acct_bank_name, o.cntpty_open_acct_bank_name) as cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_bank_card_type_cd, o.cntpty_bank_card_type_cd) as cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,nvl(n.plat_indent_id, o.plat_indent_id) as plat_indent_id -- 平台订单编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.appl_dt <> n.appl_dt
        or o.cfm_dt <> n.cfm_dt
        or o.exp_dt <> n.exp_dt
        or o.prod_id <> n.prod_id
        or o.loan_year_int_rat <> n.loan_year_int_rat
        or o.mon_tenor <> n.mon_tenor
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_corp_cd <> n.repay_ped_corp_cd
        or o.loan_tot_perds <> n.loan_tot_perds
        or o.grace_days <> n.grace_days
        or o.intnal_dubil_id <> n.intnal_dubil_id
        or o.crdt_id <> n.crdt_id
        or o.mercht_id <> n.mercht_id
        or o.mercht_app_id <> n.mercht_app_id
        or o.distr_flow_num <> n.distr_flow_num
        or o.distr_pay_indent_id <> n.distr_pay_indent_id
        or o.distr_init_dt <> n.distr_init_dt
        or o.distr_cmplt_dt <> n.distr_cmplt_dt
        or o.distr_sucs_flg <> n.distr_sucs_flg
        or o.distr_tot_amt <> n.distr_tot_amt
        or o.curr_cd <> n.curr_cd
        or o.distr_bank_card_num <> n.distr_bank_card_num
        or o.distr_acct_name <> n.distr_acct_name
        or o.distr_bank_card_type_cd <> n.distr_bank_card_type_cd
        or o.distr_acct_rsrv_mobile_no <> n.distr_acct_rsrv_mobile_no
        or o.distr_ibank_no <> n.distr_ibank_no
        or o.plat_distr_indent_id <> n.plat_distr_indent_id
        or o.distr_tran_sucs_dt <> n.distr_tran_sucs_dt
        or o.cont_id <> n.cont_id
        or o.fin_dt <> n.fin_dt
        or o.header <> n.header
        or o.partner <> n.partner
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.cntpty_acct_type_cd <> n.cntpty_acct_type_cd
        or o.cntpty_open_acct_bank_name <> n.cntpty_open_acct_bank_name
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_bank_card_type_cd <> n.cntpty_bank_card_type_cd
        or o.plat_indent_id <> n.plat_indent_id
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,cfm_dt -- 确认日期
    ,exp_dt -- 到期日期
    ,prod_id -- 产品编号
    ,loan_year_int_rat -- 贷款年利率
    ,mon_tenor -- 月期限
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,loan_tot_perds -- 贷款总期数
    ,grace_days -- 宽限天数
    ,intnal_dubil_id -- 借据编号
    ,crdt_id -- 授信编号
    ,mercht_id -- 商户编号
    ,mercht_app_id -- 商户应用编号
    ,distr_flow_num -- 放款流水号
    ,distr_pay_indent_id -- 放款支付订单编号
    ,distr_init_dt -- 放款发起日期
    ,distr_cmplt_dt -- 放款完成日期
    ,distr_sucs_flg -- 放款状态代码
    ,distr_tot_amt -- 放款总金额
    ,curr_cd -- 币种代码
    ,distr_bank_card_num -- 放款银行卡号
    ,distr_acct_name -- 放款账户名称
    ,distr_bank_card_type_cd -- 放款银行卡类型代码
    ,distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,distr_ibank_no -- 放款联行号
    ,plat_distr_indent_id -- 平台放款订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,cont_id -- 合同编号
    ,fin_dt -- 财务日期
    ,header -- 牵头方
    ,partner -- 合作方
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cntpty_acct_type_cd -- 交易对手账户类型代码
    ,cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,plat_indent_id -- 平台订单编号
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.appl_dt -- 申请日期
    ,o.cfm_dt -- 确认日期
    ,o.exp_dt -- 到期日期
    ,o.prod_id -- 产品编号
    ,o.loan_year_int_rat -- 贷款年利率
    ,o.mon_tenor -- 月期限
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_corp_cd -- 还款周期单位代码
    ,o.loan_tot_perds -- 贷款总期数
    ,o.grace_days -- 宽限天数
    ,o.intnal_dubil_id -- 借据编号
    ,o.crdt_id -- 授信编号
    ,o.mercht_id -- 商户编号
    ,o.mercht_app_id -- 商户应用编号
    ,o.distr_flow_num -- 放款流水号
    ,o.distr_pay_indent_id -- 放款支付订单编号
    ,o.distr_init_dt -- 放款发起日期
    ,o.distr_cmplt_dt -- 放款完成日期
    ,o.distr_sucs_flg -- 放款状态代码
    ,o.distr_tot_amt -- 放款总金额
    ,o.curr_cd -- 币种代码
    ,o.distr_bank_card_num -- 放款银行卡号
    ,o.distr_acct_name -- 放款账户名称
    ,o.distr_bank_card_type_cd -- 放款银行卡类型代码
    ,o.distr_acct_rsrv_mobile_no -- 放款账户预留手机号码
    ,o.distr_ibank_no -- 放款联行号
    ,o.plat_distr_indent_id -- 平台放款订单编号
    ,o.distr_tran_sucs_dt -- 放款交易成功日期
    ,o.cont_id -- 合同编号
    ,o.fin_dt -- 财务日期
    ,o.header -- 牵头方
    ,o.partner -- 合作方
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.cntpty_acct_type_cd -- 交易对手账户类型代码
    ,o.cntpty_open_acct_bank_name -- 交易对手开户银行名称
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_bank_card_type_cd -- 交易对手银行卡类型代码
    ,o.plat_indent_id -- 平台订单编号
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_bk o
    left join ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h;
--alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_zjdk_loan_out_acct_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl;
alter table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_zjdk_loan_out_acct_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_zjdk_loan_out_acct_appl_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_zjdk_loan_out_acct_appl_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
