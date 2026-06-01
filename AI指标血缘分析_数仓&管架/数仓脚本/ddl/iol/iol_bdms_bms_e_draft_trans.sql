/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_e_draft_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_e_draft_trans
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_e_draft_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_e_draft_trans(
    id varchar2(60) -- ID
    ,edraft_id varchar2(60) -- 票据ID
    ,last_trans_id varchar2(60) -- 上手交易id
    ,trans_no varchar2(15) -- 交易编号
    ,trans_name varchar2(225) -- 交易状态
    ,status varchar2(15) -- 票据状态
    ,msg_type varchar2(3) -- 信息类型： 01 出票登记 02 承兑 03 收票 04 撤票 05 背书 06 贴现 07 贴现赎回 08 转贴现 09 转贴现赎回 10 再贴现 11 再贴现赎回 12 背书保证 13 承兑人保证 14 出票人保证 15 质押 16 质押解除 17 提示付款 18 逾期提示付款 19 追索通知 20 清偿确认 21 追索清偿签收通知 22 网银端照票申请查询
    ,electric_draft_id varchar2(45) -- 电子票据号码
    ,req_type varchar2(6) -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,req_name varchar2(525) -- 请求方名称REQ_NAME
    ,req_brch_code varchar2(30) -- 请求方组织机构代码
    ,req_account varchar2(48) -- 请求方账号
    ,req_bank_id varchar2(18) -- 请求方开户行行号
    ,rcv_type varchar2(6) -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,rcv_name varchar2(270) -- 接收方名称
    ,rcv_brch_code varchar2(30) -- 接收方组织机构代码
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_bank_id varchar2(18) -- 接收方开户行行号
    ,sign_date varchar2(12) -- 签收日期
    ,onl_stlm_flag varchar2(6) -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,transfer_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,rate number(9,6) -- 利率
    ,repurchase_rate number(9,6) -- 赎回利率
    ,amount number(18,2) -- 金额
    ,repurchase_amt number(18,2) -- 赎回实付金额
    ,discount_type varchar2(6) -- 贴现种类： RM00 买断式 RM01 回购式
    ,repurchase_end_date varchar2(12) -- 赎回截止日
    ,repurchase_begin_date varchar2(12) -- 赎回开放日
    ,req_date varchar2(12) -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,prompt_pay_amt number(18,2) -- 提示付款金额
    ,reject_code varchar2(6) -- 拒付代码
    ,reject_info varchar2(1152) -- 拒付备注信息
    ,overdue_reason varchar2(1152) -- 逾期原因说明
    ,holder_type varchar2(6) -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,solutor_date varchar2(12) -- 清偿日期
    ,txn_ctrct_nb varchar2(135) -- 交易合同编号
    ,invoice_nb varchar2(135) -- 发票号码
    ,rcrs_rsn_cd varchar2(6) -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,btch_nb varchar2(135) -- 批次号
    ,sign_flag varchar2(6) -- 签收状态： 0 拒签 1 签收
    ,reply_flag varchar2(3) -- 回复标志： 0 否 1 是
    ,rec_crt_ts varchar2(21) -- 记录插入时间
    ,req_agency_bank_id varchar2(18) -- 请求方承接行行号
    ,rcv_agency_bank_id varchar2(18) -- 接收方承接行行号
    ,guarntr_adr varchar2(270) -- 保证人地址
    ,ucondl_consign_mk varchar2(6) -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,ucondl_prms_mk varchar2(6) -- 到期无条件支付承诺
    ,proxy_sign varchar2(6) -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,proxy_req varchar2(6) -- 代理申请标识： PP00 开户机构代理申请签章 PP01 票据当事人自己签章
    ,credit_rate varchar2(5) -- 信用等级
    ,credit_rate_agency varchar2(270) -- 评级机构
    ,credit_rate_due_date varchar2(12) -- 评级到期日
    ,req_remark varchar2(1152) -- 请求方备注
    ,rcv_remark varchar2(1152) -- 接收方备注
    ,aoa_account varchar2(48) -- 入账账号
    ,aoa_bank_id varchar2(18) -- 入账行号
    ,have_type varchar2(6) -- 持票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,have_brch_code varchar2(30) -- 持票人组织机构代码
    ,have_name varchar2(525) -- 持票人名称
    ,hava_account varchar2(48) -- 持票人账号
    ,hava_bank_id varchar2(18) -- 持票人开户行号
    ,seq_no varchar2(24) -- 支付交易序号
    ,is_lock varchar2(2) -- 是否锁定： 0 否 1 是
    ,return_code varchar2(30) -- 返回码
    ,return_msg varchar2(375) -- 返回信息
    ,is_inner varchar2(2) -- 是否系统内： 0 否 1 是
    ,lastbuy_trans_id varchar2(60) -- 上手买入交易ID
    ,last_upd_txn_oprid varchar2(45) -- 操作柜员
    ,details_id varchar2(60) -- 交易明细ID
    ,orgnl_msg_id varchar2(60) -- 原报文ID
    ,reserve1 varchar2(75) -- 备注
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
grant select on ${iol_schema}.bdms_bms_e_draft_trans to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_trans to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_trans to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_e_draft_trans is 'ECDS票据交易信息表';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.id is 'ID';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.edraft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.last_trans_id is '上手交易id';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.trans_no is '交易编号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.trans_name is '交易状态';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.status is '票据状态';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.msg_type is '信息类型： 01 出票登记 02 承兑 03 收票 04 撤票 05 背书 06 贴现 07 贴现赎回 08 转贴现 09 转贴现赎回 10 再贴现 11 再贴现赎回 12 背书保证 13 承兑人保证 14 出票人保证 15 质押 16 质押解除 17 提示付款 18 逾期提示付款 19 追索通知 20 清偿确认 21 追索清偿签收通知 22 网银端照票申请查询';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.electric_draft_id is '电子票据号码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_type is '请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_name is '请求方名称REQ_NAME';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_brch_code is '请求方组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_bank_id is '请求方开户行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_type is '接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_brch_code is '接收方组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_bank_id is '接收方开户行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.sign_date is '签收日期';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.onl_stlm_flag is '线上清算标记： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.transfer_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rate is '利率';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.amount is '金额';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.repurchase_amt is '赎回实付金额';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.discount_type is '贴现种类： RM00 买断式 RM01 回购式';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.repurchase_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.repurchase_begin_date is '赎回开放日';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_date is '申请日期、提示付款、逾期提示付款、追索通知日期';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.prompt_pay_amt is '提示付款金额';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.reject_code is '拒付代码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.reject_info is '拒付备注信息';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.overdue_reason is '逾期原因说明';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.holder_type is '追索类型： RT00 拒付追索 RT01 非拒付追索';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.solutor_date is '清偿日期';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.txn_ctrct_nb is '交易合同编号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.invoice_nb is '发票号码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcrs_rsn_cd is '追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.btch_nb is '批次号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.sign_flag is '签收状态： 0 拒签 1 签收';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.reply_flag is '回复标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rec_crt_ts is '记录插入时间';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_agency_bank_id is '请求方承接行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_agency_bank_id is '接收方承接行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.guarntr_adr is '保证人地址';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.ucondl_consign_mk is '到期无条件支付委托： CC00 无条件 CC01 条件';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.ucondl_prms_mk is '到期无条件支付承诺';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.proxy_sign is '代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.proxy_req is '代理申请标识： PP00 开户机构代理申请签章 PP01 票据当事人自己签章';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.credit_rate is '信用等级';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.credit_rate_agency is '评级机构';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.credit_rate_due_date is '评级到期日';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.req_remark is '请求方备注';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.rcv_remark is '接收方备注';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.aoa_account is '入账账号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.aoa_bank_id is '入账行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.have_type is '持票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.have_brch_code is '持票人组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.have_name is '持票人名称';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.hava_account is '持票人账号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.hava_bank_id is '持票人开户行号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.seq_no is '支付交易序号';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.is_lock is '是否锁定： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.return_code is '返回码';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.return_msg is '返回信息';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.is_inner is '是否系统内： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.lastbuy_trans_id is '上手买入交易ID';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.last_upd_txn_oprid is '操作柜员';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.details_id is '交易明细ID';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.orgnl_msg_id is '原报文ID';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.reserve1 is '备注';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bms_e_draft_trans.etl_timestamp is 'ETL处理时间戳';
