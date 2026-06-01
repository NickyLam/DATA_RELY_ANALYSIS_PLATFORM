/*
Purpose:  共性加工层-押品与担保合同关系
Author:   Sunline
Usage:   python $ETL_HOME/script/main.py yyyymmdd icl_cmm_col_guar_cont_rela
CreateDate: 20190808
Logs:		20200724 周沁晖 增加字段【主押品标志】
            20210903 陈伟峰 调整押品信息关系数据范围，过滤票据池和资产池数据
            20240628 陈伟峰 新增一组来源信贷
            20241030 陈伟峰 调整第一组数据处理，去除资产池和票据池过滤逻辑
            20250916 陈伟峰 调整第一组押品数据来源，改为信贷
                            下线供应链资产池主押品标志逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_col_guar_cont_rela drop partition p_${retain_day};
alter table ${icl_schema}.cmm_col_guar_cont_rela add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_col_guar_cont_rela_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_guar_cont_rela_ex 
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_col_guar_cont_rela where 0=1;

--第一组 押品系统
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_guar_cont_rela_ex(
   etl_dt	                    -- 数据日期
   ,lp_id	                    -- 法人编号
   ,col_id	                  -- 押品编号
   ,guar_cont_id	            -- 担保合同编号
   ,col_brwer_pc_flg	        -- 押品与借款人正相关标志
   ,guar_impt_flg	            -- 保证落实标志
   ,guar_rela_cd	            -- 保证相关性代码
   ,curr_cd	                  -- 币种代码
   ,guar_amt	                -- 担保金额
   ,mtg_rat	                  -- 抵押率
   ,guar_form_cd	            -- 保证担保形式代码
   ,guar_kind_cd	            -- 保证种类代码
   ,main_col_flg							-- 主押品标志
   ,job_cd                    -- 任务代码
   ,etl_timestamp             -- etl处理时间戳
)
select 
   to_date('${batch_date}', 'yyyymmdd')	             -- 数据日期
   ,t1.lp_id	                   -- 法人编号
   ,t1.asset_id	                 -- 押品编号
   ,t1.guar_cont_id	             -- 担保合同编号
   ,''	                         -- 押品与借款人正相关标志
   ,''	                         -- 保证落实标志
   ,''	                         -- 保证相关性代码
   ,t1.guar_curr_cd	             -- 币种代码
   ,t1.guar_amt	                 -- 担保金额
   ,t1.pm_rat	                 -- 抵押率
   ,''	                         -- 保证担保形式代码
   ,''	                         -- 保证种类代码
   ,''                           -- 主押品标志
   ,'icmsf2'                    -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from ${iml_schema}.ast_col_guar_cont_rela_h t1
/* left join ${iml_schema}.ast_tot_and_splt_col_rela t2
 	 on t1.asset_id = t2.sub_asset_id
 	and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.id_mark <> 'D'
  and t2.job_cd = 'mimsf1' */
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd = 'icmsf1'
/*  and not exists (select 1 from ${iol_schema}.mims_mims_dbm_guar_relation dbmr where dbmr.cmdtysccode= t1.asset_id)  --过滤资产池
  and not exists (select 1 from ${iml_schema}.ast_tot_and_splt_col_rela s where s.sub_asset_id= t1.asset_id
                            and s.job_cd ='mimsf1'
                            and s.start_dt <= to_date('${batch_date}','yyyymmdd')
                            and s.end_dt > to_date('${batch_date}','yyyymmdd'))  ----过滤票据池
*/
;
commit;


--第二组 信贷系统
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_col_guar_cont_rela_ex(
   etl_dt	                    -- 数据日期
   ,lp_id	                    -- 法人编号
   ,col_id	                  -- 押品编号
   ,guar_cont_id	            -- 担保合同编号
   ,col_brwer_pc_flg	        -- 押品与借款人正相关标志
   ,guar_impt_flg	            -- 保证落实标志
   ,guar_rela_cd	            -- 保证相关性代码
   ,curr_cd	                  -- 币种代码
   ,guar_amt	                -- 担保金额
   ,mtg_rat	                  -- 抵押率
   ,guar_form_cd	            -- 保证担保形式代码
   ,guar_kind_cd	            -- 保证种类代码
   ,main_col_flg							-- 主押品标志
   ,job_cd                    -- 任务代码
   ,etl_timestamp             -- etl处理时间戳
)
select 
   to_date('${batch_date}', 'yyyymmdd')	             -- 数据日期
   ,t1.lp_id	                   -- 法人编号
   ,t1.guar_id	                 -- 押品编号
   ,t1.guar_cont_id	             -- 担保合同编号
   ,''	                         -- 押品与借款人正相关标志
   ,''	                         -- 保证落实标志
   ,''	                         -- 保证相关性代码
   ,t1.curr_cd	                 -- 币种代码
   ,t1.guar_amt	                 -- 担保金额
   ,t1.pm_rat                    -- 抵押率
   ,''	                         -- 保证担保形式代码
   ,''	                         -- 保证种类代码
   ,''                    			 -- 主押品标志
   ,t1.job_cd                    -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
 from (select lp_id,guar_id,guar_cont_id,curr_cd,guar_amt,pm_rat,job_cd,
              row_number() over(partition by guar_id,guar_cont_id order by obj_id desc ) as rn
         from ${iml_schema}.agt_guar_cont_guar_rela_h
        where start_dt <= to_date('${batch_date}', 'yyyymmdd')
          and end_dt > to_date('${batch_date}', 'yyyymmdd')
          and job_cd = 'icmsf1'
          and obj_type_name = 'BusinessContract') t1
where t1.rn=1
and not exists (select 1 from ${icl_schema}.cmm_col_guar_cont_rela_ex t2 where t1.guar_id= t2.col_id and t1.guar_cont_id=t2.guar_cont_id) 
;
commit;



-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_col_guar_cont_rela exchange partition p_${batch_date} with table ${icl_schema}.cmm_col_guar_cont_rela_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_col_guar_cont_rela_ex purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_col_guar_cont_rela',partname => 'p_${batch_date}', degree => 8, cascade => true);  
