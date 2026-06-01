/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_cnstring_proj_info_mimsf1
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
drop table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_cnstring_proj_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_cnstring_proj_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_cnstring_proj_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 不动产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_area -- 土地面积
    ,land_tranf_fee_amt -- 土地出让金金额
    ,land_tranf_fee_dlvy_flg -- 土地出让金交付标志
    ,attach_tranf_fee_amt -- 应补出让金金额
    ,land_usage_cd -- 土地用途代码
    ,proj_proj_name -- 工程项目名称
    ,cnstr_land_use_permit_id -- 建设用地规划许可证号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证号
    ,proj_cnstr_lics_id -- 建设工程施工许可证号
    ,start_work_dt -- 开工日期
    ,expect_cmplt_dt -- 预计竣工日期
    ,proj_expect_tot_cost -- 工程预计总造价
    ,arch_area -- 建筑面积
    ,tot_floor_cnt -- 总楼层数
    ,rent_flg -- 出租标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_id -- 门牌编号
    ,phys_addr -- 物理地址
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_cnstring_proj_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_cnstring_proj_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_construction-
insert into ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 不动产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_area -- 土地面积
    ,land_tranf_fee_amt -- 土地出让金金额
    ,land_tranf_fee_dlvy_flg -- 土地出让金交付标志
    ,attach_tranf_fee_amt -- 应补出让金金额
    ,land_usage_cd -- 土地用途代码
    ,proj_proj_name -- 工程项目名称
    ,cnstr_land_use_permit_id -- 建设用地规划许可证号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证号
    ,proj_cnstr_lics_id -- 建设工程施工许可证号
    ,start_work_dt -- 开工日期
    ,expect_cmplt_dt -- 预计竣工日期
    ,proj_expect_tot_cost -- 工程预计总造价
    ,arch_area -- 建筑面积
    ,tot_floor_cnt -- 总楼层数
    ,rent_flg -- 出租标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_id -- 门牌编号
    ,phys_addr -- 物理地址
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.LANDUSENO -- 不动产证号
    ,NVL(TRIM(P1.LANDUSENATURE),'00') -- 土地所有权性质代码
    ,NVL(TRIM(P1.LANDGAINWAY),'00') -- 土地取得方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.LANDSTARTDATE) -- 土地使用权起始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.LANDENDDATE) -- 土地使用权到期日期
    ,P1.LANDUSEYEAR -- 土地使用权年限
    ,P1.LANDAREA -- 土地面积
    ,P1.LANDLEASPRICE -- 土地出让金金额
    ,NVL(TRIM(P1.LANDDELIVERY),'00') -- 土地出让金交付标志
    ,P1.TRANSFERMONEY -- 应补出让金金额
    ,NVL(TRIM(P1.LANDUSERING),'00') -- 土地用途代码
    ,P1.PROJECTNAME -- 工程项目名称
    ,P1.LANDLICENCENO -- 建设用地规划许可证号
    ,P1.PROJECTLICENCENO -- 建设工程规划许可证号
    ,P1.LICENCENO -- 建设工程施工许可证号
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTWORKDATE) -- 开工日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.PRESTARTDATE) -- 预计竣工日期
    ,P1.PRETOTALPRICE -- 工程预计总造价
    ,P1.BUILDAREA -- 建筑面积
    ,P1.BUILDNUMBER -- 总楼层数
    ,NVL(TRIM(P1.ISRENT),'-') -- 出租标志
    ,NVL(TRIM(P1.PROVINCE),'000000') -- 所在省代码
    ,NVL(TRIM(P1.CITY),'000000') -- 所在市代码
    ,NVL(TRIM(P1.COUNTIES),'000000') -- 所在区代码
    ,P1.STREET -- 街道名称
    ,P1.ROOMNO -- 门牌编号
    ,P1.ADDRESS -- 物理地址
    ,P1.REMARK -- 其他说明
    ,NVL(TRIM(P1.TDCURRENCY),'CNY') -- 币种代码
    ,p1.YEARLYRENTAL -- 租赁年收入
    ,nvl(trim(P1.iscompleted),'-') -- 房屋竣工标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_construction' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_construction p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm 
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
insert /*+ append */ into ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,rel_esat_wat_id -- 不动产证号
    ,land_char_cd -- 土地所有权性质代码
    ,land_get_way_cd -- 土地取得方式代码
    ,land_use_right_begin_dt -- 土地使用权起始日期
    ,land_use_right_exp_dt -- 土地使用权到期日期
    ,land_use_right_years -- 土地使用权年限
    ,land_area -- 土地面积
    ,land_tranf_fee_amt -- 土地出让金金额
    ,land_tranf_fee_dlvy_flg -- 土地出让金交付标志
    ,attach_tranf_fee_amt -- 应补出让金金额
    ,land_usage_cd -- 土地用途代码
    ,proj_proj_name -- 工程项目名称
    ,cnstr_land_use_permit_id -- 建设用地规划许可证号
    ,cnstr_proj_plan_permit_id -- 建设工程规划许可证号
    ,proj_cnstr_lics_id -- 建设工程施工许可证号
    ,start_work_dt -- 开工日期
    ,expect_cmplt_dt -- 预计竣工日期
    ,proj_expect_tot_cost -- 工程预计总造价
    ,arch_area -- 建筑面积
    ,tot_floor_cnt -- 总楼层数
    ,rent_flg -- 出租标志
    ,local_prov_cd -- 所在省代码
    ,local_city_cd -- 所在市代码
    ,local_rg_cd -- 所在区代码
    ,street_name -- 街道名称
    ,dplat_id -- 门牌编号
    ,phys_addr -- 物理地址
    ,other_comnt -- 其他说明
    ,curr_cd -- 币种代码
    ,rent_anl_inco -- 租赁年收入
    ,house_cmplt_flg -- 房屋竣工标志
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
    ,nvl(n.rel_esat_wat_id, o.rel_esat_wat_id) as rel_esat_wat_id -- 不动产证号
    ,nvl(n.land_char_cd, o.land_char_cd) as land_char_cd -- 土地所有权性质代码
    ,nvl(n.land_get_way_cd, o.land_get_way_cd) as land_get_way_cd -- 土地取得方式代码
    ,nvl(n.land_use_right_begin_dt, o.land_use_right_begin_dt) as land_use_right_begin_dt -- 土地使用权起始日期
    ,nvl(n.land_use_right_exp_dt, o.land_use_right_exp_dt) as land_use_right_exp_dt -- 土地使用权到期日期
    ,nvl(n.land_use_right_years, o.land_use_right_years) as land_use_right_years -- 土地使用权年限
    ,nvl(n.land_area, o.land_area) as land_area -- 土地面积
    ,nvl(n.land_tranf_fee_amt, o.land_tranf_fee_amt) as land_tranf_fee_amt -- 土地出让金金额
    ,nvl(n.land_tranf_fee_dlvy_flg, o.land_tranf_fee_dlvy_flg) as land_tranf_fee_dlvy_flg -- 土地出让金交付标志
    ,nvl(n.attach_tranf_fee_amt, o.attach_tranf_fee_amt) as attach_tranf_fee_amt -- 应补出让金金额
    ,nvl(n.land_usage_cd, o.land_usage_cd) as land_usage_cd -- 土地用途代码
    ,nvl(n.proj_proj_name, o.proj_proj_name) as proj_proj_name -- 工程项目名称
    ,nvl(n.cnstr_land_use_permit_id, o.cnstr_land_use_permit_id) as cnstr_land_use_permit_id -- 建设用地规划许可证号
    ,nvl(n.cnstr_proj_plan_permit_id, o.cnstr_proj_plan_permit_id) as cnstr_proj_plan_permit_id -- 建设工程规划许可证号
    ,nvl(n.proj_cnstr_lics_id, o.proj_cnstr_lics_id) as proj_cnstr_lics_id -- 建设工程施工许可证号
    ,nvl(n.start_work_dt, o.start_work_dt) as start_work_dt -- 开工日期
    ,nvl(n.expect_cmplt_dt, o.expect_cmplt_dt) as expect_cmplt_dt -- 预计竣工日期
    ,nvl(n.proj_expect_tot_cost, o.proj_expect_tot_cost) as proj_expect_tot_cost -- 工程预计总造价
    ,nvl(n.arch_area, o.arch_area) as arch_area -- 建筑面积
    ,nvl(n.tot_floor_cnt, o.tot_floor_cnt) as tot_floor_cnt -- 总楼层数
    ,nvl(n.rent_flg, o.rent_flg) as rent_flg -- 出租标志
    ,nvl(n.local_prov_cd, o.local_prov_cd) as local_prov_cd -- 所在省代码
    ,nvl(n.local_city_cd, o.local_city_cd) as local_city_cd -- 所在市代码
    ,nvl(n.local_rg_cd, o.local_rg_cd) as local_rg_cd -- 所在区代码
    ,nvl(n.street_name, o.street_name) as street_name -- 街道名称
    ,nvl(n.dplat_id, o.dplat_id) as dplat_id -- 门牌编号
    ,nvl(n.phys_addr, o.phys_addr) as phys_addr -- 物理地址
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.rent_anl_inco, o.rent_anl_inco) as rent_anl_inco -- 租赁年收入
    ,nvl(n.house_cmplt_flg, o.house_cmplt_flg) as house_cmplt_flg -- 房屋竣工标志
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
                or o.land_use_right_years <> n.land_use_right_years
                or o.land_area <> n.land_area
                or o.land_tranf_fee_amt <> n.land_tranf_fee_amt
                or o.land_tranf_fee_dlvy_flg <> n.land_tranf_fee_dlvy_flg
                or o.attach_tranf_fee_amt <> n.attach_tranf_fee_amt
                or o.land_usage_cd <> n.land_usage_cd
                or o.proj_proj_name <> n.proj_proj_name
                or o.cnstr_land_use_permit_id <> n.cnstr_land_use_permit_id
                or o.cnstr_proj_plan_permit_id <> n.cnstr_proj_plan_permit_id
                or o.proj_cnstr_lics_id <> n.proj_cnstr_lics_id
                or o.start_work_dt <> n.start_work_dt
                or o.expect_cmplt_dt <> n.expect_cmplt_dt
                or o.proj_expect_tot_cost <> n.proj_expect_tot_cost
                or o.arch_area <> n.arch_area
                or o.tot_floor_cnt <> n.tot_floor_cnt
                or o.rent_flg <> n.rent_flg
                or o.local_prov_cd <> n.local_prov_cd
                or o.local_city_cd <> n.local_city_cd
                or o.local_rg_cd <> n.local_rg_cd
                or o.street_name <> n.street_name
                or o.dplat_id <> n.dplat_id
                or o.phys_addr <> n.phys_addr
                or o.other_comnt <> n.other_comnt
                or o.curr_cd <> n.curr_cd
                or o.rent_anl_inco <> n.rent_anl_inco
                or o.house_cmplt_flg <> n.house_cmplt_flg
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
from ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_cnstring_proj_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_cnstring_proj_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_cnstring_proj_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_cnstring_proj_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_cnstring_proj_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_cnstring_proj_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);