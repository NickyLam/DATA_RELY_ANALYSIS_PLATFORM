/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl T_BRANCH_CHILD_DT
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.T_BRANCH_CHILD_DT drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.T_BRANCH_CHILD_DT add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.t_branch_child_dt partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt                                                  -- 数据日期
    ,branch_code                                            -- 
    ,child_code                                             -- 
    ,branch_name                                            -- 
    ,up_org                                                 -- 
    ,lev                                                    -- 
    ,job_cd                                                 -- 任务代码
    ,etl_timestamp                                          -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                     -- 数据日期
    ,replace(replace(branch_code,chr(13),''),chr(10),'')    -- 父级机构编码
    ,replace(replace(child_code,chr(13),''),chr(10),'')     -- 机构编码
    ,replace(replace(branch_name,chr(13),''),chr(10),'')    -- 父级机构编码
    ,replace(replace(up_org,chr(13),''),chr(10),'')         -- 机构名称
    ,replace(replace(lev,chr(13),''),chr(10),'')            -- 父级机构编码
    ,replace(replace('',chr(13),''),chr(10),'')             -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
 from （select connect_by_root parent_id branch_code,
       branch_code as child_code,
       branch_name,
       up_org,
       level as lev
  from (select a.branch_code,
               a.parent_id,
               a.branch_name,
               a.parent_id as up_org
          from ${idl_schema}.a_d_cm_branch_dt a
         where a.date_id = (select max(date_id) from ${idl_schema}.a_d_cm_branch_dt)
           and a.parent_id != '*')
connect by nocycle prior branch_code = parent_id
union all
select distinct branch_code,
                branch_code as child_code,
                branch_name,
                parent_id as up_org,
                0
  from ${idl_schema}.a_d_cm_branch_dt
 where date_id = (select max(date_id) from ${idl_schema}.a_d_cm_branch_dt));
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'T_BRANCH_CHILD_DT',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);