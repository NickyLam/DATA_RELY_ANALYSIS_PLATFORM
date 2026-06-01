/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_flotation_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_flotation_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_flotation_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_flotation_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次表ID
    ,draft_id varchar2(60) -- 票据表ID
    ,quote_no varchar2(30) -- 报价单编号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 贴入 TDD02 贴出
    ,trade_brh_no varchar2(15) -- 贴现机构代码
    ,trade_user_id varchar2(15) -- 贴现交易员ID
    ,draft_number varchar2(45) -- 票据号码
    ,draft_amt number(18,2) -- 票据金额
    ,maturity_date varchar2(12) -- 票据到期日
    ,real_maturity_date varchar2(12) -- 票据实际到期日
    ,tenor_day number(8,0) -- 剩余期限
    ,pay_int number(18,2) -- 应付利息
    ,settle_amt number(18,2) -- 结算金额
    ,dscnt_entry_acct varchar2(48) -- 贴现申请人账号
    ,dscnt_entry_bank_no varchar2(18) -- 贴现申请人开户行行号
    ,drawer_name varchar2(270) -- 出票人名称
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行号
    ,flot_status varchar2(8) -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
    ,message_status varchar2(3) -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
    ,delist_time varchar2(12) -- 摘牌时间
    ,process_code varchar2(14) -- 处理码
    ,process_msg varchar2(768) -- 处理信息
    ,deal_id varchar2(60) -- 成交单表ID
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后操作时间
    ,misc varchar2(1500) -- 备注域
    ,sub_range varchar2(38) -- 子票据区间
    ,product_type varchar2(21) -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,standard_amount number(18,2) -- 标准金额
    ,settle_status varchar2(6) -- 结算状态： R20 结算成功 R21 结算失败
    ,dpc_draft_id varchar2(60) -- 登记中心票据ID
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
grant select on ${iol_schema}.bdms_cpes_flotation_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_flotation_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_flotation_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_flotation_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_flotation_details is '贴现通挂牌询价明细表';
comment on column ${iol_schema}.bdms_cpes_flotation_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_flotation_details.trade_direct is '交易方向： TDD01 贴入 TDD02 贴出';
comment on column ${iol_schema}.bdms_cpes_flotation_details.trade_brh_no is '贴现机构代码';
comment on column ${iol_schema}.bdms_cpes_flotation_details.trade_user_id is '贴现交易员ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_cpes_flotation_details.draft_amt is '票据金额';
comment on column ${iol_schema}.bdms_cpes_flotation_details.maturity_date is '票据到期日';
comment on column ${iol_schema}.bdms_cpes_flotation_details.real_maturity_date is '票据实际到期日';
comment on column ${iol_schema}.bdms_cpes_flotation_details.tenor_day is '剩余期限';
comment on column ${iol_schema}.bdms_cpes_flotation_details.pay_int is '应付利息';
comment on column ${iol_schema}.bdms_cpes_flotation_details.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_flotation_details.dscnt_entry_acct is '贴现申请人账号';
comment on column ${iol_schema}.bdms_cpes_flotation_details.dscnt_entry_bank_no is '贴现申请人开户行行号';
comment on column ${iol_schema}.bdms_cpes_flotation_details.drawer_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpes_flotation_details.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpes_flotation_details.acceptor_bank_no is '承兑人开户行号';
comment on column ${iol_schema}.bdms_cpes_flotation_details.flot_status is '挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认';
comment on column ${iol_schema}.bdms_cpes_flotation_details.message_status is '报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败';
comment on column ${iol_schema}.bdms_cpes_flotation_details.delist_time is '摘牌时间';
comment on column ${iol_schema}.bdms_cpes_flotation_details.process_code is '处理码';
comment on column ${iol_schema}.bdms_cpes_flotation_details.process_msg is '处理信息';
comment on column ${iol_schema}.bdms_cpes_flotation_details.deal_id is '成交单表ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_flotation_details.last_upd_time is '最后操作时间';
comment on column ${iol_schema}.bdms_cpes_flotation_details.misc is '备注域';
comment on column ${iol_schema}.bdms_cpes_flotation_details.sub_range is '子票据区间';
comment on column ${iol_schema}.bdms_cpes_flotation_details.product_type is '分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据';
comment on column ${iol_schema}.bdms_cpes_flotation_details.standard_amount is '标准金额';
comment on column ${iol_schema}.bdms_cpes_flotation_details.settle_status is '结算状态： R20 结算成功 R21 结算失败';
comment on column ${iol_schema}.bdms_cpes_flotation_details.dpc_draft_id is '登记中心票据ID';
comment on column ${iol_schema}.bdms_cpes_flotation_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_flotation_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_flotation_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_flotation_details.etl_timestamp is 'ETL处理时间戳';
