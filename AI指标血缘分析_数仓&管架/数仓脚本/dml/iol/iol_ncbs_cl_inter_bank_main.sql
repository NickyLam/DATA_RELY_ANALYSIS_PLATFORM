/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_inter_bank_main
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
create table ${iol_schema}.ncbs_cl_inter_bank_main_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_inter_bank_main
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_inter_bank_main_op purge;
drop table ${iol_schema}.ncbs_cl_inter_bank_main_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_inter_bank_main_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_inter_bank_main where 0=1;

create table ${iol_schema}.ncbs_cl_inter_bank_main_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_inter_bank_main where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_inter_bank_main_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,mature_date -- 到期日
            ,int_start_date -- 起息日
            ,int_rate -- 出单利率
            ,odp_rate -- 贷款罚息利率
            ,inter_bank_busi_no -- 同业代付业务编号
            ,prod_type -- 产品编号
            ,year_basis -- 年基准天数
            ,month_basis -- 月基准
            ,inter_bank_status -- 同业代付状态
            ,timestamp -- 时间戳
            ,is_last_pay_agent -- 是否最后一次代付
            ,contract_no -- 合同编号
            ,home_branch -- 客户管理行
            ,closed_date -- 关闭日期
            ,internal_key -- 账户内部键值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_inter_bank_main_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,mature_date -- 到期日
            ,int_start_date -- 起息日
            ,int_rate -- 出单利率
            ,odp_rate -- 贷款罚息利率
            ,inter_bank_busi_no -- 同业代付业务编号
            ,prod_type -- 产品编号
            ,year_basis -- 年基准天数
            ,month_basis -- 月基准
            ,inter_bank_status -- 同业代付状态
            ,timestamp -- 时间戳
            ,is_last_pay_agent -- 是否最后一次代付
            ,contract_no -- 合同编号
            ,home_branch -- 客户管理行
            ,closed_date -- 关闭日期
            ,internal_key -- 账户内部键值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.mature_date, o.mature_date) as mature_date -- 到期日
    ,nvl(n.int_start_date, o.int_start_date) as int_start_date -- 起息日
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 出单利率
    ,nvl(n.odp_rate, o.odp_rate) as odp_rate -- 贷款罚息利率
    ,nvl(n.inter_bank_busi_no, o.inter_bank_busi_no) as inter_bank_busi_no -- 同业代付业务编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.inter_bank_status, o.inter_bank_status) as inter_bank_status -- 同业代付状态
    ,nvl(n.timestamp, o.timestamp) as timestamp -- 时间戳
    ,nvl(n.is_last_pay_agent, o.is_last_pay_agent) as is_last_pay_agent -- 是否最后一次代付
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.home_branch, o.home_branch) as home_branch -- 客户管理行
    ,nvl(n.closed_date, o.closed_date) as closed_date -- 关闭日期
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,case when
            n.cmisloan_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cmisloan_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cmisloan_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_inter_bank_main_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_inter_bank_main where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cmisloan_no = n.cmisloan_no
where (
        o.cmisloan_no is null
    )
    or (
        n.cmisloan_no is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.mature_date <> n.mature_date
        or o.int_start_date <> n.int_start_date
        or o.int_rate <> n.int_rate
        or o.odp_rate <> n.odp_rate
        or o.inter_bank_busi_no <> n.inter_bank_busi_no
        or o.prod_type <> n.prod_type
        or o.year_basis <> n.year_basis
        or o.month_basis <> n.month_basis
        or o.inter_bank_status <> n.inter_bank_status
        or o.timestamp <> n.timestamp
        or o.is_last_pay_agent <> n.is_last_pay_agent
        or o.contract_no <> n.contract_no
        or o.home_branch <> n.home_branch
        or o.closed_date <> n.closed_date
        or o.internal_key <> n.internal_key
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_inter_bank_main_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,mature_date -- 到期日
            ,int_start_date -- 起息日
            ,int_rate -- 出单利率
            ,odp_rate -- 贷款罚息利率
            ,inter_bank_busi_no -- 同业代付业务编号
            ,prod_type -- 产品编号
            ,year_basis -- 年基准天数
            ,month_basis -- 月基准
            ,inter_bank_status -- 同业代付状态
            ,timestamp -- 时间戳
            ,is_last_pay_agent -- 是否最后一次代付
            ,contract_no -- 合同编号
            ,home_branch -- 客户管理行
            ,closed_date -- 关闭日期
            ,internal_key -- 账户内部键值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_inter_bank_main_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,cmisloan_no -- 客户借据编号
            ,mature_date -- 到期日
            ,int_start_date -- 起息日
            ,int_rate -- 出单利率
            ,odp_rate -- 贷款罚息利率
            ,inter_bank_busi_no -- 同业代付业务编号
            ,prod_type -- 产品编号
            ,year_basis -- 年基准天数
            ,month_basis -- 月基准
            ,inter_bank_status -- 同业代付状态
            ,timestamp -- 时间戳
            ,is_last_pay_agent -- 是否最后一次代付
            ,contract_no -- 合同编号
            ,home_branch -- 客户管理行
            ,closed_date -- 关闭日期
            ,internal_key -- 账户内部键值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.cmisloan_no -- 客户借据编号
    ,o.mature_date -- 到期日
    ,o.int_start_date -- 起息日
    ,o.int_rate -- 出单利率
    ,o.odp_rate -- 贷款罚息利率
    ,o.inter_bank_busi_no -- 同业代付业务编号
    ,o.prod_type -- 产品编号
    ,o.year_basis -- 年基准天数
    ,o.month_basis -- 月基准
    ,o.inter_bank_status -- 同业代付状态
    ,o.timestamp -- 时间戳
    ,o.is_last_pay_agent -- 是否最后一次代付
    ,o.contract_no -- 合同编号
    ,o.home_branch -- 客户管理行
    ,o.closed_date -- 关闭日期
    ,o.internal_key -- 账户内部键值
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
from ${iol_schema}.ncbs_cl_inter_bank_main_bk o
    left join ${iol_schema}.ncbs_cl_inter_bank_main_op n
        on
            o.cmisloan_no = n.cmisloan_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_inter_bank_main_cl d
        on
            o.cmisloan_no = d.cmisloan_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_inter_bank_main;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_inter_bank_main') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_inter_bank_main drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_inter_bank_main add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_inter_bank_main exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_inter_bank_main_cl;
alter table ${iol_schema}.ncbs_cl_inter_bank_main exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_inter_bank_main_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_inter_bank_main to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_inter_bank_main_op purge;
drop table ${iol_schema}.ncbs_cl_inter_bank_main_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_inter_bank_main_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_inter_bank_main',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
