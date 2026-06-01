/*
Purpose:    共性加工层-资管投资标的产品信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_am_invest_underly_prod_info
CreateDate: 20201106
Logs:       20220506 陈伟峰 新增模型
            20220809 温旺清 新增字段【行内产品二级分类代码、行内产品三级分类代码、行内产品四级分类代码、行内产品五级分类代码】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_am_invest_underly_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_invest_underly_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_invest_underly_prod_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_invest_underly_prod_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_am_invest_underly_prod_info where 0=1;


whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_am_invest_underly_prod_info_ex(
    etl_dt                         -- 数据日期
    ,lp_id                         -- 法人编号
    ,prod_id                       -- 产品编号
    ,std_prod_id                   -- 标准产品编号
    ,prod_cate_cd                  -- 产品类别代码
    ,prod_abbr                     -- 产品简称
    ,prod_fname                    -- 产品全称
    ,prft_mode_cd                  -- 收益模式代码
    ,coupon_breed_cd               -- 息票品种代码
    ,fin_prod_id                   -- 金融产品编号
    ,issue_price                   -- 发行价格
    ,issue_size                    -- 发行规模
    ,issue_curr_cd                 -- 发行币种代码
    ,overs_flg                     -- 境外标志
    ,tran_site_cd                  -- 交易场所代码
    ,tran_caln_cd                  -- 交易日历代码
    ,issue_way_cd                  -- 发行方式代码
    ,csner_id                      -- 委托人编号
    ,trustee_id                    -- 托管人编号
    ,issuer_id                     -- 发行人编号
    ,mger_id                       -- 管理人编号
    ,finer_id                      -- 融资人编号
    ,issue_dt                      -- 发行日期
    ,value_dt                      -- 起息日期
    ,exp_dt                        -- 到期日期
    ,prod_tenor                    -- 产品期限
    ,actl_exp_dt                   -- 实际到期日期
    ,subtn_flg                     -- 永续标志
    ,subtn_claus                   -- 永续条款
    ,contn_weight_flg              -- 含权标志
    ,brkevn_flg                    -- 保本标志
    ,rgst_trust_org_cd             -- 登记托管机构代码
    ,fin_inst_issue_flg            -- 金融机构发行标志
    ,guartor_id                    -- 担保人编号
    ,purch_cfm_tenor               -- 申购确认期限
    ,redem_cfm_tenor               -- 赎回确认期限
    ,sub_debt_flg                  -- 次级债标志
    ,invest_char_type_cd           -- 投资性质类型代码
    ,fac_val                       -- 面值
    ,city_bond_flg                 -- 城投债标志
    ,city_bond_lev_cd              -- 城投债级别代码
    ,asset_src_cd                  -- 资产来源代码
    ,distr_brch_id                 -- 放款分行编号
    ,clear_ped_cd                  -- 清算周期代码
    ,proj_dir_indus_categy_cd      -- 项目投向行业门类代码
    ,proj_dir_indus_gen_cd         -- 项目投向行业大类代码
    ,bank_int_prod_level2_cls_cd   --行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd   --行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd   --行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd   --行内产品五级分类代码
    ,actl_crdt_main_id             -- 实际授信主体编号
    ,ped_days                      -- 周期天数
    ,am_plan_type_cd               -- 资管计划类型代码
    ,int_rat_adj_way_cd            -- 利率调整方式代码
    ,prod_bal                      -- 产品余额
    ,prod_nv                       -- 产品净值
    ,job_cd                        -- 任务代码
    ,etl_timestamp                 -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.src_prod_id                            -- 产品编号                
   ,t1.std_prod_id                            -- 标准产品编号            
   ,t1.prod_cate_cd                           -- 产品类别代码            
   ,t1.prod_abbr                              -- 产品简称                
   ,t1.prod_fname                             -- 产品全称                
   ,t1.prft_mode_cd                           -- 收益模式代码            
   ,t1.coupon_breed_cd                        -- 息票品种代码            
   ,t1.fin_prod_id                            -- 金融产品编号            
   ,t1.issue_price                            -- 发行价格                
   ,t1.issue_size                             -- 发行规模                
   ,t1.issue_curr_cd                          -- 发行币种代码            
   ,t1.overs_flg                              -- 境外标志                
   ,t1.tran_site_cd                           -- 交易场所代码            
   ,t1.tran_caln_cd                           -- 交易日历代码            
   ,t1.issue_way_cd                           -- 发行方式代码            
   ,t1.csner_id                               -- 委托人编号              
   ,t1.trustee_id                             -- 托管人编号              
   ,t1.issuer_id                              -- 发行人编号              
   ,t1.mger_id                                -- 管理人编号              
   ,t1.finer_id                               -- 融资人编号              
   ,t1.issue_dt                               -- 发行日期                
   ,t1.value_dt                               -- 起息日期                
   ,t1.exp_dt                                 -- 到期日期                
   ,t1.prod_tenor                             -- 产品期限                
   ,t1.actl_exp_dt                            -- 实际到期日期            
   ,t1.subtn_flg                              -- 永续标志                
   ,t1.subtn_claus                            -- 永续条款                
   ,t1.contn_weight_flg                       -- 含权标志                
   ,t1.brkevn_flg                             -- 保本标志                
   ,t1.rgst_trust_org_cd                      -- 登记托管机构代码        
   ,t1.fin_inst_issue_flg                     -- 金融机构发行标志        
   ,t1.guartor_id                             -- 担保人编号              
   ,t1.purch_cfm_tenor                        -- 申购确认期限            
   ,t1.redem_cfm_tenor                        -- 赎回确认期限            
   ,t1.sub_debt_flg                           -- 次级债标志              
   ,t1.invest_char_type_cd                    -- 投资性质类型代码        
   ,t1.fac_val                                -- 面值                    
   ,t1.city_bond_flg                          -- 城投债标志              
   ,t1.city_bond_lev_cd                       -- 城投债级别代码          
   ,t1.asset_src_cd                           -- 资产来源代码            
   ,t1.distr_brch_id                          -- 放款分行编号            
   ,t1.clear_ped_cd                           -- 清算周期代码            
   ,t1.proj_dir_indus_categy_cd               -- 项目投向行业门类代码    
   ,t1.proj_dir_indus_gen_cd                  -- 项目投向行业大类代码 
   ,t5.bank_int_prod_level2_cls_cd            --行内产品二级分类代码
   ,t5.bank_int_prod_level3_cls_cd            --行内产品三级分类代码
   ,t5.bank_int_prod_level4_cls_cd            --行内产品四级分类代码
   ,t5.bank_int_prod_level5_cls_cd            --行内产品五级分类代码											                                                                                                                                             
   ,t1.actl_crdt_main_id                      -- 实际授信主体编号        
   ,t1.ped_days                               -- 周期天数                
   ,t1.am_plan_type_cd                        -- 资管计划类型代码        
   ,t1.int_rat_adj_way_cd                     -- 利率调整方式代码        
   ,nvl(t2.paid_in_capital,0)                 -- 产品余额                
   ,nvl(t2.corp_nv,0)                         -- 产品净值                
   ,t1.job_cd                                 -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${iml_schema}.prd_am_invest_underly_prod t1
 left join ${iml_schema}.fin_am_stat_analy_sob_tot t2
   on t2.sob_id =t1.src_prod_id
  and t2.job_cd ='famsi2'
  and t2.enter_acct_dt=to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.prd_am_fin_prod_cls_h t5
   on t1.fin_prod_id = t5.fin_prod_id 
  and t5.job_cd = 'famsf2'
  and t5.start_dt <=to_date('${batch_date}','yyyymmdd')
  and t5.end_dt >to_date('${batch_date}','yyyymmdd')   
where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.id_mark <> 'D'
	and t1.job_cd = 'famsf2'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_am_invest_underly_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_invest_underly_prod_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_invest_underly_prod_info_ex purge;



-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_am_invest_underly_prod_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

