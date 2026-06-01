/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hxyhcombasinfo
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_hxyhcombasinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hxyhcombasinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hxyhcombasinfo_op purge;
drop table ${iol_schema}.wind_hxyhcombasinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhcombasinfo_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hxyhcombasinfo where 0=1;

create table ${iol_schema}.wind_hxyhcombasinfo_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hxyhcombasinfo where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_hxyhcombasinfo_op(
        object_id -- 对象ID
        ,comp_id -- 公司ID
        ,comp_name -- 公司名称
        ,comp_sname -- 公司中文简称
        ,province -- 省份
        ,city -- 城市
        ,address -- 注册地址
        ,office -- 办公地址
        ,register_number -- 工商登记号
        ,regcapital -- 注册资本(万元)
        ,currencycode -- 货币代码
        ,chairman -- 法人代表
        ,founddate -- 成立日期
        ,enddate -- 公司终止日期
        ,s_info_totalemployees -- 员工总数(人)
        ,business_scope -- 经营范围
        ,s_info_org_code -- 组织机构代码
        ,wind_ind_code -- WIND行业代码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.comp_id -- 公司ID
    ,n.comp_name -- 公司名称
    ,n.comp_sname -- 公司中文简称
    ,n.province -- 省份
    ,n.city -- 城市
    ,n.address -- 注册地址
    ,n.office -- 办公地址
    ,n.register_number -- 工商登记号
    ,n.regcapital -- 注册资本(万元)
    ,n.currencycode -- 货币代码
    ,n.chairman -- 法人代表
    ,n.founddate -- 成立日期
    ,n.enddate -- 公司终止日期
    ,n.s_info_totalemployees -- 员工总数(人)
    ,n.business_scope -- 经营范围
    ,n.s_info_org_code -- 组织机构代码
    ,n.wind_ind_code -- WIND行业代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_hxyhcombasinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_hxyhcombasinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
            and o.comp_id = n.comp_id
            and o.register_number = n.register_number
where (
        o.object_id is null
        and o.comp_id is null
        and o.register_number is null
    )
    or (
        o.comp_name <> n.comp_name
        or o.comp_sname <> n.comp_sname
        or o.province <> n.province
        or o.city <> n.city
        or o.address <> n.address
        or o.office <> n.office
        or o.regcapital <> n.regcapital
        or o.currencycode <> n.currencycode
        or o.chairman <> n.chairman
        or o.founddate <> n.founddate
        or o.enddate <> n.enddate
        or o.s_info_totalemployees <> n.s_info_totalemployees
        or o.business_scope <> n.business_scope
        or o.s_info_org_code <> n.s_info_org_code
        or o.wind_ind_code <> n.wind_ind_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hxyhcombasinfo_cl(
            object_id -- 对象ID
        ,comp_id -- 公司ID
        ,comp_name -- 公司名称
        ,comp_sname -- 公司中文简称
        ,province -- 省份
        ,city -- 城市
        ,address -- 注册地址
        ,office -- 办公地址
        ,register_number -- 工商登记号
        ,regcapital -- 注册资本(万元)
        ,currencycode -- 货币代码
        ,chairman -- 法人代表
        ,founddate -- 成立日期
        ,enddate -- 公司终止日期
        ,s_info_totalemployees -- 员工总数(人)
        ,business_scope -- 经营范围
        ,s_info_org_code -- 组织机构代码
        ,wind_ind_code -- WIND行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hxyhcombasinfo_op(
            object_id -- 对象ID
        ,comp_id -- 公司ID
        ,comp_name -- 公司名称
        ,comp_sname -- 公司中文简称
        ,province -- 省份
        ,city -- 城市
        ,address -- 注册地址
        ,office -- 办公地址
        ,register_number -- 工商登记号
        ,regcapital -- 注册资本(万元)
        ,currencycode -- 货币代码
        ,chairman -- 法人代表
        ,founddate -- 成立日期
        ,enddate -- 公司终止日期
        ,s_info_totalemployees -- 员工总数(人)
        ,business_scope -- 经营范围
        ,s_info_org_code -- 组织机构代码
        ,wind_ind_code -- WIND行业代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.comp_id -- 公司ID
    ,o.comp_name -- 公司名称
    ,o.comp_sname -- 公司中文简称
    ,o.province -- 省份
    ,o.city -- 城市
    ,o.address -- 注册地址
    ,o.office -- 办公地址
    ,o.register_number -- 工商登记号
    ,o.regcapital -- 注册资本(万元)
    ,o.currencycode -- 货币代码
    ,o.chairman -- 法人代表
    ,o.founddate -- 成立日期
    ,o.enddate -- 公司终止日期
    ,o.s_info_totalemployees -- 员工总数(人)
    ,o.business_scope -- 经营范围
    ,o.s_info_org_code -- 组织机构代码
    ,o.wind_ind_code -- WIND行业代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hxyhcombasinfo_bk o
    left join ${iol_schema}.wind_hxyhcombasinfo_op n
        on
            o.object_id = n.object_id
            and o.comp_id = n.comp_id
            and o.register_number = n.register_number
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_hxyhcombasinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_hxyhcombasinfo exchange partition p_19000101 with table ${iol_schema}.wind_hxyhcombasinfo_cl;
alter table ${iol_schema}.wind_hxyhcombasinfo exchange partition p_20991231 with table ${iol_schema}.wind_hxyhcombasinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hxyhcombasinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hxyhcombasinfo_op purge;
drop table ${iol_schema}.wind_hxyhcombasinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hxyhcombasinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hxyhcombasinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
