/*
Purpose:    共性加工层-联合网贷贷款合同信息：包括联合网贷中网商贷部分业务的贷款业务合同系信息，来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_loan_cont_info
CreateDate: 20230928
Logs:       20241118 谢  宁 增加完成状态表
            20250218 谢  宁 增加微业贷
			20250509 谢  宁 增加36个新字段
           20250516 陈伟峰 调整【限制或鼓励行业代码】，置空，调整投向行业标签值为2025041800000023
           20250730 陈伟峰 新增乐分期
           20260112 陈伟峰 新增富民联合网贷
           20260114 陈伟峰 调整微业贷担保合同表的担保方式取值逻辑，从guar_form_cd调整为直取guar_way_cd

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_loan_cont_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_loan_cont_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_loan_cont_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_loan_cont_info_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_loan_cont_info where 0=1;

-- 第一组  网商贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.cont_id                              -- 合同编号
       ,t1.crdt_appl_id                         -- 授信申请流水号
       ,''                                      -- 额度合同编号
       ,t1.cust_id                              -- 客户编号
       ,t1.cust_name                            -- 客户名称
       ,t1.prod_id                              -- 标准产品编号
       ,t1.lmt_cont_flg                         -- 授信类型代码
       ,t1.appl_type_cd                         -- 申请类型代码
       ,t1.curr_cd                              -- 币种代码
       ,t1.int_rat_float_way_cd                 -- 基准利率类型代码
       ,t1.int_rat_adj_way_cd                   -- 利率调整方式代码
       ,t1.cont_status_cd                       -- 合同状态代码
       ,t1.apv_status_cd                        -- 审批状态代码
       ,t1.main_guar_way_cd                     -- 担保方式代码
       ,t1.repay_way_cd                         -- 还款方式代码
       ,t1.loan_usage_cd                        -- 贷款用途类型代码
	   ,''		                                -- 限制或鼓励行业代码
       ,''                                      -- 供应链金融业务产品分类代码
       ,''                                      -- 保障性安居工程贷款类型
       ,''                                      -- 创业担保贷款类型代码
       ,''                                      -- 房地产贷款类型代码
       ,''                                      -- 战略性新兴产业类型代码
       ,''                                      -- 投向数字经济核心产业类型代码
       ,''                                      -- 涉农贷款主体类型代码
       ,''                                      -- 涉农贷款投向代码
       ,''                                      -- 贷款投向行业代码
       ,''                                      -- 贷款财政扶持方式代码
       ,''                                      -- 过剩行业代码
       ,''                                      -- 先进制造业标志
       ,''                                      -- 绿色信贷融资标志
       ,''                                      -- 国家限制行业标志
       ,''                                      -- 高技术服务业贷款标志
       ,''                                      -- 科创企业标志
       ,''                                      -- 科技型企业标志
       ,''                                      -- 高新技术企业标志
       ,''                                      -- 专精特新中小企业标志
       ,''                                      -- 专精特新小巨人企业标志
       ,''                                      -- 养老产业标志
       ,''                                      -- 工业转型升级标识
       ,''                                      -- 三旧改造或城市更新项目标志
       ,''                                      -- 一带一路建设投融资标志
       ,''                                      -- 供应链金融业务标志
       ,''                                      -- 创业担保贷款标志
       ,''                                      -- 县城区贷款标志
       ,''                                      -- 境外贷款标志
       ,''                                      -- 投向政府和社会资本合作项目标志
       ,''                                      -- 文化产业标志
       ,''                                      -- 投向高技术产业标志
       ,''                                      -- 新机制发放贷款标志
       ,''                                      -- 涉农贷款标志
       ,''                                      -- 种业振兴贷款标志
       ,''                                      -- 项目融资标志
       ,t1.recvbl_acct_id                       -- 收款账户名称
       ,t1.recver_open_bank_no                  -- 收款账户开户机构编号
       ,t1.exec_int_rat                         -- 执行利率
       ,t1.loan_bal                             -- 合同余额
       ,t1.cont_amt                             -- 合同金额
       ,t1.actl_out_acct_amt                    -- 放款金额
       ,t1.tenor                                -- 期限
       ,t1.effect_dt                            -- 起始日期
       ,t1.invalid_dt                           -- 到期日期
       ,t1.sign_dt                              -- 签订日期
       ,t1.out_acct_dt                          -- 放款日期
       ,t1.payoff_dt                            -- 终止日期
       ,t1.spec_repay_dt                        -- 指定还款日
       ,t1.oper_teller_id                       -- 经办人编号
       ,t1.oper_org_id                          -- 经办机构编号
       ,t1.oper_dt                              -- 经办日期
       ,t1.rgst_teller_id                       -- 登记人编号
       ,t1.rgst_org_id                          -- 登记机构编号
       ,t1.rgst_dt                              -- 登记日期
       ,t1.update_teller_id                     -- 更新人编号
       ,t1.update_org_id                        -- 更新机构编号
       ,t1.up_date                              -- 更新日期
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_wsd_loan_cont_info_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='mybkf1'
;
commit;

-- 第二组  字节小微贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.cont_id                              -- 合同编号
       ,t1.intnal_dubil_id                      -- 授信申请流水号
       ,t2.cont_id                              -- 额度合同编号
       ,t1.cust_id                              -- 客户编号
       ,t1.cust_name                            -- 客户名称
       ,t1.prod_id                              -- 标准产品编号
       ,'02'                                    -- 授信类型代码
       ,'ResaleLoanApply'                       -- 申请类型代码
       ,t1.curr_cd                              -- 币种代码
       ,''                                      -- 基准利率类型代码
       ,''                                      -- 利率调整方式代码
       ,decode(t1.cont_valid_flg,'1','2','4')   -- 合同状态代码
       ,decode(t1.apv_status_cd,'Finished','1','Approving','3','-') -- 审批状态代码
       ,'D'                                     -- 担保方式代码
       ,''                                      -- 还款方式代码
       ,t1.loan_usage_cd                        -- 贷款用途类型代码
	   ,''		                                -- 限制或鼓励行业代码
       ,''                                      -- 供应链金融业务产品分类代码
       ,''                                      -- 保障性安居工程贷款类型
       ,''                                      -- 创业担保贷款类型代码
       ,''                                      -- 房地产贷款类型代码
       ,''                                      -- 战略性新兴产业类型代码
       ,''                                      -- 投向数字经济核心产业类型代码
       ,''                                      -- 涉农贷款主体类型代码
       ,''                                      -- 涉农贷款投向代码
       ,t3.intraindustrytype                                      -- 贷款投向行业代码
       ,''                                      -- 贷款财政扶持方式代码
       ,''                                      -- 过剩行业代码
       ,''                                      -- 先进制造业标志
       ,''                                      -- 绿色信贷融资标志
       ,''                                      -- 国家限制行业标志
       ,''                                      -- 高技术服务业贷款标志
       ,''                                      -- 科创企业标志
       ,''                                      -- 科技型企业标志
       ,''                                      -- 高新技术企业标志
       ,''                                      -- 专精特新中小企业标志
       ,''                                      -- 专精特新小巨人企业标志
       ,''                                      -- 养老产业标志
       ,''                                      -- 工业转型升级标识
       ,''                                      -- 三旧改造或城市更新项目标志
       ,''                                      -- 一带一路建设投融资标志
       ,''                                      -- 供应链金融业务标志
       ,''                                      -- 创业担保贷款标志
       ,''                                      -- 县城区贷款标志
       ,''                                      -- 境外贷款标志
       ,''                                      -- 投向政府和社会资本合作项目标志
       ,''                                      -- 文化产业标志
       ,''                                      -- 投向高技术产业标志
       ,''                                      -- 新机制发放贷款标志
       ,''                                      -- 涉农贷款标志
       ,''                                      -- 种业振兴贷款标志
       ,''                                      -- 项目融资标志
       ,''                                      -- 收款账户名称
       ,''                                      -- 收款账户开户机构编号
       ,t1.loan_int_rat                         -- 执行利率
       ,t1.cont_bal                             -- 合同余额
       ,t1.cont_amt                             -- 合同金额
       ,t1.cont_amt                             -- 放款金额
       ,t1.tenor                                -- 期限
       ,t1.begin_dt                             -- 起始日期
       ,t1.exp_dt                               -- 到期日期
       ,t1.begin_dt                             -- 签订日期
       ,t1.begin_dt                             -- 放款日期
       ,null                                    -- 终止日期
       ,null                                    -- 指定还款日
       ,t1.rgst_teller_id                       -- 经办人编号
       ,t1.rgst_org_id                          -- 经办机构编号
       ,t1.rgst_dt                              -- 经办日期
       ,t1.rgst_teller_id                       -- 登记人编号
       ,t1.rgst_org_id                          -- 登记机构编号
       ,t1.rgst_dt                              -- 登记日期
       ,t1.final_update_teller_id               -- 更新人编号
       ,t1.final_update_org_id                  -- 更新机构编号
       ,t1.final_update_dt                      -- 更新日期
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_zjdk_loan_cont_info_h t1
 left join ${iml_schema}.agt_zjdk_loan_cont_info_h t2
   on t1.lmt_cont_id = t2.cont_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.lmt_cont_flg = '01' --额度合同
  and t2.job_cd = 'icmsf1'
 left join ${iol_schema}.icms_zjbk_business_contract t3
   on t1.cont_id = t3.serialno
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t3.businessflag = '2'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.lmt_cont_flg = '02' --业务合同
  and t1.job_cd = 'icmsf1'
;
commit;

-- 第三组  微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.cont_id                              -- 合同编号
       ,t1.lmt_id                               -- 授信申请流水号
       ,t1.lmt_id                               -- 额度合同编号
       ,t1.cust_id                              -- 客户编号
       ,t1.cust_name                            -- 客户名称
       ,t1.prod_id                              -- 标准产品编号
       ,'02'                                    -- 授信类型代码
       ,t1.appl_type_cd                         -- 申请类型代码
       ,t1.curr_cd                              -- 币种代码
       ,t1.base_rat_type_cd                     -- 基准利率类型代码
       ,t1.int_rat_adj_way_cd                   -- 利率调整方式代码
       ,t1.cont_status_cd                       -- 合同状态代码
       ,'1'                                     -- 审批状态代码
       ,t3.guar_way_cd                          -- 担保方式代码
       ,t2.repay_way_cd                          -- 还款方式代码
       ,t2.loan_usage_cd                         -- 贷款用途类型代码
	   ,t4.lmt_or_encrge_indus_cd		         -- 限制或鼓励行业代码
       ,t4.sup_chain_fin_bus_prod_cls_cd         -- 供应链金融业务产品分类代码
       ,t4.guar_proj_loan_type_cd		         -- 保障性安居工程贷款类型
       ,t4.buid_bus_guar_loan_type_cd	         -- 创业担保贷款类型代码
       ,t4.estate_loan_type_cd		             -- 房地产贷款类型代码
       ,t4.strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,t4.digit_econ_core_type_cd		         -- 投向数字经济核心产业类型代码
       ,t4.agclt_loan_main_type_cd		         -- 涉农贷款主体类型代码
       ,t4.agclt_loan_dir_cd		             -- 涉农贷款投向代码
       ,t4.dir_indus_cd		                     -- 贷款投向行业代码
       ,t4.loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,t4.surp_indus_cd		                 -- 过剩行业代码
       ,t4.adv_man_indu_flg		                 -- 先进制造业标志
       ,t4.green_crdt_fin_flg		             -- 绿色信贷融资标志
       ,t4.cty_lmt_indus_flg		             -- 国家限制行业标志
       ,t4.high_tech_serv_loan_flg		         -- 高技术服务业贷款标志
       ,t4.sci_tech_inovt_corp_flg		         -- 科创企业标志
       ,t4.sci_tech_corp_flg		             -- 科技型企业标志
       ,t4.high_new_tech_corp_flg		         -- 高新技术企业标志
       ,t4.spe_soph_unq_new_med_side_enter_flg	 -- 专精特新中小企业标志
       ,t4.spe_soph_unq_new_lte_gnt_corp_flg	 -- 专精特新小巨人企业标志
       ,t4.provi_for_aged_property_flg		     -- 养老产业标志
       ,t4.indu_corp_tech_rem_ugd_flg		     -- 工业转型升级标识
       ,t4.three_old_tf_or_city_update_proj_flg  -- 三旧改造或城市更新项目标志
       ,t4.br_build_ifin_flg		             -- 一带一路建设投融资标志
       ,t4.sup_chain_fin_bus_flg		         -- 供应链金融业务标志
       ,t4.buid_bus_guar_loan_flg		         -- 创业担保贷款标志
       ,t4.county_loan_flg		                 -- 县城区贷款标志
       ,t4.overs_loan_flg		                 -- 境外贷款标志
       ,t4.ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,t4.cul_property_flg		                 -- 文化产业标志
       ,t4.high_tech_property_flg		         -- 投向高技术产业标志
       ,t4.new_distr_flg		                 -- 新机制发放贷款标志
       ,t4.agclt_flg		                     -- 涉农贷款标志
       ,t4.seed_loan_flg		                 -- 种业振兴贷款标志
       ,t4.proj_fin_flg		                     -- 项目融资标志
       ,t2.distr_acct_name                       -- 收款账户名称
       ,t2.distr_org_id                          -- 收款账户开户机构编号
       ,t2.loan_int_rat                          -- 执行利率
       ,nvl(t2.loan_bal,0)                       -- 合同余额
       ,nvl(t2.loan_amt,0)                       -- 合同金额
       ,nvl(t2.loan_amt,0)                       -- 放款金额
       ,t2.loan_tenor                            -- 期限
       ,t1.cont_effect_dt                        -- 起始日期
       ,t1.init_exp_dt                           -- 到期日期
       ,t1.cont_effect_dt                        -- 签订日期
       ,t1.cont_effect_dt                        -- 放款日期
       ,t1.cont_exp_dt                           -- 终止日期
       ,null                                     -- 指定还款日
       ,t1.rgst_teller_id                        -- 经办人编号
       ,t1.rgst_org_id                           -- 经办机构编号
       ,t1.rgst_dt                               -- 经办日期
       ,t1.rgst_teller_id                        -- 登记人编号
       ,t1.rgst_org_id                           -- 登记机构编号
       ,t1.rgst_dt                               -- 登记日期
       ,t1.final_update_teller_id                -- 更新人编号
       ,t1.final_update_org_id                   -- 更新机构编号
       ,t1.final_update_dt                       -- 更新日期
       ,t1.job_cd                                -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_wyd_loan_cont_h t1
 left join ${iml_schema}.agt_wyd_dubil_h t2 
   on t1.cont_id = t2.cont_id
  and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'icmsf1'
 left join (select lmt_id,guar_way_cd,row_number() over(partition by lmt_id,guar_way_cd order by exp_dt desc) as rn 
              from ${iml_schema}.agt_wyd_guar_cont_h
             where etl_dt = to_date('${batch_date}', 'yyyymmdd')
			   and effect_flg = '1'
               and job_cd = 'icmsf1' 
		   ) t3
   on t1.lmt_id = t3.lmt_id
  and t3.rn = 1

 left join ( select t1.objectno as cont_id
                    ,''  as lmt_or_encrge_indus_cd		 -- 限制或鼓励行业代码
                    ,max(case when t1.tagid ='2025033100000043' then to_char(t1.tagvalue) else '' end)  as sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
                    ,max(case when t1.tagid ='2025033100000044' then to_char(t1.tagvalue) else '' end)  as guar_proj_loan_type_cd		 -- 保障性安居工程贷款类型
                    ,max(case when t1.tagid ='2025033100000046' then to_char(t1.tagvalue) else '' end)  as buid_bus_guar_loan_type_cd    -- 创业担保贷款类型代码
                    ,max(case when t1.tagid ='2025033100000049' then to_char(t1.tagvalue) else '' end)  as estate_loan_type_cd		     -- 房地产贷款类型代码
                    ,max(case when t1.tagid ='2025033100000050' then to_char(t1.tagvalue) else '' end)  as strate_new_indus_type_cd	     -- 战略性新兴产业类型代码
                    ,max(case when t1.tagid ='2025033100000051' then to_char(t1.tagvalue) else '' end)  as digit_econ_core_type_cd       -- 投向数字经济核心产业类型代码
                    ,max(case when t1.tagid ='2025033100000065' then to_char(t1.tagvalue) else '' end)  as agclt_loan_main_type_cd	     -- 涉农贷款主体类型代码
                    ,max(case when t1.tagid ='2025033100000066' then to_char(t1.tagvalue) else '' end)  as agclt_loan_dir_cd		     -- 涉农贷款投向代码
                    ,max(case when t1.tagid ='2025041800000023' then to_char(t2.itemno)   else '' end)  as dir_indus_cd		             -- 贷款投向行业代码
                    ,max(case when t1.tagid ='2025033100000068' then to_char(t1.tagvalue) else '' end)  as loan_fin_supt_way_cd		     -- 贷款财政扶持方式代码
                    ,max(case when t1.tagid ='2025033100000069' then to_char(t1.tagvalue) else '' end)  as surp_indus_cd		         -- 过剩行业代码
                    ,max(case when t1.tagid ='2025033100000032' then to_char(t1.tagvalue) else '' end)  as adv_man_indu_flg		         -- 先进制造业标志
                    ,max(case when t1.tagid ='2025033100000033' then to_char(t1.tagvalue) else '' end)  as green_crdt_fin_flg		     -- 绿色信贷融资标志
                    ,max(case when t1.tagid ='2025033100000034' then to_char(t1.tagvalue) else '' end)  as cty_lmt_indus_flg		     -- 国家限制行业标志
                    ,max(case when t1.tagid ='2025033100000035' then to_char(t1.tagvalue) else '' end)  as high_tech_serv_loan_flg	     -- 高技术服务业贷款标志
                    ,max(case when t1.tagid ='2025033100000036' then to_char(t1.tagvalue) else '' end)  as sci_tech_inovt_corp_flg	     -- 科创企业标志
                    ,max(case when t1.tagid ='2025033100000037' then to_char(t1.tagvalue) else '' end)  as sci_tech_corp_flg		     -- 科技型企业标志
                    ,max(case when t1.tagid ='2025033100000039' then to_char(t1.tagvalue) else '' end)  as high_new_tech_corp_flg	     -- 高新技术企业标志
                    ,max(case when t1.tagid ='2025033100000040' then to_char(t1.tagvalue) else '' end)  as spe_soph_unq_new_med_side_enter_flg -- 专精特新中小企业标志
                    ,max(case when t1.tagid ='2025033100000041' then to_char(t1.tagvalue) else '' end)  as spe_soph_unq_new_lte_gnt_corp_flg   -- 专精特新小巨人企业标志
                    ,max(case when t1.tagid ='2025033100000045' then to_char(t1.tagvalue) else '' end)  as provi_for_aged_property_flg		   -- 养老产业标志
                    ,max(case when t1.tagid ='2025033100000047' then to_char(t1.tagvalue) else '' end)  as indu_corp_tech_rem_ugd_flg		   -- 工业转型升级标识
                    ,max(case when t1.tagid ='2025033100000052' then to_char(t1.tagvalue) else '' end)  as three_old_tf_or_city_update_proj_flg-- 三旧改造或城市更新项目标志
                    ,max(case when t1.tagid ='2025033100000053' then to_char(t1.tagvalue) else '' end)  as br_build_ifin_flg		           -- 一带一路建设投融资标志
                    ,max(case when t1.tagid ='2025033100000054' then to_char(t1.tagvalue) else '' end)  as sup_chain_fin_bus_flg		       -- 供应链金融业务标志
                    ,max(case when t1.tagid ='2025033100000055' then to_char(t1.tagvalue) else '' end)  as buid_bus_guar_loan_flg		       -- 创业担保贷款标志
                    ,max(case when t1.tagid ='2025033100000056' then to_char(t1.tagvalue) else '' end)  as county_loan_flg		               -- 县城区贷款标志
                    ,max(case when t1.tagid ='2025033100000057' then to_char(t1.tagvalue) else '' end)  as overs_loan_flg		               -- 境外贷款标志
                    ,max(case when t1.tagid ='2025033100000058' then to_char(t1.tagvalue) else '' end)  as ppp_proj_flg		                   -- 投向政府和社会资本合作项目标志
                    ,max(case when t1.tagid ='2025033100000059' then to_char(t1.tagvalue) else '' end)  as cul_property_flg		               -- 文化产业标志
                    ,max(case when t1.tagid ='2025033100000060' then to_char(t1.tagvalue) else '' end)  as high_tech_property_flg		       -- 投向高技术产业标志
                    ,max(case when t1.tagid ='2025033100000061' then to_char(t1.tagvalue) else '' end)  as new_distr_flg		               -- 新机制发放贷款标志
                    ,max(case when t1.tagid ='2025033100000062' then to_char(t1.tagvalue) else '' end)  as agclt_flg		                   -- 涉农贷款标志
                    ,max(case when t1.tagid ='2025033100000063' then to_char(t1.tagvalue) else '' end)  as seed_loan_flg		               -- 种业振兴贷款标志
                    ,max(case when t1.tagid ='2025033100000064' then to_char(t1.tagvalue) else '' end)  as proj_fin_flg		                   -- 项目融资标志
             from ${iol_schema}.icms_tag_term_final_data t1
			 left join ${iol_schema}.icms_code_library t2 
			    on t2.itemname = t1.tagvalue 
               and t2.codeno = 'IndustryType'
               and length(t2.itemno)>4
			   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
			   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
			 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
			   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
			   and t1.taghirearchy = '50'
			 group by t1.objectno
           )t4
    on t1.cont_id = t4.cont_id
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
;
commit;


-- 第四组 唯品合作贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')      -- 数据日期
       ,t1.lp_id                                -- 法人编号
       ,t1.cont_id                              -- 合同编号
       ,t1.crdt_appl_id                         -- 授信申请流水号
       ,t1.cont_id                              -- 额度合同编号
       ,t1.cust_id                              -- 客户编号
       ,t1.cust_name                            -- 客户名称
       ,t1.prod_id                              -- 标准产品编号
       ,'02'                                    -- 授信类型代码
       ,null                                    -- 申请类型代码
       ,t1.curr_cd                              -- 币种代码
       ,t1.base_rat_type_cd                     -- 基准利率类型代码
       ,t1.int_rat_adj_way_cd                   -- 利率调整方式代码
       ,t1.cont_status_cd                       -- 合同状态代码
       ,null                                    -- 审批状态代码
       ,t1.main_guar_way_cd                     -- 担保方式代码
       ,''                                      -- 还款方式代码
       ,t2.loan_usage_cd                        -- 贷款用途类型代码
	   ,''		                                -- 限制或鼓励行业代码
       ,''                                      -- 供应链金融业务产品分类代码
       ,''                                      -- 保障性安居工程贷款类型
       ,''                                      -- 创业担保贷款类型代码
       ,''                                      -- 房地产贷款类型代码
       ,''                                      -- 战略性新兴产业类型代码
       ,''                                      -- 投向数字经济核心产业类型代码
       ,''                                      -- 涉农贷款主体类型代码
       ,''                                      -- 涉农贷款投向代码
       ,''                                      -- 贷款投向行业代码
       ,''                                      -- 贷款财政扶持方式代码
       ,''                                      -- 过剩行业代码
       ,''                                      -- 先进制造业标志
       ,''                                      -- 绿色信贷融资标志
       ,''                                      -- 国家限制行业标志
       ,''                                      -- 高技术服务业贷款标志
       ,''                                      -- 科创企业标志
       ,''                                      -- 科技型企业标志
       ,''                                      -- 高新技术企业标志
       ,''                                      -- 专精特新中小企业标志
       ,''                                      -- 专精特新小巨人企业标志
       ,''                                      -- 养老产业标志
       ,''                                      -- 工业转型升级标识
       ,''                                      -- 三旧改造或城市更新项目标志
       ,''                                      -- 一带一路建设投融资标志
       ,''                                      -- 供应链金融业务标志
       ,''                                      -- 创业担保贷款标志
       ,''                                      -- 县城区贷款标志
       ,''                                      -- 境外贷款标志
       ,''                                      -- 投向政府和社会资本合作项目标志
       ,''                                      -- 文化产业标志
       ,''                                      -- 投向高技术产业标志
       ,''                                      -- 新机制发放贷款标志
       ,''                                      -- 涉农贷款标志
       ,''                                      -- 种业振兴贷款标志
       ,''                                      -- 项目融资标志
       ,''                                      -- 收款账户名称
       ,''                                      -- 收款账户开户机构编号
       ,t1.exec_int_rat                         -- 执行利率
       ,t2.dubil_bal                            -- 合同余额
       ,t1.cont_amt                             -- 合同金额
       ,t1.cont_amt                             -- 放款金额
       ,t1.loan_tenor                            -- 期限
       ,t1.cont_effect_dt                       -- 起始日期
       ,t1.cont_exp_dt                          -- 到期日期
       ,t1.sign_dt                              -- 签订日期
       ,t1.cont_effect_dt                       -- 放款日期
       ,t1.cont_exp_dt                          -- 终止日期
       ,null                                    -- 指定还款日
       ,t1.rgst_teller_id                       -- 经办人编号
       ,t1.rgst_org_id                          -- 经办机构编号
       ,t1.rgst_dt                              -- 经办日期
       ,t1.rgst_teller_id                       -- 登记人编号
       ,t1.rgst_org_id                          -- 登记机构编号
       ,t1.rgst_dt                              -- 登记日期
       ,t1.rgst_teller_id                       -- 更新人编号
       ,t1.rgst_org_id                          -- 更新机构编号
       ,t1.rgst_dt                              -- 更新日期
       ,t1.job_cd                               -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_wph_loan_cont_info_h t1
 left join ${iml_schema}.agt_wph_dubil_info_h t2
   on t1.cont_id = t2.cont_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.cont_type_cd = '02'
;
commit;



-- 第五组 分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
      to_date('${batch_date}','yyyymmdd')                --数据日期
      ,t1.lp_id                                             --法人编号
      ,t1.cont_id                                           --合同编号
      ,t1.crdt_appl_id                                      --授信申请流水号
      ,t1.rela_cont_id                                      --额度合同编号
      ,t1.cust_id                                           --客户编号
      ,t1.cust_name                                         --客户名称
      ,t1.prod_id                                           --标准产品编号
      ,''                                                   --授信类型代码
      ,''                                                   --申请类型代码
      ,t1.curr_cd                                           --币种代码
      ,t1.base_rat_type_cd                                  --基准利率类型代码
      ,t1.int_rat_adj_way_cd                                --利率调整方式代码
      ,t1.cont_status_cd                                    --合同状态代码
      ,decode (t1.apv_status_cd,'Approving','3','Finished','1','Refused','2','-')     --审批状态代码
      ,t1.guar_way_cd                                       --担保方式代码
      ,t1.repay_way_cd                                      --还款方式代码
      ,''                                                    --贷款用途类型代码
      ,''                                                    --限制或鼓励行业代码
      ,''                                                    --供应链金融业务产品分类代码
      ,''                                                    --保障性安居工程贷款类型
      ,''                                                    --创业担保贷款类型代码
      ,''                                                    --房地产贷款类型代码
      ,''                                                    --战略性新兴产业类型代码
      ,''                                                    --投向数字经济核心产业类型代码
      ,''                                                    --涉农贷款主体类型代码
      ,''                                                    --涉农贷款投向代码
      ,''                                                    --贷款投向行业代码
      ,''                                                    --贷款财政扶持方式代码
      ,''                                                    --过剩行业代码
      ,''                                                    --先进制造业标志
      ,''                                                    --绿色信贷融资标志
      ,''                                                    --国家限制行业标志
      ,''                                                    --高技术服务业贷款标志
      ,''                                                    --科创企业标志
      ,''                                                    --科技型企业标志
      ,''                                                    --高新技术企业标志
      ,''                                                    --专精特新中小企业标志
      ,''                                                    --专精特新小巨人企业标志
      ,''                                                    --养老产业标志
      ,''                                                    --工业转型升级标识
      ,''                                                    --三旧改造或城市更新项目标志
      ,''                                                    --一带一路建设投融资标志
      ,''                                                    --供应链金融业务标志
      ,''                                                    --创业担保贷款标志
      ,''                                                    --县城区贷款标志
      ,''                                                    --境外贷款标志
      ,''                                                    --投向政府和社会资本合作项目标志
      ,''                                                    --文化产业标志
      ,''                                                    --投向高技术产业标志
      ,''                                                    --新机制发放贷款标志
      ,''                                                    --涉农贷款标志
      ,''                                                    --种业振兴贷款标志
      ,''                                                    --项目融资标志
      ,''                                                    --收款账户名称
      ,''                                                    --收款账户开户机构编号
      ,t1.exec_int_rat                                       --执行利率
      ,t1.loan_bal                                           --合同余额
      ,t1.cont_amt                                           --合同金额
      ,t1.distr_amt                                          --放款金额
      ,t1.mon_tenor                                          --期限
      ,t1.cont_effect_dt                                     --起始日期
      ,t1.cont_exp_dt                                        --到期日期
      ,t1.sign_dt                                            --签订日期
      ,t1.distr_dt                                           --放款日期
      ,t1.payoff_dt                                          --终止日期
      ,''                                                    --指定还款日
      ,t1.rgst_teller_id                                     --经办人编号
      ,t1.rgst_org_id                                        --经办机构编号
      ,t1.rgst_dt                                            --经办日期
      ,t1.rgst_teller_id                                     --登记人编号
      ,t1.rgst_org_id                                        --登记机构编号
      ,t1.rgst_dt                                            --登记日期
      ,t1.update_teller_id                                   --更新人编号
      ,t1.update_org_id                                      --更新机构编号
      ,t1.final_update_dt                                    --更新日期
      ,t1.job_cd                                             -- 任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.agt_lx_loan_cont_info_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.cont_type_cd = '02' --业务合同
;
commit;

-- 第六组 富民联合贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_cont_info_ex(
       etl_dt                                    -- 数据日期
       ,lp_id                                    -- 法人编号
       ,cont_id                                  -- 合同编号
       ,crdt_appl_flow_num                       -- 授信申请流水号
       ,lmt_cont_id                              -- 额度合同编号
       ,cust_id                                  -- 客户编号
       ,cust_name                                -- 客户名称
       ,std_prod_id                              -- 标准产品编号
       ,crdt_type_cd                             -- 授信类型代码
       ,appl_type_cd                             -- 申请类型代码
       ,curr_cd                                  -- 币种代码
       ,base_rat_type_cd                         -- 基准利率类型代码
       ,int_rat_adj_way_cd                       -- 利率调整方式代码
       ,cont_status_cd                           -- 合同状态代码
       ,apv_status_cd                            -- 审批状态代码
       ,guar_way_cd                              -- 担保方式代码
       ,repay_way_cd                             -- 还款方式代码
       ,loan_usage_type_cd                       -- 贷款用途类型代码
	   ,lmt_or_encrge_indus_cd		             -- 限制或鼓励行业代码
       ,sup_chain_fin_bus_prod_cls_cd            -- 供应链金融业务产品分类代码
       ,guar_proj_loan_type_cd		             -- 保障性安居工程贷款类型
       ,buid_bus_guar_loan_type_cd	             -- 创业担保贷款类型代码
       ,estate_loan_type_cd		                 -- 房地产贷款类型代码
       ,strate_new_indus_type_cd	             -- 战略性新兴产业类型代码
       ,digit_econ_core_type_cd		             -- 投向数字经济核心产业类型代码
       ,agclt_loan_main_type_cd		             -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd		                 -- 涉农贷款投向代码
       ,dir_indus_cd		                     -- 贷款投向行业代码
       ,loan_fin_supt_way_cd		             -- 贷款财政扶持方式代码
       ,surp_indus_cd		                     -- 过剩行业代码
       ,adv_man_indu_flg		                 -- 先进制造业标志
       ,green_crdt_fin_flg		                 -- 绿色信贷融资标志
       ,cty_lmt_indus_flg		                 -- 国家限制行业标志
       ,high_tech_serv_loan_flg		             -- 高技术服务业贷款标志
       ,sci_tech_inovt_corp_flg		             -- 科创企业标志
       ,sci_tech_corp_flg		                 -- 科技型企业标志
       ,high_new_tech_corp_flg		             -- 高新技术企业标志
       ,spe_soph_unq_new_med_side_enter_flg	     -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg	     -- 专精特新小巨人企业标志
       ,provi_for_aged_property_flg		         -- 养老产业标志
       ,indu_corp_tech_rem_ugd_flg		         -- 工业转型升级标识
       ,three_old_tf_or_city_update_proj_flg     -- 三旧改造或城市更新项目标志
       ,br_build_ifin_flg		                 -- 一带一路建设投融资标志
       ,sup_chain_fin_bus_flg		             -- 供应链金融业务标志
       ,buid_bus_guar_loan_flg		             -- 创业担保贷款标志
       ,county_loan_flg		                     -- 县城区贷款标志
       ,overs_loan_flg		                     -- 境外贷款标志
       ,ppp_proj_flg		                     -- 投向政府和社会资本合作项目标志
       ,cul_property_flg		                 -- 文化产业标志
       ,high_tech_property_flg		             -- 投向高技术产业标志
       ,new_distr_flg		                     -- 新机制发放贷款标志
       ,agclt_flg		                         -- 涉农贷款标志
       ,seed_loan_flg		                     -- 种业振兴贷款标志
       ,proj_fin_flg		                     -- 项目融资标志
       ,recvbl_acct_name                         -- 收款账户名称
       ,recvbl_acct_open_org_id                  -- 收款账户开户机构编号
       ,exec_int_rat                             -- 执行利率
       ,cont_bal                                 -- 合同余额
       ,cont_amt                                 -- 合同金额
       ,distr_amt                                -- 放款金额
       ,tenor                                    -- 期限
       ,begin_dt                                 -- 起始日期
       ,exp_dt                                   -- 到期日期
       ,sign_dt                                  -- 签订日期
       ,distr_dt                                 -- 放款日期
       ,termnt_dt                                -- 终止日期
       ,spec_repay_day                           -- 指定还款日
       ,operr_id                                 -- 经办人编号
       ,oper_org_id                              -- 经办机构编号
       ,oper_dt                                  -- 经办日期
       ,rgstrat_id                               -- 登记人编号
       ,rgst_org_id                              -- 登记机构编号
       ,rgst_dt                                  -- 登记日期
       ,update_id                                -- 更新人编号
       ,update_org_id                            -- 更新机构编号
       ,update_dt                                -- 更新日期
       ,job_cd                                   -- 任务代码
       ,etl_timestamp                            -- 数据处理时间
)
 select
      to_date('${batch_date}','yyyymmdd')                                                           --数据日期
      ,t1.lp_id                                                                                        --法人编号
      ,t1.cont_id                                                                                      --合同编号
      ,t1.crdt_id                                                                                      --授信申请流水号
      ,t1.rela_cont_id                                                                                 --额度合同编号
      ,t1.cust_id                                                                                      --客户编号
      ,t1.cust_name                                                                                    --客户名称
      ,t1.prod_id                                                                                      --标准产品编号
      ,t1.lmt_cont_flg                                                                                 --授信类型代码
      ,''                                                                                              --申请类型代码
      ,t1.curr_cd                                                                                      --币种代码
      ,t1.base_rat_type_cd                                                                             --基准利率类型代码
      ,t1.int_rat_adj_way_cd                                                                           --利率调整方式代码
      ,t1.cont_status_cd                                                                               --合同状态代码
      ,decode(t1.apv_status_cd,'Finished','1','Approving','3','Refused','2','Reject','2','-')       --审批状态代码
      ,t1.main_guar_way_cd                                                                             --担保方式代码
      ,t1.repay_way_cd                                                                                 --还款方式代码
      ,t1.loan_usage_cd                                                                                --贷款用途类型代码
      ,''                                                                                               --限制或鼓励行业代码
      ,''                                                                                               --供应链金融业务产品分类代码
      ,''                                                                                               --保障性安居工程贷款类型
      ,''                                                                                               --创业担保贷款类型代码
      ,''                                                                                               --房地产贷款类型代码
      ,''                                                                                               --战略性新兴产业类型代码
      ,''                                                                                               --投向数字经济核心产业类型代码
      ,''                                                                                               --涉农贷款主体类型代码
      ,''                                                                                               --涉农贷款投向代码
      ,t1.loan_dir_indus_cd                                                                             --贷款投向行业代码
      ,''                                                                                               --贷款财政扶持方式代码
      ,''                                                                                               --过剩行业代码
      ,''                                                                                               --先进制造业标志
      ,''                                                                                               --绿色信贷融资标志
      ,''                                                                                               --国家限制行业标志
      ,''                                                                                               --高技术服务业贷款标志
      ,''                                                                                               --科创企业标志
      ,''                                                                                               --科技型企业标志
      ,''                                                                                               --高新技术企业标志
      ,''                                                                                               --专精特新中小企业标志
      ,''                                                                                               --专精特新小巨人企业标志
      ,''                                                                                               --养老产业标志
      ,''                                                                                               --工业转型升级标识
      ,''                                                                                               --三旧改造或城市更新项目标志
      ,''                                                                                               --一带一路建设投融资标志
      ,''                                                                                               --供应链金融业务标志
      ,''                                                                                               --创业担保贷款标志
      ,''                                                                                               --县城区贷款标志
      ,''                                                                                               --境外贷款标志
      ,''                                                                                               --投向政府和社会资本合作项目标志
      ,''                                                                                               --文化产业标志
      ,''                                                                                               --投向高技术产业标志
      ,''                                                                                               --新机制发放贷款标志
      ,''                                                                                               --涉农贷款标志
      ,''                                                                                               --种业振兴贷款标志
      ,''                                                                                               --项目融资标志
      ,t1.enter_name                                                                                    --收款账户名称
      ,t1.enter_open_acct_org_name                                                                      --收款账户开户机构编号
      ,t1.exec_int_rat                                                                                  --执行利率
      ,t1.cont_bal                                                                                      --合同余额
      ,t1.cont_amt                                                                                      --合同金额
      ,t1.distr_amt                                                                                     --放款金额
      ,t1.mon_tenor                                                                                     --期限
      ,t1.cont_effect_dt                                                                                --起始日期
      ,t1.cont_exp_dt                                                                                   --到期日期
      ,t1.cont_effect_dt                                                                                --签订日期
      ,t1.distr_dt                                                                                      --放款日期
      ,t1.cont_exp_dt                                                                                   --终止日期
      ,''                                                                                               --指定还款日
      ,t1.rgst_teller_id                                                                                --经办人编号
      ,t1.rgst_org_id                                                                                   --经办机构编号
      ,t1.rgst_dt                                                                                       --经办日期
      ,t1.rgst_teller_id                                                                                --登记人编号
      ,t1.rgst_org_id                                                                                   --登记机构编号
      ,t1.rgst_dt                                                                                       --登记日期
      ,t1.update_teller_id                                                                              --更新人编号
      ,t1.update_org_id                                                                                 --更新机构编号
      ,t1.final_update_dt                                                                               --更新日期
      ,'icms_lh'                                                                                        -- 任务代码
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')                                   -- etl处理时间戳
 from ${iml_schema}.agt_lhwd_loan_cont_info_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and t1.lmt_cont_flg = '02' --业务合同
;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_loan_cont_info';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt	                           -- 数据日期
   ,tab_name                           -- 表名
	 ,batch_status                       -- 跑批状态
	 ,batch_tm                           -- 跑批时间
	 ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_loan_cont_info'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_loan_cont_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_loan_cont_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_loan_cont_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_loan_cont_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
