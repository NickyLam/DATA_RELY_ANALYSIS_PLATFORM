/*
Purpose:    共性加工层-联合网贷贷款与担保合同关系：包括联合网贷中网商贷部分业务的贷款业务合同和担保合同的关系信息，来源于综合信贷管理系统ICMS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_loan_guar_cont_rela
CreateDate: 20230928
Logs: 20250219 谢  宁 新增组别【微业贷】
      20250805 陈伟峰 新增分期乐数据
      20251222 陈伟峰 新增对公微业贷203050100002

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela where 0=1;


-- 第一组  微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex(
       etl_dt                                   -- 数据日期
       ,lp_id                                   -- 法人编号
       ,loan_cont_id                            -- 贷款合同编号
       ,guar_cont_id                            -- 担保合同编号
       ,col_id                                  -- 押品编号
	   ,std_prod_id                             -- 标准产品编号
       ,guar_way_cd                             -- 担保方式代码
       ,guar_curr_cd                            -- 担保币种代码
       ,guar_cont_status_cd                     -- 担保合同状态代码
       ,guartor_cust_id                         -- 担保人客户号
       ,guartor_name                            -- 担保人名称
       ,guar_effect_dt                          -- 担保生效日期
       ,guar_exp_dt                             -- 担保到期日期
       ,job_cd                                  -- 任务代码
       ,etl_timestamp                           -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')  -- 数据日期
       ,t1.lp_id                            -- 法人编号        
       ,t1.cont_id                          -- 贷款合同编号    
       ,t2.guar_cont_id                     -- 担保合同编号    
       ,null                                -- 押品编号
       ,t1.prod_id                          -- 标准产品编号	   
       ,t2.guar_way_cd                      -- 担保方式代码    
       ,t2.curr_cd                          -- 担保币种代码    
       ,case when t2.effect_flg = '1' then '2' 
	           when t2.effect_flg = '0' then '4'
	      	else '-' end                      -- 担保合同状态代码
       ,t2.guartor_cust_id                  -- 担保人客户号    
       ,t2.guartor_cust_name                -- 担保人名称      
       ,t2.sign_dt                          -- 担保生效日期    
       ,t2.exp_dt                           -- 担保到期日期    
       ,t1.job_cd                           -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
   from ${iml_schema}.agt_wyd_loan_cont_h t1
   inner join  ${iml_schema}.agt_wyd_guar_cont_h t2
     on t1.lmt_id = t2.lmt_id
	  and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd ='icmsf1'
  where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd ='icmsf1'
	and t1.PROD_ID in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;
--
-- 第二组  分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex(
       etl_dt                                   -- 数据日期
       ,lp_id                                   -- 法人编号
       ,loan_cont_id                            -- 贷款合同编号
       ,guar_cont_id                            -- 担保合同编号
       ,col_id                                  -- 押品编号
	   ,std_prod_id                             -- 标准产品编号
       ,guar_way_cd                             -- 担保方式代码
       ,guar_curr_cd                            -- 担保币种代码
       ,guar_cont_status_cd                     -- 担保合同状态代码
       ,guartor_cust_id                         -- 担保人客户号
       ,guartor_name                            -- 担保人名称
       ,guar_effect_dt                          -- 担保生效日期
       ,guar_exp_dt                             -- 担保到期日期
       ,job_cd                                  -- 任务代码
       ,etl_timestamp                           -- 数据处理时间
)
 select
       to_date('${batch_date}','yyyymmdd')  -- 数据日期
       ,t1.lp_id                            -- 法人编号        
       ,t1.obj_id                           -- 贷款合同编号
       ,t1.guar_cont_id                     -- 担保合同编号
       ,t1.guar_id                          -- 押品编号
	   ,t3.prod_id                          -- 标准产品编号
       ,t2.guar_way_cd                      -- 担保方式代码
       ,t1.curr_cd                          -- 担保币种代码
       ,decode(t2.cont_status_cd,'101','2' ,'104','3' ,'1') -- 担保合同状态代码
       ,t2.guartor_id                       -- 担保人客户号
       ,t2.guartor_name                     -- 担保人名称
       ,t2.cont_effect_dt                   -- 担保生效日期
       ,t2.cont_exp_dt                      -- 担保到期日期   
       ,t1.job_cd                           -- 任务代码
       ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
   from ${iml_schema}.agt_guar_cont_guar_rela_h t1
  left join ${iml_schema}.agt_guar_cont_info_h t2
     on t1.guar_cont_id = t2.guar_cont_id
	and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd ='icmsf1'
    and t2.guar_cont_id like 'LX%'  --分期乐
    left join ${iml_schema}.agt_lx_loan_cont_info_h t3
     on t1.obj_id = t3.cont_id
	and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t3.job_cd ='icmsf1'
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t1.job_cd ='icmsf1'
    and t1.obj_type_name ='BusinessContract' 
    and t1.obj_id like 'LXBC%'
;
commit;


delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_loan_guar_cont_rela_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt	                           -- 数据日期
   ,tab_name                           -- 表名
	 ,batch_status                       -- 跑批状态
	 ,batch_tm                           -- 跑批时间
	 ,etl_timestamp                      -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_loan_guar_cont_rela_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_loan_guar_cont_rela',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
