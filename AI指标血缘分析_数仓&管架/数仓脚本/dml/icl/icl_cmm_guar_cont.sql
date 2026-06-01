/*
Purpose:    共性加工层-担保合同
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_guar_cont
CreateDate: 20190815
Logs:       20200724 周沁晖 调整字段【占用金额】取数逻辑（风险集市）
            20210122 谢  宁 调整字段RCRS【更新人员编号】取数逻辑
            20210122 谢  宁 调整字段CRSS【客户经理编号】【主管机构编号】【登记机构编号】
            20210122 谢  宁 新增字段【担保合同名称】
            20210222 陈伟峰 调整客户经理编号来源口径，从uuss系统获取（M层加工到核心柜员表中）
            20210323 谢  宁 调整第二组登记机构人员逻辑''-->t1.applit_id
            20210511 陈伟峰 调整dir_guar_flg-直接向我行担保标志默认值逻辑，"0"->"-"
                            调整gcust_flg-代保管标志默认值逻辑，"0"->"-"
            20210608 何桐金 增加字段【担保人国民经济部门类型代码、担保人行业类型代码、担保人行政区划代码、担保人企业规模代码】
            20210727 陈伟峰 调整【担保人证件类型代码】字段顺序
            20211110 何桐金 调整零售信贷【生效日期EFFECT_DT、到期日期EXP_DT】取数逻辑
            20211216 陈伟峰 新增字段【担保类型分类代码、包含反担保措施标志】
            20220114 陈伟峰 新增网贷平台担保合同信息
            20220423 翟若平取数数据源调整，由对公信贷系统和零售信贷系统调整为综合信贷管理系统
            20220608 温旺清 1、新增字段【保证人净资产】
                            2、置空字段【与借款人关系代码-BRWER_RELA_CD、主合同编号-PRI_CONTR_ID、主合同类型代码-PRI_CONTR_TYPE_CD、账务机构编号-ACCT_INSTIT_ID】
            20221122 温旺清 新增字段【政府性融资担保公司保证标志】
            20230104 温旺清	新增字段【担保人国家和地区代码】	
            20230509 陈伟峰	新增字段【反担保标志】
            20231225 饶雅   新增字段【担保人类别代码】				
            20250805 陈伟峰   剔除联合贷分期乐担保合同

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_guar_cont drop partition p_${retain_day};
alter table ${icl_schema}.cmm_guar_cont add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_guar_cont_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_guar_cont_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_guar_cont where 0=1;

-- 第一组  对公信贷担保合同
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_guar_cont_ex(
    etl_dt                             -- 数据日期
   ,lp_id                              -- 法人编号
   ,guar_cont_id                       -- 担保合同编号
   ,guar_cont_type_cd                  -- 担保合同类型代码
   ,guar_way_cd                        -- 担保方式代码
   ,guar_type_cls_cd                   -- 担保类型分类代码
   ,guar_kind_cd                       -- 保证种类代码
   ,status_cd                          -- 状态代码
   ,sign_dt                            -- 签订日期
   ,effect_dt                          -- 生效日期
   ,exp_dt                             -- 到期日期
   ,cust_id                            -- 客户编号
   ,guartor_id                         -- 担保人编号
   ,guartor_name                       -- 担保人名称
   ,guartor_cert_type_cd               -- 担保人证件类型代码
   ,guartor_cert_no                    -- 担保人证件号码
   ,guartor_cate_cd                    -- 担保人类别代码
   ,guartor_natnal_econ_dept_type_cd   -- 担保人国民经济部门类型代码
   ,guartor_indus_type_cd              -- 担保人行业类型代码
   ,guartor_dist_cd                    -- 担保人行政区划代码
   ,guartor_corp_size_cd               -- 担保人企业规模代码
   ,guartor_cty_rg_cd                  -- 担保人国家和地区代码	
   ,guartor_net_asset                  -- 保证人净资产
   ,brwer_rela_cd                      -- 与借款人关系代码
   ,curr_cd                            -- 币种代码
   ,guar_amt                           -- 担保金额
   ,ocup_amt                           -- 占用金额
   ,guar_start_dt                      -- 担保起始日期
   ,guar_exp_dt                        -- 担保到期日期
   ,guar_tenor                         -- 担保期限
   ,pri_contr_id                       -- 主合同编号
   ,pri_contr_type_cd                  -- 主合同类型代码
   ,ocup_guar_lmt_flg                  -- 占用担保额度标志
   ,guar_range_cd                      -- 担保范围代码
   ,gcust_flg                          -- 代保管标志
   ,rev_guar_flg                       -- 反担保标志
   ,rev_guar_measure_flg               -- 包含反担保措施标志
   ,gover_fin_guar_corp_guar_flg       -- 政府性融资担保公司保证标志
   ,obg_id                             -- 权利人编号
   ,obg_name                           -- 权利人名称
   ,dir_guar_flg                       -- 直接向我行担保标志
   ,cust_mgr_id                        -- 客户经理编号
   ,director_org_id                    -- 主管机构编号
   ,acct_instit_id                     -- 账务机构编号
   ,rgst_org_id                        -- 登记机构编号
   ,rgstrat_id                         -- 登记人员编号
   ,rgst_dt                            -- 登记日期
   ,update_person_id                   -- 更新人员编号
   ,update_dt                          -- 更新日期
   ,guar_cont_name                     -- 担保合同名称
   ,job_cd                             -- 任务代码
   ,etl_timestamp                      -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')     -- 数据日期
   ,t1.lp_id                               -- 法人编号
   ,t1.guar_cont_id                        -- 担保合同编号
   ,t1.guar_cont_type_cd                   -- 担保合同类型代码
   ,nvl(trim(t1.guar_way_cd),'-')          -- 担保方式代码
   ,t1.guar_type_cls_cd                    -- 担保类型分类代码
   ,nvl(trim(t1.guar_guar_form_cd),'-')    -- 保证种类代码
   ,t1.cont_status_cd                      -- 状态代码
   ,t1.cont_sign_dt                        -- 签订日期
   ,t1.cont_effect_dt                      -- 生效日期
   ,t1.cont_exp_dt                         -- 到期日期
   ,t1.cust_id                             -- 客户编号
   ,t1.guartor_id                          -- 担保人编号
   ,t1.guartor_name                        -- 担保人名称
   ,t1.guartor_cert_type_cd                -- 担保人证件类型代码
   ,t1.guartor_cert_no                     -- 担保人证件号码
   ,t1.guartor_cate_cd                     -- 担保人类别代码
   ,t1.natnal_econ_dept_type_cd            -- 担保人国民经济部门类型代码
   ,t1.nat_std_indus_dir_cd                -- 担保人行业类型代码
   ,t1.rgst_dist_cd                        -- 担保人行政区划代码
   ,t1.corp_size_cd                        -- 担保人企业规模代码
   ,t1.rgst_cty_rg_cd                      -- 担保人国家和地区代码	
   ,t1.guartor_net_asset                   -- 保证人净资产
   ,''                                     -- 与借款人关系代码
   ,t1.guar_curr_cd                        -- 币种代码
   ,t1.guar_tot_amt                        -- 担保金额
   ,t1.aldy_guar_amt                       -- 占用金额
   ,t1.cont_effect_dt                      -- 担保起始日期
   ,t1.cont_exp_dt                         -- 担保到期日期
   --,case when (t1.guar_begin_dt = date'2999-12-31' or t1.guar_begin_dt = date'0001-01-01') then t1.cont_effect_dt else t1.guar_begin_dt end  -- 担保起始日期
   --,case when (t1.guar_exp_dt = date'2999-12-31' or t1.guar_exp_dt = date'0001-01-01') then t1.cont_exp_dt else t1.guar_exp_dt end  -- 担保到期日期
   ,t1.guar_mon_tenor                      -- 担保期限
   ,''                                     -- 主合同编号
   ,''                                     -- 主合同类型代码
   ,t1.ocup_guar_lmt_flg                   -- 占用担保额度标志
   ,t1.guar_range_cd                       -- 担保范围代码
   ,t1.gcust_flg                           -- 代保管标志
   ,t1.rev_guar_flg                        -- 包含反担保措施标志
   ,t1.rev_guar_measure_flg                -- 包含反担保措施标志
   ,t1.gover_fin_guar_corp_guar_flg        -- 政府性融资担保公司保证标志
   ,t1.obg_cust_id                         -- 权利人编号
   ,t1.obg_name                            -- 权利人名称
   ,t1.dir_hxb_guar_flg                    -- 直接向我行担保标志
   ,t1.rgst_teller_id                      -- 客户经理编号
   ,t1.rgst_org_id                         -- 主管机构编号
   ,''                                     -- 账务机构编号
   ,t1.rgst_org_id                         -- 登记机构编号
   ,t1.rgst_teller_id                      -- 登记人员编号
   ,t1.rgst_dt                             -- 登记日期
   ,t1.update_teller_id                    -- 更新人员编号
   ,t1.modif_dt                            -- 更新日期
   ,t1.text_cont_id                        -- 担保合同名称
   ,t1.job_cd                              -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from ${iml_schema}.agt_guar_cont_info_h t1
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t1.guar_cont_id not like 'LX%'     --剔除联合贷分期乐担保合同
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_guar_cont exchange partition p_${batch_date} with table ${icl_schema}.cmm_guar_cont_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_guar_cont_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_guar_cont',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);