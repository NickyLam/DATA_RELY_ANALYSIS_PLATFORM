/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_merchant_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_merchant_info
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_merchant_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_merchant_info(
    sign_no varchar2(60) -- 协议号
    ,payee_acct_no varchar2(32) -- 收款账号
    ,payee_acct_name varchar2(256) -- 申请企业名称
    ,intra_acct_no varchar2(32) -- 内部账户
    ,intra_acct_name varchar2(76) -- 内部账户户名
    ,branch_no varchar2(48) -- 商户归属机构
    ,business_scope varchar2(64) -- 经营范围
    ,legitimacy varchar2(12) -- 是否符合经营范围
    ,business_license varchar2(48) -- 营业执照号码
    ,active varchar2(14) -- 启用状态
    ,create_time date -- 创建时间
    ,update_time date -- 更新时间
    ,mer_type varchar2(32) -- 商户类别
    ,pty_num varchar2(32) -- 客户号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ppps_t_merchant_info to ${iml_schema};
grant select on ${iol_schema}.ppps_t_merchant_info to ${icl_schema};
grant select on ${iol_schema}.ppps_t_merchant_info to ${idl_schema};
grant select on ${iol_schema}.ppps_t_merchant_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_merchant_info is '商户表';
comment on column ${iol_schema}.ppps_t_merchant_info.sign_no is '协议号';
comment on column ${iol_schema}.ppps_t_merchant_info.payee_acct_no is '收款账号';
comment on column ${iol_schema}.ppps_t_merchant_info.payee_acct_name is '申请企业名称';
comment on column ${iol_schema}.ppps_t_merchant_info.intra_acct_no is '内部账户';
comment on column ${iol_schema}.ppps_t_merchant_info.intra_acct_name is '内部账户户名';
comment on column ${iol_schema}.ppps_t_merchant_info.branch_no is '商户归属机构';
comment on column ${iol_schema}.ppps_t_merchant_info.business_scope is '经营范围';
comment on column ${iol_schema}.ppps_t_merchant_info.legitimacy is '是否符合经营范围';
comment on column ${iol_schema}.ppps_t_merchant_info.business_license is '营业执照号码';
comment on column ${iol_schema}.ppps_t_merchant_info.active is '启用状态';
comment on column ${iol_schema}.ppps_t_merchant_info.create_time is '创建时间';
comment on column ${iol_schema}.ppps_t_merchant_info.update_time is '更新时间';
comment on column ${iol_schema}.ppps_t_merchant_info.mer_type is '商户类别';
comment on column ${iol_schema}.ppps_t_merchant_info.pty_num is '客户号';
comment on column ${iol_schema}.ppps_t_merchant_info.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_t_merchant_info.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_t_merchant_info.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_t_merchant_info.etl_timestamp is 'ETL处理时间戳';
