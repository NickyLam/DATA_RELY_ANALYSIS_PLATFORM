/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_col_tran_recvbl_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_col_tran_recvbl_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_col_tran_recvbl_info(
etl_dt date --ETL处理日期
,lc_num varchar2(60) --信用证号码
,fac_val_amt number(30,2) --票面金额
,inv_id varchar2(60) --发票编号
,inv_dt date --发票日期
,inv_exp_dt date --发票到期日期
,aging number(10,0) --账龄
,payer_name varchar2(100) --付款人名称
,bkrpt_clear_flg varchar2(10) --破产清算标志
,payer_acct_id varchar2(60) --付款人账户编号
,advise_acct_recvbl_flg varchar2(10) --通知应收账款义务人标志
,cred_rht_prod_flg varchar2(10) --债权产生标志
,other_comnt varchar2(4000) --其他说明
,rela_flg varchar2(10) --关系标志
,curr_cd varchar2(30) --币种代码
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
grant select on ${idl_schema}.oass_ast_col_tran_recvbl_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_col_tran_recvbl_info is '押品交易类应收账款信息';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.lc_num is '信用证号码';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.fac_val_amt is '票面金额';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.inv_id is '发票编号';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.inv_dt is '发票日期';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.inv_exp_dt is '发票到期日期';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.aging is '账龄';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.payer_name is '付款人名称';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.bkrpt_clear_flg is '破产清算标志';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.payer_acct_id is '付款人账户编号';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.advise_acct_recvbl_flg is '通知应收账款义务人标志';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.cred_rht_prod_flg is '债权产生标志';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.other_comnt is '其他说明';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.rela_flg is '关系标志';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_col_tran_recvbl_info.lp_id is '法人编号';

