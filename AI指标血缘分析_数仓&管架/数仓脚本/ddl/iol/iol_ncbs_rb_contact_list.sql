/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_contact_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_contact_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_contact_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_contact_list(
    client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,contact_status varchar2(1) -- 联系人状态
    ,contact_type varchar2(20) -- 联系类型	
    ,linkman_desc varchar2(50) -- 联系人类型描述
    ,linkman_type varchar2(2) -- 联系人类型
    ,phone_no1 varchar2(20) -- 电话号码1
    ,phone_no2 varchar2(20) -- 联系人电话2
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,linkman_name varchar2(200) -- 联系人名称
    ,check_certificate_order varchar2(1) -- 查证人顺序
    ,contact_class varchar2(1) -- 联系人分类
    ,check_certificate_flag varchar2(1) -- 是否为指定资金查证人
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
grant select on ${iol_schema}.ncbs_rb_contact_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_contact_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_contact_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_contact_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_contact_list is '账户联系人信息表';
comment on column ${iol_schema}.ncbs_rb_contact_list.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_contact_list.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_contact_list.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_contact_list.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_contact_list.company is '法人';
comment on column ${iol_schema}.ncbs_rb_contact_list.contact_status is '联系人状态';
comment on column ${iol_schema}.ncbs_rb_contact_list.contact_type is '联系类型	';
comment on column ${iol_schema}.ncbs_rb_contact_list.linkman_desc is '联系人类型描述';
comment on column ${iol_schema}.ncbs_rb_contact_list.linkman_type is '联系人类型';
comment on column ${iol_schema}.ncbs_rb_contact_list.phone_no1 is '电话号码1';
comment on column ${iol_schema}.ncbs_rb_contact_list.phone_no2 is '联系人电话2';
comment on column ${iol_schema}.ncbs_rb_contact_list.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_contact_list.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_contact_list.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_contact_list.linkman_name is '联系人名称';
comment on column ${iol_schema}.ncbs_rb_contact_list.check_certificate_order is '查证人顺序';
comment on column ${iol_schema}.ncbs_rb_contact_list.contact_class is '联系人分类';
comment on column ${iol_schema}.ncbs_rb_contact_list.check_certificate_flag is '是否为指定资金查证人';
comment on column ${iol_schema}.ncbs_rb_contact_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_contact_list.etl_timestamp is 'ETL处理时间戳';
