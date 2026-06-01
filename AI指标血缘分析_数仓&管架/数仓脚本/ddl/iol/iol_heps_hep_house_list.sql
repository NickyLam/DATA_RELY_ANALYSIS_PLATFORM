/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_house_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_house_list
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_house_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_house_list(
    flow_id varchar2(50) -- 业务id
    ,property_prove varchar2(32) -- 权属证明
    ,prove_no varchar2(900) -- 证明编号
    ,durable_years varchar2(10) -- 使用年限
    ,house_usage varchar2(32) -- 房屋用途
    ,house_use varchar2(64) -- 房屋用途
    ,id number(22) -- id
    ,guaranty_name varchar2(256) -- 权属人名称
    ,guarantyid_no varchar2(128) -- 权属人身份证号
    ,guaranty_ownshare number(16,9) -- 权属人共有份额
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
grant select on ${iol_schema}.heps_hep_house_list to ${iml_schema};
grant select on ${iol_schema}.heps_hep_house_list to ${icl_schema};
grant select on ${iol_schema}.heps_hep_house_list to ${idl_schema};
grant select on ${iol_schema}.heps_hep_house_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_house_list is '房屋信息产权信息表';
comment on column ${iol_schema}.heps_hep_house_list.flow_id is '业务id';
comment on column ${iol_schema}.heps_hep_house_list.property_prove is '权属证明';
comment on column ${iol_schema}.heps_hep_house_list.prove_no is '证明编号';
comment on column ${iol_schema}.heps_hep_house_list.durable_years is '使用年限';
comment on column ${iol_schema}.heps_hep_house_list.house_usage is '房屋用途';
comment on column ${iol_schema}.heps_hep_house_list.house_use is '房屋用途';
comment on column ${iol_schema}.heps_hep_house_list.id is 'id';
comment on column ${iol_schema}.heps_hep_house_list.guaranty_name is '权属人名称';
comment on column ${iol_schema}.heps_hep_house_list.guarantyid_no is '权属人身份证号';
comment on column ${iol_schema}.heps_hep_house_list.guaranty_ownshare is '权属人共有份额';
comment on column ${iol_schema}.heps_hep_house_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_house_list.etl_timestamp is 'ETL处理时间戳';
