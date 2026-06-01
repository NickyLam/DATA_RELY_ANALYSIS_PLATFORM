/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_bond_resale_and_redemp_detail
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
create table ${iol_schema}.uxds_bond_resale_and_redemp_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uxds_bond_resale_and_redemp_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail_op purge;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_resale_and_redemp_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_resale_and_redemp_detail where 0=1;

create table ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_resale_and_redemp_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,bond_short_name -- 债券简称
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,fore_occurrence_date -- 预计发生日期
            ,price -- 价格
            ,notice_ed -- 告知截止日
            ,is_sure_to_exercise -- 是否确定行权
            ,is_actually_exercised -- 实际是否行权
            ,par_value -- 面值
            ,interest_rate -- 利息
            ,price_spe_ins -- 价格特殊说明
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_resale_and_redemp_detail_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,bond_short_name -- 债券简称
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,fore_occurrence_date -- 预计发生日期
            ,price -- 价格
            ,notice_ed -- 告知截止日
            ,is_sure_to_exercise -- 是否确定行权
            ,is_actually_exercised -- 实际是否行权
            ,par_value -- 面值
            ,interest_rate -- 利息
            ,price_spe_ins -- 价格特殊说明
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq, o.seq) as seq -- 记录唯一标识
    ,nvl(n.ctime, o.ctime) as ctime -- 记录创建日期
    ,nvl(n.mtime, o.mtime) as mtime -- 记录修改日期
    ,nvl(n.rtime, o.rtime) as rtime -- 记录通讯到用户端日期
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券id
    ,nvl(n.bond_short_name, o.bond_short_name) as bond_short_name -- 债券简称
    ,nvl(n.clause_type_code, o.clause_type_code) as clause_type_code -- 条款类型编码
    ,nvl(n.clause_type, o.clause_type) as clause_type -- 条款类型
    ,nvl(n.fore_occurrence_date, o.fore_occurrence_date) as fore_occurrence_date -- 预计发生日期
    ,nvl(n.price, o.price) as price -- 价格
    ,nvl(n.notice_ed, o.notice_ed) as notice_ed -- 告知截止日
    ,nvl(n.is_sure_to_exercise, o.is_sure_to_exercise) as is_sure_to_exercise -- 是否确定行权
    ,nvl(n.is_actually_exercised, o.is_actually_exercised) as is_actually_exercised -- 实际是否行权
    ,nvl(n.par_value, o.par_value) as par_value -- 面值
    ,nvl(n.interest_rate, o.interest_rate) as interest_rate -- 利息
    ,nvl(n.price_spe_ins, o.price_spe_ins) as price_spe_ins -- 价格特殊说明
    ,nvl(n.isvalid, o.isvalid) as isvalid -- 是否有效
    ,case when
            n.seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uxds_bond_resale_and_redemp_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uxds_bond_resale_and_redemp_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq = n.seq
where (
        o.seq is null
    )
    or (
        n.seq is null
    )
    or (
        o.ctime <> n.ctime
        or o.mtime <> n.mtime
        or o.rtime <> n.rtime
        or o.bond_id <> n.bond_id
        or o.bond_short_name <> n.bond_short_name
        or o.clause_type_code <> n.clause_type_code
        or o.clause_type <> n.clause_type
        or o.fore_occurrence_date <> n.fore_occurrence_date
        or o.price <> n.price
        or o.notice_ed <> n.notice_ed
        or o.is_sure_to_exercise <> n.is_sure_to_exercise
        or o.is_actually_exercised <> n.is_actually_exercised
        or o.par_value <> n.par_value
        or o.interest_rate <> n.interest_rate
        or o.price_spe_ins <> n.price_spe_ins
        or o.isvalid <> n.isvalid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,bond_short_name -- 债券简称
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,fore_occurrence_date -- 预计发生日期
            ,price -- 价格
            ,notice_ed -- 告知截止日
            ,is_sure_to_exercise -- 是否确定行权
            ,is_actually_exercised -- 实际是否行权
            ,par_value -- 面值
            ,interest_rate -- 利息
            ,price_spe_ins -- 价格特殊说明
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_resale_and_redemp_detail_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,bond_short_name -- 债券简称
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,fore_occurrence_date -- 预计发生日期
            ,price -- 价格
            ,notice_ed -- 告知截止日
            ,is_sure_to_exercise -- 是否确定行权
            ,is_actually_exercised -- 实际是否行权
            ,par_value -- 面值
            ,interest_rate -- 利息
            ,price_spe_ins -- 价格特殊说明
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq -- 记录唯一标识
    ,o.ctime -- 记录创建日期
    ,o.mtime -- 记录修改日期
    ,o.rtime -- 记录通讯到用户端日期
    ,o.bond_id -- 债券id
    ,o.bond_short_name -- 债券简称
    ,o.clause_type_code -- 条款类型编码
    ,o.clause_type -- 条款类型
    ,o.fore_occurrence_date -- 预计发生日期
    ,o.price -- 价格
    ,o.notice_ed -- 告知截止日
    ,o.is_sure_to_exercise -- 是否确定行权
    ,o.is_actually_exercised -- 实际是否行权
    ,o.par_value -- 面值
    ,o.interest_rate -- 利息
    ,o.price_spe_ins -- 价格特殊说明
    ,o.isvalid -- 是否有效
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
from ${iol_schema}.uxds_bond_resale_and_redemp_detail_bk o
    left join ${iol_schema}.uxds_bond_resale_and_redemp_detail_op n
        on
            o.seq = n.seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl d
        on
            o.seq = d.seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.uxds_bond_resale_and_redemp_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('uxds_bond_resale_and_redemp_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.uxds_bond_resale_and_redemp_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.uxds_bond_resale_and_redemp_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.uxds_bond_resale_and_redemp_detail exchange partition p_${batch_date} with table ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl;
alter table ${iol_schema}.uxds_bond_resale_and_redemp_detail exchange partition p_20991231 with table ${iol_schema}.uxds_bond_resale_and_redemp_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_bond_resale_and_redemp_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail_op purge;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uxds_bond_resale_and_redemp_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_bond_resale_and_redemp_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
