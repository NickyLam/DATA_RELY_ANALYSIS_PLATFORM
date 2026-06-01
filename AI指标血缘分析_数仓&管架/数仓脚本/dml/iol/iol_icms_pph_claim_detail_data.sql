/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_pph_claim_detail_data
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
create table ${iol_schema}.icms_pph_claim_detail_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_pph_claim_detail_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_claim_detail_data_op purge;
drop table ${iol_schema}.icms_pph_claim_detail_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_claim_detail_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_claim_detail_data where 0=1;

create table ${iol_schema}.icms_pph_claim_detail_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_claim_detail_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_claim_detail_data_cl(
            serialno -- 借据号
            ,inputdate -- 录入日期
            ,tradedate -- 理赔日期
            ,status -- 理赔处理标识1：成功，0：失败
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tradeamt -- 应理赔金额
            ,screditclaimamt -- 借据余额（尚欠本金）
            ,compid -- 产品编号
            ,bankclaimamt -- 实际理赔金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_claim_detail_data_op(
            serialno -- 借据号
            ,inputdate -- 录入日期
            ,tradedate -- 理赔日期
            ,status -- 理赔处理标识1：成功，0：失败
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tradeamt -- 应理赔金额
            ,screditclaimamt -- 借据余额（尚欠本金）
            ,compid -- 产品编号
            ,bankclaimamt -- 实际理赔金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 理赔日期
    ,nvl(n.status, o.status) as status -- 理赔处理标识1：成功，0：失败
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.tradeamt, o.tradeamt) as tradeamt -- 应理赔金额
    ,nvl(n.screditclaimamt, o.screditclaimamt) as screditclaimamt -- 借据余额（尚欠本金）
    ,nvl(n.compid, o.compid) as compid -- 产品编号
    ,nvl(n.bankclaimamt, o.bankclaimamt) as bankclaimamt -- 实际理赔金额
    ,case when
            n.serialno is null
            and n.inputdate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.inputdate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.inputdate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_pph_claim_detail_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_pph_claim_detail_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.inputdate = n.inputdate
where (
        o.serialno is null
        and o.inputdate is null
    )
    or (
        n.serialno is null
        and n.inputdate is null
    )
    or (
        o.tradedate <> n.tradedate
        or o.status <> n.status
        or o.migtflag <> n.migtflag
        or o.tradeamt <> n.tradeamt
        or o.screditclaimamt <> n.screditclaimamt
        or o.compid <> n.compid
        or o.bankclaimamt <> n.bankclaimamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_claim_detail_data_cl(
            serialno -- 借据号
            ,inputdate -- 录入日期
            ,tradedate -- 理赔日期
            ,status -- 理赔处理标识1：成功，0：失败
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tradeamt -- 应理赔金额
            ,screditclaimamt -- 借据余额（尚欠本金）
            ,compid -- 产品编号
            ,bankclaimamt -- 实际理赔金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_claim_detail_data_op(
            serialno -- 借据号
            ,inputdate -- 录入日期
            ,tradedate -- 理赔日期
            ,status -- 理赔处理标识1：成功，0：失败
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tradeamt -- 应理赔金额
            ,screditclaimamt -- 借据余额（尚欠本金）
            ,compid -- 产品编号
            ,bankclaimamt -- 实际理赔金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据号
    ,o.inputdate -- 录入日期
    ,o.tradedate -- 理赔日期
    ,o.status -- 理赔处理标识1：成功，0：失败
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.tradeamt -- 应理赔金额
    ,o.screditclaimamt -- 借据余额（尚欠本金）
    ,o.compid -- 产品编号
    ,o.bankclaimamt -- 实际理赔金额
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
from ${iol_schema}.icms_pph_claim_detail_data_bk o
    left join ${iol_schema}.icms_pph_claim_detail_data_op n
        on
            o.serialno = n.serialno
            and o.inputdate = n.inputdate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_pph_claim_detail_data_cl d
        on
            o.serialno = d.serialno
            and o.inputdate = d.inputdate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_pph_claim_detail_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_pph_claim_detail_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_pph_claim_detail_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_pph_claim_detail_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_pph_claim_detail_data exchange partition p_${batch_date} with table ${iol_schema}.icms_pph_claim_detail_data_cl;
alter table ${iol_schema}.icms_pph_claim_detail_data exchange partition p_20991231 with table ${iol_schema}.icms_pph_claim_detail_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_pph_claim_detail_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_claim_detail_data_op purge;
drop table ${iol_schema}.icms_pph_claim_detail_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_pph_claim_detail_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_pph_claim_detail_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
