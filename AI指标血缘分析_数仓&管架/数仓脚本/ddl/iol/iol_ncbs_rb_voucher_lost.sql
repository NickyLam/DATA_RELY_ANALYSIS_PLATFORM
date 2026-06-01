/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_lost
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_lost
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_lost purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_lost(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,deal_result varchar2(200) -- 处理结果
    ,lost_key varchar2(50) -- 挂失标识符
    ,lost_no varchar2(50) -- 挂失编号
    ,lost_type varchar2(3) -- 挂失类型
    ,prefix varchar2(10) -- 前缀
    ,pwd_flag varchar2(1) -- 是否忘记密码标志
    ,relieve_loss_type varchar2(1) -- 解挂类型
    ,res_flag varchar2(1) -- 冻结标志
    ,source_type varchar2(6) -- 渠道编号
    ,start_seq_no varchar2(50) -- 冻结开始的序号
    ,voucher_lost_status varchar2(3) -- 凭证挂失状态
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,unlost_date date -- 解挂日期
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,reported_lost_reason varchar2(200) -- 挂失解挂原因
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,unchain_auth_user_id varchar2(8) -- 解挂授权柜员
    ,unchain_branch varchar2(12) -- 解挂机构
    ,unlost_user_id varchar2(8) -- 解挂柜员
    ,auto_unblock_date date -- 支票自动解挂日期
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
grant select on ${iol_schema}.ncbs_rb_voucher_lost to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_lost to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_lost is '凭证挂失登记簿';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.deal_result is '处理结果';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.lost_key is '挂失标识符';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.lost_no is '挂失编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.lost_type is '挂失类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.pwd_flag is '是否忘记密码标志';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.relieve_loss_type is '解挂类型';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.res_flag is '冻结标志';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.start_seq_no is '冻结开始的序号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.voucher_lost_status is '凭证挂失状态';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.unlost_date is '解挂日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.reported_lost_reason is '挂失解挂原因';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.unchain_auth_user_id is '解挂授权柜员';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.unchain_branch is '解挂机构';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.unlost_user_id is '解挂柜员';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.auto_unblock_date is '支票自动解挂日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_lost.etl_timestamp is 'ETL处理时间戳';
