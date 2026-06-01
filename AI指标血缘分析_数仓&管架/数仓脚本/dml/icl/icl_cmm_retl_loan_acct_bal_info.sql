/*
Purpose:    共性加工层-零售贷款余额信息表：包括所有的零售贷款余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_acct_bal_info
CreateDate: 20220329
Logs:       20220608 李森辉 新增字段【贷款号】
            20220618 陈伟峰 调整字段【表内利息、表外利息、本金余额、当期余额、折本币当期余额、余额积数相关字段】的加工口径
                            置空字段【呆滞本金-IDLE_PRIC、呆账本金-BAD_DEBT_PRIC】
			      20220725 温旺清 调整字段【应计非应计代码】的加工口径
			      20221018 温旺清 调整字段【核销本金、核销利息、表内利息、表外利息、本金余额、当期余额、折本币当期余额及相关积数字段】的加工口径
            20230206 陈伟峰 调整基数字段加工逻辑，加入投产日关联字段判断逻辑
            20230214 陈伟峰 调整核算状态取值逻辑，优先取核算中台的核算状态
            20230609 陈伟峰 过滤开户日期大于跑批日期的数据
            20231225 饶雅 调整部分基数字段加工逻辑
            20250106 陈伟峰 新增【网商贷-房抵贷】产品数据
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_acct_bal_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_acct_bal_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_bal_info_01 purge;

-- 1.3 insert data to tmp table
-- 获取账户结算信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_bal_info_01
nologging
compress ${option_switch} for query high
as
select  t1.lp_id                                                  -- 法人编号
       ,t1.acct_id                                                -- 账户编号
       ,t1.dubil_id                                               -- 借据号
       ,t1.loan_num                                               -- 贷款号
       ,t1.prod_id                                                -- 标准产品编号
       ,t1.curr_cd                                                -- 币种代码
	     ,t1.distr_flow_num                                         -- 放款流水号
       ,case when nvl(trim(t10.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then '0'
             when nvl(trim(t10.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY') then '1'
             when nvl(trim(t10.init_loan_num),t1.accti_status_cd) in ('WRN') then '2'
             else '-'
        end as acru_non_acru_cd                                   -- 应计非应计代码
       ,nvl(t3.distr_amt,0) as dubil_amt                          -- 借据金额
       ,case when t1.prod_id = '602030100002' then nvl(t3.ld_nomal_pric,0) + nvl(t3.ld_ovdue_pric,0) 
             else nvl(t3.ld_nomal_pric,0) 
        end as nomal_pric                                                              -- 正常本金
       ,decode(t1.prod_id,'602030100002',0,nvl(t3.ld_ovdue_pric,0)) as ovdue_pric      -- 逾期本金
       ,t1.job_cd                             -- 任务代码
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_acct_bal_h t3
    on t1.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd ='ncbsf1'
  inner join ${iml_schema}.prd_loan_prod_info_h t7
    on t1.prod_id = t7.prod_id
   and t7.crdt_prod_cate_cd in ('2', '4')   --零售贷款,个人委托贷款
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join ${iml_schema}.evt_loan_sub_acct_measure_flow t10
    on t1.loan_num||t1.distr_flow_num = t10.core_loan_num
   and t10.job_cd = 'tglsi1'
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
   and decode(trim(t1.auto_revs_flg),NULL,'-',t1.auto_revs_flg) <> 'Y'   --剔除自动冲正的数据
   and t1.acct_aldy_check_flg <> '0'
   and t1.open_acct_dt <=to_date('${batch_date}', 'yyyymmdd')
;

-- 1.4 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_acct_bal_info_ex purge;
alter table ${icl_schema}.cmm_retl_loan_acct_bal_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_acct_bal_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_acct_bal_info where 0=1;


--第一组 核心贷款账户信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_retl_loan_acct_bal_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,acct_id                       -- 账户编号
       ,dubil_num                     -- 借据号
       ,loan_num                      -- 贷款号
       ,std_prod_id                   -- 标准产品编号
       ,acru_non_acru_cd              -- 应计非应计代码
       ,dubil_amt                     -- 借据金额
       ,nomal_pric                    -- 正常本金
       ,ovdue_pric                    -- 逾期本金
       ,idle_pric                     -- 呆滞本金
       ,bad_debt_pric                 -- 呆账本金
       ,wrt_off_pric                  -- 核销本金
       ,wrt_off_int                   -- 核销利息
       ,in_bs_int                     -- 表内利息
       ,off_bs_int                    -- 表外利息
       ,pric_bal                      -- 本金余额
       ,currt_bal                     -- 当期余额
       ,cl_curr_currt_bal             -- 折本币当期余额
       ,ear_d_bal                     -- 日初余额
       ,ear_m_bal                     -- 月初余额
       ,ear_s_bal                     -- 季初余额
       ,ear_y_bal                     -- 年初余额
       ,y_acm_bal                     -- 年累计余额
       ,s_acm_bal                     -- 季累计余额
       ,m_acm_bal                     -- 月累计余额
       ,cl_curr_ear_d_bal             -- 折本币日初余额
       ,cl_curr_ear_m_bal             -- 折本币月初余额
       ,cl_curr_ear_s_bal             -- 折本币季初余额
       ,cl_curr_ear_y_bal             -- 折本币年初余额
       ,cl_curr_y_acm_bal             -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal       -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal       -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal       -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal       -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal             -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal       -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal       -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal       -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal             -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal       -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal       -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal       -- 折本币年初月累计余额
       ,y_avg_bal                     -- 年日均余额
       ,q_avg_bal                     -- 季日均余额
       ,m_avg_bal                     -- 月日均余额
       ,cl_curr_y_avg_bal             -- 折本币年日均余额
       ,cl_curr_q_avg_bal             -- 折本币季日均余额
       ,cl_curr_m_avg_bal             -- 折本币月日均余额
       ,nomal_pric_y_acm_bal          -- 正常本金年累计余额
       ,nomal_pric_s_acm_bal          -- 正常本金季累计余额
       ,nomal_pric_m_acm_bal          -- 正常本金月累计余额
       ,nomal_pric_cl_curr_y_acm_bal  -- 正常本金折本币年累计余额
       ,nomal_pric_cl_curr_s_acm_bal  -- 正常本金折本币季累计余额
       ,nomal_pric_cl_curr_m_acm_bal  -- 正常本金折本币月累计余额
       ,nomal_pric_y_avg_bal          -- 正常本金年日均余额
       ,nomal_pric_q_avg_bal          -- 正常本金季日均余额
       ,nomal_pric_m_avg_bal          -- 正常本金月日均余额
       ,nomal_pric_cl_curr_y_avg_bal  -- 正常本金折本币年日均余额
       ,nomal_pric_cl_curr_q_avg_bal  -- 正常本金折本币季日均余额
       ,nomal_pric_cl_curr_m_avg_bal  -- 正常本金折本币月日均余额
       ,ovdue_pric_y_acm_bal          -- 逾期本金年累计余额
       ,ovdue_pric_s_acm_bal          -- 逾期本金季累计余额
       ,ovdue_pric_m_acm_bal          -- 逾期本金月累计余额
       ,ovdue_pric_cl_curr_y_acm_bal  -- 逾期本金折本币年累计余额
       ,ovdue_pric_cl_curr_s_acm_bal  -- 逾期本金折本币季累计余额
       ,ovdue_pric_cl_curr_m_acm_bal  -- 逾期本金折本币月累计余额
       ,ovdue_pric_y_avg_bal          -- 逾期本金年日均余额
       ,ovdue_pric_q_avg_bal          -- 逾期本金季日均余额
       ,ovdue_pric_m_avg_bal          -- 逾期本金月日均余额
       ,ovdue_pric_cl_curr_y_avg_bal  -- 逾期本金折本币年日均余额
       ,ovdue_pric_cl_curr_q_avg_bal  -- 逾期本金折本币季日均余额
       ,ovdue_pric_cl_curr_m_avg_bal  -- 逾期本金折本币月日均余额
       ,idle_pric_y_acm_bal           -- 呆滞本金年累计余额
       ,idle_pric_s_acm_bal           -- 呆滞本金季累计余额
       ,idle_pric_m_acm_bal           -- 呆滞本金月累计余额
       ,idle_pric_cl_curr_y_acm_bal   -- 呆滞本金折本币年累计余额
       ,idle_pric_cl_curr_s_acm_bal   -- 呆滞本金折本币季累计余额
       ,idle_pric_cl_curr_m_acm_bal   -- 呆滞本金折本币月累计余额
       ,idle_pric_y_avg_bal           -- 呆滞本金年日均余额
       ,idle_pric_q_avg_bal           -- 呆滞本金季日均余额
       ,idle_pric_m_avg_bal           -- 呆滞本金月日均余额
       ,idle_pric_dc_y_avg_bal        -- 呆滞本金本币年日均余额
       ,idle_pric_dc_q_avg_bal        -- 呆滞本金本币季日均余额
       ,idle_pric_dc_m_avg_bal        -- 呆滞本金本币月日均余额
       ,bad_debt_pric_y_acm_bal       -- 呆账本金年累计余额
       ,bad_debt_pric_s_acm_bal       -- 呆账本金季累计余额
       ,bad_debt_pric_m_acm_bal       -- 呆账本金月累计余额
       ,bad_debt_cl_curr_y_acm_bal    -- 呆账本金折本币年累计余额
       ,bad_debt_cl_curr_s_acm_bal    -- 呆账本金折本币季累计余额
       ,bad_debt_cl_curr_m_acm_bal    -- 呆账本金折本币月累计余额
       ,bad_debt_pric_y_avg_bal       -- 呆账本金年日均余额
       ,bad_debt_pric_q_avg_bal       -- 呆账本金季日均余额
       ,bad_debt_pric_m_avg_bal       -- 呆账本金月日均余额
       ,bad_debt_pric_dc_y_avg_bal    -- 呆账本金本币年日均余额
       ,bad_debt_pric_dc_q_avg_bal    -- 呆账本金本币季日均余额
       ,bad_debt_pric_dc_m_avg_bal    -- 呆账本金本币月日均余额
       ,in_bs_int_y_acm_bal           -- 表内利息年累计余额
       ,in_bs_int_s_acm_bal           -- 表内利息季累计余额
       ,in_bs_int_m_acm_bal           -- 表内利息月累计余额
       ,in_bs_int_cl_curr_y_acm_bal   -- 表内利息折本币年累计余额
       ,in_bs_int_cl_curr_s_acm_bal   -- 表内利息折本币季累计余额
       ,in_bs_int_cl_curr_m_acm_bal   -- 表内利息折本币月累计余额
       ,in_bs_int_y_avg_bal           -- 表内利息年日均余额
       ,in_bs_int_q_avg_bal           -- 表内利息季日均余额
       ,in_bs_int_m_avg_bal           -- 表内利息月日均余额
       ,in_bs_int_dc_y_avg_bal        -- 表内利息本币年日均余额
       ,in_bs_int_dc_q_avg_bal        -- 表内利息本币季日均余额
       ,in_bs_int_dc_m_avg_bal        -- 表内利息本币月日均余额
       ,off_bs_int_y_acm_bal          -- 表外利息年累计余额
       ,off_bs_int_s_acm_bal          -- 表外利息季累计余额
       ,off_bs_int_m_acm_bal          -- 表外利息月累计余额
       ,off_bs_int_cl_curr_y_acm_bal  -- 表外利息折本币年累计余额
       ,off_bs_int_cl_curr_s_acm_bal  -- 表外利息折本币季累计余额
       ,off_bs_int_cl_curr_m_acm_bal  -- 表外利息折本币月累计余额
       ,off_bs_int_y_avg_bal          -- 表外利息年日均余额
       ,off_bs_int_q_avg_bal          -- 表外利息季日均余额
       ,off_bs_int_m_avg_bal          -- 表外利息月日均余额
       ,off_bs_int_dc_y_avg_bal       -- 表外利息本币年日均余额
       ,off_bs_int_dc_q_avg_bal       -- 表外利息本币季日均余额
       ,off_bs_int_dc_m_avg_bal       -- 表外利息本币月日均余额
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                        -- 数据日期
       ,t1.lp_id                                                  -- 法人编号
       ,t1.acct_id                                                -- 账户编号
       ,t1.dubil_id                                               -- 借据号
       ,t1.loan_num                                               -- 贷款号
       ,t1.prod_id                                                -- 标准产品编号
       ,t1.acru_non_acru_cd                                       -- 应计非应计代码
       ,t1.dubil_amt                                              -- 借据金额
       ,t1.nomal_pric                                             -- 正常本金
       ,t1.ovdue_pric                                             -- 逾期本金
       ,0                                                         -- 呆滞本金
       ,0                                                         -- 呆账本金	   
	     ,nvl(t10.wrtn_off_pric,0)                                         -- 核销本金
       ,nvl(t10.wrtn_off_int,0)                                          -- 核销利息
       ,nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)                     -- 表内利息
       ,nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)           -- 表外利息
       ,nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)+nvl(t10.wrtn_off_pric,0)             -- 本金余额
       ,nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)                               -- 当期余额
       ,(nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(t5.convt_cny_exch_rat, 1)         -- 折本币当期余额	   	   	   
       ,coalesce(t6.currt_bal,t6_1.currt_bal,0)                                                    --日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) else coalesce(t6.ear_m_bal,t6_1.ear_m_bal,0.0) end       --月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0)  else coalesce(t6.ear_s_bal,t6_1.ear_s_bal,0.0) end   --季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) else coalesce(t6.ear_y_bal,t6_1.ear_y_bal,0.0) end     --年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) else coalesce(t6.y_acm_bal,t6_1.y_acm_bal,0.0)+nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) end          --年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) else coalesce(t6.s_acm_bal,t6_1.s_acm_bal,0.0) + nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) end       --季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) else coalesce(t6.m_acm_bal,t6_1.m_acm_bal,0.0) + nvl((nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)),0) end               --月累计余额
       ,coalesce(t6.cl_curr_currt_bal,t6_1.cl_curr_currt_bal,0.0)     --折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_currt_bal,t6_1.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_m_bal,t6_1.cl_curr_ear_m_bal, 0.0) end       --折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_currt_bal,t6_1.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_s_bal,t6_1.cl_curr_ear_s_bal,0.0) end     --折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_currt_bal,t6.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_y_bal,t6_1.cl_curr_ear_y_bal,0.0) end      --折本币年初余额	   	   
       ,case when substr('${batch_date}',5,4) = '0101' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_y_acm_bal,t6_1.cl_curr_y_acm_bal,0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end        --折本币年累计余额		
       ,coalesce(t6.cl_curr_y_acm_bal,t6_1.cl_curr_y_acm_bal, 0.0)                                                                                                                                         -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_y_acm_bal,t6_1.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_y_acm_bal,t6_1.cl_curr_ear_m_y_acm_bal, 0.0) end                                         -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_y_acm_bal,t6_1.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal,t6_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_y_acm_bal,t6_1.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_y_acm_bal,t6_1.cl_curr_ear_y_y_acm_bal, 0.0) end                                       -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_s_acm_bal,t6_1.cl_curr_s_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end   -- 折本币季累计余额
       ,coalesce(t6.cl_curr_s_acm_bal,t6_1.cl_curr_s_acm_bal, 0.0)                                                                                                                                          -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_s_acm_bal,t6_1.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal,t6_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_s_acm_bal,t6_1.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_s_acm_bal,t6_1.cl_curr_ear_y_s_acm_bal, 0.0) end                                       -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_m_acm_bal,t6_1.cl_curr_m_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end    -- 折本币月累计余额
       ,coalesce(t6.cl_curr_m_acm_bal,t6_1.cl_curr_m_acm_bal, 0.0)                                                                                                                                          -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_m_acm_bal,t6_1.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_m_acm_bal,t6_1.cl_curr_ear_m_m_acm_bal, 0.0) end                                         -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_m_acm_bal,t6_1.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_m_acm_bal,t6_1.cl_curr_ear_y_m_acm_bal, 0.0) end                                       -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) else coalesce(t6.y_acm_bal,t6_1.y_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) else coalesce(t6.s_acm_bal,t6_1.s_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) else coalesce(t6.m_acm_bal,t6_1.m_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0)) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.y_acm_bal,t6_1.y_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.s_acm_bal,t6_1.s_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.m_acm_bal,t6_1.m_acm_bal, 0.0) + (nvl(t10.nomal_pric,0)+nvl(t10.log_pric,0)+nvl(t10.abs_pric,0))*nvl(trim(t5.convt_cny_exch_rat),1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额	   	   	   	   	             	   
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_y_acm_bal,t6_1.nomal_pric_y_acm_bal,0.0) + nvl(t1.nomal_pric,0)  end                                                                                                                                      -- 正常本金年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_s_acm_bal,t6_1.nomal_pric_s_acm_bal,0.0) + nvl(t1.nomal_pric,0)  end                                                                                                              -- 正常本金季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_m_acm_bal,t6_1.nomal_pric_m_acm_bal,0.0) + nvl(t1.nomal_pric,0)  end                                                                                                                                        -- 正常本金月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_y_acm_bal,t6_1.nomal_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                  -- 正常本金折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_s_acm_bal,t6_1.nomal_pric_cl_curr_s_acm_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                          -- 正常本金折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_m_acm_bal,t6_1.nomal_pric_cl_curr_m_acm_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                    -- 正常本金折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_y_avg_bal,t6_1.nomal_pric_y_avg_bal,0.0) + nvl(t1.nomal_pric,0)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                   -- 正常本金年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_q_avg_bal,t6_1.nomal_pric_q_avg_bal,0.0) + nvl(t1.nomal_pric,0)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)            -- 正常本金季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_pric,0)  else coalesce(t6.nomal_pric_m_avg_bal,t6_1.nomal_pric_m_avg_bal,0.0) + nvl(t1.nomal_pric,0)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                           -- 正常本金月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_y_avg_bal,t6_1.nomal_pric_cl_curr_y_avg_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 正常本金折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_q_avg_bal,t6_1.nomal_pric_cl_curr_q_avg_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 正常本金折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_m_avg_bal,t6_1.nomal_pric_cl_curr_m_avg_bal,0.0) + nvl(t1.nomal_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 正常本金折本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_y_acm_bal,t6_1.ovdue_pric_y_acm_bal,0.0) + nvl(t1.ovdue_pric,0)  end                                                                                                                                      -- 逾期本金年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_s_acm_bal,t6_1.ovdue_pric_s_acm_bal,0.0) + nvl(t1.ovdue_pric,0)  end                                                                                                              -- 逾期本金季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_m_acm_bal,t6_1.ovdue_pric_m_acm_bal,0.0) + nvl(t1.ovdue_pric,0)  end                                                                                                                                        -- 逾期本金月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_y_acm_bal,t6_1.ovdue_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                  -- 逾期本金折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_cl_curr_y_acm_bal,t6_1.ovdue_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                        -- 逾期本金折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_m_acm_bal,t6_1.ovdue_pric_cl_curr_m_acm_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                    -- 逾期本金折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_y_avg_bal,t6_1.ovdue_pric_y_avg_bal,0.0) + nvl(t1.ovdue_pric,0)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                   -- 逾期本金年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_q_avg_bal,t6_1.ovdue_pric_q_avg_bal,0.0) + nvl(t1.ovdue_pric,0)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)            -- 逾期本金季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_pric,0)  else coalesce(t6.ovdue_pric_m_avg_bal,t6_1.ovdue_pric_m_avg_bal,0.0) + nvl(t1.ovdue_pric,0)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                           -- 逾期本金月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_y_avg_bal,t6_1.ovdue_pric_cl_curr_y_avg_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 逾期本金折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_q_avg_bal,t6_1.ovdue_pric_cl_curr_q_avg_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 逾期本金折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_m_avg_bal,t6_1.ovdue_pric_cl_curr_m_avg_bal,0.0) + nvl(t1.ovdue_pric,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 逾期本金折本币月日均余额
       ,0                               -- 呆滞本金年累计余额
       ,0                               -- 呆滞本金季累计余额
       ,0                               -- 呆滞本金月累计余额
       ,0                               -- 呆滞本金折本币年累计余额
       ,0                               -- 呆滞本金折本币季累计余额
       ,0                               -- 呆滞本金折本币月累计余额
       ,0                               -- 呆滞本金年日均余额
       ,0                               -- 呆滞本金季日均余额
       ,0                               -- 呆滞本金月日均余额
       ,0                               -- 呆滞本金本币年日均余额
       ,0                               -- 呆滞本金本币季日均余额
       ,0                               -- 呆滞本金本币月日均余额
       ,0                               -- 呆账本金年累计余额
       ,0                               -- 呆账本金季累计余额
       ,0                               -- 呆账本金月累计余额
       ,0                               -- 呆账本金折本币年累计余额
       ,0                               -- 呆账本金折本币季累计余额
       ,0                               -- 呆账本金折本币月累计余额
       ,0                               -- 呆账本金年日均余额
       ,0                               -- 呆账本金季日均余额
       ,0                               -- 呆账本金月日均余额
       ,0                               -- 呆账本金本币年日均余额
       ,0                               -- 呆账本金本币季日均余额
       ,0                               -- 呆账本金本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)  else coalesce(t6.in_bs_int_y_acm_bal,t6_1.in_bs_int_y_acm_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end                             -- 表内利息年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) else coalesce(t6.in_bs_int_s_acm_bal,t6_1.in_bs_int_s_acm_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end      -- 表内利息季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)  else coalesce(t6.in_bs_int_m_acm_bal,t6_1.in_bs_int_m_acm_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end                               -- 表内利息月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end                                    -- 表内利息折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.in_bs_int_cl_curr_s_acm_bal,t6_1.in_bs_int_cl_curr_s_acm_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end             -- 表内利息折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_cl_curr_m_acm_bal,t6_1.in_bs_int_cl_curr_m_acm_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end                                      -- 表内利息折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) else coalesce(t6.in_bs_int_y_avg_bal,t6_1.in_bs_int_y_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                          -- 表内利息年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)  else coalesce(t6.in_bs_int_q_avg_bal,t6_1.in_bs_int_q_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表内利息季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) else coalesce(t6.in_bs_int_m_avg_bal,t6_1.in_bs_int_m_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0) end) / to_number(substr('${batch_date}', 7, 2))                                                                                  -- 表内利息月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_dc_y_avg_bal,t6_1.in_bs_int_dc_y_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 表内利息折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.in_bs_int_dc_q_avg_bal,t6_1.in_bs_int_dc_q_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表内利息折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_dc_m_avg_bal,t6_1.in_bs_int_dc_m_avg_bal,0.0) + nvl((nvl(t10.recvbl_uncol_int,0) + nvl(t10.int_recvbl,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 表内利息折本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_y_acm_bal,t6_1.off_bs_int_y_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end                             -- 表外利息年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_s_acm_bal,t6_1.off_bs_int_s_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end     -- 表外利息季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_m_acm_bal,t6_1.off_bs_int_m_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end                               -- 表外利息月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_cl_curr_y_acm_bal,t6_1.off_bs_int_cl_curr_y_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end                               -- 表外利息折本币年累计余额
	     ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.off_bs_int_cl_curr_s_acm_bal,t6_1.off_bs_int_cl_curr_s_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end        -- 表外利息折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_cl_curr_m_acm_bal,t6_1.off_bs_int_cl_curr_m_acm_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1) end                                 -- 表外利息折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_y_avg_bal,t6_1.off_bs_int_y_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                        -- 表外利息年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_q_avg_bal,t6_1.off_bs_int_q_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表外利息季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) else coalesce(t6.off_bs_int_m_avg_bal,t6_1.off_bs_int_m_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0) end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 表外利息月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_y_avg_bal,t6_1.off_bs_int_dc_y_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 表外利息折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_q_avg_bal,t6_1.off_bs_int_dc_q_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表外利息折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_m_avg_bal,t6_1.off_bs_int_dc_m_avg_bal,0.0) + nvl((nvl(t10.non_acru_int_recvbl,0) + nvl(t10.acru_aldy_impam_int,0)),0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2)) 	   	   
       ,t1.job_cd                             -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${icl_schema}.tmp_cmm_retl_loan_acct_bal_info_01 t1
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
    on t1.curr_cd = t5.curr_cd
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_retl_loan_acct_bal_info t6
    on t1.dubil_id = t6.dubil_num
   and t1.lp_id = t6.lp_id
   and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  <=to_date('20230502', 'yyyymmdd') 
  left join ${icl_schema}.cmm_retl_loan_acct_bal_info t6_1
    on t1.acct_id = t6_1.acct_id
   and t1.lp_id = t6_1.lp_id
   and t6_1.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  >to_date('20230502', 'yyyymmdd') 
  left join ${iml_schema}.evt_loan_sub_acct_measure_flow t10
    on t1.loan_num||t1.distr_flow_num = t10.core_loan_num
   and t10.job_cd = 'tglsi1'
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  where 1 = 1
;
commit;

--第二组 信贷房抵贷借据信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_retl_loan_acct_bal_info_ex(
       etl_dt                                          -- 数据日期
       ,lp_id                                          -- 法人编号
       ,acct_id                                        -- 账户编号
       ,dubil_num                                      -- 借据号
       ,loan_num                                       -- 贷款号
       ,std_prod_id                                    -- 标准产品编号
       ,acru_non_acru_cd                               -- 应计非应计代码
       ,dubil_amt                                      -- 借据金额
       ,nomal_pric                                     -- 正常本金
       ,ovdue_pric                                     -- 逾期本金
       ,idle_pric                                      -- 呆滞本金
       ,bad_debt_pric                                  -- 呆账本金
       ,wrt_off_pric                                   -- 核销本金
       ,wrt_off_int                                    -- 核销利息
       ,in_bs_int                                      -- 表内利息
       ,off_bs_int                                     -- 表外利息
       ,pric_bal                                       -- 本金余额
       ,currt_bal                                      -- 当期余额
       ,cl_curr_currt_bal                              -- 折本币当期余额
       ,ear_d_bal                                      -- 日初余额
       ,ear_m_bal                                      -- 月初余额
       ,ear_s_bal                                      -- 季初余额
       ,ear_y_bal                                      -- 年初余额
       ,y_acm_bal                                      -- 年累计余额
       ,s_acm_bal                                      -- 季累计余额
       ,m_acm_bal                                      -- 月累计余额
       ,cl_curr_ear_d_bal                              -- 折本币日初余额
       ,cl_curr_ear_m_bal                              -- 折本币月初余额
       ,cl_curr_ear_s_bal                              -- 折本币季初余额
       ,cl_curr_ear_y_bal                              -- 折本币年初余额
       ,cl_curr_y_acm_bal                              -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal                        -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal                        -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal                        -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal                        -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal                              -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal                        -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal                        -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal                        -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal                              -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal                        -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal                        -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal                        -- 折本币年初月累计余额
       ,y_avg_bal                                      -- 年日均余额
       ,q_avg_bal                                      -- 季日均余额
       ,m_avg_bal                                      -- 月日均余额
       ,cl_curr_y_avg_bal                              -- 折本币年日均余额
       ,cl_curr_q_avg_bal                              -- 折本币季日均余额
       ,cl_curr_m_avg_bal                              -- 折本币月日均余额
       ,nomal_pric_y_acm_bal                           -- 正常本金年累计余额
       ,nomal_pric_s_acm_bal                           -- 正常本金季累计余额
       ,nomal_pric_m_acm_bal                           -- 正常本金月累计余额
       ,nomal_pric_cl_curr_y_acm_bal                   -- 正常本金折本币年累计余额
       ,nomal_pric_cl_curr_s_acm_bal                   -- 正常本金折本币季累计余额
       ,nomal_pric_cl_curr_m_acm_bal                   -- 正常本金折本币月累计余额
       ,nomal_pric_y_avg_bal                           -- 正常本金年日均余额
       ,nomal_pric_q_avg_bal                           -- 正常本金季日均余额
       ,nomal_pric_m_avg_bal                           -- 正常本金月日均余额
       ,nomal_pric_cl_curr_y_avg_bal                   -- 正常本金折本币年日均余额
       ,nomal_pric_cl_curr_q_avg_bal                   -- 正常本金折本币季日均余额
       ,nomal_pric_cl_curr_m_avg_bal                   -- 正常本金折本币月日均余额
       ,ovdue_pric_y_acm_bal                           -- 逾期本金年累计余额
       ,ovdue_pric_s_acm_bal                           -- 逾期本金季累计余额
       ,ovdue_pric_m_acm_bal                           -- 逾期本金月累计余额
       ,ovdue_pric_cl_curr_y_acm_bal                   -- 逾期本金折本币年累计余额
       ,ovdue_pric_cl_curr_s_acm_bal                   -- 逾期本金折本币季累计余额
       ,ovdue_pric_cl_curr_m_acm_bal                   -- 逾期本金折本币月累计余额
       ,ovdue_pric_y_avg_bal                           -- 逾期本金年日均余额
       ,ovdue_pric_q_avg_bal                           -- 逾期本金季日均余额
       ,ovdue_pric_m_avg_bal                           -- 逾期本金月日均余额
       ,ovdue_pric_cl_curr_y_avg_bal                   -- 逾期本金折本币年日均余额
       ,ovdue_pric_cl_curr_q_avg_bal                   -- 逾期本金折本币季日均余额
       ,ovdue_pric_cl_curr_m_avg_bal                   -- 逾期本金折本币月日均余额
       ,idle_pric_y_acm_bal                            -- 呆滞本金年累计余额
       ,idle_pric_s_acm_bal                            -- 呆滞本金季累计余额
       ,idle_pric_m_acm_bal                            -- 呆滞本金月累计余额
       ,idle_pric_cl_curr_y_acm_bal                    -- 呆滞本金折本币年累计余额
       ,idle_pric_cl_curr_s_acm_bal                    -- 呆滞本金折本币季累计余额
       ,idle_pric_cl_curr_m_acm_bal                    -- 呆滞本金折本币月累计余额
       ,idle_pric_y_avg_bal                            -- 呆滞本金年日均余额
       ,idle_pric_q_avg_bal                            -- 呆滞本金季日均余额
       ,idle_pric_m_avg_bal                            -- 呆滞本金月日均余额
       ,idle_pric_dc_y_avg_bal                         -- 呆滞本金本币年日均余额
       ,idle_pric_dc_q_avg_bal                         -- 呆滞本金本币季日均余额
       ,idle_pric_dc_m_avg_bal                         -- 呆滞本金本币月日均余额
       ,bad_debt_pric_y_acm_bal                        -- 呆账本金年累计余额
       ,bad_debt_pric_s_acm_bal                        -- 呆账本金季累计余额
       ,bad_debt_pric_m_acm_bal                        -- 呆账本金月累计余额
       ,bad_debt_cl_curr_y_acm_bal                     -- 呆账本金折本币年累计余额
       ,bad_debt_cl_curr_s_acm_bal                     -- 呆账本金折本币季累计余额
       ,bad_debt_cl_curr_m_acm_bal                     -- 呆账本金折本币月累计余额
       ,bad_debt_pric_y_avg_bal                        -- 呆账本金年日均余额
       ,bad_debt_pric_q_avg_bal                        -- 呆账本金季日均余额
       ,bad_debt_pric_m_avg_bal                        -- 呆账本金月日均余额
       ,bad_debt_pric_dc_y_avg_bal                     -- 呆账本金本币年日均余额
       ,bad_debt_pric_dc_q_avg_bal                     -- 呆账本金本币季日均余额
       ,bad_debt_pric_dc_m_avg_bal                     -- 呆账本金本币月日均余额
       ,in_bs_int_y_acm_bal                            -- 表内利息年累计余额
       ,in_bs_int_s_acm_bal                            -- 表内利息季累计余额
       ,in_bs_int_m_acm_bal                            -- 表内利息月累计余额
       ,in_bs_int_cl_curr_y_acm_bal                    -- 表内利息折本币年累计余额
       ,in_bs_int_cl_curr_s_acm_bal                    -- 表内利息折本币季累计余额
       ,in_bs_int_cl_curr_m_acm_bal                    -- 表内利息折本币月累计余额
       ,in_bs_int_y_avg_bal                            -- 表内利息年日均余额
       ,in_bs_int_q_avg_bal                            -- 表内利息季日均余额
       ,in_bs_int_m_avg_bal                            -- 表内利息月日均余额
       ,in_bs_int_dc_y_avg_bal                         -- 表内利息本币年日均余额
       ,in_bs_int_dc_q_avg_bal                         -- 表内利息本币季日均余额
       ,in_bs_int_dc_m_avg_bal                         -- 表内利息本币月日均余额
       ,off_bs_int_y_acm_bal                           -- 表外利息年累计余额
       ,off_bs_int_s_acm_bal                           -- 表外利息季累计余额
       ,off_bs_int_m_acm_bal                           -- 表外利息月累计余额
       ,off_bs_int_cl_curr_y_acm_bal                   -- 表外利息折本币年累计余额
       ,off_bs_int_cl_curr_s_acm_bal                   -- 表外利息折本币季累计余额
       ,off_bs_int_cl_curr_m_acm_bal                   -- 表外利息折本币月累计余额
       ,off_bs_int_y_avg_bal                           -- 表外利息年日均余额
       ,off_bs_int_q_avg_bal                           -- 表外利息季日均余额
       ,off_bs_int_m_avg_bal                           -- 表外利息月日均余额
       ,off_bs_int_dc_y_avg_bal                        -- 表外利息本币年日均余额
       ,off_bs_int_dc_q_avg_bal                        -- 表外利息本币季日均余额
       ,off_bs_int_dc_m_avg_bal                        -- 表外利息本币月日均余额
       ,job_cd                                         -- 任务代码
       ,etl_timestamp                                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.dubil_id	                                                     --	账户编号
       ,t1.dubil_id	                                                     --	借据号
       ,''	                                                             --	贷款号
       ,t1.prod_id                                                       -- 标准产品编号
       ,decode(t1.off_bs_flg,'1','0','2','1','-')                        -- 应计非应计代码
       ,t1.dubil_amt                                                     -- 借据金额
       ,t1.nomal_bal                                                     -- 正常本金
       ,t1.ovdue_bal                                                     -- 逾期本金
       ,0                                                                -- 呆滞本金
       ,0                                                                -- 呆账本金
       ,t1.wrt_off_pric                                                  -- 核销本金
       ,t1.wrt_off_int                                                   -- 核销利息
       ,t1.in_bs_over_int_bal                                            -- 表内利息
       ,t1.off_bs_over_int_bal                                           -- 表外利息
       ,t1.curr_bal                                                      -- 本金余额
       ,t1.curr_bal                                                      -- 当期余额
       ,t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1)                   -- 折本币当期余额	   	   
       ,coalesce(t6.currt_bal,0)                                         -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.ear_m_bal,0.0) end       --月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal  else coalesce(t6.ear_s_bal,0.0) end   --季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.ear_y_bal,0.0) end     --年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.y_acm_bal,0.0)+t1.curr_bal end          --年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal else coalesce(t6.s_acm_bal,0.0) + t1.curr_bal end       --季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.m_acm_bal,0.0) + t1.curr_bal end               --月累计余额
       ,coalesce(t6.cl_curr_currt_bal,0.0)     --折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_m_bal, 0.0) end       --折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_s_bal,0.0) end     --折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_currt_bal,0.0) else coalesce(t6.cl_curr_ear_y_bal,0.0) end      --折本币年初余额	   	   
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_y_acm_bal,0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end        --折本币年累计余额		
       ,coalesce(t6.cl_curr_y_acm_bal, 0.0)                                                                                                                                         -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_y_acm_bal, 0.0) end                                         -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_y_acm_bal, 0.0) end                                       -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_s_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end   -- 折本币季累计余额
       ,coalesce(t6.cl_curr_s_acm_bal, 0.0)                                                                                                                                          -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_s_acm_bal, 0.0) end                                       -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_m_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end    -- 折本币月累计余额
       ,coalesce(t6.cl_curr_m_acm_bal, 0.0)                                                                                                                                          -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_m_acm_bal, 0.0) end                                         -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_m_acm_bal, 0.0) end                                       -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.y_acm_bal, 0.0) + t1.curr_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal else coalesce(t6.s_acm_bal, 0.0) + t1.curr_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.m_acm_bal, 0.0) + t1.curr_bal end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_y_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_s_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_m_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额	   	   	   	   	             	   
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_y_acm_bal,0.0) + nvl(t1.nomal_bal,0)  end                                                                                                                                      -- 正常本金年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_s_acm_bal,0.0) + nvl(t1.nomal_bal,0)  end                                                                                                              -- 正常本金季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_m_acm_bal,0.0) + nvl(t1.nomal_bal,0)  end                                                                                                                                        -- 正常本金月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                  -- 正常本金折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_s_acm_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                          -- 正常本金折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_m_acm_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                    -- 正常本金折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_y_avg_bal,0.0) + nvl(t1.nomal_bal,0)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                   -- 正常本金年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_q_avg_bal,0.0) + nvl(t1.nomal_bal,0)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)            -- 正常本金季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_bal,0)  else coalesce(t6.nomal_pric_m_avg_bal,0.0) + nvl(t1.nomal_bal,0)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                           -- 正常本金月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_y_avg_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 正常本金折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_q_avg_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 正常本金折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.nomal_pric_cl_curr_m_avg_bal,0.0) + nvl(t1.nomal_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 正常本金折本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_y_acm_bal,0.0) + nvl(t1.ovdue_bal,0)  end                                                                                                                                      -- 逾期本金年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_s_acm_bal,0.0) + nvl(t1.ovdue_bal,0)  end                                                                                                              -- 逾期本金季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_m_acm_bal,0.0) + nvl(t1.ovdue_bal,0)  end                                                                                                                                        -- 逾期本金月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                  -- 逾期本金折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_cl_curr_y_acm_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                        -- 逾期本金折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_m_acm_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end                                                                    -- 逾期本金折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_y_avg_bal,0.0) + nvl(t1.ovdue_bal,0)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                   -- 逾期本金年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_q_avg_bal,0.0) + nvl(t1.ovdue_bal,0)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)            -- 逾期本金季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_bal,0)  else coalesce(t6.ovdue_pric_m_avg_bal,0.0) + nvl(t1.ovdue_bal,0)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                           -- 逾期本金月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_y_avg_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 逾期本金折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_q_avg_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 逾期本金折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.ovdue_pric_cl_curr_m_avg_bal,0.0) + nvl(t1.ovdue_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 逾期本金折本币月日均余额
       ,0                               -- 呆滞本金年累计余额
       ,0                               -- 呆滞本金季累计余额
       ,0                               -- 呆滞本金月累计余额
       ,0                               -- 呆滞本金折本币年累计余额
       ,0                               -- 呆滞本金折本币季累计余额
       ,0                               -- 呆滞本金折本币月累计余额
       ,0                               -- 呆滞本金年日均余额
       ,0                               -- 呆滞本金季日均余额
       ,0                               -- 呆滞本金月日均余额
       ,0                               -- 呆滞本金本币年日均余额
       ,0                               -- 呆滞本金本币季日均余额
       ,0                               -- 呆滞本金本币月日均余额
       ,0                               -- 呆账本金年累计余额
       ,0                               -- 呆账本金季累计余额
       ,0                               -- 呆账本金月累计余额
       ,0                               -- 呆账本金折本币年累计余额
       ,0                               -- 呆账本金折本币季累计余额
       ,0                               -- 呆账本金折本币月累计余额
       ,0                               -- 呆账本金年日均余额
       ,0                               -- 呆账本金季日均余额
       ,0                               -- 呆账本金月日均余额
       ,0                               -- 呆账本金本币年日均余额
       ,0                               -- 呆账本金本币季日均余额
       ,0                               -- 呆账本金本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.in_bs_over_int_bal,0)  else coalesce(t6.in_bs_int_y_acm_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end                             -- 表内利息年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.in_bs_over_int_bal,0) else coalesce(t6.in_bs_int_s_acm_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end      -- 表内利息季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.in_bs_over_int_bal,0)  else coalesce(t6.in_bs_int_m_acm_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end                               -- 表内利息月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else nvl(t1.in_bs_over_int_bal,0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end                                    -- 表内利息折本币年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.in_bs_int_cl_curr_s_acm_bal,0.0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end             -- 表内利息折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_cl_curr_m_acm_bal,0.0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end                                      -- 表内利息折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.in_bs_over_int_bal,0) else coalesce(t6.in_bs_int_y_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                          -- 表内利息年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.in_bs_over_int_bal,0)  else coalesce(t6.in_bs_int_q_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表内利息季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.in_bs_over_int_bal,0) else coalesce(t6.in_bs_int_m_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0) end) / to_number(substr('${batch_date}', 7, 2))                                                                                  -- 表内利息月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_dc_y_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 表内利息折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.in_bs_int_dc_q_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表内利息折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.in_bs_int_dc_m_avg_bal,0.0) + nvl(t1.in_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 表内利息折本币月日均余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_y_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end                             -- 表外利息年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_s_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end     -- 表外利息季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_m_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end                               -- 表外利息月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_cl_curr_y_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end                               -- 表外利息折本币年累计余额
	     ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) else coalesce(t6.off_bs_int_cl_curr_s_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end        -- 表外利息折本币季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_cl_curr_m_acm_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1) end                                 -- 表外利息折本币月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_y_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                        -- 表外利息年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_q_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表外利息季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.off_bs_over_int_bal,0) else coalesce(t6.off_bs_int_m_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0) end) / to_number(substr('${batch_date}', 7, 2))                                                                                 -- 表外利息月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_y_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end ) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                         -- 表外利息折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_q_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)  -- 表外利息折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  else coalesce(t6.off_bs_int_dc_m_avg_bal,0.0) + nvl(t1.off_bs_over_int_bal,0)*nvl(t5.convt_cny_exch_rat, 1)  end) / to_number(substr('${batch_date}', 7, 2)) 	   	   
       ,t1.job_cd                             -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_dubil_info_h t1
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
    on t1.curr_cd = t5.curr_cd
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_retl_loan_acct_bal_info t6
    on t1.dubil_id = t6.dubil_num
   and t1.lp_id = t6.lp_id
   and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
 where t1.job_cd = 'icmsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.prod_id ='201020100057'
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_acct_bal_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_acct_bal_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_acct_bal_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_bal_info_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_acct_bal_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
