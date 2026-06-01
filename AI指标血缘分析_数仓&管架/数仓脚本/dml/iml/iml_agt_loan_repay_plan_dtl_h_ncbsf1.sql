/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_repay_plan_dtl_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_repay_plan_dtl_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_repay_plan_dtl_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_repay_plan_dtl_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_repay_plan_dtl_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_repay_plan_dtl_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct_schedule_detail-1
insert into ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SCHED_SEQ_NO -- 还款计划编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.STAGE_NO -- 当前期次
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.START_DATE -- 起息日期
    ,P1.END_DATE -- 结息日期
    ,P1.SCHED_AMT -- 计划还款金额
    ,P1.PAID_AMT -- 已还金额
    ,P1.PRI_OUTSTANDING -- 本金金额
    ,DECODE(P1.INVOICE_FLAG,'Y','1','N','0') -- 出单标志
    ,P1.INVOICE_TRAN_NO -- 通知单号
    ,P1.INT_RATE -- 出单利率
    ,P1.BILLED_AMT -- 出单金额
    ,P1.OUTSTANDING -- 单据余额
    ,P1.DUE_DATE -- 单据到期日期
    ,P1.GRACE_DATE -- 宽限日期
    ,P1.TRAN_DATE -- 交易日期
    ,P1.FINAL_SETTLE_DATE -- 结算日期
    ,decode(trim(p1.FULLY_SETTLED_FLAG),'','-','Y','1','N','0',p1.FULLY_SETTLED_FLAG) -- 全额回收标志
    ,nvl(trim(P1.INVOICE_GEN_MODE),'-') -- 单据生成方式代码
    ,P1.REFERENCE -- 交易参考号
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,P1.TAX_RATE -- 税率
    ,P1.TAX_AMT -- 税金
    ,P1.OUTSTANDING_PREV -- 单据上日未还金额
    ,P1.OUTSTANDING_PREV_CHANGE_DATE -- 上日余额更新日期
    ,decode(trim(p1.DELAY_PAY_INT),'','-','Y','1','N','0',p1.DELAY_PAY_INT) -- 延期付息标志
    ,P1.WRN_AMT -- 核销本金
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct_schedule_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_schedule_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,repay_plan_id
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
        into ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
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
    ,nvl(n.repay_plan_id, o.repay_plan_id) as repay_plan_id -- 还款计划编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.curr_pd, o.curr_pd) as curr_pd -- 当前期次
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.int_set_dt, o.int_set_dt) as int_set_dt -- 结息日期
    ,nvl(n.plan_repay_amt, o.plan_repay_amt) as plan_repay_amt -- 计划还款金额
    ,nvl(n.aldy_paid_amt, o.aldy_paid_amt) as aldy_paid_amt -- 已还金额
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.iss_flg, o.iss_flg) as iss_flg -- 出单标志
    ,nvl(n.advise_odd_no, o.advise_odd_no) as advise_odd_no -- 通知单号
    ,nvl(n.iss_int_rat, o.iss_int_rat) as iss_int_rat -- 出单利率
    ,nvl(n.iss_amt, o.iss_amt) as iss_amt -- 出单金额
    ,nvl(n.doc_bal, o.doc_bal) as doc_bal -- 单据余额
    ,nvl(n.doc_exp_dt, o.doc_exp_dt) as doc_exp_dt -- 单据到期日期
    ,nvl(n.grace_dt, o.grace_dt) as grace_dt -- 宽限日期
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.full_amt_callbk_flg, o.full_amt_callbk_flg) as full_amt_callbk_flg -- 全额回收标志
    ,nvl(n.doc_create_way_cd, o.doc_create_way_cd) as doc_create_way_cd -- 单据生成方式代码
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tax_category_cd, o.tax_category_cd) as tax_category_cd -- 税种代码
    ,nvl(n.tax_rat, o.tax_rat) as tax_rat -- 税率
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 税金
    ,nvl(n.doc_ld_unpaid_amt, o.doc_ld_unpaid_amt) as doc_ld_unpaid_amt -- 单据上日未还金额
    ,nvl(n.ld_bal_update_dt, o.ld_bal_update_dt) as ld_bal_update_dt -- 上日余额更新日期
    ,nvl(n.delay_pay_int_flg, o.delay_pay_int_flg) as delay_pay_int_flg -- 延期付息标志
    ,nvl(n.wrt_off_pric, o.wrt_off_pric) as wrt_off_pric -- 核销本金
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.repay_plan_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.repay_plan_id = n.repay_plan_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.repay_plan_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.repay_plan_id is null
    )
    or (
        o.acct_id <> n.acct_id
        or o.cust_id <> n.cust_id
        or o.curr_pd <> n.curr_pd
        or o.amt_type_cd <> n.amt_type_cd
        or o.value_dt <> n.value_dt
        or o.int_set_dt <> n.int_set_dt
        or o.plan_repay_amt <> n.plan_repay_amt
        or o.aldy_paid_amt <> n.aldy_paid_amt
        or o.pric_amt <> n.pric_amt
        or o.iss_flg <> n.iss_flg
        or o.advise_odd_no <> n.advise_odd_no
        or o.iss_int_rat <> n.iss_int_rat
        or o.iss_amt <> n.iss_amt
        or o.doc_bal <> n.doc_bal
        or o.doc_exp_dt <> n.doc_exp_dt
        or o.grace_dt <> n.grace_dt
        or o.tran_dt <> n.tran_dt
        or o.stl_dt <> n.stl_dt
        or o.full_amt_callbk_flg <> n.full_amt_callbk_flg
        or o.doc_create_way_cd <> n.doc_create_way_cd
        or o.tran_ref_no <> n.tran_ref_no
        or o.tax_category_cd <> n.tax_category_cd
        or o.tax_rat <> n.tax_rat
        or o.tax_amt <> n.tax_amt
        or o.doc_ld_unpaid_amt <> n.doc_ld_unpaid_amt
        or o.ld_bal_update_dt <> n.ld_bal_update_dt
        or o.delay_pay_int_flg <> n.delay_pay_int_flg
        or o.wrt_off_pric <> n.wrt_off_pric
        or o.tran_teller_id <> n.tran_teller_id
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,repay_plan_id -- 还款计划编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,curr_pd -- 当前期次
    ,amt_type_cd -- 金额类型代码
    ,value_dt -- 起息日期
    ,int_set_dt -- 结息日期
    ,plan_repay_amt -- 计划还款金额
    ,aldy_paid_amt -- 已还金额
    ,pric_amt -- 本金金额
    ,iss_flg -- 出单标志
    ,advise_odd_no -- 通知单号
    ,iss_int_rat -- 出单利率
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,doc_exp_dt -- 单据到期日期
    ,grace_dt -- 宽限日期
    ,tran_dt -- 交易日期
    ,stl_dt -- 结算日期
    ,full_amt_callbk_flg -- 全额回收标志
    ,doc_create_way_cd -- 单据生成方式代码
    ,tran_ref_no -- 交易参考号
    ,tax_category_cd -- 税种代码
    ,tax_rat -- 税率
    ,tax_amt -- 税金
    ,doc_ld_unpaid_amt -- 单据上日未还金额
    ,ld_bal_update_dt -- 上日余额更新日期
    ,delay_pay_int_flg -- 延期付息标志
    ,wrt_off_pric -- 核销本金
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
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
    ,o.repay_plan_id -- 还款计划编号
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.curr_pd -- 当前期次
    ,o.amt_type_cd -- 金额类型代码
    ,o.value_dt -- 起息日期
    ,o.int_set_dt -- 结息日期
    ,o.plan_repay_amt -- 计划还款金额
    ,o.aldy_paid_amt -- 已还金额
    ,o.pric_amt -- 本金金额
    ,o.iss_flg -- 出单标志
    ,o.advise_odd_no -- 通知单号
    ,o.iss_int_rat -- 出单利率
    ,o.iss_amt -- 出单金额
    ,o.doc_bal -- 单据余额
    ,o.doc_exp_dt -- 单据到期日期
    ,o.grace_dt -- 宽限日期
    ,o.tran_dt -- 交易日期
    ,o.stl_dt -- 结算日期
    ,o.full_amt_callbk_flg -- 全额回收标志
    ,o.doc_create_way_cd -- 单据生成方式代码
    ,o.tran_ref_no -- 交易参考号
    ,o.tax_category_cd -- 税种代码
    ,o.tax_rat -- 税率
    ,o.tax_amt -- 税金
    ,o.doc_ld_unpaid_amt -- 单据上日未还金额
    ,o.ld_bal_update_dt -- 上日余额更新日期
    ,o.delay_pay_int_flg -- 延期付息标志
    ,o.wrt_off_pric -- 核销本金
    ,o.tran_teller_id -- 交易柜员编号
    ,o.final_modif_dt -- 最后修改日期
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
from ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.repay_plan_id = n.repay_plan_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.repay_plan_id = d.repay_plan_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_repay_plan_dtl_h;
--alter table ${iml_schema}.agt_loan_repay_plan_dtl_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_repay_plan_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_repay_plan_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_repay_plan_dtl_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_repay_plan_dtl_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_repay_plan_dtl_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_repay_plan_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_repay_plan_dtl_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_repay_plan_dtl_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
