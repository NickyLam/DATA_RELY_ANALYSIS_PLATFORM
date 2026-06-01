/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_take_rate
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
create table ${iol_schema}.icms_clr_take_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_take_rate
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_take_rate_op purge;
drop table ${iol_schema}.icms_clr_take_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_take_rate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_take_rate where 0=1;

create table ${iol_schema}.icms_clr_take_rate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_take_rate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_take_rate_cl(
            seqno -- 流水号
            ,province -- 省份
            ,city -- 城市
            ,counties -- 县、区
            ,deptcode -- 所属分行
            ,barsign -- 条线
            ,guartype -- 押品类型
            ,procode -- 产品编号
            ,replyno -- 关联编号
            ,guarrate -- 抵质押率
            ,procodename -- 产品名称
            ,reportinfo -- 描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_take_rate_op(
            seqno -- 流水号
            ,province -- 省份
            ,city -- 城市
            ,counties -- 县、区
            ,deptcode -- 所属分行
            ,barsign -- 条线
            ,guartype -- 押品类型
            ,procode -- 产品编号
            ,replyno -- 关联编号
            ,guarrate -- 抵质押率
            ,procodename -- 产品名称
            ,reportinfo -- 描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seqno, o.seqno) as seqno -- 流水号
    ,nvl(n.province, o.province) as province -- 省份
    ,nvl(n.city, o.city) as city -- 城市
    ,nvl(n.counties, o.counties) as counties -- 县、区
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属分行
    ,nvl(n.barsign, o.barsign) as barsign -- 条线
    ,nvl(n.guartype, o.guartype) as guartype -- 押品类型
    ,nvl(n.procode, o.procode) as procode -- 产品编号
    ,nvl(n.replyno, o.replyno) as replyno -- 关联编号
    ,nvl(n.guarrate, o.guarrate) as guarrate -- 抵质押率
    ,nvl(n.procodename, o.procodename) as procodename -- 产品名称
    ,nvl(n.reportinfo, o.reportinfo) as reportinfo -- 描述
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.seqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_take_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_take_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seqno = n.seqno
where (
        o.seqno is null
    )
    or (
        n.seqno is null
    )
    or (
        o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.deptcode <> n.deptcode
        or o.barsign <> n.barsign
        or o.guartype <> n.guartype
        or o.procode <> n.procode
        or o.replyno <> n.replyno
        or o.guarrate <> n.guarrate
        or o.procodename <> n.procodename
        or o.reportinfo <> n.reportinfo
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_take_rate_cl(
            seqno -- 流水号
            ,province -- 省份
            ,city -- 城市
            ,counties -- 县、区
            ,deptcode -- 所属分行
            ,barsign -- 条线
            ,guartype -- 押品类型
            ,procode -- 产品编号
            ,replyno -- 关联编号
            ,guarrate -- 抵质押率
            ,procodename -- 产品名称
            ,reportinfo -- 描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_take_rate_op(
            seqno -- 流水号
            ,province -- 省份
            ,city -- 城市
            ,counties -- 县、区
            ,deptcode -- 所属分行
            ,barsign -- 条线
            ,guartype -- 押品类型
            ,procode -- 产品编号
            ,replyno -- 关联编号
            ,guarrate -- 抵质押率
            ,procodename -- 产品名称
            ,reportinfo -- 描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seqno -- 流水号
    ,o.province -- 省份
    ,o.city -- 城市
    ,o.counties -- 县、区
    ,o.deptcode -- 所属分行
    ,o.barsign -- 条线
    ,o.guartype -- 押品类型
    ,o.procode -- 产品编号
    ,o.replyno -- 关联编号
    ,o.guarrate -- 抵质押率
    ,o.procodename -- 产品名称
    ,o.reportinfo -- 描述
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_take_rate_bk o
    left join ${iol_schema}.icms_clr_take_rate_op n
        on
            o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_take_rate_cl d
        on
            o.seqno = d.seqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_take_rate;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_take_rate') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_take_rate drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_take_rate add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_take_rate exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_take_rate_cl;
alter table ${iol_schema}.icms_clr_take_rate exchange partition p_20991231 with table ${iol_schema}.icms_clr_take_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_take_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_take_rate_op purge;
drop table ${iol_schema}.icms_clr_take_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_take_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_take_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
