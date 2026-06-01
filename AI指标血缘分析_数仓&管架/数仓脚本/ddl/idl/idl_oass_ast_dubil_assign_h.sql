/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_dubil_assign_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_dubil_assign_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_dubil_assign_h(
etl_dt date --数据日期
,dubil_id varchar2(60) --借据编号
,loan_assign_bal number(30,2) --贷款分配余额
,dubil_bal number(30,2) --借据余额
,splt_col_latest_val number(30,2) --拆分押品最新价值
,splt_col_insto_val number(30,2) --拆分押品入库价值
,in_out_tab_flg varchar2(10) --表内外标志
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
grant select on ${idl_schema}.oass_ast_dubil_assign_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_dubil_assign_h is '资产借据分配历史';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.dubil_id is '借据编号';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.loan_assign_bal is '贷款分配余额';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.dubil_bal is '借据余额';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.splt_col_latest_val is '拆分押品最新价值';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.splt_col_insto_val is '拆分押品入库价值';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.in_out_tab_flg is '表内外标志';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_dubil_assign_h.lp_id is '法人编号';

