/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_trans_fft
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
create table ${iol_schema}.icms_acct_trans_fft_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_acct_trans_fft
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_trans_fft_op purge;
drop table ${iol_schema}.icms_acct_trans_fft_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_trans_fft_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_trans_fft where 0=1;

create table ${iol_schema}.icms_acct_trans_fft_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_trans_fft where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_trans_fft_cl(
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_trans_fft_op(
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.counterparty, o.counterparty) as counterparty -- 交易对手
    ,nvl(n.counterpartyid, o.counterpartyid) as counterpartyid -- 交易对手编号
    ,nvl(n.shroffaccount, o.shroffaccount) as shroffaccount -- 收款账号
    ,nvl(n.loannumber, o.loannumber) as loannumber -- 借据笔数
    ,nvl(n.resalegatheramount, o.resalegatheramount) as resalegatheramount -- 转卖收款金额汇总
    ,nvl(n.resaleloanamount, o.resaleloanamount) as resaleloanamount -- 转卖借据金额汇总
    ,nvl(n.transferins, o.transferins) as transferins -- 转让说明
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 暂存标志
    ,nvl(n.fundsourceaccountno, o.fundsourceaccountno) as fundsourceaccountno -- 资金来源账号
    ,nvl(n.fundsourcebankid, o.fundsourcebankid) as fundsourcebankid -- 资金来源行号
    ,nvl(n.fundsourceaccountname, o.fundsourceaccountname) as fundsourceaccountname -- 资金来源户名
    ,nvl(n.fundsourcebankname, o.fundsourcebankname) as fundsourcebankname -- 资金来源行名
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
from (select * from ${iol_schema}.icms_acct_trans_fft_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_acct_trans_fft where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.counterparty <> n.counterparty
        or o.counterpartyid <> n.counterpartyid
        or o.shroffaccount <> n.shroffaccount
        or o.loannumber <> n.loannumber
        or o.resalegatheramount <> n.resalegatheramount
        or o.resaleloanamount <> n.resaleloanamount
        or o.transferins <> n.transferins
        or o.completeflag <> n.completeflag
        or o.fundsourceaccountno <> n.fundsourceaccountno
        or o.fundsourcebankid <> n.fundsourcebankid
        or o.fundsourceaccountname <> n.fundsourceaccountname
        or o.fundsourcebankname <> n.fundsourcebankname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_trans_fft_cl(
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_trans_fft_op(
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.counterparty -- 交易对手
    ,o.counterpartyid -- 交易对手编号
    ,o.shroffaccount -- 收款账号
    ,o.loannumber -- 借据笔数
    ,o.resalegatheramount -- 转卖收款金额汇总
    ,o.resaleloanamount -- 转卖借据金额汇总
    ,o.transferins -- 转让说明
    ,o.completeflag -- 暂存标志
    ,o.fundsourceaccountno -- 资金来源账号
    ,o.fundsourcebankid -- 资金来源行号
    ,o.fundsourceaccountname -- 资金来源户名
    ,o.fundsourcebankname -- 资金来源行名
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
from ${iol_schema}.icms_acct_trans_fft_bk o
    left join ${iol_schema}.icms_acct_trans_fft_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_acct_trans_fft_cl d
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
--truncate table ${iol_schema}.icms_acct_trans_fft;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_acct_trans_fft') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_acct_trans_fft drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_acct_trans_fft add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_acct_trans_fft exchange partition p_${batch_date} with table ${iol_schema}.icms_acct_trans_fft_cl;
alter table ${iol_schema}.icms_acct_trans_fft exchange partition p_20991231 with table ${iol_schema}.icms_acct_trans_fft_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_acct_trans_fft to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_trans_fft_op purge;
drop table ${iol_schema}.icms_acct_trans_fft_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_acct_trans_fft_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_acct_trans_fft',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
