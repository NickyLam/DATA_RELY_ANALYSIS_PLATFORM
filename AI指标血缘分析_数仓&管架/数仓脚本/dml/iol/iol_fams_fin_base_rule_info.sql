/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_base_rule_info
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
create table ${iol_schema}.fams_fin_base_rule_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_base_rule_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_base_rule_info_op purge;
drop table ${iol_schema}.fams_fin_base_rule_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_base_rule_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_base_rule_info where 0=1;

create table ${iol_schema}.fams_fin_base_rule_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_base_rule_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_base_rule_info_cl(
            base_rule_id -- 业绩基准代码，同金融产品代码
            ,eff_date -- 生效日期
            ,rate_type -- 利率类型
            ,rate -- 初始利率
            ,index_id -- 基准编号
            ,index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,reset_type -- 重置规则，期初、期末等
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
            ,publish_type -- 业绩基准披露类型，区间披露，单点披露
            ,rate_lower -- 利率下限
            ,rate_limit -- 利率上限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_base_rule_info_op(
            base_rule_id -- 业绩基准代码，同金融产品代码
            ,eff_date -- 生效日期
            ,rate_type -- 利率类型
            ,rate -- 初始利率
            ,index_id -- 基准编号
            ,index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,reset_type -- 重置规则，期初、期末等
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
            ,publish_type -- 业绩基准披露类型，区间披露，单点披露
            ,rate_lower -- 利率下限
            ,rate_limit -- 利率上限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_rule_id, o.base_rule_id) as base_rule_id -- 业绩基准代码，同金融产品代码
    ,nvl(n.eff_date, o.eff_date) as eff_date -- 生效日期
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率类型
    ,nvl(n.rate, o.rate) as rate -- 初始利率
    ,nvl(n.index_id, o.index_id) as index_id -- 基准编号
    ,nvl(n.index_source, o.index_source) as index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
    ,nvl(n.coefficient, o.coefficient) as coefficient -- 系数
    ,nvl(n.spread_rate, o.spread_rate) as spread_rate -- 利差
    ,nvl(n.reset_type, o.reset_type) as reset_type -- 重置规则，期初、期末等
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.base_rule_type, o.base_rule_type) as base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
    ,nvl(n.publish_type, o.publish_type) as publish_type -- 业绩基准披露类型，区间披露，单点披露
    ,nvl(n.rate_lower, o.rate_lower) as rate_lower -- 利率下限
    ,nvl(n.rate_limit, o.rate_limit) as rate_limit -- 利率上限
    ,case when
            n.base_rule_id is null
            and n.eff_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_rule_id is null
            and n.eff_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_rule_id is null
            and n.eff_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_base_rule_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_base_rule_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_rule_id = n.base_rule_id
            and o.eff_date = n.eff_date
where (
        o.base_rule_id is null
        and o.eff_date is null
    )
    or (
        n.base_rule_id is null
        and n.eff_date is null
    )
    or (
        o.rate_type <> n.rate_type
        or o.rate <> n.rate
        or o.index_id <> n.index_id
        or o.index_source <> n.index_source
        or o.coefficient <> n.coefficient
        or o.spread_rate <> n.spread_rate
        or o.reset_type <> n.reset_type
        or o.finprod_id <> n.finprod_id
        or o.branch <> n.branch
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.base_rule_type <> n.base_rule_type
        or o.publish_type <> n.publish_type
        or o.rate_lower <> n.rate_lower
        or o.rate_limit <> n.rate_limit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_base_rule_info_cl(
            base_rule_id -- 业绩基准代码，同金融产品代码
            ,eff_date -- 生效日期
            ,rate_type -- 利率类型
            ,rate -- 初始利率
            ,index_id -- 基准编号
            ,index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,reset_type -- 重置规则，期初、期末等
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
            ,publish_type -- 业绩基准披露类型，区间披露，单点披露
            ,rate_lower -- 利率下限
            ,rate_limit -- 利率上限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_base_rule_info_op(
            base_rule_id -- 业绩基准代码，同金融产品代码
            ,eff_date -- 生效日期
            ,rate_type -- 利率类型
            ,rate -- 初始利率
            ,index_id -- 基准编号
            ,index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,reset_type -- 重置规则，期初、期末等
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
            ,publish_type -- 业绩基准披露类型，区间披露，单点披露
            ,rate_lower -- 利率下限
            ,rate_limit -- 利率上限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_rule_id -- 业绩基准代码，同金融产品代码
    ,o.eff_date -- 生效日期
    ,o.rate_type -- 利率类型
    ,o.rate -- 初始利率
    ,o.index_id -- 基准编号
    ,o.index_source -- 基准来源，复合基准、利率行情、指数行情、曲线
    ,o.coefficient -- 系数
    ,o.spread_rate -- 利差
    ,o.reset_type -- 重置规则，期初、期末等
    ,o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.base_rule_type -- 业绩基准类型,产品披露，浮动管理费，业绩回补
    ,o.publish_type -- 业绩基准披露类型，区间披露，单点披露
    ,o.rate_lower -- 利率下限
    ,o.rate_limit -- 利率上限
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
from ${iol_schema}.fams_fin_base_rule_info_bk o
    left join ${iol_schema}.fams_fin_base_rule_info_op n
        on
            o.base_rule_id = n.base_rule_id
            and o.eff_date = n.eff_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_base_rule_info_cl d
        on
            o.base_rule_id = d.base_rule_id
            and o.eff_date = d.eff_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_fin_base_rule_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_fin_base_rule_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_fin_base_rule_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_fin_base_rule_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_fin_base_rule_info exchange partition p_${batch_date} with table ${iol_schema}.fams_fin_base_rule_info_cl;
alter table ${iol_schema}.fams_fin_base_rule_info exchange partition p_20991231 with table ${iol_schema}.fams_fin_base_rule_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_base_rule_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_base_rule_info_op purge;
drop table ${iol_schema}.fams_fin_base_rule_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_base_rule_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_base_rule_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
