/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_catalog_table
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
create table ${iol_schema}.atms_dev_catalog_table_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_catalog_table
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_catalog_table_op purge;
drop table ${iol_schema}.atms_dev_catalog_table_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_catalog_table_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_catalog_table where 0=1;

create table ${iol_schema}.atms_dev_catalog_table_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_catalog_table where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_catalog_table_cl(
            no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_catalog_table_op(
            no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.no, o.no) as no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
    ,nvl(n.name, o.name) as name -- 设备类型
    ,nvl(n.enname, o.enname) as enname -- 描述
    ,nvl(n.monitor_type, o.monitor_type) as monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
    ,nvl(n.channel_type, o.channel_type) as channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
    ,case when
            n.no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_dev_catalog_table_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_catalog_table where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.no = n.no
where (
        o.no is null
    )
    or (
        n.no is null
    )
    or (
        o.name <> n.name
        or o.enname <> n.enname
        or o.monitor_type <> n.monitor_type
        or o.channel_type <> n.channel_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_catalog_table_cl(
            no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_catalog_table_op(
            no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
    ,o.name -- 设备类型
    ,o.enname -- 描述
    ,o.monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
    ,o.channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.atms_dev_catalog_table_bk o
    left join ${iol_schema}.atms_dev_catalog_table_op n
        on
            o.no = n.no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_catalog_table_cl d
        on
            o.no = d.no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_dev_catalog_table;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_catalog_table') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_catalog_table drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_catalog_table add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_catalog_table exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_catalog_table_cl;
alter table ${iol_schema}.atms_dev_catalog_table exchange partition p_20991231 with table ${iol_schema}.atms_dev_catalog_table_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_catalog_table to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_catalog_table_op purge;
drop table ${iol_schema}.atms_dev_catalog_table_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_catalog_table_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_catalog_table',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
