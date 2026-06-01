/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_loan_payment_result
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
create table ${iol_schema}.icms_wph_loan_payment_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_loan_payment_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_loan_payment_result_op purge;
drop table ${iol_schema}.icms_wph_loan_payment_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_loan_payment_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_loan_payment_result where 0=1;

create table ${iol_schema}.icms_wph_loan_payment_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_loan_payment_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_loan_payment_result_cl(
            reference -- 交易参考号
            ,internalkey -- 借据号
            ,acctname -- 银行账户的开户人名称
            ,bankname -- 银行账户的开户行名称
            ,acctno -- 银行账户账号
            ,paytime -- 贷款到账时间
            ,payinstreqno -- 清算交易编号
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_loan_payment_result_op(
            reference -- 交易参考号
            ,internalkey -- 借据号
            ,acctname -- 银行账户的开户人名称
            ,bankname -- 银行账户的开户行名称
            ,acctno -- 银行账户账号
            ,paytime -- 贷款到账时间
            ,payinstreqno -- 清算交易编号
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.internalkey, o.internalkey) as internalkey -- 借据号
    ,nvl(n.acctname, o.acctname) as acctname -- 银行账户的开户人名称
    ,nvl(n.bankname, o.bankname) as bankname -- 银行账户的开户行名称
    ,nvl(n.acctno, o.acctno) as acctno -- 银行账户账号
    ,nvl(n.paytime, o.paytime) as paytime -- 贷款到账时间
    ,nvl(n.payinstreqno, o.payinstreqno) as payinstreqno -- 清算交易编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.bizdate, o.bizdate) as bizdate -- 流程日期
    ,case when
            n.reference is null
            and n.internalkey is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reference is null
            and n.internalkey is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reference is null
            and n.internalkey is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wph_loan_payment_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_loan_payment_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reference = n.reference
            and o.internalkey = n.internalkey
where (
        o.reference is null
        and o.internalkey is null
    )
    or (
        n.reference is null
        and n.internalkey is null
    )
    or (
        o.acctname <> n.acctname
        or o.bankname <> n.bankname
        or o.acctno <> n.acctno
        or o.paytime <> n.paytime
        or o.payinstreqno <> n.payinstreqno
        or o.inputdate <> n.inputdate
        or o.bizdate <> n.bizdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_loan_payment_result_cl(
            reference -- 交易参考号
            ,internalkey -- 借据号
            ,acctname -- 银行账户的开户人名称
            ,bankname -- 银行账户的开户行名称
            ,acctno -- 银行账户账号
            ,paytime -- 贷款到账时间
            ,payinstreqno -- 清算交易编号
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_loan_payment_result_op(
            reference -- 交易参考号
            ,internalkey -- 借据号
            ,acctname -- 银行账户的开户人名称
            ,bankname -- 银行账户的开户行名称
            ,acctno -- 银行账户账号
            ,paytime -- 贷款到账时间
            ,payinstreqno -- 清算交易编号
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reference -- 交易参考号
    ,o.internalkey -- 借据号
    ,o.acctname -- 银行账户的开户人名称
    ,o.bankname -- 银行账户的开户行名称
    ,o.acctno -- 银行账户账号
    ,o.paytime -- 贷款到账时间
    ,o.payinstreqno -- 清算交易编号
    ,o.inputdate -- 登记日期
    ,o.bizdate -- 流程日期
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
from ${iol_schema}.icms_wph_loan_payment_result_bk o
    left join ${iol_schema}.icms_wph_loan_payment_result_op n
        on
            o.reference = n.reference
            and o.internalkey = n.internalkey
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_loan_payment_result_cl d
        on
            o.reference = d.reference
            and o.internalkey = d.internalkey
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wph_loan_payment_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_loan_payment_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_loan_payment_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_loan_payment_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_loan_payment_result exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_loan_payment_result_cl;
alter table ${iol_schema}.icms_wph_loan_payment_result exchange partition p_20991231 with table ${iol_schema}.icms_wph_loan_payment_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_loan_payment_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_loan_payment_result_op purge;
drop table ${iol_schema}.icms_wph_loan_payment_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_loan_payment_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_loan_payment_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
