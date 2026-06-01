/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_card_chg_msg
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
create table ${iol_schema}.ncbs_rb_card_chg_msg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_card_chg_msg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_card_chg_msg_op purge;
drop table ${iol_schema}.ncbs_rb_card_chg_msg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_card_chg_msg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_card_chg_msg where 0=1;

create table ${iol_schema}.ncbs_rb_card_chg_msg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_card_chg_msg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_card_chg_msg_cl(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,send_no -- 发送次数
            ,send_seq_no -- 发送流水号
            ,seq_no -- 序号
            ,send_end_time -- 发送结束时间
            ,send_start_time -- 发送开始时间
            ,new_card_no -- 新卡号
            ,old_card_no -- 原卡号
            ,msg_notice_type -- 通知类型
            ,rb_status -- 存款客户合并处理状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_card_chg_msg_op(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,send_no -- 发送次数
            ,send_seq_no -- 发送流水号
            ,seq_no -- 序号
            ,send_end_time -- 发送结束时间
            ,send_start_time -- 发送开始时间
            ,new_card_no -- 新卡号
            ,old_card_no -- 原卡号
            ,msg_notice_type -- 通知类型
            ,rb_status -- 存款客户合并处理状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误代码
    ,nvl(n.send_no, o.send_no) as send_no -- 发送次数
    ,nvl(n.send_seq_no, o.send_seq_no) as send_seq_no -- 发送流水号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.send_end_time, o.send_end_time) as send_end_time -- 发送结束时间
    ,nvl(n.send_start_time, o.send_start_time) as send_start_time -- 发送开始时间
    ,nvl(n.new_card_no, o.new_card_no) as new_card_no -- 新卡号
    ,nvl(n.old_card_no, o.old_card_no) as old_card_no -- 原卡号
    ,nvl(n.msg_notice_type, o.msg_notice_type) as msg_notice_type -- 通知类型
    ,nvl(n.rb_status, o.rb_status) as rb_status -- 存款客户合并处理状态
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_card_chg_msg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_card_chg_msg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.error_code <> n.error_code
        or o.error_msg <> n.error_msg
        or o.send_no <> n.send_no
        or o.send_seq_no <> n.send_seq_no
        or o.send_end_time <> n.send_end_time
        or o.send_start_time <> n.send_start_time
        or o.new_card_no <> n.new_card_no
        or o.old_card_no <> n.old_card_no
        or o.msg_notice_type <> n.msg_notice_type
        or o.rb_status <> n.rb_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_card_chg_msg_cl(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,send_no -- 发送次数
            ,send_seq_no -- 发送流水号
            ,seq_no -- 序号
            ,send_end_time -- 发送结束时间
            ,send_start_time -- 发送开始时间
            ,new_card_no -- 新卡号
            ,old_card_no -- 原卡号
            ,msg_notice_type -- 通知类型
            ,rb_status -- 存款客户合并处理状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_card_chg_msg_op(
            client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,send_no -- 发送次数
            ,send_seq_no -- 发送流水号
            ,seq_no -- 序号
            ,send_end_time -- 发送结束时间
            ,send_start_time -- 发送开始时间
            ,new_card_no -- 新卡号
            ,old_card_no -- 原卡号
            ,msg_notice_type -- 通知类型
            ,rb_status -- 存款客户合并处理状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.user_id -- 交易柜员编号
    ,o.error_code -- 错误码
    ,o.error_msg -- 错误代码
    ,o.send_no -- 发送次数
    ,o.send_seq_no -- 发送流水号
    ,o.seq_no -- 序号
    ,o.send_end_time -- 发送结束时间
    ,o.send_start_time -- 发送开始时间
    ,o.new_card_no -- 新卡号
    ,o.old_card_no -- 原卡号
    ,o.msg_notice_type -- 通知类型
    ,o.rb_status -- 存款客户合并处理状态
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
from ${iol_schema}.ncbs_rb_card_chg_msg_bk o
    left join ${iol_schema}.ncbs_rb_card_chg_msg_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_card_chg_msg_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_card_chg_msg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_card_chg_msg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_card_chg_msg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_card_chg_msg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_card_chg_msg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_card_chg_msg_cl;
alter table ${iol_schema}.ncbs_rb_card_chg_msg exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_card_chg_msg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_card_chg_msg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_card_chg_msg_op purge;
drop table ${iol_schema}.ncbs_rb_card_chg_msg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_card_chg_msg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_card_chg_msg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
