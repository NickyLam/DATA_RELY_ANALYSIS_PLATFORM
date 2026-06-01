/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_ymsais02017
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
drop table ${iol_schema}.uxds_f_ymsais02017_ex purge;
alter table ${iol_schema}.uxds_f_ymsais02017 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_f_ymsais02017;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_ymsais02017_ex nologging
compress
as
select * from ${iol_schema}.uxds_f_ymsais02017 where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_ymsais02017_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,channeltype -- 渠道类型
    ,mobstatusresult_itemdata -- 查询结果数据
    ,mobstatusresult_itemcode -- 查询结果代码
    ,mobstatusresult_iteminfo -- 查询结果描述
    ,genmonth -- 生成月份
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,channeltype -- 渠道类型
    ,mobstatusresult_itemdata -- 查询结果数据
    ,mobstatusresult_itemcode -- 查询结果代码
    ,mobstatusresult_iteminfo -- 查询结果描述
    ,genmonth -- 生成月份
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_ymsais02017
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_ymsais02017 exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_ymsais02017_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_ymsais02017 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_ymsais02017_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_ymsais02017',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);