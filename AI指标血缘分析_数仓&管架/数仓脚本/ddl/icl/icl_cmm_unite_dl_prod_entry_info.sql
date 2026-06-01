/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_unite_dl_prod_entry_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_unite_dl_prod_entry_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_dl_prod_entry_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_dl_prod_entry_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(200) -- 产品名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_char varchar2(15) -- 产品性质
    ,subj_id varchar2(60) -- 科目编号
    ,curr_cd varchar2(10) -- 币种代码
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,td_amt number(20,2) -- 当日发生额
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
grant select on ${icl_schema}.cmm_unite_dl_prod_entry_info to ${idl_schema};
grant select on ${icl_schema}.cmm_unite_dl_prod_entry_info to ${iel_schema};
grant select on ${icl_schema}.cmm_unite_dl_prod_entry_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_unite_dl_prod_entry_info is '联合存贷款产品分录信息';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.prod_char is '产品性质';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.td_amt is '当日发生额';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_unite_dl_prod_entry_info.etl_timestamp is 'ETL处理时间戳';
