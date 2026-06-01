/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_dbl
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.isbs_dbl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_dbl;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbl_op purge;
drop table ${iol_schema}.isbs_dbl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbl where 0=1;

create table ${iol_schema}.isbs_dbl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_dbl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbl_cl(
            inr -- Internal Unique ID
            ,ver -- Version
            ,objtyp -- Object Type
            ,objinr -- Object INR
            ,rptno -- 申报号码
            ,bassta -- 基本数据状态
            ,dclsta -- 申报信息状态
            ,vrfsta -- 核销信息状态
            ,ownextkey -- Initial Entity Code
            ,ownusr -- Own User
            ,trninr -- 对应TRNINR
            ,credat -- 创建日期
            ,reldat -- 授权日期
            ,tmpref -- 临时申报流水号
            ,trdtyp -- 贸易类型
            ,acttyp -- 款项标志
            ,ygasta -- 
            ,basstarcv -- 基础信息反馈状态
            ,dclstarcv -- 申报信息反馈状态
            ,vrfstarcv -- 管理信息反馈状态
            ,iscor -- 是否核心获取
            ,refcor -- 核心流水号
            ,filever -- 文件版本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbl_op(
            inr -- Internal Unique ID
            ,ver -- Version
            ,objtyp -- Object Type
            ,objinr -- Object INR
            ,rptno -- 申报号码
            ,bassta -- 基本数据状态
            ,dclsta -- 申报信息状态
            ,vrfsta -- 核销信息状态
            ,ownextkey -- Initial Entity Code
            ,ownusr -- Own User
            ,trninr -- 对应TRNINR
            ,credat -- 创建日期
            ,reldat -- 授权日期
            ,tmpref -- 临时申报流水号
            ,trdtyp -- 贸易类型
            ,acttyp -- 款项标志
            ,ygasta -- 
            ,basstarcv -- 基础信息反馈状态
            ,dclstarcv -- 申报信息反馈状态
            ,vrfstarcv -- 管理信息反馈状态
            ,iscor -- 是否核心获取
            ,refcor -- 核心流水号
            ,filever -- 文件版本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- Internal Unique ID
    ,nvl(n.ver, o.ver) as ver -- Version
    ,nvl(n.objtyp, o.objtyp) as objtyp -- Object Type
    ,nvl(n.objinr, o.objinr) as objinr -- Object INR
    ,nvl(n.rptno, o.rptno) as rptno -- 申报号码
    ,nvl(n.bassta, o.bassta) as bassta -- 基本数据状态
    ,nvl(n.dclsta, o.dclsta) as dclsta -- 申报信息状态
    ,nvl(n.vrfsta, o.vrfsta) as vrfsta -- 核销信息状态
    ,nvl(n.ownextkey, o.ownextkey) as ownextkey -- Initial Entity Code
    ,nvl(n.ownusr, o.ownusr) as ownusr -- Own User
    ,nvl(n.trninr, o.trninr) as trninr -- 对应TRNINR
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.reldat, o.reldat) as reldat -- 授权日期
    ,nvl(n.tmpref, o.tmpref) as tmpref -- 临时申报流水号
    ,nvl(n.trdtyp, o.trdtyp) as trdtyp -- 贸易类型
    ,nvl(n.acttyp, o.acttyp) as acttyp -- 款项标志
    ,nvl(n.ygasta, o.ygasta) as ygasta -- 
    ,nvl(n.basstarcv, o.basstarcv) as basstarcv -- 基础信息反馈状态
    ,nvl(n.dclstarcv, o.dclstarcv) as dclstarcv -- 申报信息反馈状态
    ,nvl(n.vrfstarcv, o.vrfstarcv) as vrfstarcv -- 管理信息反馈状态
    ,nvl(n.iscor, o.iscor) as iscor -- 是否核心获取
    ,nvl(n.refcor, o.refcor) as refcor -- 核心流水号
    ,nvl(n.filever, o.filever) as filever -- 文件版本
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_dbl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_dbl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ver <> n.ver
        or o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.rptno <> n.rptno
        or o.bassta <> n.bassta
        or o.dclsta <> n.dclsta
        or o.vrfsta <> n.vrfsta
        or o.ownextkey <> n.ownextkey
        or o.ownusr <> n.ownusr
        or o.trninr <> n.trninr
        or o.credat <> n.credat
        or o.reldat <> n.reldat
        or o.tmpref <> n.tmpref
        or o.trdtyp <> n.trdtyp
        or o.acttyp <> n.acttyp
        or o.ygasta <> n.ygasta
        or o.basstarcv <> n.basstarcv
        or o.dclstarcv <> n.dclstarcv
        or o.vrfstarcv <> n.vrfstarcv
        or o.iscor <> n.iscor
        or o.refcor <> n.refcor
        or o.filever <> n.filever
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_dbl_cl(
            inr -- Internal Unique ID
            ,ver -- Version
            ,objtyp -- Object Type
            ,objinr -- Object INR
            ,rptno -- 申报号码
            ,bassta -- 基本数据状态
            ,dclsta -- 申报信息状态
            ,vrfsta -- 核销信息状态
            ,ownextkey -- Initial Entity Code
            ,ownusr -- Own User
            ,trninr -- 对应TRNINR
            ,credat -- 创建日期
            ,reldat -- 授权日期
            ,tmpref -- 临时申报流水号
            ,trdtyp -- 贸易类型
            ,acttyp -- 款项标志
            ,ygasta -- 
            ,basstarcv -- 基础信息反馈状态
            ,dclstarcv -- 申报信息反馈状态
            ,vrfstarcv -- 管理信息反馈状态
            ,iscor -- 是否核心获取
            ,refcor -- 核心流水号
            ,filever -- 文件版本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_dbl_op(
            inr -- Internal Unique ID
            ,ver -- Version
            ,objtyp -- Object Type
            ,objinr -- Object INR
            ,rptno -- 申报号码
            ,bassta -- 基本数据状态
            ,dclsta -- 申报信息状态
            ,vrfsta -- 核销信息状态
            ,ownextkey -- Initial Entity Code
            ,ownusr -- Own User
            ,trninr -- 对应TRNINR
            ,credat -- 创建日期
            ,reldat -- 授权日期
            ,tmpref -- 临时申报流水号
            ,trdtyp -- 贸易类型
            ,acttyp -- 款项标志
            ,ygasta -- 
            ,basstarcv -- 基础信息反馈状态
            ,dclstarcv -- 申报信息反馈状态
            ,vrfstarcv -- 管理信息反馈状态
            ,iscor -- 是否核心获取
            ,refcor -- 核心流水号
            ,filever -- 文件版本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- Internal Unique ID
    ,o.ver -- Version
    ,o.objtyp -- Object Type
    ,o.objinr -- Object INR
    ,o.rptno -- 申报号码
    ,o.bassta -- 基本数据状态
    ,o.dclsta -- 申报信息状态
    ,o.vrfsta -- 核销信息状态
    ,o.ownextkey -- Initial Entity Code
    ,o.ownusr -- Own User
    ,o.trninr -- 对应TRNINR
    ,o.credat -- 创建日期
    ,o.reldat -- 授权日期
    ,o.tmpref -- 临时申报流水号
    ,o.trdtyp -- 贸易类型
    ,o.acttyp -- 款项标志
    ,o.ygasta -- 
    ,o.basstarcv -- 基础信息反馈状态
    ,o.dclstarcv -- 申报信息反馈状态
    ,o.vrfstarcv -- 管理信息反馈状态
    ,o.iscor -- 是否核心获取
    ,o.refcor -- 核心流水号
    ,o.filever -- 文件版本
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_dbl_bk o
    left join ${iol_schema}.isbs_dbl_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_dbl_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_dbl;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_dbl exchange partition p_19000101 with table ${iol_schema}.isbs_dbl_cl;
alter table ${iol_schema}.isbs_dbl exchange partition p_20991231 with table ${iol_schema}.isbs_dbl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_dbl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_dbl_op purge;
drop table ${iol_schema}.isbs_dbl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_dbl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_dbl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
