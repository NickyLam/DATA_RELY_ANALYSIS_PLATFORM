/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_ref_curr_cd
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
alter table ${idl_schema}.icrm_ref_curr_cd drop partition p_${last_date};
alter table ${idl_schema}.icrm_ref_curr_cd drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_ref_curr_cd add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_ref_curr_cd partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,cd_val  -- 代码值
    ,cd_descb  -- 代码描述
    ,data_std_flg  -- 数据标准标志
    ,quote_data_std  -- 引用数据标准
    ,remark  -- 备注
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.cd_val,chr(13),''),chr(10),'')  -- 代码值
    ,replace(replace(t1.cd_descb,chr(13),''),chr(10),'')  -- 代码描述
    ,replace(replace(t1.data_std_flg,chr(13),''),chr(10),'')  -- 数据标准标志
    ,replace(replace(t1.quote_data_std,chr(13),''),chr(10),'')  -- 引用数据标准
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.ref_curr_cd t1    --币种代码表
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_ref_curr_cd',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);