/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_gare_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_gare_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_gare_info(
etl_dt date --ETL处理日期
,single_pro_cert_flg varchar2(60) --独立产权证标志
,gare_type_cd varchar2(30) --车库类型代码
,bs_cont_id varchar2(60) --买卖合同编号
,buy_dt date --购入日期
,buy_amt number(30,2) --购入金额
,arch_area number(30,2) --建筑面积
,usbl_area number(30,2) --实用面积
,build_year varchar2(30) --建成年份
,local_prov_cd varchar2(60) --所在省代码
,local_city_cd varchar2(60) --所在市代码
,local_rg_cd varchar2(60) --所在区代码
,street_name varchar2(100) --街道名称
,street_id varchar2(60) --街道编号
,dplat_id varchar2(100) --门牌编号
,rel_esat_wat_rgst_addr varchar2(250) --不动产权证登记地址
,estat_name varchar2(100) --楼盘名称
,prop_tenor number(30,2) --产权期限
,other_prop_cert_flg varchar2(10) --已有他项权证标志
,other_comnt varchar2(4000) --其他说明
,two_in_one_flg varchar2(10) --两证合一标志
,rel_esat_wat_id varchar2(900) --房产证号
,land_char_cd varchar2(30) --土地所有权性质代码
,land_use_area number(30,2) --土地使用面积
,land_get_way_cd varchar2(30) --土地取得方式代码
,land_use_right_begin_dt date --土地使用权起始日期
,land_use_right_exp_dt date --土地使用权到期日期
,land_use_right_years number(30,2) --土地使用权年限
,land_usage_cd varchar2(30) --土地用途代码
,rent_flg varchar2(10) --出租标志
,tentry_name varchar2(100) --承租人名称
,rent_begin_dt date --出租起始日期
,rent_exp_dt date --出租到期日期
,rent_situ_comnt varchar2(250) --出租情况说明
,curr_cd varchar2(30) --币种代码
,land_use_right_id varchar2(100) --土地证号
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,asset_id varchar2(60) --资产编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_col_gare_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_gare_info is '押品车库信息';
comment on column ${idl_schema}.oass_ast_col_gare_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.single_pro_cert_flg is '独立产权证标志';
comment on column ${idl_schema}.oass_ast_col_gare_info.gare_type_cd is '车库类型代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.bs_cont_id is '买卖合同编号';
comment on column ${idl_schema}.oass_ast_col_gare_info.buy_dt is '购入日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.buy_amt is '购入金额';
comment on column ${idl_schema}.oass_ast_col_gare_info.arch_area is '建筑面积';
comment on column ${idl_schema}.oass_ast_col_gare_info.usbl_area is '实用面积';
comment on column ${idl_schema}.oass_ast_col_gare_info.build_year is '建成年份';
comment on column ${idl_schema}.oass_ast_col_gare_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.local_rg_cd is '所在区代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.street_name is '街道名称';
comment on column ${idl_schema}.oass_ast_col_gare_info.street_id is '街道编号';
comment on column ${idl_schema}.oass_ast_col_gare_info.dplat_id is '门牌编号';
comment on column ${idl_schema}.oass_ast_col_gare_info.rel_esat_wat_rgst_addr is '不动产权证登记地址';
comment on column ${idl_schema}.oass_ast_col_gare_info.estat_name is '楼盘名称';
comment on column ${idl_schema}.oass_ast_col_gare_info.prop_tenor is '产权期限';
comment on column ${idl_schema}.oass_ast_col_gare_info.other_prop_cert_flg is '已有他项权证标志';
comment on column ${idl_schema}.oass_ast_col_gare_info.other_comnt is '其他说明';
comment on column ${idl_schema}.oass_ast_col_gare_info.two_in_one_flg is '两证合一标志';
comment on column ${idl_schema}.oass_ast_col_gare_info.rel_esat_wat_id is '房产证号';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_char_cd is '土地所有权性质代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_use_area is '土地使用面积';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_get_way_cd is '土地取得方式代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_use_right_begin_dt is '土地使用权起始日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_use_right_years is '土地使用权年限';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_usage_cd is '土地用途代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.rent_flg is '出租标志';
comment on column ${idl_schema}.oass_ast_col_gare_info.tentry_name is '承租人名称';
comment on column ${idl_schema}.oass_ast_col_gare_info.rent_begin_dt is '出租起始日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.rent_exp_dt is '出租到期日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.rent_situ_comnt is '出租情况说明';
comment on column ${idl_schema}.oass_ast_col_gare_info.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ast_col_gare_info.land_use_right_id is '土地证号';
comment on column ${idl_schema}.oass_ast_col_gare_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_gare_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_gare_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_gare_info.lp_id is '法人编号';

