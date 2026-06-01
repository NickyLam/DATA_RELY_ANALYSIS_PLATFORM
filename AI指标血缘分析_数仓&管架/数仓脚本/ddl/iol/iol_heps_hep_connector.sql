/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_connector
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_connector
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_connector purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_connector(
    connector_id number(12) -- 联系人id
    ,flow_id varchar2(50) -- 业务流水号
    ,connector_name varchar2(64) -- 联系人姓名
    ,mobile varchar2(20) -- 手机号码
    ,borrower_relation varchar2(20) -- 与主借人关系
    ,input_time date -- 录入时间
    ,lastupdate_time date -- 最后更新时间
    ,status varchar2(16) -- 状态
    ,idcard_no varchar2(64) -- 身份证号
    ,addr_detail varchar2(384) -- 详细地址
    ,educational_highest varchar2(10) -- 最高学历
    ,connector_nature_rel varchar2(10) -- 联系人户籍性质
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
grant select on ${iol_schema}.heps_hep_connector to ${iml_schema};
grant select on ${iol_schema}.heps_hep_connector to ${icl_schema};
grant select on ${iol_schema}.heps_hep_connector to ${idl_schema};
grant select on ${iol_schema}.heps_hep_connector to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_connector is '联系人信息表';
comment on column ${iol_schema}.heps_hep_connector.connector_id is '联系人id';
comment on column ${iol_schema}.heps_hep_connector.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_connector.connector_name is '联系人姓名';
comment on column ${iol_schema}.heps_hep_connector.mobile is '手机号码';
comment on column ${iol_schema}.heps_hep_connector.borrower_relation is '与主借人关系';
comment on column ${iol_schema}.heps_hep_connector.input_time is '录入时间';
comment on column ${iol_schema}.heps_hep_connector.lastupdate_time is '最后更新时间';
comment on column ${iol_schema}.heps_hep_connector.status is '状态';
comment on column ${iol_schema}.heps_hep_connector.idcard_no is '身份证号';
comment on column ${iol_schema}.heps_hep_connector.addr_detail is '详细地址';
comment on column ${iol_schema}.heps_hep_connector.educational_highest is '最高学历';
comment on column ${iol_schema}.heps_hep_connector.connector_nature_rel is '联系人户籍性质';
comment on column ${iol_schema}.heps_hep_connector.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_connector.etl_timestamp is 'ETL处理时间戳';
