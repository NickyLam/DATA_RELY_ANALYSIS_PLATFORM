/*
Purpose:    共性加工层-科目信息：包括我行所有记账科目的科目名称、上级科目信息、科目级别、科目性质等基础信息，数据主要来源于核算中台系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_subj_info
CreateDate: 20220323
Logs:

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_subj_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_subj_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_subj_info_ex purge;

create table ${icl_schema}.cmm_subj_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_subj_info where 0=1;

--第一组（共一组）核心科目信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_subj_info_ex(
       etl_dt                     -- 数据日期
       ,lp_id                     -- 法人编号
       ,subj_id                   -- 科目编号
       ,subj_name                 -- 科目名称
       ,super_subj_id             -- 上级科目编号
       ,super_subj_name           -- 上级科目名称
       ,subj_lev_cd               -- 科目级别代码
       ,subj_char_cd              -- 科目性质代码
       ,subj_bal_dir_cd           -- 科目余额方向代码
       ,subj_src_cls_cd           -- 科目来源分类代码
       ,trdpty_ctrl_acct_type_cd  -- 第三方控制账户类型代码
       ,dtl_subj_flg              -- 明细科目标志
       ,in_out_tab_flg            -- 表内外标志
       ,allow_od_flg              -- 允许透支标志
       ,allow_budget_flg          -- 允许预算标志
       ,allow_post_flg            -- 允许过账标志
       ,adj_flg                   -- 调节标志
       ,subj_status_cd            -- 科目状态代码
       ,effect_dt                 -- 生效日期
       ,invalid_dt                -- 失效日期
       ,job_cd                    -- 任务代码
       ,etl_timestamp             -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.subj_id                                                       -- 科目编号
       ,t1.subj_name                                                     -- 科目名称
       ,t1.super_subj_id                                                 -- 上级科目编号
       ,t2.subj_name                                                     -- 上级科目名称
       ,t1.subj_level_cd                                                 -- 科目级别代码
       ,t1.subj_type_cd                                                  -- 科目性质代码
       ,t1.subj_bal_dir_cd                                               -- 科目余额方向代码
       ,t1.subj_belong_cd                                                -- 科目来源分类代码
       ,''                                                               -- 第三方控制账户类型代码
       ,t1.end_level_subj_flg                                            -- 明细科目标志
       ,t1.in_bs_flg                                                     -- 表内外标志
       ,t1.allow_od_flg                                                  -- 允许透支标志
       ,''                                                               -- 允许预算标志
       ,''                                                               -- 允许过账标志
       ,''                                                               -- 调节标志
       ,t1.subj_status_cd                                                -- 科目状态代码
       ,t1.start_use_dt                                                  -- 生效日期
       ,t1.stop_use_dt                                                   -- 失效日期
       ,t1.job_cd                                                        -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.fin_subj_info_h t1
  left join ${iml_schema}.fin_subj_info_h t2
    on t1.super_subj_id=t2.subj_id
   and t2.sob_id = '1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'tglsf1'
 where t1.sob_id = '1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'tglsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_subj_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_subj_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_subj_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_subj_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
