/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rc_list_not_check_range
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
create table ${iol_schema}.ncbs_rc_list_not_check_range_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rc_list_not_check_range
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rc_list_not_check_range_op purge;
drop table ${iol_schema}.ncbs_rc_list_not_check_range_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_list_not_check_range_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rc_list_not_check_range where 0=1;

create table ${iol_schema}.ncbs_rc_list_not_check_range_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rc_list_not_check_range where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rc_list_not_check_range_cl(
            remark -- 备注
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,program_id -- 交易代码
            ,seq_no -- 序号
            ,service_code -- 服务代码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rc_list_not_check_range_op(
            remark -- 备注
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,program_id -- 交易代码
            ,seq_no -- 序号
            ,service_code -- 服务代码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.list_type, o.list_type) as list_type -- 名单类型代码
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.message_code, o.message_code) as message_code -- 接口服务代码
    ,nvl(n.message_type, o.message_type) as message_type -- 接口服务类型
    ,nvl(n.program_id, o.program_id) as program_id -- 交易代码
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.service_code, o.service_code) as service_code -- 服务代码
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
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
from (select * from ${iol_schema}.ncbs_rc_list_not_check_range_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rc_list_not_check_range where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.remark <> n.remark
        or o.list_type <> n.list_type
        or o.company <> n.company
        or o.message_code <> n.message_code
        or o.message_type <> n.message_type
        or o.program_id <> n.program_id
        or o.service_code <> n.service_code
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rc_list_not_check_range_cl(
            remark -- 备注
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,program_id -- 交易代码
            ,seq_no -- 序号
            ,service_code -- 服务代码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rc_list_not_check_range_op(
            remark -- 备注
            ,list_type -- 名单类型代码
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,program_id -- 交易代码
            ,seq_no -- 序号
            ,service_code -- 服务代码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.remark -- 备注
    ,o.list_type -- 名单类型代码
    ,o.company -- 法人
    ,o.message_code -- 接口服务代码
    ,o.message_type -- 接口服务类型
    ,o.program_id -- 交易代码
    ,o.seq_no -- 序号
    ,o.service_code -- 服务代码
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
from ${iol_schema}.ncbs_rc_list_not_check_range_bk o
    left join ${iol_schema}.ncbs_rc_list_not_check_range_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rc_list_not_check_range_cl d
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
--truncate table ${iol_schema}.ncbs_rc_list_not_check_range;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rc_list_not_check_range') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rc_list_not_check_range drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rc_list_not_check_range add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rc_list_not_check_range exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rc_list_not_check_range_cl;
alter table ${iol_schema}.ncbs_rc_list_not_check_range exchange partition p_20991231 with table ${iol_schema}.ncbs_rc_list_not_check_range_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rc_list_not_check_range to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rc_list_not_check_range_op purge;
drop table ${iol_schema}.ncbs_rc_list_not_check_range_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rc_list_not_check_range_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rc_list_not_check_range',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
