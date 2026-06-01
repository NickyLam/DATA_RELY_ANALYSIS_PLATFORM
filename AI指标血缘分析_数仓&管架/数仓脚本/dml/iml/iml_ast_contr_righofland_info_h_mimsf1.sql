/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_contr_righofland_info_h_mimsf1
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
alter table ${iml_schema}.ast_contr_righofland_info_h add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mimsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_contr_righofland_info_h partition for ('mimsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm nologging
compress ${option_switch} for query high
as select
    col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_contr_righofland_info_h partition for ('mimsf1')
where 0=1
;

create table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_contr_righofland_info_h partition for ('mimsf1') where 0=1;

create table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_contr_righofland_info_h partition for ('mimsf1') where 0=1;

-- 3.1 get new data into table
-- mims_si_landright-1
insert into ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm(
    col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,curr_cd -- 其他说明
    ,other_comnt -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 押品编号
    ,P1.LANDNO -- 不动产证号
    ,P1.WARRANTSNO -- 土地承包经营权证编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.LANDSTARTDATE) -- 土地承包经营权取得日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.LANDENDDATE) -- 土地承包经营权到期日期
    ,P1.LANDAREA -- 土地承包经营权面积
    ,nvl(trim(p1.PROVINCE),'000000') -- 注册省份代码
    ,nvl(trim(p1.CITY),'000000') -- 注册市区代码
    ,P1.ADDRESS -- 土地承包经营权地址
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRADEDATE) -- 购买日期
    ,P1.TRADEPRICE -- 购买价格
    ,nvl(trim(p1.TDCURRENCY),'-') -- 其他说明
    ,P1.REMARK -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_landright' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_landright p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm 
  	                                group by 
  	                                        col_id
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
        into ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl(
            col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op(
            col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.rel_esat_cert_num, o.rel_esat_cert_num) as rel_esat_cert_num -- 不动产证号
    ,nvl(n.land_contr_mgmt_righ_wat_num, o.land_contr_mgmt_righ_wat_num) as land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,nvl(n.land_contr_mgmt_righ_get_dt, o.land_contr_mgmt_righ_get_dt) as land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,nvl(n.land_contr_mgmt_righ_exp_dt, o.land_contr_mgmt_righ_exp_dt) as land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,nvl(n.land_contr_mgmt_righ_area, o.land_contr_mgmt_righ_area) as land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,nvl(n.rgst_prov_cd, o.rgst_prov_cd) as rgst_prov_cd -- 注册省份代码
    ,nvl(n.rgst_city_rg_cd, o.rgst_city_rg_cd) as rgst_city_rg_cd -- 注册市区代码
    ,nvl(n.land_contr_mgmt_righ_addr, o.land_contr_mgmt_righ_addr) as land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,nvl(n.buy_dt, o.buy_dt) as buy_dt -- 购买日期
    ,nvl(n.buy_price, o.buy_price) as buy_price -- 购买价格
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,case when
            n.col_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.col_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.col_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm n
    full join (select * from ${iml_schema}.ast_contr_righofland_info_h_mimsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.col_id = n.col_id
where (
        o.col_id is null
    )
    or (
        n.col_id is null
    )
    or (
        o.rel_esat_cert_num <> n.rel_esat_cert_num
        or o.land_contr_mgmt_righ_wat_num <> n.land_contr_mgmt_righ_wat_num
        or o.land_contr_mgmt_righ_get_dt <> n.land_contr_mgmt_righ_get_dt
        or o.land_contr_mgmt_righ_exp_dt <> n.land_contr_mgmt_righ_exp_dt
        or o.land_contr_mgmt_righ_area <> n.land_contr_mgmt_righ_area
        or o.rgst_prov_cd <> n.rgst_prov_cd
        or o.rgst_city_rg_cd <> n.rgst_city_rg_cd
        or o.land_contr_mgmt_righ_addr <> n.land_contr_mgmt_righ_addr
        or o.buy_dt <> n.buy_dt
        or o.buy_price <> n.buy_price
        or o.other_comnt <> n.other_comnt
        or o.curr_cd <> n.curr_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl(
            col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op(
            col_id -- 押品编号
    ,rel_esat_cert_num -- 不动产证号
    ,land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,rgst_prov_cd -- 注册省份代码
    ,rgst_city_rg_cd -- 注册市区代码
    ,land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,buy_dt -- 购买日期
    ,buy_price -- 购买价格
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.col_id -- 押品编号
    ,o.rel_esat_cert_num -- 不动产证号
    ,o.land_contr_mgmt_righ_wat_num -- 土地承包经营权证编号
    ,o.land_contr_mgmt_righ_get_dt -- 土地承包经营权取得日期
    ,o.land_contr_mgmt_righ_exp_dt -- 土地承包经营权到期日期
    ,o.land_contr_mgmt_righ_area -- 土地承包经营权面积
    ,o.rgst_prov_cd -- 注册省份代码
    ,o.rgst_city_rg_cd -- 注册市区代码
    ,o.land_contr_mgmt_righ_addr -- 土地承包经营权地址
    ,o.buy_dt -- 购买日期
    ,o.buy_price -- 购买价格
    ,o.other_comnt -- 其他说明
    ,o.curr_cd -- 币种代码
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
from ${iml_schema}.ast_contr_righofland_info_h_mimsf1_bk o
    left join ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op n
        on
            o.col_id = n.col_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl d
        on
            o.col_id = d.col_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_contr_righofland_info_h;
--alter table ${iml_schema}.ast_contr_righofland_info_h truncate partition for ('mimsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_contr_righofland_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mimsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_contr_righofland_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ast_contr_righofland_info_h modify partition p_mimsf1 
add subpartition p_mimsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_contr_righofland_info_h exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl;
alter table ${iml_schema}.ast_contr_righofland_info_h exchange subpartition p_mimsf1_20991231 with table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_contr_righofland_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_tm purge;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_op purge;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_contr_righofland_info_h_mimsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_contr_righofland_info_h', partname => 'p_mimsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
