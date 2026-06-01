/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_bis_sa_country
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
create table ${iol_schema}.rwas_bis_sa_country_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rwas_bis_sa_country
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_bis_sa_country_op purge;
drop table ${iol_schema}.rwas_bis_sa_country_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_bis_sa_country_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_bis_sa_country where 0=1;

create table ${iol_schema}.rwas_bis_sa_country_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_bis_sa_country where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_bis_sa_country_cl(
            ser_num -- 序号
            ,bis_country_cd -- 计量注册国家代码
            ,bis_country_name -- 注册国名称
            ,spc_rating_no -- 评级序号
            ,spc_rating_cd -- 标普评级代码
            ,car_regul_requir -- 当地监管资本充足率要求
            ,tier1_car_regul_requir -- 当地监管一级资本充足率要求
            ,core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
            ,reserve_cap_regul_requir -- 当地监管储备资本要求要求
            ,concyc_cap_regul_requir -- 当地监管逆周期资本要求
            ,memo -- 备注
            ,para_version_num -- 参数版本号
            ,load_date -- 加载日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_bis_sa_country_op(
            ser_num -- 序号
            ,bis_country_cd -- 计量注册国家代码
            ,bis_country_name -- 注册国名称
            ,spc_rating_no -- 评级序号
            ,spc_rating_cd -- 标普评级代码
            ,car_regul_requir -- 当地监管资本充足率要求
            ,tier1_car_regul_requir -- 当地监管一级资本充足率要求
            ,core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
            ,reserve_cap_regul_requir -- 当地监管储备资本要求要求
            ,concyc_cap_regul_requir -- 当地监管逆周期资本要求
            ,memo -- 备注
            ,para_version_num -- 参数版本号
            ,load_date -- 加载日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ser_num, o.ser_num) as ser_num -- 序号
    ,nvl(n.bis_country_cd, o.bis_country_cd) as bis_country_cd -- 计量注册国家代码
    ,nvl(n.bis_country_name, o.bis_country_name) as bis_country_name -- 注册国名称
    ,nvl(n.spc_rating_no, o.spc_rating_no) as spc_rating_no -- 评级序号
    ,nvl(n.spc_rating_cd, o.spc_rating_cd) as spc_rating_cd -- 标普评级代码
    ,nvl(n.car_regul_requir, o.car_regul_requir) as car_regul_requir -- 当地监管资本充足率要求
    ,nvl(n.tier1_car_regul_requir, o.tier1_car_regul_requir) as tier1_car_regul_requir -- 当地监管一级资本充足率要求
    ,nvl(n.core_tier1_car_regul_requir, o.core_tier1_car_regul_requir) as core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
    ,nvl(n.reserve_cap_regul_requir, o.reserve_cap_regul_requir) as reserve_cap_regul_requir -- 当地监管储备资本要求要求
    ,nvl(n.concyc_cap_regul_requir, o.concyc_cap_regul_requir) as concyc_cap_regul_requir -- 当地监管逆周期资本要求
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.para_version_num, o.para_version_num) as para_version_num -- 参数版本号
    ,nvl(n.load_date, o.load_date) as load_date -- 加载日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,case when
            n.ser_num is null
            and n.para_version_num is null
            and n.start_date is null
            and n.end_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ser_num is null
            and n.para_version_num is null
            and n.start_date is null
            and n.end_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ser_num is null
            and n.para_version_num is null
            and n.start_date is null
            and n.end_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rwas_bis_sa_country_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rwas_bis_sa_country where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ser_num = n.ser_num
            and o.para_version_num = n.para_version_num
            and o.start_date = n.start_date
            and o.end_date = n.end_date
where (
        o.ser_num is null
        and o.para_version_num is null
        and o.start_date is null
        and o.end_date is null
    )
    or (
        n.ser_num is null
        and n.para_version_num is null
        and n.start_date is null
        and n.end_date is null
    )
    or (
        o.bis_country_cd <> n.bis_country_cd
        or o.bis_country_name <> n.bis_country_name
        or o.spc_rating_no <> n.spc_rating_no
        or o.spc_rating_cd <> n.spc_rating_cd
        or o.car_regul_requir <> n.car_regul_requir
        or o.tier1_car_regul_requir <> n.tier1_car_regul_requir
        or o.core_tier1_car_regul_requir <> n.core_tier1_car_regul_requir
        or o.reserve_cap_regul_requir <> n.reserve_cap_regul_requir
        or o.concyc_cap_regul_requir <> n.concyc_cap_regul_requir
        or o.memo <> n.memo
        or o.load_date <> n.load_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rwas_bis_sa_country_cl(
            ser_num -- 序号
            ,bis_country_cd -- 计量注册国家代码
            ,bis_country_name -- 注册国名称
            ,spc_rating_no -- 评级序号
            ,spc_rating_cd -- 标普评级代码
            ,car_regul_requir -- 当地监管资本充足率要求
            ,tier1_car_regul_requir -- 当地监管一级资本充足率要求
            ,core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
            ,reserve_cap_regul_requir -- 当地监管储备资本要求要求
            ,concyc_cap_regul_requir -- 当地监管逆周期资本要求
            ,memo -- 备注
            ,para_version_num -- 参数版本号
            ,load_date -- 加载日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rwas_bis_sa_country_op(
            ser_num -- 序号
            ,bis_country_cd -- 计量注册国家代码
            ,bis_country_name -- 注册国名称
            ,spc_rating_no -- 评级序号
            ,spc_rating_cd -- 标普评级代码
            ,car_regul_requir -- 当地监管资本充足率要求
            ,tier1_car_regul_requir -- 当地监管一级资本充足率要求
            ,core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
            ,reserve_cap_regul_requir -- 当地监管储备资本要求要求
            ,concyc_cap_regul_requir -- 当地监管逆周期资本要求
            ,memo -- 备注
            ,para_version_num -- 参数版本号
            ,load_date -- 加载日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ser_num -- 序号
    ,o.bis_country_cd -- 计量注册国家代码
    ,o.bis_country_name -- 注册国名称
    ,o.spc_rating_no -- 评级序号
    ,o.spc_rating_cd -- 标普评级代码
    ,o.car_regul_requir -- 当地监管资本充足率要求
    ,o.tier1_car_regul_requir -- 当地监管一级资本充足率要求
    ,o.core_tier1_car_regul_requir -- 当地监管核心一级资本充足率要求
    ,o.reserve_cap_regul_requir -- 当地监管储备资本要求要求
    ,o.concyc_cap_regul_requir -- 当地监管逆周期资本要求
    ,o.memo -- 备注
    ,o.para_version_num -- 参数版本号
    ,o.load_date -- 加载日期
    ,o.start_date -- 开始日期
    ,o.end_date -- 结束日期
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
from ${iol_schema}.rwas_bis_sa_country_bk o
    left join ${iol_schema}.rwas_bis_sa_country_op n
        on
            o.ser_num = n.ser_num
            and o.para_version_num = n.para_version_num
            and o.start_date = n.start_date
            and o.end_date = n.end_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rwas_bis_sa_country_cl d
        on
            o.ser_num = d.ser_num
            and o.para_version_num = d.para_version_num
            and o.start_date = d.start_date
            and o.end_date = d.end_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rwas_bis_sa_country;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rwas_bis_sa_country') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rwas_bis_sa_country drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rwas_bis_sa_country add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rwas_bis_sa_country exchange partition p_${batch_date} with table ${iol_schema}.rwas_bis_sa_country_cl;
alter table ${iol_schema}.rwas_bis_sa_country exchange partition p_20991231 with table ${iol_schema}.rwas_bis_sa_country_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_bis_sa_country to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rwas_bis_sa_country_op purge;
drop table ${iol_schema}.rwas_bis_sa_country_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rwas_bis_sa_country_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_bis_sa_country',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
