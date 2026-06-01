/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_qywfwzxx
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
create table ${iol_schema}.icms_sxd_company_qywfwzxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_qywfwzxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx_op purge;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_qywfwzxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_qywfwzxx where 0=1;

create table ${iol_schema}.icms_sxd_company_qywfwzxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_qywfwzxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_qywfwzxx_cl(
            id -- 主键
            ,xgzt -- 限改状态
            ,wfwzlxdm -- 违法违章类型代码
            ,wfwzztmc -- 违法违章状态
            ,zywfwzsddm -- 违法违章手段代码
            ,zywfwzss -- 违法违章事实
            ,serno -- 业务流水号
            ,larq -- 立案日期
            ,migtflag -- 
            ,djrq -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_qywfwzxx_op(
            id -- 主键
            ,xgzt -- 限改状态
            ,wfwzlxdm -- 违法违章类型代码
            ,wfwzztmc -- 违法违章状态
            ,zywfwzsddm -- 违法违章手段代码
            ,zywfwzss -- 违法违章事实
            ,serno -- 业务流水号
            ,larq -- 立案日期
            ,migtflag -- 
            ,djrq -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.xgzt, o.xgzt) as xgzt -- 限改状态
    ,nvl(n.wfwzlxdm, o.wfwzlxdm) as wfwzlxdm -- 违法违章类型代码
    ,nvl(n.wfwzztmc, o.wfwzztmc) as wfwzztmc -- 违法违章状态
    ,nvl(n.zywfwzsddm, o.zywfwzsddm) as zywfwzsddm -- 违法违章手段代码
    ,nvl(n.zywfwzss, o.zywfwzss) as zywfwzss -- 违法违章事实
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.larq, o.larq) as larq -- 立案日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.djrq, o.djrq) as djrq -- 登记日期
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
from (select * from ${iol_schema}.icms_sxd_company_qywfwzxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_qywfwzxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.xgzt <> n.xgzt
        or o.wfwzlxdm <> n.wfwzlxdm
        or o.wfwzztmc <> n.wfwzztmc
        or o.zywfwzsddm <> n.zywfwzsddm
        or o.zywfwzss <> n.zywfwzss
        or o.serno <> n.serno
        or o.larq <> n.larq
        or o.migtflag <> n.migtflag
        or o.djrq <> n.djrq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_qywfwzxx_cl(
            id -- 主键
            ,xgzt -- 限改状态
            ,wfwzlxdm -- 违法违章类型代码
            ,wfwzztmc -- 违法违章状态
            ,zywfwzsddm -- 违法违章手段代码
            ,zywfwzss -- 违法违章事实
            ,serno -- 业务流水号
            ,larq -- 立案日期
            ,migtflag -- 
            ,djrq -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_qywfwzxx_op(
            id -- 主键
            ,xgzt -- 限改状态
            ,wfwzlxdm -- 违法违章类型代码
            ,wfwzztmc -- 违法违章状态
            ,zywfwzsddm -- 违法违章手段代码
            ,zywfwzss -- 违法违章事实
            ,serno -- 业务流水号
            ,larq -- 立案日期
            ,migtflag -- 
            ,djrq -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.xgzt -- 限改状态
    ,o.wfwzlxdm -- 违法违章类型代码
    ,o.wfwzztmc -- 违法违章状态
    ,o.zywfwzsddm -- 违法违章手段代码
    ,o.zywfwzss -- 违法违章事实
    ,o.serno -- 业务流水号
    ,o.larq -- 立案日期
    ,o.migtflag -- 
    ,o.djrq -- 登记日期
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
from ${iol_schema}.icms_sxd_company_qywfwzxx_bk o
    left join ${iol_schema}.icms_sxd_company_qywfwzxx_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_qywfwzxx_cl d
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
--truncate table ${iol_schema}.icms_sxd_company_qywfwzxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_qywfwzxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_qywfwzxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_qywfwzxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_qywfwzxx exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_qywfwzxx_cl;
alter table ${iol_schema}.icms_sxd_company_qywfwzxx exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_qywfwzxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_qywfwzxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx_op purge;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_qywfwzxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_qywfwzxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
