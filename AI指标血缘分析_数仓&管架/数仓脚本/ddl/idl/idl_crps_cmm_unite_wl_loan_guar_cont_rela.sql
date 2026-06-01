/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_loan_guar_cont_rela
CreateDate: 20231111
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,loan_cont_id varchar2(100) --贷款合同编号
,guar_cont_id	varchar2(100)	--担保合同编号
,col_id	varchar2(100)	--押品编号
,guar_way_cd varchar2(30) --担保方式代码
,guar_curr_cd	varchar2(10) --担保币种代码
,guar_cont_status_cd varchar2(30) --担保合同状态代码
,guartor_cust_id varchar2(100) --担保人客户号
,guartor_name	varchar2(500) --担保人名称
,guar_effect_dt date --担保生效日期
,guar_exp_dt date --担保到期日期

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela is '联合网贷贷款与担保合同关系';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.etl_dt is '数据日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.lp_id is '法人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.loan_cont_id is '贷款合同编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_cont_id is '担保合同编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.col_id is '押品编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_curr_cd is '担保币种代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_cont_status_cd is '担保合同状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guartor_cust_id is '担保人客户号';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guartor_name is '担保人名称';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_effect_dt is '担保生效日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela.guar_exp_dt is '担保到期日期';
