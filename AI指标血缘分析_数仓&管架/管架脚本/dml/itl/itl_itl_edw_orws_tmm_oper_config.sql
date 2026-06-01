/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_tmm_oper_config
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
alter table ${itl_schema}.itl_edw_orws_tmm_oper_config drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_tmm_oper_config drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_tmm_oper_config add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_tmm_oper_config partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 
    ,model_id -- 
    ,model_group -- 
    ,warn_level -- 
    ,is_auto -- 
    ,auto_description -- 
    ,auto_emp_id -- 
    ,power_value -- 
    ,bizinfo_template -- 
    ,owner_organ_id -- 
    ,risk_level -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 
    ,nvl(trim(model_id), 0) as model_id -- 
    ,nvl(trim(model_group), 0) as model_group -- 
    ,nvl(trim(warn_level), 0) as warn_level -- 
    ,nvl(trim(is_auto), 0) as is_auto -- 
    ,nvl(trim(auto_description), ' ') as auto_description -- 
    ,nvl(trim(auto_emp_id), 0) as auto_emp_id -- 
    ,nvl(trim(power_value), ' ') as power_value -- 
    ,nvl(trim(bizinfo_template), ' ') as bizinfo_template -- 
    ,nvl(trim(owner_organ_id), 0) as owner_organ_id -- 
    ,nvl(trim(risk_level), 0) as risk_level -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_tmm_oper_config
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_tmm_oper_config to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_tmm_oper_config',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);