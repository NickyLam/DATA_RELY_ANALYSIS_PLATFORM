/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_cautioner
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_cautioner
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_cautioner purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_cautioner(
    cautioner_id number(12,0) -- 担保人id
    ,flow_id varchar2(50) -- 业务流水号
    ,cautioner_name varchar2(64) -- 担保人姓名
    ,mobile varchar2(20) -- 担保人手机号码
    ,borrower_relation varchar2(20) -- 担保人与主借人关系
    ,status varchar2(16) -- 状态
    ,input_time date -- 录入时间
    ,lastupdate_time date -- 最后更新时间
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
grant select on ${iol_schema}.heps_hep_cautioner to ${iml_schema};
grant select on ${iol_schema}.heps_hep_cautioner to ${icl_schema};
grant select on ${iol_schema}.heps_hep_cautioner to ${idl_schema};
grant select on ${iol_schema}.heps_hep_cautioner to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_cautioner is '担保人信息表';
comment on column ${iol_schema}.heps_hep_cautioner.cautioner_id is '担保人id';
comment on column ${iol_schema}.heps_hep_cautioner.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_cautioner.cautioner_name is '担保人姓名';
comment on column ${iol_schema}.heps_hep_cautioner.mobile is '担保人手机号码';
comment on column ${iol_schema}.heps_hep_cautioner.borrower_relation is '担保人与主借人关系';
comment on column ${iol_schema}.heps_hep_cautioner.status is '状态';
comment on column ${iol_schema}.heps_hep_cautioner.input_time is '录入时间';
comment on column ${iol_schema}.heps_hep_cautioner.lastupdate_time is '最后更新时间';
comment on column ${iol_schema}.heps_hep_cautioner.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_cautioner.etl_timestamp is 'ETL处理时间戳';
