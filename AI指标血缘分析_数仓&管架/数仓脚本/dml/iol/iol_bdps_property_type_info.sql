/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_property_type_info
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
create table ${iol_schema}.bdps_property_type_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_property_type_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_type_info_op purge;
drop table ${iol_schema}.bdps_property_type_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_type_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_type_info where 0=1;

create table ${iol_schema}.bdps_property_type_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_type_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_type_info_cl(
            id -- 
            ,property_type -- 资产种类
            ,pledge_rate -- 质押率
            ,risk_level -- 风险级别     1-  低 2-  中3-  高
            ,effective_date -- 生效日期
            ,valid_flag -- 是否有效   0-无效 1-有效
            ,max_pledge_amt -- 最高质押规模
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,detail_type -- 详细类型 1-保本理财 2-非保本理财
            ,quota_type -- 额度类型 1-低风险额度 2-敞口额度"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_type_info_op(
            id -- 
            ,property_type -- 资产种类
            ,pledge_rate -- 质押率
            ,risk_level -- 风险级别     1-  低 2-  中3-  高
            ,effective_date -- 生效日期
            ,valid_flag -- 是否有效   0-无效 1-有效
            ,max_pledge_amt -- 最高质押规模
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,detail_type -- 详细类型 1-保本理财 2-非保本理财
            ,quota_type -- 额度类型 1-低风险额度 2-敞口额度"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.property_type, o.property_type) as property_type -- 资产种类
    ,nvl(n.pledge_rate, o.pledge_rate) as pledge_rate -- 质押率
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险级别     1-  低 2-  中3-  高
    ,nvl(n.effective_date, o.effective_date) as effective_date -- 生效日期
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 是否有效   0-无效 1-有效
    ,nvl(n.max_pledge_amt, o.max_pledge_amt) as max_pledge_amt -- 最高质押规模
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后更新操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构ID
    ,nvl(n.detail_type, o.detail_type) as detail_type -- 详细类型 1-保本理财 2-非保本理财
    ,nvl(n.quota_type, o.quota_type) as quota_type -- 额度类型 1-低风险额度 2-敞口额度"
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_property_type_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_property_type_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.property_type <> n.property_type
        or o.pledge_rate <> n.pledge_rate
        or o.risk_level <> n.risk_level
        or o.effective_date <> n.effective_date
        or o.valid_flag <> n.valid_flag
        or o.max_pledge_amt <> n.max_pledge_amt
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.remark <> n.remark
        or o.branch_id <> n.branch_id
        or o.detail_type <> n.detail_type
        or o.quota_type <> n.quota_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_type_info_cl(
            id -- 
            ,property_type -- 资产种类
            ,pledge_rate -- 质押率
            ,risk_level -- 风险级别     1-  低 2-  中3-  高
            ,effective_date -- 生效日期
            ,valid_flag -- 是否有效   0-无效 1-有效
            ,max_pledge_amt -- 最高质押规模
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,detail_type -- 详细类型 1-保本理财 2-非保本理财
            ,quota_type -- 额度类型 1-低风险额度 2-敞口额度"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_type_info_op(
            id -- 
            ,property_type -- 资产种类
            ,pledge_rate -- 质押率
            ,risk_level -- 风险级别     1-  低 2-  中3-  高
            ,effective_date -- 生效日期
            ,valid_flag -- 是否有效   0-无效 1-有效
            ,max_pledge_amt -- 最高质押规模
            ,last_upd_oper_id -- 最后更新操作员
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,branch_id -- 机构ID
            ,detail_type -- 详细类型 1-保本理财 2-非保本理财
            ,quota_type -- 额度类型 1-低风险额度 2-敞口额度"
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.property_type -- 资产种类
    ,o.pledge_rate -- 质押率
    ,o.risk_level -- 风险级别     1-  低 2-  中3-  高
    ,o.effective_date -- 生效日期
    ,o.valid_flag -- 是否有效   0-无效 1-有效
    ,o.max_pledge_amt -- 最高质押规模
    ,o.last_upd_oper_id -- 最后更新操作员
    ,o.last_upd_time -- 最后更新时间
    ,o.remark -- 备注
    ,o.branch_id -- 机构ID
    ,o.detail_type -- 详细类型 1-保本理财 2-非保本理财
    ,o.quota_type -- 额度类型 1-低风险额度 2-敞口额度"
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_property_type_info_bk o
    left join ${iol_schema}.bdps_property_type_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_property_type_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_property_type_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_property_type_info exchange partition p_19000101 with table ${iol_schema}.bdps_property_type_info_cl;
alter table ${iol_schema}.bdps_property_type_info exchange partition p_20991231 with table ${iol_schema}.bdps_property_type_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_property_type_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_type_info_op purge;
drop table ${iol_schema}.bdps_property_type_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_property_type_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_property_type_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
