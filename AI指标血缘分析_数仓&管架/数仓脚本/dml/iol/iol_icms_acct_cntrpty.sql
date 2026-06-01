/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_cntrpty
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
create table ${iol_schema}.icms_acct_cntrpty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_acct_cntrpty
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_cntrpty_op purge;
drop table ${iol_schema}.icms_acct_cntrpty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_cntrpty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_cntrpty where 0=1;

create table ${iol_schema}.icms_acct_cntrpty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_cntrpty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_cntrpty_cl(
            serialno -- 流水号
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,hangseqno -- 挂账编号
            ,cntrptyname -- 交易对手名称
            ,othrealbaseacctno -- 交易对手账号
            ,contrabankcode -- 交易对手行号
            ,contrabankname -- 交易对手行名称
            ,tranamt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_cntrpty_op(
            serialno -- 流水号
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,hangseqno -- 挂账编号
            ,cntrptyname -- 交易对手名称
            ,othrealbaseacctno -- 交易对手账号
            ,contrabankcode -- 交易对手行号
            ,contrabankname -- 交易对手行名称
            ,tranamt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relativeobjecttype, o.relativeobjecttype) as relativeobjecttype -- 关联对象类型
    ,nvl(n.relativeobjectno, o.relativeobjectno) as relativeobjectno -- 关联对象编号
    ,nvl(n.hangseqno, o.hangseqno) as hangseqno -- 挂账编号
    ,nvl(n.cntrptyname, o.cntrptyname) as cntrptyname -- 交易对手名称
    ,nvl(n.othrealbaseacctno, o.othrealbaseacctno) as othrealbaseacctno -- 交易对手账号
    ,nvl(n.contrabankcode, o.contrabankcode) as contrabankcode -- 交易对手行号
    ,nvl(n.contrabankname, o.contrabankname) as contrabankname -- 交易对手行名称
    ,nvl(n.tranamt, o.tranamt) as tranamt -- 交易金额
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
from (select * from ${iol_schema}.icms_acct_cntrpty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_acct_cntrpty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeobjecttype <> n.relativeobjecttype
        or o.relativeobjectno <> n.relativeobjectno
        or o.hangseqno <> n.hangseqno
        or o.cntrptyname <> n.cntrptyname
        or o.othrealbaseacctno <> n.othrealbaseacctno
        or o.contrabankcode <> n.contrabankcode
        or o.contrabankname <> n.contrabankname
        or o.tranamt <> n.tranamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_cntrpty_cl(
            serialno -- 流水号
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,hangseqno -- 挂账编号
            ,cntrptyname -- 交易对手名称
            ,othrealbaseacctno -- 交易对手账号
            ,contrabankcode -- 交易对手行号
            ,contrabankname -- 交易对手行名称
            ,tranamt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_cntrpty_op(
            serialno -- 流水号
            ,relativeobjecttype -- 关联对象类型
            ,relativeobjectno -- 关联对象编号
            ,hangseqno -- 挂账编号
            ,cntrptyname -- 交易对手名称
            ,othrealbaseacctno -- 交易对手账号
            ,contrabankcode -- 交易对手行号
            ,contrabankname -- 交易对手行名称
            ,tranamt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relativeobjecttype -- 关联对象类型
    ,o.relativeobjectno -- 关联对象编号
    ,o.hangseqno -- 挂账编号
    ,o.cntrptyname -- 交易对手名称
    ,o.othrealbaseacctno -- 交易对手账号
    ,o.contrabankcode -- 交易对手行号
    ,o.contrabankname -- 交易对手行名称
    ,o.tranamt -- 交易金额
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
from ${iol_schema}.icms_acct_cntrpty_bk o
    left join ${iol_schema}.icms_acct_cntrpty_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_acct_cntrpty_cl d
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
--truncate table ${iol_schema}.icms_acct_cntrpty;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_acct_cntrpty') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_acct_cntrpty drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_acct_cntrpty add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_acct_cntrpty exchange partition p_${batch_date} with table ${iol_schema}.icms_acct_cntrpty_cl;
alter table ${iol_schema}.icms_acct_cntrpty exchange partition p_20991231 with table ${iol_schema}.icms_acct_cntrpty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_acct_cntrpty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_cntrpty_op purge;
drop table ${iol_schema}.icms_acct_cntrpty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_acct_cntrpty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_acct_cntrpty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
