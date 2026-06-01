/*
Purpose:    共性加工层-代理代销产品信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_agent_consmt_prod_info
CreateDate: 20201106
Logs:       20201127 新增字段【标准产品编号】
            20201126 陈伟峰 调整字段第五组盈米【当前累计净值、净值、净值日期】的取数口径
	        20201130 陈伟峰 增加字段【个人首次最低投资金额】,【赎回资金到帐天数】
   	        20201211 周沁晖 调整保险分组【风险等级代码】的取数口径
	        20201217 陈伟峰 增加字段【托管人名称】、【管理人名称】
            20210107 陈伟峰 新增字段【产品模板说明】
            20211027 何桐金 新增字段【收益类型代码、周期开放型标志】
            20211214 陈伟峰 新增第六组家族信托产品数据、新增字段【业绩基准】
            20220428 陈伟峰 新增字段【产品模板编号、产品小类代码、下一开放起始日期、下一开放结束日期、支持购买方式代码、销售费率、差价费率】
                            新增代销业务数据来源
			20220809 温旺清 新增字段【发行人名称】
			20250218 陈伟峰 新增字段【养老目标基金标志】
            20251224 陈伟峰 调整代销理财的费率表加工逻辑，按照生效日期排序取大者
            20260123 陈伟峰 调整基金的产品名称和产品全称取值逻辑，财富平台做基金产品迁移时互换了名称
            20260128 陈伟峰 调整表nfss_tbprdmanager ->ifms_tbprdmanager
                                  nfss_tbdict  ->ifms_tbdict
      
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_agent_consmt_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_agent_consmt_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_prod_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_prod_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_agent_consmt_prod_info where 0=1;

--第一组（共六组）金融产品
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.init_prod_id                           -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.prod_descb                             -- 产品名称
   ,t2.prod_name                              -- 产品全称
   ,''                                        -- 产品模板编号
   ,t1.prod_tepla                             -- 产品模板说明
   ,t1.ta_cd                                  -- TA代码
   ,'03'                                      -- 代销业务类型代码
   ,t1.prod_cate_cd                           -- 产品类型代码
   ,''                                        -- 产品小类代码
   ,t1.prod_sponsor_id                        -- 发行人编号
   ,t7.publisher_name                         --发行人名称
   ,t1.prod_trustee_id                        -- 托管人编号
   ,t5.prompt                                 -- 托管人名称
   ,t1.prod_mger_id                           -- 管理人编号
   ,t4.manager_name                           -- 管理人名称
   ,''                                        -- 基金经理
   ,t1.prod_host_dept_id                      -- 部门编号
   ,t1.prod_host_org_id                       -- 机构编号
   ,t1.coll_start_dt                          -- 募集开始日期
   ,t1.coll_end_dt                            -- 募集结束日期
   ,t1.prod_found_dt                          -- 成立日期
   ,t1.prod_end_dt                            -- 结束日期
   ,t1.prod_value_dt                          -- 起息日期
   ,t1.int_closing_dt                         -- 利息截止日期
   ,''                                        -- 下一开放开始日期
   ,''                                        -- 下一开放结束日期
   ,t1.prft_exp_dt                            -- 收益到期日期
   ,t1.actl_found_dt                          -- 实际成立日期
   ,t1.sp_acct_id                             -- 认申购账户编号
   ,t1.redem_acct_id                          -- 赎回账户编号
   ,t1.comm_fee_assign_acct_id                -- 手续费分配账户编号
   ,t1.mgmt_fee_assign_acct_id                -- 管理费分配账户编号
   ,t1.chn_cd_comb                            -- 允许渠道组编号
   ,t1.allow_cust_type_cd_comb                -- 允许客户组编号
   ,t1.sell_rg_ctrl_flg                       -- 销售区域控制标志
   ,t1.lmt_ctrl_flg_cd                        -- 额度控制标志
   ,''                                        -- 周期开放型标志
   ,t8.field_value             -- 养老目标基金标志
   ,t1.allow_divd_way_cd                      -- 允许分红方式代码
   ,t1.deflt_divd_way_cd                      -- 默认分红方式代码
   ,t1.prft_embody_way_cd                     -- 收益体现方式代码
   ,''                                        -- 收益类型代码
   ,t1.charge_way_cd                          -- 收费类型代码
   ,t1.prod_attr_cd                           -- 产品属性代码
   ,t1.risk_level_cd                          -- 风险等级代码
   ,t1.estim_level_cd                         -- 评估等级代码
   ,t3.prod_status_cd                         -- 产品状态代码
   ,t1.tran_flg_cd                            -- 转换标志代码
   ,t1.tard_way_cd                            -- 交易方式代码
   ,t1.ec_flg                                 -- 钞汇标志代码
   ,t1.prft_curr_cd                           -- 收益币种代码
   ,t1.curr_cd                                -- 币种代码
   ,'-'                                       -- 支持购买方式代码
   ,t1.ctrl_flg_comb                          -- 控制标志信息
   ,t1.bta_ctrl_flg_comb                      -- BAT控制标志信息
   ,t1.issue_price                            -- 发行价格
   ,t1.expe_yld_rat                           -- 预期收益率
   ,t1.prod_lowt_coll_amt                     -- 最低募集金额
   ,t1.prod_higt_coll_amt                     -- 最高募集金额
   ,t1.prod_lowt_coll_lot                     -- 最低募集份额
   ,t1.prod_higt_coll_lot                     -- 最高募集份额
   ,t1.prod_actl_coll_amt                     -- 实际募集金额
   ,t1.prod_curr_size                         -- 当前募集规模
   ,nvl(t1.indv_fir_lowt_invest_amt,0)        -- 个人首次最低投资金额
   ,0                                         -- 业绩基准
   ,t1.ped_days                               -- 周期天数
   ,t1.nv_days                                -- 净值天数
   ,t1.prod_curr_tot_lot                      -- 当前总份额
   ,t1.prod_acm_nv                            -- 当前累计净值
   ,t1.prod_nv                                -- 净值
   ,t1.nv_dt                                  -- 净值日期
   ,t1.prod_fac_val                           -- 面值
   ,0                                         -- 销售费率
   ,0                                         -- 差价费率
   ,'-'                                       -- 保险产品项目类型代码
   ,'-'                                       -- 定向保险代码
   ,0                                         -- 保险返回天数
   ,t1.redem_cap_avl_days                     -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_consmt_fund_prod t1
 left join ${iml_schema}.prd_name_h t2
 	 on t1.prod_id = t2.prod_id
  and t2.prod_name_type_cd = '05'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'nfssf1'
  and t2.id_mark <> 'D'
 left join ${iml_schema}.prd_prod_status_h t3
 	 on t1.prod_id = t3.prod_id
  and t3.prod_status_type_cd = '005'
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'nfssf1'
  and t3.id_mark <> 'D'
 left join ${iol_schema}.ifms_tbprdmanager t4
   on t1.prod_mger_id=t4.prd_manager
  and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t4.end_dt >to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.ifms_tbdict t5
   on t1.prod_trustee_id=t5.val
  and t5.hs_key='K_CPTGR'
  and t5.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t5.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.nfss_tbprdparamvalue t6			
   on t1.init_prod_id = t6.prd_code
  and t6.field_code = 'prd_publisher'
  and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t6.end_dt >to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.nfss_tbprdpublisher t7			
   on t6.field_value = t7.publisher_code
  and t7.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t7.end_dt >to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.nfss_tbprdparamvalue t8			
   on t1.init_prod_id = t8.prd_code
  and t8.field_code = 'short_run_prd'
   and t8.table_name = 'tbdxfundproduct'
  and t8.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t8.end_dt >to_date('${batch_date}','yyyymmdd')
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
	and t1.job_cd = 'nfssf1'
;
commit;

--第二组（共六组）保险
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.prod_id                                -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.prod_name                              -- 产品名称
   ,t1.prod_descb                             -- 产品全称
   ,''                                        -- 产品模板编号
   ,''                                        -- 产品模板说明
   ,t1.ta_cd                                  -- TA代码
   ,'02'                                      -- 代销业务类型代码
   ,t1.prod_type_cd                           -- 产品类型代码
   ,''                                        -- 产品小类代码
   ,''                                        -- 发行人编号
   ,''                                        --发行人名称
   ,''                                        -- 托管人编号
   ,''                                        -- 托管人名称
   ,''                                        -- 管理人编号
   ,''                                        -- 管理人名称
   ,''                                        -- 基金经理
   ,''                                        -- 部门编号
   ,''                                        -- 机构编号
   ,null                                      -- 募集开始日期
   ,null                                      -- 募集结束日期
   ,t1.prod_effect_dt                         -- 成立日期
   ,t1.prod_invalid_dt                        -- 结束日期
   ,null                                      -- 起息日期
   ,null                                      -- 利息截止日期
   ,''                                        -- 下一开放开始日期
   ,''                                        -- 下一开放结束日期
   ,null                                      -- 收益到期日期
   ,null                                      -- 实际成立日期
   ,''                                        -- 认申购账户编号
   ,''                                        -- 赎回账户编号
   ,''                                        -- 手续费分配账户编号
   ,''                                        -- 管理费分配账户编号
   ,''                                        -- 允许渠道组编号
   ,''                                        -- 允许客户组编号
   ,''                                        -- 销售区域控制标志
   ,t1.lmt_ctrl_type_cd                       -- 额度控制标志
   ,''                                        --周期开放型标志
   ,''              -- 养老目标基金标志
   ,'-'                                       -- 允许分红方式代码
   ,'-'                                       -- 默认分红方式代码
   ,'-'                                       -- 收益体现方式代码
   ,''                                        -- 收益类型代码
   ,'-'                                       -- 收费类型代码
   ,'9999'                                    -- 产品属性代码
   ,t1.risk_level_cd                          -- 风险等级代码
   ,'-'                                       -- 评估等级代码
   ,'999'                                     -- 产品状态代码
   ,'-'                                       -- 转换标志代码
   ,'9'                                       -- 交易方式代码
   ,'-'                                       -- 钞汇标志代码
   ,'-'                                       -- 收益币种代码
   ,t1.curr_cd                                -- 币种代码
   ,'-'                                       -- 支持购买方式代码
   ,t1.ctrl_flg_comb                          -- 控制标志信息
   ,''                                        -- BAT控制标志信息
   ,0                                         -- 发行价格
   ,0                                         -- 预期收益率
   ,0                                         -- 最低募集金额
   ,0                                         -- 最高募集金额
   ,0                                         -- 最低募集份额
   ,0                                         -- 最高募集份额
   ,0                                         -- 实际募集金额
   ,0                                         -- 当前募集规模
   ,t1.indv_min_permium_amt                   -- 个人首次最低投资金额
   ,0                                         -- 业绩基准
   ,0                                         -- 周期天数
   ,0                                         -- 净值天数
   ,0                                         -- 当前总份额
   ,0                                         -- 当前累计净值
   ,0                                         -- 净值
   ,null                                      -- 净值日期
   ,0                                         -- 面值
   ,0                                         -- 销售费率
   ,0                                         -- 差价费率
   ,t1.prod_sub_type_cd                       -- 保险产品项目类型代码
   ,t1.dir_insure_prod_id                     -- 定向保险代码
   ,t1.reptac_days                            -- 保险返回天数
   ,0                                         -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.prd_insure_prod t1
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.id_mark <> 'D'
	and t1.job_cd = 'inssf1'
;
commit;

--第三组（共六组）七兴宝
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.sell_mode_cd                           -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.fund_abbr                              -- 产品名称
   ,t1.fund_fname                             -- 产品全称
   ,''                                        -- 产品模板编号
   ,''                                        -- 产品模板说明
   ,t1.ta_cd                                  -- TA代码
   ,'01'                                      -- 代销业务类型代码
   ,t1.fund_type_cd                           -- 产品类型代码
   ,''                                        -- 产品小类代码
   ,''                                        -- 发行人编号
   ,''                                        --发行人名称
   ,''                                        -- 托管人编号
   ,''                                        -- 托管人名称
   ,t1.mger_id                                -- 管理人编号
   ,''                                        -- 管理人名称
   ,t1.fund_mgr                               -- 基金经理
   ,''                                        -- 部门编号
   ,''                                        -- 机构编号
   ,t1.prod_coll_start_dt                     -- 募集开始日期
   ,t1.prod_coll_end_dt                       -- 募集结束日期
   ,t1.fund_found_dt                          -- 成立日期
   ,null                                      -- 结束日期
   ,null                                      -- 起息日期
   ,null                                      -- 利息截止日期
   ,''                                        -- 下一开放开始日期
   ,''                                        -- 下一开放结束日期
   ,null                                      -- 收益到期日期
   ,t1.fund_found_dt                          -- 实际成立日期
   ,t1.purch_clear_acct_id                    -- 认申购账户编号
   ,t1.redem_divd_clear_acct_id               -- 赎回账户编号
   ,t1.comm_fee_clear_acct_id                 -- 手续费分配账户编号
   ,''                                        -- 管理费分配账户编号
   ,''                                        -- 允许渠道组编号
   ,''                                        -- 允许客户组编号
   ,''                                        -- 销售区域控制标志
   ,''                                        -- 额度控制标志
   ,''                                        --周期开放型标志
   ,''              -- 养老目标基金标志
   ,'-'                                       -- 允许分红方式代码
   ,t1.divd_way_cd                            -- 默认分红方式代码
   ,'-'                                       -- 收益体现方式代码
   ,''                                        -- 收益类型代码
   ,t1.charge_way_cd                          -- 收费类型代码
   ,'9999'                                    -- 产品属性代码
   ,t2.rating_rest_cd                         -- 风险等级代码
   ,'-'                                       -- 评估等级代码
   ,t3.prod_status_cd                         -- 产品状态代码
   ,'-'                                       -- 转换标志代码
   ,'9'                                       -- 交易方式代码
   ,'-'                                       -- 钞汇标志代码
   ,'-'                                       -- 收益币种代码
   ,t1.curr_cd                                -- 币种代码
   ,'-'                                       -- 支持购买方式代码
   ,''                                        -- 控制标志信息
   ,''                                        -- BAT控制标志信息
   ,0                                         -- 发行价格
   ,0                                         -- 预期收益率
   ,0                                         -- 最低募集金额
   ,0                                         -- 最高募集金额
   ,0                                         -- 最低募集份额
   ,0                                         -- 最高募集份额
   ,0                                         -- 实际募集金额
   ,0                                         -- 当前募集规模
   ,0                                         -- 个人首次最低投资金额
   ,0                                         -- 业绩基准
   ,0                                         -- 周期天数
   ,0                                         -- 净值天数
   ,0                                         -- 当前总份额
   ,0                                         -- 当前累计净值
   ,0                                         -- 净值
   ,null                                      -- 净值日期
   ,0                                         -- 面值
   ,0                                         -- 销售费率
   ,0                                         -- 差价费率
   ,'-'                                       -- 保险产品项目类型代码
   ,'-'                                       -- 定向保险代码
   ,0                                         -- 保险返回天数
   ,0                                         -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_qxb_prod_info t1
 left join ${iml_schema}.prd_risk_rating_h t2
 	 on t1.prod_id = t2.prod_id
  and t2.rating_type_cd = 'CD1968'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'fsmsf1'
  and t2.id_mark <> 'D'
 left join ${iml_schema}.prd_prod_status_h t3
 	 on t1.prod_id = t3.prod_id
  and t3.prod_status_type_cd = 'CD1477'
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'fsmsf1'
  and t3.id_mark <> 'D'
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
	and t1.job_cd = 'fsmsf1'
;
commit;

--第四组（共六组）信托资管
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.init_prod_id                           -- 产品编号
   ,t1.std_prod_id                            -- 标准产品编号
   ,t2.prod_name                              -- 产品名称
   ,t1.prod_descb                             -- 产品全称
   ,''                                        -- 产品模板编号
   ,t1.prod_tepla                             -- 产品模板说明
   ,t1.ta_cd                                  -- TA代码
   ,'04'                                      -- 代销业务类型代码
   ,t1.prod_cate_cd                           -- 产品类型代码
   ,''                                        -- 产品小类代码
   ,t1.prod_sponsor_id                        -- 发行人编号
   ,''                                        --发行人名称
   ,t1.prod_trustee_id                        -- 托管人编号
   ,t5.prompt                                 -- 托管人名称
   ,t1.prod_mger_id                           -- 管理人编号
   ,t4.manager_name                           -- 管理人名称
   ,''                                        -- 基金经理
   ,t1.prod_host_dept_id                      -- 部门编号
   ,t1.prod_host_org_id                       -- 机构编号
   ,t1.coll_start_dt                          -- 募集开始日期
   ,t1.coll_end_dt                            -- 募集结束日期
   ,t1.prod_found_dt                          -- 成立日期
   ,t1.prod_end_dt                            -- 结束日期
   ,t1.prod_value_dt                          -- 起息日期
   ,t1.int_closing_dt                         -- 利息截止日期
   ,''                                        -- 下一开放开始日期
   ,''                                        -- 下一开放结束日期
   ,t1.prft_exp_dt                            -- 收益到期日期
   ,t1.actl_found_dt                          -- 实际成立日期
   ,t1.sp_acct_id                             -- 认申购账户编号
   ,t1.redem_acct_id                          -- 赎回账户编号
   ,t1.comm_fee_assign_acct_id                -- 手续费分配账户编号
   ,t1.mgmt_fee_assign_acct_id                -- 管理费分配账户编号
   ,t1.chn_cd_comb                            -- 允许渠道组编号
   ,t1.allow_cust_type_cd_comb                -- 允许客户组编号
   ,t1.sell_rg_ctrl_flg                       -- 销售区域控制标志
   ,t1.lmt_ctrl_flg_cd                        -- 额度控制标志
   ,nvl(trim(substr(t1.ctrl_flg_comb, 175, 1)),0)  --周期开放型标志
   ,''              -- 养老目标基金标志
   ,t1.allow_divd_way_cd                      -- 允许分红方式代码
   ,t1.deflt_divd_way_cd                      -- 默认分红方式代码
   ,t1.prft_embody_way_cd                     -- 收益体现方式代码
   ,case  t6.field_value
        when '1' then '01'
        when '2' then '02'
        when  '0' then '00'
    else '-' end                              -- 收益类型代码
   ,t1.charge_way_cd                          -- 收费类型代码
   ,t1.prod_attr_cd                           -- 产品属性代码
   ,t1.risk_level_cd                          -- 风险等级代码
   ,t1.estim_level_cd                         -- 评估等级代码
   ,t3.prod_status_cd                         -- 产品状态代码
   ,t1.tran_flg_cd                            -- 转换标志代码
   ,t1.tard_way_cd                            -- 交易方式代码
   ,t1.ec_flg                                 -- 钞汇标志代码
   ,t1.prft_curr_cd                           -- 收益币种代码
   ,t1.curr_cd                                -- 币种代码
   ,'-'                                       -- 支持购买方式代码
   ,t1.ctrl_flg_comb                          -- 控制标志信息
   ,t1.bta_ctrl_flg_comb                      -- BAT控制标志信息
   ,t1.issue_price                            -- 发行价格
   ,t1.expe_yld_rat                           -- 预期收益率
   ,t1.prod_lowt_coll_amt                     -- 最低募集金额
   ,t1.prod_higt_coll_amt                     -- 最高募集金额
   ,t1.prod_lowt_coll_lot                     -- 最低募集份额
   ,t1.prod_higt_coll_lot                     -- 最高募集份额
   ,t1.prod_actl_coll_amt                     -- 实际募集金额
   ,t1.prod_curr_size                         -- 当前募集规模
   ,nvl(t1.indv_fir_lowt_invest_amt,0)        -- 个人首次最低投资金额
   ,0                                         -- 业绩基准
   ,t1.ped_days                               -- 周期天数
   ,t1.nv_days                                -- 净值天数
   ,t1.prod_curr_tot_lot                      -- 当前总份额
   ,t1.prod_acm_nv                            -- 当前累计净值
   ,t1.prod_nv                                -- 净值
   ,t1.nv_dt                                  -- 净值日期
   ,t1.prod_fac_val                           -- 面值
   ,0                                         -- 销售费率
   ,0                                         -- 差价费率
   ,'-'                                       -- 保险产品项目类型代码
   ,'-'                                       -- 定向保险代码
   ,0                                         -- 保险返回天数
   ,t1.redem_cap_avl_days                     -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_trust_prod t1
 left join ${iml_schema}.prd_name_h t2
 	 on t1.prod_id = t2.prod_id
  and t2.prod_name_type_cd = '06'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.job_cd = 'trusf1'
  and t2.id_mark <> 'D'
 left join ${iml_schema}.prd_prod_status_h t3
 	 on t1.prod_id = t3.prod_id
  and t3.prod_status_type_cd = '006'
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and t3.job_cd = 'trusf1'
  and t3.id_mark <> 'D'
 left join ${iol_schema}.nfss_tcs_tbprdmanager t4
   on t1.prod_mger_id=t4.prd_manager
  and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t4.end_dt >to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.nfss_tcs_tbdict t5
   on t1.prod_trustee_id=t5.val
  and t5.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t5.end_dt >to_date('${batch_date}','yyyymmdd')
 left join ${iol_schema}.nfss_tcs_tbprdparamvalue t6
   on t1.prod_id = '223009'||t6.prd_code
  and t6.table_name = 'tbproduct'
  and t6.field_code = 'prd_income_type'
  and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t6.end_dt >to_date('${batch_date}','yyyymmdd')
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
	and t1.job_cd = 'trusf1'
;
commit;

--第五组（共六组）盈米
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.fund_cd                                -- 产品编号
   ,''                                        -- 标准产品编号
   ,t1.fund_abbr                              -- 产品名称
   ,t1.fund_fname                             -- 产品全称
   ,''                                        -- 产品模板编号
   ,''                                        -- 产品模板说明
   ,t1.mercht_id                              -- TA代码
   ,'05'                                      -- 代销业务类型代码
   ,t1.fund_type_cd                           -- 产品类型代码
   ,''                                        -- 产品小类代码
   ,''                                        -- 发行人编号
   ,''                                        --发行人名称
   ,t1.fund_trustee                           -- 托管人编号
   ,t1.fund_trustee                           -- 托管人名称
   ,t1.fund_mger                              -- 管理人编号
   ,t1.fund_mger                              -- 管理人名称
   ,t1.fund_mgr                               -- 基金经理
   ,''                                        -- 部门编号
   ,''                                        -- 机构编号
   ,null                                      -- 募集开始日期
   ,null                                      -- 募集结束日期
   ,t1.found_dt                               -- 成立日期
   ,null                                      -- 结束日期
   ,null                                      -- 起息日期
   ,null                                      -- 利息截止日期
   ,''                                        -- 下一开放开始日期
   ,''                                        -- 下一开放结束日期
   ,null                                      -- 收益到期日期
   ,t1.found_dt                               -- 实际成立日期
   ,''                                        -- 认申购账户编号
   ,''                                        -- 赎回账户编号
   ,''                                        -- 手续费分配账户编号
   ,''                                        -- 管理费分配账户编号
   ,''                                        -- 允许渠道组编号
   ,''                                        -- 允许客户组编号
   ,''                                        -- 销售区域控制标志
   ,''                                        -- 额度控制标志
   ,''                                        -- 周期开放型标志
   ,''              -- 养老目标基金标志
   ,t1.divd_way_cd                            -- 允许分红方式代码
   ,t1.divd_way_cd                            -- 默认分红方式代码
   ,'-'                                       -- 收益体现方式代码
   ,''                                        -- 收益类型代码
   ,t1.fund_fee_type_cd                       -- 收费类型代码
   ,'9999'                                    -- 产品属性代码
   ,t1.prod_risk_level_cd                     -- 风险等级代码
   ,'-'                                       -- 评估等级代码
   ,t2.prod_status_cd                         -- 产品状态代码
   ,'-'                                       -- 转换标志代码
   ,'9'                                       -- 交易方式代码
   ,'-'                                       -- 钞汇标志代码
   ,t1.curr_cd                                -- 收益币种代码
   ,t1.curr_cd                                -- 币种代码
   ,'-'                                       -- 支持购买方式代码
   ,''                                        -- 控制标志信息
   ,''                                        -- BAT控制标志信息
   ,0                                         -- 发行价格
   ,0                                         -- 预期收益率
   ,0                                         -- 最低募集金额
   ,0                                         -- 最高募集金额
   ,0                                         -- 最低募集份额
   ,0                                         -- 最高募集份额
   ,0                                         -- 实际募集金额
   ,0                                         -- 当前募集规模
   ,nvl(t1.indv_fir_subscr_lowt_amt,0)        -- 个人首次最低投资金额
   ,0                                         -- 业绩基准
   ,0                                         -- 周期天数
   ,0                                         -- 净值天数
   ,nvl(trim(t1.lot_size),0)                  -- 当前总份额
   ,nvl(t3.acm_nv,0)                        -- 当前累计净值
   ,nvl(t3.corp_nv,0)                         -- 净值
   ,t3.nv_dt                                      -- 净值日期
   ,0                                         -- 面值
   ,0                                         -- 销售费率
   ,0                                         -- 差价费率
   ,'-'                                       -- 保险产品项目类型代码
   ,'-'                                       -- 定向保险代码
   ,0                                         -- 保险返回天数
   ,t1.redem_avl_days                         -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_ym_fund_info t1
 left join ${iml_schema}.prd_prod_status_h t2
 	 on t1.prod_id = t2.prod_id
  and t2.prod_status_type_cd = 'CD1477'
  and t2.job_cd = 'mpcsf1'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  and t2.id_mark <> 'D'
  left join (select fund_cd,
                    mercht_id,
                    nv_dt,
                    corp_nv,
                    acm_nv,
                    row_number() over(partition by fund_cd, mercht_id order by nv_dt desc,update_tm desc) rn
             from ${iml_schema}.prd_ym_fund_nv_info
            where create_dt <= to_date('${batch_date}', 'yyyymmdd')
			        and job_cd ='mpcsf1') t3
   on t1.fund_cd = t3.fund_cd
  and t1.mercht_id=t3.mercht_id
  and t3.rn =1
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
	and t1.job_cd = 'mpcsf1'
	and t1.id_mark <> 'D'
;
commit;


--第六组（共六组）家族信托
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')            -- 数据日期
   ,t1.lp_id                                      -- 法人编号
   ,t1.init_prod_id                               -- 产品编号
   ,' '                                           -- 标准产品编号
   ,t1.prod_name                                  -- 产品名称
   ,t1.prod_name                                  -- 产品全称
   ,''                                            -- 产品模板编号
   ,' '                                           -- 产品模板说明
   ,'-'                                           -- ta代码
   ,'06'                                          -- 代销业务类型代码
   ,'999'                                         -- 产品类型代码
   ,''                                            -- 产品小类代码
   ,t1.trust_corp_cd                              -- 发行人编号
   ,t1.trust_corp_name                            -- 发行人名称
   ,' '                                           -- 托管人编号
   ,' '                                           -- 托管人名称
   ,t1.trust_corp_cd                              -- 管理人编号
   ,t1.trust_corp_name                            -- 管理人名称
   ,' '                                           -- 基金经理
   ,' '                                           -- 部门编号
   ,' '                                           -- 机构编号
   ,t1.coll_start_dt                              -- 募集开始日期
   ,t1.coll_end_dt                                -- 募集结束日期
   ,t1.found_dt                                   -- 成立日期
   ,t1.termnt_dt                                  -- 结束日期
   ,''                                            -- 起息日期
   ,''                                            -- 利息截止日期
   ,''                                            -- 下一开放开始日期
   ,''                                            -- 下一开放结束日期
   ,''                                            -- 收益到期日期
   ,''                                            -- 实际成立日期
   ,' '                                           -- 认申购账户编号
   ,' '                                           -- 赎回账户编号
   ,' '                                           -- 手续费分配账户编号
   ,' '                                           -- 管理费分配账户编号
   ,' '                                           -- 允许渠道组编号
   ,' '                                           -- 允许客户组编号
   ,' '                                           -- 销售区域控制标志
   ,' '                                           -- 额度控制标志
   ,' '                                           -- 周期开放型标志
   ,''              -- 养老目标基金标志
   ,'-'                                           -- 允许分红方式代码
   ,'-'                                           -- 默认分红方式代码
   ,'-'                                           -- 收益体现方式代码
   ,''                                            -- 收益类型代码
   ,'-'                                           -- 收费类型代码
   ,'9999'                                        -- 产品属性代码
   ,decode(t1.risk_level_cd,'0','01' ,'1','02'
                           ,'2','03' ,'3','04'
                           ,'4','05' ,'5','00')   -- 风险等级代码
   ,'-'                                           -- 评估等级代码
   ,t1.prod_status_cd                             -- 产品状态代码
   ,'-'                                           -- 转换标志代码
   ,'9'                                           -- 交易方式代码
   ,'9'                                           -- 钞汇标志代码
   ,'CNY'                                         -- 收益币种代码
   ,'CNY'                                         -- 币种代码
   ,'-'                                           -- 支持购买方式代码
   ,' '                                           -- 控制标志信息
   ,' '                                           -- bat控制标志信息
   ,0                                             -- 发行价格
   ,0                                             -- 预期收益率
   ,0                                             -- 最低募集金额
   ,0                                             -- 最高募集金额
   ,0                                             -- 最低募集份额
   ,0                                             -- 最高募集份额
   ,0                                             -- 实际募集金额
   ,0                                             -- 当前募集规模
   ,0                                             -- 个人首次最低投资金额
   ,t1.acvmnt_base                                -- 业绩基准
   ,0                                             -- 周期天数
   ,0                                             -- 净值天数
   ,t1.lot                                        -- 当前总份额
   ,1                                             -- 当前累计净值
   ,nvl(t2.corp_nv,1)                             -- 净值
   ,t2.nv_dt                                      -- 净值日期
   ,0                                             -- 面值
   ,0                                             -- 销售费率
   ,0                                             -- 差价费率
   ,'-'                                           -- 保险产品项目类型代码
   ,'-'                                           -- 定向保险代码
   ,0                                             -- 保险返回天数
   ,0                                             -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_family_trust_prod_h t1
 left join (select t.*,row_number() over(partition by t.prod_id order by t.nv_dt,t.nv_id desc) rn
              from ${iml_schema}.prd_prod_nv t
             where nv_dt<=to_date('${batch_date}','yyyymmdd')
               and t.job_cd ='nfssi1') t2
   on t1.prod_id=t2.prod_id
  and t2.rn=1
where t1.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t1.end_dt >to_date('${batch_date}','yyyymmdd')
  and t1.job_cd ='nfssf1'
;
commit;


--第七组（共七组）理财代销
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_agent_consmt_prod_info_ex(
   etl_dt	                                   -- 数据日期
   ,lp_id	                                   -- 法人编号
   ,prod_id                                  -- 产品编号
   ,std_prod_id                              -- 标准产品编号
   ,prod_name                                -- 产品名称
   ,prod_fname                               -- 产品全称
   ,prod_tepla_id                            -- 产品模板编号
   ,prod_tepla_comnt                         -- 产品模板说明
   ,ta_cd                                    -- ta代码
   ,consmt_bus_type_cd                       -- 代销业务类型代码
   ,prod_type_cd                             -- 产品类型代码
   ,prod_sclass_cd                           -- 产品小类代码
   ,issuer_id                                -- 发行人编号
   ,issuer_name                              --发行人名称
   ,trustee_id                               -- 托管人编号
   ,trustee_name                             -- 托管人名称
   ,mger_id                                  -- 管理人编号
   ,mger_name                                -- 管理人名称
   ,fund_mgr                                 -- 基金经理
   ,dept_id                                  -- 部门编号
   ,org_id                                   -- 机构编号
   ,coll_start_dt                            -- 募集开始日期
   ,coll_end_dt                              -- 募集结束日期
   ,found_dt                                 -- 成立日期
   ,end_dt                                   -- 结束日期
   ,value_dt                                 -- 起息日期
   ,int_closing_dt                           -- 利息截止日期
   ,next_open_start_dt                       -- 下一开放开始日期
   ,next_open_end_dt                         -- 下一开放结束日期
   ,prft_exp_dt                              -- 收益到期日期
   ,actl_found_dt                            -- 实际成立日期
   ,sp_acct_id                               -- 认申购账户编号
   ,redem_acct_id                            -- 赎回账户编号
   ,comm_fee_assign_acct_id                  -- 手续费分配账户编号
   ,mgmt_fee_assign_acct_id                  -- 管理费分配账户编号
   ,allow_chn_group_id                       -- 允许渠道组编号
   ,allow_cust_group_id                      -- 允许客户组编号
   ,sell_rg_ctrl_flg                         -- 销售区域控制标志
   ,lmt_ctrl_flg                             -- 额度控制标志
   ,ped_open_flg                             -- 周期开放型标志
   ,provi_for_aged_target_fund_flg             -- 养老目标基金标志
   ,allow_divd_way_cd                        -- 允许分红方式代码
   ,deflt_divd_way_cd                        -- 默认分红方式代码
   ,prft_embody_way_cd                       -- 收益体现方式代码
   ,prft_type_cd                             -- 收益类型代码
   ,charge_type_cd                           -- 收费类型代码
   ,prod_attr_cd                             -- 产品属性代码
   ,risk_level_cd                            -- 风险等级代码
   ,estim_level_cd                           -- 评估等级代码
   ,prod_status_cd                           -- 产品状态代码
   ,tran_flg_cd                              -- 转换标志代码
   ,tard_way_cd                              -- 交易方式代码
   ,ec_flg_cd                                -- 钞汇标志代码
   ,prft_curr_cd                             -- 收益币种代码
   ,curr_cd                                  -- 币种代码
   ,supt_buy_way_cd                          -- 支持购买方式代码
   ,ctrl_flg_info                            -- 控制标志信息
   ,bta_ctrl_flg_info                        -- bta控制标志信息
   ,issue_price                              -- 发行价格
   ,expe_yld_rat                             -- 预期收益率
   ,lowt_coll_amt                            -- 最低募集金额
   ,higt_coll_amt                            -- 最高募集金额
   ,lowt_coll_lot                            -- 最低募集份额
   ,higt_coll_lot                            -- 最高募集份额
   ,actl_coll_amt                            -- 实际募集金额
   ,curr_coll_size                           -- 当前募集规模
   ,indv_fir_lowt_invest_amt                 -- 个人首次最低投资金额
   ,acvmnt_base                              -- 业绩基准
   ,ped_days                                 -- 周期天数
   ,nv_days                                  -- 净值天数
   ,curr_tot_lot                             -- 当前总份额
   ,curr_acm_nv                              -- 当前累计净值
   ,nv                                       -- 净值
   ,nv_dt                                    -- 净值日期
   ,fac_val                                  -- 面值
   ,sale_fee_rat                             -- 销售费率
   ,diff_price_fee_rat                       -- 差价费率
   ,insure_prod_proj_type_cd                 -- 保险产品项目类型代码
   ,dir_insure_cd                            -- 定向保险代码
   ,insure_return_days                       -- 保险返回天数
   ,redem_cap_avl_days                       -- 赎回资金到帐天数
   ,job_cd                                   -- 任务代码
   ,etl_timestamp                            -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')            -- 数据日期
   ,t1.lp_id                                      -- 法人编号
   ,t1.finc_prod_id                               -- 产品编号
   ,''                                            -- 标准产品编号
   ,t1.prod_name                                  -- 产品名称
   ,t1.prod_name                                  -- 产品全称
   ,t1.prod_tepla_id                              -- 产品模板编号
   ,t1.ref_yld_rat_comnt                          -- 产品模板说明
   ,t1.ta_cd                                      -- ta代码
   ,'07'                                          -- 代销业务类型代码
   ,'9999'                                        -- 产品类型代码
   ,t4.field_value                                -- 产品小类代码
   ,t1.prod_sponsor_cd                            -- 发行人编号
   ,''                                            --发行人名称
   ,t1.prod_trustee_cd                            -- 托管人编号
   ,''                                            -- 托管人名称
   ,t1.prod_mger_cd                               -- 管理人编号
   ,''                                            -- 管理人名称
   ,t1.prod_mger_cd                               -- 基金经理
   ,t1.prod_host_org_id                           -- 部门编号
   ,t1.prod_host_org_id                           -- 机构编号
   ,t1.coll_start_dt                              -- 募集开始日期
   ,t1.coll_end_dt                                -- 募集结束日期
   ,t1.prod_found_dt                              -- 成立日期
   ,t1.prod_end_dt                                -- 结束日期
   ,t1.prod_value_dt                              -- 起息日期
   ,to_date('29991231','yyyymmdd')                -- 利息截止日期
   ,t2.value_dt                                   -- 下一开放开始日期
   ,''                                            -- 下一开放结束日期
   ,t1.prft_exp_dt                                -- 收益到期日期
   ,t1.actl_found_dt                              -- 实际成立日期
   ,t1.buy_acct_id                                -- 认申购账户编号
   ,t1.redem_acct_id                              -- 赎回账户编号
   ,''                                            -- 手续费分配账户编号
   ,''                                            -- 管理费分配账户编号
   ,''                                            -- 允许渠道组编号
   ,t1.allow_cust_group_list                      -- 允许客户组编号
   ,t1.sell_rg_ctrl_flg                           -- 销售区域控制标志
   ,t1.lmt_ctrl_flg                               -- 额度控制标志
   ,'-'                                           -- 周期开放型标志
   ,''             -- 养老目标基金标志
   ,t1.allow_divd_way_cd                          -- 允许分红方式代码
   ,t1.deflt_divd_way_cd                          -- 默认分红方式代码
   ,t1.prft_embody_way_cd                         -- 收益体现方式代码
   ,'-'                                           -- 收益类型代码
   ,'-'                                           -- 收费类型代码
   ,t1.prod_attr_cd                               -- 产品属性代码
   ,t1.risk_level_cd                              -- 风险等级代码
   ,'-'                                           -- 评估等级代码
   ,t1.status_cd                                  -- 产品状态代码
   ,t1.tran_flg                                   -- 转换标志代码
   ,''                                            -- 交易方式代码
   ,t1.ec_flg                                     -- 钞汇标志代码
   ,t1.curr_cd                                    -- 收益币种代码
   ,t1.curr_cd                                    -- 币种代码
   ,t1.supt_buy_way_cd                            -- 支持购买方式代码
   ,t1.ctrl_flg                                   -- 控制标志信息
   ,t1.bta_ctrl_flg                               -- bta控制标志信息
   ,t1.issue_price                                -- 发行价格
   ,t1.expe_yld_rat                               -- 预期收益率
   ,t1.prod_lowt_coll_amt                         -- 最低募集金额
   ,t1.prod_higt_coll_amt                         -- 最高募集金额
   ,t1.prod_lowt_coll_lot                         -- 最低募集份额
   ,t1.prod_higt_coll_lot                         -- 最高募集份额
   ,t1.prod_actl_coll_amt                         -- 实际募集金额
   ,t1.curr_size                                  -- 当前募集规模
   ,t1.indv_fir_lowt_invest_amt                   -- 个人首次最低投资金额
   ,0                                             -- 业绩基准
   ,t1.ped_days                                   -- 周期天数
   ,0                                             -- 净值天数
   ,0                                             -- 当前总份额
   ,0                                             -- 当前累计净值
   ,t1.prod_nv                                    -- 净值
   ,to_date('${batch_date}','yyyymmdd')           -- 净值日期
   ,t1.prod_fac_val                               -- 面值
   ,nvl(t5.prod_fee_rat,0)                        -- 销售费率
   ,nvl(t6.prod_fee_rat,0)                        -- 差价费率
   ,'-'                                           -- 保险产品项目类型代码
   ,'-'                                           -- 定向保险代码
   ,'0'                                           -- 保险返回天数
   ,t1.redem_cap_avl_days                         -- 赎回资金到帐天数
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_finc t1
 left join (select rela_id as prd_code, min(tx_dt) as value_dt
              from ${iml_schema}.ref_tx_day_para
             where tx_dt > to_date('${batch_date}','yyyymmdd')
               and dt_type_cd = '70'
             group by rela_id) t2
   on t1.finc_prod_id =t2.prd_code
 left join (select rela_id as prd_code, max(tx_dt) as exp_dt
               from ${iml_schema}.ref_tx_day_para
              where tx_dt <= to_date('${batch_date}','yyyymmdd')
                and dt_type_cd = '70'
              group by rela_id) t3
   on t1.finc_prod_id =t3.prd_code
 left join ${iol_schema}.ifms_tbprdparamvalue t4
   on t1.finc_prod_id =t4.prd_code
  and t4.table_name='tbproduct' 
  and t4.field_code='prd_xlx'
  and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t4.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select t.*
                        ,row_number() over(partition by prod_id,fee_rat_type_cd order by effect_dt desc) rn
                   from ${iml_schema}.prd_fee_rat_h t 
                  where effect_dt<= to_date('${batch_date}', 'yyyymmdd')
                     and invalid_dt> to_date('${batch_date}', 'yyyymmdd')
                     and job_cd = 'ifmsf1'
                     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and end_dt > to_date('${batch_date}', 'yyyymmdd')) t5
    on t1.finc_prod_id = t5.prod_id
   and t5.fee_rat_type_cd = '100101'   --销售费率
   and t5.rn=1
  left join (select t.*
                        ,row_number() over(partition by prod_id,fee_rat_type_cd order by effect_dt desc) rn
                   from ${iml_schema}.prd_fee_rat_h t 
                  where effect_dt<= to_date('${batch_date}', 'yyyymmdd')
                     and invalid_dt> to_date('${batch_date}', 'yyyymmdd')
                     and job_cd = 'ifmsf1'
                     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and end_dt > to_date('${batch_date}', 'yyyymmdd')) t6
    on t1.finc_prod_id = t6.prod_id
   and t6.fee_rat_type_cd = '100102'   --差价费率
   and t6.rn=1
 where t1.ta_cd not in ('GDHX','GJS','HX')
  and t1.create_dt <=to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
  and t1.job_cd ='ifmsf1'
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_agent_consmt_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_agent_consmt_prod_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_agent_consmt_prod_info_ex purge;



-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_agent_consmt_prod_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
