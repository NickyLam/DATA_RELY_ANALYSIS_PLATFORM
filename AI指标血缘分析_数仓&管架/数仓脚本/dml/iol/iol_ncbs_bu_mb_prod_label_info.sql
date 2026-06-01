/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_bu_mb_prod_label_info
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
create table ${iol_schema}.ncbs_bu_mb_prod_label_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_bu_mb_prod_label_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info_op purge;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_bu_mb_prod_label_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_bu_mb_prod_label_info where 0=1;

create table ${iol_schema}.ncbs_bu_mb_prod_label_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_bu_mb_prod_label_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_bu_mb_prod_label_info_cl(
            seq_no -- 序号
            ,prod_type -- 产品编号
            ,label_key -- 标签键
            ,label_value -- 标签值
            ,label_value_desc -- 标签值描述
            ,om_dept_id -- 部门编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,user_id -- 交易柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_bu_mb_prod_label_info_op(
            seq_no -- 序号
            ,prod_type -- 产品编号
            ,label_key -- 标签键
            ,label_value -- 标签值
            ,label_value_desc -- 标签值描述
            ,om_dept_id -- 部门编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,user_id -- 交易柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.label_key, o.label_key) as label_key -- 标签键
    ,nvl(n.label_value, o.label_value) as label_value -- 标签值
    ,nvl(n.label_value_desc, o.label_value_desc) as label_value_desc -- 标签值描述
    ,nvl(n.om_dept_id, o.om_dept_id) as om_dept_id -- 部门编号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员
    ,case when
            n.seq_no is null
            and n.prod_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.prod_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.prod_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_bu_mb_prod_label_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_bu_mb_prod_label_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.prod_type = n.prod_type
where (
        o.seq_no is null
        and o.prod_type is null
    )
    or (
        n.seq_no is null
        and n.prod_type is null
    )
    or (
        o.label_key <> n.label_key
        or o.label_value <> n.label_value
        or o.label_value_desc <> n.label_value_desc
        or o.om_dept_id <> n.om_dept_id
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.user_id <> n.user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_bu_mb_prod_label_info_cl(
            seq_no -- 序号
            ,prod_type -- 产品编号
            ,label_key -- 标签键
            ,label_value -- 标签值
            ,label_value_desc -- 标签值描述
            ,om_dept_id -- 部门编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,user_id -- 交易柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_bu_mb_prod_label_info_op(
            seq_no -- 序号
            ,prod_type -- 产品编号
            ,label_key -- 标签键
            ,label_value -- 标签值
            ,label_value_desc -- 标签值描述
            ,om_dept_id -- 部门编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,user_id -- 交易柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_no -- 序号
    ,o.prod_type -- 产品编号
    ,o.label_key -- 标签键
    ,o.label_value -- 标签值
    ,o.label_value_desc -- 标签值描述
    ,o.om_dept_id -- 部门编号
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.user_id -- 交易柜员
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
from ${iol_schema}.ncbs_bu_mb_prod_label_info_bk o
    left join ${iol_schema}.ncbs_bu_mb_prod_label_info_op n
        on
            o.seq_no = n.seq_no
            and o.prod_type = n.prod_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_bu_mb_prod_label_info_cl d
        on
            o.seq_no = d.seq_no
            and o.prod_type = d.prod_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_bu_mb_prod_label_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_bu_mb_prod_label_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_bu_mb_prod_label_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_bu_mb_prod_label_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_bu_mb_prod_label_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_bu_mb_prod_label_info_cl;
alter table ${iol_schema}.ncbs_bu_mb_prod_label_info exchange partition p_20991231 with table ${iol_schema}.ncbs_bu_mb_prod_label_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_bu_mb_prod_label_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info_op purge;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_bu_mb_prod_label_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
