/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_motor_vehic_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_motor_vehic_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_motor_vehic_info(
etl_dt date --ETL处理日期
,exchg_inpwn_rgst_id varchar2(100) --交易所质押登记编号
,drv_lics_id varchar2(100) --行驶证编号
,chassis_no varchar2(100) --车架号
,engine_id varchar2(100) --发动机编号
,lics_plat_num varchar2(100) --车牌照号码
,house_used_flg varchar2(30) --一手二手标志
,local_prov_cd varchar2(60) --所在省代码
,local_city_cd varchar2(60) --所在市代码
,brand_prod_manuf_name varchar2(100) --品牌生产厂商名称
,model_spec varchar2(60) --型号规格
,displment number(30,2) --排量
,chg_speed_type_cd varchar2(30) --变速类型代码
,leave_factory_dt date --出厂日期
,design_use_exp_dt date --设计使用到期日期
,steer_mile_cnt number(30,2) --行驶里程数
,oper_vehic_flg varchar2(10) --运营车辆标志
,oper_car_type_cd varchar2(30) --运营车类型代码
,inv_id varchar2(100) --发票编号
,other_comnt varchar2(4000) --其他说明
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,asset_id varchar2(100) --资产编号
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
grant select on ${idl_schema}.oass_ast_col_motor_vehic_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_motor_vehic_info is '押品机动车信息';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.exchg_inpwn_rgst_id is '交易所质押登记编号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.drv_lics_id is '行驶证编号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.chassis_no is '车架号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.engine_id is '发动机编号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.lics_plat_num is '车牌照号码';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.house_used_flg is '一手二手标志';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.brand_prod_manuf_name is '品牌生产厂商名称';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.model_spec is '型号规格';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.displment is '排量';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.chg_speed_type_cd is '变速类型代码';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.leave_factory_dt is '出厂日期';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.design_use_exp_dt is '设计使用到期日期';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.steer_mile_cnt is '行驶里程数';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.oper_vehic_flg is '运营车辆标志';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.oper_car_type_cd is '运营车类型代码';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.inv_id is '发票编号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.other_comnt is '其他说明';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_motor_vehic_info.lp_id is '法人编号';

