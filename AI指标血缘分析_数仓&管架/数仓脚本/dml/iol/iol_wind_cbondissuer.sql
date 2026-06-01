/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondissuer
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
create table ${iol_schema}.wind_cbondissuer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_cbondissuer;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondissuer_op purge;
drop table ${iol_schema}.wind_cbondissuer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondissuer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbondissuer where 0=1;

create table ${iol_schema}.wind_cbondissuer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbondissuer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbondissuer_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_compname -- 债券主体公司名称
            ,s_info_compcode -- 债券主体公司id
            ,used -- 是否有效
            ,s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
            ,s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
            ,s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
            ,s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
            ,s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
            ,s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
            ,s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
            ,s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
            ,s_info_compregaddress -- 债券主体公司国籍(注册地)
            ,s_info_comptype -- 债券主体类型
            ,s_info_listcompornot -- 是否上市公司
            ,s_info_effective_dt -- 生效日期
            ,s_info_invalid_dt -- 失效日期
            ,b_agency_guarantornature -- 公司属性
            ,is_fin_inst -- 是否金融机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbondissuer_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_compname -- 债券主体公司名称
            ,s_info_compcode -- 债券主体公司id
            ,used -- 是否有效
            ,s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
            ,s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
            ,s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
            ,s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
            ,s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
            ,s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
            ,s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
            ,s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
            ,s_info_compregaddress -- 债券主体公司国籍(注册地)
            ,s_info_comptype -- 债券主体类型
            ,s_info_listcompornot -- 是否上市公司
            ,s_info_effective_dt -- 生效日期
            ,s_info_invalid_dt -- 失效日期
            ,b_agency_guarantornature -- 公司属性
            ,is_fin_inst -- 是否金融机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.s_info_compname, o.s_info_compname) as s_info_compname -- 债券主体公司名称
    ,nvl(n.s_info_compcode, o.s_info_compcode) as s_info_compcode -- 债券主体公司id
    ,nvl(n.used, o.used) as used -- 是否有效
    ,nvl(n.s_info_compind_code1, o.s_info_compind_code1) as s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
    ,nvl(n.s_info_compind_name1, o.s_info_compind_name1) as s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
    ,nvl(n.s_info_compind_code2, o.s_info_compind_code2) as s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
    ,nvl(n.s_info_compind_name2, o.s_info_compind_name2) as s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
    ,nvl(n.s_info_compind_code3, o.s_info_compind_code3) as s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
    ,nvl(n.s_info_compind_name3, o.s_info_compind_name3) as s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
    ,nvl(n.s_info_compind_code4, o.s_info_compind_code4) as s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
    ,nvl(n.s_info_compind_name4, o.s_info_compind_name4) as s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
    ,nvl(n.s_info_compregaddress, o.s_info_compregaddress) as s_info_compregaddress -- 债券主体公司国籍(注册地)
    ,nvl(n.s_info_comptype, o.s_info_comptype) as s_info_comptype -- 债券主体类型
    ,nvl(n.s_info_listcompornot, o.s_info_listcompornot) as s_info_listcompornot -- 是否上市公司
    ,nvl(n.s_info_effective_dt, o.s_info_effective_dt) as s_info_effective_dt -- 生效日期
    ,nvl(n.s_info_invalid_dt, o.s_info_invalid_dt) as s_info_invalid_dt -- 失效日期
    ,nvl(n.b_agency_guarantornature, o.b_agency_guarantornature) as b_agency_guarantornature -- 公司属性
    ,nvl(n.is_fin_inst, o.is_fin_inst) as is_fin_inst -- 是否金融机构
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_cbondissuer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_cbondissuer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.s_info_compname <> n.s_info_compname
        or o.s_info_compcode <> n.s_info_compcode
        or o.used <> n.used
        or o.s_info_compind_code1 <> n.s_info_compind_code1
        or o.s_info_compind_name1 <> n.s_info_compind_name1
        or o.s_info_compind_code2 <> n.s_info_compind_code2
        or o.s_info_compind_name2 <> n.s_info_compind_name2
        or o.s_info_compind_code3 <> n.s_info_compind_code3
        or o.s_info_compind_name3 <> n.s_info_compind_name3
        or o.s_info_compind_code4 <> n.s_info_compind_code4
        or o.s_info_compind_name4 <> n.s_info_compind_name4
        or o.s_info_compregaddress <> n.s_info_compregaddress
        or o.s_info_comptype <> n.s_info_comptype
        or o.s_info_listcompornot <> n.s_info_listcompornot
        or o.s_info_effective_dt <> n.s_info_effective_dt
        or o.s_info_invalid_dt <> n.s_info_invalid_dt
        or o.b_agency_guarantornature <> n.b_agency_guarantornature
        or o.is_fin_inst <> n.is_fin_inst
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbondissuer_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_compname -- 债券主体公司名称
            ,s_info_compcode -- 债券主体公司id
            ,used -- 是否有效
            ,s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
            ,s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
            ,s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
            ,s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
            ,s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
            ,s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
            ,s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
            ,s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
            ,s_info_compregaddress -- 债券主体公司国籍(注册地)
            ,s_info_comptype -- 债券主体类型
            ,s_info_listcompornot -- 是否上市公司
            ,s_info_effective_dt -- 生效日期
            ,s_info_invalid_dt -- 失效日期
            ,b_agency_guarantornature -- 公司属性
            ,is_fin_inst -- 是否金融机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbondissuer_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_compname -- 债券主体公司名称
            ,s_info_compcode -- 债券主体公司id
            ,used -- 是否有效
            ,s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
            ,s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
            ,s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
            ,s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
            ,s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
            ,s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
            ,s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
            ,s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
            ,s_info_compregaddress -- 债券主体公司国籍(注册地)
            ,s_info_comptype -- 债券主体类型
            ,s_info_listcompornot -- 是否上市公司
            ,s_info_effective_dt -- 生效日期
            ,s_info_invalid_dt -- 失效日期
            ,b_agency_guarantornature -- 公司属性
            ,is_fin_inst -- 是否金融机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.s_info_compname -- 债券主体公司名称
    ,o.s_info_compcode -- 债券主体公司id
    ,o.used -- 是否有效
    ,o.s_info_compind_code1 -- 债券主体公司所属Wind一级行业代码
    ,o.s_info_compind_name1 -- 债券主体公司所属Wind一级行业名称
    ,o.s_info_compind_code2 -- 债券主体公司所属Wind二级行业代码
    ,o.s_info_compind_name2 -- 债券主体公司所属Wind二级行业名称
    ,o.s_info_compind_code3 -- 债券主体公司所属Wind三级行业代码
    ,o.s_info_compind_name3 -- 债券主体公司所属Wind三级行业名称
    ,o.s_info_compind_code4 -- 债券主体公司所属Wind四级行业代码
    ,o.s_info_compind_name4 -- 债券主体公司所属Wind四级行业名称
    ,o.s_info_compregaddress -- 债券主体公司国籍(注册地)
    ,o.s_info_comptype -- 债券主体类型
    ,o.s_info_listcompornot -- 是否上市公司
    ,o.s_info_effective_dt -- 生效日期
    ,o.s_info_invalid_dt -- 失效日期
    ,o.b_agency_guarantornature -- 公司属性
    ,o.is_fin_inst -- 是否金融机构
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_cbondissuer_bk o
    left join ${iol_schema}.wind_cbondissuer_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_cbondissuer_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_cbondissuer;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_cbondissuer exchange partition p_19000101 with table ${iol_schema}.wind_cbondissuer_cl;
alter table ${iol_schema}.wind_cbondissuer exchange partition p_20991231 with table ${iol_schema}.wind_cbondissuer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondissuer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondissuer_op purge;
drop table ${iol_schema}.wind_cbondissuer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_cbondissuer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondissuer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
