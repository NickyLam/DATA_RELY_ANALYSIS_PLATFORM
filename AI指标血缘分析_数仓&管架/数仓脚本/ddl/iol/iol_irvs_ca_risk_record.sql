/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ca_risk_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ca_risk_record
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ca_risk_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ca_risk_record(
    id varchar2(50) -- 主键ID
    ,customer_no varchar2(50) -- 客户编号
    ,customer_name varchar2(100) -- 客户名称
    ,client_type varchar2(2) -- 客户类型
    ,txn_org_cd varchar2(20) -- 客户所属机构
    ,phone varchar2(20) -- 联系方式
    ,id_type varchar2(20) -- 证件类型
    ,id_code varchar2(50) -- 证件号码
    ,paper_id varchar2(50) -- 关联问卷主键ID
    ,score number(18,2) -- 总分
    ,risk_level varchar2(2) -- 风险等级
    ,risk_time varchar2(50) -- 评级时间
    ,channel varchar2(10) -- 评估渠道
    ,effective_date date -- 有效期
    ,blip_platf_file_id varchar2(500) -- 影像平台文件ID
    ,risk_months varchar2(10) -- 风险有效月数
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
grant select on ${iol_schema}.irvs_ca_risk_record to ${iml_schema};
grant select on ${iol_schema}.irvs_ca_risk_record to ${icl_schema};
grant select on ${iol_schema}.irvs_ca_risk_record to ${idl_schema};
grant select on ${iol_schema}.irvs_ca_risk_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ca_risk_record is '客户风险评估记录表';
comment on column ${iol_schema}.irvs_ca_risk_record.id is '主键ID';
comment on column ${iol_schema}.irvs_ca_risk_record.customer_no is '客户编号';
comment on column ${iol_schema}.irvs_ca_risk_record.customer_name is '客户名称';
comment on column ${iol_schema}.irvs_ca_risk_record.client_type is '客户类型';
comment on column ${iol_schema}.irvs_ca_risk_record.txn_org_cd is '客户所属机构';
comment on column ${iol_schema}.irvs_ca_risk_record.phone is '联系方式';
comment on column ${iol_schema}.irvs_ca_risk_record.id_type is '证件类型';
comment on column ${iol_schema}.irvs_ca_risk_record.id_code is '证件号码';
comment on column ${iol_schema}.irvs_ca_risk_record.paper_id is '关联问卷主键ID';
comment on column ${iol_schema}.irvs_ca_risk_record.score is '总分';
comment on column ${iol_schema}.irvs_ca_risk_record.risk_level is '风险等级';
comment on column ${iol_schema}.irvs_ca_risk_record.risk_time is '评级时间';
comment on column ${iol_schema}.irvs_ca_risk_record.channel is '评估渠道';
comment on column ${iol_schema}.irvs_ca_risk_record.effective_date is '有效期';
comment on column ${iol_schema}.irvs_ca_risk_record.blip_platf_file_id is '影像平台文件ID';
comment on column ${iol_schema}.irvs_ca_risk_record.risk_months is '风险有效月数';
comment on column ${iol_schema}.irvs_ca_risk_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.irvs_ca_risk_record.etl_timestamp is 'ETL处理时间戳';
