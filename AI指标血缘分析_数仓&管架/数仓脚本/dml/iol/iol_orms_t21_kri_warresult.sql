/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orms_t21_kri_warresult
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
create table ${iol_schema}.orms_t21_kri_warresult_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orms_t21_kri_warresult;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_kri_warresult_op purge;
drop table ${iol_schema}.orms_t21_kri_warresult_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_kri_warresult_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_kri_warresult where 0=1;

create table ${iol_schema}.orms_t21_kri_warresult_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_kri_warresult where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_kri_warresult_cl(
            waringid -- 预警结果编号物理主键
            ,dataid -- 数据ID
            ,kriid -- 指标ID
            ,waringunitid -- 预警机构编号
            ,waringvalue -- 预警值
            ,startdate -- 数据起始日期
            ,enddate -- 数据结束日期
            ,krirangeid -- 预警关联的指标阈值ID
            ,waringrange -- 预警区间（关联的指标阈值）
            ,waringdate -- 预警日期
            ,notifistaffid -- 通知对象
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,kricolorid -- 与容忍度参数表关联
            ,kricolorrgb -- 容忍度颜色值
            ,orgid -- 纬度机构ID
            ,blid -- 纬度业务条线ID
            ,warstatus -- 预警状态
            ,anadesc -- 分析说明
            ,isact -- 是否发起整改
            ,recordversion -- 记录版本号
            ,createdtime -- 创建时间
            ,lastmodid -- 最近修改人ID
            ,lastmodtime -- 最近修改时间
            ,delflag -- 删除标志
            ,toleranceid -- 容忍度id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_kri_warresult_op(
            waringid -- 预警结果编号物理主键
            ,dataid -- 数据ID
            ,kriid -- 指标ID
            ,waringunitid -- 预警机构编号
            ,waringvalue -- 预警值
            ,startdate -- 数据起始日期
            ,enddate -- 数据结束日期
            ,krirangeid -- 预警关联的指标阈值ID
            ,waringrange -- 预警区间（关联的指标阈值）
            ,waringdate -- 预警日期
            ,notifistaffid -- 通知对象
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,kricolorid -- 与容忍度参数表关联
            ,kricolorrgb -- 容忍度颜色值
            ,orgid -- 纬度机构ID
            ,blid -- 纬度业务条线ID
            ,warstatus -- 预警状态
            ,anadesc -- 分析说明
            ,isact -- 是否发起整改
            ,recordversion -- 记录版本号
            ,createdtime -- 创建时间
            ,lastmodid -- 最近修改人ID
            ,lastmodtime -- 最近修改时间
            ,delflag -- 删除标志
            ,toleranceid -- 容忍度id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.waringid, o.waringid) as waringid -- 预警结果编号物理主键
    ,nvl(n.dataid, o.dataid) as dataid -- 数据ID
    ,nvl(n.kriid, o.kriid) as kriid -- 指标ID
    ,nvl(n.waringunitid, o.waringunitid) as waringunitid -- 预警机构编号
    ,nvl(n.waringvalue, o.waringvalue) as waringvalue -- 预警值
    ,nvl(n.startdate, o.startdate) as startdate -- 数据起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 数据结束日期
    ,nvl(n.krirangeid, o.krirangeid) as krirangeid -- 预警关联的指标阈值ID
    ,nvl(n.waringrange, o.waringrange) as waringrange -- 预警区间（关联的指标阈值）
    ,nvl(n.waringdate, o.waringdate) as waringdate -- 预警日期
    ,nvl(n.notifistaffid, o.notifistaffid) as notifistaffid -- 通知对象
    ,nvl(n.notifimode, o.notifimode) as notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,nvl(n.kricolorid, o.kricolorid) as kricolorid -- 与容忍度参数表关联
    ,nvl(n.kricolorrgb, o.kricolorrgb) as kricolorrgb -- 容忍度颜色值
    ,nvl(n.orgid, o.orgid) as orgid -- 纬度机构ID
    ,nvl(n.blid, o.blid) as blid -- 纬度业务条线ID
    ,nvl(n.warstatus, o.warstatus) as warstatus -- 预警状态
    ,nvl(n.anadesc, o.anadesc) as anadesc -- 分析说明
    ,nvl(n.isact, o.isact) as isact -- 是否发起整改
    ,nvl(n.recordversion, o.recordversion) as recordversion -- 记录版本号
    ,nvl(n.createdtime, o.createdtime) as createdtime -- 创建时间
    ,nvl(n.lastmodid, o.lastmodid) as lastmodid -- 最近修改人ID
    ,nvl(n.lastmodtime, o.lastmodtime) as lastmodtime -- 最近修改时间
    ,nvl(n.delflag, o.delflag) as delflag -- 删除标志
    ,nvl(n.toleranceid, o.toleranceid) as toleranceid -- 容忍度id
    ,case when
            n.waringid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.waringid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.waringid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orms_t21_kri_warresult_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orms_t21_kri_warresult where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.waringid = n.waringid
where (
        o.waringid is null
    )
    or (
        n.waringid is null
    )
    or (
        o.dataid <> n.dataid
        or o.kriid <> n.kriid
        or o.waringunitid <> n.waringunitid
        or o.waringvalue <> n.waringvalue
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.krirangeid <> n.krirangeid
        or o.waringrange <> n.waringrange
        or o.waringdate <> n.waringdate
        or o.notifistaffid <> n.notifistaffid
        or o.notifimode <> n.notifimode
        or o.kricolorid <> n.kricolorid
        or o.kricolorrgb <> n.kricolorrgb
        or o.orgid <> n.orgid
        or o.blid <> n.blid
        or o.warstatus <> n.warstatus
        or o.anadesc <> n.anadesc
        or o.isact <> n.isact
        or o.recordversion <> n.recordversion
        or o.createdtime <> n.createdtime
        or o.lastmodid <> n.lastmodid
        or o.lastmodtime <> n.lastmodtime
        or o.delflag <> n.delflag
        or o.toleranceid <> n.toleranceid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_kri_warresult_cl(
            waringid -- 预警结果编号物理主键
            ,dataid -- 数据ID
            ,kriid -- 指标ID
            ,waringunitid -- 预警机构编号
            ,waringvalue -- 预警值
            ,startdate -- 数据起始日期
            ,enddate -- 数据结束日期
            ,krirangeid -- 预警关联的指标阈值ID
            ,waringrange -- 预警区间（关联的指标阈值）
            ,waringdate -- 预警日期
            ,notifistaffid -- 通知对象
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,kricolorid -- 与容忍度参数表关联
            ,kricolorrgb -- 容忍度颜色值
            ,orgid -- 纬度机构ID
            ,blid -- 纬度业务条线ID
            ,warstatus -- 预警状态
            ,anadesc -- 分析说明
            ,isact -- 是否发起整改
            ,recordversion -- 记录版本号
            ,createdtime -- 创建时间
            ,lastmodid -- 最近修改人ID
            ,lastmodtime -- 最近修改时间
            ,delflag -- 删除标志
            ,toleranceid -- 容忍度id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_kri_warresult_op(
            waringid -- 预警结果编号物理主键
            ,dataid -- 数据ID
            ,kriid -- 指标ID
            ,waringunitid -- 预警机构编号
            ,waringvalue -- 预警值
            ,startdate -- 数据起始日期
            ,enddate -- 数据结束日期
            ,krirangeid -- 预警关联的指标阈值ID
            ,waringrange -- 预警区间（关联的指标阈值）
            ,waringdate -- 预警日期
            ,notifistaffid -- 通知对象
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,kricolorid -- 与容忍度参数表关联
            ,kricolorrgb -- 容忍度颜色值
            ,orgid -- 纬度机构ID
            ,blid -- 纬度业务条线ID
            ,warstatus -- 预警状态
            ,anadesc -- 分析说明
            ,isact -- 是否发起整改
            ,recordversion -- 记录版本号
            ,createdtime -- 创建时间
            ,lastmodid -- 最近修改人ID
            ,lastmodtime -- 最近修改时间
            ,delflag -- 删除标志
            ,toleranceid -- 容忍度id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.waringid -- 预警结果编号物理主键
    ,o.dataid -- 数据ID
    ,o.kriid -- 指标ID
    ,o.waringunitid -- 预警机构编号
    ,o.waringvalue -- 预警值
    ,o.startdate -- 数据起始日期
    ,o.enddate -- 数据结束日期
    ,o.krirangeid -- 预警关联的指标阈值ID
    ,o.waringrange -- 预警区间（关联的指标阈值）
    ,o.waringdate -- 预警日期
    ,o.notifistaffid -- 通知对象
    ,o.notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,o.kricolorid -- 与容忍度参数表关联
    ,o.kricolorrgb -- 容忍度颜色值
    ,o.orgid -- 纬度机构ID
    ,o.blid -- 纬度业务条线ID
    ,o.warstatus -- 预警状态
    ,o.anadesc -- 分析说明
    ,o.isact -- 是否发起整改
    ,o.recordversion -- 记录版本号
    ,o.createdtime -- 创建时间
    ,o.lastmodid -- 最近修改人ID
    ,o.lastmodtime -- 最近修改时间
    ,o.delflag -- 删除标志
    ,o.toleranceid -- 容忍度id
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orms_t21_kri_warresult_bk o
    left join ${iol_schema}.orms_t21_kri_warresult_op n
        on
            o.waringid = n.waringid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orms_t21_kri_warresult_cl d
        on
            o.waringid = d.waringid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.orms_t21_kri_warresult;

-- 4.2 exchange partition
alter table ${iol_schema}.orms_t21_kri_warresult exchange partition p_19000101 with table ${iol_schema}.orms_t21_kri_warresult_cl;
alter table ${iol_schema}.orms_t21_kri_warresult exchange partition p_20991231 with table ${iol_schema}.orms_t21_kri_warresult_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orms_t21_kri_warresult to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_kri_warresult_op purge;
drop table ${iol_schema}.orms_t21_kri_warresult_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orms_t21_kri_warresult_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orms_t21_kri_warresult',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
