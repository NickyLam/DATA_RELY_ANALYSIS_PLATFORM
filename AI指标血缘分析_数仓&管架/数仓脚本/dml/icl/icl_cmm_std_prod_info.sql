/*
Purpose:    共性加工层-标准产品信息  包括我行所有设定和配置完成的标准产品（可售产品）的基本信息，包含存款、贷款、同业、中间业务、其他资产负债等。数据主要来源于新核心系统的产品工厂。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd ${icl_schema}.icl_cmm_std_prod_info
Createdate: 
Logs:            
            20220318 翟若平 1、增加字段【基础产品编号、产品组标志、产品作用范围代码、计提合并标志】
                            2、置空字段【发布状态代码、产品概述、映射规则描述】
			      20220518 温旺清	1、修改来源表：prd_base_prod_cls_h ->prd_prod_cls_h以及相关逻辑
                            2、修改T6的来源表数据；prd_prod_attr_info_h ->prd_prod_def_h; prd_prod_attr_para ->prd_prod_attr_val_def_h
            20220521 翟若平 1、去掉T2~T5临时表中产品级别的过滤条件（prod_cls_hibchy_cd = ?）
                            2、调整字段【一级产品编号、一级产品名称、二级产品编号、二级产品名称、三级产品编号、三级产品名称、四级产品编号、四级产品名称、产品级别代码】的加工口径
            20220622 朱觉军	1、取数主表调整，由产品类型定义表调整为产品目录表							
      
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_std_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_std_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_std_prod_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_std_prod_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_std_prod_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_std_prod_info_ex(
       etl_dt                   --数据日期
      ,lp_id                    --法人编号
      ,prod_id                  --产品编号
      ,prod_name                --产品名称
      ,base_prod_id             --基础产品编号
      ,level1_prod_id           --一级产品编号
      ,level1_prod_name         --一级产品名称
      ,level2_prod_id           --二级产品编号
      ,level2_prod_name         --二级产品名称
      ,level3_prod_id           --三级产品编号
      ,level3_prod_name         --三级产品名称
      ,level4_prod_id           --四级产品编号
      ,level4_prod_name         --四级产品名称
      ,prod_lev_cd              --产品级别代码
      ,issue_status_cd          --发布状态代码
      ,prod_status_cd           --产品状态代码
      ,effect_dt                --生效日期
      ,invalid_dt               --失效日期
      ,prod_sum                 --产品概述
      ,mgmt_dept_name           --管理部门名称
      ,map_rule_descb           --映射规则描述
      ,comb_prod_flg            --产品组标志
      ,prod_range_cd            --产品作用范围代码
      ,provi_merge_flg          --计提合并标志
      ,job_cd	                  -- 任务代码
      ,etl_timestamp	          -- 数据处理时间
)
select 
      to_date('${batch_date}','yyyymmdd')	 -- 数据日期     
      ,t1.lp_id                            -- 法人编号     
      ,t1.prod_id                          -- 产品编号     
      ,case when length(t1.prod_id)=1 then t1.prod_gen_name
            when length(t1.prod_id)=3 then t1.prod_sclass_name
            when length(t1.prod_id)=5 then t1.prod_group_name
            when length(t1.prod_id)=7 then t1.base_prod_name
       else t1.sellbl_prod_name end as prod_name                                                                   -- 产品名称
      ,t1.base_prod_id                                                                                             -- 基础产品编号     
      ,t1.prod_gen_id                                                                                              -- 一级产品编号    
      ,t1.prod_gen_name                                                                                            -- 一级产品名称  
      ,case when t1.prod_hibchy = '1' then  '' else t1.prod_gen_id||t1.prod_sclass_id end                          -- 二级产品编号  
      ,t1.prod_sclass_name                                                                                         -- 二级产品名称  
      ,case when t1.prod_hibchy in ('1','2') then  '' else t1.prod_gen_id||t1.prod_sclass_id||t1.prod_group_id end -- 三级产品编号  
      ,t1.prod_group_name                                                                                          -- 三级产品名称  
      ,t1.base_prod_id                                                                                             -- 四级产品编号  
      ,t1.base_prod_name                                                                                           -- 四级产品名称  
      ,t1.prod_hibchy                                                                                              -- 产品级别代码  
      ,''                                                                                                          -- 发布状态代码  
      ,t1.prod_status_cd                                                                                           -- 产品状态代码  
      ,t1.effect_dt                                                                                                -- 生效日期    
      ,t1.invalid_dt                                                                                               -- 失效日期    
      ,''                                                                                                          -- 产品概述    
      ,t1.mgmt_org_id                                                                                              -- 管理部门名称  
      ,''                                                                                                          -- 映射规则描述  
      ,decode(t2.prod_group_flg, 'Y', '1', 'N','0','')                                                             -- 产品组标志  
      ,t2.prod_range_cd                                                                                            -- 产品作用范围代码
      ,decode(t2.provi_merge_flg, 'Y', '1','N', '0','')                                                            -- 计提合并标志  
      ,t1.job_cd                                                       -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') --数据处理时间          
  from  ${iml_schema}.prd_prod_catlg_h t1		--产品目录历史
  left join  ${iml_schema}.prd_std_prod_info_h t2	--标准产品信息历史表
    on t1.prod_id = t2.prod_id
   and t2.job_cd = 'ncbsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.job_cd = 'ncbsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_std_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_std_prod_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_std_prod_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_std_prod_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);