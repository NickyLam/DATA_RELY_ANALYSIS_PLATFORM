/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_account_quanyi_point
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_account_quanyi_point
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_account_quanyi_point purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_quanyi_point(
    branch_no varchar2(18) -- 分行号
    ,branch_no_name varchar2(150) -- 分行名称
    ,org_no varchar2(18) -- 机构号
    ,org_no_name varchar2(150) -- 机构名称
    ,pty_id varchar2(75) -- 客户号
    ,pty_name varchar2(300) -- 客户名称
    ,equity_count number(22,0) -- 权益积分
    ,val_end_dt varchar2(12) -- 有效结束日期(格式为yyyy1230，消费时优先使用今年到期的权益积分)
    ,is_valid varchar2(2) -- 是否有效标志(0-有效 1-失效)
    ,last_ope_time varchar2(21) -- 最后操作时间(yyyymmddhhmmss)
    ,final_oper_pers varchar2(48) -- 最后操作人
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
grant select on ${iol_schema}.cpms_t_account_quanyi_point to ${iml_schema};
grant select on ${iol_schema}.cpms_t_account_quanyi_point to ${icl_schema};
grant select on ${iol_schema}.cpms_t_account_quanyi_point to ${idl_schema};
grant select on ${iol_schema}.cpms_t_account_quanyi_point to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_account_quanyi_point is '客户权益积分表';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.branch_no is '分行号';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.branch_no_name is '分行名称';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.org_no is '机构号';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.org_no_name is '机构名称';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.pty_id is '客户号';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.pty_name is '客户名称';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.equity_count is '权益积分';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.val_end_dt is '有效结束日期(格式为yyyy1230，消费时优先使用今年到期的权益积分)';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.is_valid is '是否有效标志(0-有效 1-失效)';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.last_ope_time is '最后操作时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.final_oper_pers is '最后操作人';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cpms_t_account_quanyi_point.etl_timestamp is 'ETL处理时间戳';
