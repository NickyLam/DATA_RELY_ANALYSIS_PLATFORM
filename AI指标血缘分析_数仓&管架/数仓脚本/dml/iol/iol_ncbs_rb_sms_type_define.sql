/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_sms_type_define
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
create table ${iol_schema}.ncbs_rb_sms_type_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_sms_type_define
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_sms_type_define_op purge;
drop table ${iol_schema}.ncbs_rb_sms_type_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_sms_type_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_sms_type_define where 0=1;

create table ${iol_schema}.ncbs_rb_sms_type_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_sms_type_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_sms_type_define_cl(
            client_indicator -- 客户标识
            ,company -- 法人
            ,match_condition -- 检查内容(匹配条件)
            ,require_agr_flag -- 是否需要短信签约
            ,send_method -- 发送方式
            ,send_priority -- 短信发送优先级
            ,sms_client_type -- 短信客户类型
            ,sms_desc -- 短信类型描述
            ,sms_send_time -- 短信发送时间
            ,sms_send_type -- 短信发送类型
            ,sms_template -- 短信模板
            ,sms_tran_type -- 交易类型范围
            ,sms_type -- 短信类型
            ,template_flag -- 是否使用短信模板
            ,tran_timestamp -- 交易时间戳
            ,remind_days -- 提前提醒天数
            ,sms_min_amt -- 短信发送最小金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_sms_type_define_op(
            client_indicator -- 客户标识
            ,company -- 法人
            ,match_condition -- 检查内容(匹配条件)
            ,require_agr_flag -- 是否需要短信签约
            ,send_method -- 发送方式
            ,send_priority -- 短信发送优先级
            ,sms_client_type -- 短信客户类型
            ,sms_desc -- 短信类型描述
            ,sms_send_time -- 短信发送时间
            ,sms_send_type -- 短信发送类型
            ,sms_template -- 短信模板
            ,sms_tran_type -- 交易类型范围
            ,sms_type -- 短信类型
            ,template_flag -- 是否使用短信模板
            ,tran_timestamp -- 交易时间戳
            ,remind_days -- 提前提醒天数
            ,sms_min_amt -- 短信发送最小金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_indicator, o.client_indicator) as client_indicator -- 客户标识
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.match_condition, o.match_condition) as match_condition -- 检查内容(匹配条件)
    ,nvl(n.require_agr_flag, o.require_agr_flag) as require_agr_flag -- 是否需要短信签约
    ,nvl(n.send_method, o.send_method) as send_method -- 发送方式
    ,nvl(n.send_priority, o.send_priority) as send_priority -- 短信发送优先级
    ,nvl(n.sms_client_type, o.sms_client_type) as sms_client_type -- 短信客户类型
    ,nvl(n.sms_desc, o.sms_desc) as sms_desc -- 短信类型描述
    ,nvl(n.sms_send_time, o.sms_send_time) as sms_send_time -- 短信发送时间
    ,nvl(n.sms_send_type, o.sms_send_type) as sms_send_type -- 短信发送类型
    ,nvl(n.sms_template, o.sms_template) as sms_template -- 短信模板
    ,nvl(n.sms_tran_type, o.sms_tran_type) as sms_tran_type -- 交易类型范围
    ,nvl(n.sms_type, o.sms_type) as sms_type -- 短信类型
    ,nvl(n.template_flag, o.template_flag) as template_flag -- 是否使用短信模板
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.remind_days, o.remind_days) as remind_days -- 提前提醒天数
    ,nvl(n.sms_min_amt, o.sms_min_amt) as sms_min_amt -- 短信发送最小金额
    ,case when
            n.sms_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sms_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sms_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_sms_type_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_sms_type_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sms_type = n.sms_type
where (
        o.sms_type is null
    )
    or (
        n.sms_type is null
    )
    or (
        o.client_indicator <> n.client_indicator
        or o.company <> n.company
        or o.match_condition <> n.match_condition
        or o.require_agr_flag <> n.require_agr_flag
        or o.send_method <> n.send_method
        or o.send_priority <> n.send_priority
        or o.sms_client_type <> n.sms_client_type
        or o.sms_desc <> n.sms_desc
        or o.sms_send_time <> n.sms_send_time
        or o.sms_send_type <> n.sms_send_type
        or o.sms_template <> n.sms_template
        or o.sms_tran_type <> n.sms_tran_type
        or o.template_flag <> n.template_flag
        or o.tran_timestamp <> n.tran_timestamp
        or o.remind_days <> n.remind_days
        or o.sms_min_amt <> n.sms_min_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_sms_type_define_cl(
            client_indicator -- 客户标识
            ,company -- 法人
            ,match_condition -- 检查内容(匹配条件)
            ,require_agr_flag -- 是否需要短信签约
            ,send_method -- 发送方式
            ,send_priority -- 短信发送优先级
            ,sms_client_type -- 短信客户类型
            ,sms_desc -- 短信类型描述
            ,sms_send_time -- 短信发送时间
            ,sms_send_type -- 短信发送类型
            ,sms_template -- 短信模板
            ,sms_tran_type -- 交易类型范围
            ,sms_type -- 短信类型
            ,template_flag -- 是否使用短信模板
            ,tran_timestamp -- 交易时间戳
            ,remind_days -- 提前提醒天数
            ,sms_min_amt -- 短信发送最小金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_sms_type_define_op(
            client_indicator -- 客户标识
            ,company -- 法人
            ,match_condition -- 检查内容(匹配条件)
            ,require_agr_flag -- 是否需要短信签约
            ,send_method -- 发送方式
            ,send_priority -- 短信发送优先级
            ,sms_client_type -- 短信客户类型
            ,sms_desc -- 短信类型描述
            ,sms_send_time -- 短信发送时间
            ,sms_send_type -- 短信发送类型
            ,sms_template -- 短信模板
            ,sms_tran_type -- 交易类型范围
            ,sms_type -- 短信类型
            ,template_flag -- 是否使用短信模板
            ,tran_timestamp -- 交易时间戳
            ,remind_days -- 提前提醒天数
            ,sms_min_amt -- 短信发送最小金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_indicator -- 客户标识
    ,o.company -- 法人
    ,o.match_condition -- 检查内容(匹配条件)
    ,o.require_agr_flag -- 是否需要短信签约
    ,o.send_method -- 发送方式
    ,o.send_priority -- 短信发送优先级
    ,o.sms_client_type -- 短信客户类型
    ,o.sms_desc -- 短信类型描述
    ,o.sms_send_time -- 短信发送时间
    ,o.sms_send_type -- 短信发送类型
    ,o.sms_template -- 短信模板
    ,o.sms_tran_type -- 交易类型范围
    ,o.sms_type -- 短信类型
    ,o.template_flag -- 是否使用短信模板
    ,o.tran_timestamp -- 交易时间戳
    ,o.remind_days -- 提前提醒天数
    ,o.sms_min_amt -- 短信发送最小金额
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
from ${iol_schema}.ncbs_rb_sms_type_define_bk o
    left join ${iol_schema}.ncbs_rb_sms_type_define_op n
        on
            o.sms_type = n.sms_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_sms_type_define_cl d
        on
            o.sms_type = d.sms_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_sms_type_define;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_sms_type_define') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_sms_type_define drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_sms_type_define add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_sms_type_define exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_sms_type_define_cl;
alter table ${iol_schema}.ncbs_rb_sms_type_define exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_sms_type_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_sms_type_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_sms_type_define_op purge;
drop table ${iol_schema}.ncbs_rb_sms_type_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_sms_type_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_sms_type_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
