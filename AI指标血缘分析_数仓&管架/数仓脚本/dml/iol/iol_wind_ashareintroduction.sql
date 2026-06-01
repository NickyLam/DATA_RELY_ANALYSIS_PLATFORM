/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareintroduction
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
create table ${iol_schema}.wind_ashareintroduction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_ashareintroduction
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareintroduction_op purge;
drop table ${iol_schema}.wind_ashareintroduction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareintroduction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareintroduction where 0=1;

create table ${iol_schema}.wind_ashareintroduction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareintroduction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareintroduction_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_chineseintroduction -- 公司中文简介
            ,s_info_comptype -- 公司类型
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_country -- 国籍
            ,s_info_businessscope -- 经营范围
            ,s_info_company_type -- 公司类别
            ,s_info_totalemployees -- 员工总数(人)
            ,s_info_main_business -- 主要产品及业务
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareintroduction_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_chineseintroduction -- 公司中文简介
            ,s_info_comptype -- 公司类型
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_country -- 国籍
            ,s_info_businessscope -- 经营范围
            ,s_info_company_type -- 公司类别
            ,s_info_totalemployees -- 员工总数(人)
            ,s_info_main_business -- 主要产品及业务
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.s_info_province, o.s_info_province) as s_info_province -- 省份
    ,nvl(n.s_info_city, o.s_info_city) as s_info_city -- 城市
    ,nvl(n.s_info_chairman, o.s_info_chairman) as s_info_chairman -- 法人代表
    ,nvl(n.s_info_president, o.s_info_president) as s_info_president -- 总经理
    ,nvl(n.s_info_bdsecretary, o.s_info_bdsecretary) as s_info_bdsecretary -- 董事会秘书
    ,nvl(n.s_info_regcapital, o.s_info_regcapital) as s_info_regcapital -- 注册资本(万元)
    ,nvl(n.s_info_founddate, o.s_info_founddate) as s_info_founddate -- 成立日期
    ,nvl(n.s_info_chineseintroduction, o.s_info_chineseintroduction) as s_info_chineseintroduction -- 公司中文简介
    ,nvl(n.s_info_comptype, o.s_info_comptype) as s_info_comptype -- 公司类型
    ,nvl(n.s_info_website, o.s_info_website) as s_info_website -- 主页
    ,nvl(n.s_info_email, o.s_info_email) as s_info_email -- 电子邮箱
    ,nvl(n.s_info_office, o.s_info_office) as s_info_office -- 办公地址
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 公告日期
    ,nvl(n.s_info_country, o.s_info_country) as s_info_country -- 国籍
    ,nvl(n.s_info_businessscope, o.s_info_businessscope) as s_info_businessscope -- 经营范围
    ,nvl(n.s_info_company_type, o.s_info_company_type) as s_info_company_type -- 公司类别
    ,nvl(n.s_info_totalemployees, o.s_info_totalemployees) as s_info_totalemployees -- 员工总数(人)
    ,nvl(n.s_info_main_business, o.s_info_main_business) as s_info_main_business -- 主要产品及业务
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
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
from (select * from ${iol_schema}.wind_ashareintroduction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_ashareintroduction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.s_info_province <> n.s_info_province
        or o.s_info_city <> n.s_info_city
        or o.s_info_chairman <> n.s_info_chairman
        or o.s_info_president <> n.s_info_president
        or o.s_info_bdsecretary <> n.s_info_bdsecretary
        or o.s_info_regcapital <> n.s_info_regcapital
        or o.s_info_founddate <> n.s_info_founddate
        or o.s_info_chineseintroduction <> n.s_info_chineseintroduction
        or o.s_info_comptype <> n.s_info_comptype
        or o.s_info_website <> n.s_info_website
        or o.s_info_email <> n.s_info_email
        or o.s_info_office <> n.s_info_office
        or o.ann_dt <> n.ann_dt
        or o.s_info_country <> n.s_info_country
        or o.s_info_businessscope <> n.s_info_businessscope
        or o.s_info_company_type <> n.s_info_company_type
        or o.s_info_totalemployees <> n.s_info_totalemployees
        or o.s_info_main_business <> n.s_info_main_business
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_ashareintroduction_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_chineseintroduction -- 公司中文简介
            ,s_info_comptype -- 公司类型
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_country -- 国籍
            ,s_info_businessscope -- 经营范围
            ,s_info_company_type -- 公司类别
            ,s_info_totalemployees -- 员工总数(人)
            ,s_info_main_business -- 主要产品及业务
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_ashareintroduction_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_province -- 省份
            ,s_info_city -- 城市
            ,s_info_chairman -- 法人代表
            ,s_info_president -- 总经理
            ,s_info_bdsecretary -- 董事会秘书
            ,s_info_regcapital -- 注册资本(万元)
            ,s_info_founddate -- 成立日期
            ,s_info_chineseintroduction -- 公司中文简介
            ,s_info_comptype -- 公司类型
            ,s_info_website -- 主页
            ,s_info_email -- 电子邮箱
            ,s_info_office -- 办公地址
            ,ann_dt -- 公告日期
            ,s_info_country -- 国籍
            ,s_info_businessscope -- 经营范围
            ,s_info_company_type -- 公司类别
            ,s_info_totalemployees -- 员工总数(人)
            ,s_info_main_business -- 主要产品及业务
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.s_info_province -- 省份
    ,o.s_info_city -- 城市
    ,o.s_info_chairman -- 法人代表
    ,o.s_info_president -- 总经理
    ,o.s_info_bdsecretary -- 董事会秘书
    ,o.s_info_regcapital -- 注册资本(万元)
    ,o.s_info_founddate -- 成立日期
    ,o.s_info_chineseintroduction -- 公司中文简介
    ,o.s_info_comptype -- 公司类型
    ,o.s_info_website -- 主页
    ,o.s_info_email -- 电子邮箱
    ,o.s_info_office -- 办公地址
    ,o.ann_dt -- 公告日期
    ,o.s_info_country -- 国籍
    ,o.s_info_businessscope -- 经营范围
    ,o.s_info_company_type -- 公司类别
    ,o.s_info_totalemployees -- 员工总数(人)
    ,o.s_info_main_business -- 主要产品及业务
    ,o.opdate -- 
    ,o.opmode -- 
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
from ${iol_schema}.wind_ashareintroduction_bk o
    left join ${iol_schema}.wind_ashareintroduction_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_ashareintroduction_cl d
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
--truncate table ${iol_schema}.wind_ashareintroduction;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_ashareintroduction') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_ashareintroduction drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_ashareintroduction add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_ashareintroduction exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareintroduction_cl;
alter table ${iol_schema}.wind_ashareintroduction exchange partition p_20991231 with table ${iol_schema}.wind_ashareintroduction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareintroduction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_ashareintroduction_op purge;
drop table ${iol_schema}.wind_ashareintroduction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_ashareintroduction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareintroduction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
