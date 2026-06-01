/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_delay_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_delay_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_delay_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_delay_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,arrival_status varchar2(1) -- 到账状态
    ,cash_item varchar2(10) -- 现金项目
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,commission_client_tel varchar2(20) -- 代办/代理人电话
    ,company varchar2(20) -- 法人
    ,exchange_tran_code varchar2(10) -- 收入方交易编码
    ,exchange_tran_codet varchar2(10) -- 支出方交易编码
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,pay_unit varchar2(200) -- 交款单位
    ,prefix varchar2(10) -- 前缀
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,settle_card_flag varchar2(1) -- 单位结算卡转账标识
    ,source_type varchar2(6) -- 渠道编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,track2 varchar2(200) -- 卡二磁道
    ,track3 varchar2(200) -- 卡三磁道
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_note varchar2(1000) -- 交易附言
    ,sign_timestamp varchar2(26) -- 延迟到账发起交易时间戳
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cancel_reason varchar2(200) -- 撤销原因
    ,commission_client_name varchar2(200) -- 代办人名称
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_card_no varchar2(50) -- 对手卡号
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_method varchar2(2) -- 到账方式
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
grant select on ${iol_schema}.ncbs_rb_delay_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_delay_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_delay_tran_hist is '24小时转账流水表';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.arrival_status is '到账状态';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.commission_client_tel is '代办/代理人电话';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.exchange_tran_code is '收入方交易编码';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.exchange_tran_codet is '支出方交易编码';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.pay_unit is '交款单位';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.settle_card_flag is '单位结算卡转账标识';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.track2 is '卡二磁道';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.track3 is '卡三磁道';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.sign_timestamp is '延迟到账发起交易时间戳';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.cancel_reason is '撤销原因';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.commission_client_name is '代办人名称';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_card_no is '对手卡号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.tran_method is '到账方式';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_delay_tran_hist.etl_timestamp is 'ETL处理时间戳';
