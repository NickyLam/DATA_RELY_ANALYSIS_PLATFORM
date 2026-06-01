/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_contr_righofland_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_contr_righofland_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ast_contr_righofland_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_contr_righofland_info_h(
    col_id varchar2(100) -- 押品编号
    ,rel_esat_cert_num varchar2(100) -- 不动产证号
    ,land_contr_mgmt_righ_wat_num varchar2(250) -- 土地承包经营权证编号
    ,land_contr_mgmt_righ_get_dt date -- 土地承包经营权取得日期
    ,land_contr_mgmt_righ_exp_dt date -- 土地承包经营权到期日期
    ,land_contr_mgmt_righ_area number(30,2) -- 土地承包经营权面积
    ,rgst_prov_cd varchar2(60) -- 注册省份代码
    ,rgst_city_rg_cd varchar2(60) -- 注册市区代码
    ,land_contr_mgmt_righ_addr varchar2(750) -- 土地承包经营权地址
    ,buy_dt date -- 购买日期
    ,buy_price number(30,2) -- 购买价格
    ,other_comnt varchar2(4000) -- 其他说明
    ,curr_cd varchar2(30) -- 币种代码
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
grant select on ${iml_schema}.ast_contr_righofland_info_h to ${icl_schema};
grant select on ${iml_schema}.ast_contr_righofland_info_h to ${idl_schema};
grant select on ${iml_schema}.ast_contr_righofland_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_contr_righofland_info_h is '土地承包经营权信息历史';
comment on column ${iml_schema}.ast_contr_righofland_info_h.col_id is '押品编号';
comment on column ${iml_schema}.ast_contr_righofland_info_h.rel_esat_cert_num is '不动产证号';
comment on column ${iml_schema}.ast_contr_righofland_info_h.land_contr_mgmt_righ_wat_num is '土地承包经营权证编号';
comment on column ${iml_schema}.ast_contr_righofland_info_h.land_contr_mgmt_righ_get_dt is '土地承包经营权取得日期';
comment on column ${iml_schema}.ast_contr_righofland_info_h.land_contr_mgmt_righ_exp_dt is '土地承包经营权到期日期';
comment on column ${iml_schema}.ast_contr_righofland_info_h.land_contr_mgmt_righ_area is '土地承包经营权面积';
comment on column ${iml_schema}.ast_contr_righofland_info_h.rgst_prov_cd is '注册省份代码';
comment on column ${iml_schema}.ast_contr_righofland_info_h.rgst_city_rg_cd is '注册市区代码';
comment on column ${iml_schema}.ast_contr_righofland_info_h.land_contr_mgmt_righ_addr is '土地承包经营权地址';
comment on column ${iml_schema}.ast_contr_righofland_info_h.buy_dt is '购买日期';
comment on column ${iml_schema}.ast_contr_righofland_info_h.buy_price is '购买价格';
comment on column ${iml_schema}.ast_contr_righofland_info_h.other_comnt is '其他说明';
comment on column ${iml_schema}.ast_contr_righofland_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_contr_righofland_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ast_contr_righofland_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ast_contr_righofland_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ast_contr_righofland_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_contr_righofland_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ast_contr_righofland_info_h.etl_timestamp is 'ETL处理时间戳';
