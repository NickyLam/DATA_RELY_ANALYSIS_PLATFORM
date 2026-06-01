/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t99_central_cust_info
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
create table ${iol_schema}.eifs_t99_central_cust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t99_central_cust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t99_central_cust_info_op purge;
drop table ${iol_schema}.eifs_t99_central_cust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t99_central_cust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t99_central_cust_info where 0=1;

create table ${iol_schema}.eifs_t99_central_cust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t99_central_cust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t99_central_cust_info_cl(
            cust_num -- 客户编号
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型代码
            ,rgst_type_cd -- 登记注册类型代码
            ,nation_eco_dept_cd -- 国民经济部门代码
            ,belong_indus_cd -- 所属行业代码
            ,corp_size_cd -- 企业规模
            ,addr_detail -- 注册地址
            ,phys_addr_cty_zone_cd -- 注册地国家
            ,prov_cd -- 注册地省份
            ,city_cd -- 注册地市级
            ,county_cd -- 注册地区级
            ,economic_org_form -- 控股类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t99_central_cust_info_op(
            cust_num -- 客户编号
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型代码
            ,rgst_type_cd -- 登记注册类型代码
            ,nation_eco_dept_cd -- 国民经济部门代码
            ,belong_indus_cd -- 所属行业代码
            ,corp_size_cd -- 企业规模
            ,addr_detail -- 注册地址
            ,phys_addr_cty_zone_cd -- 注册地国家
            ,prov_cd -- 注册地省份
            ,city_cd -- 注册地市级
            ,county_cd -- 注册地区级
            ,economic_org_form -- 控股类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_num, o.cust_num) as cust_num -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 组织机构类型代码
    ,nvl(n.rgst_type_cd, o.rgst_type_cd) as rgst_type_cd -- 登记注册类型代码
    ,nvl(n.nation_eco_dept_cd, o.nation_eco_dept_cd) as nation_eco_dept_cd -- 国民经济部门代码
    ,nvl(n.belong_indus_cd, o.belong_indus_cd) as belong_indus_cd -- 所属行业代码
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模
    ,nvl(n.addr_detail, o.addr_detail) as addr_detail -- 注册地址
    ,nvl(n.phys_addr_cty_zone_cd, o.phys_addr_cty_zone_cd) as phys_addr_cty_zone_cd -- 注册地国家
    ,nvl(n.prov_cd, o.prov_cd) as prov_cd -- 注册地省份
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 注册地市级
    ,nvl(n.county_cd, o.county_cd) as county_cd -- 注册地区级
    ,nvl(n.economic_org_form, o.economic_org_form) as economic_org_form -- 控股类型
    ,case when
            n.cust_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t99_central_cust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t99_central_cust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_num = n.cust_num
where (
        o.cust_num is null
    )
    or (
        n.cust_num is null
    )
    or (
        o.cust_name <> n.cust_name
        or o.org_type_cd <> n.org_type_cd
        or o.rgst_type_cd <> n.rgst_type_cd
        or o.nation_eco_dept_cd <> n.nation_eco_dept_cd
        or o.belong_indus_cd <> n.belong_indus_cd
        or o.corp_size_cd <> n.corp_size_cd
        or o.addr_detail <> n.addr_detail
        or o.phys_addr_cty_zone_cd <> n.phys_addr_cty_zone_cd
        or o.prov_cd <> n.prov_cd
        or o.city_cd <> n.city_cd
        or o.county_cd <> n.county_cd
        or o.economic_org_form <> n.economic_org_form
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t99_central_cust_info_cl(
            cust_num -- 客户编号
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型代码
            ,rgst_type_cd -- 登记注册类型代码
            ,nation_eco_dept_cd -- 国民经济部门代码
            ,belong_indus_cd -- 所属行业代码
            ,corp_size_cd -- 企业规模
            ,addr_detail -- 注册地址
            ,phys_addr_cty_zone_cd -- 注册地国家
            ,prov_cd -- 注册地省份
            ,city_cd -- 注册地市级
            ,county_cd -- 注册地区级
            ,economic_org_form -- 控股类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t99_central_cust_info_op(
            cust_num -- 客户编号
            ,cust_name -- 客户名称
            ,org_type_cd -- 组织机构类型代码
            ,rgst_type_cd -- 登记注册类型代码
            ,nation_eco_dept_cd -- 国民经济部门代码
            ,belong_indus_cd -- 所属行业代码
            ,corp_size_cd -- 企业规模
            ,addr_detail -- 注册地址
            ,phys_addr_cty_zone_cd -- 注册地国家
            ,prov_cd -- 注册地省份
            ,city_cd -- 注册地市级
            ,county_cd -- 注册地区级
            ,economic_org_form -- 控股类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_num -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.org_type_cd -- 组织机构类型代码
    ,o.rgst_type_cd -- 登记注册类型代码
    ,o.nation_eco_dept_cd -- 国民经济部门代码
    ,o.belong_indus_cd -- 所属行业代码
    ,o.corp_size_cd -- 企业规模
    ,o.addr_detail -- 注册地址
    ,o.phys_addr_cty_zone_cd -- 注册地国家
    ,o.prov_cd -- 注册地省份
    ,o.city_cd -- 注册地市级
    ,o.county_cd -- 注册地区级
    ,o.economic_org_form -- 控股类型
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
from ${iol_schema}.eifs_t99_central_cust_info_bk o
    left join ${iol_schema}.eifs_t99_central_cust_info_op n
        on
            o.cust_num = n.cust_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t99_central_cust_info_cl d
        on
            o.cust_num = d.cust_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t99_central_cust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t99_central_cust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t99_central_cust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t99_central_cust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t99_central_cust_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t99_central_cust_info_cl;
alter table ${iol_schema}.eifs_t99_central_cust_info exchange partition p_20991231 with table ${iol_schema}.eifs_t99_central_cust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t99_central_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t99_central_cust_info_op purge;
drop table ${iol_schema}.eifs_t99_central_cust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t99_central_cust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t99_central_cust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
