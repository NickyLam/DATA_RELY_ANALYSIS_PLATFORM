/*
Purpose:    共性加工层-联合网贷还款计划：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融待等网络贷款的还款计划信息，数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220929 icl_cmm_unite_wl_repay_plan
CreateDate: 20190815
Logs:       20250220 谢宁   新增微业贷
            20250730 陈伟峰 新增乐分期
            20251222 陈伟峰 新增对公微业贷203050100002
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_repay_plan drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_repay_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_repay_plan_ex purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_repay_plan_01 purge;

-- 1.3 create table for exchage and add partition
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_repay_plan_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_repay_plan where 0=1;

-- 第一组（共二组）微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 总期数
       ,init_tot_perds              -- 原始总期数
       ,repay_perds                 -- 还款期数
       ,init_repay_perds            -- 原始还款期数
       ,repay_sub_perds             -- 还款子期数
       ,value_dt                    -- 起息日期
       ,init_value_dt               -- 原始起息日期
       ,repaybl_dt                  -- 应还款日期
       ,payoff_dt                   -- 结清日期
       ,pric_turn_ovdue_dt          -- 本金转逾期日期
       ,int_turn_ovdue_dt           -- 利息转逾期日期
       ,grace_dt                    -- 宽限日期
       ,inst_status_cd              -- 分期状态代码
       ,ovdue_flg                   -- 逾期标志
       ,repay_flg                   -- 偿还标志
       ,curr_cd                     -- 币种代码
       ,pric_ovdue_days             -- 本金逾期天数
       ,int_ovdue_days              -- 利息逾期天数
       ,curr_issue_recvbl_pric      -- 本期应收本金
       ,curr_issue_int_recvbl       -- 本期应收利息
       ,curr_issue_recvbl_pric_bal  -- 本期应收本金余额
       ,curr_issue_int_recvbl_bal   -- 本期应收利息余额
       ,curr_issue_ovdue_pric_pnlt  -- 本期逾期本金罚息
       ,curr_issue_ovdue_int_pnlt   -- 本期逾期利息罚息
       ,job_cd                      -- 任务代码
       ,etl_timestamp               -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')     -- 数据日期
       ,t1.lp_id                               -- 法人编号
       ,t1.DUBIL_ID                            -- 借据编号
       ,t1.CUST_ID                             -- 客户编号
       ,t1.PROD_ID                             -- 产品编号
       ,t2.LOAN_NUM                            -- 总期数
       ,t2.LOAN_NUM                            -- 原始总期数
       ,t1.PERDS                               -- 还款期数
       ,t1.PERDS                               -- 原始还款期数
       ,''                                     -- 还款子期数
       ,t1.VALUE_DT                            -- 起息日期
       ,t1.VALUE_DT                            -- 原始起息日期
       ,t1.EXP_DT                              -- 应还款日期
       ,t1.CURRT_PAYOFF_DT                     -- 结清日期
       ,t1.PRIC_TURN_OVDUE_DT                  -- 本金转逾期日期
       ,t1.INT_TURN_OVDUE_DT                   -- 利息转逾期日期
       ,t1.DEFER_DT                            -- 宽限日期
       ,case when t1.currt_aldy_payoff_flg in ('1') then 'CLEAR'
             when t1.pric_status_cd = '10' then 'OVD'
             when t1.currt_aldy_payoff_flg in ('2','0') then 'NORMAL'
        else '-' end                           --分期状态代码
       ,case when t1.pric_status_cd = '10' then '1' else '0' end   --逾期标志
       ,case when t1.pric_status_cd = '04' then '1' else '0' end   --偿还标志
       ,t3.curr_cd                             --币种代码
       ,t1.pric_ovdue_days                     --本金逾期天数
       ,t1.int_ovdue_days                      --利息逾期天数
       ,nvl(t1.currt_rpbl_pric,0)              --本期应收本金
       ,nvl(t1.currt_rpbl_tot_int,0)           --本期应收利息
       ,nvl(t1.currt_rpbl_pric, 0) - nvl(t1.currt_paid_pric, 0)   --本期应收本金余额
       ,nvl(t1.currt_rpbl_tot_int,0) - nvl(t1.currt_paid_int, 0)  --本期应收利息余额
       ,nvl(t1.rpbl_pric_pnlt,0)               --本期逾期本金罚息
       ,nvl(t1.rpbl_int_pnlt,0)                --本期逾期利息罚息
       ,t1.job_cd                              --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6') --数据处理时间
  from ${iml_schema}.AGT_WYD_REPAY_PLAN t1
 left join ${iml_schema}.AGT_WYD_DUBIL_ATTACH_INFO t2
   on t1.dubil_id = t2.dubil_id
  and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'icmsf1'
 left join ${iml_schema}.agt_wyd_dubil_h t3
   on t1.dubil_id = t3.dubil_id
  and t3.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t3.job_cd = 'icmsf1'
 where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and t1.PROD_ID in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;

-- 第二组（共二组）分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 总期数
       ,init_tot_perds              -- 原始总期数
       ,repay_perds                 -- 还款期数
       ,init_repay_perds            -- 原始还款期数
       ,repay_sub_perds             -- 还款子期数
       ,value_dt                    -- 起息日期
       ,init_value_dt               -- 原始起息日期
       ,repaybl_dt                  -- 应还款日期
       ,payoff_dt                   -- 结清日期
       ,pric_turn_ovdue_dt          -- 本金转逾期日期
       ,int_turn_ovdue_dt           -- 利息转逾期日期
       ,grace_dt                    -- 宽限日期
       ,inst_status_cd              -- 分期状态代码
       ,ovdue_flg                   -- 逾期标志
       ,repay_flg                   -- 偿还标志
       ,curr_cd                     -- 币种代码
       ,pric_ovdue_days             -- 本金逾期天数
       ,int_ovdue_days              -- 利息逾期天数
       ,curr_issue_recvbl_pric      -- 本期应收本金
       ,curr_issue_int_recvbl       -- 本期应收利息
       ,curr_issue_recvbl_pric_bal  -- 本期应收本金余额
       ,curr_issue_int_recvbl_bal   -- 本期应收利息余额
       ,curr_issue_ovdue_pric_pnlt  -- 本期逾期本金罚息
       ,curr_issue_ovdue_int_pnlt   -- 本期逾期利息罚息
       ,job_cd                      -- 任务代码
       ,etl_timestamp               -- 数据处理时间
)
select
        to_date('${batch_date}','yyyymmdd')        -- 数据日期
       ,t1.lp_id                                      -- 法人编号
       ,t1.dubil_id                                   --借据编号
       ,t1.cust_id                                    --客户编号
       ,t1.prod_id                                    --产品编号
       ,t1.tot_perds                                  --总期数
       ,t1.tot_perds                                  --原始总期数
       ,t1.curr_perds                                 --还款期数
       ,t1.curr_perds                                 --原始还款期数
       ,''                                           --子期数
       ,t1.value_dt                                  --起息日期
       ,t1.value_dt                                  --原始起息日期
       ,t1.repay_dt                                   --应还款日期
       ,t1.payoff_dt                                 --结清日期
       ,''                                           --本金转逾期日期
       ,''                                           --利息转逾期日期
       ,''                                           --宽限日期
       ,t1.pd_status_cd                             --分期状态代码
       ,''                                           --逾期标志
       ,''                                           --偿还标志
       ,t1.curr_cd                                    --币种代码
       ,0                                              --本金逾期天数
       ,0                                              --利息逾期天数
       ,t1.rpbl_pric                                  --本期应收本金
       ,t1.rpbl_int                                   --本期应收利息
       ,t1.pric_bal                                   --本期应收本金余额
       ,t1.int_bal                                    --本期应收利息余额
       ,0                                             --本期逾期本金罚息 
       ,0                                             --本期逾期利息罚息
       ,t1.job_cd                                     --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6') --数据处理时间
  from ${iml_schema}.agt_lx_repay_plan t1
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;



delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_repay_plan_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_icl_batch_jnl(
   etl_dt                                -- 数据日期
   ,tab_name                             -- 表名
     ,batch_status                       -- 跑批状态
     ,batch_tm                           -- 跑批时间
     ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_repay_plan_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_repay_plan exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_repay_plan_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_repay_plan_ex purge;
--drop table ${icl_schema}.tmp_cmm_unite_wl_repay_plan_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_repay_plan',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
