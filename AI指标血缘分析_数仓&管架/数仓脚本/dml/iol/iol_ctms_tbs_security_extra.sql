/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_security_extra
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
create table ${iol_schema}.ctms_tbs_security_extra_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_security_extra
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_security_extra_op purge;
drop table ${iol_schema}.ctms_tbs_security_extra_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_security_extra_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_security_extra where 0=1;

create table ${iol_schema}.ctms_tbs_security_extra_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_security_extra where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_security_extra_cl(
            security_code -- 债券代码
            ,allow_netting -- 是否净额交割
            ,depository_trust -- 托管机构
            ,asset_type -- 资产类别
            ,cb_stock_id -- 股票代码
            ,cb_stock_name -- 股票名称
            ,payment_back_mode -- 还本处理方式
            ,breach_contract -- 
            ,perpetual -- 永续债标识
            ,n_bsns_day -- N工作日
            ,issuer_country_name -- 发行主体所属国家/地区
            ,issuer_location -- 发行地
            ,local_government_classify -- 地方政府债分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_security_extra_op(
            security_code -- 债券代码
            ,allow_netting -- 是否净额交割
            ,depository_trust -- 托管机构
            ,asset_type -- 资产类别
            ,cb_stock_id -- 股票代码
            ,cb_stock_name -- 股票名称
            ,payment_back_mode -- 还本处理方式
            ,breach_contract -- 
            ,perpetual -- 永续债标识
            ,n_bsns_day -- N工作日
            ,issuer_country_name -- 发行主体所属国家/地区
            ,issuer_location -- 发行地
            ,local_government_classify -- 地方政府债分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.allow_netting, o.allow_netting) as allow_netting -- 是否净额交割
    ,nvl(n.depository_trust, o.depository_trust) as depository_trust -- 托管机构
    ,nvl(n.asset_type, o.asset_type) as asset_type -- 资产类别
    ,nvl(n.cb_stock_id, o.cb_stock_id) as cb_stock_id -- 股票代码
    ,nvl(n.cb_stock_name, o.cb_stock_name) as cb_stock_name -- 股票名称
    ,nvl(n.payment_back_mode, o.payment_back_mode) as payment_back_mode -- 还本处理方式
    ,nvl(n.breach_contract, o.breach_contract) as breach_contract -- 
    ,nvl(n.perpetual, o.perpetual) as perpetual -- 永续债标识
    ,nvl(n.n_bsns_day, o.n_bsns_day) as n_bsns_day -- N工作日
    ,nvl(n.issuer_country_name, o.issuer_country_name) as issuer_country_name -- 发行主体所属国家/地区
    ,nvl(n.issuer_location, o.issuer_location) as issuer_location -- 发行地
    ,nvl(n.local_government_classify, o.local_government_classify) as local_government_classify -- 地方政府债分类
    ,case when
            n.security_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_security_extra_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_security_extra where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_code = n.security_code
where (
        o.security_code is null
    )
    or (
        n.security_code is null
    )
    or (
        o.allow_netting <> n.allow_netting
        or o.depository_trust <> n.depository_trust
        or o.asset_type <> n.asset_type
        or o.cb_stock_id <> n.cb_stock_id
        or o.cb_stock_name <> n.cb_stock_name
        or o.payment_back_mode <> n.payment_back_mode
        or o.breach_contract <> n.breach_contract
        or o.perpetual <> n.perpetual
        or o.n_bsns_day <> n.n_bsns_day
        or o.issuer_country_name <> n.issuer_country_name
        or o.issuer_location <> n.issuer_location
        or o.local_government_classify <> n.local_government_classify
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_security_extra_cl(
            security_code -- 债券代码
            ,allow_netting -- 是否净额交割
            ,depository_trust -- 托管机构
            ,asset_type -- 资产类别
            ,cb_stock_id -- 股票代码
            ,cb_stock_name -- 股票名称
            ,payment_back_mode -- 还本处理方式
            ,breach_contract -- 
            ,perpetual -- 永续债标识
            ,n_bsns_day -- N工作日
            ,issuer_country_name -- 发行主体所属国家/地区
            ,issuer_location -- 发行地
            ,local_government_classify -- 地方政府债分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_security_extra_op(
            security_code -- 债券代码
            ,allow_netting -- 是否净额交割
            ,depository_trust -- 托管机构
            ,asset_type -- 资产类别
            ,cb_stock_id -- 股票代码
            ,cb_stock_name -- 股票名称
            ,payment_back_mode -- 还本处理方式
            ,breach_contract -- 
            ,perpetual -- 永续债标识
            ,n_bsns_day -- N工作日
            ,issuer_country_name -- 发行主体所属国家/地区
            ,issuer_location -- 发行地
            ,local_government_classify -- 地方政府债分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.allow_netting -- 是否净额交割
    ,o.depository_trust -- 托管机构
    ,o.asset_type -- 资产类别
    ,o.cb_stock_id -- 股票代码
    ,o.cb_stock_name -- 股票名称
    ,o.payment_back_mode -- 还本处理方式
    ,o.breach_contract -- 
    ,o.perpetual -- 永续债标识
    ,o.n_bsns_day -- N工作日
    ,o.issuer_country_name -- 发行主体所属国家/地区
    ,o.issuer_location -- 发行地
    ,o.local_government_classify -- 地方政府债分类
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
from ${iol_schema}.ctms_tbs_security_extra_bk o
    left join ${iol_schema}.ctms_tbs_security_extra_op n
        on
            o.security_code = n.security_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_security_extra_cl d
        on
            o.security_code = d.security_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_tbs_security_extra;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_tbs_security_extra') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_tbs_security_extra drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_tbs_security_extra add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_tbs_security_extra exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_security_extra_cl;
alter table ${iol_schema}.ctms_tbs_security_extra exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_security_extra_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_security_extra to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_security_extra_op purge;
drop table ${iol_schema}.ctms_tbs_security_extra_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_security_extra_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_security_extra',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
