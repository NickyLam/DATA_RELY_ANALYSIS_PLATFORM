/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_non_result_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_non_result_info
whenever sqlerror continue none;
drop table ${iol_schema}.alss_non_result_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_non_result_info(
    deal_date varchar2(96) -- 交易日期
    ,tran_organ varchar2(300) -- 交易机构
    ,jobs_name varchar2(300) -- 经办业务人员岗位
    ,deal_user_no varchar2(96) -- 用户号
    ,teller_name varchar2(300) -- 用户姓名
    ,deal_user_no1 varchar2(96) -- 授权柜员号
    ,teller_name1 varchar2(300) -- 授权柜员姓名
    ,org_id varchar2(180) -- 授权机构
    ,tran_code varchar2(500) -- 交易码值
    ,tran_name varchar2(90) -- 交易名称
    ,tran_start_time date -- 交易开始时间
    ,tran_end_time date -- 交易结束时间
    ,glob_seq_num varchar2(500) -- 业务流水号
    ,system_name varchar2(100) -- 系统名称
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
grant select on ${iol_schema}.alss_non_result_info to ${iml_schema};
grant select on ${iol_schema}.alss_non_result_info to ${icl_schema};
grant select on ${iol_schema}.alss_non_result_info to ${idl_schema};
grant select on ${iol_schema}.alss_non_result_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_non_result_info is '业务流程信息表';
comment on column ${iol_schema}.alss_non_result_info.deal_date is '交易日期';
comment on column ${iol_schema}.alss_non_result_info.tran_organ is '交易机构';
comment on column ${iol_schema}.alss_non_result_info.jobs_name is '经办业务人员岗位';
comment on column ${iol_schema}.alss_non_result_info.deal_user_no is '用户号';
comment on column ${iol_schema}.alss_non_result_info.teller_name is '用户姓名';
comment on column ${iol_schema}.alss_non_result_info.deal_user_no1 is '授权柜员号';
comment on column ${iol_schema}.alss_non_result_info.teller_name1 is '授权柜员姓名';
comment on column ${iol_schema}.alss_non_result_info.org_id is '授权机构';
comment on column ${iol_schema}.alss_non_result_info.tran_code is '交易码值';
comment on column ${iol_schema}.alss_non_result_info.tran_name is '交易名称';
comment on column ${iol_schema}.alss_non_result_info.tran_start_time is '交易开始时间';
comment on column ${iol_schema}.alss_non_result_info.tran_end_time is '交易结束时间';
comment on column ${iol_schema}.alss_non_result_info.glob_seq_num is '业务流水号';
comment on column ${iol_schema}.alss_non_result_info.system_name is '系统名称';
comment on column ${iol_schema}.alss_non_result_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_non_result_info.etl_timestamp is 'ETL处理时间戳';
