/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_otherrate_result
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
create table ${iol_schema}.icms_customer_otherrate_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_otherrate_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_otherrate_result_op purge;
drop table ${iol_schema}.icms_customer_otherrate_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_otherrate_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_otherrate_result where 0=1;

create table ${iol_schema}.icms_customer_otherrate_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_otherrate_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_otherrate_result_cl(
            serialno -- 流水号
            ,customerid -- 客户号
            ,ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
            ,rateenddate -- 评级失效日
            ,updatetime -- 更新时间
            ,rateorg -- 评级机构
            ,ratebegindate -- 评级生效日
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,raterisklevel -- 评级结果
            ,ratedate -- 评级日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_otherrate_result_op(
            serialno -- 流水号
            ,customerid -- 客户号
            ,ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
            ,rateenddate -- 评级失效日
            ,updatetime -- 更新时间
            ,rateorg -- 评级机构
            ,ratebegindate -- 评级生效日
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,raterisklevel -- 评级结果
            ,ratedate -- 评级日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
    ,nvl(n.rateenddate, o.rateenddate) as rateenddate -- 评级失效日
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.rateorg, o.rateorg) as rateorg -- 评级机构
    ,nvl(n.ratebegindate, o.ratebegindate) as ratebegindate -- 评级生效日
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.raterisklevel, o.raterisklevel) as raterisklevel -- 评级结果
    ,nvl(n.ratedate, o.ratedate) as ratedate -- 评级日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
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
from (select * from ${iol_schema}.icms_customer_otherrate_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_otherrate_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.ratetype <> n.ratetype
        or o.rateenddate <> n.rateenddate
        or o.updatetime <> n.updatetime
        or o.rateorg <> n.rateorg
        or o.ratebegindate <> n.ratebegindate
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.raterisklevel <> n.raterisklevel
        or o.ratedate <> n.ratedate
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_otherrate_result_cl(
            serialno -- 流水号
            ,customerid -- 客户号
            ,ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
            ,rateenddate -- 评级失效日
            ,updatetime -- 更新时间
            ,rateorg -- 评级机构
            ,ratebegindate -- 评级生效日
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,raterisklevel -- 评级结果
            ,ratedate -- 评级日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_otherrate_result_op(
            serialno -- 流水号
            ,customerid -- 客户号
            ,ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
            ,rateenddate -- 评级失效日
            ,updatetime -- 更新时间
            ,rateorg -- 评级机构
            ,ratebegindate -- 评级生效日
            ,inputdate -- 登记时间
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,raterisklevel -- 评级结果
            ,ratedate -- 评级日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户号
    ,o.ratetype -- 评级类型（1.外部机构评级、2.监管评级/分类评级）
    ,o.rateenddate -- 评级失效日
    ,o.updatetime -- 更新时间
    ,o.rateorg -- 评级机构
    ,o.ratebegindate -- 评级生效日
    ,o.inputdate -- 登记时间
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.raterisklevel -- 评级结果
    ,o.ratedate -- 评级日期
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
from ${iol_schema}.icms_customer_otherrate_result_bk o
    left join ${iol_schema}.icms_customer_otherrate_result_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_otherrate_result_cl d
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
--truncate table ${iol_schema}.icms_customer_otherrate_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_otherrate_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_otherrate_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_otherrate_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_otherrate_result exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_otherrate_result_cl;
alter table ${iol_schema}.icms_customer_otherrate_result exchange partition p_20991231 with table ${iol_schema}.icms_customer_otherrate_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_otherrate_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_otherrate_result_op purge;
drop table ${iol_schema}.icms_customer_otherrate_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_otherrate_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_otherrate_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
