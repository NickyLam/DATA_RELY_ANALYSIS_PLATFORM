/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t00_pub_code_define
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t00_pub_code_define_ex purge;
alter table ${iol_schema}.eifs_t00_pub_code_define add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.eifs_t00_pub_code_define;

-- 2.3 insert data to ex table
create table ${iol_schema}.eifs_t00_pub_code_define_ex nologging
compress
as
select * from ${iol_schema}.eifs_t00_pub_code_define where 0=1;

insert /*+ append */ into ${iol_schema}.eifs_t00_pub_code_define_ex(
    code_no -- 代码编号
    ,code_name -- 中文名称
    ,code_value -- 代码值
    ,code_desc -- 中文说明
    ,valid_flag -- 有效标志
    ,code_id -- 代码ID
    ,code_sort -- 代码排序
    ,parent_id -- 父代码ID
    ,sub_code -- 子类码值
    ,description -- 描述
    ,init_user_id -- 创建人用户ID
    ,init_user_postn_id -- 创建人用户岗位ID
    ,update_user_id -- 更新人用户ID
    ,update_user_postn_id -- 更新人用户岗位ID
    ,created_ts -- 进入ECIF的时间
    ,last_updated_ts -- 最新更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    code_no -- 代码编号
    ,code_name -- 中文名称
    ,code_value -- 代码值
    ,code_desc -- 中文说明
    ,valid_flag -- 有效标志
    ,code_id -- 代码ID
    ,code_sort -- 代码排序
    ,parent_id -- 父代码ID
    ,sub_code -- 子类码值
    ,description -- 描述
    ,init_user_id -- 创建人用户ID
    ,init_user_postn_id -- 创建人用户岗位ID
    ,update_user_id -- 更新人用户ID
    ,update_user_postn_id -- 更新人用户岗位ID
    ,created_ts -- 进入ECIF的时间
    ,last_updated_ts -- 最新更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.eifs_t00_pub_code_define
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.eifs_t00_pub_code_define exchange partition p_${batch_date} with table ${iol_schema}.eifs_t00_pub_code_define_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t00_pub_code_define to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.eifs_t00_pub_code_define_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t00_pub_code_define',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);