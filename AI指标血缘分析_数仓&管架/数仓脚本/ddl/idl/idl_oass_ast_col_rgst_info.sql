/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_rgst_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_rgst_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_rgst_info(
etl_dt date --ETL处理日期
,rgst_seq_num varchar2(60) --登记序号
,rgst_org_name varchar2(500) --登记机构名称
,rgst_val number(30,2) --已抵押价值
,rgst_dt date --登记日期
,rgst_exp_dt date --登记有效终止日期
,pre_mtg_flg varchar2(10) --预抵押标志
,pre_mtg_rgst_dt date --预抵押登记日期
,pre_mtg_rgst_invalid_dt date --预抵押登记失效日期
,operr_id varchar2(60) --操作员编号
,rgst_cert_id varchar2(250) --登记证书编号
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
grant select on ${idl_schema}.oass_ast_col_rgst_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_rgst_info is '押品登记信息';
comment on column ${idl_schema}.oass_ast_col_rgst_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_seq_num is '登记序号';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_org_name is '登记机构名称';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_val is '已抵押价值';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_exp_dt is '登记有效终止日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.pre_mtg_flg is '预抵押标志';
comment on column ${idl_schema}.oass_ast_col_rgst_info.pre_mtg_rgst_dt is '预抵押登记日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.pre_mtg_rgst_invalid_dt is '预抵押登记失效日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.operr_id is '操作员编号';
comment on column ${idl_schema}.oass_ast_col_rgst_info.rgst_cert_id is '登记证书编号';
comment on column ${idl_schema}.oass_ast_col_rgst_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_rgst_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_rgst_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_rgst_info.lp_id is '法人编号';

