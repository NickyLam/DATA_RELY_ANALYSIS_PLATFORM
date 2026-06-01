/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_tot_and_splt_col_rela
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_tot_and_splt_col_rela purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_tot_and_splt_col_rela(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,sup_chain_sys_merchd_id varchar2(60) --供应链系统商品编号
,invtry_id varchar2(60) --库存编号
,inpwn_id varchar2(60) --质押编号
,guar_contr_no varchar2(60) --担保合同号码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,parent_asset_id varchar2(60) --父资产编号
,sub_asset_id varchar2(60) --子资产编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_tot_and_splt_col_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_tot_and_splt_col_rela is '总押品与拆分押品关系表';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.sup_chain_sys_merchd_id is '供应链系统商品编号';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.invtry_id is '库存编号';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.inpwn_id is '质押编号';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.guar_contr_no is '担保合同号码';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.parent_asset_id is '父资产编号';
comment on column ${idl_schema}.oass_ast_tot_and_splt_col_rela.sub_asset_id is '子资产编号';

