/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_pir_adm_pay_cust_authority
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
create table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifcs_pir_adm_pay_cust_authority;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op purge;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_pir_adm_pay_cust_authority where 0=1;

create table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifcs_pir_adm_pay_cust_authority where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,cust_typ -- 客户类型
            ,authority_typ -- 支付权限类型
            ,cust_num -- 客户数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,cust_typ -- 客户类型
            ,authority_typ -- 支付权限类型
            ,cust_num -- 客户数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.org_num, o.org_num) as org_num -- 机构号
    ,nvl(n.cust_typ, o.cust_typ) as cust_typ -- 客户类型
    ,nvl(n.authority_typ, o.authority_typ) as authority_typ -- 支付权限类型
    ,nvl(n.cust_num, o.cust_num) as cust_num -- 客户数
    ,case when
            n.data_dt is null
            and n.org_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.data_dt is null
            and n.org_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.data_dt is null
            and n.org_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifcs_pir_adm_pay_cust_authority_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifcs_pir_adm_pay_cust_authority where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
where (
        o.data_dt is null
        and o.org_num is null
    )
    or (
        n.data_dt is null
        and n.org_num is null
    )
    or (
        o.cust_typ <> n.cust_typ
        or o.authority_typ <> n.authority_typ
        or o.cust_num <> n.cust_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,cust_typ -- 客户类型
            ,authority_typ -- 支付权限类型
            ,cust_num -- 客户数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op(
            data_dt -- 数据日期
            ,org_num -- 机构号
            ,cust_typ -- 客户类型
            ,authority_typ -- 支付权限类型
            ,cust_num -- 客户数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.data_dt -- 数据日期
    ,o.org_num -- 机构号
    ,o.cust_typ -- 客户类型
    ,o.authority_typ -- 支付权限类型
    ,o.cust_num -- 客户数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifcs_pir_adm_pay_cust_authority_bk o
    left join ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op n
        on
            o.data_dt = n.data_dt
            and o.org_num = n.org_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl d
        on
            o.data_dt = d.data_dt
            and o.org_num = d.org_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifcs_pir_adm_pay_cust_authority;

-- 4.2 exchange partition
alter table ${iol_schema}.ifcs_pir_adm_pay_cust_authority exchange partition p_19000101 with table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl;
alter table ${iol_schema}.ifcs_pir_adm_pay_cust_authority exchange partition p_20991231 with table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_pir_adm_pay_cust_authority to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_op purge;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifcs_pir_adm_pay_cust_authority_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_pir_adm_pay_cust_authority',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
