/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_all_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_all_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_all_info_h(
etl_dt date --数据日期
,seq_num varchar2(100) --序号
,all_cust_id varchar2(100) --所有人客户编号
,col_all_type_cd varchar2(10) --押品所有人类型代码
,cert_type_cd varchar2(10) --证件类型代码
,cert_no varchar2(60) --证件号码
,pmo_obg_brwer_rela_cd varchar2(10) --抵质押品权利人与借款人关系代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,col_belong_ps_trdpty_flg varchar2(10) --押品权属人是否第三方标志
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
grant select on ${idl_schema}.oass_ast_col_all_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_all_info_h is '押品所有人信息历史';
comment on column ${idl_schema}.oass_ast_col_all_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_col_all_info_h.seq_num is '序号';
comment on column ${idl_schema}.oass_ast_col_all_info_h.all_cust_id is '所有人客户编号';
comment on column ${idl_schema}.oass_ast_col_all_info_h.col_all_type_cd is '押品所有人类型代码';
comment on column ${idl_schema}.oass_ast_col_all_info_h.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.oass_ast_col_all_info_h.cert_no is '证件号码';
comment on column ${idl_schema}.oass_ast_col_all_info_h.pmo_obg_brwer_rela_cd is '抵质押品权利人与借款人关系代码';
comment on column ${idl_schema}.oass_ast_col_all_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_col_all_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_col_all_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_all_info_h.col_belong_ps_trdpty_flg is '押品权属人是否第三方标志';
comment on column ${idl_schema}.oass_ast_col_all_info_h.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_all_info_h.lp_id is '法人编号';

