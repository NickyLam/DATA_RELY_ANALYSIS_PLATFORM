/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_arch_land_use_info_mimsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_arch_land_use_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_arch_land_use_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_arch_land_use_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 房产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_usage_cd -- 土地用途代码
    ,land_use_right_area -- 土地使用权面积
    ,idle_land_type_cd -- 闲置土地类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,phys_addr -- 物理地址
    ,parcel_id -- 宗地编号
    ,buy_dt -- 购入日期
    ,buy_amt -- 购入金额
    ,attachmen_flg -- 附着物标志
    ,attachmen_type_cd -- 附着物类型代码
    ,build_qtty -- 建筑物数量
    ,attachmen_owner_name -- 附着物所有人名称
    ,attachmen_owner_type_cd -- 附着物所有人类型代码
    ,attachmen_tot_area -- 附着物总面积
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_arch_land_use_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_arch_land_use_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_constructland-
insert into ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 房产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_usage_cd -- 土地用途代码
    ,land_use_right_area -- 土地使用权面积
    ,idle_land_type_cd -- 闲置土地类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,phys_addr -- 物理地址
    ,parcel_id -- 宗地编号
    ,buy_dt -- 购入日期
    ,buy_amt -- 购入金额
    ,attachmen_flg -- 附着物标志
    ,attachmen_type_cd -- 附着物类型代码
    ,build_qtty -- 建筑物数量
    ,attachmen_owner_name -- 附着物所有人名称
    ,attachmen_owner_type_cd -- 附着物所有人类型代码
    ,attachmen_tot_area -- 附着物总面积
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.LANDNO -- 房产证号
    ,NVL(TRIM(P1.LANDUSENATURE),'00') -- 土地所有权性质代码
    ,NVL(TRIM(P1.LANDGAINWAY),'00') -- 土地取得方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.LANDSTARTDATE) -- 土地使用权起始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.LANDENDDATE) -- 土地使用权到期日期
    ,NVL(TRIM(P1.LANDUSERING),'00') -- 土地用途代码
    ,P1.LANDUSEAREA -- 土地使用权面积
    ,NVL(TRIM(P1.LANDTYPE),'99') -- 闲置土地类型代码
    ,NVL(TRIM(P1.PROVINCE),'000000') -- 所在省代码
    ,NVL(TRIM(P1.CITY),'000000') -- 所在市代码
    ,NVL(TRIM(P1.COUNTIES),'000000') -- 所在区代码
    ,P1.STREET -- 街道名称
    ,P1.ADDRESS -- 物理地址
    ,P1.LANDDEC -- 宗地编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRADEDATE) -- 购入日期
    ,P1.TRADEPRICE -- 购入金额
    ,NVL(TRIM(P1.ISATTACHMENTS),'-') -- 附着物标志
    ,NVL(TRIM(P1.ATTACHMENTTYPE),'00') -- 附着物类型代码
    ,P1.BUILDTERM -- 建筑物数量
    ,P1.ATTACHMENTOWNER -- 附着物所有人名称
    ,NVL(TRIM(P1.ATTACHMENTREGION),'00') -- 附着物所有人类型代码
    ,P1.OVERALLFLOORAGE -- 附着物总面积
    ,P1.REMARK -- 其他说明
    ,NVL(TRIM(P1.TDCURRENCY),'CNY') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_constructland' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_constructland p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ast_col_arch_land_use_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 房产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_usage_cd -- 土地用途代码
    ,land_use_right_area -- 土地使用权面积
    ,idle_land_type_cd -- 闲置土地类型代码
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,phys_addr -- 物理地址
    ,parcel_id -- 宗地编号
    ,buy_dt -- 购入日期
    ,buy_amt -- 购入金额
    ,attachmen_flg -- 附着物标志
    ,attachmen_type_cd -- 附着物类型代码
    ,build_qtty -- 建筑物数量
    ,attachmen_owner_name -- 附着物所有人名称
    ,attachmen_owner_type_cd -- 附着物所有人类型代码
    ,attachmen_tot_area -- 附着物总面积
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rel_esat_wat_id, o.rel_esat_wat_id) as rel_esat_wat_id -- 房产证号
    ,nvl(n.land_char_cd, o.land_char_cd) as land_char_cd -- 土地所有权性质代码
    ,nvl(n.land_get_way_cd, o.land_get_way_cd) as land_get_way_cd -- 土地取得方式代码
    ,nvl(n.land_use_right_begin_dt, o.land_use_right_begin_dt) as land_use_right_begin_dt -- 土地使用权起始日期
    ,nvl(n.land_use_right_exp_dt, o.land_use_right_exp_dt) as land_use_right_exp_dt -- 土地使用权到期日期
    ,nvl(n.land_usage_cd, o.land_usage_cd) as land_usage_cd -- 土地用途代码
    ,nvl(n.land_use_right_area, o.land_use_right_area) as land_use_right_area -- 土地使用权面积
    ,nvl(n.idle_land_type_cd, o.idle_land_type_cd) as idle_land_type_cd -- 闲置土地类型代码
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.local_rg_cd, o.local_rg_cd) as local_rg_cd -- 所在区代码
    ,nvl(n.street_name, o.street_name) as street_name -- 街道名称
    ,nvl(n.phys_addr, o.phys_addr) as phys_addr -- 物理地址
    ,nvl(n.parcel_id, o.parcel_id) as parcel_id -- 宗地编号
    ,nvl(n.buy_dt, o.buy_dt) as buy_dt -- 购入日期
    ,nvl(n.buy_amt, o.buy_amt) as buy_amt -- 购入金额
    ,nvl(n.attachmen_flg, o.attachmen_flg) as attachmen_flg -- 附着物标志
    ,nvl(n.attachmen_type_cd, o.attachmen_type_cd) as attachmen_type_cd -- 附着物类型代码
    ,nvl(n.build_qtty, o.build_qtty) as build_qtty -- 建筑物数量
    ,nvl(n.attachmen_owner_name, o.attachmen_owner_name) as attachmen_owner_name -- 附着物所有人名称
    ,nvl(n.attachmen_owner_type_cd, o.attachmen_owner_type_cd) as attachmen_owner_type_cd -- 附着物所有人类型代码
    ,nvl(n.attachmen_tot_area, o.attachmen_tot_area) as attachmen_tot_area -- 附着物总面积
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.rel_esat_wat_id <> n.rel_esat_wat_id
                or o.land_char_cd <> n.land_char_cd
                or o.land_get_way_cd <> n.land_get_way_cd
                or o.land_use_right_begin_dt <> n.land_use_right_begin_dt
                or o.land_use_right_exp_dt <> n.land_use_right_exp_dt
                or o.land_usage_cd <> n.land_usage_cd
                or o.land_use_right_area <> n.land_use_right_area
                or o.idle_land_type_cd <> n.idle_land_type_cd
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.local_rg_cd <> n.local_rg_cd
                or o.street_name <> n.street_name
                or o.phys_addr <> n.phys_addr
                or o.parcel_id <> n.parcel_id
                or o.buy_dt <> n.buy_dt
                or o.buy_amt <> n.buy_amt
                or o.attachmen_flg <> n.attachmen_flg
                or o.attachmen_type_cd <> n.attachmen_type_cd
                or o.build_qtty <> n.build_qtty
                or o.attachmen_owner_name <> n.attachmen_owner_name
                or o.attachmen_owner_type_cd <> n.attachmen_owner_type_cd
                or o.attachmen_tot_area <> n.attachmen_tot_area
                or o.other_comnt <> n.other_comnt
                or o.curr_cd <> n.curr_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_arch_land_use_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_arch_land_use_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_arch_land_use_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_arch_land_use_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_arch_land_use_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_arch_land_use_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_arch_land_use_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);