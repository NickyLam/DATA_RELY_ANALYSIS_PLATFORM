/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_city_cd_para_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_city_cd_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_city_cd_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_city_cd_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_city_cd_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_city_cd_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_city_cd_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_city_cd_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_city_cd_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_city_cd_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_fm_city-1
insert into ${iml_schema}.ref_city_cd_para_ncbsf1_tm(
    lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.COUNTRY -- 所属国家和地区代码
    ,P1.STATE -- 所属省代码
    ,P1.CITY -- 城市代码
    ,P1.CITY_DESC -- 城市名称
    ,P1.ATTACHED_TO -- 上级城市代码
    ,P1.CITY_TEL -- 电话区号
    ,P1.POSTAL_CODE -- 邮政编码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_fm_city' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_fm_city p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_city_cd_para_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,belong_cty_rg_cd
  	                                        ,belong_prov_cd
  	                                        ,city_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_city_cd_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_city_cd_para_ncbsf1_op(
            lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.belong_cty_rg_cd, o.belong_cty_rg_cd) as belong_cty_rg_cd -- 所属国家和地区代码
    ,nvl(n.belong_prov_cd, o.belong_prov_cd) as belong_prov_cd -- 所属省代码
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 城市代码
    ,nvl(n.city_name, o.city_name) as city_name -- 城市名称
    ,nvl(n.super_city_cd, o.super_city_cd) as super_city_cd -- 上级城市代码
    ,nvl(n.tel_zone_cd, o.tel_zone_cd) as tel_zone_cd -- 电话区号
    ,nvl(n.zip_code, o.zip_code) as zip_code -- 邮政编码
    ,case when
            n.lp_id is null
            and n.belong_cty_rg_cd is null
            and n.belong_prov_cd is null
            and n.city_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.belong_cty_rg_cd is null
            and n.belong_prov_cd is null
            and n.city_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.belong_cty_rg_cd is null
            and n.belong_prov_cd is null
            and n.city_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_city_cd_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_city_cd_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.belong_cty_rg_cd = n.belong_cty_rg_cd
            and o.belong_prov_cd = n.belong_prov_cd
            and o.city_cd = n.city_cd
where (
        o.lp_id is null
        and o.belong_cty_rg_cd is null
        and o.belong_prov_cd is null
        and o.city_cd is null
    )
    or (
        n.lp_id is null
        and n.belong_cty_rg_cd is null
        and n.belong_prov_cd is null
        and n.city_cd is null
    )
    or (
        o.city_name <> n.city_name
        or o.super_city_cd <> n.super_city_cd
        or o.tel_zone_cd <> n.tel_zone_cd
        or o.zip_code <> n.zip_code
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_city_cd_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_city_cd_para_ncbsf1_op(
            lp_id -- 法人编号
    ,belong_cty_rg_cd -- 所属国家和地区代码
    ,belong_prov_cd -- 所属省代码
    ,city_cd -- 城市代码
    ,city_name -- 城市名称
    ,super_city_cd -- 上级城市代码
    ,tel_zone_cd -- 电话区号
    ,zip_code -- 邮政编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.belong_cty_rg_cd -- 所属国家和地区代码
    ,o.belong_prov_cd -- 所属省代码
    ,o.city_cd -- 城市代码
    ,o.city_name -- 城市名称
    ,o.super_city_cd -- 上级城市代码
    ,o.tel_zone_cd -- 电话区号
    ,o.zip_code -- 邮政编码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_city_cd_para_ncbsf1_bk o
    left join ${iml_schema}.ref_city_cd_para_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.belong_cty_rg_cd = n.belong_cty_rg_cd
            and o.belong_prov_cd = n.belong_prov_cd
            and o.city_cd = n.city_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_city_cd_para_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.belong_cty_rg_cd = d.belong_cty_rg_cd
            and o.belong_prov_cd = d.belong_prov_cd
            and o.city_cd = d.city_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_city_cd_para;
alter table ${iml_schema}.ref_city_cd_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_city_cd_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_city_cd_para_ncbsf1_cl;
alter table ${iml_schema}.ref_city_cd_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_city_cd_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_city_cd_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_city_cd_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_city_cd_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
