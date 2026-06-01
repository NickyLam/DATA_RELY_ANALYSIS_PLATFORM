/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ft_product
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
create table ${iol_schema}.nfss_ft_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_ft_product
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_product_op purge;
drop table ${iol_schema}.nfss_ft_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_product where 0=1;

create table ${iol_schema}.nfss_ft_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_product_cl(
            product_id -- 主键序号
            ,product_name -- 产品名称
            ,product_code -- 产品代码
            ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
            ,performance_status -- 业绩比较基准
            ,establishment_date -- 成立日
            ,termination_date -- 终止日
            ,product_status -- 产品状态 0募集，1成立，2终止
            ,purchase_amount -- 起购金额
            ,commencement_date -- 募集开始日
            ,closing_date -- 募集结束日
            ,init_amount -- 初始创立金额
            ,current_net_worth -- 当前净值
            ,current_market_value -- 当前市值
            ,trustcompany_code -- 信托公司代码
            ,trustcompany_name -- 信托公司名称
            ,product_sorted -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_product_op(
            product_id -- 主键序号
            ,product_name -- 产品名称
            ,product_code -- 产品代码
            ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
            ,performance_status -- 业绩比较基准
            ,establishment_date -- 成立日
            ,termination_date -- 终止日
            ,product_status -- 产品状态 0募集，1成立，2终止
            ,purchase_amount -- 起购金额
            ,commencement_date -- 募集开始日
            ,closing_date -- 募集结束日
            ,init_amount -- 初始创立金额
            ,current_net_worth -- 当前净值
            ,current_market_value -- 当前市值
            ,trustcompany_code -- 信托公司代码
            ,trustcompany_name -- 信托公司名称
            ,product_sorted -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.product_id, o.product_id) as product_id -- 主键序号
    ,nvl(n.product_name, o.product_name) as product_name -- 产品名称
    ,nvl(n.product_code, o.product_code) as product_code -- 产品代码
    ,nvl(n.risk_grade, o.risk_grade) as risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
    ,nvl(n.performance_status, o.performance_status) as performance_status -- 业绩比较基准
    ,nvl(n.establishment_date, o.establishment_date) as establishment_date -- 成立日
    ,nvl(n.termination_date, o.termination_date) as termination_date -- 终止日
    ,nvl(n.product_status, o.product_status) as product_status -- 产品状态 0募集，1成立，2终止
    ,nvl(n.purchase_amount, o.purchase_amount) as purchase_amount -- 起购金额
    ,nvl(n.commencement_date, o.commencement_date) as commencement_date -- 募集开始日
    ,nvl(n.closing_date, o.closing_date) as closing_date -- 募集结束日
    ,nvl(n.init_amount, o.init_amount) as init_amount -- 初始创立金额
    ,nvl(n.current_net_worth, o.current_net_worth) as current_net_worth -- 当前净值
    ,nvl(n.current_market_value, o.current_market_value) as current_market_value -- 当前市值
    ,nvl(n.trustcompany_code, o.trustcompany_code) as trustcompany_code -- 信托公司代码
    ,nvl(n.trustcompany_name, o.trustcompany_name) as trustcompany_name -- 信托公司名称
    ,nvl(n.product_sorted, o.product_sorted) as product_sorted -- 排序字段
    ,nvl(n.created_by, o.created_by) as created_by -- 创建者
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,case when
            n.product_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.product_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.product_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_ft_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_ft_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.product_id = n.product_id
where (
        o.product_id is null
    )
    or (
        n.product_id is null
    )
    or (
        o.product_name <> n.product_name
        or o.product_code <> n.product_code
        or o.risk_grade <> n.risk_grade
        or o.performance_status <> n.performance_status
        or o.establishment_date <> n.establishment_date
        or o.termination_date <> n.termination_date
        or o.product_status <> n.product_status
        or o.purchase_amount <> n.purchase_amount
        or o.commencement_date <> n.commencement_date
        or o.closing_date <> n.closing_date
        or o.init_amount <> n.init_amount
        or o.current_net_worth <> n.current_net_worth
        or o.current_market_value <> n.current_market_value
        or o.trustcompany_code <> n.trustcompany_code
        or o.trustcompany_name <> n.trustcompany_name
        or o.product_sorted <> n.product_sorted
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_product_cl(
            product_id -- 主键序号
            ,product_name -- 产品名称
            ,product_code -- 产品代码
            ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
            ,performance_status -- 业绩比较基准
            ,establishment_date -- 成立日
            ,termination_date -- 终止日
            ,product_status -- 产品状态 0募集，1成立，2终止
            ,purchase_amount -- 起购金额
            ,commencement_date -- 募集开始日
            ,closing_date -- 募集结束日
            ,init_amount -- 初始创立金额
            ,current_net_worth -- 当前净值
            ,current_market_value -- 当前市值
            ,trustcompany_code -- 信托公司代码
            ,trustcompany_name -- 信托公司名称
            ,product_sorted -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_product_op(
            product_id -- 主键序号
            ,product_name -- 产品名称
            ,product_code -- 产品代码
            ,risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
            ,performance_status -- 业绩比较基准
            ,establishment_date -- 成立日
            ,termination_date -- 终止日
            ,product_status -- 产品状态 0募集，1成立，2终止
            ,purchase_amount -- 起购金额
            ,commencement_date -- 募集开始日
            ,closing_date -- 募集结束日
            ,init_amount -- 初始创立金额
            ,current_net_worth -- 当前净值
            ,current_market_value -- 当前市值
            ,trustcompany_code -- 信托公司代码
            ,trustcompany_name -- 信托公司名称
            ,product_sorted -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.product_id -- 主键序号
    ,o.product_name -- 产品名称
    ,o.product_code -- 产品代码
    ,o.risk_grade -- 风险等级 R1:R1低风险  R2:R2中低风险 R3:R3中风险 R4:R4中高风险 R5:R5高风险
    ,o.performance_status -- 业绩比较基准
    ,o.establishment_date -- 成立日
    ,o.termination_date -- 终止日
    ,o.product_status -- 产品状态 0募集，1成立，2终止
    ,o.purchase_amount -- 起购金额
    ,o.commencement_date -- 募集开始日
    ,o.closing_date -- 募集结束日
    ,o.init_amount -- 初始创立金额
    ,o.current_net_worth -- 当前净值
    ,o.current_market_value -- 当前市值
    ,o.trustcompany_code -- 信托公司代码
    ,o.trustcompany_name -- 信托公司名称
    ,o.product_sorted -- 排序字段
    ,o.created_by -- 创建者
    ,o.updated_by -- 修改者
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
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
from ${iol_schema}.nfss_ft_product_bk o
    left join ${iol_schema}.nfss_ft_product_op n
        on
            o.product_id = n.product_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_ft_product_cl d
        on
            o.product_id = d.product_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_ft_product;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_ft_product') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_ft_product drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_ft_product add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_ft_product exchange partition p_${batch_date} with table ${iol_schema}.nfss_ft_product_cl;
alter table ${iol_schema}.nfss_ft_product exchange partition p_20991231 with table ${iol_schema}.nfss_ft_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ft_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_product_op purge;
drop table ${iol_schema}.nfss_ft_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_ft_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ft_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
