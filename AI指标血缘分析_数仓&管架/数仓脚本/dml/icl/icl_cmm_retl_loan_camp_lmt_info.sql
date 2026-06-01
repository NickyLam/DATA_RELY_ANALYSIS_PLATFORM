/*
purpose:    共性加工层-零售贷款营销额度信息 : 零售贷款营销额度信息：包括所有行内零售贷款业务中营销额度部分的授信额度信息，包含传统零售贷款业务、助贷业务、微贷工厂业务、网贷业务、房快贷等业务。数据来源于综合信贷管理系统ICMS。
营销额度非真实授信给客户的额度。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_camp_lmt_info
createdate: 20231227
logs:
  20231227 更新人 饶雅
  
*/


set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_camp_lmt_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_camp_lmt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_retl_loan_camp_lmt_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_camp_lmt_info_ex purge;

-- 2.1 create temporary table cmm_retl_loan_camp_lmt_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_camp_lmt_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_retl_loan_camp_lmt_info where 0=1;

-- 2.2 insert into data to temporary table cmm_retl_loan_camp_lmt_info_ex
--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_camp_lmt_info_ex(
     etl_dt -- 数据日期
    ,lp_id -- 法人编号
    ,lmt_cont_id -- 额度合同编号
    ,lmt_cont_cn_name -- 额度合同中文名称
    ,lmt_appl_flow_num -- 额度申请流水号
    ,cust_id  -- 客户编号
    ,tax_num -- 纳税人识别号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,actv_flg  -- 激活标志
    ,circl_flg  -- 循环标志
    ,low_risk_bus_flg  -- 低风险业务标志
    ,cust_type_cd  -- 客户类型代码
    ,prod_type_cd  -- 产品类型代码
    ,curr_cd  -- 币种代码
    ,main_guar_way_cd  -- 主担保方式代码
    ,sub_guar_way_cd  -- 子担保方式代码
    ,status_cd  -- 状态代码
    ,loan_happ_type_cd  -- 贷款发生类型代码
    ,borw_usage_type_cd  -- 贷款用途代码
    ,mon_tenor  -- 月期限
    ,begin_dt  -- 起始日期
    ,exp_dt  -- 到期日期
    ,cust_mgr_id  -- 客户经理编号
    ,belong_org_id  -- 所属机构编号
    ,belong_brch_id  -- 所属分行编号
    ,acct_instit_id  -- 账务机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,crdt_lmt  -- 授信额度
    ,occu_crdt_lmt  -- 已用授信额度
    ,surp_crdt_lmt  -- 剩余授信额度
    ,crdt_open_amt  -- 授信敞口金额
    ,lower_ocup_up_level_crdt_open_amt  -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt  -- 下层占用上层授信名义金额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
  )
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.cont_id                                                       -- 额度合同编号
       ,t1.text_cont_id                                                  -- 额度合同中文名称
       ,t1.apv_flow_num                                                  -- 额度申请流水号
       ,t1.cust_id                                                       -- 客户编号
       ,t5.taxpayer_idtfy_num                                            -- 纳税人识别号
       ,t1.prod_id                                                       -- 产品编号
       ,t2.prod_name                                                     -- 产品名称
       ,decode(t1.cont_status_cd, '1', '1','2', '1', '0')                -- 激活标志
       ,t1.lmt_circl_flg                                                 -- 循环标志
       ,decode(t1.low_risk_bus_flg, '1', '1', '0')                       -- 低风险业务标志
       ,nvl(trim(t3.cust_type_cd),'-')                                   -- 客户类型代码
       ,t2.super_prod_id                                                 -- 产品类型代码
       ,t1.curr_cd                                                       -- 币种代码
       ,t1.main_guar_way_cd                                              -- 主担保方式代码
       ,nvl(trim(t1.guar_way_cd_two), t1.guar_way_cd_three)              -- 子担保方式代码
       ,t1.cont_status_cd                                                -- 状态代码
       ,t1.loan_distr_type_cd                                            -- 贷款发生类型代码
       ,t1.loan_usage_cd                                                 -- 贷款用途代码
       ,t1.mon_tenor                                                     -- 期限
       ,t1.cont_effect_dt                                                -- 起始日期
       ,t1.cont_exp_dt                                                   -- 到期日期
       ,t1.rgst_teller_id                                                -- 客户经理编号
       ,t1.rgst_org_id                                                   -- 所属机构编号
       ,substr(t1.rgst_org_id, 1, 3)                                     -- 所属分行编号
       ,nvl(trim(t1.core_out_acct_org_id), t1.rgst_org_id)               -- 账务机构编号
       ,nvl(trim(t1.lon_post_mgmt_org_id), t1.rgst_org_id)               -- 管理机构编号
       ,nvl(t1.cont_amt,0)                                               -- 授信额度
       ,nvl(t7.nmal_amt,0) - nvl(t7.aval_nmal_amt,0)                     -- 已用授信额度
       ,nvl(t7.aval_nmal_amt,0)                                          -- 剩余授信额度
       ,nvl(t7.open_amt,0)                                               -- 授信敞口金额
	     ,nvl(t7.lower_ocup_up_level_crdt_open_amt,0)                      --下层占用上层授信敞口金额
       ,nvl(t7.lower_ocup_up_level_crdt_nmal_amt,0)                      --下层占用上层授信名义金额
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_cont_info_h t1
 inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd in ('2', '4')
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_cust t3
    on t1.cust_id = t3.cust_id
   and t3.id_mark <> 'D'
   and t3.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'eifsf1'
  left join ${iml_schema}.agt_loan_apv_basic_info_h t4
    on t1.apv_flow_num = t4.apv_flow_num
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_appl_indv_loan_attach_info_h t5
    on t4.appl_flow_num = t5.appl_flow_num
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_crdt_lmt_info_h t7
    on t1.cont_id = t7.lmt_id
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
where t1.lmt_cont_flg = '01'
   and t1.xxd_camp_lmt_flg='1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_camp_lmt_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_camp_lmt_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_camp_lmt_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_camp_lmt_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);