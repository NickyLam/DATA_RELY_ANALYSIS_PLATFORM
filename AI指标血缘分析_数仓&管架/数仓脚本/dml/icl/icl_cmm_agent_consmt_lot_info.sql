/*
Purpose:    共性加工层-代理代销份额信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_agent_consmt_lot_info
CreateDate: 20201106
Logs:       20201205 陈伟峰 调整代销基金组取数逻辑
            20211214 陈伟峰 新增第六组家族信托份额数据
            20220501 陈伟峰 新增第七组理财代销份额数据
            20220707 陈伟峰 调整第七组理财代销积数字段关联逻辑，使用ta_tran_acct_id关联
			20220728 温旺清 调整【客户类型代码】口径
			20220820 徐子豪 调整第二组保险主表算法为拉链算法。
			20221011 温旺清 1、新增字段【实际起息日、实际到期日】，增加【实际起息日】做主键；
			                2、调整【本期收益、本日收益、交易冻结份额、长期冻结份额、本地冻结份额、赎回金额、买入成本、总份额】加工逻辑
			20230320 陈伟峰 调整理财一组份额表取数逻辑，加入ROWNUMBER排序取一条
			20230809 陈伟峰 新增字段【组合销售标志、组合产品编号】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_agent_consmt_lot_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_agent_consmt_lot_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_lot_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_lot_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_agent_consmt_lot_info where 0=1;

--第一组（共六组）代销基金
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- TA代码
   ,t1.prod_id                                -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.ta_tran_acct_id                        -- 交易账户编号
   ,'03'                                      -- 代销业务类型代码
   ,t1.bank_acct_id                           -- 资金结算账号
   ,t1.cust_id                                -- 客户编号
   ,t1.cont_id                                -- 合约编号
   ,t1.open_acct_org_id                       -- 归属机构编号
   ,t1.bank_id                                -- 银行编号
   ,t1.seller_id                              -- 销售商编号
   ,t1.ec_idf_cd                              -- 钞汇标志代码
   ,t1.divd_way_cd                            -- 分红方式代码
   ,t1.cust_type_cd                           -- 客户类型代码
   ,'-'                                       -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,null                                      -- 首次认购日期
   ,t1.final_chg_dt                           -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,t1.bonus_ratio                            -- 分红比例
   ,t1.prft_cust_ratio                        -- 收益率
   ,t1.acm_inco                               -- 累计收益
   ,t1.unpaid_prft                            -- 未付收益
   ,t1.froz_unpaid_prft                       -- 冻结未付收益
   ,t1.curr_issue_prft                        -- 本期收益
   ,t1.new_assign_prft                        -- 本日收益
   ,t1.tran_froz_lot                          -- 交易冻结份额
   ,t1.lonterm_froz_lot                       -- 长期冻结份额
   ,t1.loc_froz_lot                           -- 本地冻结份额
   ,t1.yd_lot_tot                             -- 上日总份额
   ,0                                         -- 未确认产品金额
   ,0                                         -- 赎回金额
   ,t1.buy_cost                               -- 买入成本
   ,t1.lot_tot                                -- 总份额
   ,nvl(t2.nav, 1)                            -- 净值
   ,t1.lot_tot * nvl(t2.nav, 1)               -- 当前余额
   ,nvl(t3.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_consmt_fund_lot_h t1
 left join (select prod_id as prd_code,
                   ta_cd as ta_code,
                   prod_nv as nav,
                   start_dt as cfm_date,
                   issue_dt as iss_date,
                   row_number() over(partition by prod_id, ta_cd order by start_dt desc, issue_dt desc) rn
              from ${iml_schema}.prd_consmt_fund_day_sell_h
             where start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
			   and job_cd ='nfssi1') t2
   on t1.prod_id = substr(t2.prd_code,7)
  and t1.ta_cd = t2.ta_code
  and t2.rn = 1
 left join ${icl_schema}.cmm_agent_consmt_lot_info t3
   on t1.ta_cd = t3.ta_cd
  and t1.prod_id = t3.prod_id
  and t1.ta_tran_acct_id = t3.tran_acct_id
  and t1.lp_id = t3.lp_id
  and t3.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'nfssf1'
;
commit;

--第二组（共六组）保险
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- TA代码
   ,t1.prod_id                                -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.insure_pl_id                           -- 交易账户编号
   ,'02'                                      -- 代销业务类型代码
   ,t1.bank_acct_id                           -- 资金结算账号
   ,t1.cust_id                                -- 客户编号
   ,t1.seq_num                                -- 合约编号
   ,t1.org_id                                 -- 归属机构编号
   ,t1.bank_id                                -- 银行编号
   ,'099'                                     -- 销售商编号
   ,'9'                                       -- 钞汇标志代码
   ,'0'                                       -- 分红方式代码
   ,'-'                                       -- 客户类型代码
   ,'-'                                       -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t3.imp_dt                                 -- 首次认购日期
   ,t1.tran_dt                                -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,0                                         -- 分红比例
   ,0                                         -- 收益率
   ,0                                         -- 累计收益
   ,0                                         -- 未付收益
   ,0                                         -- 冻结未付收益
   ,0                                         -- 本期收益
   ,0                                         -- 本日收益
   ,0                                         -- 交易冻结份额
   ,0                                         -- 长期冻结份额
   ,0                                         -- 本地冻结份额
   ,t2.amt                                    -- 上日总份额
   ,t4.amt                                    -- 未确认产品金额
   ,0                                         -- 赎回金额
   ,t5.amt                                    -- 买入成本
   ,t6.amt                                    -- 总份额
   ,1                                         -- 净值
   ,t6.amt                                    -- 当前余额
   ,nvl(t7.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t4.amt else nvl(t7.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t4.amt else nvl(t7.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t4.amt else nvl(t7.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t4.amt else nvl(t7.y_acm_bal,0.0) + (t4.amt) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t4.amt else nvl(t7.s_acm_bal,0.0) + (t4.amt) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t4.amt else nvl(t7.m_acm_bal,0.0) + (t4.amt) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t4.amt else nvl(t7.y_acm_bal,0.0) + (t4.amt) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t4.amt else nvl(t7.s_acm_bal,0.0) + (t4.amt) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t4.amt else nvl(t7.m_acm_bal,0.0) + (t4.amt) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_insure_pl t1
 left join ${iml_schema}.agt_amt_h t2
   on t1.agt_id = t2.agt_id
  and t2.amt_type_cd = '004003'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd') - 1
  and t2.end_dt > to_date('${batch_date}','yyyymmdd') - 1
  and t2.job_cd = 'inssf1'
 left join ${iml_schema}.agt_imp_dt_h t3
   on t1.agt_id = t3.agt_id
  and t3.dt_type_cd = '54'
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'inssf1'
 left join ${iml_schema}.agt_amt_h t4
   on t1.agt_id = t4.agt_id
  and t4.amt_type_cd = '004002'
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  and t4.job_cd = 'inssf1'
 left join ${iml_schema}.agt_amt_h t5
   on t1.agt_id = t5.agt_id
  and t5.amt_type_cd = '004001'
  and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t5.end_dt > to_date('${batch_date}','yyyymmdd')
  and t5.job_cd = 'inssf1'
 left join ${iml_schema}.agt_amt_h t6
   on t1.agt_id = t6.agt_id
  and t6.amt_type_cd = '004003'
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  and t6.job_cd = 'inssf1'
 left join ${icl_schema}.cmm_agent_consmt_lot_info t7
   on t1.ta_cd = t7.ta_cd
  and t1.prod_id = t7.prod_id
  and t1.insure_pl_id = t7.tran_acct_id
  and t1.lp_id = t7.lp_id
  and t7.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'inssf1'
;
commit;

--第三组（共六组）七兴宝
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- TA代码
   ,t1.fund_cd_id                             -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.tran_acct_num                          -- 交易账户编号
   ,'01'                                      -- 代销业务类型代码
   ,''                                        -- 资金结算账号
   ,t1.fund_cust_id                           -- 客户编号
   ,''                                        -- 合约编号
   ,''                                        -- 归属机构编号
   ,t1.ibank_no                               -- 银行编号
   ,'099'                                     -- 销售商编号
   ,'9'                                       -- 钞汇标志代码
   ,'0'                                       -- 分红方式代码
   ,'-'                                       -- 客户类型代码
   ,t1.lot_type_cd                            -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t1.fir_subscr_dt                          -- 首次认购日期
   ,null                                      -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,0                                         -- 分红比例
   ,0                                         -- 收益率
   ,t1.acm_prft                               -- 累计收益
   ,t1.unpay_turn_prft                        -- 未付收益
   ,0                                         -- 冻结未付收益
   ,0                                         -- 本期收益
   ,0                                         -- 本日收益
   ,t1.tran_froz_lot                          -- 交易冻结份额
   ,t1.froz_lot                               -- 长期冻结份额
   ,t1.bank_froz_lot                          -- 本地冻结份额
   ,t2.prod_lot                               -- 上日总份额
   ,t1.uncfm_prod_amt                         -- 未确认产品金额
   ,t1.redem_amt                              -- 赎回金额
   ,t1.buy_cost                               -- 买入成本
   ,t1.prod_lot                               -- 总份额
   ,1                                         -- 净值
   ,t1.prod_lot                               -- 当前余额
   ,nvl(t3.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.prod_lot else nvl(t3.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.prod_lot else nvl(t3.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.prod_lot else nvl(t3.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.prod_lot else nvl(t3.y_acm_bal,0.0) + (t1.prod_lot) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.prod_lot else nvl(t3.s_acm_bal,0.0) + (t1.prod_lot) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.prod_lot else nvl(t3.m_acm_bal,0.0) + (t1.prod_lot) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.prod_lot else nvl(t3.y_acm_bal,0.0) + (t1.prod_lot) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.prod_lot else nvl(t3.s_acm_bal,0.0) + (t1.prod_lot) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.prod_lot else nvl(t3.m_acm_bal,0.0) + (t1.prod_lot) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_qxb_bal_lot_h t1
 left join ${iml_schema}.agt_qxb_bal_lot_h t2
   on t1.ibank_no = t2.ibank_no
  and t1.tran_acct_num = t2.tran_acct_num
  and t1.fund_cd_id = t2.fund_cd_id
  and t1.ta_cd = t2.ta_cd
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd') - 1
  and t2.end_dt > to_date('${batch_date}','yyyymmdd') - 1
  and t2.id_mark = 'fsmsi1'
 left join ${icl_schema}.cmm_agent_consmt_lot_info t3
   on t1.ta_cd = t3.ta_cd
  and t1.fund_cd_id = t3.prod_id
  and t1.tran_acct_num = t3.tran_acct_id
  and t1.lp_id = t3.lp_id
  and t3.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') - 1
  and t1.end_dt > to_date('${batch_date}','yyyymmdd') - 1
	and t1.job_cd = 'fsmsi1'
;
commit;

--第四组（共六组）信托资管
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- TA代码
   ,t1.prod_id                                -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.ta_tran_acct_id                        -- 交易账户编号
   ,'04'                                      -- 代销业务类型代码
   ,t1.bank_acct_id                           -- 资金结算账号
   ,t1.cust_id                                -- 客户编号
   ,t1.cont_id                                -- 合约编号
   ,t1.open_acct_org_id                       -- 归属机构编号
   ,t1.bank_id                                -- 银行编号
   ,t1.seller_id                              -- 销售商编号
   ,t1.ec_idf_cd                              -- 钞汇标志代码
   ,t1.divd_way_cd                            -- 分红方式代码
   ,t1.cust_type_cd                           -- 客户类型代码
   ,'-'                                       -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,null                                      -- 首次认购日期
   ,t1.final_chg_dt                           -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,t1.bonus_ratio                            -- 分红比例
   ,t1.prft_cust_ratio                        -- 收益率
   ,t1.acm_inco                               -- 累计收益
   ,t1.unpaid_prft                            -- 未付收益
   ,t1.froz_unpaid_prft                       -- 冻结未付收益
   ,t1.curr_issue_prft                        -- 本期收益
   ,t1.new_assign_prft                        -- 本日收益
   ,t1.tran_froz_lot                          -- 交易冻结份额
   ,t1.lonterm_froz_lot                       -- 长期冻结份额
   ,t1.loc_froz_lot                           -- 本地冻结份额
   ,t1.yd_lot_tot                             -- 上日总份额
   ,0                                         -- 未确认产品金额
   ,0                                         -- 赎回金额
   ,t1.buy_cost                               -- 买入成本
   ,t1.lot_tot                                -- 总份额
   ,nvl(t2.nav, 1)                            -- 净值
   ,t1.lot_tot * nvl(t2.nav, 1)               -- 当前余额
   ,nvl(t3.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t2.nav, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot_tot * nvl(t2.nav, 1)) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_trust_lot_h t1
 left join (select prod_id as prd_code,
                   ta_cd as ta_code,
                   prod_nv as nav,
                   start_dt as cfm_date,
                   issue_dt as iss_date,
                   row_number() over(partition by prod_id, ta_cd order by start_dt desc, issue_dt desc) rn
              from ${iml_schema}.prd_trust_day_sell_h
             where start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and job_cd = 'trusi1') t2
   on t1.prod_id = substr(t2.prd_code,7)
  and t1.ta_cd = t2.ta_code
  and t2.rn = 1
 left join ${icl_schema}.cmm_agent_consmt_lot_info t3
   on t1.ta_cd = t3.ta_cd
  and t1.prod_id = t3.prod_id
  and t1.ta_tran_acct_id = t3.tran_acct_id
  and t1.lp_id = t3.lp_id
  and t3.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'trusf1'
;
commit;

--第五组（共六组）盈米
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.mercht_id                              -- TA代码
   ,t1.fund_cd                                -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.ym_riches_acct_id                      -- 交易账户编号
   ,'05'                                      -- 代销业务类型代码
   ,t1.acct_id                                -- 资金结算账号
   ,t3.cust_id                                -- 客户编号
   ,t1.lot_id                                 -- 合约编号
   ,''                                        -- 归属机构编号
   ,''                                        -- 银行编号
   ,'099'                                     -- 销售商编号
   ,'9'                                       -- 钞汇标志代码
   ,t1.divd_way_cd                            -- 分红方式代码
   ,'-'                                       -- 客户类型代码
   ,'-'                                       -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,null                                      -- 首次认购日期
   ,null                                      -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,0                                         -- 分红比例
   ,0                                         -- 收益率
   ,t1.acm_prft                               -- 累计收益
   ,t1.unpaid_prft                            -- 未付收益
   ,0                                         -- 冻结未付收益
   ,t1.curr_prft                              -- 本期收益
   ,0                                         -- 本日收益
   ,0                                         -- 交易冻结份额
   ,t1.froz_lot                               -- 长期冻结份额
   ,0                                         -- 本地冻结份额
   ,0                                         -- 上日总份额
   ,0                                         -- 未确认产品金额
   ,0                                         -- 赎回金额
   ,0                                         -- 买入成本
   ,t1.lot_tot                                -- 总份额
   ,nvl(t4.corp_nv, 1)                        -- 净值
   ,t1.lot_tot * nvl(t4.corp_nv, 1)           -- 当前余额
   ,nvl(t5.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.y_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.s_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.m_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.y_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.s_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot_tot * nvl(t4.corp_nv, 1) else nvl(t5.m_acm_bal,0.0) + (t1.lot_tot * nvl(t4.corp_nv, 1)) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_ym_fund_lot_h t1
 left join ${iml_schema}.agt_ym_fund_lot_h t2
 	 on t1.mercht_id = t2.mercht_id
 	and t1.fund_cd = t2.fund_cd
 	and t1.ym_riches_acct_id = t2.ym_riches_acct_id
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd') - 1
  and t2.end_dt > to_date('${batch_date}','yyyymmdd') - 1
  and t2.job_cd = 'mpcsf1'
 left join ${iml_schema}.agt_ym_fund_acct t3
   on t1.ym_riches_acct_id = t3.ym_riches_acct_id
  and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.id_mark <> 'D'
  and t3.job_cd = 'mpcsf1'
 left join (select mercht_id,
                   fund_cd,
                   nv_dt,
                   corp_nv,
                   acm_nv,
                   row_number() over(partition by mercht_id, fund_cd order by nv_dt desc) rn
              from ${iml_schema}.prd_ym_fund_nv_info
             where create_dt <= to_date('${batch_date}', 'yyyymmdd')
               and id_mark <> 'D'
               and job_cd= 'mpcsf1'
               and nv_dt <= to_date('${batch_date}', 'yyyymmdd')) t4
   on t1.mercht_id = t4.mercht_id
  and t1.fund_cd = t4.fund_cd
  and t4.rn = 1
 left join ${icl_schema}.cmm_agent_consmt_lot_info t5
   on t1.mercht_id = t5.ta_cd
  and t1.fund_cd = t5.prod_id
  and t1.ym_riches_acct_id = t5.tran_acct_id
  and t1.lp_id = t5.lp_id
  and t5.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'mpcsf1'
;
commit;


--第六组（共六组）家族信托
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,'-'                                       -- ta代码
   ,t1.prod_id                                -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.prod_id                                -- 交易账户编号
   ,'06'                                      -- 代销业务类型代码
   ,' '                                       -- 资金结算账号
   ,t1.cust_id                                -- 客户编号
   ,' '                                       -- 合约编号
   ,' '                                       -- 归属机构编号
   ,' '                                       -- 银行编号
   ,' '                                       -- 销售商编号
   ,'9'                                       -- 钞汇标志代码
   ,'-'                                       -- 分红方式代码
   ,'1'                                       -- 客户类型代码
   ,'0'                                       -- 份额类型代码
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,''                                        -- 首次认购日期
   ,''                                        -- 最后动户日期
   ,to_date('19000101','yyyymmdd')            -- 实际起息日期
   ,to_date('29991231','yyyymmdd')            -- 实际到期日期
   ,0                                         -- 分红比例
   ,0                                         -- 收益率
   ,0                                         -- 累计收益
   ,0                                         -- 未付收益
   ,0                                         -- 冻结未付收益
   ,0                                         -- 本期收益
   ,0                                         -- 本日收益
   ,0                                         -- 交易冻结份额
   ,0                                         -- 长期冻结份额
   ,0                                         -- 本地冻结份额
   ,nvl(t3.tot_lot,0)                         -- 上日总份额
   ,0                                         -- 未确认产品金额
   ,0                                         -- 赎回金额
   ,0                                         -- 买入成本
   ,t1.lot                                    -- 总份额
   ,nvl(t2.corp_nv, 1)                        -- 净值
   ,t1.lot * nvl(t2.corp_nv, 1)               -- 当前余额
   ,nvl(t3.curr_bal,0.0)                      -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.y_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.s_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then t1.lot * nvl(t2.corp_nv, 1) else nvl(t3.m_acm_bal,0.0) + (t1.lot * nvl(t2.corp_nv, 1)) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_family_trust_lot_h t1	
 left join ${iml_schema}.prd_prod_nv t2	 
   on t1.nv_id=t2.nv_id
  and t2.job_cd = 'nfssi1'
 left join ${icl_schema}.cmm_agent_consmt_lot_info t3
   on t1.prod_id = t3.prod_id
  and t1.prod_id = t3.tran_acct_id
  and t1.lp_id = t3.lp_id
  and t3.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
  and t3.ta_cd ='-'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'nfssf1'
;
commit;



--第六组（共六组）理财代销
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_lot_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,ta_cd                                    -- TA代码
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,tran_acct_id                             -- 交易账户编号
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,cap_stl_acct_num                         -- 资金结算账号
   ,cust_id                                  -- 客户编号
   ,cont_id                                  -- 合约编号
   ,belong_org_id                            -- 归属机构编号
   ,bank_id                                  -- 银行编号
   ,seller_id                                -- 销售商编号
   ,ec_flg_cd                                -- 钞汇标志代码
   ,divd_way_cd                              -- 分红方式代码
   ,cust_type_cd                             -- 客户类型代码
   ,lot_type_cd                              -- 份额类型代码
   ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,fir_subscr_dt                            -- 首次认购日期
   ,final_activ_acct_dt                      -- 最后动户日期
   ,actl_value_dt                            -- 实际起息日期
   ,actl_exp_dt                              -- 实际到期日期
   ,divd_ratio                               -- 分红比例
   ,yld_rat                                  -- 收益率
   ,acm_prft                                 -- 累计收益
   ,unpaid_prft                              -- 未付收益
   ,froz_unpaid_prft                         -- 冻结未付收益
   ,curr_issue_prft                          -- 本期收益
   ,td_prft                                  -- 本日收益
   ,tran_froz_lot                            -- 交易冻结份额
   ,lonterm_froz_lot                         -- 长期冻结份额
   ,loc_froz_lot                             -- 本地冻结份额
   ,ld_tot_lot                               -- 上日总份额
   ,uncfm_prod_amt                           -- 未确认产品金额
   ,redem_amt                                -- 赎回金额
   ,buy_cost                                 -- 买入成本
   ,tot_lot                                  -- 总份额
   ,nv                                       -- 净值
   ,curr_bal                                 -- 当前余额
   ,ear_d_bal                                -- 日初余额
   ,ear_m_bal                                -- 月初余额
   ,ear_s_bal                                -- 季初余额
   ,ear_y_bal                                -- 年初余额
   ,y_acm_bal                                -- 年累计余额
   ,s_acm_bal                                -- 季累计余额
   ,m_acm_bal                                -- 月累计余额
   ,y_avg_bal                                -- 年日均余额
   ,q_avg_bal                                -- 季日均余额
   ,m_avg_bal                                -- 月日均余额
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- ta代码
   ,t1.prod_id                                -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.ta_tran_acct_id                        -- 交易账户编号
   ,'07'                                      -- 代销业务类型代码
   ,t1.bank_acct_id                           -- 资金结算账号
   ,t1.bank_cust_id                           -- 客户编号
   ,t1.cont_id                                -- 合约编号
   ,t1.tran_belong_org_id                     -- 归属机构编号
   ,t1.bank_id                                -- 银行编号
   ,t1.seller_cd                              -- 销售商编号
   ,t1.ec_flg                                 -- 钞汇标志代码
   ,t2.allow_divd_way_cd                      -- 分红方式代码
   ,nvl(t3.cust_type_cd,'-')                  -- 客户类型代码
   ,''                                        -- 份额类型代码
   ,case when t6.comb_prod_id is not null then '1' else '0' end    -- 组合销售标志      
   ,t6.comb_prod_id                              -- 组合产品编号                
   ,${iml_schema}.dateformat_min(t4.trans_date)  -- 首次认购日期
   ,t1.final_tran_dt                          -- 最后动户日期
   ,case when t2.prod_tepla_id = 'D315' 
         then t5.cfm_date else t2.prod_value_dt end      -- 实际起息日期
   ,case when t2.prod_tepla_id = 'D315' 
         then t5.end_date else t2.prod_end_dt end        -- 实际到期日期
   ,0                                         -- 分红比例
   ,t2.expe_yld_rat                           -- 收益率
   ,0                                         -- 累计收益
   ,0                                         -- 未付收益
   ,0                                         -- 冻结未付收益
   ,nvl(t99.curr_issue_prft,0)+nvl(t5.tot_vol,t1.lot_tot)*(nvl(t2.prod_nv,1)-1)    -- 本期收益
   ,nvl(t5.tot_vol,t1.lot_tot)*(nvl(t2.prod_nv,1)-1)          -- 本日收益
   ,nvl(t5.frozen_vol,t1.froz_lot)                            -- 交易冻结份额
   ,nvl(t5.long_frozen_vol,t1.lonterm_froz_lot)               -- 长期冻结份额
   ,nvl(t5.other_frozen,t1.loc_froz_lot)                      -- 本地冻结份额
   ,nvl(t99.tot_lot,0)                                        -- 上日总份额
   ,0                                                         -- 未确认产品金额
   ,nvl(t5.cost,t1.buy_cost_amt) - nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)   -- 赎回金额
   ,nvl(t5.cost,t1.buy_cost_amt)                              -- 买入成本
   ,nvl(t5.tot_vol,t1.lot_tot)                                -- 总份额
   ,nvl(t2.prod_nv,1)                                         -- 净值
   ,nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)              -- 当前余额
   ,nvl(t99.curr_bal,0)                                       -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.ear_m_bal,0.0) end                               -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.ear_s_bal,0.0) end     -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.ear_y_bal,0.0) end                             -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.y_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end                             -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.s_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end     -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.m_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end                               -- 月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.y_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                              -- 年日均余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.s_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)      -- 季日均余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1) else nvl(t99.m_acm_bal,0.0) + (nvl(t5.tot_vol,t1.lot_tot)*nvl(t2.prod_nv,1)) end/to_number(substr('${batch_date}', 7, 2))                                                                                       -- 月日均余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.agt_finc_lot_h t1	
 left join ${iml_schema}.prd_finc t2	
   on t1.prod_id = t2.finc_prod_id
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
	and t2.job_cd = 'ifmsf1'
	and t2.id_mark <> 'D'
 left join ${iml_schema}.agt_finc_acct t3	
   on t1.finc_acct_id = t3.finc_acct_id
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t3.end_dt > to_date('${batch_date}','yyyymmdd')
	and t3.job_cd = 'ifmsf1'
	and trim(t3.finc_acct_id) is not null  --代销账户开户确认是T+1，存在账号为空的情况，会导致关联重复
	and t3.ta_cd not in ('GDHX','GJS','HX')
	and t1.ta_cd=t3.ta_cd
 left join (select ta_tran_acct_id
                  ,min(tran_dt) as trans_date
              from ${iml_schema}.evt_finc_tran_cfm  
             where ta_cd not in ('GDHX','GJS','HX')
               and job_cd ='ifmsi1'
             group by ta_tran_acct_id) t4
   on t1.ta_tran_acct_id = t4.ta_tran_acct_id
 left join (select tb.ta_client,
                   tb.ta_code,
                   tb.prd_code,
                   ${iml_schema}.dateformat_max(trim(tb.cfm_date)) as cfm_date,
                   ${iml_schema}.dateformat_max(trim(tb.end_date)) as end_date,
                   sum(tb.tot_vol) as tot_vol,
                   sum(tb.cost) as cost,
                   sum(tb.frozen_vol) as frozen_vol,
                   sum(tb.long_frozen_vol) as long_frozen_vol,
                   sum(tb.other_frozen) as other_frozen,
                   row_number() over(partition by tb.ta_client, tb.prd_code, tb.cfm_date order by tb.end_date desc) as rn
              from ${iol_schema}.ifms_tbsharedetail0 tb
             where tb.start_dt <= to_date('${batch_date}','yyyymmdd')
	             and tb.end_dt > to_date('${batch_date}','yyyymmdd')
	             and exists (select 1 from ${iml_schema}.prd_finc t2 
	                          where t2.prod_tepla_id = 'D315'
	                            and t2.finc_prod_id=tb.prd_code 
	                            and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
	                            and t2.job_cd = 'ifmsf1'
	                            and t2.id_mark <> 'D')
             group by tb.ta_client,tb.ta_code,tb.prd_code,tb.cfm_date,tb.end_date) t5
   on t1.ta_tran_acct_id = t5.ta_client 
  and t1.prod_id = t5.prd_code
  and t1.ta_cd=t5.ta_code
  and t5.rn=1
left join ${icl_schema}.cmm_agent_consmt_lot_info t99
   on /*t99.ta_cd=t1.ta_cd
  and */t99.prod_id=t1.prod_id
  and t99.tran_acct_id=t1.ta_tran_acct_id   --ta_tran_acct_id
  and t99.consmt_bus_type_cd='07'
  and t99.etl_dt =to_date('${batch_date}','yyyymmdd')-1
  and t99.actl_value_dt = (case when t2.prod_tepla_id = 'D315' 
  then t5.cfm_date else t2.prod_value_dt end)
left join ${iml_schema}.agt_comb_prod_post_info_h t6
   on t1.ta_cd=t6.ta_cd
  and t1.prod_id = t6.dtl_prod_id
  and t1.ta_tran_acct_id = t6.ta_tran_acct_id
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t6.end_dt > to_date('${batch_date}','yyyymmdd')
	and t6.job_cd = 'nfssf1'
where t1.ta_cd not in ('GDHX','GJS','HX')
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'ifmsf1'
;
commit;



-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_agent_consmt_lot_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_agent_consmt_lot_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_lot_info_ex purge;



-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_agent_consmt_lot_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
