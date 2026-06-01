/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_trans_fft_detail
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
create table ${iol_schema}.icms_acct_trans_fft_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_acct_trans_fft_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_trans_fft_detail_op purge;
drop table ${iol_schema}.icms_acct_trans_fft_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_trans_fft_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_trans_fft_detail where 0=1;

create table ${iol_schema}.icms_acct_trans_fft_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_acct_trans_fft_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_trans_fft_detail_cl(
            serialno -- 流水号
            ,objectno -- 主表流水号
            ,bdserialno -- 借据编号
            ,salerate -- 卖出利率
            ,resalegather -- 转卖收款金额
            ,remitcomexpense -- 汇入手续费支出
            ,issuebank -- 开证行
            ,acceptbank -- 承兑行
            ,classofbenetrade -- 信用证受益人行业分类
            ,resalematurity -- 转卖到期日
            ,prepaidamount -- 待摊金额
            ,interbusinessreve -- 中间业务收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_trans_fft_detail_op(
            serialno -- 流水号
            ,objectno -- 主表流水号
            ,bdserialno -- 借据编号
            ,salerate -- 卖出利率
            ,resalegather -- 转卖收款金额
            ,remitcomexpense -- 汇入手续费支出
            ,issuebank -- 开证行
            ,acceptbank -- 承兑行
            ,classofbenetrade -- 信用证受益人行业分类
            ,resalematurity -- 转卖到期日
            ,prepaidamount -- 待摊金额
            ,interbusinessreve -- 中间业务收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 主表流水号
    ,nvl(n.bdserialno, o.bdserialno) as bdserialno -- 借据编号
    ,nvl(n.salerate, o.salerate) as salerate -- 卖出利率
    ,nvl(n.resalegather, o.resalegather) as resalegather -- 转卖收款金额
    ,nvl(n.remitcomexpense, o.remitcomexpense) as remitcomexpense -- 汇入手续费支出
    ,nvl(n.issuebank, o.issuebank) as issuebank -- 开证行
    ,nvl(n.acceptbank, o.acceptbank) as acceptbank -- 承兑行
    ,nvl(n.classofbenetrade, o.classofbenetrade) as classofbenetrade -- 信用证受益人行业分类
    ,nvl(n.resalematurity, o.resalematurity) as resalematurity -- 转卖到期日
    ,nvl(n.prepaidamount, o.prepaidamount) as prepaidamount -- 待摊金额
    ,nvl(n.interbusinessreve, o.interbusinessreve) as interbusinessreve -- 中间业务收入
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
from (select * from ${iol_schema}.icms_acct_trans_fft_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_acct_trans_fft_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objectno <> n.objectno
        or o.bdserialno <> n.bdserialno
        or o.salerate <> n.salerate
        or o.resalegather <> n.resalegather
        or o.remitcomexpense <> n.remitcomexpense
        or o.issuebank <> n.issuebank
        or o.acceptbank <> n.acceptbank
        or o.classofbenetrade <> n.classofbenetrade
        or o.resalematurity <> n.resalematurity
        or o.prepaidamount <> n.prepaidamount
        or o.interbusinessreve <> n.interbusinessreve
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_acct_trans_fft_detail_cl(
            serialno -- 流水号
            ,objectno -- 主表流水号
            ,bdserialno -- 借据编号
            ,salerate -- 卖出利率
            ,resalegather -- 转卖收款金额
            ,remitcomexpense -- 汇入手续费支出
            ,issuebank -- 开证行
            ,acceptbank -- 承兑行
            ,classofbenetrade -- 信用证受益人行业分类
            ,resalematurity -- 转卖到期日
            ,prepaidamount -- 待摊金额
            ,interbusinessreve -- 中间业务收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_acct_trans_fft_detail_op(
            serialno -- 流水号
            ,objectno -- 主表流水号
            ,bdserialno -- 借据编号
            ,salerate -- 卖出利率
            ,resalegather -- 转卖收款金额
            ,remitcomexpense -- 汇入手续费支出
            ,issuebank -- 开证行
            ,acceptbank -- 承兑行
            ,classofbenetrade -- 信用证受益人行业分类
            ,resalematurity -- 转卖到期日
            ,prepaidamount -- 待摊金额
            ,interbusinessreve -- 中间业务收入
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objectno -- 主表流水号
    ,o.bdserialno -- 借据编号
    ,o.salerate -- 卖出利率
    ,o.resalegather -- 转卖收款金额
    ,o.remitcomexpense -- 汇入手续费支出
    ,o.issuebank -- 开证行
    ,o.acceptbank -- 承兑行
    ,o.classofbenetrade -- 信用证受益人行业分类
    ,o.resalematurity -- 转卖到期日
    ,o.prepaidamount -- 待摊金额
    ,o.interbusinessreve -- 中间业务收入
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
from ${iol_schema}.icms_acct_trans_fft_detail_bk o
    left join ${iol_schema}.icms_acct_trans_fft_detail_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_acct_trans_fft_detail_cl d
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
--truncate table ${iol_schema}.icms_acct_trans_fft_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_acct_trans_fft_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_acct_trans_fft_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_acct_trans_fft_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_acct_trans_fft_detail exchange partition p_${batch_date} with table ${iol_schema}.icms_acct_trans_fft_detail_cl;
alter table ${iol_schema}.icms_acct_trans_fft_detail exchange partition p_20991231 with table ${iol_schema}.icms_acct_trans_fft_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_acct_trans_fft_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_acct_trans_fft_detail_op purge;
drop table ${iol_schema}.icms_acct_trans_fft_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_acct_trans_fft_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_acct_trans_fft_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
