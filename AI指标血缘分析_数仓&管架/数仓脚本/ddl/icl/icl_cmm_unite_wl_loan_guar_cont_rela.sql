/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_wl_loan_guar_cont_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,loan_cont_id varchar2(100) -- 贷款合同编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,col_id varchar2(100) -- 押品编号
	,std_prod_id VARCHAR2(60) -- 标准产品编号
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guar_curr_cd varchar2(10) -- 担保币种代码
    ,guar_cont_status_cd varchar2(30) -- 担保合同状态代码
    ,guartor_cust_id varchar2(100) -- 担保人客户号
    ,guartor_name varchar2(500) -- 担保人名称
    ,guar_effect_dt date -- 担保生效日期
    ,guar_exp_dt date -- 担保到期日期
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela is '联合网贷贷款与担保合同关系';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.loan_cont_id is '贷款合同编号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_cont_id is '担保合同编号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.col_id is '押品编号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_curr_cd is '担保币种代码';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_cont_status_cd is '担保合同状态代码';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guartor_cust_id is '担保人客户号';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_effect_dt is '担保生效日期';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.guar_exp_dt is '担保到期日期';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela.etl_timestamp is 'ETL处理时间戳';
