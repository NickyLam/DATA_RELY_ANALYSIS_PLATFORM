/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_om_apply_oa_relation
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
create table ${iol_schema}.ncbs_om_apply_oa_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_om_apply_oa_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_om_apply_oa_relation_op purge;
drop table ${iol_schema}.ncbs_om_apply_oa_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_om_apply_oa_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_om_apply_oa_relation where 0=1;

create table ${iol_schema}.ncbs_om_apply_oa_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_om_apply_oa_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_om_apply_oa_relation_cl(
            oa_approval_no -- OA审批单号
            ,om_apply_no -- 参数平台变更申请单号
            ,business_type -- 业务场景  0-产品目录维护
            ,start_timestamp -- 任务开始时间戳
            ,end_timestamp -- 任务结束时间戳
            ,om_user_id -- 操作用户
            ,deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
            ,deal_msg -- 处理信息
            ,param_code -- 目录代码|目录代码
            ,param_code_name -- 目录名称|目录名称
            ,effect_date -- 生效日期|生效日期
            ,expire_date -- 失效日期|失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_om_apply_oa_relation_op(
            oa_approval_no -- OA审批单号
            ,om_apply_no -- 参数平台变更申请单号
            ,business_type -- 业务场景  0-产品目录维护
            ,start_timestamp -- 任务开始时间戳
            ,end_timestamp -- 任务结束时间戳
            ,om_user_id -- 操作用户
            ,deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
            ,deal_msg -- 处理信息
            ,param_code -- 目录代码|目录代码
            ,param_code_name -- 目录名称|目录名称
            ,effect_date -- 生效日期|生效日期
            ,expire_date -- 失效日期|失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.oa_approval_no, o.oa_approval_no) as oa_approval_no -- OA审批单号
    ,nvl(n.om_apply_no, o.om_apply_no) as om_apply_no -- 参数平台变更申请单号
    ,nvl(n.business_type, o.business_type) as business_type -- 业务场景  0-产品目录维护
    ,nvl(n.start_timestamp, o.start_timestamp) as start_timestamp -- 任务开始时间戳
    ,nvl(n.end_timestamp, o.end_timestamp) as end_timestamp -- 任务结束时间戳
    ,nvl(n.om_user_id, o.om_user_id) as om_user_id -- 操作用户
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
    ,nvl(n.deal_msg, o.deal_msg) as deal_msg -- 处理信息
    ,nvl(n.param_code, o.param_code) as param_code -- 目录代码|目录代码
    ,nvl(n.param_code_name, o.param_code_name) as param_code_name -- 目录名称|目录名称
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 生效日期|生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期|失效日期
    ,case when
            n.oa_approval_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.oa_approval_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.oa_approval_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_om_apply_oa_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_om_apply_oa_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.oa_approval_no = n.oa_approval_no
where (
        o.oa_approval_no is null
    )
    or (
        n.oa_approval_no is null
    )
    or (
        o.om_apply_no <> n.om_apply_no
        or o.business_type <> n.business_type
        or o.start_timestamp <> n.start_timestamp
        or o.end_timestamp <> n.end_timestamp
        or o.om_user_id <> n.om_user_id
        or o.deal_status <> n.deal_status
        or o.deal_msg <> n.deal_msg
        or o.param_code <> n.param_code
        or o.param_code_name <> n.param_code_name
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_om_apply_oa_relation_cl(
            oa_approval_no -- OA审批单号
            ,om_apply_no -- 参数平台变更申请单号
            ,business_type -- 业务场景  0-产品目录维护
            ,start_timestamp -- 任务开始时间戳
            ,end_timestamp -- 任务结束时间戳
            ,om_user_id -- 操作用户
            ,deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
            ,deal_msg -- 处理信息
            ,param_code -- 目录代码|目录代码
            ,param_code_name -- 目录名称|目录名称
            ,effect_date -- 生效日期|生效日期
            ,expire_date -- 失效日期|失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_om_apply_oa_relation_op(
            oa_approval_no -- OA审批单号
            ,om_apply_no -- 参数平台变更申请单号
            ,business_type -- 业务场景  0-产品目录维护
            ,start_timestamp -- 任务开始时间戳
            ,end_timestamp -- 任务结束时间戳
            ,om_user_id -- 操作用户
            ,deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
            ,deal_msg -- 处理信息
            ,param_code -- 目录代码|目录代码
            ,param_code_name -- 目录名称|目录名称
            ,effect_date -- 生效日期|生效日期
            ,expire_date -- 失效日期|失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.oa_approval_no -- OA审批单号
    ,o.om_apply_no -- 参数平台变更申请单号
    ,o.business_type -- 业务场景  0-产品目录维护
    ,o.start_timestamp -- 任务开始时间戳
    ,o.end_timestamp -- 任务结束时间戳
    ,o.om_user_id -- 操作用户
    ,o.deal_status -- 处理状态  0-处理中,1-处理完成,2-处理失败
    ,o.deal_msg -- 处理信息
    ,o.param_code -- 目录代码|目录代码
    ,o.param_code_name -- 目录名称|目录名称
    ,o.effect_date -- 生效日期|生效日期
    ,o.expire_date -- 失效日期|失效日期
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
from ${iol_schema}.ncbs_om_apply_oa_relation_bk o
    left join ${iol_schema}.ncbs_om_apply_oa_relation_op n
        on
            o.oa_approval_no = n.oa_approval_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_om_apply_oa_relation_cl d
        on
            o.oa_approval_no = d.oa_approval_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_om_apply_oa_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_om_apply_oa_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_om_apply_oa_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_om_apply_oa_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_om_apply_oa_relation exchange partition p_${batch_date} with table ${iol_schema}.ncbs_om_apply_oa_relation_cl;
alter table ${iol_schema}.ncbs_om_apply_oa_relation exchange partition p_20991231 with table ${iol_schema}.ncbs_om_apply_oa_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_om_apply_oa_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_om_apply_oa_relation_op purge;
drop table ${iol_schema}.ncbs_om_apply_oa_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_om_apply_oa_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_om_apply_oa_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
