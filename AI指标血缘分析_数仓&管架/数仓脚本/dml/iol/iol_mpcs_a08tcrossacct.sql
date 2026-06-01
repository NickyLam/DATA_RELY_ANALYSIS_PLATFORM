/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tcrossacct
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
create table ${iol_schema}.mpcs_a08tcrossacct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08tcrossacct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tcrossacct_op purge;
drop table ${iol_schema}.mpcs_a08tcrossacct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tcrossacct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tcrossacct where 0=1;

create table ${iol_schema}.mpcs_a08tcrossacct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tcrossacct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tcrossacct_cl(
            contractnumber -- 协议编号
            ,accountnumber -- 主办企业专用账户
            ,accountname -- 主办企业账户名称
            ,amountlimit -- 净流入额度
            ,amount -- 已使用额度
            ,signdate -- 入库日期
            ,signflag -- 协议状态 0-签约状态；3-取消状态
            ,updt -- 最后修改时间
            ,custno -- 客户号
            ,srcseqno -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tcrossacct_op(
            contractnumber -- 协议编号
            ,accountnumber -- 主办企业专用账户
            ,accountname -- 主办企业账户名称
            ,amountlimit -- 净流入额度
            ,amount -- 已使用额度
            ,signdate -- 入库日期
            ,signflag -- 协议状态 0-签约状态；3-取消状态
            ,updt -- 最后修改时间
            ,custno -- 客户号
            ,srcseqno -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contractnumber, o.contractnumber) as contractnumber -- 协议编号
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 主办企业专用账户
    ,nvl(n.accountname, o.accountname) as accountname -- 主办企业账户名称
    ,nvl(n.amountlimit, o.amountlimit) as amountlimit -- 净流入额度
    ,nvl(n.amount, o.amount) as amount -- 已使用额度
    ,nvl(n.signdate, o.signdate) as signdate -- 入库日期
    ,nvl(n.signflag, o.signflag) as signflag -- 协议状态 0-签约状态；3-取消状态
    ,nvl(n.updt, o.updt) as updt -- 最后修改时间
    ,nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 交易流水号
    ,case when
            n.contractnumber is null
            and n.accountnumber is null
            and n.signflag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contractnumber is null
            and n.accountnumber is null
            and n.signflag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contractnumber is null
            and n.accountnumber is null
            and n.signflag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08tcrossacct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08tcrossacct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractnumber = n.contractnumber
            and o.accountnumber = n.accountnumber
            and o.signflag = n.signflag
where (
        o.contractnumber is null
        and o.accountnumber is null
        and o.signflag is null
    )
    or (
        n.contractnumber is null
        and n.accountnumber is null
        and n.signflag is null
    )
    or (
        o.accountname <> n.accountname
        or o.amountlimit <> n.amountlimit
        or o.amount <> n.amount
        or o.signdate <> n.signdate
        or o.updt <> n.updt
        or o.custno <> n.custno
        or o.srcseqno <> n.srcseqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tcrossacct_cl(
            contractnumber -- 协议编号
            ,accountnumber -- 主办企业专用账户
            ,accountname -- 主办企业账户名称
            ,amountlimit -- 净流入额度
            ,amount -- 已使用额度
            ,signdate -- 入库日期
            ,signflag -- 协议状态 0-签约状态；3-取消状态
            ,updt -- 最后修改时间
            ,custno -- 客户号
            ,srcseqno -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tcrossacct_op(
            contractnumber -- 协议编号
            ,accountnumber -- 主办企业专用账户
            ,accountname -- 主办企业账户名称
            ,amountlimit -- 净流入额度
            ,amount -- 已使用额度
            ,signdate -- 入库日期
            ,signflag -- 协议状态 0-签约状态；3-取消状态
            ,updt -- 最后修改时间
            ,custno -- 客户号
            ,srcseqno -- 交易流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contractnumber -- 协议编号
    ,o.accountnumber -- 主办企业专用账户
    ,o.accountname -- 主办企业账户名称
    ,o.amountlimit -- 净流入额度
    ,o.amount -- 已使用额度
    ,o.signdate -- 入库日期
    ,o.signflag -- 协议状态 0-签约状态；3-取消状态
    ,o.updt -- 最后修改时间
    ,o.custno -- 客户号
    ,o.srcseqno -- 交易流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a08tcrossacct_bk o
    left join ${iol_schema}.mpcs_a08tcrossacct_op n
        on
            o.contractnumber = n.contractnumber
            and o.accountnumber = n.accountnumber
            and o.signflag = n.signflag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08tcrossacct_cl d
        on
            o.contractnumber = d.contractnumber
            and o.accountnumber = d.accountnumber
            and o.signflag = d.signflag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a08tcrossacct;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a08tcrossacct exchange partition p_19000101 with table ${iol_schema}.mpcs_a08tcrossacct_cl;
alter table ${iol_schema}.mpcs_a08tcrossacct exchange partition p_20991231 with table ${iol_schema}.mpcs_a08tcrossacct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tcrossacct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tcrossacct_op purge;
drop table ${iol_schema}.mpcs_a08tcrossacct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08tcrossacct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tcrossacct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
