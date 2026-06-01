/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dsvp_seal_papercard
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
create table ${iol_schema}.dsvp_seal_papercard_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.dsvp_seal_papercard
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dsvp_seal_papercard_op purge;
drop table ${iol_schema}.dsvp_seal_papercard_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_seal_papercard_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dsvp_seal_papercard where 0=1;

create table ${iol_schema}.dsvp_seal_papercard_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dsvp_seal_papercard where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dsvp_seal_papercard_cl(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,innercardno -- 印鉴卡号
            ,sealsfront -- 正面
            ,sealsback -- 反面
            ,serno -- 序号
            ,picname -- 图像名称
            ,picpath -- 图像路径
            ,isfront -- 正面标识（0-否，1-是）
            ,dpi -- 分辨率
            ,barcode -- 机构编号
            ,imagetype -- 图像类型（0-正卡，1-副卡）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dsvp_seal_papercard_op(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,innercardno -- 印鉴卡号
            ,sealsfront -- 正面
            ,sealsback -- 反面
            ,serno -- 序号
            ,picname -- 图像名称
            ,picpath -- 图像路径
            ,isfront -- 正面标识（0-否，1-是）
            ,dpi -- 分辨率
            ,barcode -- 机构编号
            ,imagetype -- 图像类型（0-正卡，1-副卡）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dbserno, o.dbserno) as dbserno -- 编号
    ,nvl(n.accountno, o.accountno) as accountno -- 账号
    ,nvl(n.sealcardno, o.sealcardno) as sealcardno -- 印鉴卡序号
    ,nvl(n.innercardno, o.innercardno) as innercardno -- 印鉴卡号
    ,nvl(n.sealsfront, o.sealsfront) as sealsfront -- 正面
    ,nvl(n.sealsback, o.sealsback) as sealsback -- 反面
    ,nvl(n.serno, o.serno) as serno -- 序号
    ,nvl(n.picname, o.picname) as picname -- 图像名称
    ,nvl(n.picpath, o.picpath) as picpath -- 图像路径
    ,nvl(n.isfront, o.isfront) as isfront -- 正面标识（0-否，1-是）
    ,nvl(n.dpi, o.dpi) as dpi -- 分辨率
    ,nvl(n.barcode, o.barcode) as barcode -- 机构编号
    ,nvl(n.imagetype, o.imagetype) as imagetype -- 图像类型（0-正卡，1-副卡）
    ,case when
            n.accountno is null
            and n.sealcardno is null
            and n.innercardno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accountno is null
            and n.sealcardno is null
            and n.innercardno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accountno is null
            and n.sealcardno is null
            and n.innercardno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.dsvp_seal_papercard_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.dsvp_seal_papercard where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accountno = n.accountno
            and o.sealcardno = n.sealcardno
            and o.innercardno = n.innercardno
where (
        o.accountno is null
        and o.sealcardno is null
        and o.innercardno is null
    )
    or (
        n.accountno is null
        and n.sealcardno is null
        and n.innercardno is null
    )
    or (
        o.dbserno <> n.dbserno
        or o.sealsfront <> n.sealsfront
        or o.sealsback <> n.sealsback
        or o.serno <> n.serno
        or o.picname <> n.picname
        or o.picpath <> n.picpath
        or o.isfront <> n.isfront
        or o.dpi <> n.dpi
        or o.barcode <> n.barcode
        or o.imagetype <> n.imagetype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dsvp_seal_papercard_cl(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,innercardno -- 印鉴卡号
            ,sealsfront -- 正面
            ,sealsback -- 反面
            ,serno -- 序号
            ,picname -- 图像名称
            ,picpath -- 图像路径
            ,isfront -- 正面标识（0-否，1-是）
            ,dpi -- 分辨率
            ,barcode -- 机构编号
            ,imagetype -- 图像类型（0-正卡，1-副卡）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dsvp_seal_papercard_op(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,innercardno -- 印鉴卡号
            ,sealsfront -- 正面
            ,sealsback -- 反面
            ,serno -- 序号
            ,picname -- 图像名称
            ,picpath -- 图像路径
            ,isfront -- 正面标识（0-否，1-是）
            ,dpi -- 分辨率
            ,barcode -- 机构编号
            ,imagetype -- 图像类型（0-正卡，1-副卡）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dbserno -- 编号
    ,o.accountno -- 账号
    ,o.sealcardno -- 印鉴卡序号
    ,o.innercardno -- 印鉴卡号
    ,o.sealsfront -- 正面
    ,o.sealsback -- 反面
    ,o.serno -- 序号
    ,o.picname -- 图像名称
    ,o.picpath -- 图像路径
    ,o.isfront -- 正面标识（0-否，1-是）
    ,o.dpi -- 分辨率
    ,o.barcode -- 机构编号
    ,o.imagetype -- 图像类型（0-正卡，1-副卡）
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
from ${iol_schema}.dsvp_seal_papercard_bk o
    left join ${iol_schema}.dsvp_seal_papercard_op n
        on
            o.accountno = n.accountno
            and o.sealcardno = n.sealcardno
            and o.innercardno = n.innercardno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.dsvp_seal_papercard_cl d
        on
            o.accountno = d.accountno
            and o.sealcardno = d.sealcardno
            and o.innercardno = d.innercardno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.dsvp_seal_papercard;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('dsvp_seal_papercard') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.dsvp_seal_papercard drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.dsvp_seal_papercard add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.dsvp_seal_papercard exchange partition p_${batch_date} with table ${iol_schema}.dsvp_seal_papercard_cl;
alter table ${iol_schema}.dsvp_seal_papercard exchange partition p_20991231 with table ${iol_schema}.dsvp_seal_papercard_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dsvp_seal_papercard to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dsvp_seal_papercard_op purge;
drop table ${iol_schema}.dsvp_seal_papercard_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.dsvp_seal_papercard_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dsvp_seal_papercard',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
