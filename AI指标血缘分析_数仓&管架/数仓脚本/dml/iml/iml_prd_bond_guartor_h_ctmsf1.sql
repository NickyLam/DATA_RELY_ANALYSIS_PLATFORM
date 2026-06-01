/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_guartor_h_ctmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_guartor_h add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_guartor_h_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_guartor_h partition for ('ctmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_guartor_h_ctmsf1_tm nologging
compress ${option_switch} for query high
as select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_guartor_h partition for ('ctmsf1')
where 0=1
;

create table ${iml_schema}.prd_bond_guartor_h_ctmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_guartor_h partition for ('ctmsf1') where 0=1;

create table ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_guartor_h partition for ('ctmsf1') where 0=1;

-- 3.1 get new data into table
-- ctms_tbs_v_security_guarantee-
insert into ${iml_schema}.prd_bond_guartor_h_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.SEQ) -- 序号
    ,P1.CID -- 担保人编号
    ,P1.CNAME -- 担保人名称
    ,P1.PARTS -- 担保份额
    ,P1.I_OR_G -- 担保人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_security_guarantee' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_security_guarantee p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_guartor_h_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.guartor_id, o.guartor_id) as guartor_id -- 担保人编号
    ,nvl(n.guartor_name, o.guartor_name) as guartor_name -- 担保人名称
    ,nvl(n.guar_lot, o.guar_lot) as guar_lot -- 担保份额
    ,nvl(n.guartor_type_cd, o.guartor_type_cd) as guartor_type_cd -- 担保人类型代码
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.seq_num is null
            and n.guartor_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.seq_num is null
            and n.guartor_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.seq_num is null
            and n.guartor_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_guartor_h_ctmsf1_tm n
    full join (select * from ${iml_schema}.prd_bond_guartor_h_ctmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.guartor_id = n.guartor_id
where (
        o.bond_id is null
        and o.lp_id is null
        and o.seq_num is null
        and o.guartor_id is null
    )
    or (
        n.bond_id is null
        and n.lp_id is null
        and n.seq_num is null
        and n.guartor_id is null
    )
    or (
        o.guartor_name <> n.guartor_name
        or o.guar_lot <> n.guar_lot
        or o.guartor_type_cd <> n.guartor_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_guartor_h_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,guartor_id -- 担保人编号
    ,guartor_name -- 担保人名称
    ,guar_lot -- 担保份额
    ,guartor_type_cd -- 担保人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bond_id -- 债券编号
    ,o.lp_id -- 法人编号
    ,o.seq_num -- 序号
    ,o.guartor_id -- 担保人编号
    ,o.guartor_name -- 担保人名称
    ,o.guar_lot -- 担保份额
    ,o.guartor_type_cd -- 担保人类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_guartor_h_ctmsf1_bk o
    left join ${iml_schema}.prd_bond_guartor_h_ctmsf1_op n
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.seq_num = n.seq_num
            and o.guartor_id = n.guartor_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl d
        on
            o.bond_id = d.bond_id
            and o.lp_id = d.lp_id
            and o.seq_num = d.seq_num
            and o.guartor_id = d.guartor_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_bond_guartor_h;
alter table ${iml_schema}.prd_bond_guartor_h truncate partition for ('ctmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_bond_guartor_h exchange subpartition p_ctmsf1_19000101 with table ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl;
alter table ${iml_schema}.prd_bond_guartor_h exchange subpartition p_ctmsf1_20991231 with table ${iml_schema}.prd_bond_guartor_h_ctmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_guartor_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_bond_guartor_h_ctmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_guartor_h', partname => 'p_ctmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
