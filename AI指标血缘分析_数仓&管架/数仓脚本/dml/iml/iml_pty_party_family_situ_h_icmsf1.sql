/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_family_situ_h_icmsf1
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
alter table ${iml_schema}.pty_party_family_situ_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_family_situ_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_family_situ_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_family_situ_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_family_situ_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_party_family_situ_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_family_situ_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_party_family_situ_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_family_situ_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ind_info-
insert into ${iml_schema}.pty_party_family_situ_h_icmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUSTOMERID -- 当事人编号
    ,'9999' -- 法人编号
    ,0.0 -- 本地居住年限
    ,' ' -- 当地房产标志
    ,' ' -- 当地社保标志
    ,NVL(TRIM(P1.HOUSEVALUE),'00') -- 房屋价值代码
    ,P1.SUPPORTPOPULATIONS -- 供养人口类型代码
    ,NVL(TRIM(P1.NATIVEDETAIL),'00') -- 户籍性质代码
    ,NVL(TRIM(P1.FAMILYSTATUS),'9') -- 居住状况代码
    ,P1.CHILDREN -- 子女人数代码
    ,P1.ISHAVECAR -- 自由汽车状况代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ind_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ind_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_family_situ_h_icmsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_party_family_situ_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_family_situ_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.loc_resd_years, o.loc_resd_years) as loc_resd_years -- 本地居住年限
    ,nvl(n.local_estate_flg, o.local_estate_flg) as local_estate_flg -- 当地房产标志
    ,nvl(n.local_soci_secu_flg, o.local_soci_secu_flg) as local_soci_secu_flg -- 当地社保标志
    ,nvl(n.house_val_cd, o.house_val_cd) as house_val_cd -- 房屋价值代码
    ,nvl(n.prov_pulation_type_cd, o.prov_pulation_type_cd) as prov_pulation_type_cd -- 供养人口类型代码
    ,nvl(n.rpr_char_cd, o.rpr_char_cd) as rpr_char_cd -- 户籍性质代码
    ,nvl(n.resdnt_status_cd, o.resdnt_status_cd) as resdnt_status_cd -- 居住状况代码
    ,nvl(n.child_number_cd, o.child_number_cd) as child_number_cd -- 子女人数代码
    ,nvl(n.free_car_situ_cd, o.free_car_situ_cd) as free_car_situ_cd -- 自由汽车状况代码
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_family_situ_h_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_party_family_situ_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.loc_resd_years <> n.loc_resd_years
        or o.local_estate_flg <> n.local_estate_flg
        or o.local_soci_secu_flg <> n.local_soci_secu_flg
        or o.house_val_cd <> n.house_val_cd
        or o.prov_pulation_type_cd <> n.prov_pulation_type_cd
        or o.rpr_char_cd <> n.rpr_char_cd
        or o.resdnt_status_cd <> n.resdnt_status_cd
        or o.child_number_cd <> n.child_number_cd
        or o.free_car_situ_cd <> n.free_car_situ_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_family_situ_h_icmsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_family_situ_h_icmsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,loc_resd_years -- 本地居住年限
    ,local_estate_flg -- 当地房产标志
    ,local_soci_secu_flg -- 当地社保标志
    ,house_val_cd -- 房屋价值代码
    ,prov_pulation_type_cd -- 供养人口类型代码
    ,rpr_char_cd -- 户籍性质代码
    ,resdnt_status_cd -- 居住状况代码
    ,child_number_cd -- 子女人数代码
    ,free_car_situ_cd -- 自由汽车状况代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.loc_resd_years -- 本地居住年限
    ,o.local_estate_flg -- 当地房产标志
    ,o.local_soci_secu_flg -- 当地社保标志
    ,o.house_val_cd -- 房屋价值代码
    ,o.prov_pulation_type_cd -- 供养人口类型代码
    ,o.rpr_char_cd -- 户籍性质代码
    ,o.resdnt_status_cd -- 居住状况代码
    ,o.child_number_cd -- 子女人数代码
    ,o.free_car_situ_cd -- 自由汽车状况代码
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
from ${iml_schema}.pty_party_family_situ_h_icmsf1_bk o
    left join ${iml_schema}.pty_party_family_situ_h_icmsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_family_situ_h_icmsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_family_situ_h;
--alter table ${iml_schema}.pty_party_family_situ_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_family_situ_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_family_situ_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_family_situ_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_family_situ_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_party_family_situ_h_icmsf1_cl;
alter table ${iml_schema}.pty_party_family_situ_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_party_family_situ_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_family_situ_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_tm purge;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_op purge;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_family_situ_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_family_situ_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
