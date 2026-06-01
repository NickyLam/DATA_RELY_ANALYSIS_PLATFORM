/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_col_arch_land_use_info
CreateDate: 20221118
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.ast_col_arch_land_use_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.ast_col_arch_land_use_info(
etl_dt date --数据日期
,asset_id varchar2(60) --资产编号
,lp_id varchar2(60) --法人编号
,rel_esat_wat_id varchar2(900) --不动产权证编号
,land_char_cd varchar2(30) --土地所有权性质代码
,land_get_way_cd varchar2(30) --土地取得方式代码
,land_use_right_begin_dt date --土地使用权起始日期
,land_use_right_exp_dt date --土地使用权到期日期
,land_usage_cd varchar2(30) --土地用途代码
,land_use_right_area number(30,2) --土地使用权面积
,idle_land_type_cd varchar2(30) --闲置土地类型代码
,local_prov_cd varchar2(60) --所在省代码
,local_city_cd varchar2(60) --所在市代码
,local_rg_cd varchar2(60) --所在区代码
,street_name varchar2(100) --街道名称
,phys_addr varchar2(250) --物理地址
,parcel_id varchar2(100) --宗地编号
,buy_dt date --购入日期
,buy_amt number(30,2) --购入金额
,attachmen_flg varchar2(10) --附着物标志
,attachmen_type_cd varchar2(30) --附着物类型代码
,build_qtty number(10) --建筑物数量
,attachmen_owner_name varchar2(100) --附着物所有人名称
,attachmen_owner_type_cd varchar2(100) --附着物所有人类型代码
,attachmen_tot_area number(30,2) --附着物总面积
,other_comnt varchar2(4000) --其他说明
,curr_cd varchar2(30) --币种代码
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --删除标识

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_col_arch_land_use_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_col_arch_land_use_info is '押品建设用地使用权信息';
comment on column ${idl_schema}.ast_col_arch_land_use_info.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.asset_id is '资产编号';
comment on column ${idl_schema}.ast_col_arch_land_use_info.lp_id is '法人编号';
comment on column ${idl_schema}.ast_col_arch_land_use_info.rel_esat_wat_id is '不动产权证编号';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_char_cd is '土地所有权性质代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_get_way_cd is '土地取得方式代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_usage_cd is '土地用途代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.land_use_right_area is '土地使用权面积';
comment on column ${idl_schema}.ast_col_arch_land_use_info.idle_land_type_cd is '闲置土地类型代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.local_rg_cd is '所在区代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.street_name is '街道名称';
comment on column ${idl_schema}.ast_col_arch_land_use_info.phys_addr is '物理地址';
comment on column ${idl_schema}.ast_col_arch_land_use_info.parcel_id is '宗地编号';
comment on column ${idl_schema}.ast_col_arch_land_use_info.buy_dt is '购入日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.buy_amt is '购入金额';
comment on column ${idl_schema}.ast_col_arch_land_use_info.attachmen_flg is '附着物标志';
comment on column ${idl_schema}.ast_col_arch_land_use_info.attachmen_type_cd is '附着物类型代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.build_qtty is '建筑物数量';
comment on column ${idl_schema}.ast_col_arch_land_use_info.attachmen_owner_name is '附着物所有人名称';
comment on column ${idl_schema}.ast_col_arch_land_use_info.attachmen_owner_type_cd is '附着物所有人类型代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.attachmen_tot_area is '附着物总面积';
comment on column ${idl_schema}.ast_col_arch_land_use_info.other_comnt is '其他说明';
comment on column ${idl_schema}.ast_col_arch_land_use_info.curr_cd is '币种代码';
comment on column ${idl_schema}.ast_col_arch_land_use_info.create_dt is '创建日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.update_dt is '更新日期';
comment on column ${idl_schema}.ast_col_arch_land_use_info.id_mark is '删除标识';

