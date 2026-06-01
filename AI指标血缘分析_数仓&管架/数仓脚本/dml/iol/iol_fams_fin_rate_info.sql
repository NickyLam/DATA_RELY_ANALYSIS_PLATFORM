/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_rate_info
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
create table ${iol_schema}.fams_fin_rate_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_rate_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_rate_info_op purge;
drop table ${iol_schema}.fams_fin_rate_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_rate_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_rate_info where 0=1;

create table ${iol_schema}.fams_fin_rate_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_rate_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_rate_info_cl(
            cash_id -- 现金流代码
            ,eff_date -- 生效日
            ,int_type -- 利率类型
            ,basis -- 计息基础，a/360，a/365等
            ,reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
            ,reset_freq -- 重置频率，针对固定频率重置，目前无
            ,first_reset_date -- 首次重置日，针对固定频率重置，目前无
            ,reset_date -- 指定重置日期，针对指定日期重置，目前无
            ,observe_bef_day -- 提前观察数量，所有重置类型都有
            ,observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
            ,rate -- 初始利率
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,highest_rate -- 利率上限
            ,lowest_rate -- 利率下限
            ,benchmark_id -- 基准编号
            ,benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,first_confirm_date -- 首期利率确定日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_rate_info_op(
            cash_id -- 现金流代码
            ,eff_date -- 生效日
            ,int_type -- 利率类型
            ,basis -- 计息基础，a/360，a/365等
            ,reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
            ,reset_freq -- 重置频率，针对固定频率重置，目前无
            ,first_reset_date -- 首次重置日，针对固定频率重置，目前无
            ,reset_date -- 指定重置日期，针对指定日期重置，目前无
            ,observe_bef_day -- 提前观察数量，所有重置类型都有
            ,observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
            ,rate -- 初始利率
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,highest_rate -- 利率上限
            ,lowest_rate -- 利率下限
            ,benchmark_id -- 基准编号
            ,benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,first_confirm_date -- 首期利率确定日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_id, o.cash_id) as cash_id -- 现金流代码
    ,nvl(n.eff_date, o.eff_date) as eff_date -- 生效日
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.basis, o.basis) as basis -- 计息基础，a/360，a/365等
    ,nvl(n.reset_type, o.reset_type) as reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
    ,nvl(n.reset_freq, o.reset_freq) as reset_freq -- 重置频率，针对固定频率重置，目前无
    ,nvl(n.first_reset_date, o.first_reset_date) as first_reset_date -- 首次重置日，针对固定频率重置，目前无
    ,nvl(n.reset_date, o.reset_date) as reset_date -- 指定重置日期，针对指定日期重置，目前无
    ,nvl(n.observe_bef_day, o.observe_bef_day) as observe_bef_day -- 提前观察数量，所有重置类型都有
    ,nvl(n.observe_bef_unit, o.observe_bef_unit) as observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
    ,nvl(n.rate, o.rate) as rate -- 初始利率
    ,nvl(n.coefficient, o.coefficient) as coefficient -- 系数
    ,nvl(n.spread_rate, o.spread_rate) as spread_rate -- 利差
    ,nvl(n.highest_rate, o.highest_rate) as highest_rate -- 利率上限
    ,nvl(n.lowest_rate, o.lowest_rate) as lowest_rate -- 利率下限
    ,nvl(n.benchmark_id, o.benchmark_id) as benchmark_id -- 基准编号
    ,nvl(n.benchmark_type, o.benchmark_type) as benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.first_confirm_date, o.first_confirm_date) as first_confirm_date -- 首期利率确定日
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_rate_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_rate_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_id = n.cash_id
            and o.eff_date = n.eff_date
where (
        o.cash_id is null
        and o.eff_date is null
    )
    or (
        n.cash_id is null
        and n.eff_date is null
    )
    or (
        o.int_type <> n.int_type
        or o.basis <> n.basis
        or o.reset_type <> n.reset_type
        or o.reset_freq <> n.reset_freq
        or o.first_reset_date <> n.first_reset_date
        or o.reset_date <> n.reset_date
        or o.observe_bef_day <> n.observe_bef_day
        or o.observe_bef_unit <> n.observe_bef_unit
        or o.rate <> n.rate
        or o.coefficient <> n.coefficient
        or o.spread_rate <> n.spread_rate
        or o.highest_rate <> n.highest_rate
        or o.lowest_rate <> n.lowest_rate
        or o.benchmark_id <> n.benchmark_id
        or o.benchmark_type <> n.benchmark_type
        or o.finprod_id <> n.finprod_id
        or o.branch <> n.branch
        or o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.first_confirm_date <> n.first_confirm_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_rate_info_cl(
            cash_id -- 现金流代码
            ,eff_date -- 生效日
            ,int_type -- 利率类型
            ,basis -- 计息基础，a/360，a/365等
            ,reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
            ,reset_freq -- 重置频率，针对固定频率重置，目前无
            ,first_reset_date -- 首次重置日，针对固定频率重置，目前无
            ,reset_date -- 指定重置日期，针对指定日期重置，目前无
            ,observe_bef_day -- 提前观察数量，所有重置类型都有
            ,observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
            ,rate -- 初始利率
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,highest_rate -- 利率上限
            ,lowest_rate -- 利率下限
            ,benchmark_id -- 基准编号
            ,benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,first_confirm_date -- 首期利率确定日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_rate_info_op(
            cash_id -- 现金流代码
            ,eff_date -- 生效日
            ,int_type -- 利率类型
            ,basis -- 计息基础，a/360，a/365等
            ,reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
            ,reset_freq -- 重置频率，针对固定频率重置，目前无
            ,first_reset_date -- 首次重置日，针对固定频率重置，目前无
            ,reset_date -- 指定重置日期，针对指定日期重置，目前无
            ,observe_bef_day -- 提前观察数量，所有重置类型都有
            ,observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
            ,rate -- 初始利率
            ,coefficient -- 系数
            ,spread_rate -- 利差
            ,highest_rate -- 利率上限
            ,lowest_rate -- 利率下限
            ,benchmark_id -- 基准编号
            ,benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
            ,finprod_id -- 金融产品代码
            ,branch -- 分支序号
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,first_confirm_date -- 首期利率确定日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_id -- 现金流代码
    ,o.eff_date -- 生效日
    ,o.int_type -- 利率类型
    ,o.basis -- 计息基础，a/360，a/365等
    ,o.reset_type -- 重置类型，基准利率变动后固定间隔生效、付息后下一计息期生效
    ,o.reset_freq -- 重置频率，针对固定频率重置，目前无
    ,o.first_reset_date -- 首次重置日，针对固定频率重置，目前无
    ,o.reset_date -- 指定重置日期，针对指定日期重置，目前无
    ,o.observe_bef_day -- 提前观察数量，所有重置类型都有
    ,o.observe_bef_unit -- 提前观察单位，自然日、工作日、自然月等
    ,o.rate -- 初始利率
    ,o.coefficient -- 系数
    ,o.spread_rate -- 利差
    ,o.highest_rate -- 利率上限
    ,o.lowest_rate -- 利率下限
    ,o.benchmark_id -- 基准编号
    ,o.benchmark_type -- 基准类型，复合基准、利率行情、指数行情、曲线
    ,o.finprod_id -- 金融产品代码
    ,o.branch -- 分支序号
    ,o.finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.first_confirm_date -- 首期利率确定日
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
from ${iol_schema}.fams_fin_rate_info_bk o
    left join ${iol_schema}.fams_fin_rate_info_op n
        on
            o.cash_id = n.cash_id
            and o.eff_date = n.eff_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_rate_info_cl d
        on
            o.cash_id = d.cash_id
            and o.eff_date = d.eff_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_fin_rate_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_fin_rate_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_fin_rate_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_fin_rate_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_fin_rate_info exchange partition p_${batch_date} with table ${iol_schema}.fams_fin_rate_info_cl;
alter table ${iol_schema}.fams_fin_rate_info exchange partition p_20991231 with table ${iol_schema}.fams_fin_rate_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_rate_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_rate_info_op purge;
drop table ${iol_schema}.fams_fin_rate_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_rate_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_rate_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
