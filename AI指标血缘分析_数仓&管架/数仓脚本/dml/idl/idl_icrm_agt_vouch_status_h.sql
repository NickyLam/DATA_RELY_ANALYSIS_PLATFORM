/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_agt_vouch_status_h
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
alter table ${idl_schema}.icrm_agt_vouch_status_h drop partition p_${last_date};
alter table ${idl_schema}.icrm_agt_vouch_status_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_agt_vouch_status_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_agt_vouch_status_h partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,vouch_id  -- 凭证编号
    ,lp_id  -- 法人编号
    ,vouch_status_type_cd  -- 凭证状态类型代码
    ,vouch_status_cd  -- 凭证状态代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.vouch_id,chr(13),''),chr(10),'')  -- 凭证编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.vouch_status_type_cd,chr(13),''),chr(10),'')  -- 凭证状态类型代码
    ,replace(replace(t1.vouch_status_cd,chr(13),''),chr(10),'')  -- 凭证状态代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.agt_vouch_status_h t1    --凭证状态历史
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_agt_vouch_status_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);