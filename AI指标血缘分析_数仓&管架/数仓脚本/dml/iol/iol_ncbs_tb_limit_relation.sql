/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_limit_relation
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
create table ${iol_schema}.ncbs_tb_limit_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_limit_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_limit_relation_op purge;
drop table ${iol_schema}.ncbs_tb_limit_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_limit_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_limit_relation where 0=1;

create table ${iol_schema}.ncbs_tb_limit_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_limit_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_limit_relation_cl(
            remark -- 备注
            ,company -- 法人
            ,ctrl_id -- 控制编号
            ,cv_flag -- 现金/凭证标志
            ,lm_rela_type -- 限额关系分类
            ,lm_rela_object_id -- 限额关系对象id
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,branch -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_limit_relation_op(
            remark -- 备注
            ,company -- 法人
            ,ctrl_id -- 控制编号
            ,cv_flag -- 现金/凭证标志
            ,lm_rela_type -- 限额关系分类
            ,lm_rela_object_id -- 限额关系对象id
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,branch -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.ctrl_id, o.ctrl_id) as ctrl_id -- 控制编号
    ,nvl(n.cv_flag, o.cv_flag) as cv_flag -- 现金/凭证标志
    ,nvl(n.lm_rela_type, o.lm_rela_type) as lm_rela_type -- 限额关系分类
    ,nvl(n.lm_rela_object_id, o.lm_rela_object_id) as lm_rela_object_id -- 限额关系对象id
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.branch, o.branch) as branch -- 交易机构编号
    ,case when
            n.cv_flag is null
            and n.lm_rela_type is null
            and n.lm_rela_object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cv_flag is null
            and n.lm_rela_type is null
            and n.lm_rela_object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cv_flag is null
            and n.lm_rela_type is null
            and n.lm_rela_object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_limit_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_limit_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cv_flag = n.cv_flag
            and o.lm_rela_type = n.lm_rela_type
            and o.lm_rela_object_id = n.lm_rela_object_id
where (
        o.cv_flag is null
        and o.lm_rela_type is null
        and o.lm_rela_object_id is null
    )
    or (
        n.cv_flag is null
        and n.lm_rela_type is null
        and n.lm_rela_object_id is null
    )
    or (
        o.remark <> n.remark
        or o.company <> n.company
        or o.ctrl_id <> n.ctrl_id
        or o.effect_date <> n.effect_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.branch <> n.branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_limit_relation_cl(
            remark -- 备注
            ,company -- 法人
            ,ctrl_id -- 控制编号
            ,cv_flag -- 现金/凭证标志
            ,lm_rela_type -- 限额关系分类
            ,lm_rela_object_id -- 限额关系对象id
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,branch -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_limit_relation_op(
            remark -- 备注
            ,company -- 法人
            ,ctrl_id -- 控制编号
            ,cv_flag -- 现金/凭证标志
            ,lm_rela_type -- 限额关系分类
            ,lm_rela_object_id -- 限额关系对象id
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,branch -- 交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.remark -- 备注
    ,o.company -- 法人
    ,o.ctrl_id -- 控制编号
    ,o.cv_flag -- 现金/凭证标志
    ,o.lm_rela_type -- 限额关系分类
    ,o.lm_rela_object_id -- 限额关系对象id
    ,o.effect_date -- 产品生效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.branch -- 交易机构编号
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
from ${iol_schema}.ncbs_tb_limit_relation_bk o
    left join ${iol_schema}.ncbs_tb_limit_relation_op n
        on
            o.cv_flag = n.cv_flag
            and o.lm_rela_type = n.lm_rela_type
            and o.lm_rela_object_id = n.lm_rela_object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_limit_relation_cl d
        on
            o.cv_flag = d.cv_flag
            and o.lm_rela_type = d.lm_rela_type
            and o.lm_rela_object_id = d.lm_rela_object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_limit_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_limit_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_limit_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_limit_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_limit_relation exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_limit_relation_cl;
alter table ${iol_schema}.ncbs_tb_limit_relation exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_limit_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_limit_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_limit_relation_op purge;
drop table ${iol_schema}.ncbs_tb_limit_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_limit_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_limit_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
