/*
Purpose:    共性加工层-对公贷款还款计划：包括所有对公贷款账户的分期还款方式和普通还款方式对应的还款计划，可以根据还款方式代码区分分期还款计划还是普通还款计划，可以通过不规则还款计划标志区分不规则还款计划。数据来源于新核心系统NCBS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_repay_plan
CreateDate: 20220325
Logs:       20220325 李森辉 1、取数数据源调整，由旧核心系统改成新核心系统
                            2、新增字段【利息逾期天数】
                            3、第一组和第二组整合为第一组
            20220330 李森辉 1、调整字段【应计正常本金】的取数口径
                            2、新增字段【本金余额、本期应收金额】
            20220525 李森辉 新增字段【贷款号】
			      20220811 温旺清	1、新增第二组利息的还款计划  2、调整第一组的映射。
			      20220818 翟若平 1、新增字段【还款金额类型代码】
                            2、调整字段【贷款期数、逾期标志、本期本金逾期日期、本期利息逾期日期、本期贷款逾期天数、利息逾期天数、不规则还款计划标志、偿还标志、执行利率、应计正常本金、本期应收金额、本期应收本金、本期应收利息】的加工口径
                            3、删除第二组
            20221110 陈伟峰 调整应还部分字段加工逻辑，从BILLED_AMT改为SCHED_AMT
            20221221 温旺清 1、增加字段【宽限还款日期、本期单据余额】
                            2、调整字段【逾期标志、本期本金逾期日期、本期利息逾期日期、本期贷款逾期天数、利息逾期天数、应计正常本金、本期应收金额】的加工口径
            20230310 陈伟峰	调整agt_loan_acct_info_h表dubil_id使用逻辑，增加银团贷款'203010400001','602060100002'拼接规则
            20230901 徐子豪 调整【贷款期数】加工逻辑，当发生提前还款时，核心会生成一笔期次为999的还款计划，按照最大期次取贷款期数时会取到999的期次，需过滤掉取才准确
            20231030 徐子豪 新增字段【期次历史逾期标志】
            20241105 陈伟峰 调整prd_loan_prod_info_h关联方式，避免过滤集团委托贷款数据

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_repay_plan drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_repay_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_repay_plan_ex purge;


-- 2.1 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_repay_plan_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_repay_plan where 0 = 1;

--第一组（共一组）规则还款计划(本金为主)
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_repay_plan_ex(
       etl_dt                      -- 数据日期
       ,lp_id                      -- 法人编号
       ,dubil_id                   -- 借据编号
       ,acct_id                    -- 账户编号
       ,loan_num                   -- 贷款号
       ,cust_id                    -- 客户编号
       ,tot_perds                  -- 贷款期数
       ,repay_perds                -- 还款期数
       ,repay_sub_perds            -- 还款子期数
       ,value_dt                   -- 起息日期
       ,repaybl_dt                 -- 应还款日期
	     ,grace_repay_dt             -- 宽限还款日期
       ,exec_status_flg            -- 执行状态标志
       ,ovdue_flg                  -- 逾期标志
       ,pd_h_ovdue_flg             -- 期次历史逾期标志
       ,curr_issue_pric_ovdue_dt   -- 本期本金逾期日期
       ,curr_issue_int_ovdue_dt    -- 本期利息逾期日期
       ,curr_issue_ovdue_days      -- 本期贷款逾期天数
       ,int_ovdue_days             -- 利息逾期天数
       ,irr_repay_plan_flg         -- 不规则还款计划标志
       ,repay_flg                  -- 偿还标志
       ,is_int_set_flg             -- 是否结息标志
       ,repay_amt_type_cd          -- 还款金额类型
       ,repay_cate_cd              -- 还款类别代码
       ,repay_way_cd               -- 还款方式代码
       ,curr_cd                    -- 币种代码
       ,exec_int_rat               -- 执行利率
       ,pric_bal                   -- 本金余额
       ,acru_nomal_pric            -- 应计正常本金
       ,curr_issue_recvbl_amt      -- 本期应收金额
       ,curr_doc_bal               -- 本期单据余额
       ,curr_issue_ovdue_pric      -- 本期逾期本金
       ,curr_issue_ovdue_int       -- 本期逾期利息
       ,curr_issue_ovdue_comp_int  -- 本期逾期复利
       ,curr_issue_recvbl_pric     -- 本期应收本金
       ,curr_issue_int_recvbl      -- 本期应收利息
       ,curr_issue_recvbl_fee      -- 本期应收费用
       ,curr_issue_int_sub_amt     -- 本期贴息金额
       ,curr_issue_over_int_bal    -- 本期欠息余额
       ,curr_issue_pnlt_bal        -- 本期罚息余额
       ,curr_issue_idle_bal        -- 本期呆滞余额
       ,curr_issue_bad_debt_bal    -- 本期呆账余额
       ,job_cd                     -- 任务代码
       ,etl_timestamp              -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')         -- 数据日期
       ,t1.lp_id                                   -- 法人编号
       ,case when t1.prod_id in ('203010400001','602060100002')
             then t1.dubil_id||t1.distr_flow_num
             else t1.dubil_id
             end                                   -- 借据号
       ,t1.acct_id                                 -- 账户编号
       ,t1.loan_num                                -- 贷款号
       ,t1.cust_id                                 -- 客户编号
       ,t3.cnt_stage_no                            -- 贷款期数
       ,t2.curr_pd                                 -- 还款期数
       ,t2.repay_plan_id                           -- 还款子期数
       ,t2.value_dt                                -- 起息日期
       ,t2.int_set_dt                              -- 应还款日期
       ,t2.grace_dt                                -- 宽限还款日期
       ,t2.iss_flg                                 -- 执行状态标志
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' then '1' else '0' end  -- 逾期标志
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and (t2.stl_dt >t2.grace_dt or (t2.stl_dt = t2.grace_dt and t2.full_amt_callbk_flg='0') or t2.doc_bal<>0)  then '1' else '0' end  -- 期次历史逾期标志
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' and t2.amt_type_cd = 'PRI' then t2.doc_exp_dt else null end  -- 本期本金逾期日期
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' and t2.amt_type_cd = 'INT' then t2.doc_exp_dt else null end  -- 本期利息逾期日期
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' and t2.amt_type_cd = 'PRI' then to_date('${batch_date}', 'yyyymmdd') - t2.doc_exp_dt + 1 else null end  -- 本期贷款逾期天数
       ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' and t2.amt_type_cd = 'INT' then to_date('${batch_date}', 'yyyymmdd') - t2.doc_exp_dt + 1 else null end  -- 利息逾期天数
       ,case when t1.repay_way_cd in ('5', '10') then '1' else '0' end                                   -- 不规则还款计划标志
       ,case when t2.full_amt_callbk_flg = '1' then '1' else '0' end                                     -- 偿还标志
       ,t6.int_set_flg                                                                                   -- 是否结息标志
       ,t2.amt_type_cd                                                                                   -- 还款金额类型代码
       ,decode(t2.amt_type_cd, 'PRI', '1', 'INT', '2', '-')                                              -- 还款类别代码
       ,t1.repay_way_cd                                                                                  -- 还款方式代码
       ,t1.curr_cd                                                                                       -- 币种代码
       ,nvl(t2.iss_int_rat, 0.00)                                                                        -- 执行利率
       ,nvl(t8.ld_ovdue_pric, 0) + nvl(t8.ld_nomal_pric, 0)                                              -- 本金余额
       ,decode(t2.amt_type_cd, 'PRI', nvl(t2.plan_repay_amt, 0), 0)                                             -- 应计正常本金
       ,nvl(t2.plan_repay_amt, 0)                                                                               -- 本期应收金额
       ,t2.doc_bal                                                                                       -- 本期单据余额
       ,nvl(t4.ld_ovdue_pric, 0)                                                                         -- 本期逾期本金
       ,nvl(t4.ld_ovdue_int, 0)                                                                          -- 本期逾期利息
       ,nvl(t4.ld_ovdue_comp_int, 0)                                                                     -- 本期逾期复利
       ,decode(t2.amt_type_cd, 'PRI', nvl(t2.plan_repay_amt, 0), 0)                                             -- 本期应收本金
       ,decode(t2.amt_type_cd, 'INT', nvl(t2.plan_repay_amt, 0), 0)                                             -- 本期应收利息
       ,0                                                                                                -- 本期应收费用
       ,0                                                                                                -- 本期贴息金额
       ,nvl(t4.ld_ovdue_int, 0)                                                                          -- 本期欠息余额
       ,nvl(t4.ld_ovdue_pnlt, 0)                                                                         -- 本期罚息余额
       ,0                                                                                                -- 本期呆滞余额
       ,0      	   	                                                                                     -- 本期呆账余额
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_acct_info_h t1
 inner join ${iml_schema}.agt_loan_repay_plan_dtl_h t2
    on t1.acct_id = t2.acct_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 inner join ${iml_schema}.prd_loan_prod_info_h t7
    on t1.prod_id = t7.prod_id
--   and t7.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
 left join (select st.acct_id,max(st.curr_pd) as cnt_stage_no
             from ${iml_schema}.agt_loan_repay_plan_dtl_h st
            where st.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and st.end_dt > to_date('${batch_date}', 'yyyymmdd')
              and st.job_cd = 'ncbsf1'
              and st.curr_pd <> '999'
              group by st.acct_id ) t3
    on t1.acct_id = t3.acct_id
 left join ${iml_schema}.agt_loan_repay_plan_pd_h t4
    on t1.acct_id = t4.acct_id
   and t2.curr_pd = t4.curr_pd
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ncbsf1'
 left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h t6
   on t1.acct_id = t6.acct_id
  and t6.int_cls_cd = 'INT'
  and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t6.job_cd = 'ncbsf1'
 left join ${iml_schema}.agt_loan_acct_bal_h t8
   on t1.acct_id = t8.acct_id
  and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t8.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'ncbsf1'
  and (t7.crdt_prod_cate_cd not in ('2','3','4') or t1.prod_id='602030100003')  --零售贷款,联合网贷,个人委托贷款，集团委托贷款
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_repay_plan exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_repay_plan_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_repay_plan_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_loan_repay_plan',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);