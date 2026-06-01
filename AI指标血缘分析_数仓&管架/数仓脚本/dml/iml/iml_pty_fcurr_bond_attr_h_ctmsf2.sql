/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_fcurr_bond_attr_h_ctmsf2
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
alter table ${iml_schema}.pty_fcurr_bond_attr_h add partition p_ctmsf2 values ('ctmsf2')(
        subpartition p_ctmsf2_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsf2_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fcurr_bond_attr_h partition for ('ctmsf2')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_tm purge;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op purge;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fcurr_bond_attr_h partition for ('ctmsf2')
where 0=1
;

create table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fcurr_bond_attr_h partition for ('ctmsf2') where 0=1;

create table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fcurr_bond_attr_h partition for ('ctmsf2') where 0=1;

-- 3.1 get new data into table
-- ctms_v_rms_cptys_udflist-1
insert into ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101005'||P1.ENTYID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.UDF_CODE -- 属性名称
    ,P1.UDF_DESC -- 属性描述
    ,P1.UDF_VALUE -- 属性值
    ,P1.UDF_VALUEDESC -- 属性值描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_rms_cptys_udflist' -- 源表名称
    ,'ctmsf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.attr_name, o.attr_name) as attr_name -- 属性名称
    ,nvl(n.attr_descb, o.attr_descb) as attr_descb -- 属性描述
    ,nvl(n.attr_val, o.attr_val) as attr_val -- 属性值
    ,nvl(n.attr_val_descb, o.attr_val_descb) as attr_val_descb -- 属性值描述
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.attr_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_tm n
    full join (select * from ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.attr_name = n.attr_name
where (
        o.party_id is null
        and o.lp_id is null
        and o.attr_name is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.attr_name is null
    )
    or (
        o.attr_descb <> n.attr_descb
        or o.attr_val <> n.attr_val
        or o.attr_val_descb <> n.attr_val_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,attr_name -- 属性名称
    ,attr_descb -- 属性描述
    ,attr_val -- 属性值
    ,attr_val_descb -- 属性值描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.attr_name -- 属性名称
    ,o.attr_descb -- 属性描述
    ,o.attr_val -- 属性值
    ,o.attr_val_descb -- 属性值描述
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_bk o
    left join ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.attr_name = n.attr_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.attr_name = d.attr_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_fcurr_bond_attr_h;
alter table ${iml_schema}.pty_fcurr_bond_attr_h truncate partition for ('ctmsf2') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_fcurr_bond_attr_h exchange subpartition p_ctmsf2_19000101 with table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl;
alter table ${iml_schema}.pty_fcurr_bond_attr_h exchange subpartition p_ctmsf2_20991231 with table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_fcurr_bond_attr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_tm purge;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_op purge;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_fcurr_bond_attr_h_ctmsf2_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_fcurr_bond_attr_h', partname => 'p_ctmsf2_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
