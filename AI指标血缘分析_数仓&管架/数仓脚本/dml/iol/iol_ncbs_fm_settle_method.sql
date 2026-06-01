/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_settle_method
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
create table ${iol_schema}.ncbs_fm_settle_method_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_settle_method
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_settle_method_op purge;
drop table ${iol_schema}.ncbs_fm_settle_method_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_settle_method_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_settle_method where 0=1;

create table ${iol_schema}.ncbs_fm_settle_method_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_settle_method where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_settle_method_cl(
            doc_type -- 凭证类型
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,dest_client_type -- 目标客户类型
            ,dest_id -- 目标id
            ,dest_type -- 目标类型
            ,dp_settle_flag -- 是否为dp清算
            ,format -- 电位类型
            ,is_cash -- 是否现金
            ,media -- 报表格式
            ,pay_rec -- 收付标志
            ,print_mode -- 打印模式
            ,release_security -- 安全释放
            ,senders_contact_type -- 发报方联系类型
            ,settle_acct_type -- 结算账户类型
            ,settle_method -- 结算方法
            ,settle_method_desc -- 结算方法描述
            ,verify_security -- 安全复合
            ,route -- 联系方式类型
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_settle_method_op(
            doc_type -- 凭证类型
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,dest_client_type -- 目标客户类型
            ,dest_id -- 目标id
            ,dest_type -- 目标类型
            ,dp_settle_flag -- 是否为dp清算
            ,format -- 电位类型
            ,is_cash -- 是否现金
            ,media -- 报表格式
            ,pay_rec -- 收付标志
            ,print_mode -- 打印模式
            ,release_security -- 安全释放
            ,senders_contact_type -- 发报方联系类型
            ,settle_acct_type -- 结算账户类型
            ,settle_method -- 结算方法
            ,settle_method_desc -- 结算方法描述
            ,verify_security -- 安全复合
            ,route -- 联系方式类型
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contact_type, o.contact_type) as contact_type -- 联系类型	
    ,nvl(n.dest_client_type, o.dest_client_type) as dest_client_type -- 目标客户类型
    ,nvl(n.dest_id, o.dest_id) as dest_id -- 目标id
    ,nvl(n.dest_type, o.dest_type) as dest_type -- 目标类型
    ,nvl(n.dp_settle_flag, o.dp_settle_flag) as dp_settle_flag -- 是否为dp清算
    ,nvl(n.format, o.format) as format -- 电位类型
    ,nvl(n.is_cash, o.is_cash) as is_cash -- 是否现金
    ,nvl(n.media, o.media) as media -- 报表格式
    ,nvl(n.pay_rec, o.pay_rec) as pay_rec -- 收付标志
    ,nvl(n.print_mode, o.print_mode) as print_mode -- 打印模式
    ,nvl(n.release_security, o.release_security) as release_security -- 安全释放
    ,nvl(n.senders_contact_type, o.senders_contact_type) as senders_contact_type -- 发报方联系类型
    ,nvl(n.settle_acct_type, o.settle_acct_type) as settle_acct_type -- 结算账户类型
    ,nvl(n.settle_method, o.settle_method) as settle_method -- 结算方法
    ,nvl(n.settle_method_desc, o.settle_method_desc) as settle_method_desc -- 结算方法描述
    ,nvl(n.verify_security, o.verify_security) as verify_security -- 安全复合
    ,nvl(n.route, o.route) as route -- 联系方式类型
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.pay_rec is null
            and n.settle_method is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pay_rec is null
            and n.settle_method is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pay_rec is null
            and n.settle_method is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_settle_method_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_settle_method where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pay_rec = n.pay_rec
            and o.settle_method = n.settle_method
where (
        o.pay_rec is null
        and o.settle_method is null
    )
    or (
        n.pay_rec is null
        and n.settle_method is null
    )
    or (
        o.doc_type <> n.doc_type
        or o.company <> n.company
        or o.contact_type <> n.contact_type
        or o.dest_client_type <> n.dest_client_type
        or o.dest_id <> n.dest_id
        or o.dest_type <> n.dest_type
        or o.dp_settle_flag <> n.dp_settle_flag
        or o.format <> n.format
        or o.is_cash <> n.is_cash
        or o.media <> n.media
        or o.print_mode <> n.print_mode
        or o.release_security <> n.release_security
        or o.senders_contact_type <> n.senders_contact_type
        or o.settle_acct_type <> n.settle_acct_type
        or o.settle_method_desc <> n.settle_method_desc
        or o.verify_security <> n.verify_security
        or o.route <> n.route
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_settle_method_cl(
            doc_type -- 凭证类型
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,dest_client_type -- 目标客户类型
            ,dest_id -- 目标id
            ,dest_type -- 目标类型
            ,dp_settle_flag -- 是否为dp清算
            ,format -- 电位类型
            ,is_cash -- 是否现金
            ,media -- 报表格式
            ,pay_rec -- 收付标志
            ,print_mode -- 打印模式
            ,release_security -- 安全释放
            ,senders_contact_type -- 发报方联系类型
            ,settle_acct_type -- 结算账户类型
            ,settle_method -- 结算方法
            ,settle_method_desc -- 结算方法描述
            ,verify_security -- 安全复合
            ,route -- 联系方式类型
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_settle_method_op(
            doc_type -- 凭证类型
            ,company -- 法人
            ,contact_type -- 联系类型	
            ,dest_client_type -- 目标客户类型
            ,dest_id -- 目标id
            ,dest_type -- 目标类型
            ,dp_settle_flag -- 是否为dp清算
            ,format -- 电位类型
            ,is_cash -- 是否现金
            ,media -- 报表格式
            ,pay_rec -- 收付标志
            ,print_mode -- 打印模式
            ,release_security -- 安全释放
            ,senders_contact_type -- 发报方联系类型
            ,settle_acct_type -- 结算账户类型
            ,settle_method -- 结算方法
            ,settle_method_desc -- 结算方法描述
            ,verify_security -- 安全复合
            ,route -- 联系方式类型
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.doc_type -- 凭证类型
    ,o.company -- 法人
    ,o.contact_type -- 联系类型	
    ,o.dest_client_type -- 目标客户类型
    ,o.dest_id -- 目标id
    ,o.dest_type -- 目标类型
    ,o.dp_settle_flag -- 是否为dp清算
    ,o.format -- 电位类型
    ,o.is_cash -- 是否现金
    ,o.media -- 报表格式
    ,o.pay_rec -- 收付标志
    ,o.print_mode -- 打印模式
    ,o.release_security -- 安全释放
    ,o.senders_contact_type -- 发报方联系类型
    ,o.settle_acct_type -- 结算账户类型
    ,o.settle_method -- 结算方法
    ,o.settle_method_desc -- 结算方法描述
    ,o.verify_security -- 安全复合
    ,o.route -- 联系方式类型
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_fm_settle_method_bk o
    left join ${iol_schema}.ncbs_fm_settle_method_op n
        on
            o.pay_rec = n.pay_rec
            and o.settle_method = n.settle_method
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_settle_method_cl d
        on
            o.pay_rec = d.pay_rec
            and o.settle_method = d.settle_method
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_settle_method;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_settle_method') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_settle_method drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_settle_method add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_settle_method exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_settle_method_cl;
alter table ${iol_schema}.ncbs_fm_settle_method exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_settle_method_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_settle_method to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_settle_method_op purge;
drop table ${iol_schema}.ncbs_fm_settle_method_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_settle_method_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_settle_method',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
