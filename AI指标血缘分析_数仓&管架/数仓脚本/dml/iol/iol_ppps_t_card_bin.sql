/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_card_bin
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
create table ${iol_schema}.ppps_t_card_bin_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_t_card_bin
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_card_bin_op purge;
drop table ${iol_schema}.ppps_t_card_bin_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_card_bin_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_card_bin where 0=1;

create table ${iol_schema}.ppps_t_card_bin_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_card_bin where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_card_bin_cl(
            id -- 自增主键
            ,card_bin -- 卡BIN
            ,card_length -- 卡号长度
            ,acct_type -- 卡类型，取值：AcctTypeEnum
            ,clear_bank_code -- 清算行行号
            ,clear_bank_name -- 清算行行名
            ,active -- 起停状态，取值：ActiveStateEnum
            ,create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,financial_branch_code -- 金融机构代码"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_card_bin_op(
            id -- 自增主键
            ,card_bin -- 卡BIN
            ,card_length -- 卡号长度
            ,acct_type -- 卡类型，取值：AcctTypeEnum
            ,clear_bank_code -- 清算行行号
            ,clear_bank_name -- 清算行行名
            ,active -- 起停状态，取值：ActiveStateEnum
            ,create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,financial_branch_code -- 金融机构代码"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.card_bin, o.card_bin) as card_bin -- 卡BIN
    ,nvl(n.card_length, o.card_length) as card_length -- 卡号长度
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 卡类型，取值：AcctTypeEnum
    ,nvl(n.clear_bank_code, o.clear_bank_code) as clear_bank_code -- 清算行行号
    ,nvl(n.clear_bank_name, o.clear_bank_name) as clear_bank_name -- 清算行行名
    ,nvl(n.active, o.active) as active -- 起停状态，取值：ActiveStateEnum
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(n.update_time, o.update_time) as update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(n.financial_branch_code, o.financial_branch_code) as financial_branch_code -- 金融机构代码"
    ,case when
            n.card_bin is null
            and n.card_length is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.card_bin is null
            and n.card_length is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.card_bin is null
            and n.card_length is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_t_card_bin_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_t_card_bin where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.card_bin = n.card_bin
            and o.card_length = n.card_length
where (
        o.card_bin is null
        and o.card_length is null
    )
    or (
        n.card_bin is null
        and n.card_length is null
    )
    or (
        o.id <> n.id
        or o.acct_type <> n.acct_type
        or o.clear_bank_code <> n.clear_bank_code
        or o.clear_bank_name <> n.clear_bank_name
        or o.active <> n.active
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.financial_branch_code <> n.financial_branch_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_card_bin_cl(
            id -- 自增主键
            ,card_bin -- 卡BIN
            ,card_length -- 卡号长度
            ,acct_type -- 卡类型，取值：AcctTypeEnum
            ,clear_bank_code -- 清算行行号
            ,clear_bank_name -- 清算行行名
            ,active -- 起停状态，取值：ActiveStateEnum
            ,create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,financial_branch_code -- 金融机构代码"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_card_bin_op(
            id -- 自增主键
            ,card_bin -- 卡BIN
            ,card_length -- 卡号长度
            ,acct_type -- 卡类型，取值：AcctTypeEnum
            ,clear_bank_code -- 清算行行号
            ,clear_bank_name -- 清算行行名
            ,active -- 起停状态，取值：ActiveStateEnum
            ,create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,financial_branch_code -- 金融机构代码"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.card_bin -- 卡BIN
    ,o.card_length -- 卡号长度
    ,o.acct_type -- 卡类型，取值：AcctTypeEnum
    ,o.clear_bank_code -- 清算行行号
    ,o.clear_bank_name -- 清算行行名
    ,o.active -- 起停状态，取值：ActiveStateEnum
    ,o.create_time -- 创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,o.update_time -- 最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,o.financial_branch_code -- 金融机构代码"
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
from ${iol_schema}.ppps_t_card_bin_bk o
    left join ${iol_schema}.ppps_t_card_bin_op n
        on
            o.card_bin = n.card_bin
            and o.card_length = n.card_length
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_t_card_bin_cl d
        on
            o.card_bin = d.card_bin
            and o.card_length = d.card_length
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_t_card_bin;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_t_card_bin') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_t_card_bin drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_t_card_bin add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_t_card_bin exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_card_bin_cl;
alter table ${iol_schema}.ppps_t_card_bin exchange partition p_20991231 with table ${iol_schema}.ppps_t_card_bin_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_card_bin to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_card_bin_op purge;
drop table ${iol_schema}.ppps_t_card_bin_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_t_card_bin_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_card_bin',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
