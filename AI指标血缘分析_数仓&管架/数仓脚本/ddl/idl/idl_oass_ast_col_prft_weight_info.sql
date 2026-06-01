/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_prft_weight_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_prft_weight_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_prft_weight_info(
etl_dt date --ETL处理日期
,prft_weight_gover_doc_id varchar2(60) --收益权政府批文编号
,prft_weight_gover_doc_name varchar2(100) --收益权政府批文名称
,eqty_cert_id varchar2(60) --权益证书编号
,eqty_owner_name varchar2(100) --权益所有人名称
,eqty_start_dt date --权益开始日期
,eqty_exp_dt date --权益到期日期
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
grant select on ${idl_schema}.oass_ast_col_prft_weight_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_prft_weight_info is '押品收益权信息';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.prft_weight_gover_doc_id is '收益权政府批文编号';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.prft_weight_gover_doc_name is '收益权政府批文名称';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.eqty_cert_id is '权益证书编号';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.eqty_owner_name is '权益所有人名称';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.eqty_start_dt is '权益开始日期';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.eqty_exp_dt is '权益到期日期';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.other_comnt is '其他说明';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_prft_weight_info.lp_id is '法人编号';

