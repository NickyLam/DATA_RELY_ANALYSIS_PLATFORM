/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_service_company
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
create table ${iol_schema}.atms_dev_service_company_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_service_company
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_service_company_op purge;
drop table ${iol_schema}.atms_dev_service_company_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_service_company_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_service_company where 0=1;

create table ${iol_schema}.atms_dev_service_company_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_service_company where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_service_company_cl(
            no -- 编号
            ,name -- 服务商名称
            ,linkman -- 联系人
            ,address -- 地址
            ,phone -- 固话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,infofilepath -- 信息文件路径
            ,infofilename -- 信息文件名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_service_company_op(
            no -- 编号
            ,name -- 服务商名称
            ,linkman -- 联系人
            ,address -- 地址
            ,phone -- 固话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,infofilepath -- 信息文件路径
            ,infofilename -- 信息文件名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.no, o.no) as no -- 编号
    ,nvl(n.name, o.name) as name -- 服务商名称
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.phone, o.phone) as phone -- 固话
    ,nvl(n.mobile, o.mobile) as mobile -- 手机
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.infofilepath, o.infofilepath) as infofilepath -- 信息文件路径
    ,nvl(n.infofilename, o.infofilename) as infofilename -- 信息文件名称
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
from (select * from ${iol_schema}.atms_dev_service_company_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_service_company where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.linkman <> n.linkman
        or o.address <> n.address
        or o.phone <> n.phone
        or o.mobile <> n.mobile
        or o.fax <> n.fax
        or o.email <> n.email
        or o.infofilepath <> n.infofilepath
        or o.infofilename <> n.infofilename
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_service_company_cl(
            no -- 编号
            ,name -- 服务商名称
            ,linkman -- 联系人
            ,address -- 地址
            ,phone -- 固话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,infofilepath -- 信息文件路径
            ,infofilename -- 信息文件名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_service_company_op(
            no -- 编号
            ,name -- 服务商名称
            ,linkman -- 联系人
            ,address -- 地址
            ,phone -- 固话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,infofilepath -- 信息文件路径
            ,infofilename -- 信息文件名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.no -- 编号
    ,o.name -- 服务商名称
    ,o.linkman -- 联系人
    ,o.address -- 地址
    ,o.phone -- 固话
    ,o.mobile -- 手机
    ,o.fax -- 传真
    ,o.email -- 电子邮箱
    ,o.infofilepath -- 信息文件路径
    ,o.infofilename -- 信息文件名称
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
from ${iol_schema}.atms_dev_service_company_bk o
    left join ${iol_schema}.atms_dev_service_company_op n
        on
            o.no = n.no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_service_company_cl d
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
--truncate table ${iol_schema}.atms_dev_service_company;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_service_company') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_service_company drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_service_company add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_service_company exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_service_company_cl;
alter table ${iol_schema}.atms_dev_service_company exchange partition p_20991231 with table ${iol_schema}.atms_dev_service_company_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_service_company to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_service_company_op purge;
drop table ${iol_schema}.atms_dev_service_company_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_service_company_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_service_company',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
