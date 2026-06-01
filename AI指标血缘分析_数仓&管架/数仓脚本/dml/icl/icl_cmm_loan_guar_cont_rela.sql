/*
Purpose:    共性加工层-贷款合同与担保合同关系：包括贷款业务合同和担保合同的关系信息，其中普通贷款的关系信息来源于押品系统MIMS，微贷工厂的关系信息来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_loan_guar_cont_rela
CreateDate: 20190815
Logs:       周沁晖 20210331 新增字段【主合同类型代码、担保金额、担保币种代码、来源系统代码、条线代码】
                            调整口径【担保合同类型代码、担保合同状态代码、担保起始日期、担保到期日期】
                            新增第二组【微贷】
            陈伟峰 20210607 调整微贷组数据,【担保合同类型代码】和【担保合同状态代码】取数逻辑
            李森辉 20220427 1、调整第二组微贷工厂的取数数据源，由旧对公信贷系统调整为综合信贷管理系统取数
            李森辉 20220512 调整第一组字段【担保合同类型代码、担保合同状态代码】的取数口径
            温旺清 20220826 调整第二组字段【担保合同类型代码、担保方式代码】的加工口径
            20250805 陈伟峰   剔除联合贷分期乐担保合同
            20250916 陈伟峰 调整第一组押品数据来源，改为信贷
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_loan_guar_cont_rela drop partition p_${retain_day};
alter table ${icl_schema}.cmm_loan_guar_cont_rela add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_loan_guar_cont_rela_ex purge;
create table ${icl_schema}.cmm_loan_guar_cont_rela_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_loan_guar_cont_rela where 0=1;

whenever sqlerror exit sql.sqlcode;
--第一组（共两组）押品
insert /*+ append */ into ${icl_schema}.cmm_loan_guar_cont_rela_ex(
       etl_dt                -- 数据日期
       ,lp_id                -- 法人编号
       ,loan_cont_id         -- 贷款合同编号
       ,guar_cont_id         -- 担保合同编号
       ,pri_contr_type_cd    -- 主合同类型代码
       ,guar_cont_type_cd    -- 担保合同类型代码
       ,guar_way_cd          -- 担保方式代码
       ,guar_cont_status_cd  -- 担保合同状态代码
       ,guartor_name         -- 担保人名称
       ,guar_start_dt        -- 担保起始日期
       ,guar_exp_dt          -- 担保到期日期
       ,guar_amt             -- 担保金额  
       ,guar_curr_cd         -- 担保币种代码
       ,src_sys_cd           -- 来源系统代码
       ,strip_line_cd        -- 条线代码  
       ,job_cd               -- 任务代码
       ,etl_timestamp        -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                              -- 数据日期
       ,t1.lp_id                                                        -- 法人编号
       ,t1.cont_id                                                      -- 贷款合同编号
       ,t1.guar_cont_id                                                 -- 担保合同编号
       ,t1.pri_contr_type_cd                                            -- 主合同类型代码
       ,t2.guar_cont_type_cd                                            -- 担保合同类型代码
       ,t1.guar_type_cd                                                 -- 担保方式代码
       ,nvl(trim(t2.cont_status_cd),'000')                              -- 担保合同状态代码
       ,t2.guartor_name                                                 -- 担保人名称
       ,t2.cont_effect_dt                                               -- 担保起始日期
       ,t2.cont_exp_dt                                                  -- 担保到期日期
       ,t1.guar_amt                                                     -- 担保金额  
       ,t1.guar_curr_cd                                                 -- 担保币种代码
       ,t1.src_sys_cd                                                   -- 来源系统代码
       ,t1.strip_line_cd                                                -- 条线代码  
       ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_cont_guar_cont_rela_h t1
  left join ${iml_schema}.agt_guar_cont_info_h t2
    on t1.guar_cont_id = t2.guar_cont_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and t1.guar_cont_id not like 'LX%' 
;
commit;

whenever sqlerror exit sql.sqlcode;
--第二组（共两组）微贷
insert /*+ append */ into ${icl_schema}.cmm_loan_guar_cont_rela_ex(
       etl_dt                -- 数据日期
       ,lp_id                -- 法人编号
       ,loan_cont_id         -- 贷款合同编号
       ,guar_cont_id         -- 担保合同编号
       ,pri_contr_type_cd    -- 主合同类型代码
       ,guar_cont_type_cd    -- 担保合同类型代码
       ,guar_way_cd          -- 担保方式代码
       ,guar_cont_status_cd  -- 担保合同状态代码
       ,guartor_name         -- 担保人名称
       ,guar_start_dt        -- 担保起始日期
       ,guar_exp_dt          -- 担保到期日期
       ,guar_amt             -- 担保金额
       ,guar_curr_cd         -- 担保币种代码
       ,src_sys_cd           -- 来源系统代码
       ,strip_line_cd        -- 条线代码
       ,job_cd               -- 任务代码
       ,etl_timestamp        -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                              -- 数据日期
       ,t1.lp_id                                                        -- 法人编号
       ,t5.cont_id                                                      -- 贷款合同编号
       ,t1.obj_id                                                       -- 担保合同编号
       ,decode(t5.lmt_cont_flg, '01', '2', '02', '1', '0')              -- 主合同类型代码
       ,t2.elec_cont_type                                               -- 担保合同类型代码
       ,t2.guar_way_cd                                                  -- 担保方式代码
       ,nvl(trim(t2.cont_status_cd),'000')                              -- 担保合同状态代码
       ,t2.guartor_name                                                 -- 担保人名称
       ,t2.cont_effect_dt                                               -- 担保起始日期
       ,t2.cont_exp_dt                                                  -- 担保到期日期
       ,t2.guar_tot_amt                                                 -- 担保金额
       ,t2.guar_curr_cd                                                 -- 担保币种代码
       ,'1'                                                             -- 来源系统代码
       ,'3'                                                             -- 条线代码
       ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_appl_rela_tab_info_h t1
  left join ${iml_schema}.agt_guar_cont_info_h t2
    on t1.obj_id = t2.guar_cont_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_appl_basic_info_h t3
    on t1.appl_id = t3.appl_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_apv_basic_info_h t4
    on t4.appl_flow_num = t3.appl_flow_num
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_info_h t5
    on t5.apv_flow_num = t4.apv_flow_num
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'icmsf1'
 where t1.obj_type_name = 'GuarantyContract'
   and t5.cont_id like 'UPL%'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_loan_guar_cont_rela exchange partition p_${batch_date} with table ${icl_schema}.cmm_loan_guar_cont_rela_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_loan_guar_cont_rela_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_loan_guar_cont_rela',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);