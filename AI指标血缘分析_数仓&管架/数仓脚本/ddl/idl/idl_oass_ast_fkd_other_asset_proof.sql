/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_fkd_other_asset_proof
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_fkd_other_asset_proof purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_fkd_other_asset_proof(
etl_dt date --数据日期
,asset_proof_list_id varchar2(60) --资产证明列表编号
,bus_flow_num varchar2(60) --业务流水号
,other_asset_proof_type varchar2(100) --其他资产证明类型
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
grant select on ${idl_schema}.oass_ast_fkd_other_asset_proof to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_fkd_other_asset_proof is '房快贷其他资产证明';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.asset_proof_list_id is '资产证明列表编号';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.other_asset_proof_type is '其他资产证明类型';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_fkd_other_asset_proof.lp_id is '法人编号';

