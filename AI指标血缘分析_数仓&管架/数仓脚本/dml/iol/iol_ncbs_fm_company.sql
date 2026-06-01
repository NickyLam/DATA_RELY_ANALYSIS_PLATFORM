/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_company
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
create table ${iol_schema}.ncbs_fm_company_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_company
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_company_op purge;
drop table ${iol_schema}.ncbs_fm_company_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_company_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_company where 0=1;

create table ${iol_schema}.ncbs_fm_company_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_company where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_company_cl(
            company -- 法人
            ,company_name -- 公司名称
            ,multi_corp_query_allow -- 多法人是否允许跨法人查询标志
            ,system_phase -- 系统所处的阶段
            ,tran_timestamp -- 交易时间戳
            ,cny_business_unit -- 账套(人民币)
            ,company_client_no -- 法人内部客户号
            ,head_office_code -- 总行机构代码
            ,hkd_business_unit -- 账套(港币)
            ,all_dra_company -- 通兑法人代码
            ,all_dep_company -- 通存法人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_company_op(
            company -- 法人
            ,company_name -- 公司名称
            ,multi_corp_query_allow -- 多法人是否允许跨法人查询标志
            ,system_phase -- 系统所处的阶段
            ,tran_timestamp -- 交易时间戳
            ,cny_business_unit -- 账套(人民币)
            ,company_client_no -- 法人内部客户号
            ,head_office_code -- 总行机构代码
            ,hkd_business_unit -- 账套(港币)
            ,all_dra_company -- 通兑法人代码
            ,all_dep_company -- 通存法人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.company, o.company) as company -- 法人
    ,nvl(n.company_name, o.company_name) as company_name -- 公司名称
    ,nvl(n.multi_corp_query_allow, o.multi_corp_query_allow) as multi_corp_query_allow -- 多法人是否允许跨法人查询标志
    ,nvl(n.system_phase, o.system_phase) as system_phase -- 系统所处的阶段
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.cny_business_unit, o.cny_business_unit) as cny_business_unit -- 账套(人民币)
    ,nvl(n.company_client_no, o.company_client_no) as company_client_no -- 法人内部客户号
    ,nvl(n.head_office_code, o.head_office_code) as head_office_code -- 总行机构代码
    ,nvl(n.hkd_business_unit, o.hkd_business_unit) as hkd_business_unit -- 账套(港币)
    ,nvl(n.all_dra_company, o.all_dra_company) as all_dra_company -- 通兑法人代码
    ,nvl(n.all_dep_company, o.all_dep_company) as all_dep_company -- 通存法人代码
    ,case when
            n.company is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.company is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.company is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_company_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_company where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.company = n.company
where (
        o.company is null
    )
    or (
        n.company is null
    )
    or (
        o.company_name <> n.company_name
        or o.multi_corp_query_allow <> n.multi_corp_query_allow
        or o.system_phase <> n.system_phase
        or o.tran_timestamp <> n.tran_timestamp
        or o.cny_business_unit <> n.cny_business_unit
        or o.company_client_no <> n.company_client_no
        or o.head_office_code <> n.head_office_code
        or o.hkd_business_unit <> n.hkd_business_unit
        or o.all_dra_company <> n.all_dra_company
        or o.all_dep_company <> n.all_dep_company
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_company_cl(
            company -- 法人
            ,company_name -- 公司名称
            ,multi_corp_query_allow -- 多法人是否允许跨法人查询标志
            ,system_phase -- 系统所处的阶段
            ,tran_timestamp -- 交易时间戳
            ,cny_business_unit -- 账套(人民币)
            ,company_client_no -- 法人内部客户号
            ,head_office_code -- 总行机构代码
            ,hkd_business_unit -- 账套(港币)
            ,all_dra_company -- 通兑法人代码
            ,all_dep_company -- 通存法人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_company_op(
            company -- 法人
            ,company_name -- 公司名称
            ,multi_corp_query_allow -- 多法人是否允许跨法人查询标志
            ,system_phase -- 系统所处的阶段
            ,tran_timestamp -- 交易时间戳
            ,cny_business_unit -- 账套(人民币)
            ,company_client_no -- 法人内部客户号
            ,head_office_code -- 总行机构代码
            ,hkd_business_unit -- 账套(港币)
            ,all_dra_company -- 通兑法人代码
            ,all_dep_company -- 通存法人代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.company -- 法人
    ,o.company_name -- 公司名称
    ,o.multi_corp_query_allow -- 多法人是否允许跨法人查询标志
    ,o.system_phase -- 系统所处的阶段
    ,o.tran_timestamp -- 交易时间戳
    ,o.cny_business_unit -- 账套(人民币)
    ,o.company_client_no -- 法人内部客户号
    ,o.head_office_code -- 总行机构代码
    ,o.hkd_business_unit -- 账套(港币)
    ,o.all_dra_company -- 通兑法人代码
    ,o.all_dep_company -- 通存法人代码
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
from ${iol_schema}.ncbs_fm_company_bk o
    left join ${iol_schema}.ncbs_fm_company_op n
        on
            o.company = n.company
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_company_cl d
        on
            o.company = d.company
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_company;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_company') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_company drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_company add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_company exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_company_cl;
alter table ${iol_schema}.ncbs_fm_company exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_company_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_company to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_company_op purge;
drop table ${iol_schema}.ncbs_fm_company_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_company_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_company',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
