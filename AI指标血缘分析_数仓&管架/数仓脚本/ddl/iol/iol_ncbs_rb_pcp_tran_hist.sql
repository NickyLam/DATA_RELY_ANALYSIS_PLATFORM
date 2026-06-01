/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_status varchar2(1) -- 冲补抹标志
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,failure_reason varchar2(200) -- 失败原因
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,pcp_prod_type varchar2(12) -- 资金池产品类型
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,narrative varchar2(400) -- 摘要
    ,narrative_code varchar2(30) -- 摘要码
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
grant select on ${iol_schema}.ncbs_rb_pcp_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_tran_hist is '归集/下拨登记簿';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.pcp_prod_type is '资金池产品类型';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_pcp_tran_hist.etl_timestamp is 'ETL处理时间戳';
