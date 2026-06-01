/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid
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
drop table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid_ex purge;
alter table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid_ex nologging
compress
as
select * from ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,areaname -- 行政区
    ,provincename -- 省份
    ,constructionid -- 楼盘编码
    ,slgetconstrutionviewinfobyid -- 关联标签
    ,doorplate -- 显示地址
    ,developers -- 开发商
    ,regionname -- 片区
    ,constructionname -- 楼盘名称
    ,arealine -- 环线
    ,areaid -- 行政区ID
    ,enddate -- 建成年代
    ,salename -- 楼盘自定义名称
    ,genmonth -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,areaname -- 行政区
    ,provincename -- 省份
    ,constructionid -- 楼盘编码
    ,slgetconstrutionviewinfobyid -- 关联标签
    ,doorplate -- 显示地址
    ,developers -- 开发商
    ,regionname -- 片区
    ,constructionname -- 楼盘名称
    ,arealine -- 环线
    ,areaid -- 行政区ID
    ,enddate -- 建成年代
    ,salename -- 楼盘自定义名称
    ,genmonth -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);