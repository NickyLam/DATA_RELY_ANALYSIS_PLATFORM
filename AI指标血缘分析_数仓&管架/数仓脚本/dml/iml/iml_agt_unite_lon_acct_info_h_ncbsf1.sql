/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_unite_lon_acct_info_h_ncbsf1
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
alter table ${iml_schema}.agt_unite_lon_acct_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_acct_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_unite_lon_acct_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_acct_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_unite_lon_acct_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_ul_acct-1
insert into ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222630'||P1.CMISLOAN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.LENDER -- 客户名称
    ,P1.ACCT_NAME -- 账户名称
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,nvl(trim(P1.ACCT_STATUS_PREV),'-') -- 上一账户状态代码
    ,nvl(trim(P1.ACCT_TYPE),'-') -- 账户类型代码
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.DD_NO -- 放款流水号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.MARKETING_PROD -- 营销产品编号
    ,P1.MARKETING_PROD_DESC -- 营销产品名称
    ,nvl(trim(P1.TERM),0) -- 贷款期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,nvl(trim(P1.CUR_STAGE_NO),0) -- 当前期次
    ,nvl(trim(P1.FIVE_CATEGORY),'90') -- 五级分类代码
    ,decode(trim(P1.INT_IND_FLAG),'Y','1','N','0','','-') -- 计息标志
    ,decode(trim(P1.IS_INDIVIDUAL),'Y','1','N','0','','-') -- 个体工商户标志
    ,decode(trim(P1.MANUAL_CHANGE_SCHEDULE_FLAG),'Y','1','N','0','','-') -- 需要手工录入还款计划标志
    ,nvl(trim(P1.FIVE_CATEGORY),'0000') -- 贷款用途代码
    ,nvl(trim(P1.SCHED_MODE),'-') -- 还款方式代码
    ,P1.DD_AMT -- 放款金额
    ,P1.FORMULA_AMT -- 每期计划还款金额
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,nvl(trim(P1.ACCOUNTING_STATUS_PREV),'-') -- 上一核算状态代码
    ,P1.ACCOUNTING_STATUS_UPD_DATE -- 核算状态变更日期
    ,P1.ACCT_CLOSE_DATE -- 销户日期
    ,P1.ACCT_CLOSE_REASON -- 销户原因
    ,P1.ACCT_OPEN_DATE -- 开户日期
    ,P1.ACCT_STATUS_UPD_DATE -- 账户状态变更日期
    ,P1.EFFECT_DATE -- 产品生效日期
    ,P1.FIRST_OVERDUE_DATE -- 最早逾期日期
    ,P1.LAST_TRAN_DATE -- 最后交易日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.OPEN_TRAN_DATE -- 首次交易日期
    ,P1.ORI_MATURITY_DATE -- 原始到期日期
    ,P1.ORIG_ACCT_OPEN_DATE -- 原始开户日期
    ,P1.SSI_END_DATE -- 贴息截止日期
    ,P1.APPLY_BRANCH -- 申请机构编号
    ,P1.BELONG_BRANCH -- 归属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ul_acct' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ul_acct p1
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
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
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.last_acct_status_cd, o.last_acct_status_cd) as last_acct_status_cd -- 上一账户状态代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.distr_flow_num, o.distr_flow_num) as distr_flow_num -- 放款流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.camp_prod_id, o.camp_prod_id) as camp_prod_id -- 营销产品编号
    ,nvl(n.camp_prod_name, o.camp_prod_name) as camp_prod_name -- 营销产品名称
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.curr_pd, o.curr_pd) as curr_pd -- 当前期次
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.indv_bus_flg, o.indv_bus_flg) as indv_bus_flg -- 个体工商户标志
    ,nvl(n.need_manual_input_repay_plan_flg, o.need_manual_input_repay_plan_flg) as need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.eh_issue_plan_repay_amt, o.eh_issue_plan_repay_amt) as eh_issue_plan_repay_amt -- 每期计划还款金额
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.last_accti_status_cd, o.last_accti_status_cd) as last_accti_status_cd -- 上一核算状态代码
    ,nvl(n.accti_status_modif_dt, o.accti_status_modif_dt) as accti_status_modif_dt -- 核算状态变更日期
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_rs, o.clos_acct_rs) as clos_acct_rs -- 销户原因
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.acct_status_modif_dt, o.acct_status_modif_dt) as acct_status_modif_dt -- 账户状态变更日期
    ,nvl(n.prod_effect_dt, o.prod_effect_dt) as prod_effect_dt -- 产品生效日期
    ,nvl(n.earliest_ovdue_dt, o.earliest_ovdue_dt) as earliest_ovdue_dt -- 最早逾期日期
    ,nvl(n.final_tran_dt, o.final_tran_dt) as final_tran_dt -- 最后交易日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.fir_tran_dt, o.fir_tran_dt) as fir_tran_dt -- 首次交易日期
    ,nvl(n.init_exp_dt, o.init_exp_dt) as init_exp_dt -- 原始到期日期
    ,nvl(n.init_open_acct_dt, o.init_open_acct_dt) as init_open_acct_dt -- 原始开户日期
    ,nvl(n.int_sub_closing_dt, o.int_sub_closing_dt) as int_sub_closing_dt -- 贴息截止日期
    ,nvl(n.appl_org_id, o.appl_org_id) as appl_org_id -- 申请机构编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 归属机构编号
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
from ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.loan_num <> n.loan_num
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.acct_name <> n.acct_name
        or o.acct_status_cd <> n.acct_status_cd
        or o.last_acct_status_cd <> n.last_acct_status_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.curr_cd <> n.curr_cd
        or o.distr_flow_num <> n.distr_flow_num
        or o.prod_id <> n.prod_id
        or o.camp_prod_id <> n.camp_prod_id
        or o.camp_prod_name <> n.camp_prod_name
        or o.loan_tenor <> n.loan_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.curr_pd <> n.curr_pd
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.indv_bus_flg <> n.indv_bus_flg
        or o.need_manual_input_repay_plan_flg <> n.need_manual_input_repay_plan_flg
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.distr_amt <> n.distr_amt
        or o.eh_issue_plan_repay_amt <> n.eh_issue_plan_repay_amt
        or o.chn_id <> n.chn_id
        or o.accti_status_cd <> n.accti_status_cd
        or o.last_accti_status_cd <> n.last_accti_status_cd
        or o.accti_status_modif_dt <> n.accti_status_modif_dt
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.clos_acct_rs <> n.clos_acct_rs
        or o.open_acct_dt <> n.open_acct_dt
        or o.acct_status_modif_dt <> n.acct_status_modif_dt
        or o.prod_effect_dt <> n.prod_effect_dt
        or o.earliest_ovdue_dt <> n.earliest_ovdue_dt
        or o.final_tran_dt <> n.final_tran_dt
        or o.exp_dt <> n.exp_dt
        or o.fir_tran_dt <> n.fir_tran_dt
        or o.init_exp_dt <> n.init_exp_dt
        or o.init_open_acct_dt <> n.init_open_acct_dt
        or o.int_sub_closing_dt <> n.int_sub_closing_dt
        or o.appl_org_id <> n.appl_org_id
        or o.belong_org_id <> n.belong_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,loan_num -- 贷款号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,acct_name -- 账户名称
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_type_cd -- 账户类型代码
    ,curr_cd -- 币种代码
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,curr_pd -- 当前期次
    ,level5_cls_cd -- 五级分类代码
    ,int_accr_flg -- 计息标志
    ,indv_bus_flg -- 个体工商户标志
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,loan_usage_cd -- 贷款用途代码
    ,repay_way_cd -- 还款方式代码
    ,distr_amt -- 放款金额
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,chn_id -- 渠道编号
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,open_acct_dt -- 开户日期
    ,acct_status_modif_dt -- 账户状态变更日期
    ,prod_effect_dt -- 产品生效日期
    ,earliest_ovdue_dt -- 最早逾期日期
    ,final_tran_dt -- 最后交易日期
    ,exp_dt -- 到期日期
    ,fir_tran_dt -- 首次交易日期
    ,init_exp_dt -- 原始到期日期
    ,init_open_acct_dt -- 原始开户日期
    ,int_sub_closing_dt -- 贴息截止日期
    ,appl_org_id -- 申请机构编号
    ,belong_org_id -- 归属机构编号
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
    ,o.loan_num -- 贷款号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.acct_name -- 账户名称
    ,o.acct_status_cd -- 账户状态代码
    ,o.last_acct_status_cd -- 上一账户状态代码
    ,o.acct_type_cd -- 账户类型代码
    ,o.curr_cd -- 币种代码
    ,o.distr_flow_num -- 放款流水号
    ,o.prod_id -- 产品编号
    ,o.camp_prod_id -- 营销产品编号
    ,o.camp_prod_name -- 营销产品名称
    ,o.loan_tenor -- 贷款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.curr_pd -- 当前期次
    ,o.level5_cls_cd -- 五级分类代码
    ,o.int_accr_flg -- 计息标志
    ,o.indv_bus_flg -- 个体工商户标志
    ,o.need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.distr_amt -- 放款金额
    ,o.eh_issue_plan_repay_amt -- 每期计划还款金额
    ,o.chn_id -- 渠道编号
    ,o.accti_status_cd -- 核算状态代码
    ,o.last_accti_status_cd -- 上一核算状态代码
    ,o.accti_status_modif_dt -- 核算状态变更日期
    ,o.clos_acct_dt -- 销户日期
    ,o.clos_acct_rs -- 销户原因
    ,o.open_acct_dt -- 开户日期
    ,o.acct_status_modif_dt -- 账户状态变更日期
    ,o.prod_effect_dt -- 产品生效日期
    ,o.earliest_ovdue_dt -- 最早逾期日期
    ,o.final_tran_dt -- 最后交易日期
    ,o.exp_dt -- 到期日期
    ,o.fir_tran_dt -- 首次交易日期
    ,o.init_exp_dt -- 原始到期日期
    ,o.init_open_acct_dt -- 原始开户日期
    ,o.int_sub_closing_dt -- 贴息截止日期
    ,o.appl_org_id -- 申请机构编号
    ,o.belong_org_id -- 归属机构编号
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
from ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_unite_lon_acct_info_h;
--alter table ${iml_schema}.agt_unite_lon_acct_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_unite_lon_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_unite_lon_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_unite_lon_acct_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_unite_lon_acct_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_unite_lon_acct_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_unite_lon_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_unite_lon_acct_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_unite_lon_acct_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
