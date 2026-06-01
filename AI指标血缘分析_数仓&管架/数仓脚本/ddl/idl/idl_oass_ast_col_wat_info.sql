/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_wat_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_wat_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_wat_info(
etl_dt date --ETL处理日期
,wat_id varchar2(60) --权证编号
,wat_num varchar2(250) --权证号码
,wat_name varchar2(500) --权证名称
,wat_type_cd varchar2(10) --权证类型代码
,licen_issue_autho_name varchar2(500) --发证机关名称
,issue_dt date --发证日期
,valid_closing_dt date --有效截止日期
,rgst_dt date --登记日期
,rgst_emply_id varchar2(60) --登记员工编号
,insto_flow_id varchar2(60) --入库流程编号
,acss_cont_id varchar2(60) --从合同编号
,pri_contr_id varchar2(60) --主合同编号
,insto_id varchar2(60) --入库编号
,insto_dt date --入库日期
,ex_flow_id varchar2(60) --出库流程编号
,ex_dt date --出库日期
,latest_debit_flow_id varchar2(60) --最新借用流程编号
,latest_debit_dt date --最新借用日期
,rn_flow_id varchar2(60) --续借流程编号
,rn_dt date --续借日期
,rn_cnt number(10,0) --续借次数
,latest_rtn_dt date --最新归还日期
,wat_status_cd varchar2(10) --权证状态类型代码
,uniq_wat_flg varchar2(10) --唯一权证标志
,flow_status_cd varchar2(10) --流程状态代码
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
grant select on ${idl_schema}.oass_ast_col_wat_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_wat_info is '押品权证信息';
comment on column ${idl_schema}.oass_ast_col_wat_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.wat_id is '权证编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.wat_num is '权证号码';
comment on column ${idl_schema}.oass_ast_col_wat_info.wat_name is '权证名称';
comment on column ${idl_schema}.oass_ast_col_wat_info.wat_type_cd is '权证类型代码';
comment on column ${idl_schema}.oass_ast_col_wat_info.licen_issue_autho_name is '发证机关名称';
comment on column ${idl_schema}.oass_ast_col_wat_info.issue_dt is '发证日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.valid_closing_dt is '有效截止日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.rgst_emply_id is '登记员工编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.insto_flow_id is '入库流程编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.acss_cont_id is '从合同编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.pri_contr_id is '主合同编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.insto_id is '入库编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.insto_dt is '入库日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.ex_flow_id is '出库流程编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.ex_dt is '出库日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.latest_debit_flow_id is '最新借用流程编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.latest_debit_dt is '最新借用日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.rn_flow_id is '续借流程编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.rn_dt is '续借日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.rn_cnt is '续借次数';
comment on column ${idl_schema}.oass_ast_col_wat_info.latest_rtn_dt is '最新归还日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.wat_status_cd is '权证状态类型代码';
comment on column ${idl_schema}.oass_ast_col_wat_info.uniq_wat_flg is '唯一权证标志';
comment on column ${idl_schema}.oass_ast_col_wat_info.flow_status_cd is '流程状态代码';
comment on column ${idl_schema}.oass_ast_col_wat_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_wat_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_wat_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_wat_info.lp_id is '法人编号';

