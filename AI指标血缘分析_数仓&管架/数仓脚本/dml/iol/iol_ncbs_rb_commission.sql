/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_commission
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
create table ${iol_schema}.ncbs_rb_commission_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_commission
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_commission_op purge;
drop table ${iol_schema}.ncbs_rb_commission_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_commission_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_commission where 0=1;

create table ${iol_schema}.ncbs_rb_commission_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_commission where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_commission_cl(
            client_no -- 客户编号
            ,country -- 国家
            ,company -- 法人
            ,check_date -- 检查日期
            ,tran_timestamp -- 交易时间戳
            ,commission_client_name -- 代办人名称
            ,commission_client_no -- 代办人客户号
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_commission_op(
            client_no -- 客户编号
            ,country -- 国家
            ,company -- 法人
            ,check_date -- 检查日期
            ,tran_timestamp -- 交易时间戳
            ,commission_client_name -- 代办人名称
            ,commission_client_no -- 代办人客户号
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.check_date, o.check_date) as check_date -- 检查日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.commission_client_name, o.commission_client_name) as commission_client_name -- 代办人名称
    ,nvl(n.commission_client_no, o.commission_client_no) as commission_client_no -- 代办人客户号
    ,nvl(n.commission_document_id, o.commission_document_id) as commission_document_id -- 代办人证件号码
    ,nvl(n.commission_document_type, o.commission_document_type) as commission_document_type -- 代办人证件类型
    ,case when
            n.check_date is null
            and n.commission_document_id is null
            and n.commission_document_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.check_date is null
            and n.commission_document_id is null
            and n.commission_document_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.check_date is null
            and n.commission_document_id is null
            and n.commission_document_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_commission_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_commission where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.check_date = n.check_date
            and o.commission_document_id = n.commission_document_id
            and o.commission_document_type = n.commission_document_type
where (
        o.check_date is null
        and o.commission_document_id is null
        and o.commission_document_type is null
    )
    or (
        n.check_date is null
        and n.commission_document_id is null
        and n.commission_document_type is null
    )
    or (
        o.client_no <> n.client_no
        or o.country <> n.country
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.commission_client_name <> n.commission_client_name
        or o.commission_client_no <> n.commission_client_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_commission_cl(
            client_no -- 客户编号
            ,country -- 国家
            ,company -- 法人
            ,check_date -- 检查日期
            ,tran_timestamp -- 交易时间戳
            ,commission_client_name -- 代办人名称
            ,commission_client_no -- 代办人客户号
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_commission_op(
            client_no -- 客户编号
            ,country -- 国家
            ,company -- 法人
            ,check_date -- 检查日期
            ,tran_timestamp -- 交易时间戳
            ,commission_client_name -- 代办人名称
            ,commission_client_no -- 代办人客户号
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.country -- 国家
    ,o.company -- 法人
    ,o.check_date -- 检查日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.commission_client_name -- 代办人名称
    ,o.commission_client_no -- 代办人客户号
    ,o.commission_document_id -- 代办人证件号码
    ,o.commission_document_type -- 代办人证件类型
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
from ${iol_schema}.ncbs_rb_commission_bk o
    left join ${iol_schema}.ncbs_rb_commission_op n
        on
            o.check_date = n.check_date
            and o.commission_document_id = n.commission_document_id
            and o.commission_document_type = n.commission_document_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_commission_cl d
        on
            o.check_date = d.check_date
            and o.commission_document_id = d.commission_document_id
            and o.commission_document_type = d.commission_document_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_commission;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_commission') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_commission drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_commission add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_commission exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_commission_cl;
alter table ${iol_schema}.ncbs_rb_commission exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_commission_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_commission to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_commission_op purge;
drop table ${iol_schema}.ncbs_rb_commission_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_commission_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_commission',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
