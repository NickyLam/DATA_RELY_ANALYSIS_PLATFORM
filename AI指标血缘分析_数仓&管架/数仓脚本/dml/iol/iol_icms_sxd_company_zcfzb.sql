/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_zcfzb
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
create table ${iol_schema}.icms_sxd_company_zcfzb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_zcfzb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_zcfzb_op purge;
drop table ${iol_schema}.icms_sxd_company_zcfzb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_zcfzb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_zcfzb where 0=1;

create table ${iol_schema}.icms_sxd_company_zcfzb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_zcfzb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_zcfzb_cl(
            id -- 主键
            ,sssqq -- 所属时间起
            ,qms_qy -- 期末数资产（权益）
            ,zcxmmc -- 资产项目名称
            ,mc -- 序号
            ,ncs_qy -- 年初数资产（权益）
            ,serno -- 业务流水号
            ,qyxmmc -- 负债和所有者权益项目名称
            ,sssqz -- 所属时间止
            ,bblx -- 版本类型
            ,sbrq -- 申报日期
            ,qms_zc -- 期末数资产（资产）
            ,ncs_zc -- 年初数资产（资产）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_zcfzb_op(
            id -- 主键
            ,sssqq -- 所属时间起
            ,qms_qy -- 期末数资产（权益）
            ,zcxmmc -- 资产项目名称
            ,mc -- 序号
            ,ncs_qy -- 年初数资产（权益）
            ,serno -- 业务流水号
            ,qyxmmc -- 负债和所有者权益项目名称
            ,sssqz -- 所属时间止
            ,bblx -- 版本类型
            ,sbrq -- 申报日期
            ,qms_zc -- 期末数资产（资产）
            ,ncs_zc -- 年初数资产（资产）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.sssqq, o.sssqq) as sssqq -- 所属时间起
    ,nvl(n.qms_qy, o.qms_qy) as qms_qy -- 期末数资产（权益）
    ,nvl(n.zcxmmc, o.zcxmmc) as zcxmmc -- 资产项目名称
    ,nvl(n.mc, o.mc) as mc -- 序号
    ,nvl(n.ncs_qy, o.ncs_qy) as ncs_qy -- 年初数资产（权益）
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.qyxmmc, o.qyxmmc) as qyxmmc -- 负债和所有者权益项目名称
    ,nvl(n.sssqz, o.sssqz) as sssqz -- 所属时间止
    ,nvl(n.bblx, o.bblx) as bblx -- 版本类型
    ,nvl(n.sbrq, o.sbrq) as sbrq -- 申报日期
    ,nvl(n.qms_zc, o.qms_zc) as qms_zc -- 期末数资产（资产）
    ,nvl(n.ncs_zc, o.ncs_zc) as ncs_zc -- 年初数资产（资产）
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_sxd_company_zcfzb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_zcfzb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.sssqq <> n.sssqq
        or o.qms_qy <> n.qms_qy
        or o.zcxmmc <> n.zcxmmc
        or o.mc <> n.mc
        or o.ncs_qy <> n.ncs_qy
        or o.serno <> n.serno
        or o.qyxmmc <> n.qyxmmc
        or o.sssqz <> n.sssqz
        or o.bblx <> n.bblx
        or o.sbrq <> n.sbrq
        or o.qms_zc <> n.qms_zc
        or o.ncs_zc <> n.ncs_zc
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_zcfzb_cl(
            id -- 主键
            ,sssqq -- 所属时间起
            ,qms_qy -- 期末数资产（权益）
            ,zcxmmc -- 资产项目名称
            ,mc -- 序号
            ,ncs_qy -- 年初数资产（权益）
            ,serno -- 业务流水号
            ,qyxmmc -- 负债和所有者权益项目名称
            ,sssqz -- 所属时间止
            ,bblx -- 版本类型
            ,sbrq -- 申报日期
            ,qms_zc -- 期末数资产（资产）
            ,ncs_zc -- 年初数资产（资产）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_zcfzb_op(
            id -- 主键
            ,sssqq -- 所属时间起
            ,qms_qy -- 期末数资产（权益）
            ,zcxmmc -- 资产项目名称
            ,mc -- 序号
            ,ncs_qy -- 年初数资产（权益）
            ,serno -- 业务流水号
            ,qyxmmc -- 负债和所有者权益项目名称
            ,sssqz -- 所属时间止
            ,bblx -- 版本类型
            ,sbrq -- 申报日期
            ,qms_zc -- 期末数资产（资产）
            ,ncs_zc -- 年初数资产（资产）
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.sssqq -- 所属时间起
    ,o.qms_qy -- 期末数资产（权益）
    ,o.zcxmmc -- 资产项目名称
    ,o.mc -- 序号
    ,o.ncs_qy -- 年初数资产（权益）
    ,o.serno -- 业务流水号
    ,o.qyxmmc -- 负债和所有者权益项目名称
    ,o.sssqz -- 所属时间止
    ,o.bblx -- 版本类型
    ,o.sbrq -- 申报日期
    ,o.qms_zc -- 期末数资产（资产）
    ,o.ncs_zc -- 年初数资产（资产）
    ,o.migtflag -- 迁移标志：crsrcrilcupl
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
from ${iol_schema}.icms_sxd_company_zcfzb_bk o
    left join ${iol_schema}.icms_sxd_company_zcfzb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_zcfzb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_sxd_company_zcfzb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_zcfzb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_zcfzb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_zcfzb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_zcfzb exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_zcfzb_cl;
alter table ${iol_schema}.icms_sxd_company_zcfzb exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_zcfzb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_zcfzb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_zcfzb_op purge;
drop table ${iol_schema}.icms_sxd_company_zcfzb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_zcfzb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_zcfzb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
