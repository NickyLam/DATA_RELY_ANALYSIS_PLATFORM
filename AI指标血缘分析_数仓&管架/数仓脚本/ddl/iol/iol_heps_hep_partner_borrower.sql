/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_partner_borrower
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_partner_borrower
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_partner_borrower purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_partner_borrower(
    borrower_id number(12) -- 共同借款人id
    ,flow_id varchar2(50) -- 业务流水号
    ,borrower_name varchar2(64) -- 共同借款人姓名
    ,borrower_certificate_type varchar2(12) -- 证件类型
    ,idcard_no varchar2(20) -- 身份证号码
    ,borrower_mobile varchar2(20) -- 共同借款人手机号码
    ,borrower_relation varchar2(10) -- 与主借人关系
    ,detail_address varchar2(200) -- 详细居住地址
    ,marital_status varchar2(10) -- 婚姻状况
    ,spouse_certificate_type varchar2(10) -- 配偶证件类型
    ,spouse_name varchar2(64) -- 配偶姓名
    ,spouse_idcard_no varchar2(20) -- 配偶身份证号码
    ,spouse_mobile varchar2(11) -- 配偶手机号码
    ,child_certificate_type varchar2(12) -- 子女证件类型
    ,child_name varchar2(64) -- 子女姓名
    ,child_idcard_no varchar2(20) -- 子女身份证
    ,child_mobile varchar2(20) -- 子女手机
    ,status varchar2(16) -- 状态
    ,input_time date -- 录入时间
    ,lastupdate_time date -- 最后更新时间
    ,nature_category_rel varchar2(10) -- 关联人户籍性质
    ,rel_family_addr varchar2(384) -- 关联人居住地址
    ,edu_experience varchar2(10) -- 最高学历
    ,partner_agree varchar2(5) -- 本人授权勾选情况
    ,credit varchar2(5) -- 征信授权
    ,marital_agree varchar2(5) -- 配偶授权勾选情况
    ,spouse_credit varchar2(5) -- 配偶征信授权
    ,is_farmer varchar2(2) -- 是否农户
    ,work_nature varchar2(1) -- 关联人客户性质
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
grant select on ${iol_schema}.heps_hep_partner_borrower to ${iml_schema};
grant select on ${iol_schema}.heps_hep_partner_borrower to ${icl_schema};
grant select on ${iol_schema}.heps_hep_partner_borrower to ${idl_schema};
grant select on ${iol_schema}.heps_hep_partner_borrower to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_partner_borrower is '共同借款人信息表';
comment on column ${iol_schema}.heps_hep_partner_borrower.borrower_id is '共同借款人id';
comment on column ${iol_schema}.heps_hep_partner_borrower.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_partner_borrower.borrower_name is '共同借款人姓名';
comment on column ${iol_schema}.heps_hep_partner_borrower.borrower_certificate_type is '证件类型';
comment on column ${iol_schema}.heps_hep_partner_borrower.idcard_no is '身份证号码';
comment on column ${iol_schema}.heps_hep_partner_borrower.borrower_mobile is '共同借款人手机号码';
comment on column ${iol_schema}.heps_hep_partner_borrower.borrower_relation is '与主借人关系';
comment on column ${iol_schema}.heps_hep_partner_borrower.detail_address is '详细居住地址';
comment on column ${iol_schema}.heps_hep_partner_borrower.marital_status is '婚姻状况';
comment on column ${iol_schema}.heps_hep_partner_borrower.spouse_certificate_type is '配偶证件类型';
comment on column ${iol_schema}.heps_hep_partner_borrower.spouse_name is '配偶姓名';
comment on column ${iol_schema}.heps_hep_partner_borrower.spouse_idcard_no is '配偶身份证号码';
comment on column ${iol_schema}.heps_hep_partner_borrower.spouse_mobile is '配偶手机号码';
comment on column ${iol_schema}.heps_hep_partner_borrower.child_certificate_type is '子女证件类型';
comment on column ${iol_schema}.heps_hep_partner_borrower.child_name is '子女姓名';
comment on column ${iol_schema}.heps_hep_partner_borrower.child_idcard_no is '子女身份证';
comment on column ${iol_schema}.heps_hep_partner_borrower.child_mobile is '子女手机';
comment on column ${iol_schema}.heps_hep_partner_borrower.status is '状态';
comment on column ${iol_schema}.heps_hep_partner_borrower.input_time is '录入时间';
comment on column ${iol_schema}.heps_hep_partner_borrower.lastupdate_time is '最后更新时间';
comment on column ${iol_schema}.heps_hep_partner_borrower.nature_category_rel is '关联人户籍性质';
comment on column ${iol_schema}.heps_hep_partner_borrower.rel_family_addr is '关联人居住地址';
comment on column ${iol_schema}.heps_hep_partner_borrower.edu_experience is '最高学历';
comment on column ${iol_schema}.heps_hep_partner_borrower.partner_agree is '本人授权勾选情况';
comment on column ${iol_schema}.heps_hep_partner_borrower.credit is '征信授权';
comment on column ${iol_schema}.heps_hep_partner_borrower.marital_agree is '配偶授权勾选情况';
comment on column ${iol_schema}.heps_hep_partner_borrower.spouse_credit is '配偶征信授权';
comment on column ${iol_schema}.heps_hep_partner_borrower.is_farmer is '是否农户';
comment on column ${iol_schema}.heps_hep_partner_borrower.work_nature is '关联人客户性质';
comment on column ${iol_schema}.heps_hep_partner_borrower.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_partner_borrower.etl_timestamp is 'ETL处理时间戳';
