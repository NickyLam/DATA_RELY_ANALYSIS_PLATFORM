  /*
Purpose:    共性加工层-押品保证人评级信息，包括我行所有的押品保证人评级信息，包括内部评级和外部评级，数据来源于押品系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_col_guartor_rating_info
Createdate: 20190729
Logs:
            20220305 陈伟峰 新增模型
            20220305 陈伟峰 新增字段【币种代码、保证人经济成分代码、保证人国标行业分类代码、阶段性担保标志、保证人净资产金额】
            20231030 徐子豪 新增字段【保证人担保独立性代码】
            20241017 谢  宁 新增字段【保证人证件类型代码】【保证人证件号码】修改【保证人名称】逻辑
            20250917 陈伟峰 调整模型数据源，取信贷
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_col_guartor_rating_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_col_guartor_rating_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_col_guartor_rating_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_col_guartor_rating_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_col_guartor_rating_info where 0=1;


--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_guartor_rating_info_ex(
   etl_dt                       -- 数据日期
   ,lp_id                        -- 法人编号
   ,col_id                       -- 押品编号
   ,guartor_id                   -- 保证人编号
   ,guartor_cert_type_cd         -- 保证人证件类型代码
   ,guartor_cert_no              -- 保证人证件号码
   ,guartor_name                 -- 保证人名称
   ,guartor_type_cd              -- 保证人类型代码
   ,guartor_intnal_rating_dt     -- 保证人内部评级日期
   ,guartor_intnal_rating_rest   -- 保证人内部评级结果
   ,guartor_ext_rating_dt        -- 保证人外部评级日期
   ,guartor_ext_rating_rest      -- 保证人外部评级结果
   ,guar_aim_cd                  -- 保证目的代码
   ,curr_cd	                     -- 币种代码
   ,guartor_econ_compnt_cd	     -- 保证人经济成分代码
   ,guartor_nat_std_indus_cls_cd -- 保证人国标行业分类代码
   ,guartor_guar_indep_cd        -- 保证人担保独立性代码
   ,stage_guar_flg	             -- 阶段性担保标志
   ,guartor_net_asset_amt	       -- 保证人净资产金额
   ,job_cd                       -- 任务代码
   ,etl_timestamp                -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                              -- 数据日期
   ,t1.lp_id                                                           -- 法人编号
   ,t1.col_id                                                      -- 押品编号
   ,t1.guartor_id                                                         -- 保证人编号
   ,t1.guartor_cert_type_cd                                                        -- 保证人证件类型代码
   ,t1.guartor_cert_no                                                          -- 保证人证件号码
   ,t1.guartor_name                                                       -- 保证人名称
   ,t1.guartor_type_cd                                                       -- 保证人类型代码
   ,t1.guartor_ext_rating_dt                                                   -- 保证人内部评级日期
   ,t1.guartor_ext_rating_cd                                                 -- 保证人内部评级结果
   ,t1.guartor_intnal_rating_dt                                                    -- 保证人外部评级日期
   ,t1.guartor_intnal_rating_cd                                                  -- 保证人外部评级结果
   ,t1.guar_aim_cd                                                         -- 保证目的代码
   ,t1.net_asset_curr_cd                                                -- 币种代码
   ,''                                                                 -- 保证人经济成分代码
   ,''                                                                 -- 保证人国标行业分类代码
   ,t1.guartor_guar_indep_cd                                                    -- 保证人担保独立性代码
   ,t1.stage_guar_flg                                                         -- 阶段性担保标志
   ,t1.guartor_net_asset                                                        -- 保证人净资产金额
   ,t1.job_cd                                                         -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- etl处理时间戳
from ${iml_schema}.ast_col_guar_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
and t1.job_cd ='icmsf1'
and exists (select 1 from ${iml_schema}.ast_col_basic_info t2 where t1.col_id=t2.asset_id
                   and t2.create_dt <=to_date('${batch_date}','yyyymmdd')
                   and t2.job_cd ='icmsf1'
                   and t2.id_mark <>'D'
                   and t2.col_type_id like '98%'--保证类押品 
                )  
;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_col_guartor_rating_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_col_guartor_rating_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_col_guartor_rating_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_col_guartor_rating_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);