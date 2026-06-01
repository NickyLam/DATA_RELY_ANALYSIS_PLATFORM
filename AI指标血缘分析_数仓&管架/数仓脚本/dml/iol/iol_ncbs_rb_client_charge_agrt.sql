/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_client_charge_agrt
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
create table ${iol_schema}.ncbs_rb_client_charge_agrt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_client_charge_agrt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt_op purge;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_charge_agrt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_charge_agrt where 0=1;

create table ${iol_schema}.ncbs_rb_client_charge_agrt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_charge_agrt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_charge_agrt_cl(
            client_no -- 客户编号
            ,period_freq -- 频率id
            ,agreement_id -- 协议编号
            ,charge_way -- 收费方式
            ,company -- 法人
            ,fee_type -- 费率类型
            ,oth_business_no -- 对手业务编号
            ,seq_no -- 序号
            ,status -- 状态
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,charge_day -- 收费日
            ,oth_name -- 对手名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_charge_agrt_op(
            client_no -- 客户编号
            ,period_freq -- 频率id
            ,agreement_id -- 协议编号
            ,charge_way -- 收费方式
            ,company -- 法人
            ,fee_type -- 费率类型
            ,oth_business_no -- 对手业务编号
            ,seq_no -- 序号
            ,status -- 状态
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,charge_day -- 收费日
            ,oth_name -- 对手名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.charge_way, o.charge_way) as charge_way -- 收费方式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.oth_business_no, o.oth_business_no) as oth_business_no -- 对手业务编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.next_charge_date, o.next_charge_date) as next_charge_date -- 下一收费日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.charge_day, o.charge_day) as charge_day -- 收费日
    ,nvl(n.oth_name, o.oth_name) as oth_name -- 对手名称
    ,case when
            n.agreement_id is null
            and n.fee_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
            and n.fee_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
            and n.fee_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_client_charge_agrt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_client_charge_agrt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
            and o.fee_type = n.fee_type
where (
        o.agreement_id is null
        and o.fee_type is null
    )
    or (
        n.agreement_id is null
        and n.fee_type is null
    )
    or (
        o.client_no <> n.client_no
        or o.period_freq <> n.period_freq
        or o.charge_way <> n.charge_way
        or o.company <> n.company
        or o.oth_business_no <> n.oth_business_no
        or o.seq_no <> n.seq_no
        or o.status <> n.status
        or o.next_charge_date <> n.next_charge_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.charge_day <> n.charge_day
        or o.oth_name <> n.oth_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_charge_agrt_cl(
            client_no -- 客户编号
            ,period_freq -- 频率id
            ,agreement_id -- 协议编号
            ,charge_way -- 收费方式
            ,company -- 法人
            ,fee_type -- 费率类型
            ,oth_business_no -- 对手业务编号
            ,seq_no -- 序号
            ,status -- 状态
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,charge_day -- 收费日
            ,oth_name -- 对手名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_charge_agrt_op(
            client_no -- 客户编号
            ,period_freq -- 频率id
            ,agreement_id -- 协议编号
            ,charge_way -- 收费方式
            ,company -- 法人
            ,fee_type -- 费率类型
            ,oth_business_no -- 对手业务编号
            ,seq_no -- 序号
            ,status -- 状态
            ,next_charge_date -- 下一收费日期
            ,tran_timestamp -- 交易时间戳
            ,charge_day -- 收费日
            ,oth_name -- 对手名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.period_freq -- 频率id
    ,o.agreement_id -- 协议编号
    ,o.charge_way -- 收费方式
    ,o.company -- 法人
    ,o.fee_type -- 费率类型
    ,o.oth_business_no -- 对手业务编号
    ,o.seq_no -- 序号
    ,o.status -- 状态
    ,o.next_charge_date -- 下一收费日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.charge_day -- 收费日
    ,o.oth_name -- 对手名称
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
from ${iol_schema}.ncbs_rb_client_charge_agrt_bk o
    left join ${iol_schema}.ncbs_rb_client_charge_agrt_op n
        on
            o.agreement_id = n.agreement_id
            and o.fee_type = n.fee_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_client_charge_agrt_cl d
        on
            o.agreement_id = d.agreement_id
            and o.fee_type = d.fee_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_client_charge_agrt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_client_charge_agrt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_client_charge_agrt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_client_charge_agrt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_client_charge_agrt exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_client_charge_agrt_cl;
alter table ${iol_schema}.ncbs_rb_client_charge_agrt exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_client_charge_agrt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_client_charge_agrt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt_op purge;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_client_charge_agrt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
