/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_case_acct_cur
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_case_acct_cur
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_case_acct_cur purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_case_acct_cur(
    modify_tm varchar2(29) -- 修改时间
    ,main_acct_id varchar2(96) -- 主账号
    ,open_dt date -- 开户日期
    ,acct_type varchar2(9) -- 账户类型
    ,open_tm varchar2(21) -- 开户时间
    ,oth_card_style varchar2(192) -- 其他银行卡类型
    ,cust_id varchar2(48) -- 客户编号
    ,create_tm varchar2(29) -- 创建时间
    ,org_id varchar2(24) -- 开户机构
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,close_tm varchar2(21) -- 销户时间
    ,bs_valid varchar2(2) -- 可疑验证（参见[字典:aml0042]）
    ,acct_id varchar2(96) -- 账户编号
    ,close_dt date -- 销户日期
    ,card_style varchar2(3) -- 银行卡类型 卡片类型（参见[字典:aml0031]）
    ,card_no varchar2(96) -- 银行卡号码
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,modifier varchar2(48) -- 修改人
    ,data_src varchar2(2) -- 数据来源（参见[字典:aml0045]）
    ,creator varchar2(48) -- 创建人
    ,rsrv_01 varchar2(48) -- 备用字段1
    ,rsrv_04 varchar2(96) -- 备用字段4
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
grant select on ${iol_schema}.amls_t2a_case_acct_cur to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_case_acct_cur to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_case_acct_cur to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_case_acct_cur to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_case_acct_cur is '案例当前账户信息表';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.main_acct_id is '主账号';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.open_dt is '开户日期';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.acct_type is '账户类型';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.open_tm is '开户时间';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.oth_card_style is '其他银行卡类型';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.org_id is '开户机构';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.close_tm is '销户时间';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.bs_valid is '可疑验证（参见[字典:aml0042]）';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.close_dt is '销户日期';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.card_style is '银行卡类型 卡片类型（参见[字典:aml0031]）';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.card_no is '银行卡号码';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.modifier is '修改人';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.data_src is '数据来源（参见[字典:aml0045]）';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.creator is '创建人';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.rsrv_01 is '备用字段1';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t2a_case_acct_cur.etl_timestamp is 'ETL处理时间戳';
