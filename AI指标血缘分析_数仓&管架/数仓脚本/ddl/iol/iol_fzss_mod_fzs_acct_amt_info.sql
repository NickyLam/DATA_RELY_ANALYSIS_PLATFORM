/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_acct_amt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_acct_amt_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_acct_amt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_acct_amt_info(
    data_date varchar2(8) -- 数据日期
    ,corp_id varchar2(10) -- 平台商户号
    ,sub_acct_no varchar2(40) -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：暂定开头8
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,sub_acct_nm varchar2(256) -- 子账户名称
    ,acct_cls varchar2(2) -- 子账号类别 [枚举: 01 -二级商户子账号、02-功能户]
    ,cust_type varchar2(1) -- 客户类型 [枚举: 1-对私,2-对公]
    ,acct_status varchar2(2) -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,balance number(20,2) -- 总余额 [枚举: 总余额]
    ,cash_amt number(20,2) -- 可提余额 [枚举: 清算后的余额]
    ,freeze_amt number(20,2) -- 冻结余额
    ,outstanding_amt number(20,2) -- 待清算余额
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
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
grant select on ${iol_schema}.fzss_mod_fzs_acct_amt_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_amt_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_amt_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_acct_amt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_acct_amt_info is '子账户余额信息表';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.data_date is '数据日期';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.sub_acct_no is '子账号 账号格式 对私：623627+01+序号+1位验证位 对公：暂定开头8';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.sub_acct_nm is '子账户名称';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.acct_cls is '子账号类别 [枚举: 01 -二级商户子账号、02-功能户]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.cust_type is '客户类型 [枚举: 1-对私,2-对公]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.acct_status is '账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.balance is '总余额 [枚举: 总余额]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.cash_amt is '可提余额 [枚举: 清算后的余额]';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.freeze_amt is '冻结余额';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.outstanding_amt is '待清算余额';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fzss_mod_fzs_acct_amt_info.etl_timestamp is 'ETL处理时间戳';
