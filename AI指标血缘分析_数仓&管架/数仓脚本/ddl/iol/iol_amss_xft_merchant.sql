/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_xft_merchant
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_xft_merchant
whenever sqlerror continue none;
drop table ${iol_schema}.amss_xft_merchant purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_xft_merchant(
    merchant_id varchar2(32) -- 商户编号（主键）
    ,merchant_name varchar2(450) -- 商户名称
    ,merchant_short_name varchar2(128) -- 商户简称
    ,account_code varchar2(64) -- 清分账户
    ,account_name varchar2(128) -- 清分账户名
    ,account_bank varchar2(128) -- 清算账户开户行（总行名称）
    ,account_bank_name varchar2(128) -- 清算账户开户行名（分行/支行）
    ,account_type number(4,0) -- 清算账户类型-默认：3-内部户
    ,channel_id varchar2(32) -- 机构编号（对应渠道ChannelId）
    ,channel_name varchar2(128) -- 机构名称
    ,examine_status number(4,0) -- 审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)
    ,check_flag number(1,0) -- 是否校验 (0-不校验, 1-校验)
    ,merchant_status number(1,0) -- 商户状态 (0-禁用, 1-启用)
    ,clear_mode number(1,0) -- 清算模式 (1-自动清算, 2-客户发起清算)
    ,deposit_account varchar2(64) -- 入账账户
    ,deposit_account_name varchar2(128) -- 入账户名
    ,rate_max number(15,2) -- 入账金额比例上限
    ,rate_min number(15,2) -- 入账金额比例下限
    ,amt_max number(15,2) -- 入账金额上限
    ,amt_min number(15,2) -- 入账金额下限
    ,ftp_host varchar2(64) -- 商户FTP-IP
    ,ftp_port varchar2(8) -- 商户FTP-端口
    ,ftp_user varchar2(64) -- 商户FTP-用户名
    ,ftp_password varchar2(64) -- 商户FTP-密码
    ,ftp_local varchar2(256) -- 商户FTP-本地上传路径
    ,ftp_remote varchar2(256) -- 商户FTP-远程路径
    ,ftp_remote_ret varchar2(256) -- 商户FTP-回盘文件路径
    ,create_emp varchar2(32) -- 创建人
    ,create_time timestamp -- 创建时间
    ,update_emp varchar2(32) -- 更新人
    ,update_time timestamp -- 更新时间
    ,fld_s1 varchar2(128) -- 字符型保留字段1
    ,fld_s2 varchar2(128) -- 字符型保留字段2
    ,fld_s3 varchar2(128) -- 字符型保留字段3
    ,fld_n1 number(15,0) -- 数值型保留字段1
    ,fld_n2 number(15,0) -- 数值型保留字段2
    ,fld_n3 number(15,0) -- 数值型保留字段3
    ,audit_emp varchar2(32) -- 审核人
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
grant select on ${iol_schema}.amss_xft_merchant to ${iml_schema};
grant select on ${iol_schema}.amss_xft_merchant to ${icl_schema};
grant select on ${iol_schema}.amss_xft_merchant to ${idl_schema};
grant select on ${iol_schema}.amss_xft_merchant to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_xft_merchant is '兴付通商户表';
comment on column ${iol_schema}.amss_xft_merchant.merchant_id is '商户编号（主键）';
comment on column ${iol_schema}.amss_xft_merchant.merchant_name is '商户名称';
comment on column ${iol_schema}.amss_xft_merchant.merchant_short_name is '商户简称';
comment on column ${iol_schema}.amss_xft_merchant.account_code is '清分账户';
comment on column ${iol_schema}.amss_xft_merchant.account_name is '清分账户名';
comment on column ${iol_schema}.amss_xft_merchant.account_bank is '清算账户开户行（总行名称）';
comment on column ${iol_schema}.amss_xft_merchant.account_bank_name is '清算账户开户行名（分行/支行）';
comment on column ${iol_schema}.amss_xft_merchant.account_type is '清算账户类型-默认：3-内部户';
comment on column ${iol_schema}.amss_xft_merchant.channel_id is '机构编号（对应渠道ChannelId）';
comment on column ${iol_schema}.amss_xft_merchant.channel_name is '机构名称';
comment on column ${iol_schema}.amss_xft_merchant.examine_status is '审核状态 (0:未审核 1:审核通过 2:审核不通过 3:需再次审核)';
comment on column ${iol_schema}.amss_xft_merchant.check_flag is '是否校验 (0-不校验, 1-校验)';
comment on column ${iol_schema}.amss_xft_merchant.merchant_status is '商户状态 (0-禁用, 1-启用)';
comment on column ${iol_schema}.amss_xft_merchant.clear_mode is '清算模式 (1-自动清算, 2-客户发起清算)';
comment on column ${iol_schema}.amss_xft_merchant.deposit_account is '入账账户';
comment on column ${iol_schema}.amss_xft_merchant.deposit_account_name is '入账户名';
comment on column ${iol_schema}.amss_xft_merchant.rate_max is '入账金额比例上限';
comment on column ${iol_schema}.amss_xft_merchant.rate_min is '入账金额比例下限';
comment on column ${iol_schema}.amss_xft_merchant.amt_max is '入账金额上限';
comment on column ${iol_schema}.amss_xft_merchant.amt_min is '入账金额下限';
comment on column ${iol_schema}.amss_xft_merchant.ftp_host is '商户FTP-IP';
comment on column ${iol_schema}.amss_xft_merchant.ftp_port is '商户FTP-端口';
comment on column ${iol_schema}.amss_xft_merchant.ftp_user is '商户FTP-用户名';
comment on column ${iol_schema}.amss_xft_merchant.ftp_password is '商户FTP-密码';
comment on column ${iol_schema}.amss_xft_merchant.ftp_local is '商户FTP-本地上传路径';
comment on column ${iol_schema}.amss_xft_merchant.ftp_remote is '商户FTP-远程路径';
comment on column ${iol_schema}.amss_xft_merchant.ftp_remote_ret is '商户FTP-回盘文件路径';
comment on column ${iol_schema}.amss_xft_merchant.create_emp is '创建人';
comment on column ${iol_schema}.amss_xft_merchant.create_time is '创建时间';
comment on column ${iol_schema}.amss_xft_merchant.update_emp is '更新人';
comment on column ${iol_schema}.amss_xft_merchant.update_time is '更新时间';
comment on column ${iol_schema}.amss_xft_merchant.fld_s1 is '字符型保留字段1';
comment on column ${iol_schema}.amss_xft_merchant.fld_s2 is '字符型保留字段2';
comment on column ${iol_schema}.amss_xft_merchant.fld_s3 is '字符型保留字段3';
comment on column ${iol_schema}.amss_xft_merchant.fld_n1 is '数值型保留字段1';
comment on column ${iol_schema}.amss_xft_merchant.fld_n2 is '数值型保留字段2';
comment on column ${iol_schema}.amss_xft_merchant.fld_n3 is '数值型保留字段3';
comment on column ${iol_schema}.amss_xft_merchant.audit_emp is '审核人';
comment on column ${iol_schema}.amss_xft_merchant.start_dt is '开始时间';
comment on column ${iol_schema}.amss_xft_merchant.end_dt is '结束时间';
comment on column ${iol_schema}.amss_xft_merchant.id_mark is '增删标志';
comment on column ${iol_schema}.amss_xft_merchant.etl_timestamp is 'ETL处理时间戳';
