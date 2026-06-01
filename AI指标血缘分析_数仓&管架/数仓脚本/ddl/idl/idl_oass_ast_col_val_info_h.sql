/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_val_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_val_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_val_info_h(
etl_dt date --数据日期
,estim_way_cd varchar2(10) --评估方式代码
,estim_dt date --估值日期
,curr_cd varchar2(10) --币种代码
,exch_rat number(18,8) --汇率
,ext_estim_exp_dt date --估值到期日期
,ext_estim_org_id varchar2(500) --外部评估机构编号
,ext_estim_method_cd varchar2(30) --外部评估方法代码
,ext_pre_estim_val number(30,2) --外部预评价值
,ext_formal_estim_dt date --外部正式评估日期
,ext_estim_val number(30,2) --外部评估价值
,intnal_estim_val number(30,2) --内部评估价值
,appl_estim_cfm_val number(30,2) --申请评估确认价值
,flow_id varchar2(60) --流程编号
,hxb_cfm_val number(30,2) --我行确认价值
,estim_idtfy_dt date --评估认定日期
,ext_pa_estim_val number(30,2) --外部初评评估价值
,intnal_pa_estim_val number(30,2) --内部初评评估价值
,hxb_pa_cfm_val number(30,2) --我行初评确认价值
,pa_flow_id varchar2(60) --初评流程编号
,evltion_status_cd varchar2(10) --估值状态代码
,froz_flg varchar2(10) --冻结标志
,insto_col_val number(30,2) --入库押品价值
,insto_org_id varchar2(60) --入库机构编号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,ext_pre_estim_flg varchar2(10) --外部预评估标志
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
grant select on ${idl_schema}.oass_ast_col_val_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_val_info_h is '押品价值信息历史';
comment on column ${idl_schema}.oass_ast_col_val_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_col_val_info_h.estim_way_cd is '评估方式代码';
comment on column ${idl_schema}.oass_ast_col_val_info_h.estim_dt is '估值日期';
comment on column ${idl_schema}.oass_ast_col_val_info_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ast_col_val_info_h.exch_rat is '汇率';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_estim_exp_dt is '估值到期日期';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_estim_org_id is '外部评估机构编号';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_estim_method_cd is '外部评估方法代码';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_pre_estim_val is '外部预评价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_formal_estim_dt is '外部正式评估日期';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_estim_val is '外部评估价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.intnal_estim_val is '内部评估价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.appl_estim_cfm_val is '申请评估确认价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.flow_id is '流程编号';
comment on column ${idl_schema}.oass_ast_col_val_info_h.hxb_cfm_val is '我行确认价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.estim_idtfy_dt is '评估认定日期';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_pa_estim_val is '外部初评评估价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.intnal_pa_estim_val is '内部初评评估价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.hxb_pa_cfm_val is '我行初评确认价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.pa_flow_id is '初评流程编号';
comment on column ${idl_schema}.oass_ast_col_val_info_h.evltion_status_cd is '估值状态代码';
comment on column ${idl_schema}.oass_ast_col_val_info_h.froz_flg is '冻结标志';
comment on column ${idl_schema}.oass_ast_col_val_info_h.insto_col_val is '入库押品价值';
comment on column ${idl_schema}.oass_ast_col_val_info_h.insto_org_id is '入库机构编号';
comment on column ${idl_schema}.oass_ast_col_val_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_col_val_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_col_val_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_val_info_h.ext_pre_estim_flg is '外部预评估标志';
comment on column ${idl_schema}.oass_ast_col_val_info_h.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_val_info_h.lp_id is '法人编号';

