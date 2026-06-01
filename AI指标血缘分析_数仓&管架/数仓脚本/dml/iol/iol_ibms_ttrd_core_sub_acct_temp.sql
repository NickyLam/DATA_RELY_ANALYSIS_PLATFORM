/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_core_sub_acct_temp
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
create table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_core_sub_acct_temp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op purge;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_core_sub_acct_temp where 0=1;

create table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_core_sub_acct_temp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl(
            id -- 主键ID
            ,order_id -- 审批单号
            ,acct -- 账户
            ,sub_acct -- 子户号
            ,customer_no -- 客户号
            ,business_type -- 业务类型，定期：A09，活期：A11
            ,imp_date -- 导入日期
            ,product -- 产品
            ,currency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op(
            id -- 主键ID
            ,order_id -- 审批单号
            ,acct -- 账户
            ,sub_acct -- 子户号
            ,customer_no -- 客户号
            ,business_type -- 业务类型，定期：A09，活期：A11
            ,imp_date -- 导入日期
            ,product -- 产品
            ,currency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.order_id, o.order_id) as order_id -- 审批单号
    ,nvl(n.acct, o.acct) as acct -- 账户
    ,nvl(n.sub_acct, o.sub_acct) as sub_acct -- 子户号
    ,nvl(n.customer_no, o.customer_no) as customer_no -- 客户号
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型，定期：A09，活期：A11
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.product, o.product) as product -- 产品
    ,nvl(n.currency, o.currency) as currency -- 币种
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
from (select * from ${iol_schema}.ibms_ttrd_core_sub_acct_temp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_core_sub_acct_temp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.order_id <> n.order_id
        or o.acct <> n.acct
        or o.sub_acct <> n.sub_acct
        or o.customer_no <> n.customer_no
        or o.business_type <> n.business_type
        or o.imp_date <> n.imp_date
        or o.product <> n.product
        or o.currency <> n.currency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl(
            id -- 主键ID
            ,order_id -- 审批单号
            ,acct -- 账户
            ,sub_acct -- 子户号
            ,customer_no -- 客户号
            ,business_type -- 业务类型，定期：A09，活期：A11
            ,imp_date -- 导入日期
            ,product -- 产品
            ,currency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op(
            id -- 主键ID
            ,order_id -- 审批单号
            ,acct -- 账户
            ,sub_acct -- 子户号
            ,customer_no -- 客户号
            ,business_type -- 业务类型，定期：A09，活期：A11
            ,imp_date -- 导入日期
            ,product -- 产品
            ,currency -- 币种
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.order_id -- 审批单号
    ,o.acct -- 账户
    ,o.sub_acct -- 子户号
    ,o.customer_no -- 客户号
    ,o.business_type -- 业务类型，定期：A09，活期：A11
    ,o.imp_date -- 导入日期
    ,o.product -- 产品
    ,o.currency -- 币种
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
from ${iol_schema}.ibms_ttrd_core_sub_acct_temp_bk o
    left join ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_core_sub_acct_temp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_core_sub_acct_temp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_core_sub_acct_temp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_core_sub_acct_temp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_core_sub_acct_temp exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl;
alter table ${iol_schema}.ibms_ttrd_core_sub_acct_temp exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_core_sub_acct_temp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_op purge;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_core_sub_acct_temp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_core_sub_acct_temp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
