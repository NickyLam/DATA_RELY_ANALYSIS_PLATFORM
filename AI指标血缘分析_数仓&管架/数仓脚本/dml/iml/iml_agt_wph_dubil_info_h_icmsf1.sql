/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wph_dubil_info_h_icmsf1
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
alter table ${iml_schema}.agt_wph_dubil_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_dubil_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_dubil_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_dubil_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_dubil_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wph_business_duebill-1
insert into ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300070'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 借据编号
    ,P1.HXDUEBILLNO -- 核心借据编号
    ,P1.PUTOUTSERIALNO -- 出账流水号
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.PRODUCTID -- 产品编号
    ,P1.CUSTOMERID -- 客户编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.ENCASHAMT -- 借据金额
    ,P1.BALANCE -- 借据余额
    ,nvl(trim(P1.ACCOUNTINGSTATUS),'-') -- 核算状态代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,nvl(trim(P1.REASONCODE),'000000') -- 贷款用途代码
    ,nvl(trim(P1.REPAYMODE),'-') -- 还款方式代码
    ,P1.INTERESTCALCULATION -- 计息方式代码
    ,nvl(trim(P1.INTERESTREPAYCYCLE),'-') -- 结息方式代码
    ,nvl(trim(P1.CYCLEFREQ),'-') -- 结息周期代码
    ,nvl(trim(P1.TERMTYPE),'-') -- 周期单位代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.REPAYCYCLE END -- 还款周期代码
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,P1.FLOATRANGE -- 浮动点数
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,nvl(trim(P1.REMART),'XXX') -- 资产三分类代码
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,${iml_schema}.dateformat_max2(P1.PUTOUTDATE) -- 贷款发放日期
    ,${iml_schema}.dateformat_max2(P1.MATURITY) -- 贷款到期日期
    ,to_number(nvl(trim(P1.TERMMONTH),'0')) -- 月期限
    ,P1.TOTALTERMS -- 总期数
    ,P1.CURTERM -- 当前期数
    ,P1.REPAYDAY -- 还款日
    ,${iml_schema}.dateformat_max2(P1.GUARPAIDDATE) -- 代偿结清日期
    ,${iml_schema}.dateformat_max2(P1.NEXTREPAYDATE) -- 下一还款日期
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,${iml_schema}.dateformat_max2(P1.WRITEOFFTIME) -- 核销日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.WRITEOFF END -- 核销标志
    ,P1.WRITEOFFAMT -- 核销金额
    ,P1.GRACEDAYS -- 宽限期天数
    ,${iml_schema}.dateformat_max2(P1.OVERDUEDATE) -- 逾期日期
    ,to_number(nvl(trim(P1.DAYSOVD),'0')) -- 贷款逾期天数
    ,P1.OVDPRINBAL -- 逾期本金余额
    ,P1.OVDINTBAL -- 逾期利息余额
    ,P1.ODIPAMT -- 逾期复利
    ,P1.OVERDUERATE -- 逾期利率
    ,P1.OVDRATE -- 罚息利率
    ,P1.BASERATE -- 基准利率
    ,P1.EXECUTERATE -- 执行利率
    ,P1.INTPLTYRATE -- 复利利率
    ,P1.DAILYINT -- 当日计提利息
    ,P1.DAILYPNLTINT -- 当日计提罚息
    ,P1.PNLTINTOVERDUE -- 应收欠息
    ,P1.PNLTINTAMT -- 应收利息
    ,P1.PNLTODIAMT -- 应收复利
    ,P1.NORMALINTAMT -- 正常利息
    ,P1.PNLTINTBAL -- 罚息余额
    ,P1.PNLTINTTOTAL -- 应收罚息
    ,P1.NORMALAMT -- 正常本金
    ,P1.OSLAMT -- 未到期本金
    ,P1.BANKCONTRIRATIO -- 银行出资比例
    ,P1.DDPERCENCONTRI -- 合作方出资比例
    ,P1.PAYMENTNUM -- 入账账户编号
    ,P1.PAYMENTBANKNAME -- 入账账户开户银行名称
    ,P1.REPAYNUM -- 还款账户编号
    ,P1.PAYMENTBANKNO -- 还款账户开户银行编号
    ,P1.PAYMENTORGNAME -- 还款账户开户机构名称
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.UNIONGUARANTEEFLAG),'-') -- 融担模式代码
    ,P1.GUARANTEEAID -- 第一担保编号
    ,P1.GUARANTEEARATE -- 第一担保比例
    ,P1.GUARANTEEACONTRACTNO -- 第一担保合同编号
    ,P1.GUARANTEEBID -- 第二担保编号
    ,P1.GUARANTEEBRATE -- 第二担保比例
    ,P1.GUARANTEEBCONTRACTNO -- 第二担保合同编号
    ,P1.REMARK2 -- 第二备用字段
    ,P1.MANAGEORGID -- 管理机构编号
    ,P1.PUTOUTORGID -- 账务机构编号
    ,P1.OPERATEUSERID -- 经办柜员编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_business_duebill' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_business_duebill p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYCYCLE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WPH_BUSINESS_DUEBILL'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYCYCLE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WPH_DUBIL_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_PED_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.WRITEOFF = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_WPH_BUSINESS_DUEBILL'
        AND R2.SRC_FIELD_EN_NAME= 'WRITEOFF'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_WPH_DUBIL_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'WRT_OFF_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
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
        into ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
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
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.core_dubil_id, o.core_dubil_id) as core_dubil_id -- 核心借据编号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.dubil_bal, o.dubil_bal) as dubil_bal -- 借据余额
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.int_set_way_cd, o.int_set_way_cd) as int_set_way_cd -- 结息方式代码
    ,nvl(n.int_set_ped_cd, o.int_set_ped_cd) as int_set_ped_cd -- 结息周期代码
    ,nvl(n.ped_corp_cd, o.ped_corp_cd) as ped_corp_cd -- 周期单位代码
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期代码
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.float_range, o.float_range) as float_range -- 浮动点数
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 五级分类代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.loan_distr_dt, o.loan_distr_dt) as loan_distr_dt -- 贷款发放日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.tot_perds, o.tot_perds) as tot_perds -- 总期数
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.comp_payoff_dt, o.comp_payoff_dt) as comp_payoff_dt -- 代偿结清日期
    ,nvl(n.next_repay_dt, o.next_repay_dt) as next_repay_dt -- 下一还款日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.wrt_off_dt, o.wrt_off_dt) as wrt_off_dt -- 核销日期
    ,nvl(n.wrt_off_flg, o.wrt_off_flg) as wrt_off_flg -- 核销标志
    ,nvl(n.wrt_off_amt, o.wrt_off_amt) as wrt_off_amt -- 核销金额
    ,nvl(n.grace_period_days, o.grace_period_days) as grace_period_days -- 宽限期天数
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.ovdue_pric_bal, o.ovdue_pric_bal) as ovdue_pric_bal -- 逾期本金余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息余额
    ,nvl(n.ovdue_comp_int, o.ovdue_comp_int) as ovdue_comp_int -- 逾期复利
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.pnlt_int_rat, o.pnlt_int_rat) as pnlt_int_rat -- 罚息利率
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.comp_int_int_rat, o.comp_int_int_rat) as comp_int_int_rat -- 复利利率
    ,nvl(n.td_provi_int, o.td_provi_int) as td_provi_int -- 当日计提利息
    ,nvl(n.td_provi_pnlt, o.td_provi_pnlt) as td_provi_pnlt -- 当日计提罚息
    ,nvl(n.recvbl_over_int, o.recvbl_over_int) as recvbl_over_int -- 应收欠息
    ,nvl(n.int_recvbl, o.int_recvbl) as int_recvbl -- 应收利息
    ,nvl(n.recvbl_comp_int, o.recvbl_comp_int) as recvbl_comp_int -- 应收复利
    ,nvl(n.nomal_int, o.nomal_int) as nomal_int -- 正常利息
    ,nvl(n.pnlt_bal, o.pnlt_bal) as pnlt_bal -- 罚息余额
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.nomal_pric, o.nomal_pric) as nomal_pric -- 正常本金
    ,nvl(n.unexp_pric, o.unexp_pric) as unexp_pric -- 未到期本金
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.partner_contri_ratio, o.partner_contri_ratio) as partner_contri_ratio -- 合作方出资比例
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_open_acct_bank_name, o.enter_open_acct_bank_name) as enter_open_acct_bank_name -- 入账账户开户银行名称
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账户编号
    ,nvl(n.repay_num_open_acct_bank_id, o.repay_num_open_acct_bank_id) as repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,nvl(n.repay_num_open_acct_org_name, o.repay_num_open_acct_org_name) as repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 主担保方式代码
    ,nvl(n.fin_guar_mode_cd, o.fin_guar_mode_cd) as fin_guar_mode_cd -- 融担模式代码
    ,nvl(n.fst_guar_id, o.fst_guar_id) as fst_guar_id -- 第一担保编号
    ,nvl(n.fst_guar_ratio, o.fst_guar_ratio) as fst_guar_ratio -- 第一担保比例
    ,nvl(n.fst_guar_cont_id, o.fst_guar_cont_id) as fst_guar_cont_id -- 第一担保合同编号
    ,nvl(n.secd_guar_id, o.secd_guar_id) as secd_guar_id -- 第二担保编号
    ,nvl(n.secd_guar_ratio, o.secd_guar_ratio) as secd_guar_ratio -- 第二担保比例
    ,nvl(n.secd_guar_cont_id, o.secd_guar_cont_id) as secd_guar_cont_id -- 第二担保合同编号
    ,nvl(n.resv_field_two, o.resv_field_two) as resv_field_two -- 第二备用字段
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wph_dubil_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
    )
    or (
        o.core_dubil_id <> n.core_dubil_id
        or o.out_acct_flow_num <> n.out_acct_flow_num
        or o.cont_id <> n.cont_id
        or o.prod_id <> n.prod_id
        or o.cust_id <> n.cust_id
        or o.curr_cd <> n.curr_cd
        or o.dubil_amt <> n.dubil_amt
        or o.dubil_bal <> n.dubil_bal
        or o.accti_status_cd <> n.accti_status_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.loan_type_cd <> n.loan_type_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.int_set_way_cd <> n.int_set_way_cd
        or o.int_set_ped_cd <> n.int_set_ped_cd
        or o.ped_corp_cd <> n.ped_corp_cd
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.float_range <> n.float_range
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
        or o.tran_dt <> n.tran_dt
        or o.loan_distr_dt <> n.loan_distr_dt
        or o.loan_exp_dt <> n.loan_exp_dt
        or o.mon_tenor <> n.mon_tenor
        or o.tot_perds <> n.tot_perds
        or o.curr_perds <> n.curr_perds
        or o.repay_day <> n.repay_day
        or o.comp_payoff_dt <> n.comp_payoff_dt
        or o.next_repay_dt <> n.next_repay_dt
        or o.payoff_dt <> n.payoff_dt
        or o.wrt_off_dt <> n.wrt_off_dt
        or o.wrt_off_flg <> n.wrt_off_flg
        or o.wrt_off_amt <> n.wrt_off_amt
        or o.grace_period_days <> n.grace_period_days
        or o.ovdue_dt <> n.ovdue_dt
        or o.ovdue_days <> n.ovdue_days
        or o.ovdue_pric_bal <> n.ovdue_pric_bal
        or o.ovdue_int_bal <> n.ovdue_int_bal
        or o.ovdue_comp_int <> n.ovdue_comp_int
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.pnlt_int_rat <> n.pnlt_int_rat
        or o.base_rat <> n.base_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.comp_int_int_rat <> n.comp_int_int_rat
        or o.td_provi_int <> n.td_provi_int
        or o.td_provi_pnlt <> n.td_provi_pnlt
        or o.recvbl_over_int <> n.recvbl_over_int
        or o.int_recvbl <> n.int_recvbl
        or o.recvbl_comp_int <> n.recvbl_comp_int
        or o.nomal_int <> n.nomal_int
        or o.pnlt_bal <> n.pnlt_bal
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.nomal_pric <> n.nomal_pric
        or o.unexp_pric <> n.unexp_pric
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.partner_contri_ratio <> n.partner_contri_ratio
        or o.enter_id <> n.enter_id
        or o.enter_open_acct_bank_name <> n.enter_open_acct_bank_name
        or o.repay_num_id <> n.repay_num_id
        or o.repay_num_open_acct_bank_id <> n.repay_num_open_acct_bank_id
        or o.repay_num_open_acct_org_name <> n.repay_num_open_acct_org_name
        or o.guar_way_cd <> n.guar_way_cd
        or o.fin_guar_mode_cd <> n.fin_guar_mode_cd
        or o.fst_guar_id <> n.fst_guar_id
        or o.fst_guar_ratio <> n.fst_guar_ratio
        or o.fst_guar_cont_id <> n.fst_guar_cont_id
        or o.secd_guar_id <> n.secd_guar_id
        or o.secd_guar_ratio <> n.secd_guar_ratio
        or o.secd_guar_cont_id <> n.secd_guar_cont_id
        or o.resv_field_two <> n.resv_field_two
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.acct_instit_id <> n.acct_instit_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,core_dubil_id -- 核心借据编号
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,accti_status_cd -- 核算状态代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,int_set_way_cd -- 结息方式代码
    ,int_set_ped_cd -- 结息周期代码
    ,ped_corp_cd -- 周期单位代码
    ,repay_ped_cd -- 还款周期代码
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,float_range -- 浮动点数
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_level5_cls_cd -- 五级分类代码
    ,tran_dt -- 交易日期
    ,loan_distr_dt -- 贷款发放日期
    ,loan_exp_dt -- 贷款到期日期
    ,mon_tenor -- 月期限
    ,tot_perds -- 总期数
    ,curr_perds -- 当前期数
    ,repay_day -- 还款日
    ,comp_payoff_dt -- 代偿结清日期
    ,next_repay_dt -- 下一还款日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,wrt_off_flg -- 核销标志
    ,wrt_off_amt -- 核销金额
    ,grace_period_days -- 宽限期天数
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int_rat -- 逾期利率
    ,pnlt_int_rat -- 罚息利率
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,comp_int_int_rat -- 复利利率
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,recvbl_over_int -- 应收欠息
    ,int_recvbl -- 应收利息
    ,recvbl_comp_int -- 应收复利
    ,nomal_int -- 正常利息
    ,pnlt_bal -- 罚息余额
    ,recvbl_pnlt -- 应收罚息
    ,nomal_pric -- 正常本金
    ,unexp_pric -- 未到期本金
    ,bank_contri_ratio -- 银行出资比例
    ,partner_contri_ratio -- 合作方出资比例
    ,enter_id -- 入账账户编号
    ,enter_open_acct_bank_name -- 入账账户开户银行名称
    ,repay_num_id -- 还款账户编号
    ,repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,guar_way_cd -- 主担保方式代码
    ,fin_guar_mode_cd -- 融担模式代码
    ,fst_guar_id -- 第一担保编号
    ,fst_guar_ratio -- 第一担保比例
    ,fst_guar_cont_id -- 第一担保合同编号
    ,secd_guar_id -- 第二担保编号
    ,secd_guar_ratio -- 第二担保比例
    ,secd_guar_cont_id -- 第二担保合同编号
    ,resv_field_two -- 第二备用字段
    ,mgmt_org_id -- 管理机构编号
    ,acct_instit_id -- 账务机构编号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
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
    ,o.dubil_id -- 借据编号
    ,o.core_dubil_id -- 核心借据编号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.cont_id -- 合同编号
    ,o.prod_id -- 产品编号
    ,o.cust_id -- 客户编号
    ,o.curr_cd -- 币种代码
    ,o.dubil_amt -- 借据金额
    ,o.dubil_bal -- 借据余额
    ,o.accti_status_cd -- 核算状态代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.loan_type_cd -- 贷款类型代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.int_set_way_cd -- 结息方式代码
    ,o.int_set_ped_cd -- 结息周期代码
    ,o.ped_corp_cd -- 周期单位代码
    ,o.repay_ped_cd -- 还款周期代码
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.float_range -- 浮动点数
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.loan_level5_cls_cd -- 五级分类代码
    ,o.tran_dt -- 交易日期
    ,o.loan_distr_dt -- 贷款发放日期
    ,o.loan_exp_dt -- 贷款到期日期
    ,o.mon_tenor -- 月期限
    ,o.tot_perds -- 总期数
    ,o.curr_perds -- 当前期数
    ,o.repay_day -- 还款日
    ,o.comp_payoff_dt -- 代偿结清日期
    ,o.next_repay_dt -- 下一还款日期
    ,o.payoff_dt -- 结清日期
    ,o.wrt_off_dt -- 核销日期
    ,o.wrt_off_flg -- 核销标志
    ,o.wrt_off_amt -- 核销金额
    ,o.grace_period_days -- 宽限期天数
    ,o.ovdue_dt -- 逾期日期
    ,o.ovdue_days -- 贷款逾期天数
    ,o.ovdue_pric_bal -- 逾期本金余额
    ,o.ovdue_int_bal -- 逾期利息余额
    ,o.ovdue_comp_int -- 逾期复利
    ,o.ovdue_int_rat -- 逾期利率
    ,o.pnlt_int_rat -- 罚息利率
    ,o.base_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.comp_int_int_rat -- 复利利率
    ,o.td_provi_int -- 当日计提利息
    ,o.td_provi_pnlt -- 当日计提罚息
    ,o.recvbl_over_int -- 应收欠息
    ,o.int_recvbl -- 应收利息
    ,o.recvbl_comp_int -- 应收复利
    ,o.nomal_int -- 正常利息
    ,o.pnlt_bal -- 罚息余额
    ,o.recvbl_pnlt -- 应收罚息
    ,o.nomal_pric -- 正常本金
    ,o.unexp_pric -- 未到期本金
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.partner_contri_ratio -- 合作方出资比例
    ,o.enter_id -- 入账账户编号
    ,o.enter_open_acct_bank_name -- 入账账户开户银行名称
    ,o.repay_num_id -- 还款账户编号
    ,o.repay_num_open_acct_bank_id -- 还款账户开户银行编号
    ,o.repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,o.guar_way_cd -- 主担保方式代码
    ,o.fin_guar_mode_cd -- 融担模式代码
    ,o.fst_guar_id -- 第一担保编号
    ,o.fst_guar_ratio -- 第一担保比例
    ,o.fst_guar_cont_id -- 第一担保合同编号
    ,o.secd_guar_id -- 第二担保编号
    ,o.secd_guar_ratio -- 第二担保比例
    ,o.secd_guar_cont_id -- 第二担保合同编号
    ,o.resv_field_two -- 第二备用字段
    ,o.mgmt_org_id -- 管理机构编号
    ,o.acct_instit_id -- 账务机构编号
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_org_id -- 经办机构编号
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
from ${iml_schema}.agt_wph_dubil_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wph_dubil_info_h;
--alter table ${iml_schema}.agt_wph_dubil_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wph_dubil_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wph_dubil_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wph_dubil_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wph_dubil_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_wph_dubil_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wph_dubil_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wph_dubil_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wph_dubil_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
