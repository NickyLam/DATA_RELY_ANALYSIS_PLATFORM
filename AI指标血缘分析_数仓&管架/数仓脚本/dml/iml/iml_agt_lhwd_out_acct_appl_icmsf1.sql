/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lhwd_out_acct_appl_icmsf1
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
alter table ${iml_schema}.agt_lhwd_out_acct_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_out_acct_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_out_acct_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_out_acct_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_out_acct_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lhwd_business_putout-1
insert into ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206019'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 出账流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.PUTOUTSTATUS END -- 出账状态代码
    ,P1.BUSINESSSUM -- 出账金额
    ,P1.PUTOUTTIME -- 出账日期
    ,P1.PUTOUTORGID -- 出账机构编号
    ,P1.RELACONTRACTNO -- 合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 支付方式代码
    ,P1.BIZDATE -- 业务日期
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,P1.STARTDATE -- 贷款生效日期
    ,P1.MATURITY -- 贷款到期日期
    ,nvl(trim(P1.ISCYCLE),'-') -- 循环标志
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主要担保方式代码
    ,nvl(trim(P1.NATIONALINDUSTRYTYPE),'-') -- 贷款投向行业代码
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,to_number(nvl(trim(P1.GRACEPERIOD),0)) -- 宽限期
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,P1.EXECUTERATE -- 执行利率
    ,nvl(trim(P1.CREDITCHANNEL),'-') -- 授信渠道代码
    ,P1.BANKCONTRIRATIO -- 银行出资比例
    ,P1.TRANSCATIONNO -- 清算交易编号
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.FLOATRANGE -- 利率浮动点差
    ,P1.OVERDUERATE -- 逾期利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动比例
    ,P1.BANKRESERVEPHONE -- 银行卡预留手机号
    ,P1.PAYMENTACCOUNTNO -- 入账账户编号
    ,P1.PAYMENTACCOUNTNAME -- 入账账户名称
    ,P1.PAYMENTACCOUNTBANKNAME -- 入账账户开户机构名称
    ,nvl(trim(P1.PAYMENTACCOUNTTYPE),'-') -- 入账账户类型代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.REPAYCYCLE END -- 还款周期单位代码
    ,P1.REPAYACCOUNTNO -- 还款账户编号
    ,P1.REPAYACCOUNTNAME -- 还款账户名称
    ,nvl(trim(P1.REPAYACCOUNTTYPE),'-') -- 还款账户类型代码
    ,P1.REPAYACCOUNTBANKNAME -- 还款账户开户机构名称
    ,P1.THIRDREQUESTNO -- 合作方出账流水号
    ,P1.THIRDDUEBILLSERIALNO -- 合作方借据编号
    ,P1.PRODUCTNO -- 合作方产品编号
    ,P1.APPLYNO -- 合作方全局流水号
    ,nvl(trim(P1.BUSINESSMODEL),'-') -- 合作方业务模式代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_business_putout' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lhwd_business_putout p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PUTOUTSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_LHWD_BUSINESS_PUTOUT'
        AND R1.SRC_FIELD_EN_NAME= 'PUTOUTSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LHWD_OUT_ACCT_APPL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'OUT_ACCT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.REPAYCYCLE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_LHWD_BUSINESS_PUTOUT'
        AND R2.SRC_FIELD_EN_NAME= 'REPAYCYCLE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LHWD_OUT_ACCT_APPL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REPAY_PED_CORP_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.out_acct_status_cd, o.out_acct_status_cd) as out_acct_status_cd -- 出账状态代码
    ,nvl(n.out_acct_amt, o.out_acct_amt) as out_acct_amt -- 出账金额
    ,nvl(n.out_acct_dt, o.out_acct_dt) as out_acct_dt -- 出账日期
    ,nvl(n.out_acct_org_id, o.out_acct_org_id) as out_acct_org_id -- 出账机构编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.bus_dt, o.bus_dt) as bus_dt -- 业务日期
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.loan_effect_dt, o.loan_effect_dt) as loan_effect_dt -- 贷款生效日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.major_guar_way_cd, o.major_guar_way_cd) as major_guar_way_cd -- 主要担保方式代码
    ,nvl(n.loan_dir_indus_cd, o.loan_dir_indus_cd) as loan_dir_indus_cd -- 贷款投向行业代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.clear_tran_id, o.clear_tran_id) as clear_tran_id -- 清算交易编号
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_float_spread, o.int_rat_float_spread) as int_rat_float_spread -- 利率浮动点差
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_fl_rt, o.ovdue_int_rat_fl_rt) as ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,nvl(n.bank_card_rsrv_mobile_no, o.bank_card_rsrv_mobile_no) as bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_open_acct_org_name, o.enter_open_acct_org_name) as enter_open_acct_org_name -- 入账账户开户机构名称
    ,nvl(n.enter_type_cd, o.enter_type_cd) as enter_type_cd -- 入账账户类型代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_corp_cd, o.repay_ped_corp_cd) as repay_ped_corp_cd -- 还款周期单位代码
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账户编号
    ,nvl(n.repay_num_name, o.repay_num_name) as repay_num_name -- 还款账户名称
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账户类型代码
    ,nvl(n.repay_num_open_acct_org_name, o.repay_num_open_acct_org_name) as repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,nvl(n.partner_out_acct_flow_num, o.partner_out_acct_flow_num) as partner_out_acct_flow_num -- 合作方出账流水号
    ,nvl(n.partner_dubil_id, o.partner_dubil_id) as partner_dubil_id -- 合作方借据编号
    ,nvl(n.partner_prod_id, o.partner_prod_id) as partner_prod_id -- 合作方产品编号
    ,nvl(n.partner_ova_flow_num, o.partner_ova_flow_num) as partner_ova_flow_num -- 合作方全局流水号
    ,nvl(n.partner_bus_mode_cd, o.partner_bus_mode_cd) as partner_bus_mode_cd -- 合作方业务模式代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.out_acct_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.out_acct_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.out_acct_flow_num is null
    )
    or (
        o.out_acct_status_cd <> n.out_acct_status_cd
        or o.out_acct_amt <> n.out_acct_amt
        or o.out_acct_dt <> n.out_acct_dt
        or o.out_acct_org_id <> n.out_acct_org_id
        or o.cont_id <> n.cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.bus_dt <> n.bus_dt
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.loan_effect_dt <> n.loan_effect_dt
        or o.loan_exp_dt <> n.loan_exp_dt
        or o.circl_flg <> n.circl_flg
        or o.major_guar_way_cd <> n.major_guar_way_cd
        or o.loan_dir_indus_cd <> n.loan_dir_indus_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.grace_period <> n.grace_period
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.crdt_chn_cd <> n.crdt_chn_cd
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.clear_tran_id <> n.clear_tran_id
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_float_spread <> n.int_rat_float_spread
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_fl_rt <> n.ovdue_int_rat_fl_rt
        or o.bank_card_rsrv_mobile_no <> n.bank_card_rsrv_mobile_no
        or o.enter_id <> n.enter_id
        or o.enter_name <> n.enter_name
        or o.enter_open_acct_org_name <> n.enter_open_acct_org_name
        or o.enter_type_cd <> n.enter_type_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_corp_cd <> n.repay_ped_corp_cd
        or o.repay_num_id <> n.repay_num_id
        or o.repay_num_name <> n.repay_num_name
        or o.repay_num_type_cd <> n.repay_num_type_cd
        or o.repay_num_open_acct_org_name <> n.repay_num_open_acct_org_name
        or o.partner_out_acct_flow_num <> n.partner_out_acct_flow_num
        or o.partner_dubil_id <> n.partner_dubil_id
        or o.partner_prod_id <> n.partner_prod_id
        or o.partner_ova_flow_num <> n.partner_ova_flow_num
        or o.partner_bus_mode_cd <> n.partner_bus_mode_cd
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_status_cd -- 出账状态代码
    ,out_acct_amt -- 出账金额
    ,out_acct_dt -- 出账日期
    ,out_acct_org_id -- 出账机构编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,apv_status_cd -- 审批状态代码
    ,mode_pay_cd -- 支付方式代码
    ,bus_dt -- 业务日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,loan_effect_dt -- 贷款生效日期
    ,loan_exp_dt -- 贷款到期日期
    ,circl_flg -- 循环标志
    ,major_guar_way_cd -- 主要担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,grace_period -- 宽限期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,crdt_chn_cd -- 授信渠道代码
    ,bank_contri_ratio -- 银行出资比例
    ,clear_tran_id -- 清算交易编号
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,enter_id -- 入账账户编号
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,enter_type_cd -- 入账账户类型代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_name -- 还款账户名称
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,partner_out_acct_flow_num -- 合作方出账流水号
    ,partner_dubil_id -- 合作方借据编号
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
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
    ,o.out_acct_flow_num -- 出账流水号
    ,o.out_acct_status_cd -- 出账状态代码
    ,o.out_acct_amt -- 出账金额
    ,o.out_acct_dt -- 出账日期
    ,o.out_acct_org_id -- 出账机构编号
    ,o.cont_id -- 合同编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.mode_pay_cd -- 支付方式代码
    ,o.bus_dt -- 业务日期
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.loan_effect_dt -- 贷款生效日期
    ,o.loan_exp_dt -- 贷款到期日期
    ,o.circl_flg -- 循环标志
    ,o.major_guar_way_cd -- 主要担保方式代码
    ,o.loan_dir_indus_cd -- 贷款投向行业代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.grace_period -- 宽限期
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.clear_tran_id -- 清算交易编号
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_float_spread -- 利率浮动点差
    ,o.ovdue_int_rat -- 逾期利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,o.bank_card_rsrv_mobile_no -- 银行卡预留手机号
    ,o.enter_id -- 入账账户编号
    ,o.enter_name -- 入账账户名称
    ,o.enter_open_acct_org_name -- 入账账户开户机构名称
    ,o.enter_type_cd -- 入账账户类型代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_corp_cd -- 还款周期单位代码
    ,o.repay_num_id -- 还款账户编号
    ,o.repay_num_name -- 还款账户名称
    ,o.repay_num_type_cd -- 还款账户类型代码
    ,o.repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,o.partner_out_acct_flow_num -- 合作方出账流水号
    ,o.partner_dubil_id -- 合作方借据编号
    ,o.partner_prod_id -- 合作方产品编号
    ,o.partner_ova_flow_num -- 合作方全局流水号
    ,o.partner_bus_mode_cd -- 合作方业务模式代码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.out_acct_flow_num = n.out_acct_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.out_acct_flow_num = d.out_acct_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lhwd_out_acct_appl;
--alter table ${iml_schema}.agt_lhwd_out_acct_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lhwd_out_acct_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lhwd_out_acct_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lhwd_out_acct_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lhwd_out_acct_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lhwd_out_acct_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lhwd_out_acct_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lhwd_out_acct_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lhwd_out_acct_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
