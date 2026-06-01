/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_account_equity_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_account_equity_list
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_account_equity_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_equity_list(
    id number(22,0) -- 主键id
    ,trade_date varchar2(12) -- 交易日期
    ,trade_time varchar2(24) -- 交易时间
    ,branch_no varchar2(18) -- 分行号
    ,branch_no_name varchar2(150) -- 分行名称
    ,org_no varchar2(18) -- 机构号
    ,org_no_name varchar2(150) -- 机构名称
    ,pty_id varchar2(75) -- 客户号
    ,pty_name varchar2(300) -- 客户名称
    ,equity_count number(22,0) -- 权益积分变化(数值为正负，区分消费，增加)
    ,equity_count_useble number(22,0) -- 剩余可用权益积分
    ,trade_channel varchar2(5) -- 交易渠道(系统字母简称)
    ,trade_type varchar2(3) -- 交易类型(1-消费：客户兑换权益积分产生的扣减项2-配赠：系统按配赠权益积分，自动生成的增加项3-到期：积分有效期到期，系统自动扣除到期积分的扣减项4-手工调整：由于其他情况，电话银行需手工进行调整权益的增加/扣减项)
    ,remark varchar2(768) -- 摘要
    ,attachment_path varchar2(1200) -- 附件路径
    ,attachment varchar2(1200) -- 附件名称
    ,last_ope_time varchar2(21) -- 最后操作时间
    ,final_oper_pers varchar2(48) -- 最后操作人
    ,memo_info varchar2(3000) -- 备注
    ,glob_seq_num varchar2(150) -- 全局流水号
    ,mail_sbj varchar2(600) -- 邮件主题
    ,mail_cntt varchar2(3000) -- 邮件内容
    ,mailbox_addr varchar2(300) -- 邮件地址
    ,mail_flag varchar2(2) -- 邮件发送标示0未发送1发送中2已发送3不需要发送邮件
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
grant select on ${iol_schema}.cpms_t_account_equity_list to ${iml_schema};
grant select on ${iol_schema}.cpms_t_account_equity_list to ${icl_schema};
grant select on ${iol_schema}.cpms_t_account_equity_list to ${idl_schema};
grant select on ${iol_schema}.cpms_t_account_equity_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_account_equity_list is '客户权益积分明细表';
comment on column ${iol_schema}.cpms_t_account_equity_list.id is '主键id';
comment on column ${iol_schema}.cpms_t_account_equity_list.trade_date is '交易日期';
comment on column ${iol_schema}.cpms_t_account_equity_list.trade_time is '交易时间';
comment on column ${iol_schema}.cpms_t_account_equity_list.branch_no is '分行号';
comment on column ${iol_schema}.cpms_t_account_equity_list.branch_no_name is '分行名称';
comment on column ${iol_schema}.cpms_t_account_equity_list.org_no is '机构号';
comment on column ${iol_schema}.cpms_t_account_equity_list.org_no_name is '机构名称';
comment on column ${iol_schema}.cpms_t_account_equity_list.pty_id is '客户号';
comment on column ${iol_schema}.cpms_t_account_equity_list.pty_name is '客户名称';
comment on column ${iol_schema}.cpms_t_account_equity_list.equity_count is '权益积分变化(数值为正负，区分消费，增加)';
comment on column ${iol_schema}.cpms_t_account_equity_list.equity_count_useble is '剩余可用权益积分';
comment on column ${iol_schema}.cpms_t_account_equity_list.trade_channel is '交易渠道(系统字母简称)';
comment on column ${iol_schema}.cpms_t_account_equity_list.trade_type is '交易类型(1-消费：客户兑换权益积分产生的扣减项2-配赠：系统按配赠权益积分，自动生成的增加项3-到期：积分有效期到期，系统自动扣除到期积分的扣减项4-手工调整：由于其他情况，电话银行需手工进行调整权益的增加/扣减项)';
comment on column ${iol_schema}.cpms_t_account_equity_list.remark is '摘要';
comment on column ${iol_schema}.cpms_t_account_equity_list.attachment_path is '附件路径';
comment on column ${iol_schema}.cpms_t_account_equity_list.attachment is '附件名称';
comment on column ${iol_schema}.cpms_t_account_equity_list.last_ope_time is '最后操作时间';
comment on column ${iol_schema}.cpms_t_account_equity_list.final_oper_pers is '最后操作人';
comment on column ${iol_schema}.cpms_t_account_equity_list.memo_info is '备注';
comment on column ${iol_schema}.cpms_t_account_equity_list.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.cpms_t_account_equity_list.mail_sbj is '邮件主题';
comment on column ${iol_schema}.cpms_t_account_equity_list.mail_cntt is '邮件内容';
comment on column ${iol_schema}.cpms_t_account_equity_list.mailbox_addr is '邮件地址';
comment on column ${iol_schema}.cpms_t_account_equity_list.mail_flag is '邮件发送标示0未发送1发送中2已发送3不需要发送邮件';
comment on column ${iol_schema}.cpms_t_account_equity_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cpms_t_account_equity_list.etl_timestamp is 'ETL处理时间戳';
