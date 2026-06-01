/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_rg_holiday_para_ncbsf1
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
alter table ${iml_schema}.ref_rg_holiday_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_rg_holiday_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rg_holiday_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rg_holiday_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_rg_holiday_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rg_holiday_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rg_holiday_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_fm_loc_holiday-1
insert into ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm(
    lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.HOLIDAY_TYPE -- 假日类型代码
    ,P1.COUNTRY -- 所在国家和地区代码
    ,P1.STATE -- 所在省代码
    ,P1.HOLIDAY_DATE -- 假日日期
    ,P1.HOLIDAY_DESC -- 假日类型描述
    ,DECODE(P1.WORKING_HOLIDAY,'W','1','H','0') -- 工作日标志
    ,P1.APPLY_IND -- 适用范围代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_fm_loc_holiday' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_fm_loc_holiday p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,holiday_type_cd
  	                                        ,local_cty_rg_cd
  	                                        ,local_prov_cd
  	                                        ,holiday_dt
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
        into ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_rg_holiday_para_ncbsf1_op(
            lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.holiday_type_cd, o.holiday_type_cd) as holiday_type_cd -- 假日类型代码
    ,nvl(n.local_cty_rg_cd, o.local_cty_rg_cd) as local_cty_rg_cd -- 所在国家和地区代码
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.holiday_dt, o.holiday_dt) as holiday_dt -- 假日日期
    ,nvl(n.holiday_type_descb, o.holiday_type_descb) as holiday_type_descb -- 假日类型描述
    ,nvl(n.wd_flg, o.wd_flg) as wd_flg -- 工作日标志
    ,nvl(n.fit_range_cd, o.fit_range_cd) as fit_range_cd -- 适用范围代码
    ,case when
            n.lp_id is null
            and n.holiday_type_cd is null
            and n.local_cty_rg_cd is null
            and n.local_prov_cd is null
            and n.holiday_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.holiday_type_cd is null
            and n.local_cty_rg_cd is null
            and n.local_prov_cd is null
            and n.holiday_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.holiday_type_cd is null
            and n.local_cty_rg_cd is null
            and n.local_prov_cd is null
            and n.holiday_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_rg_holiday_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.holiday_type_cd = n.holiday_type_cd
            and o.local_cty_rg_cd = n.local_cty_rg_cd
            and o.local_prov_cd = n.local_prov_cd
            and o.holiday_dt = n.holiday_dt
where (
        o.lp_id is null
        and o.holiday_type_cd is null
        and o.local_cty_rg_cd is null
        and o.local_prov_cd is null
        and o.holiday_dt is null
    )
    or (
        n.lp_id is null
        and n.holiday_type_cd is null
        and n.local_cty_rg_cd is null
        and n.local_prov_cd is null
        and n.holiday_dt is null
    )
    or (
        o.holiday_type_descb <> n.holiday_type_descb
        or o.wd_flg <> n.wd_flg
        or o.fit_range_cd <> n.fit_range_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_rg_holiday_para_ncbsf1_op(
            lp_id -- 法人编号
    ,holiday_type_cd -- 假日类型代码
    ,local_cty_rg_cd -- 所在国家和地区代码
    ,local_prov_cd -- 所在省代码
    ,holiday_dt -- 假日日期
    ,holiday_type_descb -- 假日类型描述
    ,wd_flg -- 工作日标志
    ,fit_range_cd -- 适用范围代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.holiday_type_cd -- 假日类型代码
    ,o.local_cty_rg_cd -- 所在国家和地区代码
    ,o.local_prov_cd -- 所在省代码
    ,o.holiday_dt -- 假日日期
    ,o.holiday_type_descb -- 假日类型描述
    ,o.wd_flg -- 工作日标志
    ,o.fit_range_cd -- 适用范围代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rg_holiday_para_ncbsf1_bk o
    left join ${iml_schema}.ref_rg_holiday_para_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.holiday_type_cd = n.holiday_type_cd
            and o.local_cty_rg_cd = n.local_cty_rg_cd
            and o.local_prov_cd = n.local_prov_cd
            and o.holiday_dt = n.holiday_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.holiday_type_cd = d.holiday_type_cd
            and o.local_cty_rg_cd = d.local_cty_rg_cd
            and o.local_prov_cd = d.local_prov_cd
            and o.holiday_dt = d.holiday_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_rg_holiday_para;
alter table ${iml_schema}.ref_rg_holiday_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_rg_holiday_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl;
alter table ${iml_schema}.ref_rg_holiday_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_rg_holiday_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_rg_holiday_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_rg_holiday_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_rg_holiday_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
