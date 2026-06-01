/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_countparty_bankacct
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
create table ${iol_schema}.ibms_ttrd_countparty_bankacct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_countparty_bankacct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct_op purge;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_countparty_bankacct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_countparty_bankacct where 0=1;

create table ${iol_schema}.ibms_ttrd_countparty_bankacct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_countparty_bankacct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_countparty_bankacct_cl(
            id -- 
            ,i_id -- 
            ,host_i_id -- 
            ,bank_acct -- 
            ,bank_acct_name -- 
            ,currency -- 货币类型
            ,b_i_id -- 
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,bank_code -- 开户行行号
            ,bank_name -- 开户行名称
            ,swift_code -- 开户行SWIFT代码
            ,remark -- 
            ,recv_bank_name -- 本方收款行账户名
            ,recv_bank_swift_code -- 本方收款行SWIFTCODE
            ,acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
            ,swift_type -- 交割报文
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_countparty_bankacct_op(
            id -- 
            ,i_id -- 
            ,host_i_id -- 
            ,bank_acct -- 
            ,bank_acct_name -- 
            ,currency -- 货币类型
            ,b_i_id -- 
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,bank_code -- 开户行行号
            ,bank_name -- 开户行名称
            ,swift_code -- 开户行SWIFT代码
            ,remark -- 
            ,recv_bank_name -- 本方收款行账户名
            ,recv_bank_swift_code -- 本方收款行SWIFTCODE
            ,acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
            ,swift_type -- 交割报文
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.i_id, o.i_id) as i_id -- 
    ,nvl(n.host_i_id, o.host_i_id) as host_i_id -- 
    ,nvl(n.bank_acct, o.bank_acct) as bank_acct -- 
    ,nvl(n.bank_acct_name, o.bank_acct_name) as bank_acct_name -- 
    ,nvl(n.currency, o.currency) as currency -- 货币类型
    ,nvl(n.b_i_id, o.b_i_id) as b_i_id -- 
    ,nvl(n.mid_bank_acct_code, o.mid_bank_acct_code) as mid_bank_acct_code -- 中间行账号
    ,nvl(n.mid_bank_name, o.mid_bank_name) as mid_bank_name -- 中间行名称
    ,nvl(n.mid_swift_code, o.mid_swift_code) as mid_swift_code -- 中间行SWIFT代码
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 开户行行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户行名称
    ,nvl(n.swift_code, o.swift_code) as swift_code -- 开户行SWIFT代码
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 本方收款行账户名
    ,nvl(n.recv_bank_swift_code, o.recv_bank_swift_code) as recv_bank_swift_code -- 本方收款行SWIFTCODE
    ,nvl(n.acc_code_type, o.acc_code_type) as acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
    ,nvl(n.swift_type, o.swift_type) as swift_type -- 交割报文
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_countparty_bankacct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_countparty_bankacct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.i_id <> n.i_id
        or o.host_i_id <> n.host_i_id
        or o.bank_acct <> n.bank_acct
        or o.bank_acct_name <> n.bank_acct_name
        or o.currency <> n.currency
        or o.b_i_id <> n.b_i_id
        or o.mid_bank_acct_code <> n.mid_bank_acct_code
        or o.mid_bank_name <> n.mid_bank_name
        or o.mid_swift_code <> n.mid_swift_code
        or o.bank_code <> n.bank_code
        or o.bank_name <> n.bank_name
        or o.swift_code <> n.swift_code
        or o.remark <> n.remark
        or o.recv_bank_name <> n.recv_bank_name
        or o.recv_bank_swift_code <> n.recv_bank_swift_code
        or o.acc_code_type <> n.acc_code_type
        or o.swift_type <> n.swift_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_countparty_bankacct_cl(
            id -- 
            ,i_id -- 
            ,host_i_id -- 
            ,bank_acct -- 
            ,bank_acct_name -- 
            ,currency -- 货币类型
            ,b_i_id -- 
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,bank_code -- 开户行行号
            ,bank_name -- 开户行名称
            ,swift_code -- 开户行SWIFT代码
            ,remark -- 
            ,recv_bank_name -- 本方收款行账户名
            ,recv_bank_swift_code -- 本方收款行SWIFTCODE
            ,acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
            ,swift_type -- 交割报文
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_countparty_bankacct_op(
            id -- 
            ,i_id -- 
            ,host_i_id -- 
            ,bank_acct -- 
            ,bank_acct_name -- 
            ,currency -- 货币类型
            ,b_i_id -- 
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,bank_code -- 开户行行号
            ,bank_name -- 开户行名称
            ,swift_code -- 开户行SWIFT代码
            ,remark -- 
            ,recv_bank_name -- 本方收款行账户名
            ,recv_bank_swift_code -- 本方收款行SWIFTCODE
            ,acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
            ,swift_type -- 交割报文
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.i_id -- 
    ,o.host_i_id -- 
    ,o.bank_acct -- 
    ,o.bank_acct_name -- 
    ,o.currency -- 货币类型
    ,o.b_i_id -- 
    ,o.mid_bank_acct_code -- 中间行账号
    ,o.mid_bank_name -- 中间行名称
    ,o.mid_swift_code -- 中间行SWIFT代码
    ,o.bank_code -- 开户行行号
    ,o.bank_name -- 开户行名称
    ,o.swift_code -- 开户行SWIFT代码
    ,o.remark -- 
    ,o.recv_bank_name -- 本方收款行账户名
    ,o.recv_bank_swift_code -- 本方收款行SWIFTCODE
    ,o.acc_code_type -- 代码类型:0-CNAPS,8-SWIFT,9-CFXPS
    ,o.swift_type -- 交割报文
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
from ${iol_schema}.ibms_ttrd_countparty_bankacct_bk o
    left join ${iol_schema}.ibms_ttrd_countparty_bankacct_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_countparty_bankacct_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_countparty_bankacct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_countparty_bankacct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_countparty_bankacct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_countparty_bankacct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_countparty_bankacct exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_countparty_bankacct_cl;
alter table ${iol_schema}.ibms_ttrd_countparty_bankacct exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_countparty_bankacct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_countparty_bankacct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct_op purge;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_countparty_bankacct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
