/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_insure_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_insure_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_insure_info(
etl_dt date --ETL处理日期
,insure_seq_num varchar2(60) --保险序号
,insure_pl_id varchar2(60) --保险单编号
,insu_comp_name varchar2(250) --保险公司名称
,insu_comp_orgnz_cd varchar2(60) --保险公司组织机构代码
,full_amt_insure_flg varchar2(10) --全额投保标志
,insure_insud_amt number(30,2) --保险承保金额
,begin_dt date --起始日期
,exp_dt date --到期日期
,check_guar_dt date --核保日期
,fst_ctfer_name varchar2(100) --第一核保人姓名
,secd_ctfer_name varchar2(100) --第二核保人姓名
,operr_id varchar2(60) --操作员编号
,insure_status_cd varchar2(10) --保险状态代码
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
grant select on ${idl_schema}.oass_ast_col_insure_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_insure_info is '押品保险信息';
comment on column ${idl_schema}.oass_ast_col_insure_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.insure_seq_num is '保险序号';
comment on column ${idl_schema}.oass_ast_col_insure_info.insure_pl_id is '保险单编号';
comment on column ${idl_schema}.oass_ast_col_insure_info.insu_comp_name is '保险公司名称';
comment on column ${idl_schema}.oass_ast_col_insure_info.insu_comp_orgnz_cd is '保险公司组织机构代码';
comment on column ${idl_schema}.oass_ast_col_insure_info.full_amt_insure_flg is '全额投保标志';
comment on column ${idl_schema}.oass_ast_col_insure_info.insure_insud_amt is '保险承保金额';
comment on column ${idl_schema}.oass_ast_col_insure_info.begin_dt is '起始日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.check_guar_dt is '核保日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.fst_ctfer_name is '第一核保人姓名';
comment on column ${idl_schema}.oass_ast_col_insure_info.secd_ctfer_name is '第二核保人姓名';
comment on column ${idl_schema}.oass_ast_col_insure_info.operr_id is '操作员编号';
comment on column ${idl_schema}.oass_ast_col_insure_info.insure_status_cd is '保险状态代码';
comment on column ${idl_schema}.oass_ast_col_insure_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_insure_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_insure_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_insure_info.lp_id is '法人编号';

