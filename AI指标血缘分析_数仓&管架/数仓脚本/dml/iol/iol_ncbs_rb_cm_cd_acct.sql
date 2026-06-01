/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_cm_cd_acct
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
create table ${iol_schema}.ncbs_rb_cm_cd_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_cm_cd_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct_op purge;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cm_cd_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_cm_cd_acct where 0=1;

create table ${iol_schema}.ncbs_rb_cm_cd_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_cm_cd_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_cm_cd_acct_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,channel_seq_no -- 全局流水号
            ,cm_cd_flag -- 存管现管标志
            ,cm_cd_operate -- 现管存管操作标识
            ,company -- 法人
            ,source_type -- 渠道编号
            ,sub_channel_seq_no -- 子渠道流水号
            ,xg_sign_status -- 现金管理协议状态
            ,last_change_date -- 最后修改日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,base_client_no -- 主账户客户号
            ,last_change_user_id -- 最后修改柜员
            ,sub_acct_name -- 子账户中文名
            ,sub_acct_no -- 子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_cm_cd_acct_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,channel_seq_no -- 全局流水号
            ,cm_cd_flag -- 存管现管标志
            ,cm_cd_operate -- 现管存管操作标识
            ,company -- 法人
            ,source_type -- 渠道编号
            ,sub_channel_seq_no -- 子渠道流水号
            ,xg_sign_status -- 现金管理协议状态
            ,last_change_date -- 最后修改日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,base_client_no -- 主账户客户号
            ,last_change_user_id -- 最后修改柜员
            ,sub_acct_name -- 子账户中文名
            ,sub_acct_no -- 子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.cm_cd_flag, o.cm_cd_flag) as cm_cd_flag -- 存管现管标志
    ,nvl(n.cm_cd_operate, o.cm_cd_operate) as cm_cd_operate -- 现管存管操作标识
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.sub_channel_seq_no, o.sub_channel_seq_no) as sub_channel_seq_no -- 子渠道流水号
    ,nvl(n.xg_sign_status, o.xg_sign_status) as xg_sign_status -- 现金管理协议状态
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.base_client_no, o.base_client_no) as base_client_no -- 主账户客户号
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.sub_acct_name, o.sub_acct_name) as sub_acct_name -- 子账户中文名
    ,nvl(n.sub_acct_no, o.sub_acct_no) as sub_acct_no -- 子账户
    ,case when
            n.base_acct_no is null
            and n.sub_acct_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_acct_no is null
            and n.sub_acct_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_acct_no is null
            and n.sub_acct_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_cm_cd_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_cm_cd_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_acct_no = n.base_acct_no
            and o.sub_acct_no = n.sub_acct_no
where (
        o.base_acct_no is null
        and o.sub_acct_no is null
    )
    or (
        n.base_acct_no is null
        and n.sub_acct_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.channel_seq_no <> n.channel_seq_no
        or o.cm_cd_flag <> n.cm_cd_flag
        or o.cm_cd_operate <> n.cm_cd_operate
        or o.company <> n.company
        or o.source_type <> n.source_type
        or o.sub_channel_seq_no <> n.sub_channel_seq_no
        or o.xg_sign_status <> n.xg_sign_status
        or o.last_change_date <> n.last_change_date
        or o.sign_date <> n.sign_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.base_client_no <> n.base_client_no
        or o.last_change_user_id <> n.last_change_user_id
        or o.sub_acct_name <> n.sub_acct_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_cm_cd_acct_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,channel_seq_no -- 全局流水号
            ,cm_cd_flag -- 存管现管标志
            ,cm_cd_operate -- 现管存管操作标识
            ,company -- 法人
            ,source_type -- 渠道编号
            ,sub_channel_seq_no -- 子渠道流水号
            ,xg_sign_status -- 现金管理协议状态
            ,last_change_date -- 最后修改日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,base_client_no -- 主账户客户号
            ,last_change_user_id -- 最后修改柜员
            ,sub_acct_name -- 子账户中文名
            ,sub_acct_no -- 子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_cm_cd_acct_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,channel_seq_no -- 全局流水号
            ,cm_cd_flag -- 存管现管标志
            ,cm_cd_operate -- 现管存管操作标识
            ,company -- 法人
            ,source_type -- 渠道编号
            ,sub_channel_seq_no -- 子渠道流水号
            ,xg_sign_status -- 现金管理协议状态
            ,last_change_date -- 最后修改日期
            ,sign_date -- 签约日期
            ,tran_timestamp -- 交易时间戳
            ,base_client_no -- 主账户客户号
            ,last_change_user_id -- 最后修改柜员
            ,sub_acct_name -- 子账户中文名
            ,sub_acct_no -- 子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.channel_seq_no -- 全局流水号
    ,o.cm_cd_flag -- 存管现管标志
    ,o.cm_cd_operate -- 现管存管操作标识
    ,o.company -- 法人
    ,o.source_type -- 渠道编号
    ,o.sub_channel_seq_no -- 子渠道流水号
    ,o.xg_sign_status -- 现金管理协议状态
    ,o.last_change_date -- 最后修改日期
    ,o.sign_date -- 签约日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.base_client_no -- 主账户客户号
    ,o.last_change_user_id -- 最后修改柜员
    ,o.sub_acct_name -- 子账户中文名
    ,o.sub_acct_no -- 子账户
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
from ${iol_schema}.ncbs_rb_cm_cd_acct_bk o
    left join ${iol_schema}.ncbs_rb_cm_cd_acct_op n
        on
            o.base_acct_no = n.base_acct_no
            and o.sub_acct_no = n.sub_acct_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_cm_cd_acct_cl d
        on
            o.base_acct_no = d.base_acct_no
            and o.sub_acct_no = d.sub_acct_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_cm_cd_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_cm_cd_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_cm_cd_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_cm_cd_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_cm_cd_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_cm_cd_acct_cl;
alter table ${iol_schema}.ncbs_rb_cm_cd_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_cm_cd_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_cm_cd_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct_op purge;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_cm_cd_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_cm_cd_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
