/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_ashareindustriescode
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
-- alter table ${itl_schema}.mtl_wind_ashareindustriescode drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_ashareindustriescode drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_ashareindustriescode add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_ashareindustriescode partition for (to_date('${batch_date}','yyyymmdd')) (    
     etl_dt           -- 数据日期
    ,object_id        -- 对象ID
    ,industriescode   -- 行业代码
    ,industriesname   -- 行业名称
    ,levelnum         -- 级数  
    ,used             -- 是否有效
    ,industriesalias  -- 板块别名
    ,sequence1         -- 展示序号
    ,memo             -- 备注  
    ,start_dt         -- 开始时间
    ,end_dt           -- 结束时间
    ,id_mark          -- 增删标志   
    ,etl_timestamp    -- ETL处理时间
)
select
      to_date('${batch_date}','yyyymmdd') as  etl_dt -- 数据日期    
     ,nvl(trim(object_id ),' ') as  object_id -- 对象ID    
     ,nvl(trim(industriescode) ,' ') as industriescode -- 行业代码    
     ,nvl(trim(industriesname),' ')as industriesname -- 行业名称    
     ,nvl(trim(levelnum),' ') as levelnum -- 级数      
     ,nvl(trim(used),' ') as  used -- 是否有效    
     ,nvl(trim(industriesalias) ,' ') as industriesalias -- 板块别名    
     ,nvl(trim(sequence1),' ') as sequence1 -- 展示序号    
     ,nvl(trim(memo) ,' ') as  memo -- 备注      
     ,nvl(start_dt,null) as start_dt -- 开始时间    
     ,nvl(end_dt,null) as end_dt -- 结束时间    
     ,nvl(trim(id_mark),' ') as id_mark -- 增删标志    
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_ashareindustriescode
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_ashareindustriescode to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_ashareindustriescode',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);