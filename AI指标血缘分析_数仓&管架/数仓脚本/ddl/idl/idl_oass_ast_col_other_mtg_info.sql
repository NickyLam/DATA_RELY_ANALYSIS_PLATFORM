/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_other_mtg_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_other_mtg_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_other_mtg_info(
etl_dt date --ETL处理日期
,col_name varchar2(100) --押品名称
,col_qtty number(18,2) --押品数量
,measure_corp_cd varchar2(30) --计量单位代码
,col_val number(30,2) --押品价值
,col_store_addr varchar2(100) --押品存放地址
,prop_get_dt date --所有权取得日期
,col_ori_price_val number(18,2) --押品原价值
,other_comnt varchar2(4000) --其他说明
,curr_cd varchar2(30) --币种代码
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
grant select on ${idl_schema}.oass_ast_col_other_mtg_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_other_mtg_info is '押品其他抵押物信息';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.col_name is '押品名称';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.col_qtty is '押品数量';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.measure_corp_cd is '计量单位代码';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.col_val is '押品价值';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.col_store_addr is '押品存放地址';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.prop_get_dt is '所有权取得日期';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.col_ori_price_val is '押品原价值';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.other_comnt is '其他说明';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_other_mtg_info.lp_id is '法人编号';

