/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_short varchar2(150) -- 客户简称
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_class varchar2(10) -- 协议分类
    ,agreement_close_acct_flag varchar2(1) -- 签约后是否允许销户
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_key varchar2(30) -- 协议键值
    ,agreement_key_type varchar2(2) -- 协议键类型
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,out_sign_channel varchar2(20) -- 解约渠道
    ,sign_channel varchar2(20) -- 签约渠道
    ,agreement_open_date date -- 协议签订日期
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,out_sign_date date -- 解约日期
    ,sign_date date -- 签约日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,agre_prod_type varchar2(12) -- 签约主产品类型
    ,agreement_amt number(17,2) -- 协议金额
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,opposite_internal_key number(15) -- 签约对方账户内部键
    ,out_sign_branch varchar2(12) -- 解约机构
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,sign_branch varchar2(12) -- 签约机构
    ,sign_user_id varchar2(8) -- 签约柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,is_auto_sign varchar2(1) -- 
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
grant select on ${iol_schema}.ncbs_rb_agreement to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement is '合同/协议信息表';
comment on column ${iol_schema}.ncbs_rb_agreement.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_agreement.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement.client_short is '客户简称';
comment on column ${iol_schema}.ncbs_rb_agreement.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_class is '协议分类';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_close_acct_flag is '签约后是否允许销户';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_key is '协议键值';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_key_type is '协议键类型';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement.out_sign_channel is '解约渠道';
comment on column ${iol_schema}.ncbs_rb_agreement.sign_channel is '签约渠道';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_open_date is '协议签订日期';
comment on column ${iol_schema}.ncbs_rb_agreement.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_agreement.out_sign_date is '解约日期';
comment on column ${iol_schema}.ncbs_rb_agreement.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_rb_agreement.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement.agre_prod_type is '签约主产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement.agreement_amt is '协议金额';
comment on column ${iol_schema}.ncbs_rb_agreement.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_agreement.opposite_internal_key is '签约对方账户内部键';
comment on column ${iol_schema}.ncbs_rb_agreement.out_sign_branch is '解约机构';
comment on column ${iol_schema}.ncbs_rb_agreement.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement.sign_branch is '签约机构';
comment on column ${iol_schema}.ncbs_rb_agreement.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_agreement.is_auto_sign is '';
comment on column ${iol_schema}.ncbs_rb_agreement.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement.etl_timestamp is 'ETL处理时间戳';
