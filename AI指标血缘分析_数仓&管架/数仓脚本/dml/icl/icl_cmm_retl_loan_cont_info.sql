/*
Purpose:    共性加工层-零售贷款合同信息：包括所有行内零售贷款的贷款业务合同信息，包含传统零售贷款业务、助贷业务、微贷工厂业务、网贷平台贷款产品的业务的贷款业务合同信息。数据来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_cont_info
CreateDate: 20190808
Logs:       20200110 翟若平 调整字段[还款频率代码、气球贷标志]的取数逻辑
            20200327 翟若平 调整网贷模块中字段[授信申请流水号]的取数逻辑
            20200627 周沁晖 增加字段【住房套数代码】
            20210428 陈伟峰 调整网贷一组的投向行业默认值，'99999'->'F5299'
            20210603 陈伟峰 调整微贷工厂一组，客户经理编号取值逻辑，柜员号->行员号
            20210706 陈伟峰 调整助贷一组【贷款投向行业】加工逻辑
            20211215 陈伟峰 新增字段【原借据编号】、调整助贷部分的【贷款贷款贷款投向行业代码】加工逻辑，去除合同起始日期大于20191206，助贷产品粤海饲料个人经营贷、恒兴股份个人经营贷，默认投向为：A0412 内陆养殖
            20220328 谢宁 新增字段【合同名称、委托贷款标志、委托人客户号、委托人客户名称、增信模式标志】
            20220427 李森辉 1、取数数据源调整，由零售信贷系统调整为综合信贷管理系统
                            2、去掉第二组助贷、第三组微贷、第四组网贷，均以整合到零售信贷合同信息
            20220607 温旺清 1、调整字段【原借据编号、业务种类代码、住房套数代码、授信额度使用标志、按揭标志、气球贷标志、允许阶段性还款标志、申请日期、审批日期、使用合作商额度标志、合作商协议编号、合作商台账编号、合作商项目类型代码、合作商类型代码】的加工口径
                            2、置空字段【发放方式代码-DISTR_WAY_CD、期限类型代码-TENOR_TYPE_CD、联保贷款标志-GRO_LEND_FLG、绿色通道标志-GREEN_PASS_FLG、信用贷款标志-CRDT_LOAN_FLG、信用贷款批复流水号-CRDT_LOAN_REPLY_FLOW_NUM、平均抵质押率-AVG_PM_RAT、合同金额-CONT_AMT】
                            3、增加T1表过滤条件【SUBSTR(T1.PRODUCTID, 1, 3) IN ('201', '202') 】
                            4、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
		    20220714 温旺清	1、调整字段名称【授信申请编号-SUPP_CARD_FLG -》 额度合同编号-LMT_CONT_ID、授信申请流水号-CRDT_APPL_FLOW_NUM -》 审批流水号-APV_FLOW_NUM】							
            20220824 翟若平 置空字段【原借据编号】，新系统中借新还旧和债务重组支持多笔借据组合后新生成一笔合同，存在一对多关系，模型不支持，置空
            20220826 温旺清 1、调整字段【终止日期】的加工口径
                            2、新增字段【到期日期】
            20221117 温旺清 调整临时表T10的取数逻辑。
            20221122 温旺清 新增字段【高技术产业类型代码,数字经济核心产业类型代码,知识产权密集型产业类型代码,战略新兴产业类型代码,文化及相关产业类型代码,涉农贷款标志,绿色信贷标志,绿色贷款用途代码,绿色贷款用途二级分类代码,绿色贷款用途三级分类代码,车辆类型代码】
            20230614 陈伟峰 调整字段【车辆类型代码】加工逻辑
	        20250520 陈  凭 新增字段【申请流水号】
	        20251126 陈伟峰 新增字段【养老产业标志PROVI_FOR_AGED_PROPERTY_FLG】
	        20251210 陈伟峰 新增字段【投向数字经济核心产业类型代码DIGIT_ECON_CORE_TYPE_CD】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_cont_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_cont_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create temp table
--drop table ${icl_schema}.tmp_cmm_retl_loan_cont_info_01 purge;

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_cont_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_cont_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_cont_info where 0=1;

-- 2.2 insert into data to temporary table cmm_retl_loan_cont_info_ex
-- 第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_cont_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,cont_id                   -- 合同编号
       ,cont_name                 -- 合同名称
       ,cust_id                   -- 客户编号
       ,lmt_cont_id               -- 额度合同编号
       ,enter_acct_id             -- 入账账户编号
       ,repay_acct_id             -- 还款账户编号
       ,prod_id                   -- 产品编号
       ,prod_name                 -- 产品名称
       ,apv_flow_num              -- 审批流水号
	   ,aplv_flow_num             -- 申请流水号
       ,init_dubil_id             -- 原借据编号
       ,cont_type_cd              -- 合同类型代码
       ,cont_status_cd            -- 合同状态代码
       ,bus_kind_cd               -- 业务种类代码
       ,loan_happ_type_cd         -- 贷款发生类型代码
       ,major_guar_way_cd         -- 主要担保方式代码
       ,sub_guar_way_cd           -- 子担保方式代码
       ,borw_usage_type_cd        -- 借款用途类型代码
       ,dir_indus_cd              -- 贷款贷款贷款投向行业代码
       ,distr_way_cd              -- 发放方式代码
       ,mode_pay_cd               -- 支付方式代码
       ,tenor_type_cd             -- 期限类型代码
       ,int_rat_adj_way_cd        -- 利率调整方式代码
       ,int_rat_float_dir_cd      -- 利率浮动方向代码
       ,repay_freq_cd             -- 还款频率代码
       ,repay_day_cfm_cd          -- 还款日确定代码
       ,curr_cd                   -- 币种代码
       ,housing_cnt_cd            -- 住房套数代码
       ,high_tech_property_type_cd        -- 高技术产业类型代码
       ,digit_econ_core_property_type_cd  -- 数字经济核心产业类型代码
       ,intel_prop_inte_property_type_cd  -- 知识产权密集型产业类型代码
       ,strtg_new_indus_type_cd           -- 战略新兴产业类型代码
       ,cul_and_rela_property_type_cd     -- 文化及相关产业类型代码
       ,digit_econ_core_type_cd           -- 投向数字经济核心产业类型代码
       ,agclt_flg                         -- 涉农贷款标志
       ,green_crdt_flg                    -- 绿色信贷标志
       ,green_loan_usage_cd               -- 绿色贷款用途代码
       ,green_loan_usage_level2_cls_cd    -- 绿色贷款用途二级分类代码
       ,green_loan_usage_level3_cls_cd    -- 绿色贷款用途三级分类代码
       ,vehic_type_cd                     -- 车辆类型代码
       ,crdt_lmt_use_flg          -- 授信额度使用标志
       ,mortg_flg                 -- 按揭标志
       ,gro_lend_flg              -- 联保贷款标志
       ,blon_loan_flg             -- 气球贷标志
       ,green_pass_flg            -- 绿色通道标志
       ,low_risk_bus_flg          -- 低风险业务标志
       ,bar_flg                   -- 随借随还标志
       ,allow_stage_repay_flg     -- 允许阶段性还款标志
       ,provi_for_aged_property_flg -- 养老产业标志	
       ,hxb_open_supv_acct_flg    -- 在我行开立监管账户标志
       ,incre_crdt_mode_cd        -- 增信模式标志
       ,entr_loan_flg             -- 委托贷款标志
       ,csner_cust_no             -- 委托人客户号
       ,csner_cust_name           -- 委托人客户名称
       ,appl_dt                   -- 申请日期
       ,apv_dt                    -- 审批日期
       ,sign_dt                   -- 签约日期
       ,cont_create_dt            -- 合同生成日期
       ,start_dt                  -- 起始日期
       ,termnt_dt                 -- 终止日期
       ,exp_dt                    --到期日期
       ,cust_mgr_id               -- 客户经理编号
       ,rgst_org_id               -- 登记机构编号
       ,mgmt_org_id               -- 管理机构编号
       ,acct_instit_id            -- 账务机构编号
       ,crdt_loan_flg             -- 信用贷款标志
       ,crdt_loan_reply_flow_num  -- 信用贷款批复流水号
       ,coprator_id               -- 合作商编号
       ,coprator_name             -- 合作商名称
       ,use_coprator_lmt_flg      -- 使用合作商额度标志
       ,coprator_agt_id           -- 合作商协议编号
       ,coprator_stand_b_id       -- 合作商台账编号
       ,coprator_proj_type_cd     -- 合作商项目类型代码
       ,coprator_type_cd          -- 合作商类型代码
       ,base_rat                  -- 基准利率
       ,exec_int_rat              -- 执行利率
       ,repay_day                 -- 还款日
       ,tenor                     -- 期限
       ,pm_guar_tot               -- 抵质押担保总额
       ,avg_pm_rat                -- 平均抵质押率
       ,cont_amt                  -- 合同金额
       ,cont_aval_bal             -- 合同可用余额
       ,acm_distr_amt             -- 累计发放金额
       ,acm_callbk_amt            -- 累计回收金额
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                  -- 数据日期
       ,t1.lp_id                                                            -- 法人编号
       ,t1.cont_id                                                          -- 合同编号
       ,t1.text_cont_id                                                     -- 合同名称
       ,t1.cust_id                                                          -- 客户编号
       ,t1.rela_cont_id                                                     -- 额度合同编号
       ,t1.enter_id                                                         -- 入账账户编号
       ,t1.stl_acct_id                                                      -- 还款账户编号
       ,t1.prod_id                                                          -- 产品编号
       ,t2.prod_name                                                        -- 产品名称
       ,t1.apv_flow_num                                                     -- 审批流水号
	   ,t6.appl_flow_num                                                    -- 申请流水号
       ,''                                                                  -- 原借据编号
       ,decode(t1.lmt_circl_flg, '1', '04', '0', '05', '00')                -- 合同类型代码
       ,t1.cont_status_cd                                                   -- 合同状态代码
       ,t9.prod_cls_id                                                      -- 业务种类代码
       ,t1.loan_distr_type_cd                                               -- 贷款发生类型代码
       ,t1.main_guar_way_cd                                                 -- 主要担保方式代码
       ,t1.guar_way_cd_two                                                  -- 子担保方式代码
       ,t1.loan_usage_cd                                                    -- 借款用途类型代码
       ,t1.nat_std_indus_dir_cd                                             -- 贷款贷款贷款投向行业代码
       ,''                                                                  -- 发放方式代码
       ,t1.distr_mode_pay_cd                                                -- 支付方式代码
       ,''                                                                  -- 期限类型代码
       ,t1.int_rat_adj_way_cd                                               -- 利率调整方式代码
       ,t1.int_rat_float_type_cd                                            -- 利率浮动方向代码
       ,t1.repay_ped_cd                                                     -- 还款频率代码
       ,nvl(trim(t3.deflt_repay_day),'0')                                   -- 还款日确定代码
       ,t1.curr_cd                                                          -- 币种代码
       ,t3.house_cnt                                                        -- 住房套数代码
       ,t3.high_tech_property_type_cd                                       -- 高技术产业类型代码
       ,t3.digit_econ_core_property_type_cd                                 -- 数字经济核心产业类型代码
       ,t3.dir_intel_prop_inte_property_type_cd                             -- 知识产权密集型产业类型代码
       ,t3.strtg_new_indus_type_cd                                          -- 战略新兴产业类型代码
       ,t3.dir_cul_and_rela_property_type_cd                                -- 文化及相关产业类型代码
       ,t1.digit_econ_core_type_cd                                          -- 投向数字经济核心产业类型代码
       ,t3.agclt_flg                                                        -- 涉农贷款标志
       ,''                                                                  -- 绿色信贷标志
       ,t3.green_crdt_subclass_cd                                           -- 绿色贷款用途代码
       ,''                                                                  -- 绿色贷款用途二级分类代码
       ,''                                                                  -- 绿色贷款用途三级分类代码
       ,t3.vehic_type_cd                                                    -- 车辆类型代码
       ,case when trim(t1.rela_cont_id) is not null then '1' else '0' end   -- 授信额度使用标志
       ,case when t1.prod_id like '20103%' then '1' else '0' end            -- 按揭标志
       ,''                                                                  -- 联保贷款标志
       ,decode(t1.repay_way_cd, '6', '1', '0')                              -- 气球贷标志
       ,''                                                                  -- 绿色通道标志
       ,decode(t1.risk_type_cd, '02', '1', '0')                             -- 低风险业务标志
       ,t3.bar_flg                                                          -- 随借随还标志
       ,'1'                                                                 -- 允许阶段性还款标志
       ,t1.provi_for_aged_property_flg                                      -- 养老产业标志	
       ,t3.hxb_open_supv_acct_flg                                           -- 在我行开立监管账户标志
       ,nvl(trim(t3.incre_crdt_mode_cd),'-')                                -- 增信模式标志 
       ,case when trim(t4.csner_cust_id) is not null then '1' else '0' end  -- 委托贷款标志
       ,t4.csner_cust_id                                                    -- 委托人客户号
       ,t4.csner_name                                                       -- 委托人客户名称
       ,t7.happ_dt                                                          -- 申请日期
       ,t6.happ_dt                                                          -- 审批日期
       ,t1.effect_dt                                                        -- 签约日期
       ,t1.happ_dt                                                          -- 合同生成日期
       ,t1.cont_effect_dt                                                   -- 起始日期
       ,nvl(decode(t1.termnt_dt, to_date('00010101', 'yyyymmdd'), null, t1.termnt_dt), t1.cont_exp_dt)   -- 终止日期
       ,t1.cont_exp_dt                                                      --到期日
       ,t1.rgst_teller_id                                                   -- 客户经理编号
       ,t1.rgst_org_id                                                      -- 登记机构编号 
--       ,t1.lon_post_mgmt_org_id                                             -- 管理机构编号
       ,t1.oper_org_id                                                      -- 管理机构编号
       ,t1.core_out_acct_org_id                                             -- 账务机构编号
       ,''                                                                  -- 信用贷款标志
       ,''                                                                  -- 信用贷款批复流水号
       ,t5.major_guartor_id                                                 -- 合作商编号
       ,t5.major_guartor_name                                               -- 合作商名称
       ,case when trim(t11.co_proj_id) is not null then '1' else '0' end    -- 使用合作商额度标志
       ,t11.co_proj_id                                                      -- 合作商协议编号，合作商协议编号和合作商台账编号合并了
       ,t11.co_proj_id                                                      -- 合作商台账编号，合作商协议编号和合作商台账编号合并了
       ,t11.co_proj_type_cd                                                 -- 合作商项目类型代码
       ,t11.partner_type_cd                                                 -- 合作商类型代码
       ,t1.base_rat                                                         -- 基准利率
--       ,t1.exec_mon_int_rat                                                 -- 执行利率
       ,t1.exec_int_rat                                                     -- 执行利率
       ,t1.deflt_repay_day                                                  -- 还款日
       ,t1.mon_tenor                                                        -- 期限
       ,''                                                                  -- 抵质押担保总额
       ,''                                                                  -- 平均抵质押率
       ,t1.cont_amt                                                         -- 合同金额
       --,t1.curr_bal                                                         -- 合同可用余额
       ,nvl(t12.aval_nmal_amt,0)                                            -- 合同可用余额
       ,t1.actl_out_acct_amt                                                -- 累计发放金额
       ,nvl(t1.actl_out_acct_amt,0) - nvl(t1.curr_bal, 0)                   -- 累计回收金额
       ,t1.job_cd                                                           -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间
  from ${iml_schema}.agt_loan_cont_info_h t1
 inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd in ('2', '4')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h t3
    on t1.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_mini_loan_attach_info_h t5
    on t1.agt_id = t5.agt_id
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_apv_basic_info_h t6
    on t1.apv_flow_num = t6.apv_flow_num
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_appl_basic_info_h t7
    on t6.appl_flow_num = t7.appl_flow_num
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_csner_out_acct_info_h t4
    on t7.appl_flow_num = t4.flow_num
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'icmsf1'
  /*left join ${iml_schema}.agt_loan_appl_rela_tab_info_h t8
    on t7.appl_flow_num = t8.appl_flow_num
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.obj_type_name = 'BusinessDuebill'
   and t8.job_cd = 'icmsf1'*/
  left join ${iml_schema}.prd_prod_cls_h t9
    on t2.super_prod_id = t9.prod_cls_id
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'ncbsf1'
  left join (select re.*,row_number() over(partition by re.appl_flow_num order by re.appl_flow_num ) rn
                      from ${iml_schema}.agt_loan_appl_rela_tab_info_h re
                     where re.obj_type_name in ('RelativeProject', 'RelativePartner')
                       and re.start_dt <= to_date('${batch_date}','yyyymmdd')
                       and re.end_dt > to_date('${batch_date}','yyyymmdd')
                       and re.job_cd = 'icmsf1') t10
    on t7.appl_flow_num = t10.appl_flow_num
   and t10.rn = 1
  left join ${iml_schema}.agt_crdt_partner_proj_basic_info_h t11
    on t10.obj_id = t11.co_proj_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_crdt_bus_info_h t12
    on t1.cont_id = t12.bus_id
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   and t12.job_cd = 'icmsf1'
 where t1.lmt_cont_flg = '02'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_cont_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_cont_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_cont_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_cont_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
