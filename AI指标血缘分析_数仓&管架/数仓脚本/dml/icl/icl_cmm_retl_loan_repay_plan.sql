/*
Purpose:    共性加工层-零售贷款还款计划
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_repay_plan
CreateDate: 20190815
Logs:       20210805 陈伟峰 调整【应计正常本金,本期应收应计利息,本期催收应计利息,本期应收欠息，本期催收欠息，本期应收应计罚息，本期催收应计罚息，本期应收罚息，本期催收罚息，本期应计复息，本期复息】加工逻辑，优先从贷款账户期供表取
            20211215 陈伟峰 调整【偿还标志】加工逻辑，当子期数在期供历史不存在时，为“偿还”
			      20220525 温旺清	新增字段【贷款号 LOAN_NUM】
            20220812 温旺清	1、新增第二组利息的还款计划  2、调整第一组的映射.
            20220818 翟若平 1、新增字段【还款金额类型代码】
                            2、置空字段【下次还款日期】
                            3、调整字段【贷款期数、逾期标志、偿还标志、执行利率、应计正常本金、本期应收金额、本期应收本金、本期应收利息、本期应收应计利息】的加工口径
                            4、删除第二组
            20221110 陈伟峰 调整应还部分字段加工逻辑，从BILLED_AMT改为SCHED_AMT
            20221221 温旺清 1、调整字段【逾期标志】的加工口径
                            2、新增字段【本期单据余额】
            20230901 徐子豪 调整【贷款期数】加工逻辑，当发生提前还款时，核心会生成一笔期次为999的还款计划，按照最大期次取贷款期数时会取到999的期次，需过滤掉取才准确
            20231010 徐子豪 新增字段【本期逾期本金】
            20231030 徐子豪 新增字段【期次历史逾期标志】
            20250106 陈伟峰 新增【网商贷-房抵贷】产品数据
            20250409 陈伟峰 调整第二组子期数逻辑，使用空格处理避免主键字段为空
            20251211 陈伟峰 调整房抵贷部分的【期次历史逾期标志】加工逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_repay_plan drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_repay_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop exchange_tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_repay_plan_ex purge;


-- 1.3 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_repay_plan_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_repay_plan where 0=1;

-- 第一组 规则还款计划(本金)
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_repay_plan_ex(
    etl_dt                           -- 数据日期
    ,lp_id                           -- 法人编号
    ,dubil_id                        -- 借据编号
    ,acct_id                         -- 账户编号
	  ,loan_num                        -- 贷款号
    ,cust_id                         -- 客户编号
    ,tot_perds                       -- 贷款期数
    ,repay_perds                     -- 还款期数
    ,repay_sub_perds                 -- 还款子期数
    ,value_dt                        -- 起息日期
    ,repaybl_dt                      -- 应还款日期
    ,grace_repay_dt                  -- 宽限还款日期
    ,last_repay_dt                   -- 上次还款日期
    ,next_repay_dt                   -- 下次还款日期
    ,modif_dt                        -- 修改日期
    ,repay_amt_type_cd               -- 还款金额类型
    ,repay_type_cd                   -- 还款类型代码
    ,repay_status_cd                 -- 还款状态代码
    ,ovdue_flg                       -- 逾期标志
    ,repay_flg                       -- 偿还标志
    ,pd_h_ovdue_flg                  -- 期次历史逾期标志
    ,curr_cd                         -- 币种代码
    ,exec_int_rat                    -- 执行利率
    ,pric_bal                        -- 本金余额
    ,acru_nomal_pric                 -- 应计正常本金
    ,curr_issue_recvbl_amt           -- 本期应收金额
    ,curr_doc_bal                    -- 本期单据余额
    ,curr_issue_recvbl_pric          -- 本期应收本金
    ,curr_issue_int_recvbl           -- 本期应收利息
    ,curr_issue_recvbl_acru_int      -- 本期应收应计利息
    ,curr_issue_coll_acru_int        -- 本期催收应计利息
    ,curr_issue_ovdue_pric           -- 本期逾期本金
    ,curr_issue_recvbl_over_int      -- 本期应收欠息
    ,curr_issue_coll_over_int        -- 本期催收欠息
    ,curr_issue_recvbl_acru_pnlt     -- 本期应收应计罚息
    ,curr_issue_coll_acru_pnlt       -- 本期催收应计罚息
    ,curr_issue_recvbl_pnlt          -- 本期应收罚息
    ,curr_issue_coll_pnlt            -- 本期催收罚息
    ,curr_issue_acru_comp_int        -- 本期应计复息
    ,curr_issue_comp_int             -- 本期复息
    ,job_cd	                         -- 任务代码
    ,etl_timestamp                   -- etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')	                   -- 数据日期
    ,t1.lp_id	                                             -- 法人编号
    ,t1.dubil_id                                           -- 借据编号
    ,t1.acct_id                                            -- 账户编号
    ,t1.loan_num                                           -- 贷款号
    ,t1.cust_id                                            -- 客户编号
    ,t3.cnt_stage_no                                       -- 贷款期数
    ,t2.curr_pd                                            -- 还款期数
    ,t2.repay_plan_id                                      -- 还款子期数
    ,t2.value_dt                                           -- 起息日期
    ,t2.int_set_dt                                         -- 应还款日期
    ,t2.grace_dt                                           -- 宽限还款日期
    ,''--t5.proc_day                                       -- 上次还款日期
    ,''--t5.next_proc_dt                                   -- 下次还款日期
    ,t2.final_modif_dt                                     -- 修改日期
    ,t2.amt_type_cd                                        -- 还款金额类型
    ,''                                                    -- 还款类型代码
    ,''                                                    -- 还款状态代码
    ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and t2.full_amt_callbk_flg = '0' then '1'
          else '0' end                                    -- 逾期标志
    ,case when t2.full_amt_callbk_flg = '1' then '1'
          else '0' end                                     -- 偿还标志
    ,case when nvl(replace(t2.grace_dt,date'0001-1-1',null),t2.doc_exp_dt) <= to_date('${batch_date}', 'yyyymmdd') and 
           (t2.stl_dt >t2.grace_dt   --最后结算日期大于宽限日
            or (t2.stl_dt = t2.grace_dt and t2.full_amt_callbk_flg='0') --最后结算日期等于宽限日,且单据全额回收标志为N
            or t2.doc_bal<>0  --单据余额不为0
           )  then '1' else '0' 
     end                                                   -- 期次历史逾期标志                           
    ,t1.curr_cd                                            -- 币种代码
    ,nvl(t2.iss_int_rat, 0)                                -- 执行利率
    ,nvl(t8.ld_ovdue_pric, 0) + nvl(t8.ld_nomal_pric, 0)   -- 本金余额
    ,decode(t2.amt_type_cd, 'PRI', nvl(t2.pric_amt, 0), 0)  -- 应计正常本金
    ,nvl(t2.plan_repay_amt, 0)                                    -- 本期应收金额
    ,t2.doc_bal                                                   -- 本期单据余额
    ,decode(t2.amt_type_cd, 'PRI', nvl(t2.plan_repay_amt, 0), 0)  -- 本期应收本金
    ,decode(t2.amt_type_cd, 'INT', nvl(t2.plan_repay_amt, 0), 0)  -- 本期应收利息
    ,decode(t2.amt_type_cd, 'INT', nvl(t2.plan_repay_amt, 0), 0)  -- 本期应收应计利息
    ,0                                                     -- 本期催收应计利息
    ,nvl(t4.ld_ovdue_pric, 0)                              -- 本期逾期本金
    ,nvl(t4.ld_ovdue_int, 0)                               -- 本期应收欠息
    ,0                                                     -- 本期催收欠息
    ,nvl(t4.ld_ovdue_pnlt, 0)                              -- 本期应收应计罚息
    ,0                                                     -- 本期催收应计罚息
    ,nvl(t4.ld_ovdue_pnlt, 0)                              -- 本期应收罚息
    ,0                                                     -- 本期催收罚息
    ,nvl(t4.ld_ovdue_comp_int, 0)                          -- 本期应计复息
    ,nvl(t4.ld_ovdue_comp_int, 0)                          -- 本期复息
    ,t1.job_cd	                                           -- 任务代码
	 ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iml_schema}.agt_loan_acct_info_h t1
 inner join ${iml_schema}.agt_loan_repay_plan_dtl_h t2 
    on t1.acct_id = t2.acct_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 inner join ${iml_schema}.prd_loan_prod_info_h t6
    on t1.prod_id = t6.prod_id
   and t6.crdt_prod_cate_cd in ('2','4')   -- 零售贷款,个人委托贷款
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'icmsf1'
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
 left join ${iml_schema}.agt_loan_acct_bal_h t8
   on t1.acct_id = t8.acct_id
  and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t8.job_cd = 'ncbsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'ncbsf1'
;
commit;


-- 第二组 信贷房抵贷还款计划
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_repay_plan_ex(
    etl_dt                           -- 数据日期
    ,lp_id                           -- 法人编号
    ,dubil_id                        -- 借据编号
    ,acct_id                         -- 账户编号
	  ,loan_num                        -- 贷款号
    ,cust_id                         -- 客户编号
    ,tot_perds                       -- 贷款期数
    ,repay_perds                     -- 还款期数
    ,repay_sub_perds                 -- 还款子期数
    ,value_dt                        -- 起息日期
    ,repaybl_dt                      -- 应还款日期
    ,grace_repay_dt                  -- 宽限还款日期
    ,last_repay_dt                   -- 上次还款日期
    ,next_repay_dt                   -- 下次还款日期
    ,modif_dt                        -- 修改日期
    ,repay_amt_type_cd               -- 还款金额类型
    ,repay_type_cd                   -- 还款类型代码
    ,repay_status_cd                 -- 还款状态代码
    ,ovdue_flg                       -- 逾期标志
    ,repay_flg                       -- 偿还标志
    ,pd_h_ovdue_flg                  -- 期次历史逾期标志
    ,curr_cd                         -- 币种代码
    ,exec_int_rat                    -- 执行利率
    ,pric_bal                        -- 本金余额
    ,acru_nomal_pric                 -- 应计正常本金
    ,curr_issue_recvbl_amt           -- 本期应收金额
    ,curr_doc_bal                    -- 本期单据余额
    ,curr_issue_recvbl_pric          -- 本期应收本金
    ,curr_issue_int_recvbl           -- 本期应收利息
    ,curr_issue_recvbl_acru_int      -- 本期应收应计利息
    ,curr_issue_coll_acru_int        -- 本期催收应计利息
    ,curr_issue_ovdue_pric           -- 本期逾期本金
    ,curr_issue_recvbl_over_int      -- 本期应收欠息
    ,curr_issue_coll_over_int        -- 本期催收欠息
    ,curr_issue_recvbl_acru_pnlt     -- 本期应收应计罚息
    ,curr_issue_coll_acru_pnlt       -- 本期催收应计罚息
    ,curr_issue_recvbl_pnlt          -- 本期应收罚息
    ,curr_issue_coll_pnlt            -- 本期催收罚息
    ,curr_issue_acru_comp_int        -- 本期应计复息
    ,curr_issue_comp_int             -- 本期复息
    ,job_cd	                         -- 任务代码
    ,etl_timestamp                   -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                   -- 数据日期
       ,'9999'                                               -- 法人编号
       ,t1.duebillserialno                                   -- 借据编号
       ,t1.duebillserialno                                   -- 账户编号
       ,''                                                   -- 贷款号
       ,t2.cust_id                                           -- 客户编号
       ,t2.loan_tot_perds                                    -- 贷款期数
       ,t1.dateno                                            -- 还款期数
       ,' '                                                   -- 还款子期数
       ,t1.startdate                                         -- 起息日期
       ,t1.enddate                                           -- 应还款日期
       ,t1.gracedate                                         -- 宽限还款日期
       ,''                                                   -- 上次还款日期
       ,''                                                   -- 下次还款日期
       ,''                                                   -- 修改日期
       ,''                                                   -- 还款金额类型代码
       ,''                                                   -- 还款类型代码
       ,''                                                   -- 还款状态代码
       ,case when to_date('${batch_date}', 'yyyymmdd') >t1.enddate and t1.executiondate <>to_date('00010101', 'yyyymmdd') then '1' else '0' end         -- 逾期标志
       ,case when t1.executiondate <>to_date('00010101', 'yyyymmdd') then '1' else '0' end                 -- 偿还标志
       ,case when t1.executiondate <>to_date('00010101', 'yyyymmdd') and  t1.executiondate> t1.enddate then '1'else '0' end                                             -- 期次历史逾期标志
       ,nvl(trim(t1.businesscurrency),'CNY')                 -- 币种代码
       ,t1.businessrate                                      -- 执行利率
       ,t1.unpaidsum                                         -- 本金余额
       ,t1.normalsum                                         -- 应计正常本金
       ,t1.periodsum+t1.periodinterestsum                    -- 本期应收金额
       ,t1.periodsum+t1.periodinterestsum                    -- 本期单据余额
       ,t1.periodsum                                         -- 本期应收本金
       ,t1.periodinterestsum                                 -- 本期应收利息
       ,t1.periodinterestsum                                 -- 本期应收应计利息
       ,0                                                    -- 本期催收应计利息
       ,case when to_date('${batch_date}', 'yyyymmdd') >t1.enddate and t1.executiondate <>to_date('00010101', 'yyyymmdd') then t1.unpaidsum else 0 end    -- 本期逾期本金
       ,t1.ysintamt                                          -- 本期应收欠息
       ,0                                                    -- 本期催收欠息
       ,t1.odpaccrued                                        -- 本期应收应计罚息
       ,0                                                    -- 本期催收应计罚息
       ,t1.odpoutstanding                                    -- 本期应收罚息
       ,0                                                    -- 本期催收罚息
       ,0                                                    -- 本期应计复息
       ,t1.compoundinterest                                  -- 本期复息
       ,'icmsf1'                                             -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')        -- 数据处理时间
  from ${iol_schema}.icms_repayment_plan_info t1
  inner join ${iml_schema}.agt_loan_dubil_info_h t2
    on t1.duebillserialno=t2.dubil_id
   and t2.job_cd = 'icmsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.prod_id ='201020100057'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_repay_plan exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_repay_plan_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_repay_plan_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_repay_plan',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);