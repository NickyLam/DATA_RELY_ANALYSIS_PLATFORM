/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_apv_basic_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_apv_basic_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_basic_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_basic_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_basic_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_apv_basic_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_approve-1
insert into ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300006'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 审批流水号
    ,P1.BASERIALNO -- 申请流水号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.APPLYTYPE),'-') -- 申请方式代码
    ,decode(trim(P1.BUSINESSFLAG),'','-','1','01','2','02','00',P1.BUSINESSFLAG) -- 额度合同标志
    ,nvl(trim(P1.OCCURTYPE),'-') -- 贷款发放类型代码
    ,P1.OCCURDATE -- 发生日期
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.BUSINESSSUM -- 审批金额
    ,P1.BASEPRODUCT -- 基础产品编号
    ,P1.PRODUCTID -- 产品编号
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,P1.STARTDATE -- 起始日期
    ,P1.MATURITY -- 到期日期
    ,nvl(trim(P1.ISREMOTEBUSINESS),'-') -- 异地业务标志
    ,nvl(trim(P1.ISCYCLE),'-') -- 额度循环标志
    ,nvl(trim(P1.RISKTYPE),'-') -- 风险类型代码
    ,nvl(trim(P1.ISLOWRISK),'-') -- 低风险业务标志
    ,nvl(trim(P1.CREDITINVEST),'-') -- 授信投向代码
    ,nvl(trim(P1.NATIONALINDUSTRYTYPE),'-') -- 国标行业投向代码
    ,nvl(trim(P1.INTRAINDUSTRYTYPE),'-') -- 行内行业投向代码
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,P1.PURPOSE -- 用途描述
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,P1.FIXEDRATE -- 固定利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动类型代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,P1.FLOATRANGE -- 利率浮动值
    ,P1.EXECUTERATE -- 执行利率
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.VOUCHTYPE2),'-') -- 担保方式代码二
    ,nvl(trim(P1.VOUCHTYPE3),'-') -- 担保方式代码三
    ,nvl(trim(P1.OTHERVOUCHTYPE),'-') -- 其他担保方式代码
    ,nvl(trim(P1.HAVEADDITIONALVOUCH),'-') -- 追加担保方式标志
    ,P1.ADDITIONCOMMAND -- 其他条件描述
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,case when P1.REPAYCYCLE='06' then '1'  
      else nvl(substr( P1.REPAYCYCLE,2,1),0) end -- 还款周期
    ,case when P1.REPAYCYCLE='06' then 'O'
      else nvl(trim(substr( P1.REPAYCYCLE,1,1)),'-') end -- 还款周期单位代码
    ,P1.REPAYDATE -- 默认还款日
    ,P1.RESERVESUM -- 预留金额
    ,P1.OLDCONTRACTNO -- 关联旧合同编号
    ,P1.CLNO -- 额度编号
    ,P1.CONTRACTFLAG -- 生成合同标志
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,nvl(trim(P1.APPROVETYPE),'-') -- 批复类型代码
    ,P1.FINALAPPROVEOPINION -- 最终审批意见描述
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,decode(P1.OPERATEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.OPERATEDATE) -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,nvl(trim(P1.BELONGDEPT),'-') -- 所属条线代码
    ,'9999' -- 法人编号
    ,nvl(trim(P1.PAYFREQUENCYUNIT),'-') -- 指定周期单位代码
    ,nvl(trim(P1.PAYFREQUENCY),'-') -- 指定周期代码
    ,P1.RENEWTERMDATE -- 展期前到期日期
    ,P1.RENEWTOTALSUM -- 展期前金额
    ,P1.RENEWEXECUTEYEARRATE -- 展期前执行年利率
    ,nvl(trim(P1.ORGANIZETYPE),'-') -- 授信组织方式代码
    ,P1.TOTALSUM -- 额度敞口金额
    ,${iml_schema}.dateformat_max2(P1.PIGEONHOLEDATE) -- 归档日期
    ,nvl(trim(P1.CLASSIFYRESULTELEVEN),'20') -- 十一级分类代码
    ,P1.REINFORCEFLAG -- 补登标志
    ,nvl(trim(P1.STATUS),'-') -- 生效标志
    ,P1.BAILACCOUNT -- 保证金账户编号
    ,P1.BAILTRANSACCOUNT -- 保证金转出账户编号
    ,nvl(trim(P1.BAILCURRENCY),'-') -- 保证金币种代码
    ,P1.BAILRATIO -- 保证金比例
    ,P1.BAILSUM -- 保证金金额
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.OVERDUERATE -- 逾期执行利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,P1.SETTLEMENTACCOUNTNAME -- 结算账户名称
    ,P1.LOANACCOUNTNO -- 入账账户编号
    ,P1.SETTLEMENTACCOUNT -- 结算账户编号
    ,P1.MIGTFLAG -- 迁移备注
    ,nvl(trim(P1.ISPENSIONINDUSTRY),'-') -- 养老产业标志
    ,P1.PARENTSERIALNO -- 上层流水号
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 风险分类结果代码
    ,nvl(trim(P1.CHECKYEARSTATUS),'-') -- 年审状态代码
    ,nvl(trim(P1.RATEFLOATRATIOORBP),'-') -- 利率浮动方式代码
    ,P1.SERIALNOCN -- 批复编号
    ,nvl(trim(P1.ISYEARTOCHECK),'-') -- 需要年审标志
    ,P1.SQCHECKYEARDATE -- 上期年审日期
    ,P1.BQCHECKYEARDATE -- 本期年审日期
    ,P1.TEMPLETENO -- 同业模板编号
    ,nvl(trim(P1.WHETHERTORESTRUCTURETHELOAN),'-') -- 重组贷款标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_approve' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_approve p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,apv_flow_num
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
        into ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.apv_flow_num, o.apv_flow_num) as apv_flow_num -- 审批流水号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.appl_way_cd, o.appl_way_cd) as appl_way_cd -- 申请方式代码
    ,nvl(n.lmt_cont_flg, o.lmt_cont_flg) as lmt_cont_flg -- 额度合同标志
    ,nvl(n.loan_distr_type_cd, o.loan_distr_type_cd) as loan_distr_type_cd -- 贷款发放类型代码
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 发生日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.apv_amt, o.apv_amt) as apv_amt -- 审批金额
    ,nvl(n.base_prod_id, o.base_prod_id) as base_prod_id -- 基础产品编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 起始日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.remote_bus_flg, o.remote_bus_flg) as remote_bus_flg -- 异地业务标志
    ,nvl(n.lmt_circl_flg, o.lmt_circl_flg) as lmt_circl_flg -- 额度循环标志
    ,nvl(n.risk_type_cd, o.risk_type_cd) as risk_type_cd -- 风险类型代码
    ,nvl(n.low_risk_bus_flg, o.low_risk_bus_flg) as low_risk_bus_flg -- 低风险业务标志
    ,nvl(n.crdt_dir_cd, o.crdt_dir_cd) as crdt_dir_cd -- 授信投向代码
    ,nvl(n.nat_std_indus_dir_cd, o.nat_std_indus_dir_cd) as nat_std_indus_dir_cd -- 国标行业投向代码
    ,nvl(n.bank_int_indus_dir_cd, o.bank_int_indus_dir_cd) as bank_int_indus_dir_cd -- 行内行业投向代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.usage_descb, o.usage_descb) as usage_descb -- 用途描述
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.fix_int_rat, o.fix_int_rat) as fix_int_rat -- 固定利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_flo_val, o.int_rat_flo_val) as int_rat_flo_val -- 利率浮动值
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.guar_way_cd_two, o.guar_way_cd_two) as guar_way_cd_two -- 担保方式代码二
    ,nvl(n.guar_way_cd_three, o.guar_way_cd_three) as guar_way_cd_three -- 担保方式代码三
    ,nvl(n.other_guar_way_cd, o.other_guar_way_cd) as other_guar_way_cd -- 其他担保方式代码
    ,nvl(n.supp_guar_way_flg, o.supp_guar_way_flg) as supp_guar_way_flg -- 追加担保方式标志
    ,nvl(n.other_cond_descb, o.other_cond_descb) as other_cond_descb -- 其他条件描述
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped, o.repay_ped) as repay_ped -- 还款周期
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期单位代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.rsrv_amt, o.rsrv_amt) as rsrv_amt -- 预留金额
    ,nvl(n.rela_old_cont_id, o.rela_old_cont_id) as rela_old_cont_id -- 关联旧合同编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.create_cont_flg, o.create_cont_flg) as create_cont_flg -- 生成合同标志
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.reply_type_cd, o.reply_type_cd) as reply_type_cd -- 批复类型代码
    ,nvl(n.final_apv_opinion_descb, o.final_apv_opinion_descb) as final_apv_opinion_descb -- 最终审批意见描述
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.spec_ped_corp_cd, o.spec_ped_corp_cd) as spec_ped_corp_cd -- 指定周期单位代码
    ,nvl(n.spec_ped_cd, o.spec_ped_cd) as spec_ped_cd -- 指定周期代码
    ,nvl(n.b_renew_exp_dt, o.b_renew_exp_dt) as b_renew_exp_dt -- 展期前到期日期
    ,nvl(n.b_renew_amt, o.b_renew_amt) as b_renew_amt -- 展期前金额
    ,nvl(n.b_renew_exec_year_int_rat, o.b_renew_exec_year_int_rat) as b_renew_exec_year_int_rat -- 展期前执行年利率
    ,nvl(n.crdt_org_way_cd, o.crdt_org_way_cd) as crdt_org_way_cd -- 授信组织方式代码
    ,nvl(n.lmt_open_amt, o.lmt_open_amt) as lmt_open_amt -- 额度敞口金额
    ,nvl(n.file_dt, o.file_dt) as file_dt -- 归档日期
    ,nvl(n.level11_cls_cd, o.level11_cls_cd) as level11_cls_cd -- 十一级分类代码
    ,nvl(n.attach_rgst_flg, o.attach_rgst_flg) as attach_rgst_flg -- 补登标志
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_tran_out_acct_id, o.margin_tran_out_acct_id) as margin_tran_out_acct_id -- 保证金转出账户编号
    ,nvl(n.margin_curr_cd, o.margin_curr_cd) as margin_curr_cd -- 保证金币种代码
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.ovdue_exec_int_rat, o.ovdue_exec_int_rat) as ovdue_exec_int_rat -- 逾期执行利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.provi_for_aged_property_flg, o.provi_for_aged_property_flg) as provi_for_aged_property_flg -- 养老产业标志
    ,nvl(n.up_level_flow_num, o.up_level_flow_num) as up_level_flow_num -- 上层流水号
    ,nvl(n.risk_cls_rest_cd, o.risk_cls_rest_cd) as risk_cls_rest_cd -- 风险分类结果代码
    ,nvl(n.annual_vrfction_status_cd, o.annual_vrfction_status_cd) as annual_vrfction_status_cd -- 年审状态代码
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.reply_id, o.reply_id) as reply_id -- 批复编号
    ,nvl(n.need_annual_vrfction_flg, o.need_annual_vrfction_flg) as need_annual_vrfction_flg -- 需要年审标志
    ,nvl(n.l_ped_annual_vrfction_dt, o.l_ped_annual_vrfction_dt) as l_ped_annual_vrfction_dt -- 上期年审日期
    ,nvl(n.curr_issue_annual_vrfction_dt, o.curr_issue_annual_vrfction_dt) as curr_issue_annual_vrfction_dt -- 本期年审日期
    ,nvl(n.ibank_tepla_id, o.ibank_tepla_id) as ibank_tepla_id -- 同业模板编号
    ,nvl(n.regroup_loan_flg, o.regroup_loan_flg) as regroup_loan_flg -- 重组贷款标志
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.apv_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
where (
        o.agt_id is null
        and o.apv_flow_num is null
    )
    or (
        n.agt_id is null
        and n.apv_flow_num is null
    )
    or (
        o.appl_flow_num <> n.appl_flow_num
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.appl_way_cd <> n.appl_way_cd
        or o.lmt_cont_flg <> n.lmt_cont_flg
        or o.loan_distr_type_cd <> n.loan_distr_type_cd
        or o.happ_dt <> n.happ_dt
        or o.curr_cd <> n.curr_cd
        or o.apv_amt <> n.apv_amt
        or o.base_prod_id <> n.base_prod_id
        or o.prod_id <> n.prod_id
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.remote_bus_flg <> n.remote_bus_flg
        or o.lmt_circl_flg <> n.lmt_circl_flg
        or o.risk_type_cd <> n.risk_type_cd
        or o.low_risk_bus_flg <> n.low_risk_bus_flg
        or o.crdt_dir_cd <> n.crdt_dir_cd
        or o.nat_std_indus_dir_cd <> n.nat_std_indus_dir_cd
        or o.bank_int_indus_dir_cd <> n.bank_int_indus_dir_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.usage_descb <> n.usage_descb
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.fix_int_rat <> n.fix_int_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_flo_val <> n.int_rat_flo_val
        or o.exec_int_rat <> n.exec_int_rat
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.guar_way_cd_two <> n.guar_way_cd_two
        or o.guar_way_cd_three <> n.guar_way_cd_three
        or o.other_guar_way_cd <> n.other_guar_way_cd
        or o.supp_guar_way_flg <> n.supp_guar_way_flg
        or o.other_cond_descb <> n.other_cond_descb
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped <> n.repay_ped
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.rsrv_amt <> n.rsrv_amt
        or o.rela_old_cont_id <> n.rela_old_cont_id
        or o.lmt_id <> n.lmt_id
        or o.create_cont_flg <> n.create_cont_flg
        or o.apv_status_cd <> n.apv_status_cd
        or o.reply_type_cd <> n.reply_type_cd
        or o.final_apv_opinion_descb <> n.final_apv_opinion_descb
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.lp_id <> n.lp_id
        or o.spec_ped_corp_cd <> n.spec_ped_corp_cd
        or o.spec_ped_cd <> n.spec_ped_cd
        or o.b_renew_exp_dt <> n.b_renew_exp_dt
        or o.b_renew_amt <> n.b_renew_amt
        or o.b_renew_exec_year_int_rat <> n.b_renew_exec_year_int_rat
        or o.crdt_org_way_cd <> n.crdt_org_way_cd
        or o.lmt_open_amt <> n.lmt_open_amt
        or o.file_dt <> n.file_dt
        or o.level11_cls_cd <> n.level11_cls_cd
        or o.attach_rgst_flg <> n.attach_rgst_flg
        or o.effect_flg <> n.effect_flg
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_tran_out_acct_id <> n.margin_tran_out_acct_id
        or o.margin_curr_cd <> n.margin_curr_cd
        or o.margin_ratio <> n.margin_ratio
        or o.margin_amt <> n.margin_amt
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.ovdue_exec_int_rat <> n.ovdue_exec_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.stl_acct_name <> n.stl_acct_name
        or o.enter_id <> n.enter_id
        or o.stl_acct_id <> n.stl_acct_id
        or o.move_remark <> n.move_remark
        or o.provi_for_aged_property_flg <> n.provi_for_aged_property_flg
        or o.up_level_flow_num <> n.up_level_flow_num
        or o.risk_cls_rest_cd <> n.risk_cls_rest_cd
        or o.annual_vrfction_status_cd <> n.annual_vrfction_status_cd
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.reply_id <> n.reply_id
        or o.need_annual_vrfction_flg <> n.need_annual_vrfction_flg
        or o.l_ped_annual_vrfction_dt <> n.l_ped_annual_vrfction_dt
        or o.curr_issue_annual_vrfction_dt <> n.curr_issue_annual_vrfction_dt
        or o.ibank_tepla_id <> n.ibank_tepla_id
        or o.regroup_loan_flg <> n.regroup_loan_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,apv_flow_num -- 审批流水号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,appl_way_cd -- 申请方式代码
    ,lmt_cont_flg -- 额度合同标志
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,happ_dt -- 发生日期
    ,curr_cd -- 币种代码
    ,apv_amt -- 审批金额
    ,base_prod_id -- 基础产品编号
    ,prod_id -- 产品编号
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,remote_bus_flg -- 异地业务标志
    ,lmt_circl_flg -- 额度循环标志
    ,risk_type_cd -- 风险类型代码
    ,low_risk_bus_flg -- 低风险业务标志
    ,crdt_dir_cd -- 授信投向代码
    ,nat_std_indus_dir_cd -- 国标行业投向代码
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,loan_usage_cd -- 贷款用途代码
    ,usage_descb -- 用途描述
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_flo_val -- 利率浮动值
    ,exec_int_rat -- 执行利率
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,other_guar_way_cd -- 其他担保方式代码
    ,supp_guar_way_flg -- 追加担保方式标志
    ,other_cond_descb -- 其他条件描述
    ,repay_way_cd -- 还款方式代码
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,deflt_repay_day -- 默认还款日
    ,rsrv_amt -- 预留金额
    ,rela_old_cont_id -- 关联旧合同编号
    ,lmt_id -- 额度编号
    ,create_cont_flg -- 生成合同标志
    ,apv_status_cd -- 审批状态代码
    ,reply_type_cd -- 批复类型代码
    ,final_apv_opinion_descb -- 最终审批意见描述
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,spec_ped_corp_cd -- 指定周期单位代码
    ,spec_ped_cd -- 指定周期代码
    ,b_renew_exp_dt -- 展期前到期日期
    ,b_renew_amt -- 展期前金额
    ,b_renew_exec_year_int_rat -- 展期前执行年利率
    ,crdt_org_way_cd -- 授信组织方式代码
    ,lmt_open_amt -- 额度敞口金额
    ,file_dt -- 归档日期
    ,level11_cls_cd -- 十一级分类代码
    ,attach_rgst_flg -- 补登标志
    ,effect_flg -- 生效标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,stl_acct_name -- 结算账户名称
    ,enter_id -- 入账账户编号
    ,stl_acct_id -- 结算账户编号
    ,move_remark -- 迁移备注
    ,provi_for_aged_property_flg -- 养老产业标志
    ,up_level_flow_num -- 上层流水号
    ,risk_cls_rest_cd -- 风险分类结果代码
    ,annual_vrfction_status_cd -- 年审状态代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,reply_id -- 批复编号
    ,need_annual_vrfction_flg -- 需要年审标志
    ,l_ped_annual_vrfction_dt -- 上期年审日期
    ,curr_issue_annual_vrfction_dt -- 本期年审日期
    ,ibank_tepla_id -- 同业模板编号
    ,regroup_loan_flg -- 重组贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.apv_flow_num -- 审批流水号
    ,o.appl_flow_num -- 申请流水号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.appl_way_cd -- 申请方式代码
    ,o.lmt_cont_flg -- 额度合同标志
    ,o.loan_distr_type_cd -- 贷款发放类型代码
    ,o.happ_dt -- 发生日期
    ,o.curr_cd -- 币种代码
    ,o.apv_amt -- 审批金额
    ,o.base_prod_id -- 基础产品编号
    ,o.prod_id -- 产品编号
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.begin_dt -- 起始日期
    ,o.exp_dt -- 到期日期
    ,o.remote_bus_flg -- 异地业务标志
    ,o.lmt_circl_flg -- 额度循环标志
    ,o.risk_type_cd -- 风险类型代码
    ,o.low_risk_bus_flg -- 低风险业务标志
    ,o.crdt_dir_cd -- 授信投向代码
    ,o.nat_std_indus_dir_cd -- 国标行业投向代码
    ,o.bank_int_indus_dir_cd -- 行内行业投向代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.usage_descb -- 用途描述
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.fix_int_rat -- 固定利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_flo_val -- 利率浮动值
    ,o.exec_int_rat -- 执行利率
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.guar_way_cd_two -- 担保方式代码二
    ,o.guar_way_cd_three -- 担保方式代码三
    ,o.other_guar_way_cd -- 其他担保方式代码
    ,o.supp_guar_way_flg -- 追加担保方式标志
    ,o.other_cond_descb -- 其他条件描述
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped -- 还款周期
    ,o.repay_ped_cd -- 还款周期单位代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.rsrv_amt -- 预留金额
    ,o.rela_old_cont_id -- 关联旧合同编号
    ,o.lmt_id -- 额度编号
    ,o.create_cont_flg -- 生成合同标志
    ,o.apv_status_cd -- 审批状态代码
    ,o.reply_type_cd -- 批复类型代码
    ,o.final_apv_opinion_descb -- 最终审批意见描述
    ,o.oper_teller_id -- 业务经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.lp_id -- 法人编号
    ,o.spec_ped_corp_cd -- 指定周期单位代码
    ,o.spec_ped_cd -- 指定周期代码
    ,o.b_renew_exp_dt -- 展期前到期日期
    ,o.b_renew_amt -- 展期前金额
    ,o.b_renew_exec_year_int_rat -- 展期前执行年利率
    ,o.crdt_org_way_cd -- 授信组织方式代码
    ,o.lmt_open_amt -- 额度敞口金额
    ,o.file_dt -- 归档日期
    ,o.level11_cls_cd -- 十一级分类代码
    ,o.attach_rgst_flg -- 补登标志
    ,o.effect_flg -- 生效标志
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_tran_out_acct_id -- 保证金转出账户编号
    ,o.margin_curr_cd -- 保证金币种代码
    ,o.margin_ratio -- 保证金比例
    ,o.margin_amt -- 保证金金额
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.ovdue_exec_int_rat -- 逾期执行利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.stl_acct_name -- 结算账户名称
    ,o.enter_id -- 入账账户编号
    ,o.stl_acct_id -- 结算账户编号
    ,o.move_remark -- 迁移备注
    ,o.provi_for_aged_property_flg -- 养老产业标志
    ,o.up_level_flow_num -- 上层流水号
    ,o.risk_cls_rest_cd -- 风险分类结果代码
    ,o.annual_vrfction_status_cd -- 年审状态代码
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.reply_id -- 批复编号
    ,o.need_annual_vrfction_flg -- 需要年审标志
    ,o.l_ped_annual_vrfction_dt -- 上期年审日期
    ,o.curr_issue_annual_vrfction_dt -- 本期年审日期
    ,o.ibank_tepla_id -- 同业模板编号
    ,o.regroup_loan_flg -- 重组贷款标志
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
from ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.apv_flow_num = n.apv_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.apv_flow_num = d.apv_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_apv_basic_info_h;
--alter table ${iml_schema}.agt_loan_apv_basic_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_apv_basic_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_apv_basic_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_apv_basic_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_apv_basic_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_apv_basic_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_apv_basic_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_apv_basic_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_apv_basic_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
