/*
Purpose:    共性加工层-对公贷款业务合同补充信息：包括所有对公信贷类型业务和同业投融资业务的合同信息，主要来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_bus_cont_attach_info
CreateDate: 20220425
Logs:       20230130 温旺清 新增字段【先进制造业标志,专精特新中小企业标志,专精特新小巨人企业标志,文化产业标志,工业企业技术改造升级标志,战略性新兴产业类型代码,高新技术企业标志,科技型企业标志,科创企业标志】
            20230419 陈伟峰 新增字段【交易资产名称、ABS/ABN名称、合同余额】,交易资产名称、ABS/ABN名称为六月投产内容，先置空
			      20230729 曹永茂 应急处理字段超长报错：过滤掉【施工许可证编号】中的中文字符
			      20231009 徐子豪 新增字段【应收账款转让方式代码】
			      20231025 徐子豪 新增字段【运营开始日期】
			      20240116 饶雅   新增字段【期限天数】、【备注】、【额度编号】
			      20240412 饶雅   新增字段【养老产业标志、投向政府和社会资本合作项目标志、新机制发放贷款标志、预测现金流覆盖借款余额标志】
			      20240516 饶雅   新增字段【种业振兴贷款标志】、【县城区贷款标志】
			      20240527 饶雅   新增字段 【投向高技术产业标志】、【投向数字经济核心产业类型代码】
			      20240828 陈伟峰 新增字段 新增字段【高技术服务业贷款标志、高技术服务业贷款类型代码】
			      20240923 陈伟峰 新增字段【关系人保证贷款标志】
			      20241226 谢宁   新增字段【占用敞口额度风险类型代码】
				    20250707 陈  凭 新增字段【商票保贴追索标志、贴现人保证金账户标志】
				    20250707 陈  凭 新增字段【房地产开发贷款标志】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info drop partition p_${retain_date};
alter table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info_ex purge;

-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_bus_cont_attach_info where 0 = 1;

insert /*+ append */ into ${icl_schema}.cmm_corp_loan_bus_cont_attach_info_ex(
       etl_dt                                 -- 数据日期
       ,lp_id                                 -- 法人编号
       ,cont_id                               -- 合同编号
       ,lmt_cont_id                           -- 额度合同编号
       ,lmt_id                                -- 额度编号
       ,cont_name                             -- 合同名称
       ,cont_type_cd                          -- 合同类型代码
       ,margin_int_rat                        -- 保证金利率
       ,gover_crdt_flg                        -- 政府授信标志
       ,gover_crdt_supt_way_cd                -- 政府授信支持方式代码
       ,gover_crdt_type_cd                    -- 政府授信类型代码
       ,cdb_crdt_breed_cd                     -- 国开授信品种代码
       ,loan_char_cd                          -- 贷款性质代码
       ,invest_char_cd                        -- 投资性质代码
       ,margin_int_rat_type_cd                -- 保证金利率类型代码
       ,margin_int_accr_method_cd             -- 保证金计息方法代码
       ,acct_recvbl_tran_way_cd               -- 应收账款转让方式代码
       ,ocup_open_lmt_risk_type_cd            -- 占用敞口额度风险类型代码
       ,m_l_claus_exist_flg                   -- 溢短装条款存在标志
       ,obank_open_flg                        -- 他行代开标志
       ,three_old_tf_or_city_update_proj_flg  -- 三旧改造或城市更新项目标志
       ,cont_begin_dt                         -- 合同起始日期
       ,cont_exp_dt                           -- 合同到期日期
       ,start_work_dt                         -- 开工日期
       ,oper_start_dt                         -- 运营开始日期
       ,batch_no                              -- 批文文号
       ,plan_lics_id                          -- 规划许可证编号
       ,arch_land_lics_id                     -- 建设用地许可证编号
       ,envir_im_ass_lics_id                  -- 环评许可证编号
       ,cnstr_lics_id                         -- 施工许可证编号
       ,other_lics_id                         -- 其他许可证编号
       ,ncds_num                              -- 同业存单号码
       ,margin_tran_out_acct_num              -- 保证金转出账号
       ,bus_info_desc                         -- 业务信息描述
       ,back_info_descb                       -- 背景信息描述
       ,cargo_name                            -- 货物名称
       ,cls_freq                              -- 分类频率
       ,m_l_ratio                             -- 溢短装比例
       ,proj_tot_invest                       -- 项目总投资
       ,capital                               -- 资本金
       ,setup_proj_batch_file                 -- 立项批文
       ,other_lics                            -- 其他许可证
       ,ncds_abbr                             -- 同业存单简称
       ,margin_int_rat_level                  -- 保证金利率档次
       ,land_use_cert_id                      -- 土地使用证编号
       ,land_use_cert_dt                      -- 土地使用证日期
       ,land_plan_lics_id                     -- 用地规划许可证编号
       ,land_plan_lics_dt                     -- 用地规划许可证日期
       ,cnstr_lics_dt                         -- 施工许可证日期
       ,proj_plan_lics_dt                     -- 工程规划许可证日期
       ,buyer_name                            -- 购货方名称
       ,seller_name                           -- 销货方名称
       ,trade_tran_content                    -- 贸易交易内容
       ,stat_use_open_bal                     -- 统计用敞口余额
       ,commer_inv_info_desc                  -- 商业发票信息描述
       ,commer_inv_curr_cd                    -- 商业发票币种代码
       ,commer_inv_amt                        -- 商业发票金额
       ,commer_inv_kind_cd                    -- 商业发票种类代码
       ,adv_man_indu_flg                      -- 先进制造业标志
       ,spe_soph_unq_new_med_side_enter_flg   -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg     -- 专精特新小巨人企业标志
       ,cul_property_flg                      -- 文化产业标志
       ,indu_corp_tech_rem_ugd_flg            -- 工业企业技术改造升级标志
       ,strate_new_indus_type_cd              -- 战略性新兴产业类型代码
       ,high_new_tech_corp_flg                -- 高新技术企业标志
       ,sci_tech_corp_flg                     -- 科技型企业标志
       ,sci_tech_inovt_corp_flg               -- 科创企业标志
       ,high_tech_property_flg                -- 投向高技术产业标志
       ,digit_econ_core_type_cd               -- 投向数字经济核心产业类型代码
       ,provi_for_aged_property_flg           -- 养老产业标志
       ,ppp_proj_flg                          -- 投向政府和社会资本合作项目标志
       ,new_distr_flg                         -- 新机制发放贷款标志
       ,cashflow_cover_bbal_flg               -- 预测现金流覆盖借款余额标志
       ,seed_loan_flg                         -- 种业振兴贷款标志
       ,county_loan_flg                       -- 县城区贷款标志
       ,high_tech_serv_loan_flg               -- 高技术服务业贷款标志
       ,high_tech_serv_loan_type_cd           -- 高技术服务业贷款类型代码
       ,rela_peop_guar_loan_flg               -- 关系人保证贷款标志
       ,rei_loan_flg                          -- 房地产开发贷款标志
	     ,buss_tiket_recs_flg                   -- 商票保贴追索标志
	     ,discnter_margin_acct_flg              -- 贴现人保证金账户标志
       ,tran_asset_name                       -- 交易资产名称
       ,abs_name                              -- ABS/ABN名称
       ,cont_bal                              -- 合同余额
       ,tenor_days                            -- 期限天数
       ,remark                                -- 备注
       ,job_cd                                -- 任务代码
       ,etl_timestamp                         -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.cont_id                                                       -- 合同编号
       ,t1.rela_cont_id                                                  -- 额度合同编号
       ,t1.lmt_id                                                        -- 额度编号
       ,t4.trust_am_cont_name                                            -- 合同名称
       ,t4.trust_am_cont_type_cd                                         -- 合同类型代码
       ,t3.margin_agt_rat                                                -- 保证金利率
       ,nvl(trim(t3.gover_crdt_flg), t4.gover_crdt_flg)                  -- 政府授信标志
       ,nvl(trim(t3.gover_crdt_supt_way_cd), t4.gover_crdt_supt_way_cd)  -- 政府授信支持方式代码
       ,nvl(trim(t3.gover_crdt_type_cd), t4.gover_crdt_type_cd)          -- 政府授信类型代码
       ,nvl(trim(t3.cdb_crdt_prod_id), t4.cdb_crdt_prod_id)              -- 国开授信品种代码
       ,t3.loan_char_cd                                                  -- 贷款性质代码
       ,t4.invest_char_cd                                                -- 投资性质代码
       ,t3.margin_int_rat_type_cd                                        -- 保证金利率类型代码
       ,t3.margin_int_accr_method_cd                                     -- 保证金计息方法代码
       ,t3.acct_recvbl_tran_way_cd                                       -- 应收账款转让方式代码
       ,t1.ocup_open_lmt_risk_type_cd                                    -- 占用敞口额度风险类型代码
       ,t3.exist_m_l_claus_flg                                           -- 溢短装条款存在标志
       ,t3.obank_open_flg                                                -- 他行代开标志
       ,t3.three_old_trasf_city_update_proj_flg                          -- 三旧改造或城市更新项目标志
       ,t4.issue_dt                                                      -- 合同起始日期
       ,t4.exp_dt                                                        -- 合同到期日期
       ,t3.start_work_dt                                                 -- 开工日期
       ,t3.oper_start_dt                                                 -- 运营开始日期
       ,t3.batch_id                                                      -- 批文文号
       ,t3.plan_lics_id                                                  -- 规划许可证编号
       ,t3.arch_land_lics_id                                             -- 建设用地许可证编号
       ,t3.hp_lics_id                                                    -- 环评许可证编号
       ,t3.cnstr_lics_id                                                 -- 施工许可证编号
       ,t3.other_lics_id                                                 -- 其他许可证编号
       ,t4.dep_rcpt_no_code                                              -- 同业存单号码
       ,t3.margin_tran_out_acct_id                                       -- 保证金转出账号
       ,nvl(trim(t3.tran_bg_descb), t4.tran_bg_descb)                    -- 业务信息描述
       ,t3.traff_way_cd                                                  -- 背景信息描述
       ,t3.cargo_name                                                    -- 货物名称
       ,t3.cls_freq                                                      -- 分类频率
       ,t3.m_l_ratio                                                     -- 溢短装比例
       ,t3.proj_tot_invest_amt                                           -- 项目总投资
       ,t3.capital_amt                                                   -- 资本金
       ,t3.setup_proj_batch_id                                           -- 立项批文
       ,t3.other_lics_name                                               -- 其他许可证
       ,t4.ncds_abbr                                                     -- 同业存单简称
       ,t3.margin_int_rat_level_cd                                       -- 保证金利率档次
       ,t5.landuseno                                                     -- 土地使用证编号
       ,t5.landusedate                                                   -- 土地使用证日期
       ,t5.landplanpermitno                                              -- 用地规划许可证编号
       ,t5.landplanpermitdate                                            -- 用地规划许可证日期
       ,t5.constructpermitdate                                           -- 施工许可证日期
       ,t5.projectplanpermitdate                                         -- 工程规划许可证日期
       ,t5.buyername                                                     -- 购货方名称
       ,t5.sellername                                                    -- 销货方名称
       ,t5.tradetransactioncontent                                       -- 贸易交易内容
       ,t1.open_amt_stat                                                 -- 统计用敞口余额
       ,nvl(trim(t3.commer_inv_id), t4.commer_inv_id)                    -- 商业发票信息描述
       ,coalesce(t3.commer_inv_curr_cd, t4.commer_inv_curr_cd,'-')       -- 商业发票币种代码
       ,nvl(trim(t3.commer_inv_amt), t4.commer_inv_amt)                  -- 商业发票金额
       ,nvl(trim(t3.commer_inv_type_cd), t4.commer_inv_type_cd)          -- 商业发票种类代码
       ,t3.advanced_manu_flg                                             -- 先进制造业标志
       ,t3.only_new_minorent_flg                                         -- 专精特新中小企业标志
       ,t3.only_new_littlegiantent_flg                                   -- 专精特新小巨人企业标志
       ,t3.cultur_industry_flg                                           -- 文化产业标志
       ,t3.indent_tech_flg                                               -- 工业企业技术改造升级标志
       ,t3.strtg_new_indus_type_cd                                       -- 战略性新兴产业类型代码
       ,t1.high_new_tech_corp_flg                                        -- 高新技术企业标志
       ,t1.scen_tech_corp_flg                                            -- 科技型企业标志
       ,t1.tech_inovt_corp_flg                                           -- 科创企业标志
       ,t1.high_tech_property_flg                                        -- 投向高技术产业标志
       ,t1.digit_econ_core_type_cd                                       -- 投向数字经济核心产业类型代码
       ,t1.provi_for_aged_property_flg                                   -- 养老产业标志
       ,t3.ppp_proj_flg                                                  -- 投向政府和社会资本合作项目标志
       ,t3.new_distr_flg                                                 -- 新机制发放贷款标志
       ,t3.cashflow_cover_bbal_flg                                       -- 预测现金流覆盖借款余额标志
       ,t1.seed_loan_flg                                                 -- 种业振兴贷款标志
       ,t1.county_loan_flg                                               -- 县城区贷款标志
       ,t3.high_tech_serv_loan_flg                                       -- 高技术服务业贷款标志
       ,t3.high_tech_serv_loan_type_cd                                   -- 高技术服务业贷款类型代码
       ,t3.rela_peop_guar_loan_flg                                       -- 关系人保证贷款标志
       ,t3.rei_loan_flg                                                  -- 房地产开发贷款标志
	     ,t1.buss_tiket_recs_flg                                           -- 商票保贴追索标志
	     ,t1.discnter_margin_acct_flg                                      -- 贴现人保证金账户标志
       ,t4.tran_asset_name                                               -- 交易资产名称
       ,t4.abs_tran_name                                                 -- abs/abn名称
       ,t1.curr_bal                                                      -- 合同余额
       ,t1.day_tenor                                                     -- 期限天数
       ,t1.remark                                                        -- 备注
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_cont_info_h t1
  inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h t3
    on t1.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h t4
    on t1.agt_id = t4.agt_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'icmsf1'
  left join iol.icms_bc_extend_d t5
    on t1.cont_id= t5.serialno
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.lmt_cont_flg = '02'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info_ex purge;

-- 3.2 drop temp table

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_corp_loan_bus_cont_attach_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

