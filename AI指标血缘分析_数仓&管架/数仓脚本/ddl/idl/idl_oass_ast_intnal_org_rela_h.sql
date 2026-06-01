/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_intnal_org_rela_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_intnal_org_rela_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_intnal_org_rela_h(
etl_dt date --数据日期
,asset_intnal_org_rela_type_cd varchar2(10) --资产内部机构关系类型代码
,seq_num varchar2(60) --序号
,org_id varchar2(60) --机构编号
,start_dt date --开始时间
,end_dt date --结束时间
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
grant select on ${idl_schema}.oass_ast_intnal_org_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_intnal_org_rela_h is '资产内部机构关系历史';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.asset_intnal_org_rela_type_cd is '资产内部机构关系类型代码';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.seq_num is '序号';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.org_id is '机构编号';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_intnal_org_rela_h.lp_id is '法人编号';

