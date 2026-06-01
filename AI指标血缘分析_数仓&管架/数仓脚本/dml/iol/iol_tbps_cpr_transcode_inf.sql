/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_transcode_inf
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
create table ${iol_schema}.tbps_cpr_transcode_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_transcode_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transcode_inf_op purge;
drop table ${iol_schema}.tbps_cpr_transcode_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transcode_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transcode_inf where 0=1;

create table ${iol_schema}.tbps_cpr_transcode_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_transcode_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transcode_inf_cl(
            cti_transcode -- 交易码
            ,cti_transname -- 交易名称
            ,cti_transflag -- 对应功能菜单ID
            ,cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
            ,cti_channel -- 渠道(PC)
            ,cti_menuname -- 菜单名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transcode_inf_op(
            cti_transcode -- 交易码
            ,cti_transname -- 交易名称
            ,cti_transflag -- 对应功能菜单ID
            ,cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
            ,cti_channel -- 渠道(PC)
            ,cti_menuname -- 菜单名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cti_transcode, o.cti_transcode) as cti_transcode -- 交易码
    ,nvl(n.cti_transname, o.cti_transname) as cti_transname -- 交易名称
    ,nvl(n.cti_transflag, o.cti_transflag) as cti_transflag -- 对应功能菜单ID
    ,nvl(n.cti_menuid, o.cti_menuid) as cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
    ,nvl(n.cti_channel, o.cti_channel) as cti_channel -- 渠道(PC)
    ,nvl(n.cti_menuname, o.cti_menuname) as cti_menuname -- 菜单名称
    ,case when
            n.cti_transcode is null
            and n.cti_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cti_transcode is null
            and n.cti_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cti_transcode is null
            and n.cti_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_transcode_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_transcode_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cti_transcode = n.cti_transcode
            and o.cti_channel = n.cti_channel
where (
        o.cti_transcode is null
        and o.cti_channel is null
    )
    or (
        n.cti_transcode is null
        and n.cti_channel is null
    )
    or (
        o.cti_transname <> n.cti_transname
        or o.cti_transflag <> n.cti_transflag
        or o.cti_menuid <> n.cti_menuid
        or o.cti_menuname <> n.cti_menuname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_transcode_inf_cl(
            cti_transcode -- 交易码
            ,cti_transname -- 交易名称
            ,cti_transflag -- 对应功能菜单ID
            ,cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
            ,cti_channel -- 渠道(PC)
            ,cti_menuname -- 菜单名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_transcode_inf_op(
            cti_transcode -- 交易码
            ,cti_transname -- 交易名称
            ,cti_transflag -- 对应功能菜单ID
            ,cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
            ,cti_channel -- 渠道(PC)
            ,cti_menuname -- 菜单名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cti_transcode -- 交易码
    ,o.cti_transname -- 交易名称
    ,o.cti_transflag -- 对应功能菜单ID
    ,o.cti_menuid -- 金融交易标志(0:非金融；1:金融交易)
    ,o.cti_channel -- 渠道(PC)
    ,o.cti_menuname -- 菜单名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_transcode_inf_bk o
    left join ${iol_schema}.tbps_cpr_transcode_inf_op n
        on
            o.cti_transcode = n.cti_transcode
            and o.cti_channel = n.cti_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_transcode_inf_cl d
        on
            o.cti_transcode = d.cti_transcode
            and o.cti_channel = d.cti_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_transcode_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_transcode_inf exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_transcode_inf_cl;
alter table ${iol_schema}.tbps_cpr_transcode_inf exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_transcode_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_transcode_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_transcode_inf_op purge;
drop table ${iol_schema}.tbps_cpr_transcode_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_transcode_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_transcode_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
