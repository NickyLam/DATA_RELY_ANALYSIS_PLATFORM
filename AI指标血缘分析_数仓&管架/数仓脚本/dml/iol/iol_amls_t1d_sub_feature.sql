/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t1d_sub_feature
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
drop table ${iol_schema}.amls_t1d_sub_feature_ex purge;
alter table ${iol_schema}.amls_t1d_sub_feature add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t1d_sub_feature;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t1d_sub_feature_ex nologging
compress
as
select * from ${iol_schema}.amls_t1d_sub_feature where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t1d_sub_feature_ex(
    sub_fetr_id -- 子特征编号
    ,sub_fetr_name -- 子特征名称
    ,fetr_type -- 特征类型（参见[字典:AML0011]）
    ,exec_mode -- 特征计算方式（参见[字典:AML0013]）
    ,fetr_sts -- 特征状态（参见[字典:AML0014]）
    ,is_local_curr -- 是否本币（参见[字典:AML0015]）
    ,fetr_freq -- 特征频度（参见[字典:T00026]）
    ,fetr_desc -- 特征描述
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,fetr_id -- 特征编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sub_fetr_id -- 子特征编号
    ,sub_fetr_name -- 子特征名称
    ,fetr_type -- 特征类型（参见[字典:AML0011]）
    ,exec_mode -- 特征计算方式（参见[字典:AML0013]）
    ,fetr_sts -- 特征状态（参见[字典:AML0014]）
    ,is_local_curr -- 是否本币（参见[字典:AML0015]）
    ,fetr_freq -- 特征频度（参见[字典:T00026]）
    ,fetr_desc -- 特征描述
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,fetr_id -- 特征编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t1d_sub_feature
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t1d_sub_feature exchange partition p_${batch_date} with table ${iol_schema}.amls_t1d_sub_feature_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t1d_sub_feature to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t1d_sub_feature_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t1d_sub_feature',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);