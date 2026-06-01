/*
Purpose:    共性加工层-代理代销交易明细
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_agent_consmt_tran_dtl
CreateDate: 20200724
Logs:   20201123 陈伟峰 增加字段【交易手续费】
        20201127 陈伟峰 增加字段【关联流水号】
        20210120 陈伟峰 调整基金和信托组的字段取值【手续费】->【银行手续费】,调整盈米组交易类型代码 ->indent_status_cd
        20210305 陈伟峰 调整理财组关联条件，t2.prod_id->t2.init_prod_id
        20210319 周沁晖 调整【金融产品代销交易明细】分组【确认份额】、【确认金额】字段
        20210618 陈伟峰 调整evt_ym_tran_flow算法改为全量拉链
        20210817 何桐金 增加【产品净值】字段
        20211223 陈伟峰 剔除代理保险和家族信托交易数据
        20220111 陈伟峰 新增字段【交易归属机构编号】、【交易代理费】
        20220428 陈伟峰 新增理财代销业务数据来源
        20230809 陈伟峰 新增字段【组合销售标志、组合产品编号】
        20260123 陈伟峰 调整基金的产品名称取值逻辑，财富平台做基金产品迁移时互换了名称
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_agent_consmt_tran_dtl drop partition p_${retain_day};
alter table ${icl_schema}.cmm_agent_consmt_tran_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_tran_dtl_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_tran_dtl_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_agent_consmt_tran_dtl where 0=1;

--共五组（第一组）七兴宝交易明细
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
   ,tran_agent_fee                           -- 交易代理费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
	 ,tran_belong_org_id                       -- 交易归属机构编号
	 ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.ta_cd                                  -- ta代码
	 ,t1.cfm_dt                                 -- ta确认日期
	 ,t1.ta_cfm_flow_num                        -- ta确认流水号
	 ,''                                        -- 关联流水号
	 ,t1.appl_form_id                           -- 申请单编号
	 ,t1.init_appl_form_id                      -- 原申请单编号
	 ,t1.cust_id                                -- 客户编号
	 ,t1.fund_acct_id                           -- 产品账户编号
	 ,t1.tran_acct_id                           -- 交易账户编号
	 ,t1.bank_card_num                          -- 银行账户编号
	 ,t1.prod_id                                -- 产品编号
	 ,''                                        -- 标准产品编号
	 ,t2.fund_abbr  														-- 产品名称
	 ,''                                        -- 客户经理编号
	 ,'01'                                      -- 代销业务类型代码
	 ,t1.sell_mode_cd                           -- 销售模式代码
	 ,t1.bus_cd                                 -- 业务代码
	 ,t1.cust_type_cd                           -- 客户类型代码
	 ,t1.curr_cd                                -- 币种代码
	 ,t1.divd_way_cd                            -- 分红方式代码
	 ,t1.huge_redem_proc_cd                     -- 巨额赎回处理代码
	 ,t1.accpt_way_cd                           -- 交易渠道代码
	 ,'-'                                        -- 交易状态代码
	 ,''                                        -- 交易代码
	 ,t1.appl_lot                               -- 申请份额
	 ,t1.appl_amt                               -- 申请金额
	 ,t1.tran_cfm_lot                           -- 确认份额
	 ,t1.tran_cfm_amt                           -- 确认金额
	 ,1                                         -- 产品净值
   ,t1.comm_fee                               -- 交易手续费
   ,t1.agent_fee                              -- 交易代理费
	 ,t1.return_code                            -- 交易返回码
	 ,t1.return_info                            -- 交易返回信息
	 ,t1.tran_happ_subrch_id                    -- 交易支行编号
	 ,t1.tran_happ_brac_id                      -- 交易机构编号
	 ,''                                        -- 交易柜员编号
	 ,''                                        -- 授权柜员编号
	 ,t1.tran_happ_dt                           -- 交易发生日期
	 ,t1.tran_happ_tm                           -- 交易发生时间
	 ,''                                        -- 交易归属机构编号
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.evt_qxb_tran_cfm_h t1
left join ${iml_schema}.prd_qxb_prod_info t2
	on t1.ta_cd = t2.ta_cd
 and t1.prod_id = t2.sell_mode_cd
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.job_cd = 'fsmsf1'
 and t2.id_mark <> 'D'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.cfm_dt = to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'fsmsf1'
;
commit;

/*
--共五组（第二组）代理保险交易明细
whenever sqlerror exit sql.sqlcode;
insert  into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
	 ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
	 ,t1.ta_cd          												-- ta代码
	 ,t1.tran_dt        												-- ta确认日期
	 ,t1.flow_num       												-- ta确认流水号
	 ,t1.rela_flow_num                          -- 关联流水号
	 ,t1.flow_num       												-- 申请单编号
	 ,t1.rela_flow_num  												-- 原申请单编号
	 ,t1.cust_id      													-- 客户编号
	 ,t1.insure_pl_num  												-- 产品账户编号
	 ,t1.bank_acct_id   												-- 交易账户编号
	 ,t1.bank_acct_id   												-- 银行账户编号
	 ,t1.prod_id        												-- 产品编号
	 ,t1.std_prod_id                            -- 标准产品编号
	 ,t2.prod_name 															-- 产品名称
	 ,t1.cust_mgr_id    												-- 客户经理编号
	 ,'02'              												-- 代销业务类型代码
	 ,'1'               												-- 销售模式代码
	 ,''                												-- 业务代码
	 ,t1.cust_type_cd   												-- 客户类型代码
	 ,t1.curr_cd        												-- 币种代码
	 ,''                												-- 分红方式代码
	 ,''                												-- 巨额赎回处理代码
	 ,t1.tran_chn_cd    												-- 交易渠道代码
	 ,t1.tran_status_cd 												-- 交易状态代码
	 ,t1.tran_cd        												-- 交易代码
	 ,0                 												-- 申请份额
	 ,t1.tran_amt       												-- 申请金额
	 ,0                 												-- 确认份额
	 ,t1.tran_amt       												-- 确认金额
	 ,1                                       -- 产品净值
   ,t1.comm_fee                               -- 交易手续费
	 ,t1.return_code       											-- 交易返回码
	 ,t1.return_info    												-- 交易返回信息
	 ,''                												-- 交易支行编号
	 ,t1.tran_org_id    												-- 交易机构编号
	 ,t1.operr_id 															-- 交易柜员编号
	 ,t1.auth_teller_id      										-- 授权柜员编号
	 ,t1.host_dt        												-- 交易发生日期
	 ,iml.timeformat_max(to_char(t1.tran_dt,'yyyy-mm-dd')||t1.tran_tm) -- 交易发生时间
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.evt_insure_tran_flow t1
left join ${iml_schema}.prd_insure_prod t2
	on t1.ta_cd = t2.ta_cd
 and t1.prod_id = t2.prod_id
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'inssf1'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.tran_dt = to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'inssf1'
;
commit;
*/

--共五组（第三组）金融产品代销交易明细
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
   ,tran_agent_fee                           -- 交易代理费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
	 ,tran_belong_org_id                       -- 交易归属机构编号
	 ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
	 ,t1.ta_cd                              		-- ta代码
	 ,t1.cfm_dt                             		-- ta确认日期
	 ,t1.ta_cfm_flow_num                    		-- ta确认流水号
   ,t1.rela_flow_num                          -- 关联流水号
	 ,t1.ta_cfm_flow_num                    		-- 申请单编号
	 ,t1.init_cfm_flow_num                      -- 原申请单编号
	 ,t1.cust_id                            		-- 客户编号
	 ,t1.finc_acct_id                       		-- 产品账户编号
	 ,t1.ta_tran_acct_id                    		-- 交易账户编号
	 ,t1.bank_acct_id                       		-- 银行账户编号
	 ,t1.finc_prod_id                       		-- 产品编号
	 ,t2.std_prod_id                            -- 标准产品编号
	 ,t2.prod_descb 			        			-- 产品名称
	 ,t1.cust_mgr_id                        		-- 客户经理编号
	 ,'03'                                  		-- 代销业务类型代码
	 ,'1'                                   		-- 销售模式代码
	 ,t1.bus_cd                             		-- 业务代码
	 ,t1.cust_type_cd                       		-- 客户类型代码
	 ,t1.curr_cd                            		-- 币种代码
	 ,t1.divd_way_cd                        		-- 分红方式代码
	 ,t1.huge_redem_proc_cd                 		-- 巨额赎回处理代码
	 ,t1.tran_chn_cd                        		-- 交易渠道代码
	 ,t1.tran_status_cd                     		-- 交易状态代码
	 ,t1.tran_code                          		-- 交易代码
	 ,t1.tran_lot                           		-- 申请份额
	 ,t1.tran_amt                           		-- 申请金额
	 ,t1.cfm_lot                            		-- 确认份额
	 ,t1.cfm_amt                            		-- 确认金额
	 ,t1.prod_nv                                -- 产品净值
   ,t1.bank_comm_fee                          -- 交易手续费
   ,t1.agent_fee                              -- 交易代理费
	 ,t1.return_code                         		-- 交易返回码
	 ,t1.return_info                        		-- 交易返回信息
	 ,''                                    		-- 交易支行编号
	 ,t1.tran_org_id                        		-- 交易机构编号
	 ,t1.tran_teller_id                     		-- 交易柜员编号
	 ,t1.tran_teller_id                     		-- 授权柜员编号
	 ,t1.appl_dt                            		-- 交易发生日期
	 ,t1.appl_tm                            		-- 交易发生时间
	 ,t1.tran_belong_org_id                     -- 交易归属机构编号
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.evt_consmt_fund_tran_cfm_evt t1
left join ${iml_schema}.prd_consmt_fund_prod t2
	on t1.ta_cd = t2.ta_cd
 and t1.finc_prod_id = t2.init_prod_id
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'nfssf1'
where t1.cfm_dt = to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'nfssi1'
;
commit;

--共五组（第四组）信托资管交易明细
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
   ,tran_agent_fee                           -- 交易代理费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
	 ,tran_belong_org_id                       -- 交易归属机构编号
	 ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
	 ,t1.ta_cd                                  -- ta代码
	 ,t1.cfm_dt                                 -- ta确认日期
	 ,t1.ta_cfm_flow_num                        -- ta确认流水号
   ,t1.rela_flow_num                          -- 关联流水号
	 ,t1.ta_cfm_flow_num                        -- 申请单编号
	 ,t1.init_cfm_flow_num                      -- 原申请单编号
	 ,t1.cust_id                                -- 客户编号
	 ,t1.finc_acct_id                           -- 产品账户编号
	 ,t1.ta_tran_acct_id                        -- 交易账户编号
	 ,t1.bank_acct_id                           -- 银行账户编号
	 ,t1.prod_id                                -- 产品编号
	 ,t2.std_prod_id                            -- 标准产品编号
	 ,t2.prod_name 															-- 产品名称
	 ,t1.cust_mgr_id                            -- 客户经理编号
	 ,'04'                                      -- 代销业务类型代码
	 ,'1'                                       -- 销售模式代码
	 ,t1.bus_cd                                 -- 业务代码
	 ,t1.cust_type_cd                           -- 客户类型代码
	 ,t1.stl_curr_cd                            -- 币种代码
	 ,t1.divd_way_cd                            -- 分红方式代码
	 ,t1.need_huge_redem_proc_flg               -- 巨额赎回处理代码
	 ,t1.tran_chn_cd                            -- 交易渠道代码
	 ,t1.tran_status_cd                         -- 交易状态代码
	 ,t1.tran_cd                                -- 交易代码
	 ,t1.tran_lot                               -- 申请份额
	 ,t1.tran_amt                               -- 申请金额
	 ,t1.cfm_lot                                -- 确认份额
	 ,t1.cfm_amt                                -- 确认金额
	 ,t1.prod_nv                                -- 产品净值
   ,t1.bank_comm_fee                          -- 交易手续费
   ,t1.agent_fee                              -- 交易代理费
	 ,t1.return_code                            -- 交易返回码
	 ,t1.err_info                               -- 交易返回信息
	 ,''                                        -- 交易支行编号
	 ,t1.tran_org_id                            -- 交易机构编号
	 ,t1.tran_teller_id                         -- 交易柜员编号
	 ,t1.tran_teller_id                         -- 授权柜员编号
	 ,t1.tran_dt                                -- 交易发生日期
	 ,iml.timeformat_max(to_char(t1.tran_dt,'yyyy-mm-dd')||substr(trim(t1.tran_tm), 1, 2) || ':' ||substr(trim(t1.tran_tm), 3, 2)|| ':' ||substr(trim(t1.tran_tm), 5, 2)) -- 交易发生时间
	 ,t1.open_acct_org_id                       -- 交易归属机构编号
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.evt_trust_tran_cfm_evt t1
left join ${iml_schema}.prd_trust_prod t2
	on t1.ta_cd = t2.ta_cd
 and t1.prod_id = t2.init_prod_id
 and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'trusf1'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'trusf1'
	and t1.cfm_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

--共五组（第五组）盈米
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
   ,tran_agent_fee                           -- 交易代理费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
	 ,tran_belong_org_id                       -- 交易归属机构编号
	 ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.mercht_id                              -- TA代码
   ,t1.tran_tm                                -- TA确认日期
   ,t1.tran_flow_num                          -- TA确认流水号
   ,''                                        -- 关联流水号
   ,t1.fe_req_flow_num                        -- 申请单编号
   ,t1.fe_req_flow_num                        -- 原申请单编号
   ,t1.cust_id                                -- 客户编号
   ,''                                        -- 产品账户编号
   ,t1.ym_fund_acct_id                        -- 交易账户编号
   ,''                                        -- 银行账户编号
   ,t1.fund_cd                                -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.fund_name                              -- 产品名称
   ,t2.cust_mgr_id                            -- 客户经理编号
   ,'05'                                      -- 代销业务类型代码
   ,'1'                                       -- 销售模式代码
   ,t1.prod_buy_type_cd                       -- 业务代码
   ,'1'                                      -- 客户类型代码
   ,t1.curr_cd                                -- 币种代码
   ,t1.prod_divd_way_cd                       -- 分红方式代码
   ,t1.huge_redem_proc_flg_cd                 -- 巨额赎回处理代码
   ,t1.tran_chn_cd                            -- 交易渠道代码
   ,t1.indent_status_cd                       -- 交易状态代码
   ,t1.tran_cfm_cd                            -- 交易代码
   ,t1.tran_lot                               -- 申请份额
   ,t1.tran_amt                               -- 申请金额
   ,t1.sucsed_lot                             -- 确认份额
   ,t1.sucsed_amt                             -- 确认金额
   ,1                                         -- 产品净值
   ,0                                         -- 交易手续费
   ,0                                         -- 交易代理费
   ,t1.err_cd                                 -- 交易返回码
   ,t1.err_info_desc                          -- 交易返回信息
   ,nvl(t1.tran_out_org_id, t1.tran_in_org_id)-- 交易支行编号
   ,nvl(t1.tran_out_org_id, t1.tran_in_org_id)-- 交易机构编号
   ,''                                        -- 交易柜员编号
   ,''                                        -- 授权柜员编号
   ,t1.upp_host_dt                            -- 交易发生日期
   ,t1.tran_tm                                -- 交易发生时间
	 ,''                                        -- 交易归属机构编号
   ,'0'                                       -- 组合销售标志
   ,''                                        -- 组合产品编号
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.evt_ym_tran_flow t1
 left join ${iml_schema}.agt_ym_fund_acct t2
 	 on t1.ym_fund_acct_id = t2.ym_riches_acct_id
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.id_mark <> 'D'
  and t2.job_cd = 'mpcsf1'
where t1.job_cd = 'mpcsf1'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
	and trunc(t1.tran_tm) = to_date('${batch_date}','yyyymmdd')
;
commit;

/*
--共六组（第六组）家族信托
whenever sqlerror exit sql.sqlcode;
insert  into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')       -- 数据日期
   ,t1.lp_id                                 -- 法人编号
   ,'-'                                      -- ta代码
   ,trunc(t1.tran_tm)                        -- ta确认日期
   ,t1.indent_flow_num                       -- ta确认流水号
   ,' '                                      -- 关联流水号
   ,t1.indent_flow_num                       -- 申请单编号
   ,' '                                      -- 原申请单编号
   ,t1.party_id                              -- 客户编号
   ,' '                                      -- 产品账户编号
   ,t1.tran_acct_num                         -- 交易账户编号
   ,' '                                      -- 银行账户编号
   ,t1.prod_id                               -- 产品编号
   ,' '                                      -- 标准产品编号
   ,t3.prod_name                             -- 产品名称
   ,t1.cust_mgr_id                           -- 客户经理编号
   ,'06'                                     -- 代销业务类型代码
   ,'-'                                      -- 销售模式代码
   ,'-'                                      -- 业务代码
   ,'10'                                     -- 客户类型代码
   ,'CNY'                                    -- 币种代码
   ,'-'                                      -- 分红方式代码
   ,'-'                                      -- 巨额赎回处理代码
   ,t1.tran_chn_cd                           -- 交易渠道代码
   ,t1.tran_status_cd                        -- 交易状态代码   ---00 交易成功  01 交易失败  02 作废  03 待确认  04 待支付
   ,' '                                      -- 交易代码
   ,0                                        -- 申请份额
   ,t1.tran_amt                              -- 申请金额
   ,0                                        -- 确认份额
   ,t1.tran_amt                              -- 确认金额
   ,NVL(t2.corp_nv,1)                        -- 产品净值
   ,0                                        -- 交易手续费
   ,' '                                      -- 交易返回码
   ,' '                                      -- 交易返回信息
   ,' '                                      -- 交易支行编号
   ,' '                                      -- 交易机构编号
   ,' '                                      -- 交易柜员编号
   ,' '                                      -- 授权柜员编号
   ,trunc(t1.tran_tm)                        -- 交易发生日期
   ,trunc(t1.tran_tm)                        -- 交易发生时间
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.evt_family_trust_prod_order_h t1
 left join ${iml_schema}.prd_prod_nv t2
   on t1.prod_id=substr(t2.prod_id,7)
  and trunc(t1.tran_tm)=t2.nv_dt
  and t2.job_cd ='irvsi1'
 left join ${iml_schema}.PRD_PRODUCT t3
   on t1.prod_id=substr(t3.prod_id,7)
  and t3.job_cd = 'irvsi1'
  and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
where trunc(t1.tran_tm)=to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'irvsf1'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;

commit;
*/


--共七组（第七组）理财代销
whenever sqlerror exit sql.sqlcode;
insert  into ${icl_schema}.cmm_agent_consmt_tran_dtl_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
	 ,ta_cd                                    -- ta代码
	 ,ta_cfm_dt                                -- ta确认日期
	 ,ta_cfm_flow_num                          -- ta确认流水号
   ,rela_flow_num                            -- 关联流水号
	 ,appl_form_id                             -- 申请单编号
	 ,init_appl_form_id                        -- 原申请单编号
	 ,cust_id                                  -- 客户编号
	 ,prod_acct_id                             -- 产品账户编号
	 ,tran_acct_id                             -- 交易账户编号
	 ,bank_acct_id                             -- 银行账户编号
	 ,prod_id                                  -- 产品编号
	 ,std_prod_id                              -- 标准产品编号
	 ,prod_name 															 -- 产品名称
	 ,cust_mgr_id                              -- 客户经理编号
	 ,consmt_bus_type_cd                       -- 代销业务类型代码
	 ,sell_mode_cd                             -- 销售模式代码
	 ,bus_cd                                   -- 业务代码
	 ,cust_type_cd                             -- 客户类型代码
	 ,curr_cd                                  -- 币种代码
	 ,divd_way_cd                              -- 分红方式代码
	 ,huge_redem_proc_cd                       -- 巨额赎回处理代码
	 ,tran_chn_cd                              -- 交易渠道代码
	 ,tran_status_cd                           -- 交易状态代码
	 ,tran_cd                                  -- 交易代码
	 ,appl_lot                                 -- 申请份额
	 ,appl_amt                                 -- 申请金额
	 ,cfm_lot                                  -- 确认份额
	 ,cfm_amt                                  -- 确认金额
	 ,prod_nv                                  -- 产品净值
   ,tran_comm_fee                            -- 交易手续费
	 ,tran_return_code                         -- 交易返回码
	 ,tran_return_info                         -- 交易返回信息
	 ,tran_subrch_id                           -- 交易支行编号
	 ,tran_org_id                              -- 交易机构编号
	 ,tran_teller_id                           -- 交易柜员编号
	 ,auth_teller_id                           -- 授权柜员编号
	 ,tran_happ_dt                             -- 交易发生日期
	 ,tran_happ_tm                             -- 交易发生时间
	 ,tran_belong_org_id                       -- 交易归属机构编号
	 ,comb_sell_flag                           -- 组合销售标志
   ,comb_prod_id                             -- 组合产品编号
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')       -- 数据日期
   ,t1.lp_id                                 -- 法人编号
   ,t1.ta_cd                                 -- ta代码
   ,t1.cfm_dt                                -- ta确认日期
   ,t1.ta_cfm_flow_num                       -- ta确认流水号
   ,t1.rela_flow_num                         -- 关联流水号
   ,''                                       -- 申请单编号
   ,''                                       -- 原申请单编号
   ,t1.party_id                              -- 客户编号
   ,''                                       -- 产品账户编号
   ,t1.ta_tran_acct_id                       -- 交易账户编号
   ,t1.bank_acct_id                          -- 银行账户编号
   ,t1.finc_prod_id                          -- 产品编号
   ,''                                       -- 标准产品编号
   ,t2.prod_name                             -- 产品名称
   ,t1.cust_mgr_id                           -- 客户经理编号
   ,'07'                                     -- 代销业务类型代码
   ,'-'                                      -- 销售模式代码
   ,t1.bus_cd                                -- 业务代码
   ,t1.cust_type_cd                          -- 客户类型代码
   ,t1.curr_cd                               -- 币种代码
   ,t1.deflt_divd_way_cd                     -- 分红方式代码
   ,t1.huge_redem_proc_flg                   -- 巨额赎回处理代码
   ,t1.tran_chn_cd                           -- 交易渠道代码
   ,t1.tran_status_cd                        -- 交易状态代码
   ,t1.tran_cd                               -- 交易代码
   ,t1.tran_lot                              -- 申请份额
   ,t1.tran_amt                              -- 申请金额
   ,t1.cfm_lot                               -- 确认份额
   ,t1.cfm_amt                               -- 确认金额
   ,t1.prod_nv                               -- 产品净值
   ,0                                        -- 交易手续费
   ,t1.return_cd                             -- 交易返回码
   ,t1.remark_info                           -- 交易返回信息
   ,t1.tran_org_id                           -- 交易支行编号
   ,t1.tran_open_acct_org_id                 -- 交易机构编号
   ,t1.tran_teller_id                        -- 交易柜员编号
   ,t1.tran_teller_id                        -- 授权柜员编号
   ,t1.tran_dt                               -- 交易发生日期
   ,${iml_schema}.dateformat_min(to_char(t1.tran_dt,'yyyymmdd')||t1.tran_tm)  -- 交易发生时间
	 ,t1.tran_open_acct_org_id                 -- 交易归属机构编号
   ,case when t3.comb_prod_id is not null then '1' else '0' end  -- 组合销售标志
   ,t3.comb_prod_id                          -- 组合产品编号
   ,t1.job_cd                                -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.evt_finc_tran_cfm t1
 left join ${iml_schema}.prd_finc t2
   on t1.finc_prod_id=t2.finc_prod_id
  and t2.job_cd = 'ifmsf1'
  and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.id_mark <>'D'
 left join ${iml_schema}.evt_comb_prod_tran_cfm_evt t3
   on t1.finc_prod_id = t3.finc_prod_id
  and t1.ta_cfm_flow_num = t3.ta_cfm_flow_num
  and t3.cfm_dt = to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'nfssi1'
where t1.ta_cd not in ('GDHX','GJS','HX')
  and t1.cfm_dt =to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'ifmsi1';
commit;



-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_agent_consmt_tran_dtl exchange partition p_${batch_date} with table ${icl_schema}.cmm_agent_consmt_tran_dtl_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_tran_dtl_ex purge;



-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_agent_consmt_tran_dtl',partname => 'p_${batch_date}', degree => 8, cascade => true);
