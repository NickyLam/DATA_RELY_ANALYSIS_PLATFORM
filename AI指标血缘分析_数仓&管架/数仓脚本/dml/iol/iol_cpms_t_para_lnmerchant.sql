/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_para_lnmerchant
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
create table ${iol_schema}.cpms_t_para_lnmerchant_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.cpms_t_para_lnmerchant;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_para_lnmerchant_op purge;
drop table ${iol_schema}.cpms_t_para_lnmerchant_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_para_lnmerchant_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_para_lnmerchant where 0=1;

create table ${iol_schema}.cpms_t_para_lnmerchant_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_para_lnmerchant where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_para_lnmerchant_cl(
            id -- 
            ,branch_no -- 
            ,ln_no -- 
            ,merchant_no -- 
            ,merchant_name -- 
            ,account -- 
            ,merchant_type -- 
            ,merchant_gene_type -- 
            ,region -- 
            ,address -- 
            ,postcode -- 
            ,merchant_status -- 
            ,merchant_phone -- 
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,accept_org_no -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- Y有效；N无效
            ,last_modify_time -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_para_lnmerchant_op(
            id -- 
            ,branch_no -- 
            ,ln_no -- 
            ,merchant_no -- 
            ,merchant_name -- 
            ,account -- 
            ,merchant_type -- 
            ,merchant_gene_type -- 
            ,region -- 
            ,address -- 
            ,postcode -- 
            ,merchant_status -- 
            ,merchant_phone -- 
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,accept_org_no -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- Y有效；N无效
            ,last_modify_time -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.ln_no, o.ln_no) as ln_no -- 
    ,nvl(n.merchant_no, o.merchant_no) as merchant_no -- 
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 
    ,nvl(n.account, o.account) as account -- 
    ,nvl(n.merchant_type, o.merchant_type) as merchant_type -- 
    ,nvl(n.merchant_gene_type, o.merchant_gene_type) as merchant_gene_type -- 
    ,nvl(n.region, o.region) as region -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.postcode, o.postcode) as postcode -- 
    ,nvl(n.merchant_status, o.merchant_status) as merchant_status -- 
    ,nvl(n.merchant_phone, o.merchant_phone) as merchant_phone -- 
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 
    ,nvl(n.author_id, o.author_id) as author_id -- 
    ,nvl(n.operate_date, o.operate_date) as operate_date -- 
    ,nvl(n.operate_time, o.operate_time) as operate_time -- 
    ,nvl(n.accept_org_no, o.accept_org_no) as accept_org_no -- 
    ,nvl(n.expand_1, o.expand_1) as expand_1 -- 
    ,nvl(n.expand_2, o.expand_2) as expand_2 -- 
    ,nvl(n.expand_3, o.expand_3) as expand_3 -- 
    ,nvl(n.expand_4, o.expand_4) as expand_4 -- 
    ,nvl(n.expand_5, o.expand_5) as expand_5 -- 
    ,nvl(n.is_valid, o.is_valid) as is_valid -- Y有效；N无效
    ,nvl(n.last_modify_time, o.last_modify_time) as last_modify_time -- 
    ,nvl(n.remark, o.remark) as remark -- 
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
from (select * from ${iol_schema}.cpms_t_para_lnmerchant_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.cpms_t_para_lnmerchant where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.branch_no <> n.branch_no
        or o.ln_no <> n.ln_no
        or o.merchant_no <> n.merchant_no
        or o.merchant_name <> n.merchant_name
        or o.account <> n.account
        or o.merchant_type <> n.merchant_type
        or o.merchant_gene_type <> n.merchant_gene_type
        or o.region <> n.region
        or o.address <> n.address
        or o.postcode <> n.postcode
        or o.merchant_status <> n.merchant_status
        or o.merchant_phone <> n.merchant_phone
        or o.operator_id <> n.operator_id
        or o.author_id <> n.author_id
        or o.operate_date <> n.operate_date
        or o.operate_time <> n.operate_time
        or o.accept_org_no <> n.accept_org_no
        or o.expand_1 <> n.expand_1
        or o.expand_2 <> n.expand_2
        or o.expand_3 <> n.expand_3
        or o.expand_4 <> n.expand_4
        or o.expand_5 <> n.expand_5
        or o.is_valid <> n.is_valid
        or o.last_modify_time <> n.last_modify_time
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_para_lnmerchant_cl(
            id -- 
            ,branch_no -- 
            ,ln_no -- 
            ,merchant_no -- 
            ,merchant_name -- 
            ,account -- 
            ,merchant_type -- 
            ,merchant_gene_type -- 
            ,region -- 
            ,address -- 
            ,postcode -- 
            ,merchant_status -- 
            ,merchant_phone -- 
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,accept_org_no -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- Y有效；N无效
            ,last_modify_time -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_para_lnmerchant_op(
            id -- 
            ,branch_no -- 
            ,ln_no -- 
            ,merchant_no -- 
            ,merchant_name -- 
            ,account -- 
            ,merchant_type -- 
            ,merchant_gene_type -- 
            ,region -- 
            ,address -- 
            ,postcode -- 
            ,merchant_status -- 
            ,merchant_phone -- 
            ,operator_id -- 
            ,author_id -- 
            ,operate_date -- 
            ,operate_time -- 
            ,accept_org_no -- 
            ,expand_1 -- 
            ,expand_2 -- 
            ,expand_3 -- 
            ,expand_4 -- 
            ,expand_5 -- 
            ,is_valid -- Y有效；N无效
            ,last_modify_time -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.branch_no -- 
    ,o.ln_no -- 
    ,o.merchant_no -- 
    ,o.merchant_name -- 
    ,o.account -- 
    ,o.merchant_type -- 
    ,o.merchant_gene_type -- 
    ,o.region -- 
    ,o.address -- 
    ,o.postcode -- 
    ,o.merchant_status -- 
    ,o.merchant_phone -- 
    ,o.operator_id -- 
    ,o.author_id -- 
    ,o.operate_date -- 
    ,o.operate_time -- 
    ,o.accept_org_no -- 
    ,o.expand_1 -- 
    ,o.expand_2 -- 
    ,o.expand_3 -- 
    ,o.expand_4 -- 
    ,o.expand_5 -- 
    ,o.is_valid -- Y有效；N无效
    ,o.last_modify_time -- 
    ,o.remark -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.cpms_t_para_lnmerchant_bk o
    left join ${iol_schema}.cpms_t_para_lnmerchant_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.cpms_t_para_lnmerchant_cl d
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
-- truncate table ${iol_schema}.cpms_t_para_lnmerchant;

-- 4.2 exchange partition
alter table ${iol_schema}.cpms_t_para_lnmerchant exchange partition p_19000101 with table ${iol_schema}.cpms_t_para_lnmerchant_cl;
alter table ${iol_schema}.cpms_t_para_lnmerchant exchange partition p_20991231 with table ${iol_schema}.cpms_t_para_lnmerchant_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_para_lnmerchant to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_para_lnmerchant_op purge;
drop table ${iol_schema}.cpms_t_para_lnmerchant_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.cpms_t_para_lnmerchant_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_para_lnmerchant',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
