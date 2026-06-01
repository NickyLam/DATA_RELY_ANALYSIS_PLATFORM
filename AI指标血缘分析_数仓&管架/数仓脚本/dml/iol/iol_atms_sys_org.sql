/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_sys_org
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
create table ${iol_schema}.atms_sys_org_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_sys_org
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_sys_org_op purge;
drop table ${iol_schema}.atms_sys_org_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_sys_org_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_sys_org where 0=1;

create table ${iol_schema}.atms_sys_org_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_sys_org where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_sys_org_cl(
            no -- 机构编号
            ,name -- 机构名称
            ,parent_org -- 上级机构
            ,left_no -- 预排序左序号
            ,right_no -- 预排序右序号
            ,org_type -- 机构类型
            ,moneyorg_flag -- 是否是加钞机构
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,address -- 地址
            ,linkman -- 联系人
            ,telephone -- 电话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,business_range -- 业务范围
            ,cup_area_code -- 银联标准地区代码
            ,address_code -- 地点代码
            ,area_no_province -- 所属省级区域编码
            ,area_no_city -- 所属地市级区域编码
            ,area_no_county -- 所属县级区域编码
            ,area_type -- 所处区域类型
            ,org_physics_catalog -- 物理网点类型
            ,note -- 备注
            ,is_selfhelp -- 是否是自助银行
            ,is_bankoutlet -- 是否是网点
            ,area_no -- 区域编码
            ,org_status -- 机构状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_sys_org_op(
            no -- 机构编号
            ,name -- 机构名称
            ,parent_org -- 上级机构
            ,left_no -- 预排序左序号
            ,right_no -- 预排序右序号
            ,org_type -- 机构类型
            ,moneyorg_flag -- 是否是加钞机构
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,address -- 地址
            ,linkman -- 联系人
            ,telephone -- 电话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,business_range -- 业务范围
            ,cup_area_code -- 银联标准地区代码
            ,address_code -- 地点代码
            ,area_no_province -- 所属省级区域编码
            ,area_no_city -- 所属地市级区域编码
            ,area_no_county -- 所属县级区域编码
            ,area_type -- 所处区域类型
            ,org_physics_catalog -- 物理网点类型
            ,note -- 备注
            ,is_selfhelp -- 是否是自助银行
            ,is_bankoutlet -- 是否是网点
            ,area_no -- 区域编码
            ,org_status -- 机构状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.no, o.no) as no -- 机构编号
    ,nvl(n.name, o.name) as name -- 机构名称
    ,nvl(n.parent_org, o.parent_org) as parent_org -- 上级机构
    ,nvl(n.left_no, o.left_no) as left_no -- 预排序左序号
    ,nvl(n.right_no, o.right_no) as right_no -- 预排序右序号
    ,nvl(n.org_type, o.org_type) as org_type -- 机构类型
    ,nvl(n.moneyorg_flag, o.moneyorg_flag) as moneyorg_flag -- 是否是加钞机构
    ,nvl(n.x, o.x) as x -- 横坐标（经度）
    ,nvl(n.y, o.y) as y -- 纵坐标（纬度）
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.mobile, o.mobile) as mobile -- 手机
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.email, o.email) as email -- 电子邮箱
    ,nvl(n.business_range, o.business_range) as business_range -- 业务范围
    ,nvl(n.cup_area_code, o.cup_area_code) as cup_area_code -- 银联标准地区代码
    ,nvl(n.address_code, o.address_code) as address_code -- 地点代码
    ,nvl(n.area_no_province, o.area_no_province) as area_no_province -- 所属省级区域编码
    ,nvl(n.area_no_city, o.area_no_city) as area_no_city -- 所属地市级区域编码
    ,nvl(n.area_no_county, o.area_no_county) as area_no_county -- 所属县级区域编码
    ,nvl(n.area_type, o.area_type) as area_type -- 所处区域类型
    ,nvl(n.org_physics_catalog, o.org_physics_catalog) as org_physics_catalog -- 物理网点类型
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.is_selfhelp, o.is_selfhelp) as is_selfhelp -- 是否是自助银行
    ,nvl(n.is_bankoutlet, o.is_bankoutlet) as is_bankoutlet -- 是否是网点
    ,nvl(n.area_no, o.area_no) as area_no -- 区域编码
    ,nvl(n.org_status, o.org_status) as org_status -- 机构状态
    ,case when
            n.no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_sys_org_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_sys_org where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.no = n.no
where (
        o.no is null
    )
    or (
        n.no is null
    )
    or (
        o.name <> n.name
        or o.parent_org <> n.parent_org
        or o.left_no <> n.left_no
        or o.right_no <> n.right_no
        or o.org_type <> n.org_type
        or o.moneyorg_flag <> n.moneyorg_flag
        or o.x <> n.x
        or o.y <> n.y
        or o.address <> n.address
        or o.linkman <> n.linkman
        or o.telephone <> n.telephone
        or o.mobile <> n.mobile
        or o.fax <> n.fax
        or o.email <> n.email
        or o.business_range <> n.business_range
        or o.cup_area_code <> n.cup_area_code
        or o.address_code <> n.address_code
        or o.area_no_province <> n.area_no_province
        or o.area_no_city <> n.area_no_city
        or o.area_no_county <> n.area_no_county
        or o.area_type <> n.area_type
        or o.org_physics_catalog <> n.org_physics_catalog
        or o.note <> n.note
        or o.is_selfhelp <> n.is_selfhelp
        or o.is_bankoutlet <> n.is_bankoutlet
        or o.area_no <> n.area_no
        or o.org_status <> n.org_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_sys_org_cl(
            no -- 机构编号
            ,name -- 机构名称
            ,parent_org -- 上级机构
            ,left_no -- 预排序左序号
            ,right_no -- 预排序右序号
            ,org_type -- 机构类型
            ,moneyorg_flag -- 是否是加钞机构
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,address -- 地址
            ,linkman -- 联系人
            ,telephone -- 电话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,business_range -- 业务范围
            ,cup_area_code -- 银联标准地区代码
            ,address_code -- 地点代码
            ,area_no_province -- 所属省级区域编码
            ,area_no_city -- 所属地市级区域编码
            ,area_no_county -- 所属县级区域编码
            ,area_type -- 所处区域类型
            ,org_physics_catalog -- 物理网点类型
            ,note -- 备注
            ,is_selfhelp -- 是否是自助银行
            ,is_bankoutlet -- 是否是网点
            ,area_no -- 区域编码
            ,org_status -- 机构状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_sys_org_op(
            no -- 机构编号
            ,name -- 机构名称
            ,parent_org -- 上级机构
            ,left_no -- 预排序左序号
            ,right_no -- 预排序右序号
            ,org_type -- 机构类型
            ,moneyorg_flag -- 是否是加钞机构
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,address -- 地址
            ,linkman -- 联系人
            ,telephone -- 电话
            ,mobile -- 手机
            ,fax -- 传真
            ,email -- 电子邮箱
            ,business_range -- 业务范围
            ,cup_area_code -- 银联标准地区代码
            ,address_code -- 地点代码
            ,area_no_province -- 所属省级区域编码
            ,area_no_city -- 所属地市级区域编码
            ,area_no_county -- 所属县级区域编码
            ,area_type -- 所处区域类型
            ,org_physics_catalog -- 物理网点类型
            ,note -- 备注
            ,is_selfhelp -- 是否是自助银行
            ,is_bankoutlet -- 是否是网点
            ,area_no -- 区域编码
            ,org_status -- 机构状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.no -- 机构编号
    ,o.name -- 机构名称
    ,o.parent_org -- 上级机构
    ,o.left_no -- 预排序左序号
    ,o.right_no -- 预排序右序号
    ,o.org_type -- 机构类型
    ,o.moneyorg_flag -- 是否是加钞机构
    ,o.x -- 横坐标（经度）
    ,o.y -- 纵坐标（纬度）
    ,o.address -- 地址
    ,o.linkman -- 联系人
    ,o.telephone -- 电话
    ,o.mobile -- 手机
    ,o.fax -- 传真
    ,o.email -- 电子邮箱
    ,o.business_range -- 业务范围
    ,o.cup_area_code -- 银联标准地区代码
    ,o.address_code -- 地点代码
    ,o.area_no_province -- 所属省级区域编码
    ,o.area_no_city -- 所属地市级区域编码
    ,o.area_no_county -- 所属县级区域编码
    ,o.area_type -- 所处区域类型
    ,o.org_physics_catalog -- 物理网点类型
    ,o.note -- 备注
    ,o.is_selfhelp -- 是否是自助银行
    ,o.is_bankoutlet -- 是否是网点
    ,o.area_no -- 区域编码
    ,o.org_status -- 机构状态
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
from ${iol_schema}.atms_sys_org_bk o
    left join ${iol_schema}.atms_sys_org_op n
        on
            o.no = n.no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_sys_org_cl d
        on
            o.no = d.no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_sys_org;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_sys_org') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_sys_org drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_sys_org add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_sys_org exchange partition p_${batch_date} with table ${iol_schema}.atms_sys_org_cl;
alter table ${iol_schema}.atms_sys_org exchange partition p_20991231 with table ${iol_schema}.atms_sys_org_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_sys_org to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_sys_org_op purge;
drop table ${iol_schema}.atms_sys_org_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_sys_org_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_sys_org',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
