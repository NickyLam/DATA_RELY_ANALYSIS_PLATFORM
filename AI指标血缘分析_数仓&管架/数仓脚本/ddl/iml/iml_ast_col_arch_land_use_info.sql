/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_arch_land_use_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_arch_land_use_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_arch_land_use_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_arch_land_use_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,rel_esat_wat_id varchar2(1350) -- 房产证号
    ,land_char_cd varchar2(30) -- 土地所有权性质代码
    ,land_get_way_cd varchar2(30) -- 土地取得方式代码
    ,land_use_right_begin_dt date -- 土地使用权起始日期
    ,land_use_right_exp_dt date -- 土地使用权到期日期
    ,land_usage_cd varchar2(30) -- 土地用途代码
    ,land_use_right_area number(30,2) -- 土地使用权面积
    ,idle_land_type_cd varchar2(30) -- 闲置土地类型代码
    ,local_prov_cd varchar2(60) -- 所在省代码
    ,local_city_cd varchar2(60) -- 所在市代码
    ,local_rg_cd varchar2(60) -- 所在区代码
    ,street_name varchar2(150) -- 街道名称
    ,phys_addr varchar2(375) -- 物理地址
    ,parcel_id varchar2(100) -- 宗地编号
    ,buy_dt date -- 购入日期
    ,buy_amt number(30,2) -- 购入金额
    ,attachmen_flg varchar2(10) -- 附着物标志
    ,attachmen_type_cd varchar2(30) -- 附着物类型代码
    ,build_qtty number(10) -- 建筑物数量
    ,attachmen_owner_name varchar2(150) -- 附着物所有人名称
    ,attachmen_owner_type_cd varchar2(100) -- 附着物所有人类型代码
    ,attachmen_tot_area number(30,2) -- 附着物总面积
    ,other_comnt varchar2(4000) -- 其他说明
    ,curr_cd varchar2(30) -- 币种代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_arch_land_use_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_arch_land_use_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_arch_land_use_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_arch_land_use_info is '押品建设用地使用权信息';
comment on column ${iml_schema}.ast_col_arch_land_use_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_arch_land_use_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_arch_land_use_info.rel_esat_wat_id is '房产证号';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_char_cd is '土地所有权性质代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_get_way_cd is '土地取得方式代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_usage_cd is '土地用途代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.land_use_right_area is '土地使用权面积';
comment on column ${iml_schema}.ast_col_arch_land_use_info.idle_land_type_cd is '闲置土地类型代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.local_city_cd is '所在市代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.local_rg_cd is '所在区代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.street_name is '街道名称';
comment on column ${iml_schema}.ast_col_arch_land_use_info.phys_addr is '物理地址';
comment on column ${iml_schema}.ast_col_arch_land_use_info.parcel_id is '宗地编号';
comment on column ${iml_schema}.ast_col_arch_land_use_info.buy_dt is '购入日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.buy_amt is '购入金额';
comment on column ${iml_schema}.ast_col_arch_land_use_info.attachmen_flg is '附着物标志';
comment on column ${iml_schema}.ast_col_arch_land_use_info.attachmen_type_cd is '附着物类型代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.build_qtty is '建筑物数量';
comment on column ${iml_schema}.ast_col_arch_land_use_info.attachmen_owner_name is '附着物所有人名称';
comment on column ${iml_schema}.ast_col_arch_land_use_info.attachmen_owner_type_cd is '附着物所有人类型代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.attachmen_tot_area is '附着物总面积';
comment on column ${iml_schema}.ast_col_arch_land_use_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_arch_land_use_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_arch_land_use_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_arch_land_use_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_arch_land_use_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_arch_land_use_info.etl_timestamp is 'ETL处理时间戳';
