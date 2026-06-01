/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_northbound
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_northbound
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_northbound purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_northbound(
    unsignapplyrevertdate date -- 解约申请撤销日期
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_type varchar2(5) -- 协议类型
    ,out_sign_date date -- 解约日期
    ,sign_date date -- 签约日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,out_sign_branch varchar2(12) -- 解约机构
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,sign_branch varchar2(12) -- 签约机构
    ,sign_user_id varchar2(8) -- 签约柜员
    ,northbound_status varchar2(10) -- 北向通签约状态
    ,unsignapplaydate date -- 解约申请日期
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
grant select on ${iol_schema}.ncbs_rb_agreement_northbound to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_northbound to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_northbound to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_northbound to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_northbound is '北向通签约协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.unsignapplyrevertdate is '解约申请撤销日期';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.out_sign_date is '解约日期';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.out_sign_branch is '解约机构';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.sign_branch is '签约机构';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.northbound_status is '北向通签约状态';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.unsignapplaydate is '解约申请日期';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_northbound.etl_timestamp is 'ETL处理时间戳';
