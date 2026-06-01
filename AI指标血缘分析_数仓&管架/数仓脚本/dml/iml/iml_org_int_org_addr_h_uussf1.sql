/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_org_int_org_addr_h_uussf1
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
alter table ${iml_schema}.org_int_org_addr_h add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_uussf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.org_int_org_addr_h_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_addr_h partition for ('uussf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.org_int_org_addr_h_uussf1_tm purge;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_op purge;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_int_org_addr_h_uussf1_tm nologging
compress ${option_switch} for query high
as select
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_addr_h partition for ('uussf1')
where 0=1
;

create table ${iml_schema}.org_int_org_addr_h_uussf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_addr_h partition for ('uussf1') where 0=1;

create table ${iml_schema}.org_int_org_addr_h_uussf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_int_org_addr_h partition for ('uussf1') where 0=1;

-- 3.1 get new data into table
-- uuss_uus_organ-
insert into ${iml_schema}.org_int_org_addr_h_uussf1_tm(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ORGANCODE -- 机构编号
    ,'9999' -- 法人编号
    ,P1.PHONE -- 电话号码
    ,P1.POSTCODE -- 邮政编码
    ,nvl(trim(P1.COUNTRY),'XXX') -- 国家或地区代码
    ,P1.PROVINCE -- 省代码
    ,P1.CITY -- 市代码
    ,P1.COUNTY -- 县代码
    ,P1.ADDRESS -- 详细地址
    ,P1.HEADEMPLYID -- 负责人员工编号
    ,' ' -- 负责人姓名
    ,P1.AREACODE -- 国内长途区号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_organ' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_organ p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.org_int_org_addr_h_uussf1_tm 
  	                                group by 
  	                                        org_id
  	                                        ,lp_id
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
        into ${iml_schema}.org_int_org_addr_h_uussf1_cl(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.org_int_org_addr_h_uussf1_op(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.cty_or_rg_cd, o.cty_or_rg_cd) as cty_or_rg_cd -- 国家或地区代码
    ,nvl(n.prov_cd, o.prov_cd) as prov_cd -- 省代码
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 市代码
    ,nvl(n.county_cd, o.county_cd) as county_cd -- 县代码
    ,nvl(n.dtl_addr, o.dtl_addr) as dtl_addr -- 详细地址
    ,nvl(n.princ_emply_id, o.princ_emply_id) as princ_emply_id -- 负责人员工编号
    ,nvl(n.princ_name, o.princ_name) as princ_name -- 负责人姓名
    ,nvl(n.ddd_area_cd, o.ddd_area_cd) as ddd_area_cd -- 国内长途区号
    ,case when
            n.org_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.org_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.org_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_addr_h_uussf1_tm n
    full join (select * from ${iml_schema}.org_int_org_addr_h_uussf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
where (
        o.org_id is null
        and o.lp_id is null
    )
    or (
        n.org_id is null
        and n.lp_id is null
    )
    or (
        o.tel_num <> n.tel_num
        or o.zip_cd <> n.zip_cd
        or o.cty_or_rg_cd <> n.cty_or_rg_cd
        or o.prov_cd <> n.prov_cd
        or o.city_cd <> n.city_cd
        or o.county_cd <> n.county_cd
        or o.dtl_addr <> n.dtl_addr
        or o.princ_emply_id <> n.princ_emply_id
        or o.princ_name <> n.princ_name
        or o.ddd_area_cd <> n.ddd_area_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.org_int_org_addr_h_uussf1_cl(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.org_int_org_addr_h_uussf1_op(
            org_id -- 机构编号
    ,lp_id -- 法人编号
    ,tel_num -- 电话号码
    ,zip_cd -- 邮政编码
    ,cty_or_rg_cd -- 国家或地区代码
    ,prov_cd -- 省代码
    ,city_cd -- 市代码
    ,county_cd -- 县代码
    ,dtl_addr -- 详细地址
    ,princ_emply_id -- 负责人员工编号
    ,princ_name -- 负责人姓名
    ,ddd_area_cd -- 国内长途区号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org_id -- 机构编号
    ,o.lp_id -- 法人编号
    ,o.tel_num -- 电话号码
    ,o.zip_cd -- 邮政编码
    ,o.cty_or_rg_cd -- 国家或地区代码
    ,o.prov_cd -- 省代码
    ,o.city_cd -- 市代码
    ,o.county_cd -- 县代码
    ,o.dtl_addr -- 详细地址
    ,o.princ_emply_id -- 负责人员工编号
    ,o.princ_name -- 负责人姓名
    ,o.ddd_area_cd -- 国内长途区号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_int_org_addr_h_uussf1_bk o
    left join ${iml_schema}.org_int_org_addr_h_uussf1_op n
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.org_int_org_addr_h_uussf1_cl d
        on
            o.org_id = d.org_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.org_int_org_addr_h;
--alter table ${iml_schema}.org_int_org_addr_h truncate partition for ('uussf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('org_int_org_addr_h') 
               and substr(subpartition_name,1,8)=upper('p_uussf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.org_int_org_addr_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.org_int_org_addr_h modify partition p_uussf1 
add subpartition p_uussf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.org_int_org_addr_h exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.org_int_org_addr_h_uussf1_cl;
alter table ${iml_schema}.org_int_org_addr_h exchange subpartition p_uussf1_20991231 with table ${iml_schema}.org_int_org_addr_h_uussf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.org_int_org_addr_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_tm purge;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_op purge;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.org_int_org_addr_h_uussf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'org_int_org_addr_h', partname => 'p_uussf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
