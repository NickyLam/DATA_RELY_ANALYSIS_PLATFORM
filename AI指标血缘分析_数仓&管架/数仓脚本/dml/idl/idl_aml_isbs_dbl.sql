/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_dbl
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
alter table ${idl_schema}.aml_isbs_dbl drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_dbl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_dbl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_dbl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- Internal Unique ID
    ,ver  -- Version
    ,objtyp  -- Object Type
    ,objinr  -- Object INR
    ,rptno  -- 申报号码
    ,bassta  -- 基本数据状态
    ,dclsta  -- 申报信息状态
    ,vrfsta  -- 核销信息状态
    ,ownextkey  -- Initial Entity Code
    ,ownusr  -- Own User
    ,trninr  -- 对应TRNINR
    ,credat  -- 创建日期
    ,reldat  -- 授权日期
    ,tmpref  -- 临时申报流水号
    ,trdtyp  -- 贸易类型
    ,acttyp  -- 款项标志
    ,ygasta  -- 粤港澳电子缴费业务状态
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- Internal Unique ID
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- Version
    ,replace(replace(t1.objtyp,chr(13),''),chr(10),'')  -- Object Type
    ,replace(replace(t1.objinr,chr(13),''),chr(10),'')  -- Object INR
    ,replace(replace(t1.rptno,chr(13),''),chr(10),'')  -- 申报号码
    ,replace(replace(t1.bassta,chr(13),''),chr(10),'')  -- 基本数据状态
    ,replace(replace(t1.dclsta,chr(13),''),chr(10),'')  -- 申报信息状态
    ,replace(replace(t1.vrfsta,chr(13),''),chr(10),'')  -- 核销信息状态
    ,replace(replace(t1.ownextkey,chr(13),''),chr(10),'')  -- Initial Entity Code
    ,replace(replace(t1.ownusr,chr(13),''),chr(10),'')  -- Own User
    ,replace(replace(t1.trninr,chr(13),''),chr(10),'')  -- 对应TRNINR
    ,t1.credat  -- 创建日期
    ,t1.reldat  -- 授权日期
    ,replace(replace(t1.tmpref,chr(13),''),chr(10),'')  -- 临时申报流水号
    ,replace(replace(t1.trdtyp,chr(13),''),chr(10),'')  -- 贸易类型
    ,replace(replace(t1.acttyp,chr(13),''),chr(10),'')  -- 款项标志
    ,replace(replace(t1.ygasta,chr(13),''),chr(10),'')  -- 粤港澳电子缴费业务状态
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_dbl t1    --申报信息状态表
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_dbl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);