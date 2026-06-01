/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_acct_ip_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_acct_ip_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_acct_ip_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_acct_ip_info(
    name varchar2(75) -- 姓名
    ,cert_no varchar2(45) -- 证件号码
    ,cust_id varchar2(15) -- 客户id
    ,acct_id varchar2(75) -- 合作行卡号
    ,ext_card_no varchar2(75) -- 微众银行卡号
    ,open_acct_ip varchar2(75) -- 开户ip
    ,permanent_ip varchar2(75) -- 常驻ip
    ,lbs_info varchar2(383) -- lbs信息
    ,check_ip_flag varchar2(15) -- 是否核对ip,0-未核对 1-已核对
    ,local_flag varchar2(15) -- 是否本地,0-否 1-是
    ,province varchar2(75) -- 省份
    ,city varchar2(75) -- 开户ip城市
    ,check_time varchar2(30) -- 核对时间
    ,reback_flag varchar2(15) -- 是否回撤,0-否 1-是
    ,reback_time varchar2(30) -- 回撤时间
    ,return_code varchar2(30) -- 回撤返回码
    ,return_result varchar2(383) -- 回撤返回结果
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
grant select on ${iol_schema}.ifcs_dep_acct_ip_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_acct_ip_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_acct_ip_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_acct_ip_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_acct_ip_info is '存款账户IP信息';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.name is '姓名';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.cert_no is '证件号码';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.cust_id is '客户id';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.acct_id is '合作行卡号';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.ext_card_no is '微众银行卡号';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.open_acct_ip is '开户ip';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.permanent_ip is '常驻ip';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.lbs_info is 'lbs信息';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.check_ip_flag is '是否核对ip,0-未核对 1-已核对';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.local_flag is '是否本地,0-否 1-是';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.province is '省份';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.city is '开户ip城市';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.check_time is '核对时间';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.reback_flag is '是否回撤,0-否 1-是';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.reback_time is '回撤时间';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.return_code is '回撤返回码';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.return_result is '回撤返回结果';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_dep_acct_ip_info.etl_timestamp is 'ETL处理时间戳';
