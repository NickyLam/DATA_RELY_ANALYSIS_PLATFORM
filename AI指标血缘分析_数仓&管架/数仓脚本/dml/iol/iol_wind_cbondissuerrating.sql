/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondissuerrating
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
drop table ${iol_schema}.wind_cbondissuerrating_ex purge;
alter table ${iol_schema}.wind_cbondissuerrating add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.wind_cbondissuerrating;

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cbondissuerrating_ex nologging
compress
as
select * from ${iol_schema}.wind_cbondissuerrating where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cbondissuerrating_ex(
    object_id -- 对象ID
    ,s_info_compname -- 公司中文名称
    ,ann_dt -- 评级日期
    ,b_rate_style -- 评级类型
    ,b_info_creditrating -- 信用评级
    ,b_rate_ratingoutlook -- 评级展望
    ,b_info_creditratingagency -- 评级机构代码
    ,s_info_compcode -- 债券主体公司id
    ,b_info_creditratingexplain -- 信用评级说明
    ,b_info_precreditrating -- 前次信用评级
    ,b_creditrating_change -- 评级变动方向
    ,b_info_issuerratetype -- 评级对象类型代码
    ,ann_dt2 -- 公告日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compname -- 公司中文名称
    ,ann_dt -- 评级日期
    ,b_rate_style -- 评级类型
    ,b_info_creditrating -- 信用评级
    ,b_rate_ratingoutlook -- 评级展望
    ,b_info_creditratingagency -- 评级机构代码
    ,s_info_compcode -- 债券主体公司id
    ,b_info_creditratingexplain -- 信用评级说明
    ,b_info_precreditrating -- 前次信用评级
    ,b_creditrating_change -- 评级变动方向
    ,b_info_issuerratetype -- 评级对象类型代码
    ,ann_dt2 -- 公告日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cbondissuerrating
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cbondissuerrating exchange partition p_${batch_date} with table ${iol_schema}.wind_cbondissuerrating_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondissuerrating to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cbondissuerrating_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondissuerrating',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);