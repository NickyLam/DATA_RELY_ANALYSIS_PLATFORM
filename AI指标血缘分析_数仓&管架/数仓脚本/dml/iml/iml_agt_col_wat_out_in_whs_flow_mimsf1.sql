/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_col_wat_out_in_whs_flow_mimsf1
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
alter table ${iml_schema}.agt_col_wat_out_in_whs_flow add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_wat_out_in_whs_flow partition for ('mimsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op purge;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_wat_out_in_whs_flow partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_wat_out_in_whs_flow partition for ('mimsf1') where 0=1;

create table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_wat_out_in_whs_flow partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_guarwarrants_inner_wfs-
insert into ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '231031'||P1.BUSINESSINSID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BUSINESSINSID -- 业务编号
    ,P1.GUARID -- 押品编号
    ,P1.CONTRACTNO -- 合同编号
    ,NVL(TRIM(P1.STATE),'-') -- 流程状态代码
    ,P1.ASSCONTNO -- 担保合同编号
    ,P1.DEPARTCODE -- 下级机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_guarwarrants_inner_wfs' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_guarwarrants_inner_wfs p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.subor_org_id, o.subor_org_id) as subor_org_id -- 下级机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.col_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.col_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.col_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_tm n
    full join (select * from ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.col_id = n.col_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.col_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.col_id is null
    )
    or (
        o.bus_id <> n.bus_id
        or o.cont_id <> n.cont_id
        or o.flow_status_cd <> n.flow_status_cd
        or o.guar_cont_id <> n.guar_cont_id
        or o.subor_org_id <> n.subor_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,col_id -- 押品编号
    ,cont_id -- 合同编号
    ,flow_status_cd -- 流程状态代码
    ,guar_cont_id -- 担保合同编号
    ,subor_org_id -- 下级机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.bus_id -- 业务编号
    ,o.col_id -- 押品编号
    ,o.cont_id -- 合同编号
    ,o.flow_status_cd -- 流程状态代码
    ,o.guar_cont_id -- 担保合同编号
    ,o.subor_org_id -- 下级机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_bk o
    left join ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.col_id = n.col_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.col_id = d.col_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_col_wat_out_in_whs_flow;
alter table ${iml_schema}.agt_col_wat_out_in_whs_flow truncate partition for ('mimsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_col_wat_out_in_whs_flow exchange subpartition p_mimsf1_19000101 with table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl;
alter table ${iml_schema}.agt_col_wat_out_in_whs_flow exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_col_wat_out_in_whs_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_tm purge;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_op purge;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_col_wat_out_in_whs_flow_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_col_wat_out_in_whs_flow', partname => 'p_mimsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
