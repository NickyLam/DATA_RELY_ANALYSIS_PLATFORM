/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_endrsmt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_endrsmt_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_endrsmt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_endrsmt_info(
    id varchar2(60) -- ID
    ,draft_id varchar2(60) -- 票据ID
    ,electric_draft_id varchar2(45) -- 电子票据号码
    ,draft_amount number(16,2) -- 票据金额
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 到期日
    ,transfer_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,draft_type varchar2(6) -- 票据类型： AC01 银票 AC02 商票
    ,req_type varchar2(6) -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,req_name varchar2(525) -- 请求方名称
    ,req_brch_code varchar2(30) -- 请求方组织机构代码
    ,req_account varchar2(48) -- 请求方账号
    ,req_bank_id varchar2(18) -- 请求方开户行行号
    ,rcv_type varchar2(6) -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,rcv_name varchar2(270) -- 接收方名称
    ,rcv_brch_code varchar2(30) -- 接收方组织机构代码
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_bank_id varchar2(18) -- 接收方开户行行号
    ,sign_date varchar2(12) -- 签收日期
    ,req_date varchar2(12) -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,req_remark varchar2(1152) -- 请求方备注
    ,rcv_remark varchar2(1152) -- 接收方备注
    ,return_code varchar2(30) -- 返回码
    ,return_msg varchar2(375) -- 返回信息
    ,repurchase_end_date varchar2(12) -- 赎回截止日
    ,repurchase_begin_date varchar2(12) -- 赎回开放日
    ,onl_stlm_flag varchar2(6) -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,discount_type varchar2(6) -- 贴现种类： RM00 买断式 RM01 回购式
    ,reject_code varchar2(6) -- 拒付代码
    ,reject_info varchar2(1152) -- 拒付备注信息
    ,holder_type varchar2(6) -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,solutor_date varchar2(12) -- 清偿日期
    ,endrsmt_type varchar2(15) -- 背书类型
    ,reserve1 varchar2(75) -- 保留字段1
    ,reserve2 varchar2(75) -- 保留字段1
    ,reserve3 varchar2(75) -- 保留字段1
    ,assusigneraa_ddra_ddr varchar2(180) -- 保证人地址
    ,trans_no varchar2(30) -- 交易编号
    ,trans_name varchar2(150) -- 交易名称
    ,presentation_flag varchar2(6) -- PRESENTATION_FLAG
    ,ucondl_consign_mk varchar2(6) -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,ucondl_prms_mk varchar2(6) -- 到期无条件支付承诺
    ,txn_ctrct_nb varchar2(135) -- 交易合同编号
    ,invoice_nb varchar2(135) -- 发票号码
    ,btch_nb varchar2(135) -- 批次号
    ,proxy_sign varchar2(6) -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,proxy_req varchar2(6) -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,credit_rate varchar2(5) -- 信用等级
    ,credit_rate_agency varchar2(270) -- 评级机构
    ,credit_rate_due_date varchar2(12) -- 评级到期日
    ,rate number(9,6) -- 利率
    ,rel_amount number(18,2) -- 贴现实付金额
    ,repurchase_rate number(9,6) -- 赎回利率
    ,repurchase_amt number(18,2) -- 赎回实付金额
    ,req_recept_bank varchar2(18) -- 申请方承接行行号
    ,prompt_pay_amt number(18,2) -- 提示付款金额
    ,overdue_reason varchar2(1152) -- 逾期原因说明
    ,rcrs_amount number(18,2) -- 追索金额
    ,solutor_amount number(18,2) -- 清偿金额
    ,rcrs_rsn_cd varchar2(6) -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,rcv_recept_bank varchar2(18) -- 接收方承接行行号
    ,aoa_account varchar2(48) -- 入账账号
    ,aoa_bank_id varchar2(18) -- 入账行号
    ,create_time date -- 创建时间
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
grant select on ${iol_schema}.bdms_bms_endrsmt_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_endrsmt_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_endrsmt_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_endrsmt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_endrsmt_info is '票据背书信息表';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.electric_draft_id is '电子票据号码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.transfer_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.draft_type is '票据类型： AC01 银票 AC02 商票';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_type is '请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_brch_code is '请求方组织机构代码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_bank_id is '请求方开户行行号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_type is '接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_brch_code is '接收方组织机构代码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_bank_id is '接收方开户行行号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.sign_date is '签收日期';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_date is '申请日期、提示付款、逾期提示付款、追索通知日期';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_remark is '请求方备注';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_remark is '接收方备注';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.return_code is '返回码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.return_msg is '返回信息';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.repurchase_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.repurchase_begin_date is '赎回开放日';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.onl_stlm_flag is '线上清算标记： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.discount_type is '贴现种类： RM00 买断式 RM01 回购式';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.reject_code is '拒付代码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.reject_info is '拒付备注信息';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.holder_type is '追索类型： RT00 拒付追索 RT01 非拒付追索';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.solutor_date is '清偿日期';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.endrsmt_type is '背书类型';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.reserve1 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.reserve2 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.reserve3 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.assusigneraa_ddra_ddr is '保证人地址';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.trans_no is '交易编号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.trans_name is '交易名称';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.presentation_flag is 'PRESENTATION_FLAG';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.ucondl_consign_mk is '到期无条件支付委托： CC00 无条件 CC01 条件';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.ucondl_prms_mk is '到期无条件支付承诺';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.txn_ctrct_nb is '交易合同编号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.invoice_nb is '发票号码';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.btch_nb is '批次号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.proxy_sign is '代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.proxy_req is '代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.credit_rate is '信用等级';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.credit_rate_agency is '评级机构';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.credit_rate_due_date is '评级到期日';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rate is '利率';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rel_amount is '贴现实付金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.repurchase_amt is '赎回实付金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.req_recept_bank is '申请方承接行行号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.prompt_pay_amt is '提示付款金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.overdue_reason is '逾期原因说明';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcrs_amount is '追索金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.solutor_amount is '清偿金额';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcrs_rsn_cd is '追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.rcv_recept_bank is '接收方承接行行号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.aoa_account is '入账账号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.aoa_bank_id is '入账行号';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_endrsmt_info.etl_timestamp is 'ETL处理时间戳';
