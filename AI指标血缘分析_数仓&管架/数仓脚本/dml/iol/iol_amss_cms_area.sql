/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cms_area
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
create table ${iol_schema}.amss_cms_area_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cms_area
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_area_op purge;
drop table ${iol_schema}.amss_cms_area_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_area_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_area where 0=1;

create table ${iol_schema}.amss_cms_area_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cms_area where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_area_cl(
            area_code -- 地区编号.
            ,area_name -- 地区名称.
            ,area_type -- 地区类型.1国家，2省份，3城市，4县/区
            ,parent_area -- 所属地区.
            ,zip_code -- 邮政编号.
            ,tel_code -- 电话区号.生成渠道编号时要用到
            ,enabled -- 是否启用.
            ,name_py -- 地区名称全拼.
            ,name_spy -- 地区名称拼音缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_v2_area_code -- 支付宝V2地区编码
            ,best_pay_area_code -- 翼支付地区码
            ,hebao_area_code -- 和包地区编码
            ,union_pay_area_code -- 银联地区编号
            ,sft_area_code -- 盛付通地区编码
            ,sft_area_name -- 盛付通地区名
            ,cfca_area_code -- 清算协会地区编码
            ,jl_area_code -- 嘉联地区码
            ,yz_area_code -- 银总地区编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_area_op(
            area_code -- 地区编号.
            ,area_name -- 地区名称.
            ,area_type -- 地区类型.1国家，2省份，3城市，4县/区
            ,parent_area -- 所属地区.
            ,zip_code -- 邮政编号.
            ,tel_code -- 电话区号.生成渠道编号时要用到
            ,enabled -- 是否启用.
            ,name_py -- 地区名称全拼.
            ,name_spy -- 地区名称拼音缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_v2_area_code -- 支付宝V2地区编码
            ,best_pay_area_code -- 翼支付地区码
            ,hebao_area_code -- 和包地区编码
            ,union_pay_area_code -- 银联地区编号
            ,sft_area_code -- 盛付通地区编码
            ,sft_area_name -- 盛付通地区名
            ,cfca_area_code -- 清算协会地区编码
            ,jl_area_code -- 嘉联地区码
            ,yz_area_code -- 银总地区编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.area_code, o.area_code) as area_code -- 地区编号.
    ,nvl(n.area_name, o.area_name) as area_name -- 地区名称.
    ,nvl(n.area_type, o.area_type) as area_type -- 地区类型.1国家，2省份，3城市，4县/区
    ,nvl(n.parent_area, o.parent_area) as parent_area -- 所属地区.
    ,nvl(n.zip_code, o.zip_code) as zip_code -- 邮政编号.
    ,nvl(n.tel_code, o.tel_code) as tel_code -- 电话区号.生成渠道编号时要用到
    ,nvl(n.enabled, o.enabled) as enabled -- 是否启用.
    ,nvl(n.name_py, o.name_py) as name_py -- 地区名称全拼.
    ,nvl(n.name_spy, o.name_spy) as name_spy -- 地区名称拼音缩写.
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户.
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人.
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.ali_v2_area_code, o.ali_v2_area_code) as ali_v2_area_code -- 支付宝V2地区编码
    ,nvl(n.best_pay_area_code, o.best_pay_area_code) as best_pay_area_code -- 翼支付地区码
    ,nvl(n.hebao_area_code, o.hebao_area_code) as hebao_area_code -- 和包地区编码
    ,nvl(n.union_pay_area_code, o.union_pay_area_code) as union_pay_area_code -- 银联地区编号
    ,nvl(n.sft_area_code, o.sft_area_code) as sft_area_code -- 盛付通地区编码
    ,nvl(n.sft_area_name, o.sft_area_name) as sft_area_name -- 盛付通地区名
    ,nvl(n.cfca_area_code, o.cfca_area_code) as cfca_area_code -- 清算协会地区编码
    ,nvl(n.jl_area_code, o.jl_area_code) as jl_area_code -- 嘉联地区码
    ,nvl(n.yz_area_code, o.yz_area_code) as yz_area_code -- 银总地区编码
    ,case when
            n.area_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.area_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.area_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cms_area_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cms_area where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.area_code = n.area_code
where (
        o.area_code is null
    )
    or (
        n.area_code is null
    )
    or (
        o.area_name <> n.area_name
        or o.area_type <> n.area_type
        or o.parent_area <> n.parent_area
        or o.zip_code <> n.zip_code
        or o.tel_code <> n.tel_code
        or o.enabled <> n.enabled
        or o.name_py <> n.name_py
        or o.name_spy <> n.name_spy
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.ali_v2_area_code <> n.ali_v2_area_code
        or o.best_pay_area_code <> n.best_pay_area_code
        or o.hebao_area_code <> n.hebao_area_code
        or o.union_pay_area_code <> n.union_pay_area_code
        or o.sft_area_code <> n.sft_area_code
        or o.sft_area_name <> n.sft_area_name
        or o.cfca_area_code <> n.cfca_area_code
        or o.jl_area_code <> n.jl_area_code
        or o.yz_area_code <> n.yz_area_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cms_area_cl(
            area_code -- 地区编号.
            ,area_name -- 地区名称.
            ,area_type -- 地区类型.1国家，2省份，3城市，4县/区
            ,parent_area -- 所属地区.
            ,zip_code -- 邮政编号.
            ,tel_code -- 电话区号.生成渠道编号时要用到
            ,enabled -- 是否启用.
            ,name_py -- 地区名称全拼.
            ,name_spy -- 地区名称拼音缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_v2_area_code -- 支付宝V2地区编码
            ,best_pay_area_code -- 翼支付地区码
            ,hebao_area_code -- 和包地区编码
            ,union_pay_area_code -- 银联地区编号
            ,sft_area_code -- 盛付通地区编码
            ,sft_area_name -- 盛付通地区名
            ,cfca_area_code -- 清算协会地区编码
            ,jl_area_code -- 嘉联地区码
            ,yz_area_code -- 银总地区编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cms_area_op(
            area_code -- 地区编号.
            ,area_name -- 地区名称.
            ,area_type -- 地区类型.1国家，2省份，3城市，4县/区
            ,parent_area -- 所属地区.
            ,zip_code -- 邮政编号.
            ,tel_code -- 电话区号.生成渠道编号时要用到
            ,enabled -- 是否启用.
            ,name_py -- 地区名称全拼.
            ,name_spy -- 地区名称拼音缩写.
            ,remark -- 备注.
            ,create_user -- 创建用户.
            ,create_emp -- 创建人.
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,ali_v2_area_code -- 支付宝V2地区编码
            ,best_pay_area_code -- 翼支付地区码
            ,hebao_area_code -- 和包地区编码
            ,union_pay_area_code -- 银联地区编号
            ,sft_area_code -- 盛付通地区编码
            ,sft_area_name -- 盛付通地区名
            ,cfca_area_code -- 清算协会地区编码
            ,jl_area_code -- 嘉联地区码
            ,yz_area_code -- 银总地区编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.area_code -- 地区编号.
    ,o.area_name -- 地区名称.
    ,o.area_type -- 地区类型.1国家，2省份，3城市，4县/区
    ,o.parent_area -- 所属地区.
    ,o.zip_code -- 邮政编号.
    ,o.tel_code -- 电话区号.生成渠道编号时要用到
    ,o.enabled -- 是否启用.
    ,o.name_py -- 地区名称全拼.
    ,o.name_spy -- 地区名称拼音缩写.
    ,o.remark -- 备注.
    ,o.create_user -- 创建用户.
    ,o.create_emp -- 创建人.
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.ali_v2_area_code -- 支付宝V2地区编码
    ,o.best_pay_area_code -- 翼支付地区码
    ,o.hebao_area_code -- 和包地区编码
    ,o.union_pay_area_code -- 银联地区编号
    ,o.sft_area_code -- 盛付通地区编码
    ,o.sft_area_name -- 盛付通地区名
    ,o.cfca_area_code -- 清算协会地区编码
    ,o.jl_area_code -- 嘉联地区码
    ,o.yz_area_code -- 银总地区编码
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
from ${iol_schema}.amss_cms_area_bk o
    left join ${iol_schema}.amss_cms_area_op n
        on
            o.area_code = n.area_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cms_area_cl d
        on
            o.area_code = d.area_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cms_area;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cms_area') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cms_area drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cms_area add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cms_area exchange partition p_${batch_date} with table ${iol_schema}.amss_cms_area_cl;
alter table ${iol_schema}.amss_cms_area exchange partition p_20991231 with table ${iol_schema}.amss_cms_area_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cms_area to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cms_area_op purge;
drop table ${iol_schema}.amss_cms_area_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cms_area_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cms_area',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
