/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ast_col_inv_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ast_col_inv_info
whenever sqlerror continue none;
drop table ${idl_schema}.ast_col_inv_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ast_col_inv_info(
    etl_dt date -- 数据日期   
    ,asset_id varchar2(60) -- 资产编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,inv_type_descb varchar2(100) -- 存货类型描述   
    ,local_prov_cd varchar2(60) -- 所在省代码   
    ,local_city_cd varchar2(60) -- 所在市代码   
    ,measure_corp_cd varchar2(30) -- 计量单位代码   
    ,qtty number(30,2) -- 数量   
    ,apprv_price number(30,2) -- 核定价格   
    ,supv_corp_supv_flg varchar2(10) -- 监管公司监管标志   
    ,supv_corp_name varchar2(100) -- 监管公司名称   
    ,supv_corp_orgnz_cd varchar2(60) -- 监管公司组织机构代码   
    ,agt_effect_dt date -- 协议生效日期   
    ,agt_invalid_dt date -- 协议失效日期   
    ,other_comnt varchar2(4000) -- 其他说明   
    ,other_measure_corp varchar2(30) -- 其他计量单位   
    ,curr_cd varchar2(30) -- 币种代码   
    ,mtg_rgst_b_id varchar2(250) -- 抵押登记书编号   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ast_col_inv_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.ast_col_inv_info is '押品存货信息';
comment on column ${idl_schema}.ast_col_inv_info.etl_dt is '数据日期';
comment on column ${idl_schema}.ast_col_inv_info.asset_id is '资产编号';
comment on column ${idl_schema}.ast_col_inv_info.lp_id is '法人编号';
comment on column ${idl_schema}.ast_col_inv_info.inv_type_descb is '存货类型描述';
comment on column ${idl_schema}.ast_col_inv_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.ast_col_inv_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.ast_col_inv_info.measure_corp_cd is '计量单位代码';
comment on column ${idl_schema}.ast_col_inv_info.qtty is '数量';
comment on column ${idl_schema}.ast_col_inv_info.apprv_price is '核定价格';
comment on column ${idl_schema}.ast_col_inv_info.supv_corp_supv_flg is '监管公司监管标志';
comment on column ${idl_schema}.ast_col_inv_info.supv_corp_name is '监管公司名称';
comment on column ${idl_schema}.ast_col_inv_info.supv_corp_orgnz_cd is '监管公司组织机构代码';
comment on column ${idl_schema}.ast_col_inv_info.agt_effect_dt is '协议生效日期';
comment on column ${idl_schema}.ast_col_inv_info.agt_invalid_dt is '协议失效日期';
comment on column ${idl_schema}.ast_col_inv_info.other_comnt is '其他说明';
comment on column ${idl_schema}.ast_col_inv_info.other_measure_corp is '其他计量单位';
comment on column ${idl_schema}.ast_col_inv_info.curr_cd is '币种代码';
comment on column ${idl_schema}.ast_col_inv_info.mtg_rgst_b_id is '抵押登记书编号';
comment on column ${idl_schema}.ast_col_inv_info.create_dt is '创建日期';
comment on column ${idl_schema}.ast_col_inv_info.update_dt is '更新日期';
comment on column ${idl_schema}.ast_col_inv_info.id_mark is '删除标识';