/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_org_int_org_rela_h_isbsf1
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
alter table ${iml_schema}.org_int_org_rela_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.org_int_org_rela_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_rela_h partition for ('isbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_tm purge;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_op purge;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_int_org_rela_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_rela_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.org_int_org_rela_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_rela_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.org_int_org_rela_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_rela_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_bch
insert into ${iml_schema}.org_int_org_rela_h_isbsf1_tm(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BRANCH -- 机构编号
    ,'9999' -- 法人编号
    ,'ISBS' -- 源系统代码
    ,'12' -- 机构关系类型代码
    ,P1.INR -- 序号
    ,P1.BCHKEY -- 关联机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_bch' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_bch p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.org_int_org_rela_h_isbsf1_cl(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.org_int_org_rela_h_isbsf1_op(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.src_sys_cd, o.src_sys_cd) as src_sys_cd -- 源系统代码
    ,nvl(n.org_rela_type_cd, o.org_rela_type_cd) as org_rela_type_cd -- 机构关系类型代码
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.rela_org_id, o.rela_org_id) as rela_org_id -- 关联机构编号
    ,case when
            n.org_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.org_rela_type_cd is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.org_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.org_rela_type_cd is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.org_id is null
            and n.lp_id is null
            and n.src_sys_cd is null
            and n.org_rela_type_cd is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_rela_h_isbsf1_tm n
    full join (select * from ${iml_schema}.org_int_org_rela_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
            and o.src_sys_cd = n.src_sys_cd
            and o.org_rela_type_cd = n.org_rela_type_cd
            and o.seq_num = n.seq_num
where (
        o.org_id is null
        and o.lp_id is null
        and o.src_sys_cd is null
        and o.org_rela_type_cd is null
        and o.seq_num is null
    )
    or (
        n.org_id is null
        and n.lp_id is null
        and n.src_sys_cd is null
        and n.org_rela_type_cd is null
        and n.seq_num is null
    )
    or (
        o.rela_org_id <> n.rela_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.org_int_org_rela_h_isbsf1_cl(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.org_int_org_rela_h_isbsf1_op(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,src_sys_cd -- 源系统代码
    ,org_rela_type_cd -- 机构关系类型代码
    ,seq_num -- 序号
    ,rela_org_id -- 关联机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org_id -- 机构编号
    ,o.lp_id -- 法人编号
    ,o.src_sys_cd -- 源系统代码
    ,o.org_rela_type_cd -- 机构关系类型代码
    ,o.seq_num -- 序号
    ,o.rela_org_id -- 关联机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_rela_h_isbsf1_bk o
    left join ${iml_schema}.org_int_org_rela_h_isbsf1_op n
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
            and o.src_sys_cd = n.src_sys_cd
            and o.org_rela_type_cd = n.org_rela_type_cd
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.org_int_org_rela_h_isbsf1_cl d
        on
            o.org_id = d.org_id
            and o.lp_id = d.lp_id
            and o.src_sys_cd = d.src_sys_cd
            and o.org_rela_type_cd = d.org_rela_type_cd
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.org_int_org_rela_h;
alter table ${iml_schema}.org_int_org_rela_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.org_int_org_rela_h exchange subpartition p_isbsf1_19000101 with table ${iml_schema}.org_int_org_rela_h_isbsf1_cl;
alter table ${iml_schema}.org_int_org_rela_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.org_int_org_rela_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.org_int_org_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_tm purge;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_op purge;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.org_int_org_rela_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'org_int_org_rela_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
