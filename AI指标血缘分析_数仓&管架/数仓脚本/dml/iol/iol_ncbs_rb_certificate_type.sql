/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_certificate_type
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
create table ${iol_schema}.ncbs_rb_certificate_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_certificate_type
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_certificate_type_op purge;
drop table ${iol_schema}.ncbs_rb_certificate_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_certificate_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_certificate_type where 0=1;

create table ${iol_schema}.ncbs_rb_certificate_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_certificate_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_certificate_type_cl(
            user_id -- 交易柜员编号
            ,certificate_type -- 产权证明种类
            ,certificate_type_desc -- 产权证明种类描述
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_certificate_type_op(
            user_id -- 交易柜员编号
            ,certificate_type -- 产权证明种类
            ,certificate_type_desc -- 产权证明种类描述
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.certificate_type, o.certificate_type) as certificate_type -- 产权证明种类
    ,nvl(n.certificate_type_desc, o.certificate_type_desc) as certificate_type_desc -- 产权证明种类描述
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,case when
            n.certificate_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.certificate_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.certificate_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_certificate_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_certificate_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.certificate_type = n.certificate_type
where (
        o.certificate_type is null
    )
    or (
        n.certificate_type is null
    )
    or (
        o.user_id <> n.user_id
        or o.certificate_type_desc <> n.certificate_type_desc
        or o.company <> n.company
        or o.libra_op_time <> n.libra_op_time
        or o.last_change_date <> n.last_change_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_certificate_type_cl(
            user_id -- 交易柜员编号
            ,certificate_type -- 产权证明种类
            ,certificate_type_desc -- 产权证明种类描述
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_certificate_type_op(
            user_id -- 交易柜员编号
            ,certificate_type -- 产权证明种类
            ,certificate_type_desc -- 产权证明种类描述
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 交易柜员编号
    ,o.certificate_type -- 产权证明种类
    ,o.certificate_type_desc -- 产权证明种类描述
    ,o.company -- 法人
    ,o.libra_op_time -- libra执行次数
    ,o.last_change_date -- 最后修改日期
    ,o.tran_date -- 交易日期
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
from ${iol_schema}.ncbs_rb_certificate_type_bk o
    left join ${iol_schema}.ncbs_rb_certificate_type_op n
        on
            o.certificate_type = n.certificate_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_certificate_type_cl d
        on
            o.certificate_type = d.certificate_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_certificate_type;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_certificate_type') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_certificate_type drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_certificate_type add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_certificate_type exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_certificate_type_cl;
alter table ${iol_schema}.ncbs_rb_certificate_type exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_certificate_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_certificate_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_certificate_type_op purge;
drop table ${iol_schema}.ncbs_rb_certificate_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_certificate_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_certificate_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
