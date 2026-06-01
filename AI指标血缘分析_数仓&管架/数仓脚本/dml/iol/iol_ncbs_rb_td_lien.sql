/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_td_lien
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
create table ${iol_schema}.ncbs_rb_td_lien_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_td_lien
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_td_lien_op purge;
drop table ${iol_schema}.ncbs_rb_td_lien_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_td_lien_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_td_lien where 0=1;

create table ${iol_schema}.ncbs_rb_td_lien_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_td_lien where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_td_lien_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_td_lien_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
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
from (select * from ${iol_schema}.ncbs_rb_td_lien_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_td_lien where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.restraint_type <> n.restraint_type
        or o.company <> n.company
        or o.res_seq_no <> n.res_seq_no
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_td_lien_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_td_lien_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.restraint_type -- 限制类型
    ,o.company -- 法人
    ,o.res_seq_no -- 限制编号
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
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
from ${iol_schema}.ncbs_rb_td_lien_bk o
    left join ${iol_schema}.ncbs_rb_td_lien_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_td_lien_cl d
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
--truncate table ${iol_schema}.ncbs_rb_td_lien;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_td_lien') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_td_lien drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_td_lien add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_td_lien exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_td_lien_cl;
alter table ${iol_schema}.ncbs_rb_td_lien exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_td_lien_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_td_lien to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_td_lien_op purge;
drop table ${iol_schema}.ncbs_rb_td_lien_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_td_lien_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_td_lien',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
