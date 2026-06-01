/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ttrncdmap
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
create table ${iol_schema}.mpcs_a50ttrncdmap_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a50ttrncdmap
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ttrncdmap_op purge;
drop table ${iol_schema}.mpcs_a50ttrncdmap_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ttrncdmap_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ttrncdmap where 0=1;

create table ${iol_schema}.mpcs_a50ttrncdmap_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ttrncdmap where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ttrncdmap_cl(
            chnlid -- 渠道ID
            ,transcode -- 渠道交易码
            ,trncd -- 交易处理码
            ,msgtype -- 消息类型
            ,procecode -- 银联处理码
            ,trnname -- 交易名称
            ,bdbtrncd -- 行内处理码
            ,bdttrncd -- 他行处理码
            ,recordstat -- 记录状态: 1-有效;0-无效
            ,issndrsk -- 是否送风控系统
            ,isfallbk -- 是否禁止降级
            ,isstop -- 是否禁用
            ,memocd -- 默认摘要码
            ,memo -- 摘要码名称
            ,dealtype -- 自助渠道处理方式
            ,transtp -- 核心交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ttrncdmap_op(
            chnlid -- 渠道ID
            ,transcode -- 渠道交易码
            ,trncd -- 交易处理码
            ,msgtype -- 消息类型
            ,procecode -- 银联处理码
            ,trnname -- 交易名称
            ,bdbtrncd -- 行内处理码
            ,bdttrncd -- 他行处理码
            ,recordstat -- 记录状态: 1-有效;0-无效
            ,issndrsk -- 是否送风控系统
            ,isfallbk -- 是否禁止降级
            ,isstop -- 是否禁用
            ,memocd -- 默认摘要码
            ,memo -- 摘要码名称
            ,dealtype -- 自助渠道处理方式
            ,transtp -- 核心交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.chnlid, o.chnlid) as chnlid -- 渠道ID
    ,nvl(n.transcode, o.transcode) as transcode -- 渠道交易码
    ,nvl(n.trncd, o.trncd) as trncd -- 交易处理码
    ,nvl(n.msgtype, o.msgtype) as msgtype -- 消息类型
    ,nvl(n.procecode, o.procecode) as procecode -- 银联处理码
    ,nvl(n.trnname, o.trnname) as trnname -- 交易名称
    ,nvl(n.bdbtrncd, o.bdbtrncd) as bdbtrncd -- 行内处理码
    ,nvl(n.bdttrncd, o.bdttrncd) as bdttrncd -- 他行处理码
    ,nvl(n.recordstat, o.recordstat) as recordstat -- 记录状态: 1-有效;0-无效
    ,nvl(n.issndrsk, o.issndrsk) as issndrsk -- 是否送风控系统
    ,nvl(n.isfallbk, o.isfallbk) as isfallbk -- 是否禁止降级
    ,nvl(n.isstop, o.isstop) as isstop -- 是否禁用
    ,nvl(n.memocd, o.memocd) as memocd -- 默认摘要码
    ,nvl(n.memo, o.memo) as memo -- 摘要码名称
    ,nvl(n.dealtype, o.dealtype) as dealtype -- 自助渠道处理方式
    ,nvl(n.transtp, o.transtp) as transtp -- 核心交易类型
    ,case when
            n.chnlid is null
            and n.transcode is null
            and n.trncd is null
            and n.msgtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.chnlid is null
            and n.transcode is null
            and n.trncd is null
            and n.msgtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.chnlid is null
            and n.transcode is null
            and n.trncd is null
            and n.msgtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a50ttrncdmap_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a50ttrncdmap where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.chnlid = n.chnlid
            and o.transcode = n.transcode
            and o.trncd = n.trncd
            and o.msgtype = n.msgtype
where (
        o.chnlid is null
        and o.transcode is null
        and o.trncd is null
        and o.msgtype is null
    )
    or (
        n.chnlid is null
        and n.transcode is null
        and n.trncd is null
        and n.msgtype is null
    )
    or (
        o.procecode <> n.procecode
        or o.trnname <> n.trnname
        or o.bdbtrncd <> n.bdbtrncd
        or o.bdttrncd <> n.bdttrncd
        or o.recordstat <> n.recordstat
        or o.issndrsk <> n.issndrsk
        or o.isfallbk <> n.isfallbk
        or o.isstop <> n.isstop
        or o.memocd <> n.memocd
        or o.memo <> n.memo
        or o.dealtype <> n.dealtype
        or o.transtp <> n.transtp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ttrncdmap_cl(
            chnlid -- 渠道ID
            ,transcode -- 渠道交易码
            ,trncd -- 交易处理码
            ,msgtype -- 消息类型
            ,procecode -- 银联处理码
            ,trnname -- 交易名称
            ,bdbtrncd -- 行内处理码
            ,bdttrncd -- 他行处理码
            ,recordstat -- 记录状态: 1-有效;0-无效
            ,issndrsk -- 是否送风控系统
            ,isfallbk -- 是否禁止降级
            ,isstop -- 是否禁用
            ,memocd -- 默认摘要码
            ,memo -- 摘要码名称
            ,dealtype -- 自助渠道处理方式
            ,transtp -- 核心交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ttrncdmap_op(
            chnlid -- 渠道ID
            ,transcode -- 渠道交易码
            ,trncd -- 交易处理码
            ,msgtype -- 消息类型
            ,procecode -- 银联处理码
            ,trnname -- 交易名称
            ,bdbtrncd -- 行内处理码
            ,bdttrncd -- 他行处理码
            ,recordstat -- 记录状态: 1-有效;0-无效
            ,issndrsk -- 是否送风控系统
            ,isfallbk -- 是否禁止降级
            ,isstop -- 是否禁用
            ,memocd -- 默认摘要码
            ,memo -- 摘要码名称
            ,dealtype -- 自助渠道处理方式
            ,transtp -- 核心交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.chnlid -- 渠道ID
    ,o.transcode -- 渠道交易码
    ,o.trncd -- 交易处理码
    ,o.msgtype -- 消息类型
    ,o.procecode -- 银联处理码
    ,o.trnname -- 交易名称
    ,o.bdbtrncd -- 行内处理码
    ,o.bdttrncd -- 他行处理码
    ,o.recordstat -- 记录状态: 1-有效;0-无效
    ,o.issndrsk -- 是否送风控系统
    ,o.isfallbk -- 是否禁止降级
    ,o.isstop -- 是否禁用
    ,o.memocd -- 默认摘要码
    ,o.memo -- 摘要码名称
    ,o.dealtype -- 自助渠道处理方式
    ,o.transtp -- 核心交易类型
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
from ${iol_schema}.mpcs_a50ttrncdmap_bk o
    left join ${iol_schema}.mpcs_a50ttrncdmap_op n
        on
            o.chnlid = n.chnlid
            and o.transcode = n.transcode
            and o.trncd = n.trncd
            and o.msgtype = n.msgtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a50ttrncdmap_cl d
        on
            o.chnlid = d.chnlid
            and o.transcode = d.transcode
            and o.trncd = d.trncd
            and o.msgtype = d.msgtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a50ttrncdmap;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a50ttrncdmap') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a50ttrncdmap drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a50ttrncdmap add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a50ttrncdmap exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a50ttrncdmap_cl;
alter table ${iol_schema}.mpcs_a50ttrncdmap exchange partition p_20991231 with table ${iol_schema}.mpcs_a50ttrncdmap_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ttrncdmap to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ttrncdmap_op purge;
drop table ${iol_schema}.mpcs_a50ttrncdmap_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a50ttrncdmap_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ttrncdmap',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
