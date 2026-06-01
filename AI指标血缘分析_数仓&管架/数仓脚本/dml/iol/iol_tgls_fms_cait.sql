/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_fms_cait
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
create table ${iol_schema}.tgls_fms_cait_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_fms_cait
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_fms_cait_op purge;
drop table ${iol_schema}.tgls_fms_cait_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_fms_cait_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_fms_cait where 0=1;

create table ${iol_schema}.tgls_fms_cait_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_fms_cait where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_fms_cait_cl(
            trandt -- 交易日期
            ,transq -- 交易流水
            ,insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
            ,brchno -- 机构编号
            ,crcycd -- 币种
            ,cainam -- 应计提金额
            ,cainbl -- 已计提金额
            ,instam -- 本次计提金额
            ,stacid -- 账套
            ,cntrno -- 合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_fms_cait_op(
            trandt -- 交易日期
            ,transq -- 交易流水
            ,insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
            ,brchno -- 机构编号
            ,crcycd -- 币种
            ,cainam -- 应计提金额
            ,cainbl -- 已计提金额
            ,instam -- 本次计提金额
            ,stacid -- 账套
            ,cntrno -- 合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trandt, o.trandt) as trandt -- 交易日期
    ,nvl(n.transq, o.transq) as transq -- 交易流水
    ,nvl(n.insttp, o.insttp) as insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
    ,nvl(n.brchno, o.brchno) as brchno -- 机构编号
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.cainam, o.cainam) as cainam -- 应计提金额
    ,nvl(n.cainbl, o.cainbl) as cainbl -- 已计提金额
    ,nvl(n.instam, o.instam) as instam -- 本次计提金额
    ,nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.cntrno, o.cntrno) as cntrno -- 合同编号
    ,case when
            n.trandt is null
            and n.transq is null
            and n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trandt is null
            and n.transq is null
            and n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trandt is null
            and n.transq is null
            and n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_fms_cait_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_fms_cait where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trandt = n.trandt
            and o.transq = n.transq
            and o.stacid = n.stacid
where (
        o.trandt is null
        and o.transq is null
        and o.stacid is null
    )
    or (
        n.trandt is null
        and n.transq is null
        and n.stacid is null
    )
    or (
        o.insttp <> n.insttp
        or o.brchno <> n.brchno
        or o.crcycd <> n.crcycd
        or o.cainam <> n.cainam
        or o.cainbl <> n.cainbl
        or o.instam <> n.instam
        or o.cntrno <> n.cntrno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_fms_cait_cl(
            trandt -- 交易日期
            ,transq -- 交易流水
            ,insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
            ,brchno -- 机构编号
            ,crcycd -- 币种
            ,cainam -- 应计提金额
            ,cainbl -- 已计提金额
            ,instam -- 本次计提金额
            ,stacid -- 账套
            ,cntrno -- 合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_fms_cait_op(
            trandt -- 交易日期
            ,transq -- 交易流水
            ,insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
            ,brchno -- 机构编号
            ,crcycd -- 币种
            ,cainam -- 应计提金额
            ,cainbl -- 已计提金额
            ,instam -- 本次计提金额
            ,stacid -- 账套
            ,cntrno -- 合同编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trandt -- 交易日期
    ,o.transq -- 交易流水
    ,o.insttp -- 利息类型(1-上存2-下借3-备付金4-准备金)
    ,o.brchno -- 机构编号
    ,o.crcycd -- 币种
    ,o.cainam -- 应计提金额
    ,o.cainbl -- 已计提金额
    ,o.instam -- 本次计提金额
    ,o.stacid -- 账套
    ,o.cntrno -- 合同编号
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
from ${iol_schema}.tgls_fms_cait_bk o
    left join ${iol_schema}.tgls_fms_cait_op n
        on
            o.trandt = n.trandt
            and o.transq = n.transq
            and o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_fms_cait_cl d
        on
            o.trandt = d.trandt
            and o.transq = d.transq
            and o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_fms_cait;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_fms_cait') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_fms_cait drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_fms_cait add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_fms_cait exchange partition p_${batch_date} with table ${iol_schema}.tgls_fms_cait_cl;
alter table ${iol_schema}.tgls_fms_cait exchange partition p_20991231 with table ${iol_schema}.tgls_fms_cait_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_fms_cait to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_fms_cait_op purge;
drop table ${iol_schema}.tgls_fms_cait_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_fms_cait_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_fms_cait',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
