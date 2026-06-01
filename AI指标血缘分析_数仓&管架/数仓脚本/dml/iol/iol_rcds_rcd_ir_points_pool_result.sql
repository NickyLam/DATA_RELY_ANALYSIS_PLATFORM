/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_rcd_ir_points_pool_result
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
create table ${iol_schema}.rcds_rcd_ir_points_pool_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_rcd_ir_points_pool_result;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_rcd_ir_points_pool_result_op purge;
drop table ${iol_schema}.rcds_rcd_ir_points_pool_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_rcd_ir_points_pool_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_rcd_ir_points_pool_result where 0=1;

create table ${iol_schema}.rcds_rcd_ir_points_pool_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_rcd_ir_points_pool_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_rcd_ir_points_pool_result_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,grade_key_id -- 申请评分流水号
            ,data_dt -- 数据时间
            ,pd -- 违约率PD
            ,pd_ci_1 -- -95%CI(PD)
            ,pd_ci_2 -- +95%CI(PD)
            ,lgd -- 违约损失率LGD
            ,lgd_ci_1 -- 95%CI-(LGD)
            ,lgd_ci_2 -- 95%CI+(LGD)
            ,pool_type -- 分池模型
            ,mode_type -- 评分模型类型
            ,pd_logical_deteil -- PD逻辑描述
            ,lgd_logical_deteil -- LGD逻辑描述
            ,pd_average -- 长期平均PD
            ,lgd_average -- 长期平均LGD
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_rcd_ir_points_pool_result_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,grade_key_id -- 申请评分流水号
            ,data_dt -- 数据时间
            ,pd -- 违约率PD
            ,pd_ci_1 -- -95%CI(PD)
            ,pd_ci_2 -- +95%CI(PD)
            ,lgd -- 违约损失率LGD
            ,lgd_ci_1 -- 95%CI-(LGD)
            ,lgd_ci_2 -- 95%CI+(LGD)
            ,pool_type -- 分池模型
            ,mode_type -- 评分模型类型
            ,pd_logical_deteil -- PD逻辑描述
            ,lgd_logical_deteil -- LGD逻辑描述
            ,pd_average -- 长期平均PD
            ,lgd_average -- 长期平均LGD
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 借据号
    ,nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 数据时间
    ,nvl(n.pd, o.pd) as pd -- 违约率PD
    ,nvl(n.pd_ci_1, o.pd_ci_1) as pd_ci_1 -- -95%CI(PD)
    ,nvl(n.pd_ci_2, o.pd_ci_2) as pd_ci_2 -- +95%CI(PD)
    ,nvl(n.lgd, o.lgd) as lgd -- 违约损失率LGD
    ,nvl(n.lgd_ci_1, o.lgd_ci_1) as lgd_ci_1 -- 95%CI-(LGD)
    ,nvl(n.lgd_ci_2, o.lgd_ci_2) as lgd_ci_2 -- 95%CI+(LGD)
    ,nvl(n.pool_type, o.pool_type) as pool_type -- 分池模型
    ,nvl(n.mode_type, o.mode_type) as mode_type -- 评分模型类型
    ,nvl(n.pd_logical_deteil, o.pd_logical_deteil) as pd_logical_deteil -- PD逻辑描述
    ,nvl(n.lgd_logical_deteil, o.lgd_logical_deteil) as lgd_logical_deteil -- LGD逻辑描述
    ,nvl(n.pd_average, o.pd_average) as pd_average -- 长期平均PD
    ,nvl(n.lgd_average, o.lgd_average) as lgd_average -- 长期平均LGD
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_rcd_ir_points_pool_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_rcd_ir_points_pool_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.loan_no <> n.loan_no
        or o.grade_key_id <> n.grade_key_id
        or o.data_dt <> n.data_dt
        or o.pd <> n.pd
        or o.pd_ci_1 <> n.pd_ci_1
        or o.pd_ci_2 <> n.pd_ci_2
        or o.lgd <> n.lgd
        or o.lgd_ci_1 <> n.lgd_ci_1
        or o.lgd_ci_2 <> n.lgd_ci_2
        or o.pool_type <> n.pool_type
        or o.mode_type <> n.mode_type
        or o.pd_logical_deteil <> n.pd_logical_deteil
        or o.lgd_logical_deteil <> n.lgd_logical_deteil
        or o.pd_average <> n.pd_average
        or o.lgd_average <> n.lgd_average
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_rcd_ir_points_pool_result_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,grade_key_id -- 申请评分流水号
            ,data_dt -- 数据时间
            ,pd -- 违约率PD
            ,pd_ci_1 -- -95%CI(PD)
            ,pd_ci_2 -- +95%CI(PD)
            ,lgd -- 违约损失率LGD
            ,lgd_ci_1 -- 95%CI-(LGD)
            ,lgd_ci_2 -- 95%CI+(LGD)
            ,pool_type -- 分池模型
            ,mode_type -- 评分模型类型
            ,pd_logical_deteil -- PD逻辑描述
            ,lgd_logical_deteil -- LGD逻辑描述
            ,pd_average -- 长期平均PD
            ,lgd_average -- 长期平均LGD
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_rcd_ir_points_pool_result_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,grade_key_id -- 申请评分流水号
            ,data_dt -- 数据时间
            ,pd -- 违约率PD
            ,pd_ci_1 -- -95%CI(PD)
            ,pd_ci_2 -- +95%CI(PD)
            ,lgd -- 违约损失率LGD
            ,lgd_ci_1 -- 95%CI-(LGD)
            ,lgd_ci_2 -- 95%CI+(LGD)
            ,pool_type -- 分池模型
            ,mode_type -- 评分模型类型
            ,pd_logical_deteil -- PD逻辑描述
            ,lgd_logical_deteil -- LGD逻辑描述
            ,pd_average -- 长期平均PD
            ,lgd_average -- 长期平均LGD
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.loan_no -- 借据号
    ,o.grade_key_id -- 申请评分流水号
    ,o.data_dt -- 数据时间
    ,o.pd -- 违约率PD
    ,o.pd_ci_1 -- -95%CI(PD)
    ,o.pd_ci_2 -- +95%CI(PD)
    ,o.lgd -- 违约损失率LGD
    ,o.lgd_ci_1 -- 95%CI-(LGD)
    ,o.lgd_ci_2 -- 95%CI+(LGD)
    ,o.pool_type -- 分池模型
    ,o.mode_type -- 评分模型类型
    ,o.pd_logical_deteil -- PD逻辑描述
    ,o.lgd_logical_deteil -- LGD逻辑描述
    ,o.pd_average -- 长期平均PD
    ,o.lgd_average -- 长期平均LGD
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_rcd_ir_points_pool_result_bk o
    left join ${iol_schema}.rcds_rcd_ir_points_pool_result_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_rcd_ir_points_pool_result_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_rcd_ir_points_pool_result;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_rcd_ir_points_pool_result exchange partition p_19000101 with table ${iol_schema}.rcds_rcd_ir_points_pool_result_cl;
alter table ${iol_schema}.rcds_rcd_ir_points_pool_result exchange partition p_20991231 with table ${iol_schema}.rcds_rcd_ir_points_pool_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_rcd_ir_points_pool_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_rcd_ir_points_pool_result_op purge;
drop table ${iol_schema}.rcds_rcd_ir_points_pool_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_rcd_ir_points_pool_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_rcd_ir_points_pool_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
