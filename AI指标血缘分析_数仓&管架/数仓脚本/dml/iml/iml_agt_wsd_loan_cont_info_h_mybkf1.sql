/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wsd_loan_cont_info_h_mybkf1
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
alter table ${iml_schema}.agt_wsd_loan_cont_info_h add partition p_mybkf1 values ('mybkf1')(
        subpartition p_mybkf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mybkf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_loan_cont_info_h partition for ('mybkf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op purge;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wsd_loan_cont_info_h partition for ('mybkf1')
where 0=1
;

create table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_loan_cont_info_h partition for ('mybkf1') where 0=1;

create table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wsd_loan_cont_info_h partition for ('mybkf1') where 0=1;

-- 3.1 get new data into table
-- icms_mybk_business_contract-1
insert into ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300043'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.BUSINESSFLAG END -- 额度合同标志
    ,P1.BASERIALNO -- 授信申请编号
    ,nvl(trim(P1.APPLYTYPE),'-') -- 申请类型代码
    ,P1.OCCURDATE -- 签订日期
    ,P1.FINISHDATE -- 结清日期
    ,P1.CURRENCY -- 币种代码
    ,P1.BUSINESSSUM -- 合同金额
    ,P1.PUTOUTSUM -- 实际出账金额
    ,P1.PUTOUTDATE -- 出账日期
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,${iml_schema}.dateformat_min(P1.REPAYDATE) -- 指定还款日期
    ,P1.TERMMONTH -- 期限
    ,nvl(trim(P1.BASERATETYPE),'L9') -- 利率浮动方式代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,P1.EXECUTERATE -- 执行利率
    ,P1.BALANCE -- 贷款余额
    ,nvl(trim(P1.STATUS),'-') -- 合同状态代码
    ,P1.STARTDATE -- 生效日期
    ,P1.MATURITY -- 失效日期
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,P1.LOANACCOUNTNAME -- 收款账户编号
    ,P1.LOANACCOUNTORGID -- 收款人开户行行号
    ,P1.OPERATEUSERID -- 经办柜员编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.OPERATEDATE -- 经办日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_business_contract' -- 源表名称
    ,'mybkf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_business_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESSFLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYBK_BUSINESS_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESSFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WSD_LOAN_CONT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LMT_CONT_FLG'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm 
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
        into ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lmt_cont_flg, o.lmt_cont_flg) as lmt_cont_flg -- 额度合同标志
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.appl_type_cd, o.appl_type_cd) as appl_type_cd -- 申请类型代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签订日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.actl_out_acct_amt, o.actl_out_acct_amt) as actl_out_acct_amt -- 实际出账金额
    ,nvl(n.out_acct_dt, o.out_acct_dt) as out_acct_dt -- 出账日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.spec_repay_dt, o.spec_repay_dt) as spec_repay_dt -- 指定还款日期
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recver_open_bank_no, o.recver_open_bank_no) as recver_open_bank_no -- 收款人开户行行号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 经办柜员编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.up_date, o.up_date) as up_date -- 更新日期
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
from ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm n
    full join (select * from ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cont_id <> n.cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.lmt_cont_flg <> n.lmt_cont_flg
        or o.crdt_appl_id <> n.crdt_appl_id
        or o.appl_type_cd <> n.appl_type_cd
        or o.sign_dt <> n.sign_dt
        or o.payoff_dt <> n.payoff_dt
        or o.curr_cd <> n.curr_cd
        or o.cont_amt <> n.cont_amt
        or o.actl_out_acct_amt <> n.actl_out_acct_amt
        or o.out_acct_dt <> n.out_acct_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.spec_repay_dt <> n.spec_repay_dt
        or o.tenor <> n.tenor
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.exec_int_rat <> n.exec_int_rat
        or o.loan_bal <> n.loan_bal
        or o.cont_status_cd <> n.cont_status_cd
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recver_open_bank_no <> n.recver_open_bank_no
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.oper_dt <> n.oper_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.up_date <> n.up_date
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,lmt_cont_flg -- 额度合同标志
    ,crdt_appl_id -- 授信申请编号
    ,appl_type_cd -- 申请类型代码
    ,sign_dt -- 签订日期
    ,payoff_dt -- 结清日期
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,actl_out_acct_amt -- 实际出账金额
    ,out_acct_dt -- 出账日期
    ,apv_status_cd -- 审批状态代码
    ,spec_repay_dt -- 指定还款日期
    ,tenor -- 期限
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,main_guar_way_cd -- 主担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,exec_int_rat -- 执行利率
    ,loan_bal -- 贷款余额
    ,cont_status_cd -- 合同状态代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,loan_usage_cd -- 贷款用途代码
    ,recvbl_acct_id -- 收款账户编号
    ,recver_open_bank_no -- 收款人开户行行号
    ,oper_teller_id -- 经办柜员编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
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
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.lmt_cont_flg -- 额度合同标志
    ,o.crdt_appl_id -- 授信申请编号
    ,o.appl_type_cd -- 申请类型代码
    ,o.sign_dt -- 签订日期
    ,o.payoff_dt -- 结清日期
    ,o.curr_cd -- 币种代码
    ,o.cont_amt -- 合同金额
    ,o.actl_out_acct_amt -- 实际出账金额
    ,o.out_acct_dt -- 出账日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.spec_repay_dt -- 指定还款日期
    ,o.tenor -- 期限
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.exec_int_rat -- 执行利率
    ,o.loan_bal -- 贷款余额
    ,o.cont_status_cd -- 合同状态代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recver_open_bank_no -- 收款人开户行行号
    ,o.oper_teller_id -- 经办柜员编号
    ,o.oper_org_id -- 经办机构编号
    ,o.oper_dt -- 经办日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.up_date -- 更新日期
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
from ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_bk o
    left join ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl d
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
--truncate table ${iml_schema}.agt_wsd_loan_cont_info_h;
--alter table ${iml_schema}.agt_wsd_loan_cont_info_h truncate partition for ('mybkf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wsd_loan_cont_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mybkf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wsd_loan_cont_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_wsd_loan_cont_info_h modify partition p_mybkf1 
add subpartition p_mybkf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wsd_loan_cont_info_h exchange subpartition p_mybkf1_${batch_date} with table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl;
alter table ${iml_schema}.agt_wsd_loan_cont_info_h exchange subpartition p_mybkf1_20991231 with table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wsd_loan_cont_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_tm purge;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_op purge;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wsd_loan_cont_info_h_mybkf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wsd_loan_cont_info_h', partname => 'p_mybkf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
