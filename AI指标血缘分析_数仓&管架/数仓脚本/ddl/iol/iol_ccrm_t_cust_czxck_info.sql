/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccrm_t_cust_czxck_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccrm_t_cust_czxck_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccrm_t_cust_czxck_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccrm_t_cust_czxck_info(
    czxck_id varchar2(48) -- 主键id
    ,pty_id varchar2(90) -- 客户id
    ,cn_fname varchar2(150) -- 客户名称
    ,acct_num varchar2(90) -- 账号
    ,czxck_flag varchar2(15) -- 是否财政性存款标识
    ,rd_date date -- 认定日期
    ,oper_user varchar2(90) -- 创建人id
    ,oper_org varchar2(90) -- 创建人机构id
    ,oper_time date -- 创建时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ccrm_t_cust_czxck_info to ${iml_schema};
grant select on ${iol_schema}.ccrm_t_cust_czxck_info to ${icl_schema};
grant select on ${iol_schema}.ccrm_t_cust_czxck_info to ${idl_schema};
grant select on ${iol_schema}.ccrm_t_cust_czxck_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccrm_t_cust_czxck_info is '财政存款客户标识表';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.czxck_id is '主键id';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.pty_id is '客户id';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.cn_fname is '客户名称';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.acct_num is '账号';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.czxck_flag is '是否财政性存款标识';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.rd_date is '认定日期';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.oper_user is '创建人id';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.oper_org is '创建人机构id';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.oper_time is '创建时间';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.start_dt is '开始时间';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.end_dt is '结束时间';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.id_mark is '增删标志';
comment on column ${iol_schema}.ccrm_t_cust_czxck_info.etl_timestamp is 'ETL处理时间戳';
