/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lhwd_dubil_info_h_icmsi1
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
alter table ${iml_schema}.agt_lhwd_dubil_info_h add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_dubil_info_h partition for ('icmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm purge;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op purge;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
from ${iml_schema}.agt_lhwd_dubil_info_h partition for ('icmsi1')
where 0=1
;

create table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_dubil_info_h partition for ('icmsi1') where 0=1;

create table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_dubil_info_h partition for ('icmsi1') where 0=1;

-- 3.1 get new data into table
-- icms_lhwd_business_duebill_his-1
insert into ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
    '300076'||P1.HXBDSERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.HXBDSERIALNO -- 借据编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.INTACCRWAY),'-') -- 计息方式代码
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 放款支付方式代码
    ,nvl(trim(P1.ACCOUNTFLAG),'-') -- 记账标识代码
    ,nvl(trim(P1.ACRUNONACRU),'-') -- 应计非应计代码
    ,nvl(trim(P1.CREDITCHANNEL),'-') -- 授信渠道代码
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,nvl(trim(P1.REMART),'XXX') -- 资产三分类代码
    ,nvl(trim(P1.INTNALLOANTYPE),' ') -- 贷款类型代码
    ,nvl(trim(P1.BUSINESSSTATUS),'0') -- 借据状态代码
    ,P1.BUSINESSSUM -- 借据金额
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,to_number(nvl(trim(P1.TERMMONTH),'0')) -- 月期限
    ,to_number(nvl(trim(P1.TERMDAY),'0')) -- 日期限
    ,to_number(nvl(trim(P1.GRACEPERIOD),'0')) -- 宽限期
    ,to_number(nvl(trim(P1.TOTALTERMS),'0')) -- 贷款期数
    ,to_number(nvl(trim(P1.CURTERMS),'0')) -- 当前期数
    ,to_number(nvl(trim(P1.UNCLEARPERIODS),'0')) -- 未结清期数
    ,case when P1.FINISHDATE = to_date('00010101','yyyymmdd') then 
       to_date('29991231','yyyymmdd') 
      else P1.FINISHDATE
     end  -- 结清日期
    ,case when P1.MATURITY = to_date('00010101','yyyymmdd') then 
       to_date('29991231','yyyymmdd') 
      else P1.MATURITY 
     end  -- 到期日期
    ,P1.PUTOUTDATE -- 出账日期
    ,${iml_schema}.dateformat_max2(P1.WRNDATE) -- 核销日期
    ,P1.CLASSIFYDATE -- 五级分类日期
    ,${iml_schema}.dateformat_max2(P1.OVERDUEDATE) -- 贷款逾期日期
    ,${iml_schema}.dateformat_max2(P1.INTOVERDUEDATE) -- 贷款利息逾期日期
    ,to_number(nvl(trim(P1.OVERDUEDAYS),'0')) -- 贷款逾期天数
    ,to_number(nvl(trim(P1.INTOVERDUEDAYS),'0')) -- 贷款利息逾期天数
    ,nvl(trim(P1.INTRATFLOATWAY),'-') -- 利率浮动方式代码
    ,nvl(trim(P1.INTRATFLOATDIR),'-') -- 利率浮动方向代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.FLOATRANGE -- 利率浮动点差
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,P1.EXECUTERATE -- 执行利率
    ,P1.INTRAT -- 固收利率
    ,P1.COMPOUNDRATE -- 复利利率
    ,P1.OVERDUERATE -- 逾期利率
    ,P1.OVERDUERATEFLOATTYPE -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动比例
    ,P1.REVERSALFLAG -- 冲正标志
    ,P1.DZHXSTATUS -- 核销标志
    ,P1.WRNPRIAMT -- 核销本金
    ,P1.BALANCE -- 贷款余额
    ,P1.INTAMTBJBALANCE -- 正常本金余额
    ,P1.INTAMTLXBALANCE -- 正常利息余额
    ,P1.OVERDUEBJBALANCE -- 逾期本金余额
    ,P1.OVERDUELXBALANCE -- 逾期利息余额
    ,P1.CAPITALPENALTYBALANCE -- 罚息余额
    ,P1.INTERESTPENALTYBALANCE -- 复息余额
    ,P1.TDACRUINT -- 当日应计利息
    ,P1.YSINTAMT -- 应收利息
    ,P1.YSODPAMT -- 应收罚息
    ,P1.YSODIAMT -- 应收复息
    ,P1.WRNINTAMT -- 核销利息
    ,P1.BANKCONTRIRATIO -- 银行出资比例
    ,P1.PUTOUTSERIALNO -- 出账流水号
    ,P1.PUTOUTORGID -- 出账机构编号
    ,P1.PAYMENTACCOUNTNO -- 入账账户编号
    ,nvl(trim(P1.PAYMENTACCOUNTTYPE),'-') -- 入账账户类型代码
    ,P1.PAYMENTACCOUNTNAME -- 入账账户名称
    ,P1.PAYMENTACCOUNTBANKNAME -- 入账账户开户机构名称
    ,nvl(trim(P1.INTSETWAY),'-') -- 结算方式代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.REPAYCYCLE END -- 还款周期代码
    ,P1.REPAYACCOUNTNO -- 还款账户编号
    ,nvl(trim(P1.REPAYACCOUNTTYPE),'-') -- 还款账户类型代码
    ,P1.REPAYACCOUNTNAME -- 还款账户名称
    ,P1.REPAYACCOUNTBANKNAME -- 还款账户开户机构名称
    ,P1.SERIALNO -- 合作方借据编号
    ,P1.PRODUCTNO -- 合作方产品编号
    ,P1.APPLYNO -- 合作方全局流水号
    ,nvl(trim(P1.businessModel),'-') -- 合作方业务模式代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_business_duebill_his' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lhwd_business_duebill_his p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYCYCLE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_LHWD_BUSINESS_DUEBILL_HIS'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYCYCLE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LHWD_DUBIL_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_PED_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
     and P1.BIZDATE = to_date(${batch_date},'yyyymmdd') 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                                        ,partner_dubil_id
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
        into ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
        into ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.entry_idf_cd, o.entry_idf_cd) as entry_idf_cd -- 记账标识代码
    ,nvl(n.acru_non_acru_cd, o.acru_non_acru_cd) as acru_non_acru_cd -- 应计非应计代码
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.dubil_status_cd, o.dubil_status_cd) as dubil_status_cd -- 借据状态代码
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期
    ,nvl(n.loan_perds, o.loan_perds) as loan_perds -- 贷款期数
    ,nvl(n.curr_perds, o.curr_perds) as curr_perds -- 当前期数
    ,nvl(n.unpayoff_perds, o.unpayoff_perds) as unpayoff_perds -- 未结清期数
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.out_acct_dt, o.out_acct_dt) as out_acct_dt -- 出账日期
    ,nvl(n.wrt_off_dt, o.wrt_off_dt) as wrt_off_dt -- 核销日期
    ,nvl(n.level5_cls_dt, o.level5_cls_dt) as level5_cls_dt -- 五级分类日期
    ,nvl(n.loan_ovdue_dt, o.loan_ovdue_dt) as loan_ovdue_dt -- 贷款逾期日期
    ,nvl(n.loan_int_ovdue_dt, o.loan_int_ovdue_dt) as loan_int_ovdue_dt -- 贷款利息逾期日期
    ,nvl(n.loan_ovdue_days, o.loan_ovdue_days) as loan_ovdue_days -- 贷款逾期天数
    ,nvl(n.loan_int_ovdue_days, o.loan_int_ovdue_days) as loan_int_ovdue_days -- 贷款利息逾期天数
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_float_dir_cd, o.int_rat_float_dir_cd) as int_rat_float_dir_cd -- 利率浮动方向代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_float_spread, o.int_rat_float_spread) as int_rat_float_spread -- 利率浮动点差
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 固收利率
    ,nvl(n.comp_int_int_rat, o.comp_int_int_rat) as comp_int_int_rat -- 复利利率
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_fl_rt, o.ovdue_int_rat_fl_rt) as ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.wrt_off_flg, o.wrt_off_flg) as wrt_off_flg -- 核销标志
    ,nvl(n.wrt_off_pric, o.wrt_off_pric) as wrt_off_pric -- 核销本金
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.nomal_pric_bal, o.nomal_pric_bal) as nomal_pric_bal -- 正常本金余额
    ,nvl(n.nomal_int_bal, o.nomal_int_bal) as nomal_int_bal -- 正常利息余额
    ,nvl(n.ovdue_pric_bal, o.ovdue_pric_bal) as ovdue_pric_bal -- 逾期本金余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息余额
    ,nvl(n.pnlt_bal, o.pnlt_bal) as pnlt_bal -- 罚息余额
    ,nvl(n.comp_int_bal, o.comp_int_bal) as comp_int_bal -- 复息余额
    ,nvl(n.td_acru_int, o.td_acru_int) as td_acru_int -- 当日应计利息
    ,nvl(n.int_recvbl, o.int_recvbl) as int_recvbl -- 应收利息
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.recvbl_comp_int, o.recvbl_comp_int) as recvbl_comp_int -- 应收复息
    ,nvl(n.wrt_off_int, o.wrt_off_int) as wrt_off_int -- 核销利息
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.out_acct_org_id, o.out_acct_org_id) as out_acct_org_id -- 出账机构编号
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_type_cd, o.enter_type_cd) as enter_type_cd -- 入账账户类型代码
    ,nvl(n.enter_name, o.enter_name) as enter_name -- 入账账户名称
    ,nvl(n.enter_open_acct_org_name, o.enter_open_acct_org_name) as enter_open_acct_org_name -- 入账账户开户机构名称
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期代码
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账户编号
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账户类型代码
    ,nvl(n.repay_num_name, o.repay_num_name) as repay_num_name -- 还款账户名称
    ,nvl(n.repay_num_open_acct_org_name, o.repay_num_open_acct_org_name) as repay_num_open_acct_org_name -- 还款账户开户机构名称
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
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
            and n.partner_dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm n
    full join (select * from ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.partner_dubil_id = n.partner_dubil_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
        and o.partner_dubil_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
        and n.partner_dubil_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cont_id <> n.cont_id
        or o.prod_id <> n.prod_id
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.entry_idf_cd <> n.entry_idf_cd
        or o.acru_non_acru_cd <> n.acru_non_acru_cd
        or o.crdt_chn_cd <> n.crdt_chn_cd
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.loan_type_cd <> n.loan_type_cd
        or o.dubil_status_cd <> n.dubil_status_cd
        or o.dubil_amt <> n.dubil_amt
        or o.curr_cd <> n.curr_cd
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.grace_period <> n.grace_period
        or o.loan_perds <> n.loan_perds
        or o.curr_perds <> n.curr_perds
        or o.unpayoff_perds <> n.unpayoff_perds
        or o.payoff_dt <> n.payoff_dt
        or o.exp_dt <> n.exp_dt
        or o.out_acct_dt <> n.out_acct_dt
        or o.wrt_off_dt <> n.wrt_off_dt
        or o.level5_cls_dt <> n.level5_cls_dt
        or o.loan_ovdue_dt <> n.loan_ovdue_dt
        or o.loan_int_ovdue_dt <> n.loan_int_ovdue_dt
        or o.loan_ovdue_days <> n.loan_ovdue_days
        or o.loan_int_ovdue_days <> n.loan_int_ovdue_days
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_float_dir_cd <> n.int_rat_float_dir_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_float_spread <> n.int_rat_float_spread
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.int_rat <> n.int_rat
        or o.comp_int_int_rat <> n.comp_int_int_rat
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_fl_rt <> n.ovdue_int_rat_fl_rt
        or o.revs_flg <> n.revs_flg
        or o.wrt_off_flg <> n.wrt_off_flg
        or o.wrt_off_pric <> n.wrt_off_pric
        or o.loan_bal <> n.loan_bal
        or o.nomal_pric_bal <> n.nomal_pric_bal
        or o.nomal_int_bal <> n.nomal_int_bal
        or o.ovdue_pric_bal <> n.ovdue_pric_bal
        or o.ovdue_int_bal <> n.ovdue_int_bal
        or o.pnlt_bal <> n.pnlt_bal
        or o.comp_int_bal <> n.comp_int_bal
        or o.td_acru_int <> n.td_acru_int
        or o.int_recvbl <> n.int_recvbl
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.recvbl_comp_int <> n.recvbl_comp_int
        or o.wrt_off_int <> n.wrt_off_int
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.out_acct_flow_num <> n.out_acct_flow_num
        or o.out_acct_org_id <> n.out_acct_org_id
        or o.enter_id <> n.enter_id
        or o.enter_type_cd <> n.enter_type_cd
        or o.enter_name <> n.enter_name
        or o.enter_open_acct_org_name <> n.enter_open_acct_org_name
        or o.stl_way_cd <> n.stl_way_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.repay_num_id <> n.repay_num_id
        or o.repay_num_type_cd <> n.repay_num_type_cd
        or o.repay_num_name <> n.repay_num_name
        or o.repay_num_open_acct_org_name <> n.repay_num_open_acct_org_name
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
        into ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
        into ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,main_guar_way_cd -- 主担保方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,entry_idf_cd -- 记账标识代码
    ,acru_non_acru_cd -- 应计非应计代码
    ,crdt_chn_cd -- 授信渠道代码
    ,level5_cls_cd -- 五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,loan_type_cd -- 贷款类型代码
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,grace_period -- 宽限期
    ,loan_perds -- 贷款期数
    ,curr_perds -- 当前期数
    ,unpayoff_perds -- 未结清期数
    ,payoff_dt -- 结清日期
    ,exp_dt -- 到期日期
    ,out_acct_dt -- 出账日期
    ,wrt_off_dt -- 核销日期
    ,level5_cls_dt -- 五级分类日期
    ,loan_ovdue_dt -- 贷款逾期日期
    ,loan_int_ovdue_dt -- 贷款利息逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,loan_int_ovdue_days -- 贷款利息逾期天数
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_spread -- 利率浮动点差
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat -- 固收利率
    ,comp_int_int_rat -- 复利利率
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,revs_flg -- 冲正标志
    ,wrt_off_flg -- 核销标志
    ,wrt_off_pric -- 核销本金
    ,loan_bal -- 贷款余额
    ,nomal_pric_bal -- 正常本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,pnlt_bal -- 罚息余额
    ,comp_int_bal -- 复息余额
    ,td_acru_int -- 当日应计利息
    ,int_recvbl -- 应收利息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_comp_int -- 应收复息
    ,wrt_off_int -- 核销利息
    ,bank_contri_ratio -- 银行出资比例
    ,out_acct_flow_num -- 出账流水号
    ,out_acct_org_id -- 出账机构编号
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,enter_name -- 入账账户名称
    ,enter_open_acct_org_name -- 入账账户开户机构名称
    ,stl_way_cd -- 结算方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_name -- 还款账户名称
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
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
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 借据编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cont_id -- 合同编号
    ,o.prod_id -- 产品编号
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.entry_idf_cd -- 记账标识代码
    ,o.acru_non_acru_cd -- 应计非应计代码
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.level5_cls_cd -- 五级分类代码
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.loan_type_cd -- 贷款类型代码
    ,o.dubil_status_cd -- 借据状态代码
    ,o.dubil_amt -- 借据金额
    ,o.curr_cd -- 币种代码
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.grace_period -- 宽限期
    ,o.loan_perds -- 贷款期数
    ,o.curr_perds -- 当前期数
    ,o.unpayoff_perds -- 未结清期数
    ,o.payoff_dt -- 结清日期
    ,o.exp_dt -- 到期日期
    ,o.out_acct_dt -- 出账日期
    ,o.wrt_off_dt -- 核销日期
    ,o.level5_cls_dt -- 五级分类日期
    ,o.loan_ovdue_dt -- 贷款逾期日期
    ,o.loan_int_ovdue_dt -- 贷款利息逾期日期
    ,o.loan_ovdue_days -- 贷款逾期天数
    ,o.loan_int_ovdue_days -- 贷款利息逾期天数
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_float_dir_cd -- 利率浮动方向代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_float_spread -- 利率浮动点差
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.int_rat -- 固收利率
    ,o.comp_int_int_rat -- 复利利率
    ,o.ovdue_int_rat -- 逾期利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_fl_rt -- 逾期利率浮动比例
    ,o.revs_flg -- 冲正标志
    ,o.wrt_off_flg -- 核销标志
    ,o.wrt_off_pric -- 核销本金
    ,o.loan_bal -- 贷款余额
    ,o.nomal_pric_bal -- 正常本金余额
    ,o.nomal_int_bal -- 正常利息余额
    ,o.ovdue_pric_bal -- 逾期本金余额
    ,o.ovdue_int_bal -- 逾期利息余额
    ,o.pnlt_bal -- 罚息余额
    ,o.comp_int_bal -- 复息余额
    ,o.td_acru_int -- 当日应计利息
    ,o.int_recvbl -- 应收利息
    ,o.recvbl_pnlt -- 应收罚息
    ,o.recvbl_comp_int -- 应收复息
    ,o.wrt_off_int -- 核销利息
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.out_acct_flow_num -- 出账流水号
    ,o.out_acct_org_id -- 出账机构编号
    ,o.enter_id -- 入账账户编号
    ,o.enter_type_cd -- 入账账户类型代码
    ,o.enter_name -- 入账账户名称
    ,o.enter_open_acct_org_name -- 入账账户开户机构名称
    ,o.stl_way_cd -- 结算方式代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_cd -- 还款周期代码
    ,o.repay_num_id -- 还款账户编号
    ,o.repay_num_type_cd -- 还款账户类型代码
    ,o.repay_num_name -- 还款账户名称
    ,o.repay_num_open_acct_org_name -- 还款账户开户机构名称
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
from ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_bk o
    left join ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.partner_dubil_id = n.partner_dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
            and o.partner_dubil_id = d.partner_dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lhwd_dubil_info_h;
--alter table ${iml_schema}.agt_lhwd_dubil_info_h truncate partition for ('icmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lhwd_dubil_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lhwd_dubil_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lhwd_dubil_info_h modify partition p_icmsi1 
add subpartition p_icmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lhwd_dubil_info_h exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl;
alter table ${iml_schema}.agt_lhwd_dubil_info_h exchange subpartition p_icmsi1_20991231 with table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lhwd_dubil_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_tm purge;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_op purge;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lhwd_dubil_info_h_icmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lhwd_dubil_info_h', partname => 'p_icmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
