/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_loan_guar_cont_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_loan_guar_cont_rela
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_loan_guar_cont_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_guar_cont_rela(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,loan_cont_id varchar2(100) -- 贷款合同编号
    ,pri_contr_type_cd varchar2(10) -- 主合同类型代码
    ,guar_cont_id varchar2(60) -- 担保合同编号
    ,guar_cont_type_cd varchar2(10) -- 担保合同类型代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guar_cont_status_cd varchar2(10) -- 担保合同状态代码
    ,guartor_name varchar2(500) -- 担保人名称
    ,guar_start_dt date -- 担保起始日期
    ,guar_exp_dt date -- 担保到期日期
    ,guar_amt number(30,2) -- 担保金额
    ,guar_curr_cd varchar2(10) -- 担保币种代码
    ,src_sys_cd varchar2(10) -- 来源系统代码
    ,strip_line_cd varchar2(60) -- 条线代码
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
grant select on ${icl_schema}.cmm_loan_guar_cont_rela to ${idl_schema};
grant select on ${icl_schema}.cmm_loan_guar_cont_rela to ${iel_schema};
grant select on ${icl_schema}.cmm_loan_guar_cont_rela to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_loan_guar_cont_rela is '贷款合同与担保合同关系';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.loan_cont_id is '贷款合同编号';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.pri_contr_type_cd is '主合同类型代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_cont_id is '担保合同编号';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_cont_type_cd is '担保合同类型代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_cont_status_cd is '担保合同状态代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_start_dt is '担保起始日期';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_exp_dt is '担保到期日期';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_amt is '担保金额';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.guar_curr_cd is '担保币种代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.src_sys_cd is '来源系统代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.strip_line_cd is '条线代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_loan_guar_cont_rela.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_loan_guar_cont_rela.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_loan_guar_cont_rela.etl_timestamp is 'ETL处理时间戳';
