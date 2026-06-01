/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifds_account_password_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifds_account_password_history
whenever sqlerror continue none;
drop table ${iol_schema}.ifds_account_password_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_account_password_history(
    account_id varchar2(30) -- E账户编号
    ,password_type_id varchar2(30) -- 密码类型
    ,old_password varchar2(96) -- 旧密码
    ,new_password varchar2(96) -- 新密码
    ,modify_time timestamp -- 密码修改时间
    ,tran_teller_no varchar2(90) -- 柜员
    ,tran_seq_no varchar2(90) -- 交易流水
    ,branch_id varchar2(48) -- 机构
    ,channel varchar2(15) -- 渠道
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.ifds_account_password_history to ${iml_schema};
grant select on ${iol_schema}.ifds_account_password_history to ${icl_schema};
grant select on ${iol_schema}.ifds_account_password_history to ${idl_schema};
grant select on ${iol_schema}.ifds_account_password_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifds_account_password_history is '账户密码历史表';
comment on column ${iol_schema}.ifds_account_password_history.account_id is 'E账户编号';
comment on column ${iol_schema}.ifds_account_password_history.password_type_id is '密码类型';
comment on column ${iol_schema}.ifds_account_password_history.old_password is '旧密码';
comment on column ${iol_schema}.ifds_account_password_history.new_password is '新密码';
comment on column ${iol_schema}.ifds_account_password_history.modify_time is '密码修改时间';
comment on column ${iol_schema}.ifds_account_password_history.tran_teller_no is '柜员';
comment on column ${iol_schema}.ifds_account_password_history.tran_seq_no is '交易流水';
comment on column ${iol_schema}.ifds_account_password_history.branch_id is '机构';
comment on column ${iol_schema}.ifds_account_password_history.channel is '渠道';
comment on column ${iol_schema}.ifds_account_password_history.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.ifds_account_password_history.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.ifds_account_password_history.created_stamp is '创建时间';
comment on column ${iol_schema}.ifds_account_password_history.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.ifds_account_password_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifds_account_password_history.etl_timestamp is 'ETL处理时间戳';
