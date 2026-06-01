/*
purpose:    共性加工层-柜员信息表，数据主要来源核心
author:     sunline
usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_teller_info
createdate: 20210205
logs: 20210528 何桐金  新增字段【对应钱箱编号】
      20220513 朱觉军 取数数据源调整，由旧核心系统改成智能网点和新核心系统			
      20221017 温旺清 新增字段【柜员类型细类代码】
      20230605 陈伟峰 配合M层调整	pty_teller_post_rela_info表算法，增量流水->全量拉链 


*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_teller_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_teller_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_teller_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_teller_info_ex purge;

-- 2.1 create temporary table cmm_teller_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_teller_info_ex         
nologging                                                 
compress ${option_switch} for query high                  
as                                                        
select * from ${icl_schema}.cmm_teller_info where 0=1;

-- 2.2 insert into data to temporary table cmm_teller_info_ex

--第一组（共二组）柜员信息表

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_teller_info_ex(
        etl_dt                          -- 数据日期               
        ,lp_id                          -- 法人编号               
        ,teller_id                      -- 柜员编号               
        ,cors_moy_box_id                -- 对应钱箱编号           
        ,teller_name                    -- 柜员名称               
        ,teller_type_cd                 -- 柜员类型代码 
        ,teller_type_subclass_cd        -- 柜员类型细类代码		
        ,teller_status_cd               -- 柜员状态代码           
        ,teller_user_lev_cd             -- 柜员用户级别代码       
        ,teller_prvlg_lev_cd            -- 柜员权限级别代码       
        ,belong_org_id                  -- 所属机构编号           
        ,jobs_cd                        -- 岗位编号               
        ,jobs_cate                      -- 岗位类别               
        ,jobs_name                      -- 岗位名称               
        ,empyt_dt                       -- 入职日期               
        ,cust_mgr_flg                   -- 客户经理标志           
        ,enty_teller_flg                -- 实体柜员标志           
        ,syn_teller_flg                 -- 综合柜员标志           
        ,super_teller_flg               -- 超级柜员标志           
        ,acct_teller_flg                -- 账务柜员标志           
        ,prvlg_mgmt_flg                 -- 权限管理标志           
        ,director_mgmt_flg              -- 主管管理标志           
        ,crdt_cust_mgr_flg              -- 信贷客户经理标志       
        ,wah_kepr_flg                   -- 库管员标志             
        ,auth_flg                       -- 授权标志               
        ,auth_range                     -- 授权范围               
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间          
)                             
select 
       to_date('${batch_date}','yyyymmdd')
       ,t1.lp_id
       ,t1.teller_id         -- 柜员编号      
       ,''                   -- 对应钱箱编号  
       ,t1.teller_name       -- 柜员名称      
       ,'TELLER_USER'        -- 柜员类型代码  
       ,'01'                   -- 柜员类型细类代码
       ,t1.teller_status_cd  -- 柜员状态代码  
       ,case
           when t3.jobs_id in ('1010','2010','3003') then 'A0'
           when t3.jobs_id in ('1001','1020','2001','2020','3010') then 'A1'
           when t3.jobs_id in ('1012','1019','2012','3001','3004','3011') then 'A2'
           when t3.jobs_id in ('1011','2011','3012') then 'A3'
           else '99' 
            end  -- 柜员用户级别代码
       ,case  
           when t3.jobs_id in ('1010','2010','3003') then 'A0'
           when t3.jobs_id in ('1001','1020','2001','2020','3010') then 'A1'
           when t3.jobs_id in ('1012','1019','2012','3001','3004','3011') then 'A2'
           when t3.jobs_id in ('1011','2011','3012') then 'A3'
           else '99' 
            end  -- 柜员权限级别代码
       ,t1.org_id         -- 所属机构编号
       ,t3.jobs_id        -- 岗位编号    
       ,t3.jobs_type_cd   -- 岗位类别    
       ,t3.jobs_name      -- 岗位名称    
       ,t1.teller_empyt_dt         -- 入职日期
       ,case when t3.jobs_id in ('2017','3005') then '1'   --分行客户经理，支行客户经理
       else '0' end  -- 客户经理标志   
       ,'1'  -- 实体柜员标志 
       ,case when t3.jobs_name like '%综合柜员%' then '1' else '0' end --综合柜员标志
       ,''    --超级柜员标志
       ,case when t3.jobs_name like '%主管%调拨%'
              or t3.jobs_name like '%主管-出入库%'
              or t3.jobs_name like '%头寸管理岗%'
              or t3.jobs_name like '%薪酬福利岗%'
              or t3.jobs_name like '%薪酬福利主办岗%'  
             then '1' 
             else '0' 
             end  --账务柜员标志
       ,case when t3.jobs_name like '%主管%' then '1' else '0' end  --权限管理标志
       ,case when t3.jobs_name like '%主管%'
              or t3.jobs_name like '%高级主管%' then '1'
            else '0' 
             end  --主管管理标志
       ,case when t3.jobs_id in ('2017','3005') then '1'   --分行客户经理，支行客户经理
            else '0' end  --信贷客户经理标志
       ,case when t3.jobs_id in ('1001','2001','3001','3004','4001')
            then '1' 
            else '0' 
             end  --库管员标志
       ,case when t3.jobs_id in ('1001','1010','1011',
                                '1012','1015','1019',
                                '1020','2001','2010',
                                '2011','2012','2015',
                                '2020','3001','3003',
                                '3004','3010','3011','3012') 
             then '1'
             else '0'  
             end  --授权标志
       ,case when t3.jobs_id in ('1001','1010','1011',
                                '1012','1015','1019',
                                '1020','2001','2010',
                                '2011','2012','2015',
                                '2020','3001','3003',
                                '3004','3010','3011','3012')
            then t2.post_id     
            else null  
             end --授权范围                  
       ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳  	   
  from ${iml_schema}.pty_teller_info_h t1				
   /*left join (select tpri.*,
                   row_number() over(partition by tpri.org_id, tpri.teller_id order by tpri.post_id desc) rn 
              from ${iml_schema}.pty_teller_post_rela_info tpri
             where tpri.job_cd = 'nibsi1'
               and tpri.etl_dt = to_date('${batch_date}','yyyymmdd')
             ) t2			-- 20220823 zhairp 增量批应急			
    on t1.teller_id = t2.teller_id
   and t1.org_id = t2.org_id
   and t2.rn = 1*/
  left join ${iml_schema}.pty_teller_post_rela_info t2	
    on t1.teller_id = t2.teller_id
   and t1.org_id = t2.org_id
   and t2.job_cd = 'nibsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_teller_jobs_info_h t3			
    on t2.post_id = t3.jobs_id	
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t3.job_cd = 'nibsf1'
  left join ${iol_schema}.nibs_ib_upm_user_info t4
    on t1.teller_id = t4.usernum
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')	
  where t1.org_id <> '-'
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')	
   and t1.job_cd = 'nibsf1'		
;   
commit;

--第二组（共二组） --新核心（虚拟柜员）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_teller_info_ex(
        etl_dt                          -- 数据日期               
        ,lp_id                          -- 法人编号               
        ,teller_id                      -- 柜员编号               
        ,cors_moy_box_id                -- 对应钱箱编号           
        ,teller_name                    -- 柜员名称               
        ,teller_type_cd                 -- 柜员类型代码                    
        ,teller_type_subclass_cd        -- 柜员类型细类代码	 
        ,teller_status_cd               -- 柜员状态代码 		
        ,teller_user_lev_cd             -- 柜员用户级别代码       
        ,teller_prvlg_lev_cd            -- 柜员权限级别代码       
        ,belong_org_id                  -- 所属机构编号           
        ,jobs_cd                        -- 岗位编号               
        ,jobs_cate                      -- 岗位类别               
        ,jobs_name                      -- 岗位名称               
        ,empyt_dt                       -- 入职日期               
        ,cust_mgr_flg                   -- 客户经理标志           
        ,enty_teller_flg                -- 实体柜员标志           
        ,syn_teller_flg                 -- 综合柜员标志           
        ,super_teller_flg               -- 超级柜员标志           
        ,acct_teller_flg                -- 账务柜员标志           
        ,prvlg_mgmt_flg                 -- 权限管理标志           
        ,director_mgmt_flg              -- 主管管理标志           
        ,crdt_cust_mgr_flg              -- 信贷客户经理标志       
        ,wah_kepr_flg                   -- 库管员标志             
        ,auth_flg                       -- 授权标志               
        ,auth_range                     -- 授权范围               
        ,job_cd                         -- 任务代码            
        ,etl_timestamp                  -- 数据处理时间          
)                             
select 
       to_date('${batch_date}','yyyymmdd')     -- 数据日期               
       ,t1.lp_id                               -- 法人编号               
       ,t1.teller_id                           -- 柜员编号               
       ,''                                     -- 对应钱箱编号           
       ,t1.teller_name                         -- 柜员名称               
       ,'DUMMY_TELLER'                         -- 柜员类型代码 
       ,t1.teller_subclass_cd                  -- 柜员类型细类代码	   
       ,t1.teller_status_cd                    -- 柜员状态代码           
       ,'99'                                   -- 柜员用户级别代码       
       ,'99'                                   -- 柜员权限级别代码       
       ,t1.org_id                              -- 所属机构编号           
       ,'8888'                                 -- 岗位编号               
       ,'0'                                    -- 岗位类别               
       ,'自动柜员机岗'                         -- 岗位名称               
       ,t1.teller_create_dt                    -- 入职日期               
       ,'0'                                    -- 客户经理标志           
       ,'0'                                    -- 实体柜员标志           
       ,''                                     -- 综合柜员标志           
       ,''                                     -- 超级柜员标志           
       ,''                                     -- 账务柜员标志           
       ,''                                     -- 权限管理标志           
       ,''                                     -- 主管管理标志           
       ,'0'                                    -- 信贷客户经理标志       
       ,''                                     -- 库管员标志             
       ,''                                     -- 授权标志               
       ,''	                                   -- 授权范围               
	    ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳  
from ${iml_schema}.pty_teller_info_h t1	
where t1.teller_type_cd = 'DUMMY_TELLER'  --虚拟柜员
and t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')
and t1.job_cd = 'ncbsf1';
commit;	   
	   
-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_teller_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_teller_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_teller_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_teller_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);