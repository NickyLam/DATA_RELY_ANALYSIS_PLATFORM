/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_zjdk_dubil_info_h_icmsf1
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
alter table ${iml_schema}.agt_zjdk_dubil_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_dubil_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
from ${iml_schema}.agt_zjdk_dubil_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_dubil_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_zjdk_dubil_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_business_duebill-1
insert into ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
    '300061'||P1.LOANID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.HXDUEBILLNO -- 核心字节借据号码
    ,P1.LOANID -- 字节借据号码
    ,P1.PUTOUTSERIALNO -- 出账流水号
    ,P1.CONTRACTSERIALNO -- 合同编号
    ,P1.PRODUCTID -- 产品编号
    ,P1.PRODUCTNO -- 字节产品编号
    ,P2.INDTYPE -- 客户性质代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.ENCASHAMT -- 借据金额
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,to_number(nvl(trim(P1.TERMMONTH),'0')) -- 期限
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,P1.EXECUTERATE -- 执行利率
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,P1.FLOATRANGE -- 浮动值
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 贷款五级分类代码
    ,nvl(trim(P1.REMART),'XXX') -- 资产三分类代码
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.LOANSTATUS),'-') -- 贷款状态代码
    ,nvl(trim(P1.LOANFORM),'-') -- 贷款形态代码
    ,${iml_schema}.dateformat_min(P1.APPLYDATE) -- 申请日期
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 生效日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,P1.TOTALTERMS -- 贷款总期数
    ,P1.CURTERM -- 当期期数
    ,to_number(nvl(trim(P1.STARTTERM),'0')) -- 起始期数
    ,to_number(nvl(trim(P1.ENDTERM),'0')) -- 结清期数
    ,P1.GRACEDAY -- 宽限天数
    ,P1.REPAYDAY -- 还款日
    ,nvl(trim(P1.REPAYMODE),'-') -- 还款方式代码
    ,nvl(trim(P1.REPAYCYCLE),'-') -- 还款周期单位代码
    ,P1.PRINTOTAL -- 应还本金
    ,P1.INTTOTAL -- 应还利息
    ,P1.PRINREPAY -- 已还本金
    ,P1.INTREPAY -- 已还利息
    ,P1.PNLTINTREPAY -- 已还罚息
    ,P1.INTPLAN -- 计划利息
    ,to_number(nvl(trim(P1.INTRATE),'0')) -- 正常利率
    ,nvl(trim(P1.INTRATEUNIT),'-') -- 正常利率类型代码
    ,P1.PRINBAL -- 正常本金余额
    ,P1.OVERDUEDATE -- 逾期日期
    ,P1.DAYSOVD -- 贷款逾期天数
    ,P1.OVERDUERATE -- 逾期执行利率
    ,P1.OVDPRINBAL -- 逾期本金余额
    ,P1.OVDINTBAL -- 逾期利息余额
    ,P1.INTDISCOUNT -- 减免利息
    ,P1.PNLTINTDISCOUNT -- 减免罚息
    ,P1.PNLTINTTOTAL -- 应收罚息
    ,P1.INTBAL -- 利息余额
    ,P1.DAILYINT -- 当日计提利息
    ,P1.DAILYPNLTINT -- 当日计提罚息
    ,to_number(nvl(trim(P1.OVDRATE),'0')) -- 罚息利率
    ,nvl(trim(P1.OVDRATEUNIT),'-') -- 罚息利率类型代码
    ,P1.PNLTINTBAL -- 罚息余额
    ,to_number(nvl(trim(P1.PREPMTFEERATE),'0')) -- 提前还款手续费率
    ,P1.PREPMTFEEREPAY -- 已还提前还款手续费
    ,decode(P1.INTERESTTRANSFERSTATUS,'1','0','2','1',' ','-'，P1.INTERESTTRANSFERSTATUS） -- 非应计标志
    ,nvl(trim(to_char(P1.WRITEOFFSTATUS)),'-') -- 已核销标志
    ,${iml_schema}.dateformat_max2(P1.WRITEOFFTIME) -- 核销日期
    ,P1.BANKCONTRIRATIO -- 银行出资比例
    ,P1.OUTLOANCHANNELNO -- 平台订单编号
    ,${iml_schema}.dateformat_max2(P1.LOANRESPONSETIME) -- 放款交易成功日期
    ,P1.REPAYNUM -- 还款账户编号
    ,nvl(trim(P1.REPAYNUMTYPE),'-') -- 还款账户类型代码
    ,P1.PAYMENTNUM -- 入账账户编号
    ,nvl(trim(P1.PAYMENTNUMTYPE),'-') -- 入账账户类型代码
    ,P1.OPERATEUSERID -- 经办柜员编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.PUTOUTORGID -- 财务机构编号
    ,P1.MANAGEORGID -- 管理机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_business_duebill' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_business_duebill p1
    left join ${iol_schema}.icms_customer_info_lhdk p2 on P1.CUSTOMERID = P2.CUSTOMERID
and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
        into ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 核心字节借据号码
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 字节借据号码
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.zjdk_prod_id, o.zjdk_prod_id) as zjdk_prod_id -- 字节产品编号
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.flo_val, o.flo_val) as flo_val -- 浮动值
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 主担保方式代码
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.loan_modal_cd, o.loan_modal_cd) as loan_modal_cd -- 贷款形态代码
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.begin_dt, o.begin_dt) as begin_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.currt_perds, o.currt_perds) as currt_perds -- 当期期数
    ,nvl(n.begin_perds, o.begin_perds) as begin_perds -- 起始期数
    ,nvl(n.payoff_perds, o.payoff_perds) as payoff_perds -- 结清期数
    ,nvl(n.grace_days, o.grace_days) as grace_days -- 宽限天数
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_corp_cd, o.repay_ped_corp_cd) as repay_ped_corp_cd -- 还款周期单位代码
    ,nvl(n.rpbl_pric, o.rpbl_pric) as rpbl_pric -- 应还本金
    ,nvl(n.rpbl_int, o.rpbl_int) as rpbl_int -- 应还利息
    ,nvl(n.paid_pric, o.paid_pric) as paid_pric -- 已还本金
    ,nvl(n.paid_int, o.paid_int) as paid_int -- 已还利息
    ,nvl(n.paid_pnlt, o.paid_pnlt) as paid_pnlt -- 已还罚息
    ,nvl(n.plan_int, o.plan_int) as plan_int -- 计划利息
    ,nvl(n.nomal_int_rat, o.nomal_int_rat) as nomal_int_rat -- 正常利率
    ,nvl(n.nomal_int_rat_type_cd, o.nomal_int_rat_type_cd) as nomal_int_rat_type_cd -- 正常利率类型代码
    ,nvl(n.nomal_pric_bal, o.nomal_pric_bal) as nomal_pric_bal -- 正常本金余额
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.ovdue_exec_int_rat, o.ovdue_exec_int_rat) as ovdue_exec_int_rat -- 逾期执行利率
    ,nvl(n.ovdue_pric_bal, o.ovdue_pric_bal) as ovdue_pric_bal -- 逾期本金余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息余额
    ,nvl(n.derate_int, o.derate_int) as derate_int -- 减免利息
    ,nvl(n.derate_pnlt, o.derate_pnlt) as derate_pnlt -- 减免罚息
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.td_provi_int, o.td_provi_int) as td_provi_int -- 当日计提利息
    ,nvl(n.td_provi_pnlt, o.td_provi_pnlt) as td_provi_pnlt -- 当日计提罚息
    ,nvl(n.pnlt_int_rat, o.pnlt_int_rat) as pnlt_int_rat -- 罚息利率
    ,nvl(n.pnlt_int_rat_type_cd, o.pnlt_int_rat_type_cd) as pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,nvl(n.pnlt_bal, o.pnlt_bal) as pnlt_bal -- 罚息余额
    ,nvl(n.adv_repay_comm_fee_rat, o.adv_repay_comm_fee_rat) as adv_repay_comm_fee_rat -- 提前还款手续费率
    ,nvl(n.paid_adv_repay_comm_fee, o.paid_adv_repay_comm_fee) as paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,nvl(n.non_acru_flg, o.non_acru_flg) as non_acru_flg -- 非应计标志
    ,nvl(n.wrt_off_flg, o.wrt_off_flg) as wrt_off_flg -- 已核销标志
    ,nvl(n.wrt_off_dt, o.wrt_off_dt) as wrt_off_dt -- 核销日期
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.plat_indent_id, o.plat_indent_id) as plat_indent_id -- 平台订单编号
    ,nvl(n.distr_tran_sucs_dt, o.distr_tran_sucs_dt) as distr_tran_sucs_dt -- 放款交易成功日期
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账户编号
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账户类型代码
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 入账账户编号
    ,nvl(n.enter_type_cd, o.enter_type_cd) as enter_type_cd -- 入账账户类型代码
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.fin_org_id, o.fin_org_id) as fin_org_id -- 财务机构编号
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.intnal_dubil_id <> n.intnal_dubil_id
        or o.out_acct_flow_num <> n.out_acct_flow_num
        or o.cont_id <> n.cont_id
        or o.prod_id <> n.prod_id
        or o.zjdk_prod_id <> n.zjdk_prod_id
        or o.cust_char_cd <> n.cust_char_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.dubil_amt <> n.dubil_amt
        or o.curr_cd <> n.curr_cd
        or o.tenor <> n.tenor
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.flo_val <> n.flo_val
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.guar_way_cd <> n.guar_way_cd
        or o.loan_status_cd <> n.loan_status_cd
        or o.loan_modal_cd <> n.loan_modal_cd
        or o.appl_dt <> n.appl_dt
        or o.begin_dt <> n.begin_dt
        or o.exp_dt <> n.exp_dt
        or o.payoff_dt <> n.payoff_dt
        or o.loan_tot_perds <> n.loan_tot_perds
        or o.currt_perds <> n.currt_perds
        or o.begin_perds <> n.begin_perds
        or o.payoff_perds <> n.payoff_perds
        or o.grace_days <> n.grace_days
        or o.repay_day <> n.repay_day
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_corp_cd <> n.repay_ped_corp_cd
        or o.rpbl_pric <> n.rpbl_pric
        or o.rpbl_int <> n.rpbl_int
        or o.paid_pric <> n.paid_pric
        or o.paid_int <> n.paid_int
        or o.paid_pnlt <> n.paid_pnlt
        or o.plan_int <> n.plan_int
        or o.nomal_int_rat <> n.nomal_int_rat
        or o.nomal_int_rat_type_cd <> n.nomal_int_rat_type_cd
        or o.nomal_pric_bal <> n.nomal_pric_bal
        or o.ovdue_dt <> n.ovdue_dt
        or o.ovdue_days <> n.ovdue_days
        or o.ovdue_exec_int_rat <> n.ovdue_exec_int_rat
        or o.ovdue_pric_bal <> n.ovdue_pric_bal
        or o.ovdue_int_bal <> n.ovdue_int_bal
        or o.derate_int <> n.derate_int
        or o.derate_pnlt <> n.derate_pnlt
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.int_bal <> n.int_bal
        or o.td_provi_int <> n.td_provi_int
        or o.td_provi_pnlt <> n.td_provi_pnlt
        or o.pnlt_int_rat <> n.pnlt_int_rat
        or o.pnlt_int_rat_type_cd <> n.pnlt_int_rat_type_cd
        or o.pnlt_bal <> n.pnlt_bal
        or o.adv_repay_comm_fee_rat <> n.adv_repay_comm_fee_rat
        or o.paid_adv_repay_comm_fee <> n.paid_adv_repay_comm_fee
        or o.non_acru_flg <> n.non_acru_flg
        or o.wrt_off_flg <> n.wrt_off_flg
        or o.wrt_off_dt <> n.wrt_off_dt
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.plat_indent_id <> n.plat_indent_id
        or o.distr_tran_sucs_dt <> n.distr_tran_sucs_dt
        or o.repay_num_id <> n.repay_num_id
        or o.repay_num_type_cd <> n.repay_num_type_cd
        or o.enter_id <> n.enter_id
        or o.enter_type_cd <> n.enter_type_cd
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.fin_org_id <> n.fin_org_id
        or o.mgmt_org_id <> n.mgmt_org_id
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
        into ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
        into ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 核心字节借据号码
    ,intnal_dubil_id -- 字节借据号码
    ,out_acct_flow_num -- 出账流水号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,zjdk_prod_id -- 字节产品编号
    ,cust_char_cd -- 客户性质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,dubil_amt -- 借据金额
    ,curr_cd -- 币种代码
    ,tenor -- 期限
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,flo_val -- 浮动值
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,guar_way_cd -- 主担保方式代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_modal_cd -- 贷款形态代码
    ,appl_dt -- 申请日期
    ,begin_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,payoff_dt -- 结清日期
    ,loan_tot_perds -- 贷款总期数
    ,currt_perds -- 当期期数
    ,begin_perds -- 起始期数
    ,payoff_perds -- 结清期数
    ,grace_days -- 宽限天数
    ,repay_day -- 还款日
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_corp_cd -- 还款周期单位代码
    ,rpbl_pric -- 应还本金
    ,rpbl_int -- 应还利息
    ,paid_pric -- 已还本金
    ,paid_int -- 已还利息
    ,paid_pnlt -- 已还罚息
    ,plan_int -- 计划利息
    ,nomal_int_rat -- 正常利率
    ,nomal_int_rat_type_cd -- 正常利率类型代码
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_dt -- 逾期日期
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_exec_int_rat -- 逾期执行利率
    ,ovdue_pric_bal -- 逾期本金余额
    ,ovdue_int_bal -- 逾期利息余额
    ,derate_int -- 减免利息
    ,derate_pnlt -- 减免罚息
    ,recvbl_pnlt -- 应收罚息
    ,int_bal -- 利息余额
    ,td_provi_int -- 当日计提利息
    ,td_provi_pnlt -- 当日计提罚息
    ,pnlt_int_rat -- 罚息利率
    ,pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,pnlt_bal -- 罚息余额
    ,adv_repay_comm_fee_rat -- 提前还款手续费率
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,wrt_off_flg -- 已核销标志
    ,wrt_off_dt -- 核销日期
    ,bank_contri_ratio -- 银行出资比例
    ,plat_indent_id -- 平台订单编号
    ,distr_tran_sucs_dt -- 放款交易成功日期
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,enter_id -- 入账账户编号
    ,enter_type_cd -- 入账账户类型代码
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,fin_org_id -- 财务机构编号
    ,mgmt_org_id -- 管理机构编号
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
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 核心字节借据号码
    ,o.intnal_dubil_id -- 字节借据号码
    ,o.out_acct_flow_num -- 出账流水号
    ,o.cont_id -- 合同编号
    ,o.prod_id -- 产品编号
    ,o.zjdk_prod_id -- 字节产品编号
    ,o.cust_char_cd -- 客户性质代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.dubil_amt -- 借据金额
    ,o.curr_cd -- 币种代码
    ,o.tenor -- 期限
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.flo_val -- 浮动值
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.loan_level5_cls_cd -- 贷款五级分类代码
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.guar_way_cd -- 主担保方式代码
    ,o.loan_status_cd -- 贷款状态代码
    ,o.loan_modal_cd -- 贷款形态代码
    ,o.appl_dt -- 申请日期
    ,o.begin_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.payoff_dt -- 结清日期
    ,o.loan_tot_perds -- 贷款总期数
    ,o.currt_perds -- 当期期数
    ,o.begin_perds -- 起始期数
    ,o.payoff_perds -- 结清期数
    ,o.grace_days -- 宽限天数
    ,o.repay_day -- 还款日
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_corp_cd -- 还款周期单位代码
    ,o.rpbl_pric -- 应还本金
    ,o.rpbl_int -- 应还利息
    ,o.paid_pric -- 已还本金
    ,o.paid_int -- 已还利息
    ,o.paid_pnlt -- 已还罚息
    ,o.plan_int -- 计划利息
    ,o.nomal_int_rat -- 正常利率
    ,o.nomal_int_rat_type_cd -- 正常利率类型代码
    ,o.nomal_pric_bal -- 正常本金余额
    ,o.ovdue_dt -- 逾期日期
    ,o.ovdue_days -- 贷款逾期天数
    ,o.ovdue_exec_int_rat -- 逾期执行利率
    ,o.ovdue_pric_bal -- 逾期本金余额
    ,o.ovdue_int_bal -- 逾期利息余额
    ,o.derate_int -- 减免利息
    ,o.derate_pnlt -- 减免罚息
    ,o.recvbl_pnlt -- 应收罚息
    ,o.int_bal -- 利息余额
    ,o.td_provi_int -- 当日计提利息
    ,o.td_provi_pnlt -- 当日计提罚息
    ,o.pnlt_int_rat -- 罚息利率
    ,o.pnlt_int_rat_type_cd -- 罚息利率类型代码
    ,o.pnlt_bal -- 罚息余额
    ,o.adv_repay_comm_fee_rat -- 提前还款手续费率
    ,o.paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,o.non_acru_flg -- 非应计标志
    ,o.wrt_off_flg -- 已核销标志
    ,o.wrt_off_dt -- 核销日期
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.plat_indent_id -- 平台订单编号
    ,o.distr_tran_sucs_dt -- 放款交易成功日期
    ,o.repay_num_id -- 还款账户编号
    ,o.repay_num_type_cd -- 还款账户类型代码
    ,o.enter_id -- 入账账户编号
    ,o.enter_type_cd -- 入账账户类型代码
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_org_id -- 经办机构编号
    ,o.fin_org_id -- 财务机构编号
    ,o.mgmt_org_id -- 管理机构编号
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
from ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_zjdk_dubil_info_h;
--alter table ${iml_schema}.agt_zjdk_dubil_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_zjdk_dubil_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_zjdk_dubil_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_zjdk_dubil_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_zjdk_dubil_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_zjdk_dubil_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_zjdk_dubil_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_zjdk_dubil_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_zjdk_dubil_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
