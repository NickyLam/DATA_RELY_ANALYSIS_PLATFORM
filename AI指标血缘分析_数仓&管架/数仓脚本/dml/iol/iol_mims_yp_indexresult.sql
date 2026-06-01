/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_yp_indexresult
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
create table ${iol_schema}.mims_yp_indexresult_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_yp_indexresult
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_indexresult_op purge;
drop table ${iol_schema}.mims_yp_indexresult_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_indexresult_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_indexresult where 0=1;

create table ${iol_schema}.mims_yp_indexresult_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_yp_indexresult where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_indexresult_cl(
            datecode -- 期次 YYYY-MM-DD
            ,indextype -- 预警类型 字典INDEXTYPE
            ,objectcode -- 预警对象
            ,indexcode -- 指标编号
            ,indexname -- 指标名称
            ,indexvalue -- 指标值
            ,sccode -- 押品编号
            ,remark1 -- 备用1
            ,remark2 -- 备用2
            ,remark3 -- 备用3
            ,remark4 -- 备用4
            ,remark5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_indexresult_op(
            datecode -- 期次 YYYY-MM-DD
            ,indextype -- 预警类型 字典INDEXTYPE
            ,objectcode -- 预警对象
            ,indexcode -- 指标编号
            ,indexname -- 指标名称
            ,indexvalue -- 指标值
            ,sccode -- 押品编号
            ,remark1 -- 备用1
            ,remark2 -- 备用2
            ,remark3 -- 备用3
            ,remark4 -- 备用4
            ,remark5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.datecode, o.datecode) as datecode -- 期次 YYYY-MM-DD
    ,nvl(n.indextype, o.indextype) as indextype -- 预警类型 字典INDEXTYPE
    ,nvl(n.objectcode, o.objectcode) as objectcode -- 预警对象
    ,nvl(n.indexcode, o.indexcode) as indexcode -- 指标编号
    ,nvl(n.indexname, o.indexname) as indexname -- 指标名称
    ,nvl(n.indexvalue, o.indexvalue) as indexvalue -- 指标值
    ,nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备用2
    ,nvl(n.remark3, o.remark3) as remark3 -- 备用3
    ,nvl(n.remark4, o.remark4) as remark4 -- 备用4
    ,nvl(n.remark5, o.remark5) as remark5 -- 备用5
    ,case when
            n.datecode is null
            and n.objectcode is null
            and n.indexcode is null
            and n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.datecode is null
            and n.objectcode is null
            and n.indexcode is null
            and n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.datecode is null
            and n.objectcode is null
            and n.indexcode is null
            and n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_yp_indexresult_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_yp_indexresult where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.datecode = n.datecode
            and o.objectcode = n.objectcode
            and o.indexcode = n.indexcode
            and o.sccode = n.sccode
where (
        o.datecode is null
        and o.objectcode is null
        and o.indexcode is null
        and o.sccode is null
    )
    or (
        n.datecode is null
        and n.objectcode is null
        and n.indexcode is null
        and n.sccode is null
    )
    or (
        o.indextype <> n.indextype
        or o.indexname <> n.indexname
        or o.indexvalue <> n.indexvalue
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
        or o.remark5 <> n.remark5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_yp_indexresult_cl(
            datecode -- 期次 YYYY-MM-DD
            ,indextype -- 预警类型 字典INDEXTYPE
            ,objectcode -- 预警对象
            ,indexcode -- 指标编号
            ,indexname -- 指标名称
            ,indexvalue -- 指标值
            ,sccode -- 押品编号
            ,remark1 -- 备用1
            ,remark2 -- 备用2
            ,remark3 -- 备用3
            ,remark4 -- 备用4
            ,remark5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_yp_indexresult_op(
            datecode -- 期次 YYYY-MM-DD
            ,indextype -- 预警类型 字典INDEXTYPE
            ,objectcode -- 预警对象
            ,indexcode -- 指标编号
            ,indexname -- 指标名称
            ,indexvalue -- 指标值
            ,sccode -- 押品编号
            ,remark1 -- 备用1
            ,remark2 -- 备用2
            ,remark3 -- 备用3
            ,remark4 -- 备用4
            ,remark5 -- 备用5
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.datecode -- 期次 YYYY-MM-DD
    ,o.indextype -- 预警类型 字典INDEXTYPE
    ,o.objectcode -- 预警对象
    ,o.indexcode -- 指标编号
    ,o.indexname -- 指标名称
    ,o.indexvalue -- 指标值
    ,o.sccode -- 押品编号
    ,o.remark1 -- 备用1
    ,o.remark2 -- 备用2
    ,o.remark3 -- 备用3
    ,o.remark4 -- 备用4
    ,o.remark5 -- 备用5
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
from ${iol_schema}.mims_yp_indexresult_bk o
    left join ${iol_schema}.mims_yp_indexresult_op n
        on
            o.datecode = n.datecode
            and o.objectcode = n.objectcode
            and o.indexcode = n.indexcode
            and o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_yp_indexresult_cl d
        on
            o.datecode = d.datecode
            and o.objectcode = d.objectcode
            and o.indexcode = d.indexcode
            and o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_yp_indexresult;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_yp_indexresult') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_yp_indexresult drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_yp_indexresult add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_yp_indexresult exchange partition p_${batch_date} with table ${iol_schema}.mims_yp_indexresult_cl;
alter table ${iol_schema}.mims_yp_indexresult exchange partition p_20991231 with table ${iol_schema}.mims_yp_indexresult_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_yp_indexresult to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_yp_indexresult_op purge;
drop table ${iol_schema}.mims_yp_indexresult_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_yp_indexresult_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_yp_indexresult',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
