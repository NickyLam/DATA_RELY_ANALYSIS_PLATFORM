/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_partner_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_partner_info
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_partner_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_partner_info(
    partner_id number(20) -- 共有人id
    ,flow_id varchar2(50) -- 业务流水号
    ,idcart_no varchar2(20) -- 身份证号码
    ,partner_name varchar2(64) -- 共有人姓名
    ,partner_mobile varchar2(20) -- 手机号码
    ,borrower_relation varchar2(10) -- 与借款人关系
    ,detail_address varchar2(384) -- 详细居住地址
    ,marital_status varchar2(20) -- 婚姻状况
    ,spouse_name varchar2(64) -- 配偶姓名
    ,spouse_idcard_no varchar2(20) -- 配偶身份证
    ,spouse_mobile varchar2(20) -- 配偶手机号码
    ,child_name varchar2(64) -- 子女姓名
    ,child_idcard_no varchar2(20) -- 子女身份证
    ,child_mobile varchar2(20) -- 子女手机
    ,status varchar2(16) -- 状态
    ,input_time date -- 录入时间
    ,lastupdate_time date -- 最后更新时间
    ,partner_certificate_type varchar2(12) -- 共有人证件类型
    ,spouse_certificate_type varchar2(12) -- 配偶证件类型
    ,child_certificate_type varchar2(12) -- 子女证件类型
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
grant select on ${iol_schema}.heps_hep_partner_info to ${iml_schema};
grant select on ${iol_schema}.heps_hep_partner_info to ${icl_schema};
grant select on ${iol_schema}.heps_hep_partner_info to ${idl_schema};
grant select on ${iol_schema}.heps_hep_partner_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_partner_info is '共有人信息';
comment on column ${iol_schema}.heps_hep_partner_info.partner_id is '共有人id';
comment on column ${iol_schema}.heps_hep_partner_info.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_partner_info.idcart_no is '身份证号码';
comment on column ${iol_schema}.heps_hep_partner_info.partner_name is '共有人姓名';
comment on column ${iol_schema}.heps_hep_partner_info.partner_mobile is '手机号码';
comment on column ${iol_schema}.heps_hep_partner_info.borrower_relation is '与借款人关系';
comment on column ${iol_schema}.heps_hep_partner_info.detail_address is '详细居住地址';
comment on column ${iol_schema}.heps_hep_partner_info.marital_status is '婚姻状况';
comment on column ${iol_schema}.heps_hep_partner_info.spouse_name is '配偶姓名';
comment on column ${iol_schema}.heps_hep_partner_info.spouse_idcard_no is '配偶身份证';
comment on column ${iol_schema}.heps_hep_partner_info.spouse_mobile is '配偶手机号码';
comment on column ${iol_schema}.heps_hep_partner_info.child_name is '子女姓名';
comment on column ${iol_schema}.heps_hep_partner_info.child_idcard_no is '子女身份证';
comment on column ${iol_schema}.heps_hep_partner_info.child_mobile is '子女手机';
comment on column ${iol_schema}.heps_hep_partner_info.status is '状态';
comment on column ${iol_schema}.heps_hep_partner_info.input_time is '录入时间';
comment on column ${iol_schema}.heps_hep_partner_info.lastupdate_time is '最后更新时间';
comment on column ${iol_schema}.heps_hep_partner_info.partner_certificate_type is '共有人证件类型';
comment on column ${iol_schema}.heps_hep_partner_info.spouse_certificate_type is '配偶证件类型';
comment on column ${iol_schema}.heps_hep_partner_info.child_certificate_type is '子女证件类型';
comment on column ${iol_schema}.heps_hep_partner_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_partner_info.etl_timestamp is 'ETL处理时间戳';
