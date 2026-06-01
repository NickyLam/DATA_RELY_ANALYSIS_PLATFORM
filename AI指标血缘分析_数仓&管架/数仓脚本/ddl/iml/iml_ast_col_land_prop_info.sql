/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_land_prop_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_land_prop_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_land_prop_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_land_prop_info(
    col_id varchar2(100) -- 押品编号
    ,lp_id varchar2(100) -- 法人编号
    ,land_cert_id varchar2(250) -- 土地证号
    ,land_use_char_cd varchar2(30) -- 土地使用性质代码
    ,land_use_right_subclass_cd varchar2(30) -- 土地使用权细类代码
    ,land_use_right_get_way_cd varchar2(30) -- 土地使用权取得方式代码
    ,land_use_right_effect_dt date -- 土地使用权生效日期
    ,land_use_right_exp_dt date -- 土地使用权到期日期
    ,land_usage_cd varchar2(30) -- 土地用途代码
    ,land_use_right_area number(30,2) -- 土地使用权面积
    ,local_prov_cd varchar2(60) -- 所在省份代码
    ,city_cd varchar2(60) -- 所在城市代码
    ,local_county_rg_cd varchar2(60) -- 所在县区代码
    ,local_street varchar2(500) -- 所在街道
    ,land_dtl_addr varchar2(500) -- 土地详细地址
    ,parcel_num varchar2(250) -- 宗地号
    ,buy_dt date -- 购买日期
    ,buy_price number(30,2) -- 购买价格
    ,curr_cd varchar2(30) -- 币种代码
    ,have_land_up_attachmen_flg varchar2(10) -- 有地上附着物标志
    ,other_comnt varchar2(4000) -- 其他说明
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ast_col_land_prop_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_land_prop_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_land_prop_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_land_prop_info is '押品土地产权信息';
comment on column ${iml_schema}.ast_col_land_prop_info.col_id is '押品编号';
comment on column ${iml_schema}.ast_col_land_prop_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_land_prop_info.land_cert_id is '土地证号';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_char_cd is '土地使用性质代码';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_right_subclass_cd is '土地使用权细类代码';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_right_get_way_cd is '土地使用权取得方式代码';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_right_effect_dt is '土地使用权生效日期';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_right_exp_dt is '土地使用权到期日期';
comment on column ${iml_schema}.ast_col_land_prop_info.land_usage_cd is '土地用途代码';
comment on column ${iml_schema}.ast_col_land_prop_info.land_use_right_area is '土地使用权面积';
comment on column ${iml_schema}.ast_col_land_prop_info.local_prov_cd is '所在省份代码';
comment on column ${iml_schema}.ast_col_land_prop_info.city_cd is '所在城市代码';
comment on column ${iml_schema}.ast_col_land_prop_info.local_county_rg_cd is '所在县区代码';
comment on column ${iml_schema}.ast_col_land_prop_info.local_street is '所在街道';
comment on column ${iml_schema}.ast_col_land_prop_info.land_dtl_addr is '土地详细地址';
comment on column ${iml_schema}.ast_col_land_prop_info.parcel_num is '宗地号';
comment on column ${iml_schema}.ast_col_land_prop_info.buy_dt is '购买日期';
comment on column ${iml_schema}.ast_col_land_prop_info.buy_price is '购买价格';
comment on column ${iml_schema}.ast_col_land_prop_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_land_prop_info.have_land_up_attachmen_flg is '有地上附着物标志';
comment on column ${iml_schema}.ast_col_land_prop_info.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_col_land_prop_info.start_dt is '开始时间';
comment on column ${iml_schema}.ast_col_land_prop_info.end_dt is '结束时间';
comment on column ${iml_schema}.ast_col_land_prop_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_land_prop_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_land_prop_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_land_prop_info.etl_timestamp is 'ETL处理时间戳';
