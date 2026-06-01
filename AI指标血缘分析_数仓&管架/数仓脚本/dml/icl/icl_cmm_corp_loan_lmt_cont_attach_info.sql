/*
Purpose:    共性加工层-对公贷款额度合同补充信息：包括所有对公普通贷款、对公投融资业务、同业业务等信贷类业务的额度合同信息，主要来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_lmt_cont_attach_info
CreateDate: 20220425
Logs:       20220726 温旺清 新增字段【下层占用上层授信敞口金额、下层占用上层授信名义金额】
            20221222 翟若平 调整字段【额度名义金额、额度敞口金额、已用名义金额、已用敞口金额、可用名义金额、可用敞口金额】的加工口径
            20230309 温旺清 调整【风险暴露分类】加工口径
            20230420 陈伟峰 新增字段【通道方编号、通道方名称】
            20230612 陈伟峰 新增字段【额度项下可售产品编号】
            20230705 徐子豪 调整字段【额度项下可售产品编号】-->取【基础产品编号】
            20240220 饶雅   新增字段【额度编号】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info drop partition p_${retain_date};
alter table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info_ex purge;

-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info where 0 = 1;

insert /*+ append */ into ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info_ex(
       etl_dt                              -- 数据日期
       ,lp_id                              -- 法人编号
       ,cont_id                            -- 合同编号
       ,lmt_id                             -- 额度编号
       ,col_turn_margin_acct_num           -- 押品转保证金账号
       ,tenor_type_cd                      -- 期限类型代码
       ,lmt_kind_cd                        -- 额度种类代码
       ,group_lmt_ctrl_mode_cd             -- 集团额度管控模式代码
       ,major_loan_cls_cd                  -- 专业贷款分类代码
       ,prtcpt_way_cd                      -- 参与方式代码
       ,crdt_rg_cd                         -- 授信区域代码
       ,invest_way_cd                      -- 投资方式代码
       ,lmt_under_sellbl_prod_id           -- 额度项下可售产品编号
       ,risk_expose_cls                    -- 风险暴露分类
       ,public_crdt_flg                    -- 公开授信标志
       ,fin_sys_cont_flg                   -- 融资合同标志
       ,froz_flg                           -- 冻结标志
       ,estate_fin_flg                     -- 房地产融资标志
       ,invo_gover_class_fin_flg1          -- 政府类融资标志
       ,consm_serv_class_fin_flg           -- 消费服务类融资标志
       ,br_build_ifin_flg                  -- 一带一路建设投融资标志
       ,green_crdt_fin_flg                 -- 绿色信贷融资标志
       ,class_crdt_flg                     -- 类信贷标志
       ,distr_org_id                       -- 放款机构编号
       ,passer_id                          -- 通道方编号
       ,passer_name                        -- 通道方名称
       ,lmt_invalid_dt                     -- 额度失效日期
       ,lmt_under_bus_latest_exp_dt        -- 额度项下业务最迟到期日期
       ,lmt_next_bus_higt_pm_rat           -- 额度下业务最高抵质押率
       ,lmt_next_bus_init_margin_ratio     -- 额度下业务初始保证金比例
       ,lmt_next_bus_int_rat_lowt_flo_val  -- 额度下业务利率最低浮动值
       ,lmt_next_bus_sig_max_amt           -- 额度下业务单笔最大金额
       ,lmt_next_bus_lont_tenor            -- 额度下业务最长期限
       ,lmt_next_bus_ext_tenor             -- 额度下业务延展期限
       ,bus_curr_range                     -- 业务币种范围
       ,lmt_use_cond_descb                 -- 额度使用条件描述
       ,syn_loan_tot_amt                   -- 银团贷款总金额
       ,onl_lmt                            -- 线上额度
       ,stat_use_open_bal                  -- 统计用敞口余额
       ,lmt_nmal_amt                       -- 额度名义金额
       ,lmt_open_amt                       -- 额度敞口金额
       ,used_nmal_amt                      -- 已用名义金额
       ,used_open_amt                      -- 已用敞口金额
       ,aval_nmal_amt                      -- 可用名义金额
       ,aval_open_amt                      -- 可用敞口金额
	     ,lower_ocup_up_level_crdt_open_amt  -- 下层占用上层授信敞口金额
	     ,lower_ocup_up_level_crdt_nmal_amt  -- 下层占用上层授信名义金额
       ,job_cd                             -- 任务代码
       ,etl_timestamp                      -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.cont_id                                                       -- 合同编号
       ,t1.lmt_id                                                        -- 额度编号
       ,t3.col_turn_margin_acct_id                                       -- 押品转保证金账号
       ,t3.tenor_type_cd                                                 -- 期限类型代码
       ,t3.lmt_kind_cd                                                   -- 额度种类代码
       ,t3.group_lmt_crtl_mode_cd                                        -- 集团额度管控模式代码
       ,t3.major_loan_cls_cd                                             -- 专业贷款分类代码
       ,t3.prtcptr_way_cd                                                -- 参与方式代码
       ,t3.crdt_rg_cd                                                    -- 授信区域代码
       ,t3.invest_way_cd                                                 -- 投资方式代码
       ,t1.base_prod_id                                                  -- 额度项下可售产品编号
       ,t3.risk_expose_cls                                               -- 风险暴露分类
       ,t3.public_crdt_flg                                               -- 公开授信标志
       ,t3.fin_cont_flg                                                  -- 融资合同标志
       ,t3.froz_flg                                                      -- 冻结标志
       ,t3.invo_estate_fin_flg                                           -- 房地产融资标志
       ,t3.invo_gover_class_fin_flg                                      -- 政府类融资标志
       ,t3.consm_serv_class_fin_flg                                      -- 消费服务类融资标志
       ,t3.br_build_ifin_flg                                             -- 一带一路建设投融资标志
       ,t3.green_crdt_fin_flg                                            -- 绿色信贷融资标志
       ,t3.class_crdt_flg                                                -- 类信贷标志
       ,t3.distr_org_id                                                  -- 放款机构编号
       ,t3.passer_id                                                     -- 通道方编号
       ,t3.passer_name                                                   -- 通道方名称
       ,t3.lmt_invalid_dt                                                -- 额度失效日期
       ,t3.lmt_under_bus_latest_exp_dt                                   -- 额度项下业务最迟到期日期
       ,t3.lmt_next_bus_higt_pm_rat                                      -- 额度下业务最高抵质押率
       ,t3.lmt_next_bus_init_margin_ratio                                -- 额度下业务初始保证金比例
       ,t3.lmt_next_bus_int_rat_lowt_flo_val                             -- 额度下业务利率最低浮动值
       ,t3.lmt_next_bus_sig_max_amt                                      -- 额度下业务单笔最大金额
       ,t3.lmt_next_bus_lont_tenor                                       -- 额度下业务最长期限
       ,t3.lmt_next_bus_delay_renew_tenor                                -- 额度下业务延展期限
       ,t3.under_bus_curr_cd_range                                       -- 业务币种范围
       ,t3.lmt_use_cond_descb                                            -- 额度使用条件描述
       ,t3.syn_loan_tot_amt                                              -- 银团贷款总金额
       ,t3.onl_lmt                                                       -- 线上额度
       ,''                                                               -- 统计用敞口余额
       ,t4.nmal_amt                                                      -- 额度名义金额
       ,t4.open_amt                                                      -- 额度敞口金额
       ,t4.nmal_amt - t4.aval_nmal_amt                                   -- 已用名义金额
       ,t4.open_amt - t4.aval_open_amt                                   -- 已用敞口金额
       ,t4.aval_nmal_amt                                                 -- 可用名义金额
       ,t4.aval_open_amt                                                 -- 可用敞口金额
       ,t4.lower_ocup_up_level_crdt_open_amt                             -- 下层占用上层授信敞口金额
       ,t4.lower_ocup_up_level_crdt_nmal_amt                             -- 下层占用上层授信名义金额
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_cont_info_h t1
  inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 left join ${iml_schema}.agt_loan_cont_lmt_attach_info_h t3
    on t1.agt_id = t3.agt_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
 left join ${iml_schema}.agt_crdt_lmt_info_h t4			
    on t1.cont_id = t4.lmt_id	
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'icmsf1'
 where t1.lmt_cont_flg = '01'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_loan_lmt_cont_attach_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
