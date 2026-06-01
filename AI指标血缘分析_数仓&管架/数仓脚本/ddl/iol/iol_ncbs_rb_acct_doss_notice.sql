/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss_notice
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss_notice
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss_notice purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_notice(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,address varchar2(400) -- 地址
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,branch varchar2(12) -- 机构编号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,contact_tel varchar2(20) -- 客户联系电话
    ,linkman varchar2(200) -- 对账联系人
    ,notice_date date -- 通知日期
    ,seq_no varchar2(50) -- 序号
    ,dormant_date date -- 转不动户日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,msg_notice_type varchar2(2) -- 通知类型
    ,notice_status varchar2(1) -- 通知状态
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
grant select on ${iol_schema}.ncbs_rb_acct_doss_notice to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_notice to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_notice to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_notice to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss_notice is '久悬未取款通知登记表';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.address is '地址';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.branch is '机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.linkman is '对账联系人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.notice_date is '通知日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.dormant_date is '转不动户日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.msg_notice_type is '通知类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.notice_status is '通知状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_notice.etl_timestamp is 'ETL处理时间戳';
