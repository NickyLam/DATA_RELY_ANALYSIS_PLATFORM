/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_costinfo
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
create table ${iol_schema}.icms_ind_costinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_costinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_costinfo_op purge;
drop table ${iol_schema}.icms_ind_costinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_costinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_costinfo where 0=1;

create table ${iol_schema}.icms_ind_costinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_costinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_costinfo_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,inputdate -- 输入日期
            ,feebilltype -- 水电单据类型
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,feebilldate -- 水电单据日期
            ,updatedate -- 更新日期
            ,num -- 水电数量
            ,inputuserid -- 申请客户编号
            ,inputorgid -- 申请机构
            ,customername -- 客户名称
            ,sum -- 水电总量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_costinfo_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,inputdate -- 输入日期
            ,feebilltype -- 水电单据类型
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,feebilldate -- 水电单据日期
            ,updatedate -- 更新日期
            ,num -- 水电数量
            ,inputuserid -- 申请客户编号
            ,inputorgid -- 申请机构
            ,customername -- 客户名称
            ,sum -- 水电总量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 输入日期
    ,nvl(n.feebilltype, o.feebilltype) as feebilltype -- 水电单据类型
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.feebilldate, o.feebilldate) as feebilldate -- 水电单据日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.num, o.num) as num -- 水电数量
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 申请客户编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 申请机构
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.sum, o.sum) as sum -- 水电总量
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
from (select * from ${iol_schema}.icms_ind_costinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_costinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.inputdate <> n.inputdate
        or o.feebilltype <> n.feebilltype
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.feebilldate <> n.feebilldate
        or o.updatedate <> n.updatedate
        or o.num <> n.num
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.customername <> n.customername
        or o.sum <> n.sum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_costinfo_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,inputdate -- 输入日期
            ,feebilltype -- 水电单据类型
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,feebilldate -- 水电单据日期
            ,updatedate -- 更新日期
            ,num -- 水电数量
            ,inputuserid -- 申请客户编号
            ,inputorgid -- 申请机构
            ,customername -- 客户名称
            ,sum -- 水电总量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_costinfo_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,inputdate -- 输入日期
            ,feebilltype -- 水电单据类型
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,feebilldate -- 水电单据日期
            ,updatedate -- 更新日期
            ,num -- 水电数量
            ,inputuserid -- 申请客户编号
            ,inputorgid -- 申请机构
            ,customername -- 客户名称
            ,sum -- 水电总量
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户编号
    ,o.inputdate -- 输入日期
    ,o.feebilltype -- 水电单据类型
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.feebilldate -- 水电单据日期
    ,o.updatedate -- 更新日期
    ,o.num -- 水电数量
    ,o.inputuserid -- 申请客户编号
    ,o.inputorgid -- 申请机构
    ,o.customername -- 客户名称
    ,o.sum -- 水电总量
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
from ${iol_schema}.icms_ind_costinfo_bk o
    left join ${iol_schema}.icms_ind_costinfo_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_costinfo_cl d
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
--truncate table ${iol_schema}.icms_ind_costinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_costinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_costinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_costinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_costinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_costinfo_cl;
alter table ${iol_schema}.icms_ind_costinfo exchange partition p_20991231 with table ${iol_schema}.icms_ind_costinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_costinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_costinfo_op purge;
drop table ${iol_schema}.icms_ind_costinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_costinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_costinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
