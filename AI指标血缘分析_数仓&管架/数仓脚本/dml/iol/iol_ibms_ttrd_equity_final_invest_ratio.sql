/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_equity_final_invest_ratio
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
create table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_equity_final_invest_ratio
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_final_invest_ratio where 0=1;

create table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_equity_final_invest_ratio where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl(
            id -- 序号
            ,final_invest_type -- 最终投向类型（穿透底层）
            ,weight -- 权重(%)
            ,date_explain -- 数据项说明
            ,asset_class -- 映射资本新规基础资产品种或资产中类
            ,parent_id -- 所属分类id
            ,invest_ratio_flag -- 当期投资金额占比是否只读：1只读
            ,grade_flag -- 评级是否只读：1只读
            ,grade_type -- 评级类型
            ,low_prop_flag -- 合同中的最低投资比例是否只读：1只读
            ,high_prop_flag -- 合同中的最高投资是否只读：1只读
            ,weight_flag -- 权重是否只读：1只读
            ,style_level -- 1-加粗 2-空1格 3-空2格
            ,remark -- 备注
            ,relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
            ,node_type -- 几类节点  1 一类项   2 二类项 3 三类项
            ,grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op(
            id -- 序号
            ,final_invest_type -- 最终投向类型（穿透底层）
            ,weight -- 权重(%)
            ,date_explain -- 数据项说明
            ,asset_class -- 映射资本新规基础资产品种或资产中类
            ,parent_id -- 所属分类id
            ,invest_ratio_flag -- 当期投资金额占比是否只读：1只读
            ,grade_flag -- 评级是否只读：1只读
            ,grade_type -- 评级类型
            ,low_prop_flag -- 合同中的最低投资比例是否只读：1只读
            ,high_prop_flag -- 合同中的最高投资是否只读：1只读
            ,weight_flag -- 权重是否只读：1只读
            ,style_level -- 1-加粗 2-空1格 3-空2格
            ,remark -- 备注
            ,relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
            ,node_type -- 几类节点  1 一类项   2 二类项 3 三类项
            ,grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 序号
    ,nvl(n.final_invest_type, o.final_invest_type) as final_invest_type -- 最终投向类型（穿透底层）
    ,nvl(n.weight, o.weight) as weight -- 权重(%)
    ,nvl(n.date_explain, o.date_explain) as date_explain -- 数据项说明
    ,nvl(n.asset_class, o.asset_class) as asset_class -- 映射资本新规基础资产品种或资产中类
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 所属分类id
    ,nvl(n.invest_ratio_flag, o.invest_ratio_flag) as invest_ratio_flag -- 当期投资金额占比是否只读：1只读
    ,nvl(n.grade_flag, o.grade_flag) as grade_flag -- 评级是否只读：1只读
    ,nvl(n.grade_type, o.grade_type) as grade_type -- 评级类型
    ,nvl(n.low_prop_flag, o.low_prop_flag) as low_prop_flag -- 合同中的最低投资比例是否只读：1只读
    ,nvl(n.high_prop_flag, o.high_prop_flag) as high_prop_flag -- 合同中的最高投资是否只读：1只读
    ,nvl(n.weight_flag, o.weight_flag) as weight_flag -- 权重是否只读：1只读
    ,nvl(n.style_level, o.style_level) as style_level -- 1-加粗 2-空1格 3-空2格
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.relate_ratio_grade, o.relate_ratio_grade) as relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
    ,nvl(n.node_type, o.node_type) as node_type -- 几类节点  1 一类项   2 二类项 3 三类项
    ,nvl(n.grade_required, o.grade_required) as grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
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
from (select * from ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_equity_final_invest_ratio where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.final_invest_type <> n.final_invest_type
        or o.weight <> n.weight
        or o.date_explain <> n.date_explain
        or o.asset_class <> n.asset_class
        or o.parent_id <> n.parent_id
        or o.invest_ratio_flag <> n.invest_ratio_flag
        or o.grade_flag <> n.grade_flag
        or o.grade_type <> n.grade_type
        or o.low_prop_flag <> n.low_prop_flag
        or o.high_prop_flag <> n.high_prop_flag
        or o.weight_flag <> n.weight_flag
        or o.style_level <> n.style_level
        or o.remark <> n.remark
        or o.relate_ratio_grade <> n.relate_ratio_grade
        or o.node_type <> n.node_type
        or o.grade_required <> n.grade_required
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl(
            id -- 序号
            ,final_invest_type -- 最终投向类型（穿透底层）
            ,weight -- 权重(%)
            ,date_explain -- 数据项说明
            ,asset_class -- 映射资本新规基础资产品种或资产中类
            ,parent_id -- 所属分类id
            ,invest_ratio_flag -- 当期投资金额占比是否只读：1只读
            ,grade_flag -- 评级是否只读：1只读
            ,grade_type -- 评级类型
            ,low_prop_flag -- 合同中的最低投资比例是否只读：1只读
            ,high_prop_flag -- 合同中的最高投资是否只读：1只读
            ,weight_flag -- 权重是否只读：1只读
            ,style_level -- 1-加粗 2-空1格 3-空2格
            ,remark -- 备注
            ,relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
            ,node_type -- 几类节点  1 一类项   2 二类项 3 三类项
            ,grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op(
            id -- 序号
            ,final_invest_type -- 最终投向类型（穿透底层）
            ,weight -- 权重(%)
            ,date_explain -- 数据项说明
            ,asset_class -- 映射资本新规基础资产品种或资产中类
            ,parent_id -- 所属分类id
            ,invest_ratio_flag -- 当期投资金额占比是否只读：1只读
            ,grade_flag -- 评级是否只读：1只读
            ,grade_type -- 评级类型
            ,low_prop_flag -- 合同中的最低投资比例是否只读：1只读
            ,high_prop_flag -- 合同中的最高投资是否只读：1只读
            ,weight_flag -- 权重是否只读：1只读
            ,style_level -- 1-加粗 2-空1格 3-空2格
            ,remark -- 备注
            ,relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
            ,node_type -- 几类节点  1 一类项   2 二类项 3 三类项
            ,grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 序号
    ,o.final_invest_type -- 最终投向类型（穿透底层）
    ,o.weight -- 权重(%)
    ,o.date_explain -- 数据项说明
    ,o.asset_class -- 映射资本新规基础资产品种或资产中类
    ,o.parent_id -- 所属分类id
    ,o.invest_ratio_flag -- 当期投资金额占比是否只读：1只读
    ,o.grade_flag -- 评级是否只读：1只读
    ,o.grade_type -- 评级类型
    ,o.low_prop_flag -- 合同中的最低投资比例是否只读：1只读
    ,o.high_prop_flag -- 合同中的最高投资是否只读：1只读
    ,o.weight_flag -- 权重是否只读：1只读
    ,o.style_level -- 1-加粗 2-空1格 3-空2格
    ,o.remark -- 备注
    ,o.relate_ratio_grade -- 评级和权重是否存在联动,1-是 0-否
    ,o.node_type -- 几类节点  1 一类项   2 二类项 3 三类项
    ,o.grade_required -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
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
from ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_bk o
    left join ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_equity_final_invest_ratio') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl;
alter table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_equity_final_invest_ratio to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_op purge;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_equity_final_invest_ratio',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
