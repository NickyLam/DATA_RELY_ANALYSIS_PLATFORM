/*
Purpose:    共性加工层-贴现账户信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_discnt_acct_info
CreateDate: 20190808
Logs:
            20200110 翟若平 调整iml.ref_cny_fori_exch_mdl_p_h表取数口径
            20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
            20211107 何桐金 【agt_imp_dt_h】增加job_cd过滤条件
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_discnt_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_discnt_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_discnt_acct_info_ex purge;
drop table ${icl_schema}.cmm_discnt_acct_info_ex_02 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_discnt_acct_info_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_discnt_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_discnt_acct_info_ex(
   etl_dt                                 -- 数据日期
   ,lp_id                                 -- 法人编号
   ,acct_id                               -- 账户编号
   ,bill_num                              -- 票据号码
   ,cust_acct_id                          -- 客户账户编号
   ,cust_id                               -- 客户编号
   ,out_acct_flow_num                     -- 出账流水号
   ,dubil_id                              -- 借据编号
   ,discnt_entry_acct_id                  -- 贴现记账账户编号
   ,int_adj_acct_id                       -- 利息调整账户编号
   ,int_income_expns_acct_id              -- 利息收入支出账户编号
   ,pay_int_acct_id                       -- 付息账户编号
   ,subj_id                               -- 科目编号
   ,int_subj_id                           -- 利息科目编号
   ,bus_breed_id                          -- 业务品种编号
   ,discnt_bus_kind_cd                    -- 贴现业务种类代码
   ,bs_type_cd                            -- 买卖类型代码
   ,bill_med_cd                           -- 票据介质代码
   ,bill_type_cd                          -- 票据类型代码
   ,bs_way_cd                             -- 买卖方式代码
   ,clear_way_cd                          -- 清算方式代码
   ,discnt_status_cd                      -- 贴现状态代码
   ,int_adj_entry_cd                      -- 利息调整记账代码
   ,pay_int_way_cd                        -- 付息方式代码
   ,curr_cd                               -- 币种代码
   ,oper_teller_id                        -- 经办柜员编号
   ,rgst_teller_id                        -- 登记柜员编号
   ,discnt_org_id                         -- 贴现机构编号
   ,draw_org_id                           -- 出票机构编号
   ,mgmt_org_id                           -- 管理机构编号
   ,acct_instit_id                        -- 账务机构编号
   ,discnt_value_dt                       -- 贴现起息日期
   ,discnt_exp_dt                         -- 贴现到期日期
   ,draw_dt                               -- 出票日期
   ,discnt_dt                             -- 贴现日期
   ,discnt_flow_num                       -- 贴现流水号
   ,close_dt                              -- 关闭日期
   ,termnt_dt                             -- 终止日期
   ,close_flow_num                        -- 关闭流水号
   ,last_int_adj_day                      -- 上一利息调整日
   ,next_int_adj_day                      -- 下一利息调整日
   ,int_accr_days                         -- 计息天数
   ,pay_int_amt                           -- 付息金额
   ,int_recvbl                            -- 应收利息
   ,int_adj_bal                           -- 利息调整余额
   ,wrt_off_amt                           -- 核销金额
   ,fac_val_amt                           -- 票面金额
   ,currt_bal                             -- 当期余额
   ,cl_curr_currt_bal                     -- 折本币当期余额
   ,job_cd                                -- 任务代码
   ,etl_timestamp                         -- etl处理时间戳
)
select 
   to_date('${batch_date}','yyyymmdd')   --数据日期
   ,'9999'                               --法人编号
   ,t1.uniq_idf_id                       --账户编号
   ,t1.bill_id                           --票据号码
   ,t1.cust_acct_id                      --客户账户编号
   ,t3.party_id                          --客户编号
   ,t2.out_acct_flow_num                 --出账流水号
   ,t3.dubil_id                          --借据编号
   ,t1.bill_acct_id                      --贴现记账账户编号
   ,t1.int_adj_acct_id                   --利息调整账户编号
   ,t1.int_income_expns_acct_id          --利息收入支出账户编号
   ,t1.pay_int_acct_id                   --付息账户编号
   ,(case when t1.bus_kind_cd = '0' and t1.bill_kind_cd = '01' then '13010101' 
         when t1.bus_kind_cd = '0' and t1.bill_kind_cd = '02' then '13010201'
         else '' end)                    -- 科目编号
   ,(case when t1.bus_kind_cd = '0' and t1.bill_kind_cd = '01' then '13010102' 
         when t1.bus_kind_cd = '0' and t1.bill_kind_cd = '02' then '13010202'
         else '' end)                    --利息科目编号
   ,t2.bus_kind_cd                       --业务品种编号
   ,t1.bus_kind_cd                       --贴现业务种类代码
   ,t1.bs_type_cd                        --买卖类型代码
   ,t1.bill_med_cd                       --票据介质代码
   ,t1.bill_kind_cd                      --票据类型代码
   ,t1.bs_way_cd                         --买卖方式代码
   ,t1.clear_way_cd                      --清算方式代码
   ,(case when (trim(t5.imp_dt) is not null and t5.imp_dt <> to_date('20991231','yyyymmdd'))
   	 then '0' else t1.discnt_status_cd end)   -- 贴现状态代码
   ,decode(t1.int_adj_entry_dir_cd, 'C', '1', 'D', '0')-- 利息调整记账代码
   ,t1.pay_int_way_cd                        --付息方式代码
   ,t1.fac_val_curr_cd                       --币种代码
   ,t2.oper_teller_id                        --经办柜员编号
   ,t2.rgst_teller_id                        --登记柜员编号
   ,t1.discnt_org_id                         --贴现机构编号
   ,t1.discnt_org_id                         --出票机构编号
   ,t1.discnt_org_id                         --管理机构编号
   ,t1.discnt_org_id                         --账务机构编号
   ,t1.discnt_dt                             --贴现起息日期
   ,t1.fac_val_exp_dt                        --贴现到期日期
   ,t1.discnt_dt                             --出票日期
   ,t1.discnt_dt                             --贴现日期
   ,t1.discnt_flow_id                        --贴现流水号
   ,t1.close_dt                              --关闭日期
   ,t5.imp_dt                                --终止日期
   ,t1.close_flow_num                        --关闭流水号
   ,t1.last_int_adj_day                      --上一利息调整日
   ,t1.next_int_adj_day                      --下一利息调整日
   ,t1.int_accr_days                         --计息天数
   ,nvl(t1.pay_int_amt, 0)                   --付息金额
   ,nvl(t1.int_recvbl, 0)                    --应收利息
   ,nvl(t1.int_adj_bal, 0)                   --利息调整余额
   ,nvl(t3.wrt_off_amt, 0)                   --核销金额
   ,nvl(t1.fac_val_amt, 0)                   --票面金额
   ,(case when (trim(t5.imp_dt) is not null and t5.imp_dt <> to_date('20991231','yyyymmdd'))
   	 then 0 else t1.fac_val_amt end)                 --当期余额
   ,(case when (trim(t5.imp_dt) is not null and t5.imp_dt <> to_date('20991231','yyyymmdd'))
   	 then 0 else t1.fac_val_amt end) * nvl(t4.convt_cny_exch_rat, 1)  -- 折本币当期余额
   ,t1.job_cd                                        -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.agt_discnt_acct t1
   inner join ${iml_schema}.agt_loan_out_acct_appl t2 
   	on t1.uniq_idf_id = t2.sig_bill_uniq_mark_id 
   	and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'crssf1'
    and t2.id_mark <> 'D'
   inner join ${iml_schema}.agt_loan_dubil t3 
   	on t2.out_acct_flow_num = t3.out_acct_flow_num 
   	and t3.dubil_id not like 'UPL%' 
   	and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.job_cd = 'crssf1'
    and t3.id_mark <> 'D'
   left join ${iml_schema}.agt_imp_dt_h t5
  	 on t5.agt_id = t3.agt_id
  	and t5.dt_type_cd = '03'
  	and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t5.end_dt > to_date('${batch_date}','yyyymmdd')
  	and t5.job_cd='crssf1'
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t4 
   	on t1.fac_val_curr_cd = t4.curr_cd
   	--and t4.dt = to_date('${batch_date}', 'yyyymmdd')
   	and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
    and t4.id_mark <> 'D'
    and t4.job_cd = 'cbssf1'
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.job_cd = 'cbssf1'
 and t1.id_mark <> 'D'
;
commit;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_discnt_acct_info_ex_02 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_discnt_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_discnt_acct_info_ex_02(
   etl_dt                                 -- 数据日期
   ,lp_id                                 -- 法人编号
   ,acct_id                               -- 账户编号
   ,bill_num                              -- 票据号码
   ,cust_acct_id                          -- 客户账户编号
   ,cust_id                               -- 客户编号
   ,out_acct_flow_num                     -- 出账流水号
   ,dubil_id                              -- 借据编号
   ,discnt_entry_acct_id                  -- 贴现记账账户编号
   ,int_adj_acct_id                       -- 利息调整账户编号
   ,int_income_expns_acct_id              -- 利息收入支出账户编号
   ,pay_int_acct_id                       -- 付息账户编号
   ,subj_id                               -- 科目编号
   ,int_subj_id                           -- 利息科目编号
   ,bus_breed_id                          -- 业务品种编号
   ,discnt_bus_kind_cd                    -- 贴现业务种类代码
   ,bs_type_cd                            -- 买卖类型代码
   ,bill_med_cd                           -- 票据介质代码
   ,bill_type_cd                          -- 票据类型代码
   ,bs_way_cd                             -- 买卖方式代码
   ,clear_way_cd                          -- 清算方式代码
   ,discnt_status_cd                      -- 贴现状态代码
   ,int_adj_entry_cd                      -- 利息调整记账代码
   ,pay_int_way_cd                        -- 付息方式代码
   ,curr_cd                               -- 币种代码
   ,oper_teller_id                        -- 经办柜员编号
   ,rgst_teller_id                        -- 登记柜员编号
   ,discnt_org_id                         -- 贴现机构编号
   ,draw_org_id                           -- 出票机构编号
   ,mgmt_org_id                           -- 管理机构编号
   ,acct_instit_id                        -- 账务机构编号
   ,discnt_value_dt                       -- 贴现起息日期
   ,discnt_exp_dt                         -- 贴现到期日期
   ,draw_dt                               -- 出票日期
   ,discnt_dt                             -- 贴现日期
   ,discnt_flow_num                       -- 贴现流水号
   ,close_dt                              -- 关闭日期
   ,termnt_dt                             -- 终止日期
   ,close_flow_num                        -- 关闭流水号
   ,last_int_adj_day                      -- 上一利息调整日
   ,next_int_adj_day                      -- 下一利息调整日
   ,int_accr_days                         -- 计息天数
   ,pay_int_amt                           -- 付息金额
   ,int_recvbl                            -- 应收利息
   ,int_adj_bal                           -- 利息调整余额
   ,wrt_off_amt                           -- 核销金额
   ,fac_val_amt                           -- 票面金额
   ,currt_bal                             -- 当期余额
   ,cl_curr_currt_bal                     -- 折本币当期余额
   ,ear_d_bal                             -- 日初余额
   ,ear_m_bal                             -- 月初余额
   ,ear_s_bal                             -- 季初余额
   ,ear_y_bal                             -- 年初余额
   ,y_acm_bal                             -- 年累计余额
   ,s_acm_bal                             -- 季累计余额
   ,m_acm_bal                             -- 月累计余额
   ,cl_curr_ear_d_bal                     -- 折本币日初余额
   ,cl_curr_ear_m_bal                     -- 折本币月初余额
   ,cl_curr_ear_s_bal                     -- 折本币季初余额
   ,cl_curr_ear_y_bal                     -- 折本币年初余额
   ,cl_curr_y_acm_bal                     -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal               -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal               -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal               -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal               -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal                     -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal               -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal               -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal               -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal                     -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal               -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal               -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal               -- 折本币年初月累计余额
   ,y_avg_bal        						 					-- 年日均余额
   ,q_avg_bal        						 					-- 季日均余额
   ,m_avg_bal        						 					-- 月日均余额
   ,cl_curr_y_avg_bal						 					-- 折本币年日均余额
   ,cl_curr_q_avg_bal						 					-- 折本币季日均余额
   ,cl_curr_m_avg_bal						 					-- 折本币月日均余额
   ,job_cd                                -- 任务代码
   ,etl_timestamp                         -- etl处理时间戳
)
select 
   t1.etl_dt                                 -- 数据日期
   ,t1.lp_id                                 -- 法人编号
   ,t1.acct_id                               -- 账户编号
   ,t1.bill_num                              -- 票据号码
   ,t1.cust_acct_id                          -- 客户账户编号
   ,t1.cust_id                               -- 客户编号
   ,t1.out_acct_flow_num                     -- 出账流水号
   ,t1.dubil_id                              -- 借据编号
   ,t1.discnt_entry_acct_id                  -- 贴现记账账户编号
   ,t1.int_adj_acct_id                       -- 利息调整账户编号
   ,t1.int_income_expns_acct_id              -- 利息收入支出账户编号
   ,t1.pay_int_acct_id                       -- 付息账户编号
   ,t1.subj_id                               -- 科目编号
   ,t1.int_subj_id                           -- 利息科目编号
   ,t1.bus_breed_id                          -- 业务品种编号
   ,t1.discnt_bus_kind_cd                    -- 贴现业务种类代码
   ,t1.bs_type_cd                            -- 买卖类型代码
   ,t1.bill_med_cd                           -- 票据介质代码
   ,t1.bill_type_cd                          -- 票据类型代码
   ,t1.bs_way_cd                             -- 买卖方式代码
   ,t1.clear_way_cd                          -- 清算方式代码
   ,t1.discnt_status_cd                      -- 贴现状态代码
   ,t1.int_adj_entry_cd                      -- 利息调整记账代码
   ,t1.pay_int_way_cd                        -- 付息方式代码
   ,t1.curr_cd                               -- 币种代码
   ,t1.oper_teller_id                        -- 经办柜员编号
   ,t1.rgst_teller_id                        -- 登记柜员编号
   ,t1.discnt_org_id                         -- 贴现机构编号
   ,t1.draw_org_id                           -- 出票机构编号
   ,t1.mgmt_org_id                           -- 管理机构编号
   ,t1.acct_instit_id                        -- 账务机构编号
   ,t1.discnt_value_dt                       -- 贴现起息日期
   ,t1.discnt_exp_dt                         -- 贴现到期日期
   ,t1.draw_dt                               -- 出票日期
   ,t1.discnt_dt                             -- 贴现日期
   ,t1.discnt_flow_num                       -- 贴现流水号
   ,t1.close_dt                              -- 关闭日期
   ,t1.termnt_dt                             -- 终止日期
   ,t1.close_flow_num                        -- 关闭流水号
   ,t1.last_int_adj_day                      -- 上一利息调整日
   ,t1.next_int_adj_day                      -- 下一利息调整日
   ,t1.int_accr_days                         -- 计息天数
   ,t1.pay_int_amt                           -- 付息金额
   ,t1.int_recvbl                            -- 应收利息
   ,t1.int_adj_bal                           -- 利息调整余额
   ,t1.wrt_off_amt                           -- 核销金额
   ,t1.fac_val_amt                           -- 票面金额
   ,t1.currt_bal                             -- 当期余额
   ,t1.cl_curr_currt_bal                     -- 折本币当期余额
	 ,nvl(t2.currt_bal,0.0)                    -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.ear_m_bal,0.0) end                                                                            -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.ear_s_bal,0.0) end                                                  -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.ear_y_bal,0.0) end                                                                          -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.y_acm_bal,0.0) + t1.currt_bal end                                                                    -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.s_acm_bal,0.0) + t1.currt_bal end                                            -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.m_acm_bal,0.0) + t1.currt_bal end                                                                     -- 月累计余额
   ,t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1)                                                                                                                                                          -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_m_bal,0.0) end                                                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_s_bal,0.0) end                                    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_currt_bal,0.0) else nvl(t2.cl_curr_ear_y_bal,0.0) end                                                            -- 折本币年初余额    
   ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end                           -- 折本币年累计余额
   ,nvl(t2.cl_curr_y_acm_bal,0.0)                                                                                                                                                    -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_m_y_acm_bal,0.0) end                                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_y_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_y_acm_bal,0.0) end                                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
   ,nvl(t2.cl_curr_s_acm_bal,0.0)                                                                                                                                                    -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_s_acm_bal,0.0) else nvl(t2.cl_curr_ear_s_y_acm_bal,0.0) end                   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_s_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_s_acm_bal,0.0) end                                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end                            -- 折本币月累计余额
   ,nvl(t2.cl_curr_m_acm_bal,0.0)                                                                                                                                                   -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_m_acm_bal,0.0) else nvl(t2.cl_curr_ear_m_m_acm_bal,0.0) end                                           -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_m_acm_bal,0.0) else nvl(t2.cl_curr_ear_y_m_acm_bal,0.0) end                                         -- 折本币年初月累计余额
   ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else nvl(t2.y_acm_bal,0.0) + t1.currt_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else nvl(t2.s_acm_bal,0.0) + t1.currt_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else nvl(t2.m_acm_bal,0.0) + t1.currt_bal end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0.0) + t1.currt_bal * nvl(t3.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,t1.job_cd                                                       -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${icl_schema}.cmm_discnt_acct_info_ex t1
	left join ${icl_schema}.cmm_discnt_acct_info t2
		on t1.acct_id = t2.acct_id
		and t2.lp_id = t1.lp_id
		and t2.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
	left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3 
		on t1.curr_cd = t3.curr_cd  
		--and t3.dt = to_date('${batch_date}', 'yyyymmdd')
		and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  	and t3.id_mark <> 'D'
  	and t3.job_cd = 'cbssf1'
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_discnt_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_discnt_acct_info_ex_02;

-- 3.1 drop ex table

whenever sqlerror exit sql.sqlcode;
drop table ${icl_schema}.cmm_discnt_acct_info_ex purge;
drop table ${icl_schema}.cmm_discnt_acct_info_ex_02 purge;



-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_discnt_acct_info',partname => 'p_${batch_date}', degree => 8, cascade => true);  
