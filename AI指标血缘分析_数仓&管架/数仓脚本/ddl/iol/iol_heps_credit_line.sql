/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_credit_line
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_credit_line
whenever sqlerror continue none;
drop table ${iol_schema}.heps_credit_line purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_credit_line(
    id number -- id号
    ,customer_id number -- 客户号
    ,flow_id varchar2(64) -- 业务流程号
    ,credit_line varchar2(64) -- 授信额度
    ,credit_time varchar2(32) -- 授信期限
    ,model_result varchar2(32) -- 模型接口
    ,operate varchar2(10) -- 操作(1:同意 2:拒绝 3:复议 4:客户放弃)
    ,status varchar2(8) -- 状态
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
    ,ecif_opnion varchar2(2000) -- 客户经理意见
    ,apply_line number(24,6) -- 申请金额
    ,opnion_line number(24,6) -- 意见金额
    ,attach varchar2(2000) -- 庙算预警
    ,p_mortgage_line number -- 最高抵押金额
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
grant select on ${iol_schema}.heps_credit_line to ${iml_schema};
grant select on ${iol_schema}.heps_credit_line to ${icl_schema};
grant select on ${iol_schema}.heps_credit_line to ${idl_schema};
grant select on ${iol_schema}.heps_credit_line to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_credit_line is '授权意见金额表';
comment on column ${iol_schema}.heps_credit_line.id is 'id号';
comment on column ${iol_schema}.heps_credit_line.customer_id is '客户号';
comment on column ${iol_schema}.heps_credit_line.flow_id is '业务流程号';
comment on column ${iol_schema}.heps_credit_line.credit_line is '授信额度';
comment on column ${iol_schema}.heps_credit_line.credit_time is '授信期限';
comment on column ${iol_schema}.heps_credit_line.model_result is '模型接口';
comment on column ${iol_schema}.heps_credit_line.operate is '操作(1:同意 2:拒绝 3:复议 4:客户放弃)';
comment on column ${iol_schema}.heps_credit_line.status is '状态';
comment on column ${iol_schema}.heps_credit_line.create_time is '创建时间';
comment on column ${iol_schema}.heps_credit_line.update_time is '修改时间';
comment on column ${iol_schema}.heps_credit_line.ecif_opnion is '客户经理意见';
comment on column ${iol_schema}.heps_credit_line.apply_line is '申请金额';
comment on column ${iol_schema}.heps_credit_line.opnion_line is '意见金额';
comment on column ${iol_schema}.heps_credit_line.attach is '庙算预警';
comment on column ${iol_schema}.heps_credit_line.p_mortgage_line is '最高抵押金额';
comment on column ${iol_schema}.heps_credit_line.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_credit_line.etl_timestamp is 'ETL处理时间戳';
