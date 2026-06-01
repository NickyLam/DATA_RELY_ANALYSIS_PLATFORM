/*
Purpose:    共性加工层-联合网贷还款计划：包括所有的花呗、借呗、网商贷、微粒贷、借呗三期、京东金融待等网络贷款的还款计划信息，数据来源于综合信贷管理系统(ICMS)和中台系统(MPCS)。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220929 icl_cmm_unite_wl_repay_plan
CreateDate: 20190815
Logs:       20200110 翟若平 增加京东贷还款计划信息
            20200515 周沁晖 调整京东金融组字段[产品编号、还款子期数]的取数逻辑
                            调整网商贷组字段【产品编号】的取数逻辑
            20201015 谢  宁 中台微粒M层AGT_WLD_REPAY_PLAN --》AGT_WLD_REPAY_PLAN_H 快照改拉链算法
            20210107 陈伟峰 调整京东贷，去掉到期日限制条件
            20211011 陈伟峰 调整agt_wld_repay_plan，增加his表加工
            20220513 李森辉 1、取数数据源调整，调整花呗、借呗、京东贷、网商贷的取数源，由旧零售信贷系统调整为综合信贷管理系统。微粒贷取数源保持不变。
                            2、调整第五组借呗三期字段【产品编号】的加工口径。
            20230105 陈伟峰 调整【产品编号】加工逻辑
            20230511 陈伟峰 新增第七组-综合信贷微粒贷数据
            20230914 陈伟峰 调整【贷款期数、还款期数、起息日期】加工逻辑
            20230922 陈伟峰 新增【原始贷款期数、原始还款期数、原始起息日期】字段，网商贷的债券直转部分取原始相关字段，其他产品的加工逻辑与原来保持一致
            20230925 徐子豪 新增中台微粒贷、综合信贷微粒贷组别过滤结清数据。花呗、借呗、网商贷、借呗三期 组别过滤结清数据条件优化。
            20230922 陈伟峰 调整中台微粒贷和信贷微粒贷的加工逻辑，去掉repay_plan_oper_act_cd <> 'L'条件，该条件会导致借据中结清的期次被过滤掉。
            20240103 陈伟峰 新增字段【宽限日期】
            20250122 谢宁   新增字节小微贷
			20250220 谢宁   新增微业贷
			20250720 谢宁   新增唯品合作贷
            20250730 陈伟峰 新增乐分期
            20260112 陈伟峰 新增富民联合网贷
            20260114 陈伟峰 调整agt_wyd_dubil_attach_info的担保方式取值逻辑，改为直取guar_way_cd
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

-- 1.5 insert data to temp table
/*create table ${icl_schema}.tmp_cmm_unite_wl_repay_plan_01
as select
    agt_id
    ,lp_id
    ,intnal_dubil_id
    ,repay_plan_id
    ,acct_id
    ,acct_type_cd
    ,card_no
    ,loan_tot_perds
    ,curr_perds
    ,loan_pric
    ,rpbl_pric
    ,rpbl_fee_amt
    ,rpbl_int
    ,repaid_pric
    ,repaid_int
    ,repaid_pnlt
    ,repaid_comp_int
    ,repaid_fee
    ,reach_money_exp_repay_dt
    ,grace_dt
    ,modif_tm
    ,value_dt
    ,batch_doc_name
    ,ser_num
    ,repay_plan_oper_act_cd
    ,job_cd
from ${iml_schema}.agt_wld_repay_plan
where create_dt <= to_date('${batch_date}','yyyymmdd')
and id_mark<>'D'
and job_cd ='mpcsf1'
union all
select
    agt_id
    ,lp_id
    ,intnal_dubil_id
    ,repay_plan_id
    ,acct_id
    ,acct_type_cd
    ,card_no
    ,loan_tot_perds
    ,curr_perds
    ,loan_pric
    ,rpbl_pric
    ,rpbl_fee_amt
    ,rpbl_int
    ,repaid_pric
    ,repaid_int
    ,repaid_pnlt
    ,repaid_comp_int
    ,repaid_fee
    ,reach_money_exp_repay_dt
    ,grace_dt
    ,modif_tm
    ,value_dt
    ,batch_doc_name
    ,ser_num
    ,repay_plan_oper_act_cd
    ,job_cd
from ${iml_schema}.agt_wld_repay_plan_his
where id_mark<>'D'
and job_cd ='mpcsi1'
;
*/

-- 第一组（共十二组）花呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
select to_date('${batch_date}','yyyymmdd')                              -- 数据日期
       ,t1.lp_id                                                        -- 法人编号
       ,t1.dubil_id                                                     -- 借据编号
       ,t2.cust_id                                                      -- 客户编号
       ,t2.prod_id                                                      -- 产品编号
       ,t2.loan_cont_tenor                                              -- 贷款期数
       ,t2.loan_cont_tenor                                              -- 原始贷款期数
       ,t1.pd_num                                                       -- 还款期数
       ,t1.pd_num                                                       -- 原始还款期数
       ,1000                                                            -- 还款子期数
       ,t1.inst_start_dt                                                -- 起息日期
       ,t1.inst_start_dt                                                -- 原始起息日期
       ,t1.inst_end_dt                                                  -- 应还款日期
       ,t1.payoff_dt                                                    -- 结清日期
       ,t1.pric_turn_ovdue_dt                                           -- 本金转逾期日期
       ,t1.int_turn_ovdue_dt                                            -- 利息转逾期日期
       ,''                                                              -- 宽限日期
       ,t1.inst_status_cd                                               -- 分期状态代码
       ,decode(t1.inst_status_cd, 'OVD', '1', '0')                      -- 逾期标志
       ,decode(t1.inst_status_cd, 'CLEAR', '1', '0')                    -- 偿还标志
       ,t2.curr_cd                                                      -- 币种代码
       ,t1.pric_ovdue_days                                              -- 本金逾期天数
       ,t1.int_ovdue_days                                               -- 利息逾期天数
       ,t1.rpbl_pric                                                    -- 本期应收本金
       ,t1.rpbl_int                                                     -- 本期应收利息
       ,t1.nomal_pric_bal                                               -- 本期应收本金余额
       ,t1.int_bal                                                      -- 本期应收利息余额
       ,t1.rpbl_ovdue_pric_pnlt                                         -- 本期逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                                          -- 本期逾期利息罚息
       ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_acp_repay_plan_h t1
 inner join ${iml_schema}.agt_acp_dubil  t2  --结清数据调整存放在myhbf2分区
    on t1.dubil_id = t2.dubil_id
   and t2.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd in ('myhbf1','myhbf2')
   and t2.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myhbf1'
;
commit;


-- 第二组（共十二组）借呗
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds                   -- 原始贷款期数
       ,repay_perds                 -- 还款期数
       ,init_repay_perds                 -- 原始还款期数
       ,repay_sub_perds             -- 还款子期数
       ,value_dt                    -- 起息日期
       ,init_value_dt                    -- 原始起息日期
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
select to_date('${batch_date}','yyyymmdd')                  --数据日期
       ,t1.lp_id                                            --法人编号
       ,t1.dubil_id                                         --借据编号
       ,t2.cust_id                                          --客户编号
       ,t2.prod_id                                          --产品编号
       ,t2.loan_cont_tenor                                  --贷款期数
       ,t2.loan_cont_tenor                                  --原始贷款期数
       ,t1.pd_num                                           --还款期数
       ,t1.pd_num                                           --原始还款期数
       ,1000                                                --还款子期数
       ,t1.inst_start_dt                                    --起息日期
       ,t1.inst_start_dt                                    --原始起息日期
       ,t1.inst_end_dt                                      --应还款日期
       ,t1.payoff_dt                                        --结清日期
       ,t1.pric_turn_ovdue_dt                               --本金转逾期日期
       ,t1.int_turn_ovdue_dt                                --利息转逾期日期
       ,''                                                  -- 宽限日期
       ,t1.inst_status_cd                                   --分期状态代码
       ,decode(t1.inst_status_cd, 'OVD', '1', '0')          --逾期标志
       ,decode(t1.inst_status_cd, 'CLEAR', '1', '0')        --偿还标志
       ,t2.curr_cd                                          --币种代码
       ,t1.pric_ovdue_days                                  --本金逾期天数
       ,t1.int_ovdue_days                                   --利息逾期天数
       ,t1.pric_bal                                         --本期应收本金
       ,t1.rpbl_int                                         --本期应收利息
       ,t1.rpbl_pric                                        --本期应收本金余额
       ,t1.int_bal                                          --本期应收利息余额
       ,t1.rpbl_ovdue_pric_pnlt                             --本期逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                              --本期逾期利息罚息
       ,t1.job_cd                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_ajb_repay_plan_h t1
 inner join ${iml_schema}.agt_ajb_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'myjbf2'
   -- and (trim(t2.payoff_dt) >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or t2.payoff_dt = ${iml_schema}.dateformat_min(''))
   and t2.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
   and t2.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbf2'
;
commit;

-- 第三组（共十二组）网商贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
select to_date('${batch_date}','yyyymmdd')                  --数据日期
       ,t1.lp_id                                            --法人编号
       ,t1.dubil_id                                         --借据编号
       ,t2.cust_id                                          --客户编号
       ,t2.prod_id                                          --产品编号
       ,case when t2.cred_rht_turn_flg ='1' then t2.hxb_loan_tot_perds else t2.loan_cont_tenor end     --贷款期数
       ,t2.loan_cont_tenor                                  --原始贷款期数
       ,case when t2.cred_rht_turn_flg ='1' then t1.hxb_pd_id else t1.pd_num end                       --还款期数
       ,t1.pd_num                                           --原始还款期数
       ,1000                                                --还款子期数
       ,case when t2.cred_rht_turn_flg ='1' then t1.hxb_loan_begin_dt else t1.inst_start_dt end        --起息日期
       ,t1.inst_start_dt                                    --原始起息日期
       ,t1.inst_end_dt                                      --应还款日期
       ,t1.payoff_dt                                        --结清日期
       ,t1.pric_turn_ovdue_dt                               --本金转逾期日期
       ,t1.int_turn_ovdue_dt                                --利息转逾期日期
       ,''                                                  -- 宽限日期
       ,t1.inst_status_cd                                   --分期状态代码
       ,decode(t1.inst_status_cd, 'OVD', '1', '0')          --逾期标志
       ,decode(t1.inst_status_cd, 'CLEAR', '1', '0')        --偿还标志
       ,t2.curr_cd                                          --币种代码
       ,t1.pric_ovdue_days                                  --本金逾期天数
       ,t1.int_ovdue_days                                   --利息逾期天数
       ,t1.rpbl_pric                                        --本期应收本金
       ,t1.rpbl_int                                         --本期应收利息
       ,t1.pric_bal                                         --本期应收本金余额
       ,t1.int_bal                                          --本期应收利息余额
       ,t1.rpbl_ovdue_pric_pnlt                             --本期逾期本金罚息
       ,t1.rpbl_ovdue_int_pnlt                              --本期逾期利息罚息
       ,t1.job_cd                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_myloan_repay_plan_h t1
 inner join ${iml_schema}.agt_myloan_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'mybkf1'
 --  and (trim(t2.payoff_dt) >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or t2.payoff_dt = ${iml_schema}.dateformat_min(''))
  and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_imp_dt_h t18
   on t18.agt_id = t2.agt_id
   and t18.dt_type_cd = '03'
   and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t18.job_cd = 'mybkf1'
 where t18.imp_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'mybkf1'
;
commit;

-- 第四组（共十二组）微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
select to_date('${batch_date}','yyyymmdd')                                                                           --数据日期
       ,t1.lp_id                                                                                                     --法人编号
       ,t2.dubil_id                                                                                                  --借据编号
       ,t3.cust_id                                                                                                   --客户编号
       ,t5.prod_id                                                                                                   --产品编号
       ,t1.loan_tot_perds                                                                                            --贷款期数
       ,t1.loan_tot_perds                                                                                            --原始贷款期数
       ,t1.curr_perds                                                                                                --还款期数
       ,t1.curr_perds                                                                                                --原始还款期数
       ,1000                                                                                                         --还款子期数
       ,t1.value_dt                                                                                                  --起息日期
       ,t1.value_dt                                                                                                  --原始起息日期
       ,t1.reach_money_exp_repay_dt                                                                                  --应还款日期
       ,(case when t1.curr_perds >= nvl(t4.CURR_PERDS, 0)
               then t4.modif_tm
              when nvl(t1.rpbl_pric, 0) = nvl(t1.repaid_pric, 0)
                   and nvl(t1.rpbl_int, 0) = nvl(t1.repaid_int, 0)
              then t1.modif_tm else ${iml_schema}.dateformat_max('') end)                                            --结清日期
       ,t1.reach_money_exp_repay_dt                                                                                  --本金转逾期日期
       ,t1.reach_money_exp_repay_dt                                                                                  --利息转逾期日期
       ,t1.grace_dt                                                                                                  -- 宽限日期
       ,(case when t4.intnal_dubil_id is not null then 'CLEAR'
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                   and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then 'OVD'
              else 'NORMAL' end)                                                                                     --分期状态代码
       ,(case when t4.intnal_dubil_id is not null then '0'
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                   and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then '1'
              else '0' end)                                                                                          --逾期标志
       ,(case when t4.intnal_dubil_id is not null then '1'
              when (nvl(t1.rpbl_pric, 0) = nvl(t1.repaid_pric, 0)
                   and nvl(t1.rpbl_int, 0) = nvl(t1.repaid_int, 0))  then '1'
              else '0' end)                                                                                          --偿还标志
       ,'CNY'                                                                                                        --币种代码
       ,(case when t4.intnal_dubil_id is not null then 0
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                  and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then to_date('${batch_date}','yyyymmdd') - t1.grace_dt + 1
              else 0 end)                                                                                            --本金逾期天数
       ,(case when t4.intnal_dubil_id is not null then 0
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                  and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then to_date('${batch_date}','yyyymmdd') - t1.grace_dt + 1
              else 0 end)                                                                                            --利息逾期天数
       ,t1.rpbl_pric                                                                                                 --本期应收本金
       ,t1.rpbl_int                                                                                                  --本期应收利息
       ,case when t4.intnal_dubil_id is not null then 0 else nvl(t1.rpbl_pric, 0) - nvl(t1.repaid_pric, 0) end       --本期应收本金余额
       ,case when t4.intnal_dubil_id is not null then 0
             when t1.grace_dt <= to_date('${batch_date}','yyyymmdd') then nvl(t1.rpbl_pric, 0) - nvl(t1.repaid_pric, 0)
             else 0 end                                                                                              --本期应收利息余额
       ,t1.repaid_pnlt                                                                                               --本期逾期本金罚息
       ,0                                                                                                            --本期逾期利息罚息
       ,t1.job_cd                                                                                                    --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6')                                              --数据处理时间
  from ${iml_schema}.agt_wld_repay_plan t1
 inner join ${iml_schema}.agt_wld_dubil_info t2
    on t1.intnal_dubil_id = t2.intnal_dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'mpcsf1'
   and t2.id_mark <>'D'
  left join ${iml_schema}.agt_imp_dt_h t18
  	on t2.agt_id = t18.agt_id
   and t18.dt_type_cd = '03'
   and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t18.job_cd = 'mpcsf1'
  left join ${iml_schema}.agt_wld_acct t3
    on t2.acct_id = t3.acct_id
   and t2.acct_type_cd = t3.acct_type_cd
   and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'mpcsf1'
   and t3.id_mark <>'D'
  left join ${iml_schema}.agt_wld_repay_plan t4
    on t1.intnal_dubil_id = t4.intnal_dubil_id
   and t4.repay_plan_oper_act_cd = 'L'
   and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.id_mark<>'D'
   and t4.job_cd ='mpcsf1'
  left join ${iml_schema}.agt_prod_rela_h t5
    on t2.intnal_dubil_id = substr(t5.agt_id,7)
   and t5.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t5.end_dt >=to_date('${batch_date}','yyyymmdd')
   and t5.job_cd ='mpcsf1'
   and t5.agt_prod_rela_type_cd = '02'
 where t18.imp_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
--   and t1.repay_plan_oper_act_cd <> 'L'
   and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.id_mark<>'D'
   and t1.job_cd ='mpcsf1'
;
commit;

-- 第五组（共十二组）借呗三期
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
       ,repay_perds                 -- 还款期数
       ,init_repay_perds            -- 原始还款期数
       ,repay_sub_perds             -- 还款子期数
       ,init_value_dt               -- 起息日期
       ,value_dt                    -- 原始起息日期
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
select to_date('${batch_date}','yyyymmdd')                  --数据日期
       ,t1.lp_id                                            --法人编号
       ,t1.dubil_id                                         --借据编号
       ,t2.cust_id                                          --客户编号
       ,t2.prod_id                                          --产品编号
       ,t2.loan_cont_tenor                                  --贷款期数
       ,t2.loan_cont_tenor                                  --原始贷款期数
       ,t1.pd_num                                           --还款期数
       ,t1.pd_num                                           --原始还款期数
       ,1000                                                --还款子期数
       ,t1.inst_start_dt                                    --起息日期
       ,t1.inst_start_dt                                    --原始起息日期
       ,t1.inst_end_dt                                      --应还款日期
       ,t1.payoff_dt                                        --结清日期
       ,t1.pric_turn_ovdue_dt                               --本金转逾期日期
       ,t1.int_turn_ovdue_dt                                --利息转逾期日期
       ,''                                                  -- 宽限日期
       ,t1.inst_status_cd                                   --分期状态代码
       ,decode(t1.inst_status_cd, 'OVD', '1', '0')          --逾期标志
       ,decode(t1.inst_status_cd, 'CLEAR', '1', '0')        --偿还标志
       ,t2.curr_cd                                          --币种代码
       ,t1.pric_ovdue_days                                  --本金逾期天数
       ,t1.int_ovdue_days                                   --利息逾期天数
       ,t1.pric_amt                                         --本期应收本金
       ,t1.pric_bal                                         --本期应收利息
       ,t1.pric_bal                                         --本期应收本金余额
       ,t1.int_bal                                          --本期应收利息余额
       ,t1.ovdue_pric_pnlt_bal                              --本期逾期本金罚息
       ,t1.ovdue_int_pnlt_bal                               --本期逾期利息罚息
       ,t1.job_cd                                           --任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_ajb_ped_3_repay_plan_h t1
 inner join ${iml_schema}.agt_ajb_ped_3_dubil t2
    on t1.dubil_id = t2.dubil_id
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'myjbf3'
   and t2.id_mark <>'D'
   --and (trim(t2.payoff_dt) >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or t2.payoff_dt = ${iml_schema}.dateformat_min(''))
left join ${iml_schema}.agt_imp_dt_h t18
    on t18.agt_id = t2.agt_id
   and t18.dt_type_cd = '03'
   and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t18.job_cd = 'myjbf3'
 where t18.imp_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'myjbf3'
;
commit;

-- 第六组（共十二组）京东贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
select to_date('${batch_date}','yyyymmdd')                                --数据日期
       ,t1.lp_id                                                          --法人编号
       ,t1.dubil_id                                                       --借据编号
       ,t2.cust_id                                                        --客户编号
       ,t2.prod_id                                                        --产品编号
       ,t1.repay_tot_perds                                                --贷款期数
       ,t1.repay_tot_perds                                                --原始贷款期数
       ,t1.repay_perds                                                    --还款期数
       ,t1.repay_perds                                                    --原始还款期数
       ,1000                                                              --还款子期数
       ,t2.distr_dt                                                       --起息日期
       ,t2.distr_dt                                                       --原始起息日期
       ,nvl(t1.pric_exp_dt, t1.int_exp_dt)                                --应还款日期
       ,t2.bus_exp_dt                                                     --结清日期
       ,t1.pric_exp_dt                                                    --本金转逾期日期
       ,t1.int_exp_dt                                                     --利息转逾期日期
       ,''                                                                -- 宽限日期
       ,(case when nvl(t1.rpbl_pric_bal, 0) = 0 then 'CLEAR'
              when t1.curr_ovdue_status_cd = '1' then 'OVD'
              else 'NORMAL' end)                                          --分期状态代码
       ,t1.curr_ovdue_status_cd                                           --逾期标志
       ,(case when nvl(t1.rpbl_pric_bal, 0) = 0 then '1' else '0' end)    --偿还标志
       ,t2.curr_cd                                                        --币种代码
       ,to_date('${batch_date}', 'yyyymmdd') - t1.pric_exp_dt + 1         --本金逾期天数
       ,to_date('${batch_date}', 'yyyymmdd') - t1.int_exp_dt + 1          --利息逾期天数
       ,t1.rpbl_pric_bal                                                  --本期应收本金
       ,t1.rpbl_int_bal                                                   --本期应收利息
       ,t1.rpbl_pric_bal                                                  --本期应收本金余额
       ,t1.rpbl_int_bal                                                   --本期应收利息余额
       ,t1.rpbl_pnlt_bal                                                  --本期逾期本金罚息
       ,0                                                                 --本期逾期利息罚息
       ,t1.job_cd                                                         --任务代码
         ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iml_schema}.agt_jd_repay_plan_h t1
 inner join ${iml_schema}.agt_jd_loan_dubil_info t2
      on t1.dubil_id = t2.dubil_id
     and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
     and t2.job_cd = 'jdjrf1'
     and t2.id_mark <> 'D'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'jdjri1'
;
commit;


-- 第七组（共十二组）微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
select to_date('${batch_date}','yyyymmdd')                                                                           --数据日期
       ,t1.lp_id                                                                                                     --法人编号
       ,t2.dubil_id                                                                                                  --借据编号
       ,t2.cust_id                                                                                                   --客户编号
       ,t2.prod_id                                                                                                   --产品编号
       ,t1.loan_tot_perds                                                                                            --贷款期数
       ,t1.loan_tot_perds                                                                                            --原始贷款期数
       ,t1.curr_perds                                                                                                --还款期数
       ,t1.curr_perds                                                                                                --原始还款期数
       ,1000                                                                                                         --还款子期数
       ,t1.value_dt                                                                                                  --起息日期
       ,t1.value_dt                                                                                                  --原始起息日期
       ,t1.reach_money_exp_repay_dt                                                                                  --应还款日期
       ,(case when t1.curr_perds >= nvl(t4.curr_perds, 0) then t4.modif_tm
              when nvl(t1.rpbl_pric, 0) = nvl(t1.repaid_pric, 0) and nvl(t1.rpbl_int, 0) = nvl(t1.repaid_int, 0)
              then t1.modif_tm else ${iml_schema}.dateformat_max('') end)                                            --结清日期
       ,t1.reach_money_exp_repay_dt                                                                                  --本金转逾期日期
       ,t1.reach_money_exp_repay_dt                                                                                  --利息转逾期日期
       ,t1.grace_dt                                                                                                  -- 宽限日期
       ,(case when t4.intnal_dubil_id is not null then 'CLEAR'
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                   and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then 'OVD'
              else 'NORMAL' end)                                                                                     --分期状态代码
       ,(case when t4.intnal_dubil_id is not null then '0'
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                   and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then '1'
              else '0' end)                                                                                          --逾期标志
       ,(case when t4.intnal_dubil_id is not null then '1'
              when (nvl(t1.rpbl_pric, 0) = nvl(t1.repaid_pric, 0)
                   and nvl(t1.rpbl_int, 0) = nvl(t1.repaid_int, 0))  then '1'
              else '0' end)                                                                                          --偿还标志
       ,'CNY'                                                                                                        --币种代码
       ,(case when t4.intnal_dubil_id is not null then 0
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                  and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then to_date('${batch_date}','yyyymmdd') - t1.grace_dt + 1
              else 0 end)                                                                                            --本金逾期天数
       ,(case when t4.intnal_dubil_id is not null then 0
              when (nvl(t1.rpbl_pric, 0) <> nvl(t1.repaid_pric, 0) or nvl(t1.rpbl_int, 0) <> nvl(t1.repaid_int, 0))
                  and t1.grace_dt < to_date('${batch_date}','yyyymmdd') then to_date('${batch_date}','yyyymmdd') - t1.grace_dt + 1
              else 0 end)                                                                                            --利息逾期天数
       ,t1.rpbl_pric                                                                                                 --本期应收本金
       ,t1.rpbl_int                                                                                                  --本期应收利息
       ,case when t4.intnal_dubil_id is not null then 0 else nvl(t1.rpbl_pric, 0) - nvl(t1.repaid_pric, 0) end       --本期应收本金余额
       ,case when t4.intnal_dubil_id is not null then 0
             when t1.grace_dt <= to_date('${batch_date}','yyyymmdd') then nvl(t1.rpbl_pric, 0) - nvl(t1.repaid_pric, 0)
             else 0 end                                                                                              --本期应收利息余额
       ,t1.repaid_pnlt                                                                                               --本期逾期本金罚息
       ,0                                                                                                            --本期逾期利息罚息
       ,t1.job_cd                                                                                                    --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6')                                              --数据处理时间
  from ${iml_schema}.agt_wld_repay_plan_h t1
 inner join ${iml_schema}.agt_wld_dubil_info_h t2
    on t1.intnal_dubil_id = t2.intnal_dubil_id
   and t2.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t2.end_dt >to_date('${batch_date}','yyyymmdd')
   and t2.job_cd ='icmsf1'
   and (t2.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy') or t2.payoff_dt = ${iml_schema}.dateformat_min(''))
  left join ${iml_schema}.agt_wld_repay_plan_h t4
    on t1.intnal_dubil_id = t4.intnal_dubil_id
   and t4.repay_plan_oper_act_cd = 'L'
   and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t4.end_dt >to_date('${batch_date}','yyyymmdd')
   and t4.job_cd ='icmsf1'
 where /*t1.repay_plan_oper_act_cd <> 'L'
   and */t1.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t1.end_dt >to_date('${batch_date}','yyyymmdd')
   and t1.job_cd ='icmsf1'
;
commit;


-- 第八组（共十二组）字节小微贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
       ,t1.intnal_dubil_id                     -- 借据编号
       ,t2.cust_id                             -- 客户编号
       ,t2.prod_id                             -- 产品编号
       ,t2.tenor                               -- 贷款期数
       ,t2.tenor                               -- 原始贷款期数
       ,t1.tenor                               -- 还款期数
       ,t1.tenor                               -- 原始还款期数
       ,''                                     -- 还款子期数
       ,t1.begin_dt                            -- 起息日期
       ,t1.begin_dt                            -- 原始起息日期
       ,t1.exp_dt                              -- 应还款日期
       ,t1.payoff_dt                           -- 结清日期
       ,case when t1.ovdue_days > 0 then to_date('${batch_date}','yyyymmdd') - t1.ovdue_days
        else null end -- 本金转逾期日期
       ,null                                   -- 利息转逾期日期
       ,null                                   -- 宽限日期
       ,case when t1.curr_issue_status_cd in ('05','06') then 'CLEAR'
             when t1.curr_issue_status_cd = '02' then 'OVD'
             when t1.curr_issue_status_cd = '01' then 'NORMAL'
        else '-' end                           --分期状态代码
       ,case when t1.curr_issue_status_cd = '02' then '1' else '0' end   --逾期标志
       ,case when t1.curr_issue_status_cd = '05' then '1'
             when (nvl(t1.rpbl_pric, 0) = nvl(t1.paid_pric, 0)
              and nvl(t1.rpbl_int, 0) = nvl(t1.paid_int, 0)) then '1'
        else '0' end                                        --偿还标志
       ,t1.curr_cd                                          --币种代码
       ,t1.ovdue_days                                       --本金逾期天数
       ,t1.ovdue_days                                       --利息逾期天数
       ,nvl(t1.rpbl_pric,0)                                 --本期应收本金
       ,nvl(t1.rpbl_int,0)                                  --本期应收利息
       ,nvl(t1.rpbl_pric, 0) - nvl(t1.paid_pric, 0)         --本期应收本金余额
       ,nvl(t1.int_bal,0)                                   --本期应收利息余额
       ,nvl(t1.rpbl_pnlt,0)                                 --本期逾期本金罚息
       ,0                                                   --本期逾期利息罚息
       ,t1.job_cd                                           --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6') --数据处理时间
  from ${iml_schema}.agt_zjdk_repay_plan t1
 left join ${iml_schema}.agt_zjdk_dubil_info_h t2
   on t1.intnal_dubil_id = t2.intnal_dubil_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 第九组（共十二组）微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
       ,t2.LOAN_NUM                            -- 贷款期数
       ,t2.LOAN_NUM                            -- 原始贷款期数
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
;
commit;

-- 第十组（共十二组）唯品合作贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
       ,t1.dubil_id                            -- 借据编号
       ,t2.cust_id                             -- 客户编号
       ,t1.prod_id                             -- 产品编号
       ,t2.mon_tenor                           -- 贷款期数
       ,t2.mon_tenor                           -- 原始贷款期数
       ,t1.currt_perds                         -- 还款期数
       ,t1.currt_perds                         -- 原始还款期数
       ,''                                     -- 还款子期数
       ,t1.begin_dt                            -- 起息日期
       ,t1.begin_dt                            -- 原始起息日期
       ,t1.exp_dt                              -- 应还款日期
       ,t1.payoff_dt                           -- 结清日期
       ,to_date('${batch_date}', 'yyyymmdd') - t1.ovdue_days -- 本金转逾期日期
       ,to_date('${batch_date}', 'yyyymmdd') - t1.ovdue_days -- 利息转逾期日期
       ,t1.grace_dt_term                            -- 宽限日期
       ,case when t1.pd_status_cd = 'JIQ' then 'CLEAR'
             when t1.pd_status_cd = 'YUQ' then 'OVD'
             when t1.pd_status_cd = 'ZHC' then 'NORMAL'
        else '-' end                           --分期状态代码
       ,case when t1.pd_status_cd = 'YUQ' then '1' else '0' end   --逾期标志
       ,case when t1.pd_status_cd = 'JIQ' then '1' else '0' end   --偿还标志
       ,t1.curr_cd                             --币种代码
       ,t1.ovdue_days                          --本金逾期天数
       ,t1.ovdue_days                          --利息逾期天数
       ,nvl(t1.rpbl_pric,0)                    --本期应收本金
       ,nvl(t1.rpbl_int,0)                     --本期应收利息
       ,case when t1.pd_status_cd = 'WRN' then 0 else nvl(t1.rpbl_pric,0) - nvl(t1.paid_pric,0) end --本期应收本金余额
       ,case when t1.pd_status_cd = 'WRN' then 0 else nvl(t1.rpbl_int,0) -  nvl(t1.paid_int, 0) end --本期应收利息余额
       ,nvl(t1.rpbl_pnlt,0)                     --本期逾期本金罚息
       ,nvl(t1.rpbl_comp_int,0)                --本期逾期利息罚息
       ,t1.job_cd                              --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6') --数据处理时间
  from ${iml_schema}.agt_wph_repay_plan t1
 left join ${iml_schema}.agt_wph_dubil_info_h t2
   on t1.dubil_id = t2.dubil_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 第十一组（共十二组）分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
       ,t1.tot_perds                                  --贷款期数
       ,t1.tot_perds                                  --原始贷款期数
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

-- 第十二组（共十二组）富民联合贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_repay_plan_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,dubil_id                    -- 借据编号
       ,cust_id                     -- 客户编号
       ,prod_id                     -- 产品编号
       ,tot_perds                   -- 贷款期数
       ,init_tot_perds              -- 原始贷款期数
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
        to_date('${batch_date}','yyyymmdd')                                     --数据日期
       ,t1.lp_id                                                                   --法人编号
       ,t2.dubil_id                                                                --借据编号
       ,t2.cust_id                                                                 --客户编号
       ,t2.prod_id                                                                 --产品编号
       ,t2.loan_perds                                                              --贷款期数
       ,t2.loan_perds                                                              --原始贷款期数
       ,t1.curr_perds                                                              --还款期数
       ,t1.curr_perds                                                              --原始还款期数
       ,0                                                                          --子期数
       ,t1.begin_dt                                                                --起息日期
       ,t1.begin_dt                                                                --原始起息日期
       ,t1.exp_dt                                                                  --应还款日期
       ,t1.payoff_dt                                                               --结清日期
       ,t1.pric_turn_ovdue_dt                                                      --本金转逾期日期
       ,t1.int_turn_ovdue_dt                                                       --利息转逾期日期
       ,''                                                                         --宽限日期
       ,decode(t1.currt_status_cd,'A','NORMAL','C','CLEAR','P','OVD','-')       --分期状态代码
       ,decode(t1.currt_status_cd,'P','1','0')                                  --逾期标志
       ,decode(t1.currt_status_cd,'C','1','0')                                  --偿还标志
       ,t1.curr_cd                                                                 --币种代码
       ,t1.pric_ovdue_days                                                         --本金逾期天数
       ,t1.int_ovdue_days                                                          --利息逾期天数
       ,t1.pric_bal                                                                --本期应收本金
       ,t1.int_recvbl                                                              --本期应收利息
       ,t1.rpbl_pric                                                               --本期应收本金余额
       ,t1.int_bal                                                                 --本期应收利息余额
       ,t1.recvbl_pnlt                                                             --本期逾期本金罚息
       ,t1.recvbl_comp_int                                                         --本期逾期利息罚息
       ,'icms_lh'                                                                  --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:ss:mi.ff6')            --数据处理时间
  from ${iml_schema}.agt_lhwd_repay_plan t1
 inner join ${iml_schema}.agt_lhwd_dubil_info_h t2
    on t1.dubil_id=t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsi1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_repay_plan';
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
   ,'cmm_unite_wl_repay_plan'
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
