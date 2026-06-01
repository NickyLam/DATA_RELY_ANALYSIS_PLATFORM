/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lx_loan_cont_info_h_icmsf1
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
alter table ${iml_schema}.agt_lx_loan_cont_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_loan_cont_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
from ${iml_schema}.agt_lx_loan_cont_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_loan_cont_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lx_loan_cont_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lx_business_contract-1
insert into ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
    '300072'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 合同编号
    ,P1.BASERIALNO -- 授信申请编号
    ,P1.RELACONTRACTNO -- 关联合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,P1.OCCURDATE -- 签约日期
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.BUSINESSFLAG END -- 合同类型代码
    ,decode(P1.ISCYCLE,'1','1','2','1',' ','-',P1.ISCYCLE) -- 额度循环标志
    ,P1.CREDITNO -- 资方授信编号
    ,P1.APPLYID -- 用信申请编号
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.AVAILABLECONTRACTAMT -- 可用额度
    ,P1.BUSINESSSUM -- 合同金额
    ,nvl(trim(P1.STATUS),'-') -- 合同状态代码
    ,P1.STARTDATE -- 生效日期
    ,P1.MATURITY -- 到期日期
    ,P1.PUTOUTSUM -- 放款金额
    ,P1.PUTOUTDATE -- 放款日期
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.RISKTYPE END -- 风险类型代码
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,P1.FIXEDRATE -- 固定利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动方式代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,P1.FLOATRANGE -- 浮动点数
    ,P1.EXECUTERATE -- 执行利率
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'|| P1.REPAYCYCLE END -- 还款周期代码
    ,P1.REPAYDATE -- 指定还款日
    ,P1.SETTLEMENTACCOUNT -- 还款账号编号
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 放款支付方式代码
    ,P1.BALANCE -- 贷款余额
    ,P1.NORMALBALANCE -- 正常余额
    ,P1.OVERDUEBALANCE -- 逾期金额
    ,P1.FINISHDATE -- 结清日期
    ,'-' -- 结清类型代码
    ,nvl(trim(P1.FINISHFLAG),'-') -- 结清标志
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lx_business_contract' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lx_business_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESSFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_LX_BUSINESS_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESSFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LX_LOAN_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CONT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RISKTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_LX_BUSINESS_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'RISKTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LX_LOAN_CONT_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RISK_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.REPAYCYCLE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_LX_BUSINESS_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'REPAYCYCLE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LX_LOAN_CONT_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'REPAY_PED_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,cont_id
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
        into ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
        into ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.rela_cont_id, o.rela_cont_id) as rela_cont_id -- 关联合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.lmt_circl_flg, o.lmt_circl_flg) as lmt_circl_flg -- 额度循环标志
    ,nvl(n.asset_crdt_id, o.asset_crdt_id) as asset_crdt_id -- 资方授信编号
    ,nvl(n.lim_appl_id, o.lim_appl_id) as lim_appl_id -- 用信申请编号
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.aval_lmt, o.aval_lmt) as aval_lmt -- 可用额度
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.cont_effect_dt, o.cont_effect_dt) as cont_effect_dt -- 生效日期
    ,nvl(n.cont_exp_dt, o.cont_exp_dt) as cont_exp_dt -- 到期日期
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.risk_type_cd, o.risk_type_cd) as risk_type_cd -- 风险类型代码
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.fix_int_rat, o.fix_int_rat) as fix_int_rat -- 固定利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.float_range, o.float_range) as float_range -- 浮动点数
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 主担保方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期代码
    ,nvl(n.spec_repay_day, o.spec_repay_day) as spec_repay_day -- 指定还款日
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账号编号
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 放款支付方式代码
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.nomal_bal, o.nomal_bal) as nomal_bal -- 正常余额
    ,nvl(n.ovdue_amt, o.ovdue_amt) as ovdue_amt -- 逾期金额
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.payoff_type_cd, o.payoff_type_cd) as payoff_type_cd -- 结清类型代码
    ,nvl(n.payoff_flg, o.payoff_flg) as payoff_flg -- 结清标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.cont_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.cont_id is null
    )
    or (
        o.crdt_appl_id <> n.crdt_appl_id
        or o.rela_cont_id <> n.rela_cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.sign_dt <> n.sign_dt
        or o.curr_cd <> n.curr_cd
        or o.cont_type_cd <> n.cont_type_cd
        or o.lmt_circl_flg <> n.lmt_circl_flg
        or o.asset_crdt_id <> n.asset_crdt_id
        or o.lim_appl_id <> n.lim_appl_id
        or o.apv_status_cd <> n.apv_status_cd
        or o.aval_lmt <> n.aval_lmt
        or o.cont_amt <> n.cont_amt
        or o.cont_status_cd <> n.cont_status_cd
        or o.cont_effect_dt <> n.cont_effect_dt
        or o.cont_exp_dt <> n.cont_exp_dt
        or o.distr_amt <> n.distr_amt
        or o.distr_dt <> n.distr_dt
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.risk_type_cd <> n.risk_type_cd
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.fix_int_rat <> n.fix_int_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.float_range <> n.float_range
        or o.exec_int_rat <> n.exec_int_rat
        or o.guar_way_cd <> n.guar_way_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.spec_repay_day <> n.spec_repay_day
        or o.repay_num_id <> n.repay_num_id
        or o.mode_pay_cd <> n.mode_pay_cd
        or o.loan_bal <> n.loan_bal
        or o.nomal_bal <> n.nomal_bal
        or o.ovdue_amt <> n.ovdue_amt
        or o.payoff_dt <> n.payoff_dt
        or o.payoff_type_cd <> n.payoff_type_cd
        or o.payoff_flg <> n.payoff_flg
        or o.remark <> n.remark
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
        into ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
        into ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sign_dt -- 签约日期
    ,curr_cd -- 币种代码
    ,cont_type_cd -- 合同类型代码
    ,lmt_circl_flg -- 额度循环标志
    ,asset_crdt_id -- 资方授信编号
    ,lim_appl_id -- 用信申请编号
    ,apv_status_cd -- 审批状态代码
    ,aval_lmt -- 可用额度
    ,cont_amt -- 合同金额
    ,cont_status_cd -- 合同状态代码
    ,cont_effect_dt -- 生效日期
    ,cont_exp_dt -- 到期日期
    ,distr_amt -- 放款金额
    ,distr_dt -- 放款日期
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,risk_type_cd -- 风险类型代码
    ,int_rat_mode_cd -- 利率模式代码
    ,fix_int_rat -- 固定利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,float_range -- 浮动点数
    ,exec_int_rat -- 执行利率
    ,guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,spec_repay_day -- 指定还款日
    ,repay_num_id -- 还款账号编号
    ,mode_pay_cd -- 放款支付方式代码
    ,loan_bal -- 贷款余额
    ,nomal_bal -- 正常余额
    ,ovdue_amt -- 逾期金额
    ,payoff_dt -- 结清日期
    ,payoff_type_cd -- 结清类型代码
    ,payoff_flg -- 结清标志
    ,remark -- 备注
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
    ,o.cont_id -- 合同编号
    ,o.crdt_appl_id -- 授信申请编号
    ,o.rela_cont_id -- 关联合同编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.sign_dt -- 签约日期
    ,o.curr_cd -- 币种代码
    ,o.cont_type_cd -- 合同类型代码
    ,o.lmt_circl_flg -- 额度循环标志
    ,o.asset_crdt_id -- 资方授信编号
    ,o.lim_appl_id -- 用信申请编号
    ,o.apv_status_cd -- 审批状态代码
    ,o.aval_lmt -- 可用额度
    ,o.cont_amt -- 合同金额
    ,o.cont_status_cd -- 合同状态代码
    ,o.cont_effect_dt -- 生效日期
    ,o.cont_exp_dt -- 到期日期
    ,o.distr_amt -- 放款金额
    ,o.distr_dt -- 放款日期
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.risk_type_cd -- 风险类型代码
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.fix_int_rat -- 固定利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.float_range -- 浮动点数
    ,o.exec_int_rat -- 执行利率
    ,o.guar_way_cd -- 主担保方式代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_cd -- 还款周期代码
    ,o.spec_repay_day -- 指定还款日
    ,o.repay_num_id -- 还款账号编号
    ,o.mode_pay_cd -- 放款支付方式代码
    ,o.loan_bal -- 贷款余额
    ,o.nomal_bal -- 正常余额
    ,o.ovdue_amt -- 逾期金额
    ,o.payoff_dt -- 结清日期
    ,o.payoff_type_cd -- 结清类型代码
    ,o.payoff_flg -- 结清标志
    ,o.remark -- 备注
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
from ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.cont_id = d.cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lx_loan_cont_info_h;
--alter table ${iml_schema}.agt_lx_loan_cont_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lx_loan_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lx_loan_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lx_loan_cont_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lx_loan_cont_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_lx_loan_cont_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lx_loan_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lx_loan_cont_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lx_loan_cont_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
