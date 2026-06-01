/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_impound_agent_messgae
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
create table ${iol_schema}.ncbs_rb_impound_agent_messgae_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_impound_agent_messgae
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae_op purge;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_impound_agent_messgae_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_impound_agent_messgae where 0=1;

create table ${iol_schema}.ncbs_rb_impound_agent_messgae_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_impound_agent_messgae where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_impound_agent_messgae_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,agent_department -- 所属部门
            ,agent_number -- 办理人编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,agent_document_id -- 办理人证件号码
            ,agent_document_type -- 办理人证件类型
            ,agent_name -- 办理人姓名
            ,transfer_reason -- 扣划原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_impound_agent_messgae_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,agent_department -- 所属部门
            ,agent_number -- 办理人编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,agent_document_id -- 办理人证件号码
            ,agent_document_type -- 办理人证件类型
            ,agent_name -- 办理人姓名
            ,transfer_reason -- 扣划原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.agent_department, o.agent_department) as agent_department -- 所属部门
    ,nvl(n.agent_number, o.agent_number) as agent_number -- 办理人编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.agent_document_id, o.agent_document_id) as agent_document_id -- 办理人证件号码
    ,nvl(n.agent_document_type, o.agent_document_type) as agent_document_type -- 办理人证件类型
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 办理人姓名
    ,nvl(n.transfer_reason, o.transfer_reason) as transfer_reason -- 扣划原因
    ,case when
            n.reference is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reference is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reference is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_impound_agent_messgae_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_impound_agent_messgae where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reference = n.reference
where (
        o.reference is null
    )
    or (
        n.reference is null
    )
    or (
        o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.agent_department <> n.agent_department
        or o.agent_number <> n.agent_number
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.agent_document_id <> n.agent_document_id
        or o.agent_document_type <> n.agent_document_type
        or o.agent_name <> n.agent_name
        or o.transfer_reason <> n.transfer_reason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_impound_agent_messgae_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,agent_department -- 所属部门
            ,agent_number -- 办理人编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,agent_document_id -- 办理人证件号码
            ,agent_document_type -- 办理人证件类型
            ,agent_name -- 办理人姓名
            ,transfer_reason -- 扣划原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_impound_agent_messgae_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,agent_department -- 所属部门
            ,agent_number -- 办理人编号
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,agent_document_id -- 办理人证件号码
            ,agent_document_type -- 办理人证件类型
            ,agent_name -- 办理人姓名
            ,transfer_reason -- 扣划原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.agent_department -- 所属部门
    ,o.agent_number -- 办理人编号
    ,o.company -- 法人
    ,o.tran_timestamp -- 交易时间戳
    ,o.agent_document_id -- 办理人证件号码
    ,o.agent_document_type -- 办理人证件类型
    ,o.agent_name -- 办理人姓名
    ,o.transfer_reason -- 扣划原因
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
from ${iol_schema}.ncbs_rb_impound_agent_messgae_bk o
    left join ${iol_schema}.ncbs_rb_impound_agent_messgae_op n
        on
            o.reference = n.reference
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_impound_agent_messgae_cl d
        on
            o.reference = d.reference
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_impound_agent_messgae;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_impound_agent_messgae') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_impound_agent_messgae drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_impound_agent_messgae add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_impound_agent_messgae exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_impound_agent_messgae_cl;
alter table ${iol_schema}.ncbs_rb_impound_agent_messgae exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_impound_agent_messgae_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_impound_agent_messgae to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae_op purge;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_impound_agent_messgae_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_impound_agent_messgae',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
