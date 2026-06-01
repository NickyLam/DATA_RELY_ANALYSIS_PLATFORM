/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ptl_portfolio
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
create table ${iol_schema}.fams_ptl_portfolio_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ptl_portfolio
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_portfolio_op purge;
drop table ${iol_schema}.fams_ptl_portfolio_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_portfolio_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_portfolio where 0=1;

create table ${iol_schema}.fams_ptl_portfolio_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_portfolio where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_portfolio_cl(
            portfolio_id -- 组合代码
            ,portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
            ,portfolio_name -- 组合名称
            ,vdate -- 组合开始日
            ,mdate -- 组合结束日
            ,profit_type -- 收益类型，预期收益型/净值型/货币型
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,income_flag -- 是否保本
            ,remark -- 备注
            ,parent_portfolio_id -- 母组合代码
            ,invest_yesorno -- 是否能投资
            ,inv_trans_portf -- 所属投资过渡组合
            ,risk_enabled -- 是否启用风险
            ,ccy -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_portfolio_op(
            portfolio_id -- 组合代码
            ,portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
            ,portfolio_name -- 组合名称
            ,vdate -- 组合开始日
            ,mdate -- 组合结束日
            ,profit_type -- 收益类型，预期收益型/净值型/货币型
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,income_flag -- 是否保本
            ,remark -- 备注
            ,parent_portfolio_id -- 母组合代码
            ,invest_yesorno -- 是否能投资
            ,inv_trans_portf -- 所属投资过渡组合
            ,risk_enabled -- 是否启用风险
            ,ccy -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 组合代码
    ,nvl(n.portfolio_type, o.portfolio_type) as portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 组合名称
    ,nvl(n.vdate, o.vdate) as vdate -- 组合开始日
    ,nvl(n.mdate, o.mdate) as mdate -- 组合结束日
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 收益类型，预期收益型/净值型/货币型
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.income_flag, o.income_flag) as income_flag -- 是否保本
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.parent_portfolio_id, o.parent_portfolio_id) as parent_portfolio_id -- 母组合代码
    ,nvl(n.invest_yesorno, o.invest_yesorno) as invest_yesorno -- 是否能投资
    ,nvl(n.inv_trans_portf, o.inv_trans_portf) as inv_trans_portf -- 所属投资过渡组合
    ,nvl(n.risk_enabled, o.risk_enabled) as risk_enabled -- 是否启用风险
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,case when
            n.portfolio_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.portfolio_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.portfolio_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ptl_portfolio_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ptl_portfolio where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.portfolio_id = n.portfolio_id
where (
        o.portfolio_id is null
    )
    or (
        n.portfolio_id is null
    )
    or (
        o.portfolio_type <> n.portfolio_type
        or o.portfolio_name <> n.portfolio_name
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.profit_type <> n.profit_type
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.income_flag <> n.income_flag
        or o.remark <> n.remark
        or o.parent_portfolio_id <> n.parent_portfolio_id
        or o.invest_yesorno <> n.invest_yesorno
        or o.inv_trans_portf <> n.inv_trans_portf
        or o.risk_enabled <> n.risk_enabled
        or o.ccy <> n.ccy
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_portfolio_cl(
            portfolio_id -- 组合代码
            ,portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
            ,portfolio_name -- 组合名称
            ,vdate -- 组合开始日
            ,mdate -- 组合结束日
            ,profit_type -- 收益类型，预期收益型/净值型/货币型
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,income_flag -- 是否保本
            ,remark -- 备注
            ,parent_portfolio_id -- 母组合代码
            ,invest_yesorno -- 是否能投资
            ,inv_trans_portf -- 所属投资过渡组合
            ,risk_enabled -- 是否启用风险
            ,ccy -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_portfolio_op(
            portfolio_id -- 组合代码
            ,portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
            ,portfolio_name -- 组合名称
            ,vdate -- 组合开始日
            ,mdate -- 组合结束日
            ,profit_type -- 收益类型，预期收益型/净值型/货币型
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,income_flag -- 是否保本
            ,remark -- 备注
            ,parent_portfolio_id -- 母组合代码
            ,invest_yesorno -- 是否能投资
            ,inv_trans_portf -- 所属投资过渡组合
            ,risk_enabled -- 是否启用风险
            ,ccy -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.portfolio_id -- 组合代码
    ,o.portfolio_type -- 组合类型，管理组合、投资组合、资金单元、过渡组合
    ,o.portfolio_name -- 组合名称
    ,o.vdate -- 组合开始日
    ,o.mdate -- 组合结束日
    ,o.profit_type -- 收益类型，预期收益型/净值型/货币型
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.income_flag -- 是否保本
    ,o.remark -- 备注
    ,o.parent_portfolio_id -- 母组合代码
    ,o.invest_yesorno -- 是否能投资
    ,o.inv_trans_portf -- 所属投资过渡组合
    ,o.risk_enabled -- 是否启用风险
    ,o.ccy -- 币种
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
from ${iol_schema}.fams_ptl_portfolio_bk o
    left join ${iol_schema}.fams_ptl_portfolio_op n
        on
            o.portfolio_id = n.portfolio_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ptl_portfolio_cl d
        on
            o.portfolio_id = d.portfolio_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ptl_portfolio;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ptl_portfolio') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ptl_portfolio drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ptl_portfolio add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ptl_portfolio exchange partition p_${batch_date} with table ${iol_schema}.fams_ptl_portfolio_cl;
alter table ${iol_schema}.fams_ptl_portfolio exchange partition p_20991231 with table ${iol_schema}.fams_ptl_portfolio_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ptl_portfolio to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_portfolio_op purge;
drop table ${iol_schema}.fams_ptl_portfolio_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ptl_portfolio_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ptl_portfolio',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
