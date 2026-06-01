/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubsmallamtlimit
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
create table ${iol_schema}.mpcs_a51ubsmallamtlimit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a51ubsmallamtlimit;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit_op purge;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubsmallamtlimit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubsmallamtlimit where 0=1;

create table ${iol_schema}.mpcs_a51ubsmallamtlimit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubsmallamtlimit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51ubsmallamtlimit_cl(
            acctno -- 账号
            ,ifpwd -- 小额免密标识 0-免密 1-验密
            ,systrace -- 交易流水
            ,chnlid -- 渠道编码
            ,brchno -- 机构
            ,opid -- 操作柜员
            ,quotamt -- 单笔限额
            ,dayamt -- 单日累计限额
            ,updtime -- 操作时间
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51ubsmallamtlimit_op(
            acctno -- 账号
            ,ifpwd -- 小额免密标识 0-免密 1-验密
            ,systrace -- 交易流水
            ,chnlid -- 渠道编码
            ,brchno -- 机构
            ,opid -- 操作柜员
            ,quotamt -- 单笔限额
            ,dayamt -- 单日累计限额
            ,updtime -- 操作时间
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acctno, o.acctno) as acctno -- 账号
    ,nvl(n.ifpwd, o.ifpwd) as ifpwd -- 小额免密标识 0-免密 1-验密
    ,nvl(n.systrace, o.systrace) as systrace -- 交易流水
    ,nvl(n.chnlid, o.chnlid) as chnlid -- 渠道编码
    ,nvl(n.brchno, o.brchno) as brchno -- 机构
    ,nvl(n.opid, o.opid) as opid -- 操作柜员
    ,nvl(n.quotamt, o.quotamt) as quotamt -- 单笔限额
    ,nvl(n.dayamt, o.dayamt) as dayamt -- 单日累计限额
    ,nvl(n.updtime, o.updtime) as updtime -- 操作时间
    ,nvl(n.remark1, o.remark1) as remark1 -- 
    ,nvl(n.remark2, o.remark2) as remark2 -- 
    ,nvl(n.remark3, o.remark3) as remark3 -- 
    ,nvl(n.remark4, o.remark4) as remark4 -- 
    ,case when
            n.acctno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acctno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acctno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a51ubsmallamtlimit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a51ubsmallamtlimit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acctno = n.acctno
where (
        o.acctno is null
    )
    or (
        n.acctno is null
    )
    or (
        o.ifpwd <> n.ifpwd
        or o.systrace <> n.systrace
        or o.chnlid <> n.chnlid
        or o.brchno <> n.brchno
        or o.opid <> n.opid
        or o.quotamt <> n.quotamt
        or o.dayamt <> n.dayamt
        or o.updtime <> n.updtime
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51ubsmallamtlimit_cl(
            acctno -- 账号
            ,ifpwd -- 小额免密标识 0-免密 1-验密
            ,systrace -- 交易流水
            ,chnlid -- 渠道编码
            ,brchno -- 机构
            ,opid -- 操作柜员
            ,quotamt -- 单笔限额
            ,dayamt -- 单日累计限额
            ,updtime -- 操作时间
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51ubsmallamtlimit_op(
            acctno -- 账号
            ,ifpwd -- 小额免密标识 0-免密 1-验密
            ,systrace -- 交易流水
            ,chnlid -- 渠道编码
            ,brchno -- 机构
            ,opid -- 操作柜员
            ,quotamt -- 单笔限额
            ,dayamt -- 单日累计限额
            ,updtime -- 操作时间
            ,remark1 -- 
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acctno -- 账号
    ,o.ifpwd -- 小额免密标识 0-免密 1-验密
    ,o.systrace -- 交易流水
    ,o.chnlid -- 渠道编码
    ,o.brchno -- 机构
    ,o.opid -- 操作柜员
    ,o.quotamt -- 单笔限额
    ,o.dayamt -- 单日累计限额
    ,o.updtime -- 操作时间
    ,o.remark1 -- 
    ,o.remark2 -- 
    ,o.remark3 -- 
    ,o.remark4 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a51ubsmallamtlimit_bk o
    left join ${iol_schema}.mpcs_a51ubsmallamtlimit_op n
        on
            o.acctno = n.acctno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a51ubsmallamtlimit_cl d
        on
            o.acctno = d.acctno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a51ubsmallamtlimit;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a51ubsmallamtlimit exchange partition p_19000101 with table ${iol_schema}.mpcs_a51ubsmallamtlimit_cl;
alter table ${iol_schema}.mpcs_a51ubsmallamtlimit exchange partition p_20991231 with table ${iol_schema}.mpcs_a51ubsmallamtlimit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubsmallamtlimit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit_op purge;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a51ubsmallamtlimit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubsmallamtlimit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
