/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_sin_card
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
create table ${iol_schema}.ncbs_rb_acct_sin_card_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_sin_card
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_sin_card_op purge;
drop table ${iol_schema}.ncbs_rb_acct_sin_card_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_sin_card_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_sin_card where 0=1;

create table ${iol_schema}.ncbs_rb_acct_sin_card_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_sin_card where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_sin_card_cl(
            base_acct_no -- 交易账号/卡号
            ,acct_seq_no -- 账户子账号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,make_card_type -- 制卡类型
            ,last_tran_date -- 最后交易日期
            ,tran_timestamp -- 交易时间戳
            ,med_ins_card_no -- 医保卡号
            ,related_acct_type -- 账户关联类型
            ,sin_card_no -- 金融卡号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_sin_card_op(
            base_acct_no -- 交易账号/卡号
            ,acct_seq_no -- 账户子账号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,make_card_type -- 制卡类型
            ,last_tran_date -- 最后交易日期
            ,tran_timestamp -- 交易时间戳
            ,med_ins_card_no -- 医保卡号
            ,related_acct_type -- 账户关联类型
            ,sin_card_no -- 金融卡号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.make_card_type, o.make_card_type) as make_card_type -- 制卡类型
    ,nvl(n.last_tran_date, o.last_tran_date) as last_tran_date -- 最后交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.med_ins_card_no, o.med_ins_card_no) as med_ins_card_no -- 医保卡号
    ,nvl(n.related_acct_type, o.related_acct_type) as related_acct_type -- 账户关联类型
    ,nvl(n.sin_card_no, o.sin_card_no) as sin_card_no -- 金融卡号
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_sin_card_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_sin_card where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.acct_seq_no <> n.acct_seq_no
        or o.client_no <> n.client_no
        or o.company <> n.company
        or o.make_card_type <> n.make_card_type
        or o.last_tran_date <> n.last_tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.med_ins_card_no <> n.med_ins_card_no
        or o.related_acct_type <> n.related_acct_type
        or o.sin_card_no <> n.sin_card_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_sin_card_cl(
            base_acct_no -- 交易账号/卡号
            ,acct_seq_no -- 账户子账号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,make_card_type -- 制卡类型
            ,last_tran_date -- 最后交易日期
            ,tran_timestamp -- 交易时间戳
            ,med_ins_card_no -- 医保卡号
            ,related_acct_type -- 账户关联类型
            ,sin_card_no -- 金融卡号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_sin_card_op(
            base_acct_no -- 交易账号/卡号
            ,acct_seq_no -- 账户子账号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,make_card_type -- 制卡类型
            ,last_tran_date -- 最后交易日期
            ,tran_timestamp -- 交易时间戳
            ,med_ins_card_no -- 医保卡号
            ,related_acct_type -- 账户关联类型
            ,sin_card_no -- 金融卡号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.acct_seq_no -- 账户子账号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.make_card_type -- 制卡类型
    ,o.last_tran_date -- 最后交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.med_ins_card_no -- 医保卡号
    ,o.related_acct_type -- 账户关联类型
    ,o.sin_card_no -- 金融卡号
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
from ${iol_schema}.ncbs_rb_acct_sin_card_bk o
    left join ${iol_schema}.ncbs_rb_acct_sin_card_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_sin_card_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_sin_card;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_sin_card') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_sin_card drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_sin_card add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_sin_card exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_sin_card_cl;
alter table ${iol_schema}.ncbs_rb_acct_sin_card exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_sin_card_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_sin_card to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_sin_card_op purge;
drop table ${iol_schema}.ncbs_rb_acct_sin_card_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_sin_card_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_sin_card',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
