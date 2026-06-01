/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondthirdpartyrating
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
drop table ${iol_schema}.wind_cbondthirdpartyrating_ex purge;
alter table ${iol_schema}.wind_cbondthirdpartyrating add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.wind_cbondthirdpartyrating;

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cbondthirdpartyrating_ex nologging
compress
as
select * from ${iol_schema}.wind_cbondthirdpartyrating where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cbondthirdpartyrating_ex(
    object_id -- 对象ID
    ,s_info_compname -- 公司名称
    ,s_info_compcode -- 品种ID
    ,b_rate_style -- 品种类别代码
    ,b_info_listdate -- 发布日期
    ,b_typcode -- 评级类型代码
    ,b_est_rating_inst -- 信用等级
    ,b_est_institute -- 评估机构公司
    ,b_rate_ratingoutlook -- 评级展望
    ,b_est_prerating_inst -- 前次评级
    ,b_rate_preratingoutlook -- 前次评级展望
    ,b_est_rating_change -- 评级变动方向
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compname -- 公司名称
    ,s_info_compcode -- 品种ID
    ,b_rate_style -- 品种类别代码
    ,b_info_listdate -- 发布日期
    ,b_typcode -- 评级类型代码
    ,b_est_rating_inst -- 信用等级
    ,b_est_institute -- 评估机构公司
    ,b_rate_ratingoutlook -- 评级展望
    ,b_est_prerating_inst -- 前次评级
    ,b_rate_preratingoutlook -- 前次评级展望
    ,b_est_rating_change -- 评级变动方向
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cbondthirdpartyrating
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cbondthirdpartyrating exchange partition p_${batch_date} with table ${iol_schema}.wind_cbondthirdpartyrating_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondthirdpartyrating to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cbondthirdpartyrating_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondthirdpartyrating',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);