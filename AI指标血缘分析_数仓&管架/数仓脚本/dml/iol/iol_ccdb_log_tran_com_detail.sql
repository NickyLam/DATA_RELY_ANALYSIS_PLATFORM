/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccdb_log_tran_com_detail
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
whenever sqlerror continue none ;
create table ${iol_schema}.ccdb_log_tran_com_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccdb_log_tran_com_detail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_detail_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_tran_com_detail_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com_detail where 0=1;

create table ${iol_schema}.ccdb_log_tran_com_detail_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ccdb_log_tran_com_detail where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ccdb_log_tran_com_detail_op(
        code -- 流水号
        ,tran_type -- 报文类型（i内部请求 o对外报文）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,chanel -- 渠道
        ,return_code -- 返回码
        ,return_message -- 返回值
        ,request -- 请求报文
        ,response -- 返回报文
        ,glob_seq_num -- esb流水号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.code -- 流水号
    ,n.tran_type -- 报文类型（i内部请求 o对外报文）
    ,n.tran_code -- 交易码
    ,n.trans_date -- 交易时间
    ,n.chanel -- 渠道
    ,n.return_code -- 返回码
    ,n.return_message -- 返回值
    ,n.request -- 请求报文
    ,n.response -- 返回报文
    ,n.glob_seq_num -- esb流水号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccdb_log_tran_com_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.ccdb_log_tran_com_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.code = n.code
where (
        o.code is null
    )
    or (
        o.tran_type <> n.tran_type
        or o.tran_code <> n.tran_code
        or o.trans_date <> n.trans_date
        or o.chanel <> n.chanel
        or o.return_code <> n.return_code
        or o.return_message <> n.return_message
        or o.request <> n.request
        or o.response <> n.response
        or o.glob_seq_num <> n.glob_seq_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccdb_log_tran_com_detail_cl(
            code -- 流水号
        ,tran_type -- 报文类型（i内部请求 o对外报文）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,chanel -- 渠道
        ,return_code -- 返回码
        ,return_message -- 返回值
        ,request -- 请求报文
        ,response -- 返回报文
        ,glob_seq_num -- esb流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccdb_log_tran_com_detail_op(
            code -- 流水号
        ,tran_type -- 报文类型（i内部请求 o对外报文）
        ,tran_code -- 交易码
        ,trans_date -- 交易时间
        ,chanel -- 渠道
        ,return_code -- 返回码
        ,return_message -- 返回值
        ,request -- 请求报文
        ,response -- 返回报文
        ,glob_seq_num -- esb流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.code -- 流水号
    ,o.tran_type -- 报文类型（i内部请求 o对外报文）
    ,o.tran_code -- 交易码
    ,o.trans_date -- 交易时间
    ,o.chanel -- 渠道
    ,o.return_code -- 返回码
    ,o.return_message -- 返回值
    ,o.request -- 请求报文
    ,o.response -- 返回报文
    ,o.glob_seq_num -- esb流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ccdb_log_tran_com_detail_bk o
    left join ${iol_schema}.ccdb_log_tran_com_detail_op n
        on
            o.code = n.code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccdb_log_tran_com_detail;

-- 4.2 exchange partition
alter table ${iol_schema}.ccdb_log_tran_com_detail exchange partition p_19000101 with table ${iol_schema}.ccdb_log_tran_com_detail_cl;
alter table ${iol_schema}.ccdb_log_tran_com_detail exchange partition p_20991231 with table ${iol_schema}.ccdb_log_tran_com_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccdb_log_tran_com_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccdb_log_tran_com_detail_op purge;
drop table ${iol_schema}.ccdb_log_tran_com_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccdb_log_tran_com_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccdb_log_tran_com_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
