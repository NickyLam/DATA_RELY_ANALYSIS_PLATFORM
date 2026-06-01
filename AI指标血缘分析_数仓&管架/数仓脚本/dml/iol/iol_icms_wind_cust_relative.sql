/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wind_cust_relative
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
create table ${iol_schema}.icms_wind_cust_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wind_cust_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_relative_op purge;
drop table ${iol_schema}.icms_wind_cust_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_relative where 0=1;

create table ${iol_schema}.icms_wind_cust_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_relative_cl(
            serialno -- 流水号
            ,relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
            ,relpost -- wind关联人担任职务
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,islisted -- 是否上市公司
            ,updatedate -- 更新日期
            ,introduction -- 简历
            ,holdrate -- 股东持股比率
            ,updateuserid -- 更新员工编号
            ,relname -- 关联人名称
            ,enddate -- 持股截止日期
            ,inputorgid -- 新增机构编号
            ,compcode -- 公司代码
            ,updateorgid -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_relative_op(
            serialno -- 流水号
            ,relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
            ,relpost -- wind关联人担任职务
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,islisted -- 是否上市公司
            ,updatedate -- 更新日期
            ,introduction -- 简历
            ,holdrate -- 股东持股比率
            ,updateuserid -- 更新员工编号
            ,relname -- 关联人名称
            ,enddate -- 持股截止日期
            ,inputorgid -- 新增机构编号
            ,compcode -- 公司代码
            ,updateorgid -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relationship, o.relationship) as relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
    ,nvl(n.relpost, o.relpost) as relpost -- wind关联人担任职务
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 新增员工编号
    ,nvl(n.islisted, o.islisted) as islisted -- 是否上市公司
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.introduction, o.introduction) as introduction -- 简历
    ,nvl(n.holdrate, o.holdrate) as holdrate -- 股东持股比率
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新员工编号
    ,nvl(n.relname, o.relname) as relname -- 关联人名称
    ,nvl(n.enddate, o.enddate) as enddate -- 持股截止日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 新增机构编号
    ,nvl(n.compcode, o.compcode) as compcode -- 公司代码
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wind_cust_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wind_cust_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relationship <> n.relationship
        or o.relpost <> n.relpost
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
        or o.islisted <> n.islisted
        or o.updatedate <> n.updatedate
        or o.introduction <> n.introduction
        or o.holdrate <> n.holdrate
        or o.updateuserid <> n.updateuserid
        or o.relname <> n.relname
        or o.enddate <> n.enddate
        or o.inputorgid <> n.inputorgid
        or o.compcode <> n.compcode
        or o.updateorgid <> n.updateorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_relative_cl(
            serialno -- 流水号
            ,relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
            ,relpost -- wind关联人担任职务
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,islisted -- 是否上市公司
            ,updatedate -- 更新日期
            ,introduction -- 简历
            ,holdrate -- 股东持股比率
            ,updateuserid -- 更新员工编号
            ,relname -- 关联人名称
            ,enddate -- 持股截止日期
            ,inputorgid -- 新增机构编号
            ,compcode -- 公司代码
            ,updateorgid -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_relative_op(
            serialno -- 流水号
            ,relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
            ,relpost -- wind关联人担任职务
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,islisted -- 是否上市公司
            ,updatedate -- 更新日期
            ,introduction -- 简历
            ,holdrate -- 股东持股比率
            ,updateuserid -- 更新员工编号
            ,relname -- 关联人名称
            ,enddate -- 持股截止日期
            ,inputorgid -- 新增机构编号
            ,compcode -- 公司代码
            ,updateorgid -- 更新机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relationship -- 关联人类型:dongs-0董事长、dongs-1董事、hangs-0行长、gudong-0股东
    ,o.relpost -- wind关联人担任职务
    ,o.migtflag -- 
    ,o.inputdate -- 新增日期
    ,o.inputuserid -- 新增员工编号
    ,o.islisted -- 是否上市公司
    ,o.updatedate -- 更新日期
    ,o.introduction -- 简历
    ,o.holdrate -- 股东持股比率
    ,o.updateuserid -- 更新员工编号
    ,o.relname -- 关联人名称
    ,o.enddate -- 持股截止日期
    ,o.inputorgid -- 新增机构编号
    ,o.compcode -- 公司代码
    ,o.updateorgid -- 更新机构编号
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
from ${iol_schema}.icms_wind_cust_relative_bk o
    left join ${iol_schema}.icms_wind_cust_relative_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wind_cust_relative_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wind_cust_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wind_cust_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wind_cust_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wind_cust_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wind_cust_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_wind_cust_relative_cl;
alter table ${iol_schema}.icms_wind_cust_relative exchange partition p_20991231 with table ${iol_schema}.icms_wind_cust_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wind_cust_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_relative_op purge;
drop table ${iol_schema}.icms_wind_cust_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wind_cust_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wind_cust_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
