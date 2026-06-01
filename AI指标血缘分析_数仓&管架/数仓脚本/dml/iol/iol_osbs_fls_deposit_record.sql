/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_fls_deposit_record
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
create table ${iol_schema}.osbs_fls_deposit_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_fls_deposit_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_fls_deposit_record_op purge;
drop table ${iol_schema}.osbs_fls_deposit_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_fls_deposit_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_fls_deposit_record where 0=1;

create table ${iol_schema}.osbs_fls_deposit_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_fls_deposit_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_fls_deposit_record_cl(
            fdr_flowno -- 系统流水号
            ,fdr_globalflow -- 全局流水号
            ,fdr_transcode -- 接口码
            ,fdr_transdate -- 交易日期
            ,fdr_transtime -- 交易时间
            ,fdr_ecifno -- 客户号
            ,fdr_prodtype -- 产品类型
            ,fdr_ccy -- 币种
            ,fdr_amount -- 金额
            ,fdr_stagecode -- 大额存单期次
            ,fdr_composeid -- 存款加ID
            ,fdr_status -- 交易状态
            ,fdr_errorcode -- 错误码
            ,fdr_errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_fls_deposit_record_op(
            fdr_flowno -- 系统流水号
            ,fdr_globalflow -- 全局流水号
            ,fdr_transcode -- 接口码
            ,fdr_transdate -- 交易日期
            ,fdr_transtime -- 交易时间
            ,fdr_ecifno -- 客户号
            ,fdr_prodtype -- 产品类型
            ,fdr_ccy -- 币种
            ,fdr_amount -- 金额
            ,fdr_stagecode -- 大额存单期次
            ,fdr_composeid -- 存款加ID
            ,fdr_status -- 交易状态
            ,fdr_errorcode -- 错误码
            ,fdr_errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fdr_flowno, o.fdr_flowno) as fdr_flowno -- 系统流水号
    ,nvl(n.fdr_globalflow, o.fdr_globalflow) as fdr_globalflow -- 全局流水号
    ,nvl(n.fdr_transcode, o.fdr_transcode) as fdr_transcode -- 接口码
    ,nvl(n.fdr_transdate, o.fdr_transdate) as fdr_transdate -- 交易日期
    ,nvl(n.fdr_transtime, o.fdr_transtime) as fdr_transtime -- 交易时间
    ,nvl(n.fdr_ecifno, o.fdr_ecifno) as fdr_ecifno -- 客户号
    ,nvl(n.fdr_prodtype, o.fdr_prodtype) as fdr_prodtype -- 产品类型
    ,nvl(n.fdr_ccy, o.fdr_ccy) as fdr_ccy -- 币种
    ,nvl(n.fdr_amount, o.fdr_amount) as fdr_amount -- 金额
    ,nvl(n.fdr_stagecode, o.fdr_stagecode) as fdr_stagecode -- 大额存单期次
    ,nvl(n.fdr_composeid, o.fdr_composeid) as fdr_composeid -- 存款加ID
    ,nvl(n.fdr_status, o.fdr_status) as fdr_status -- 交易状态
    ,nvl(n.fdr_errorcode, o.fdr_errorcode) as fdr_errorcode -- 错误码
    ,nvl(n.fdr_errormsg, o.fdr_errormsg) as fdr_errormsg -- 错误信息
    ,case when
            n.fdr_flowno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fdr_flowno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fdr_flowno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_fls_deposit_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_fls_deposit_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fdr_flowno = n.fdr_flowno
where (
        o.fdr_flowno is null
    )
    or (
        n.fdr_flowno is null
    )
    or (
        o.fdr_globalflow <> n.fdr_globalflow
        or o.fdr_transcode <> n.fdr_transcode
        or o.fdr_transdate <> n.fdr_transdate
        or o.fdr_transtime <> n.fdr_transtime
        or o.fdr_ecifno <> n.fdr_ecifno
        or o.fdr_prodtype <> n.fdr_prodtype
        or o.fdr_ccy <> n.fdr_ccy
        or o.fdr_amount <> n.fdr_amount
        or o.fdr_stagecode <> n.fdr_stagecode
        or o.fdr_composeid <> n.fdr_composeid
        or o.fdr_status <> n.fdr_status
        or o.fdr_errorcode <> n.fdr_errorcode
        or o.fdr_errormsg <> n.fdr_errormsg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_fls_deposit_record_cl(
            fdr_flowno -- 系统流水号
            ,fdr_globalflow -- 全局流水号
            ,fdr_transcode -- 接口码
            ,fdr_transdate -- 交易日期
            ,fdr_transtime -- 交易时间
            ,fdr_ecifno -- 客户号
            ,fdr_prodtype -- 产品类型
            ,fdr_ccy -- 币种
            ,fdr_amount -- 金额
            ,fdr_stagecode -- 大额存单期次
            ,fdr_composeid -- 存款加ID
            ,fdr_status -- 交易状态
            ,fdr_errorcode -- 错误码
            ,fdr_errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_fls_deposit_record_op(
            fdr_flowno -- 系统流水号
            ,fdr_globalflow -- 全局流水号
            ,fdr_transcode -- 接口码
            ,fdr_transdate -- 交易日期
            ,fdr_transtime -- 交易时间
            ,fdr_ecifno -- 客户号
            ,fdr_prodtype -- 产品类型
            ,fdr_ccy -- 币种
            ,fdr_amount -- 金额
            ,fdr_stagecode -- 大额存单期次
            ,fdr_composeid -- 存款加ID
            ,fdr_status -- 交易状态
            ,fdr_errorcode -- 错误码
            ,fdr_errormsg -- 错误信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fdr_flowno -- 系统流水号
    ,o.fdr_globalflow -- 全局流水号
    ,o.fdr_transcode -- 接口码
    ,o.fdr_transdate -- 交易日期
    ,o.fdr_transtime -- 交易时间
    ,o.fdr_ecifno -- 客户号
    ,o.fdr_prodtype -- 产品类型
    ,o.fdr_ccy -- 币种
    ,o.fdr_amount -- 金额
    ,o.fdr_stagecode -- 大额存单期次
    ,o.fdr_composeid -- 存款加ID
    ,o.fdr_status -- 交易状态
    ,o.fdr_errorcode -- 错误码
    ,o.fdr_errormsg -- 错误信息
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
from ${iol_schema}.osbs_fls_deposit_record_bk o
    left join ${iol_schema}.osbs_fls_deposit_record_op n
        on
            o.fdr_flowno = n.fdr_flowno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_fls_deposit_record_cl d
        on
            o.fdr_flowno = d.fdr_flowno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_fls_deposit_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_fls_deposit_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_fls_deposit_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_fls_deposit_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_fls_deposit_record exchange partition p_${batch_date} with table ${iol_schema}.osbs_fls_deposit_record_cl;
alter table ${iol_schema}.osbs_fls_deposit_record exchange partition p_20991231 with table ${iol_schema}.osbs_fls_deposit_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_fls_deposit_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_fls_deposit_record_op purge;
drop table ${iol_schema}.osbs_fls_deposit_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_fls_deposit_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_fls_deposit_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
