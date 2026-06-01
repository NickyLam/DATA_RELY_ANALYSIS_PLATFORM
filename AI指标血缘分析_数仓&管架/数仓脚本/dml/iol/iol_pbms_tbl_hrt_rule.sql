/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_hrt_rule
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
create table ${iol_schema}.pbms_tbl_hrt_rule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_hrt_rule
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_hrt_rule_op purge;
drop table ${iol_schema}.pbms_tbl_hrt_rule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_hrt_rule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_hrt_rule where 0=1;

create table ${iol_schema}.pbms_tbl_hrt_rule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_hrt_rule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_hrt_rule_cl(
            pk_hrt_rule -- 主键
            ,activity_code -- 活动代码
            ,rule_name -- 规则名称
            ,stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
            ,window_days -- 观察期天数，如30天内
            ,min_value -- 下限值
            ,include_min -- 是否包含下限：0-不含，1-含
            ,max_value -- 上限值，为空或null则为无上限
            ,include_max -- 是否包含上限：0-不含，1-含
            ,unit -- 单位：0-元，1-万元，2-百万元
            ,effective_begin -- 生效时间
            ,effective_end -- 失效时间
            ,status -- 状态：0-未启用，1-启用
            ,remark -- 备注
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,give_bonus -- 赠送积分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_hrt_rule_op(
            pk_hrt_rule -- 主键
            ,activity_code -- 活动代码
            ,rule_name -- 规则名称
            ,stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
            ,window_days -- 观察期天数，如30天内
            ,min_value -- 下限值
            ,include_min -- 是否包含下限：0-不含，1-含
            ,max_value -- 上限值，为空或null则为无上限
            ,include_max -- 是否包含上限：0-不含，1-含
            ,unit -- 单位：0-元，1-万元，2-百万元
            ,effective_begin -- 生效时间
            ,effective_end -- 失效时间
            ,status -- 状态：0-未启用，1-启用
            ,remark -- 备注
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,give_bonus -- 赠送积分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_hrt_rule, o.pk_hrt_rule) as pk_hrt_rule -- 主键
    ,nvl(n.activity_code, o.activity_code) as activity_code -- 活动代码
    ,nvl(n.rule_name, o.rule_name) as rule_name -- 规则名称
    ,nvl(n.stat_item, o.stat_item) as stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
    ,nvl(n.window_days, o.window_days) as window_days -- 观察期天数，如30天内
    ,nvl(n.min_value, o.min_value) as min_value -- 下限值
    ,nvl(n.include_min, o.include_min) as include_min -- 是否包含下限：0-不含，1-含
    ,nvl(n.max_value, o.max_value) as max_value -- 上限值，为空或null则为无上限
    ,nvl(n.include_max, o.include_max) as include_max -- 是否包含上限：0-不含，1-含
    ,nvl(n.unit, o.unit) as unit -- 单位：0-元，1-万元，2-百万元
    ,nvl(n.effective_begin, o.effective_begin) as effective_begin -- 生效时间
    ,nvl(n.effective_end, o.effective_end) as effective_end -- 失效时间
    ,nvl(n.status, o.status) as status -- 状态：0-未启用，1-启用
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人，系统创建写system
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人，系统创建写system
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,nvl(n.give_bonus, o.give_bonus) as give_bonus -- 赠送积分
    ,case when
            n.pk_hrt_rule is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_hrt_rule is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_hrt_rule is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_hrt_rule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_hrt_rule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_hrt_rule = n.pk_hrt_rule
where (
        o.pk_hrt_rule is null
    )
    or (
        n.pk_hrt_rule is null
    )
    or (
        o.activity_code <> n.activity_code
        or o.rule_name <> n.rule_name
        or o.stat_item <> n.stat_item
        or o.window_days <> n.window_days
        or o.min_value <> n.min_value
        or o.include_min <> n.include_min
        or o.max_value <> n.max_value
        or o.include_max <> n.include_max
        or o.unit <> n.unit
        or o.effective_begin <> n.effective_begin
        or o.effective_end <> n.effective_end
        or o.status <> n.status
        or o.remark <> n.remark
        or o.created_by <> n.created_by
        or o.create_time <> n.create_time
        or o.updated_by <> n.updated_by
        or o.update_time <> n.update_time
        or o.del_flag <> n.del_flag
        or o.give_bonus <> n.give_bonus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_hrt_rule_cl(
            pk_hrt_rule -- 主键
            ,activity_code -- 活动代码
            ,rule_name -- 规则名称
            ,stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
            ,window_days -- 观察期天数，如30天内
            ,min_value -- 下限值
            ,include_min -- 是否包含下限：0-不含，1-含
            ,max_value -- 上限值，为空或null则为无上限
            ,include_max -- 是否包含上限：0-不含，1-含
            ,unit -- 单位：0-元，1-万元，2-百万元
            ,effective_begin -- 生效时间
            ,effective_end -- 失效时间
            ,status -- 状态：0-未启用，1-启用
            ,remark -- 备注
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,give_bonus -- 赠送积分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_hrt_rule_op(
            pk_hrt_rule -- 主键
            ,activity_code -- 活动代码
            ,rule_name -- 规则名称
            ,stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
            ,window_days -- 观察期天数，如30天内
            ,min_value -- 下限值
            ,include_min -- 是否包含下限：0-不含，1-含
            ,max_value -- 上限值，为空或null则为无上限
            ,include_max -- 是否包含上限：0-不含，1-含
            ,unit -- 单位：0-元，1-万元，2-百万元
            ,effective_begin -- 生效时间
            ,effective_end -- 失效时间
            ,status -- 状态：0-未启用，1-启用
            ,remark -- 备注
            ,created_by -- 创建人，系统创建写system
            ,create_time -- 创建时间
            ,updated_by -- 更新人，系统创建写system
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,give_bonus -- 赠送积分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_hrt_rule -- 主键
    ,o.activity_code -- 活动代码
    ,o.rule_name -- 规则名称
    ,o.stat_item -- 统计指标，例如 last_month_avg_asset上月日均资产、daily_avg_asset每天资产
    ,o.window_days -- 观察期天数，如30天内
    ,o.min_value -- 下限值
    ,o.include_min -- 是否包含下限：0-不含，1-含
    ,o.max_value -- 上限值，为空或null则为无上限
    ,o.include_max -- 是否包含上限：0-不含，1-含
    ,o.unit -- 单位：0-元，1-万元，2-百万元
    ,o.effective_begin -- 生效时间
    ,o.effective_end -- 失效时间
    ,o.status -- 状态：0-未启用，1-启用
    ,o.remark -- 备注
    ,o.created_by -- 创建人，系统创建写system
    ,o.create_time -- 创建时间
    ,o.updated_by -- 更新人，系统创建写system
    ,o.update_time -- 更新时间
    ,o.del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,o.give_bonus -- 赠送积分
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
from ${iol_schema}.pbms_tbl_hrt_rule_bk o
    left join ${iol_schema}.pbms_tbl_hrt_rule_op n
        on
            o.pk_hrt_rule = n.pk_hrt_rule
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_hrt_rule_cl d
        on
            o.pk_hrt_rule = d.pk_hrt_rule
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_hrt_rule;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_hrt_rule') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_hrt_rule drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_hrt_rule add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_hrt_rule exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_hrt_rule_cl;
alter table ${iol_schema}.pbms_tbl_hrt_rule exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_hrt_rule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_hrt_rule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_hrt_rule_op purge;
drop table ${iol_schema}.pbms_tbl_hrt_rule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_hrt_rule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_hrt_rule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
