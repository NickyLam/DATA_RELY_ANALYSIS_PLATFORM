/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccrm_t_cust_sbjj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccrm_t_cust_sbjj_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccrm_t_cust_sbjj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccrm_t_cust_sbjj_info(
    sbjj_id varchar2(48) -- 主键id
    ,pty_id varchar2(90) -- 客户号
    ,cn_fname varchar2(150) -- 客户名称
    ,acct_num varchar2(90) -- 账户号
    ,acct_znum varchar2(90) -- 子账户号
    ,sbjj_flag varchar2(15) -- 社保基金标识
    ,oper_user varchar2(90) -- 操作人id
    ,oper_org varchar2(90) -- 操作机构id
    ,oper_time date -- 操作日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ccrm_t_cust_sbjj_info to ${iml_schema};
grant select on ${iol_schema}.ccrm_t_cust_sbjj_info to ${icl_schema};
grant select on ${iol_schema}.ccrm_t_cust_sbjj_info to ${idl_schema};
grant select on ${iol_schema}.ccrm_t_cust_sbjj_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccrm_t_cust_sbjj_info is '';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.sbjj_id is '主键id';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.pty_id is '客户号';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.cn_fname is '客户名称';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.acct_num is '账户号';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.acct_znum is '子账户号';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.sbjj_flag is '社保基金标识';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.oper_user is '操作人id';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.oper_org is '操作机构id';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.oper_time is '操作日期';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ccrm_t_cust_sbjj_info.etl_timestamp is 'ETL处理时间戳';
