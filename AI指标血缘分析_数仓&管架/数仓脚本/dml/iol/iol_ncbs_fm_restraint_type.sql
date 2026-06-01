/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_restraint_type
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
create table ${iol_schema}.ncbs_fm_restraint_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_restraint_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_restraint_type_op purge;
drop table ${iol_schema}.ncbs_fm_restraint_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_restraint_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_restraint_type where 0=1;

create table ${iol_schema}.ncbs_fm_restraint_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_restraint_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_restraint_type_cl(
            restraint_type -- 限制类型
            ,ah_bu_flag -- 是否有权机关冻结
            ,company -- 法人
            ,eod_impound_flag -- eod扣款标志
            ,manual_res_flag -- 手工冻结标志
            ,manual_unres_flag -- 手工解冻标志
            ,res_priority -- 冻结级别
            ,restraint_class -- 限制类型类别
            ,restraint_type_desc -- 限制类型描述
            ,stop_wtd_flag -- 全额止付标志
            ,system_use_flag -- 是否系统专用标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_restraint_type_op(
            restraint_type -- 限制类型
            ,ah_bu_flag -- 是否有权机关冻结
            ,company -- 法人
            ,eod_impound_flag -- eod扣款标志
            ,manual_res_flag -- 手工冻结标志
            ,manual_unres_flag -- 手工解冻标志
            ,res_priority -- 冻结级别
            ,restraint_class -- 限制类型类别
            ,restraint_type_desc -- 限制类型描述
            ,stop_wtd_flag -- 全额止付标志
            ,system_use_flag -- 是否系统专用标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.ah_bu_flag, o.ah_bu_flag) as ah_bu_flag -- 是否有权机关冻结
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.eod_impound_flag, o.eod_impound_flag) as eod_impound_flag -- eod扣款标志
    ,nvl(n.manual_res_flag, o.manual_res_flag) as manual_res_flag -- 手工冻结标志
    ,nvl(n.manual_unres_flag, o.manual_unres_flag) as manual_unres_flag -- 手工解冻标志
    ,nvl(n.res_priority, o.res_priority) as res_priority -- 冻结级别
    ,nvl(n.restraint_class, o.restraint_class) as restraint_class -- 限制类型类别
    ,nvl(n.restraint_type_desc, o.restraint_type_desc) as restraint_type_desc -- 限制类型描述
    ,nvl(n.stop_wtd_flag, o.stop_wtd_flag) as stop_wtd_flag -- 全额止付标志
    ,nvl(n.system_use_flag, o.system_use_flag) as system_use_flag -- 是否系统专用标志
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.restraint_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.restraint_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.restraint_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_restraint_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_restraint_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.restraint_type = n.restraint_type
where (
        o.restraint_type is null
    )
    or (
        n.restraint_type is null
    )
    or (
        o.ah_bu_flag <> n.ah_bu_flag
        or o.company <> n.company
        or o.eod_impound_flag <> n.eod_impound_flag
        or o.manual_res_flag <> n.manual_res_flag
        or o.manual_unres_flag <> n.manual_unres_flag
        or o.res_priority <> n.res_priority
        or o.restraint_class <> n.restraint_class
        or o.restraint_type_desc <> n.restraint_type_desc
        or o.stop_wtd_flag <> n.stop_wtd_flag
        or o.system_use_flag <> n.system_use_flag
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_restraint_type_cl(
            restraint_type -- 限制类型
            ,ah_bu_flag -- 是否有权机关冻结
            ,company -- 法人
            ,eod_impound_flag -- eod扣款标志
            ,manual_res_flag -- 手工冻结标志
            ,manual_unres_flag -- 手工解冻标志
            ,res_priority -- 冻结级别
            ,restraint_class -- 限制类型类别
            ,restraint_type_desc -- 限制类型描述
            ,stop_wtd_flag -- 全额止付标志
            ,system_use_flag -- 是否系统专用标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_restraint_type_op(
            restraint_type -- 限制类型
            ,ah_bu_flag -- 是否有权机关冻结
            ,company -- 法人
            ,eod_impound_flag -- eod扣款标志
            ,manual_res_flag -- 手工冻结标志
            ,manual_unres_flag -- 手工解冻标志
            ,res_priority -- 冻结级别
            ,restraint_class -- 限制类型类别
            ,restraint_type_desc -- 限制类型描述
            ,stop_wtd_flag -- 全额止付标志
            ,system_use_flag -- 是否系统专用标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.restraint_type -- 限制类型
    ,o.ah_bu_flag -- 是否有权机关冻结
    ,o.company -- 法人
    ,o.eod_impound_flag -- eod扣款标志
    ,o.manual_res_flag -- 手工冻结标志
    ,o.manual_unres_flag -- 手工解冻标志
    ,o.res_priority -- 冻结级别
    ,o.restraint_class -- 限制类型类别
    ,o.restraint_type_desc -- 限制类型描述
    ,o.stop_wtd_flag -- 全额止付标志
    ,o.system_use_flag -- 是否系统专用标志
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
from ${iol_schema}.ncbs_fm_restraint_type_bk o
    left join ${iol_schema}.ncbs_fm_restraint_type_op n
        on
            o.restraint_type = n.restraint_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_restraint_type_cl d
        on
            o.restraint_type = d.restraint_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_restraint_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_restraint_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_restraint_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_restraint_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_restraint_type exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_restraint_type_cl;
alter table ${iol_schema}.ncbs_fm_restraint_type exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_restraint_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_restraint_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_restraint_type_op purge;
drop table ${iol_schema}.ncbs_fm_restraint_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_restraint_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_restraint_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
