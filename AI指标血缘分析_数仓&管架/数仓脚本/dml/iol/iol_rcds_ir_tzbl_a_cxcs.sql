/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_a_cxcs
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
create table ${iol_schema}.rcds_ir_tzbl_a_cxcs_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_tzbl_a_cxcs;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_cxcs_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_cxcs where 0=1;

create table ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_tzbl_a_cxcs where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
            ,a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
            ,a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
            ,a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_cxcs_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
            ,a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
            ,a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
            ,a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.a_freq_query_24m_ca, o.a_freq_query_24m_ca) as a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
    ,nvl(n.a_freq_query_24m_tot, o.a_freq_query_24m_tot) as a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
    ,nvl(n.a_freq_query_12m_ca, o.a_freq_query_12m_ca) as a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
    ,nvl(n.a_freq_query_12m_tot, o.a_freq_query_12m_tot) as a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
    ,nvl(n.a_freq_query_3m_ca, o.a_freq_query_3m_ca) as a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
    ,nvl(n.a_freq_query_3m_tot, o.a_freq_query_3m_tot) as a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
    ,nvl(n.a_freq_query_6m_ca, o.a_freq_query_6m_ca) as a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
    ,nvl(n.a_freq_query_6m_tot, o.a_freq_query_6m_tot) as a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
    ,case when
            n.grade_key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_tzbl_a_cxcs_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_tzbl_a_cxcs where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.data_time <> n.data_time
        or o.serialno <> n.serialno
        or o.create_time <> n.create_time
        or o.a_freq_query_24m_ca <> n.a_freq_query_24m_ca
        or o.a_freq_query_24m_tot <> n.a_freq_query_24m_tot
        or o.a_freq_query_12m_ca <> n.a_freq_query_12m_ca
        or o.a_freq_query_12m_tot <> n.a_freq_query_12m_tot
        or o.a_freq_query_3m_ca <> n.a_freq_query_3m_ca
        or o.a_freq_query_3m_tot <> n.a_freq_query_3m_tot
        or o.a_freq_query_6m_ca <> n.a_freq_query_6m_ca
        or o.a_freq_query_6m_tot <> n.a_freq_query_6m_tot
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
            ,a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
            ,a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
            ,a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_tzbl_a_cxcs_op(
            grade_key_id -- 申请评分流水号
            ,data_time -- 数据记录时间
            ,serialno -- 申请流水号
            ,create_time -- 创建时间
            ,a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
            ,a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
            ,a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
            ,a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
            ,a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
            ,a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
            ,a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
            ,a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.data_time -- 数据记录时间
    ,o.serialno -- 申请流水号
    ,o.create_time -- 创建时间
    ,o.a_freq_query_24m_ca -- 主申人查询过去24个月信贷审核查询次数
    ,o.a_freq_query_24m_tot -- 主申人查询过去24个月查询总次数
    ,o.a_freq_query_12m_ca -- 主申人查询过去12个月信贷审核查询次数
    ,o.a_freq_query_12m_tot -- 主申人查询过去12个月查询总次数
    ,o.a_freq_query_3m_ca -- 主申人查询过去3个月信贷审核查询次数
    ,o.a_freq_query_3m_tot -- 主申人查询过去3个月查询总次数
    ,o.a_freq_query_6m_ca -- 主申人查询过去6个月信贷审核查询次数
    ,o.a_freq_query_6m_tot -- 主申人查询过去6个月查询总次数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_tzbl_a_cxcs_bk o
    left join ${iol_schema}.rcds_ir_tzbl_a_cxcs_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl d
        on
            o.grade_key_id = d.grade_key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_tzbl_a_cxcs;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_tzbl_a_cxcs exchange partition p_19000101 with table ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl;
alter table ${iol_schema}.rcds_ir_tzbl_a_cxcs exchange partition p_20991231 with table ${iol_schema}.rcds_ir_tzbl_a_cxcs_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_a_cxcs to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs_op purge;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_tzbl_a_cxcs_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_a_cxcs',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
