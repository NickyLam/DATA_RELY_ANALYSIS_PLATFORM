/*
Purpose:    共性加工层-对公贷款合同信息：包括所有对公贷款业务的贷款合同信息及授信合同信息，包含对公表内贷款业务、表外业务、同业表内业务、同业表外业务等业务的贷款合同及授信合同信息（授信类型代码：01-额度合同，02-业务合同）。数据来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_cont_info
CreateDate: 20190808
Logs:       20200110 翟若平 调整字段[本金还款方式代码]的取数逻辑agt_loan_cont_info.pric_repay_way_cd->''
            20200327 翟若平 增加字段[交易对手实力、与交易对手合作年限、与交易对手成功交易次数]
            20200424 周沁晖 增加字段[人工合同编号]
            20200716 谢宁   增加字段 [已用授信额度][剩余授信额度]
            20201203 谢 宁  调整字段[绿色信贷融资标志]
            20201217 陈伟峰 调整字段【战略新兴产业类型代码】、【绿色信贷融资标志】取数关联逻辑
            20210223 谢 宁  调整字段[有效标志代码],过滤条件matn_flg (t1.matn_flg is null or t1.matn_flg <> '2') -->(t1.matn_flg = '-' or t1.matn_flg <> '0')
            20210318 陈伟峰 增加字段【同业债券编号】
            20210414 谢 宁 调整【执行利率】
            20210420 陈伟峰 增加字段【靠档计息标志】
            20210601 谢 宁 调整【合同可用余额】逻辑
            20210820 何桐金 增加字段【办理渠道代码TRAST_CHN_CD、银团贷款总金额SYN_LOAN_TOT_AMT】
            20210930 陈伟峰 修复【消费服务类融资标志、结算性存款标志、含有回售选择权标志、可分离标志、线上业务标志、类信贷标志、授信业务流程类型代码、授信区域代码、房地产融资标志、政府类融资标志1】字段错位问题
            20211027 何桐金 增加字段【涉农贷款标志、涉农贷款主体类型代码、涉农贷款投向代码、平台偿债资金来源代码、创业担保贷款标志、创业担保贷款类型代码】
            20211105 陈伟峰 增加字段【出账标志】
            20220218 陈伟峰 增加字段【资产三分类代码】
            20220305 陈伟峰 新增字段【同业交易机构编号】
            20220422 李森辉 1、取数数据源调整，由原对公信贷系统改成新的综合信贷系统；
                            2、置空字段【贷款来源代码】
                            3、新增字段【第二担保方式代码、重点贷款项目代码、融资合同标志、贷款入账账号、基准利率类型代码、利率模式代码、预留金额】
                            4、调整字段【业务品种编号】的取数口径（置空，新信贷整合到标准产品）
            20220606 李森辉 1、新增字段【标准产品编号】
                            2、调整字段【循环标志、靠档计息标志、主办行行号、参贷行行号、代理行行号、同业交易机构编号、相关合同编号、批量数据来源代码、备份额度生效代码、备份额度合同编号、线上业务标志、出账标志、授信业务流程类型代码、资产三分类代码、利率浮动值、合同可用余额、累计发放金额、累计回收金额、已用授信额度、剩余授信额度】的加工口径
                            3、置空字段【收费方式代码-CHARGE_WAY_CD、靠档计息标志-FILE_INT_ACCR_FLG、票据唯一标识编号-BILL_UNIQ_IDF_ID、手续费金额-COMM_FEE_AMT】
                            4、调整T1表过滤条件【(T1.ISINUSE IS NULL OR T1.ISINUSE <> '2') -》 SUBSTR(T1.PRODUCTID, 1, 3) NOT IN ('201', '202')】
                            5、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
		        20220908 黄俊杰 【授信区域代码】t8.crdt_rg_cd-》nvl(trim(t8.crdt_rg_cd),'00')  
		        20221009 曹永茂 【保证金币种代码】的默认值‘-’转为‘CNY’，保持和生产一致
		        20221027 温旺清 1、增加字段【同业资产唯一标识编号】
		        20230202 翟若平 调整字段【敞口余额、合同可用余额】的加工口径
            20230309 温旺清 调整【风险暴露分类】加工口径
            20230606 陈伟峰 调整字段【敞口余额、合同可用余额】的加工口径
            20231218 饶雅   调整字段【转授信标志】的加工口径
            20240605 饶雅   调整敞口余额的口径
            20240605 陈伟峰 调整【供应链金融业务产品分类代码,供应链金融业务标志】处理默认值
			20250427 陈  凭 新增字段【申请流水号】
			20251216 陈伟峰 新增字段【重组类型代码REGROUP_TYPE_CD】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_cont_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_cont_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_cont_info_ex purge;

create table ${icl_schema}.cmm_corp_loan_cont_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_cont_info where 0=1;

-- 2.2 insert data to ex table

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_cont_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,cont_id                        -- 合同编号
       ,cust_id                        -- 客户编号
       ,lmt_cont_id                    -- 额度合同编号
       ,apv_flow_num                   -- 审批流水号
	   ,aplv_flow_num                  -- 申请流水号
       ,manu_cont_id                   -- 人工合同编号
       ,bus_breed_id                   -- 业务品种编号
       ,std_prod_id                    -- 标准产品编号
       ,bus_sub_type_cd                -- 业务子类型代码
       ,loan_happ_type_cd              -- 贷款发生类型代码
       ,cont_type_cd                   -- 合同类型代码
       ,entr_loan_espec_dir_cd         -- 委托贷款特殊投向代码
       ,strtg_new_indus_type_cd        -- 战略新兴产业类型代码
       ,prod_type_cd                   -- 产品类型代码
       ,valid_flg_cd                   -- 有效标志代码
       ,dir_indus_cd                   -- 贷款贷款贷款投向行业代码
       ,surp_indus_cd                  -- 过剩行业代码
       ,sub_guar_way_cd                -- 子担保方式代码
       ,guar_type_cd                   -- 担保类型代码
       ,major_guar_way_cd              -- 主要担保方式代码
       ,secd_guar_way_cd               -- 第二担保方式代码
       ,crdt_type_cd                   -- 授信类型代码
       ,appl_way_cd                    -- 申请方式代码
       ,loan_fin_supt_way_cd           -- 贷款财政扶持方式代码
       ,invest_way_cd                  -- 投资方式代码
       ,mgmt_mode_cd                   -- 管理模式代码
       ,loan_level5_cls_cd             -- 贷款五级分类代码
       ,loan_level10_cls_cd            -- 贷款十级分类代码
       ,tenor_type_cd                  -- 期限类型代码
       ,pric_repay_way_cd              -- 本金还款方式代码
       ,int_rat_float_way_cd           -- 利率浮动方式代码
       ,charge_way_cd                  -- 收费方式代码
       ,draw_way_cd                    -- 提款方式代码
       ,cap_src_cd                     -- 资金来源代码
       ,int_rat_adj_way_cd             -- 利率调整方式代码
       ,curr_cd                        -- 币种代码
       ,sup_chain_fin_bus_prod_cls_cd  -- 供应链金融业务产品分类代码
       ,imp_loan_proj                  -- 重点贷款项目代码
       ,sup_chain_fin_bus_flg          -- 供应链金融业务标志
       ,agent_patip_loan_flg           -- 代理参贷标志
       ,lmt_circl_flg                  -- 额度循环标志
       ,circl_flg                      -- 循环标志
       ,temp_store_flg                 -- 暂存标志
       ,froz_flg                       -- 冻结标志
       ,turn_crdt_flg                  -- 转授信标志
       ,remote_loan_flg                -- 异地贷款标志
       ,other_guar_way_flg             -- 其他担保方式标志
       ,imp_proj_loan_flg              -- 重点项目贷款标志
       ,cty_lmt_indus_flg              -- 国家限制行业标志
       ,gover_crdt_flg                 -- 政府授信标志
       ,cdb_crdt_flg                   -- 国开行授信标志
       ,fix_asset_crdt_flg             -- 固定资产授信标志
       ,qual_centr_cntpty_flg          -- 合格中央交易对手标志
       ,fin_sys_cont_flg               -- 融资合同标志
       ,low_risk_bus_flg               -- 低风险业务标志
       ,file_int_accr_flg              -- 靠档计息标志
       ,host_bank_no                   -- 主办行行号
       ,patip_loan_bank_no             -- 参贷行行号
       ,agent_bank_no                  -- 代理行行号
       ,cntpty_strg                    -- 交易对手实力
       ,cntpty_co_years                -- 与交易对手合作年限
       ,cntpty_sucs_tran_cnt           -- 与交易对手成功交易次数
       ,mgmt_org_id                    -- 管理机构编号
       ,rgst_org_id                    -- 登记机构编号
       ,oper_org_id                    -- 经办机构编号
       ,distr_org_id                   -- 放款机构编号
       ,ibank_tran_org_id              -- 同业交易机构编号
       ,mgmt_teller_id                 -- 管理柜员编号
       ,oper_teller_id                 -- 经办柜员编号
       ,rgst_teller_id                 -- 登记柜员编号
       ,start_dt                       -- 起始日期
       ,distr_dt                       -- 发放日期
       ,exp_dt                         -- 到期日期
       ,oper_dt                        -- 经办日期
       ,rgst_dt                        -- 登记日期
       ,termnt_dt                      -- 终止日期
       ,lmt_use_latest_dt              -- 额度使用最迟日期
       ,lmt_under_bus_latest_exp_dt    -- 额度项下业务最迟到期日期
       ,loan_usage_descb               -- 贷款用途描述
       ,repay_src_descb                -- 还款来源描述
       ,other_cond_request_descb       -- 其他条件和要求描述
       ,trdpty_cust_name1              -- 第三方客户名称1
       ,trdpty_cust_name2              -- 第三方客户名称2
       ,rela_cont_id                   -- 相关合同编号
       ,loan_enter_acct_acct_num       -- 贷款入账账号
       ,stl_acct_num                   -- 结算账号
       ,margin_acct_num                -- 保证金账号
       ,margin_curr_cd                 -- 保证金币种代码
       ,margin_ratio                   -- 保证金比例
       ,margin_amt                     -- 保证金金额
       ,tran_market_type_cd            -- 交易市场类型代码
       ,incre_crdt_way_cd              -- 增信方式代码
       ,batch_data_src_cd              -- 批量数据来源代码
       ,backup_lmt_effect_cd           -- 备份额度生效代码
       ,backup_lmt_cont_id             -- 备份额度合同编号
       ,risk_type_cd                   -- 风险类型代码
       ,major_loan_cls_cd              -- 专业贷款分类代码
       ,risk_expose_cls                -- 风险暴露分类
       ,underly_prod_cls_flg           -- 标的产品分级标志
       ,underly_prod_cls_lev_cd        -- 标的产品分级级别代码
       ,tran_asset_name                -- 交易资产名称
       ,agclt_flg                      -- 涉农贷款标志
       ,agclt_loan_main_type_cd        -- 涉农贷款主体类型代码
       ,agclt_loan_dir_cd              -- 涉农贷款投向代码
       ,plat_solv_cap_src_cd           -- 平台偿债资金来源代码
       ,buid_bus_guar_loan_flg         -- 创业担保贷款标志
       ,buid_bus_guar_loan_type_cd     -- 创业担保贷款类型代码
       ,regroup_type_cd                -- 重组类型代码
       ,dir_ind_fund_flg               -- 投向产业基金标志
       ,dir_makti_debt_eqty_flg        -- 投向市场化债转股标志
       ,invo_gover_class_fin_flg       -- 涉及政府类融资标志
       ,consm_serv_class_fin_flg       -- 消费服务类融资标志
       ,stl_dep_flg                    -- 结算性存款标志
       ,cota_opt_choice_flg            -- 含有回售选择权标志
       ,septbl_flg                     -- 可分离标志
       ,onl_bus_flg                    -- 线上业务标志
       ,class_crdt_flg                 -- 类信贷标志
       ,out_acct_flg                   -- 出账标志
       ,ibank_bond_id                  -- 同业债券编号
       ,crdt_bus_flow_type_cd          -- 授信业务流程类型代码
       ,crdt_rg_cd                     -- 授信区域代码
       ,estate_fin_flg                 -- 房地产融资标志
       ,estate_loan_type_cd            -- 房地产贷款类型代码
       ,final_dir_type_cd              -- 最终投向类型代码
       ,pente_type_cd                  -- 穿透类型代码
       ,asset_thd_cls_cd               -- 资产三分类代码
       ,gover_class_fin_flg1           -- 政府类融资标志1
       ,br_build_ifin_flg              -- 一带一路建设投融资标志
       ,green_crdt_fin_flg             -- 绿色信贷融资标志
       ,trade_cont_id                  -- 贸易合同编号
       ,trade_cont_curr_cd             -- 贸易合同币种代码
       ,trade_cont_amt                 -- 贸易合同金额
       ,bill_qtty                      -- 票据数量
       ,discnt_bf_revw_flg             -- 先贴后查标志
       ,discnt_int_buyer_bear_ratio    -- 贴现利息买方承担比例
       ,discnt_int_applit_pay_ratio    -- 贴现利息申请人支付比例
       ,agt_pay_int_flg                -- 协议付息标志
       ,bill_uniq_idf_id               -- 票据唯一标识编号
       ,ibank_asset_uniq_idf_id        -- 同业资产唯一标识编号
       ,trdpty_acct_id                 -- 第三方账户编号
       ,loan_src_cd                    -- 贷款来源代码
       ,comm_fee_rat                   -- 手续费费率
       ,comm_fee_amt                   -- 手续费金额
       ,lc_id                          -- 信用证编号
       ,lc_amt                         -- 信用证金额
       ,trast_chn_cd                   -- 办理渠道代码
       ,syn_loan_tot_amt               -- 银团贷款总金额
       ,syn_loan_distr_amt             -- 银团贷款发放金额
       ,tenor                          -- 期限
       ,base_rat_type_cd               -- 基准利率类型代码
       ,base_rat                       -- 基准利率
       ,int_rat_flo_val                -- 利率浮动值
       ,int_rat_mode_cd                -- 利率模式代码
       ,exec_int_rat                   -- 执行利率
       ,rsrv_amt                       -- 预留金额
       ,bank_fin_tot                   -- 银行融资总额
       ,open_bal                       -- 敞口余额
       ,underly_prod_coll_amt          -- 标的产品募集金额
       ,cont_amt                       -- 合同金额
       ,cont_aval_bal                  -- 合同可用余额
       ,acm_distr_amt                  -- 累计发放金额
       ,acm_callbk_amt                 -- 累计回收金额
       ,occu_crdt_lmt                  -- 已用授信额度
       ,surp_crdt_lmt                  -- 剩余授信额度
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                                                     -- 数据日期
       ,t1.lp_id                                                                                                               -- 法人编号
       ,t1.cont_id                                                                                                             -- 合同编号
       ,t1.cust_id                                                                                                             -- 客户编号
       ,t1.rela_cont_id                                                                                                        -- 额度合同编号
       ,t1.apv_flow_num                                                                                                        -- 审批流水号
	   ,t12.appl_flow_num                                                                                                      -- 申请流水号
       ,t1.text_cont_id                                                                                                        -- 人工合同编号
       ,''                                                                                                                     -- 业务品种编号
       ,t1.prod_id                                                                                                             -- 标准产品编号
       ,nvl(trim(t3.lc_tenor_type_cd), t3.factor_type_cd)                                                                      -- 业务子类型代码
       ,t1.loan_distr_type_cd                                                                                                  -- 贷款发生类型代码
       ,coalesce(trim(t3.cont_type_cd), trim(t4.cont_type_cd), '00')                                                           -- 合同类型代码
       ,nvl(trim(t3.entr_loan_espec_dir_cd),'-')                                                                               -- 委托贷款特殊投向代码
       ,t7.strtg_new_indus_type_cd                                                                                             -- 战略新兴产业类型代码
       ,coalesce(trim(t3.trade_fin_prod_id), trim(t4.use_prod_cd), '-')                                                        -- 产品类型代码
       ,t1.cont_status_cd                                                                                                      -- 有效标志代码
       ,t1.nat_std_indus_dir_cd                                                                                                -- 贷款贷款贷款投向行业代码
       ,nvl(trim(t3.surp_indus_cd), t4.surp_indus_cd)                                                                          -- 过剩行业代码
       ,t1.sub_guar_way_cd                                                                                                     -- 子担保方式代码
       ,coalesce(trim(t3.guar_type_cd), trim(t4.guar_type_cd), '-')                                                            -- 担保类型代码
       ,t1.main_guar_way_cd                                                                                                    -- 主要担保方式代码
       ,t1.guar_way_cd_two                                                                                                     -- 第二担保方式代码
       ,t1.lmt_cont_flg                                                                                                        -- 授信类型代码
       ,t1.appl_way_cd                                                                                                         -- 申请方式代码
       ,coalesce(trim(t3.loan_fin_supt_way_cd), trim(t4.loan_fin_supt_way_cd),'-')                                             -- 贷款财政扶持方式代码
       ,t4.invest_way_cd                                                                                                       -- 投资方式代码
       ,t4.mgmt_mode_cd                                                                                                        -- 管理模式代码
       ,t1.level5_cls_cd                                                                                                       -- 贷款五级分类代码
       ,t1.level11_cls_cd                                                                                                      -- 贷款十级分类代码
       ,'M'                                                                                                                    -- 期限类型代码
       ,coalesce(trim(t3.repay_way_cd), trim(t4.repay_way_cd), trim(t1.repay_way_cd))                                          -- 本金还款方式代码
       ,t1.int_rat_float_type_cd                                                                                               -- 利率浮动方式代码
       ,''                                                                                                                     -- 收费方式代码
       ,coalesce(trim(t3.draw_way_cd), trim(t4.draw_way_cd),'00')                                                              -- 提款方式代码
       ,nvl(trim(t3.cap_src_cd), t4.cap_src_cd)                                                                                -- 资金来源代码
       ,t1.int_rat_adj_way_cd                                                                                                  -- 利率调整方式代码
       ,t1.curr_cd                                                                                                             -- 币种代码
       ,nvl(trim(decode(t3.sup_chain_fin_bus_prod_cls_cd,'00','',t3.sup_chain_fin_bus_prod_cls_cd)), t4.sup_chain_fin_bus_prod_cls_cd)    -- 供应链金融业务产品分类代码
       ,nvl(trim(t3.imp_loan_proj_cd), t4.imp_loan_proj_cd)                                                                    -- 重点贷款项目代码
       ,nvl(trim(decode(t3.sup_chain_fin_bus_flg,'-','',t3.sup_chain_fin_bus_flg)), t4.sup_chain_fin_bus_flg)                  -- 供应链金融业务标志
       ,t5.agent_patip_loan_flg                                                                                                -- 代理参贷标志
       ,nvl(trim(t1.lmt_circl_flg),'0')                                                                                        -- 额度循环标志
       ,'0'                                                                                                                    -- 循环标志
       ,nvl(trim(t1.data_input_integy_flg),'0')                                                                                -- 暂存标志
       ,nvl(trim(t1.froz_flg),'0')                                                                                             -- 冻结标志
       ,nvl(trim(t8.turn_crdt_flg),'0')                                                                                        -- 转授信标志
       ,nvl(trim(t3.remote_bus_flg),'0')                                                                                       -- 异地贷款标志
       ,nvl(trim(t1.supp_guar_way_flg),'0')                                                                                    -- 其他担保方式标志
       ,decode(nvl(trim(t3.imp_loan_proj_flg), t4.imp_loan_proj_flg),'1','1','0')                                              -- 重点项目贷款标志
       ,decode(nvl(trim(t3.cty_lmt_indus_flg), t4.cty_lmt_indus_flg),'1','1','0')                                              -- 国家限制行业标志
       ,decode(nvl(trim(t3.gover_crdt_flg), t4.gover_crdt_flg),'1','1','0')                                                    -- 政府授信标志
       ,decode(nvl(trim(t3.cdb_crdt_flg), t4.cdb_crdt_flg),'1','1','0')                                                        -- 国开行授信标志
       ,decode(nvl(trim(t3.fix_asset_crdt_flg), t4.fix_asset_crdt_flg),'1','1','0')                                            -- 固定资产授信标志
       ,decode(nvl(trim(t3.qual_centr_cntpty_flg), t4.qual_centr_cntpty_flg) ,'1','1','0')                                     -- 合格中央交易对手标志
       ,decode(nvl(trim(t3.fin_cont_flg), trim(t8.fin_cont_flg)),'1','1','0')                                                  -- 融资合同标志
       ,nvl(trim(t1.low_risk_bus_flg),'0')                                                                                           -- 低风险业务标志
       ,''                                                                                                                     -- 靠档计息标志
       ,t5.host_bank_no                                                                                                        -- 主办行行号
       ,t5.patip_loan_bank_no                                                                                                  -- 参贷行行号
       ,t5.agent_bank_no                                                                                                       -- 代理行行号
       ,nvl(trim(t3.cntpty_strg), t4.cntpty_strg)                                                                              -- 交易对手实力
       ,nvl(trim(t3.cntpty_co_years), t4.cntpty_co_years)                                                                      -- 与交易对手合作年限
       ,nvl(trim(t3.cntpty_sucs_tran_cnt), t4.cntpty_sucs_tran_cnt)                                                            -- 与交易对手成功交易次数
       ,t1.lon_post_mgmt_org_id                                                                                                -- 管理机构编号
       ,t1.rgst_org_id                                                                                                         -- 登记机构编号
       ,t1.oper_org_id                                                                                                         -- 经办机构编号
       ,t1.core_out_acct_org_id                                                                                                -- 放款机构编号
       ,t1.core_out_acct_org_id                                                                                                -- 同业交易机构编号
       ,t1.lon_post_mgmt_teller_id                                                                                             -- 管理柜员编号
       ,t1.oper_teller_id                                                                                                      -- 经办柜员编号
       ,t1.rgst_teller_id                                                                                                      -- 登记柜员编号
       ,t1.happ_dt                                                                                                             -- 起始日期
       ,t1.cont_effect_dt                                                                                                      -- 发放日期
       ,t1.cont_exp_dt                                                                                                         -- 到期日期
       ,t1.oper_dt                                                                                                             -- 经办日期
       ,t1.rgst_dt                                                                                                             -- 登记日期
       ,t1.termnt_dt                                                                                                           -- 终止日期
       ,nvl(t8.lmt_invalid_dt,to_date('29991231','yyyymmdd'))                                                                  -- 额度使用最迟日期
       ,nvl(t8.lmt_under_bus_latest_exp_dt,to_date('29991231','yyyymmdd'))                                                     -- 额度项下业务最迟到期日期
       ,t1.usage_descb                                                                                                         -- 贷款用途描述
       ,nvl(trim(t3.repay_comnt_descb), t4.repay_comnt_descb)                                                                  -- 还款来源描述
       ,nvl(trim(t3.other_cond_request_descb), t4.repay_comnt_descb)                                                           -- 其他条件和要求描述
       ,nvl(trim(t3.csner_name), t4.csner_name)                                                                                -- 第三方客户名称1
       ,nvl(trim(t3.csner_id), t4.csner_id)                                                                                    -- 第三方客户名称2
       ,t1.rela_old_cont_id                                                                                                    -- 相关合同编号
       ,t1.enter_id                                                                                                            -- 贷款入账账号
       ,t1.stl_acct_id                                                                                                         -- 结算账号
       ,t3.margin_acct_id                                                                                                      -- 保证金账号
       ,decode(trim(t3.margin_curr_cd),'-','CNY','','CNY',t3.margin_curr_cd)                                                   -- 保证金币种代码
       ,t1.margin_ratio                                                                                                        -- 保证金比例
       ,t1.margin_amt                                                                                                          -- 保证金金额
       ,nvl(trim(t4.tran_market_type_cd), 'XXX')                                                                               -- 交易市场类型代码
       ,coalesce(trim(t3.major_incre_crdt_way_cd), trim(t4.incre_crdt_way_cd),'00')                                            -- 增信方式代码
       ,t4.batch_data_src_cd                                                                                                   -- 批量数据来源代码
       ,t1.backup_status_cd                                                                                                    -- 备份额度生效代码
       ,t1.backup_lmt_cont_id                                                                                                  -- 备份额度合同编号
       ,t1.risk_type_cd                                                                                                        -- 风险类型代码
       ,t8.major_loan_cls_cd                                                                                                   -- 专业贷款分类代码
       ,t8.risk_expose_cls                                                                                                     -- 风险暴露分类
       ,nvl(trim(t4.underly_prod_cls_flg), '-')                                                                                -- 标的产品分级标志
       ,nvl(trim(t3.underly_prod_cls_lev_cd), t4.underly_prod_cls_lev_cd)                                                      -- 标的产品分级级别代码
       ,nvl(trim(t3.tran_asset_name), t4.tran_asset_name)                                                                      -- 交易资产名称
       ,nvl(nvl(decode(trim(t3.agclt_flg),'-','',trim(t3.agclt_flg)), trim(t4.agclt_flg)),'-')                                 -- 涉农贷款标志
       ,nvl(trim(t3.agclt_loan_main_type_cd), '-')                                                                             -- 涉农贷款主体类型代码
       ,nvl(trim(t3.agclt_loan_dir_cd), '-')                                                                                   -- 涉农贷款投向代码
       ,nvl(trim(t3.loc_fin_plat_solv_cap_src_cd), '-')                                                                        -- 平台偿债资金来源代码
       ,nvl(trim(t3.start_up_bus_guar_loan_flg), '-')                                                                          -- 创业担保贷款标志
       ,nvl(trim(t3.start_up_bus_guar_loan_type_cd), '-')                                                                      -- 创业担保贷款类型代码
       ,t13.renewaltype                                                                                                           -- 重组类型代码
       ,nvl(trim(t3.dir_ind_fund_flg), t4.dir_ind_fund_flg)                                                                    -- 投向产业基金标志
       ,nvl(trim(t3.dir_makti_debt_eqty_flg), t4.dir_makti_debt_eqty_flg)                                                      -- 投向市场化债转股标志
       ,nvl(trim(t3.invo_gover_class_fin_flg), t4.invo_gover_class_fin_flg)                                                    -- 涉及政府类融资标志
       ,nvl(trim(t3.consm_serv_class_fin_flg), t4.consm_serv_class_fin_flg)                                                    -- 消费服务类融资标志
       ,t4.stl_dep_flg                                                                                                         -- 结算性存款标志
       ,t4.cota_opt_choice_flg                                                                                                 -- 含有回售选择权标志
       ,t4.septbl_flg                                                                                                          -- 可分离标志
       ,t1.onl_bus_flg                                                                                                         -- 线上业务标志
       ,t4.class_crdt_flg                                                                                                      -- 类信贷标志
       ,'0'                                                                                                                    -- 出账标志
       ,nvl(trim(t3.underly_prod_id), t4.underly_prod_id)                                                                      -- 同业债券编号
       ,t8.crdt_bus_flow_type_cd                                                                                               -- 授信业务流程类型代码
       ,nvl(trim(t8.crdt_rg_cd),'00')                                                                                                          -- 授信区域代码
       ,t8.invo_estate_fin_flg                                                                                                 -- 房地产融资标志
       ,nvl(trim(t3.estate_loan_type_cd),'-')                                                                                  -- 房地产贷款类型代码
       ,t4.uder_asset_type_cd                                                                                                  -- 最终投向类型代码
       ,t4.pente_type_cd                                                                                                       -- 穿透类型代码
       ,nvl(trim(t1.asset_thd_cls_cd),'XXX')                                                                                   -- 资产三分类代码
       ,nvl(trim(t8.invo_gover_class_fin_flg),'-')                                                                            -- 政府类融资标志1
       ,t8.br_build_ifin_flg                                                                                                   -- 一带一路建设投融资标志
       ,t9.green_crdt_cust_flg                                                                                                 -- 绿色信贷融资标志
       ,nvl(trim(t3.trade_cont_id), t4.rela_trade_cont_id)                                                                     -- 贸易合同编号
       ,nvl(trim(t3.entr_dep_curr_cd),'CNY')                                                                                   -- 贸易合同币种代码
       ,case when nvl(t3.trade_cont_tot_amt, 0) = 0 then nvl(t4.trade_cont_tot_amt, 0) else nvl(t3.trade_cont_tot_amt, 0) end  -- 贸易合同金额
       ,t3.draft_qtty                                                                                                          -- 票据数量
       ,t3.discnt_bf_revw_flg                                                                                                  -- 先贴后查标志
       ,case when nvl(t3.discnt_int_applit_pay_ratio, 0) = 0 then nvl(t3.loan_amt_ocup_tran_price_money_ratio, 0) 
             else nvl(t3.discnt_int_applit_pay_ratio, 0)
        end                                                                                                                    -- 贴现利息买方承担比例
       ,t3.discnt_int_applit_pay_ratio                                                                                         -- 贴现利息申请人支付比例
       ,t3.agt_pay_int_flg                                                                                                     -- 协议付息标志
       ,''                                                                                                                     -- 票据唯一标识编号
       ,t4.asset_id                                                                                                            -- 同业资产唯一标识编号
       ,t3.load_bill_id                                                                                                        -- 第三方账户编号
       ,''                                                                                                                     -- 贷款来源代码
       ,t1.comm_fee_rat                                                                                                        -- 手续费费率
       ,0                                                                                                                      -- 手续费金额
       ,t3.lc_id                                                                                                               -- 信用证编号
       ,t3.lc_amt                                                                                                              -- 信用证金额
       ,t3.loan_trast_way_cd                                                                                                   -- 办理渠道代码
       ,nvl(t8.syn_loan_tot_amt, 0)                                                                                            -- 银团贷款总金额
       ,t3.syn_distrd_loan_amt                                                                                                 -- 银团贷款发放金额
       ,t1.mon_tenor                                                                                                           -- 期限
       ,t1.base_rat_type_cd                                                                                                    -- 基准利率类型代码
       ,t1.base_rat                                                                                                            -- 基准利率
       ,t1.int_rat_flo_val                                                                                                     -- 利率浮动值
       ,t1.int_rat_mode_cd                                                                                                     -- 利率模式代码
       ,t1.exec_mon_int_rat                                                                                                    -- 执行利率
       ,t1.rsrv_amt                                                                                                            -- 预留金额
       ,t1.lmt_open_amt                                                                                                        -- 银行融资总额
       ,case when t1.lmt_cont_flg ='01' then t10.crdt_open_bal else t11.crdt_open_bal end                                      -- 敞口余额
       ,nvl(trim(t3.prod_coll_amt), t4.underly_prod_coll_amt)                                                                  -- 标的产品募集金额
       ,t1.cont_amt                                                                                                            -- 合同金额
--       ,nvl(t1.cont_amt, 0) - nvl(t1.actl_out_acct_amt, 0)                                                                   -- 合同可用余额
       ,nvl(t10.aval_nmal_amt,t11.aval_nmal_amt)                                                                               -- 合同可用余额
       ,t1.actl_out_acct_amt                                                                                                   -- 累计发放金额
       ,nvl(t1.actl_out_acct_amt,0) - nvl(t1.curr_bal, 0)                                                                      -- 累计回收金额
       ,nvl(t10.nmal_amt, 0) - nvl(t10.aval_nmal_amt, 0 )                                                                      -- 已用授信额度
       ,nvl(t10.aval_nmal_amt, 0)                                                                                              -- 剩余授信额度
       ,t1.job_cd                                                                                                              -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                                        -- 数据处理时间
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
  left join ${iml_schema}.agt_loan_apv_lmt_attach_info_h t5
    on t1.apv_flow_num = t5.apv_flow_num
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.pty_corp t7 
    on t1.cust_id = t7.party_id
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd='eifsf1'
  left join ${iml_schema}.agt_loan_cont_lmt_attach_info_h t8
    on t1.agt_id = t8.agt_id
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'icmsf1'
  left join ${iml_schema}.pty_corp_cust t9
    on t1.cust_id = t9.cust_id
   and t9.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'icmsf1'
   and t9.id_mark <> 'D'
  left join ${iml_schema}.agt_crdt_lmt_info_h t10
    on t1.lmt_id = t10.lmt_id
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_crdt_bus_info_h t11
    on t1.lmt_id = t11.bus_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_apv_basic_info_h t12
    on t1.apv_flow_num = t12.apv_flow_num
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'icmsf1'
  left join ${iol_schema}.icms_business_contract t13
    on t1.cont_id = t13.serialno
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_cont_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_cont_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_cont_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_loan_cont_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
