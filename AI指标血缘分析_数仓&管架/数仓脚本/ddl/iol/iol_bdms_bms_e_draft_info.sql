/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_e_draft_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_e_draft_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_e_draft_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_e_draft_info(
    id varchar2(60) -- ID
    ,trans_id varchar2(60) -- 交易ID
    ,electric_draft_id varchar2(45) -- 电子票据号码
    ,draft_amount number(16,2) -- 票据金额
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 票据到期日期
    ,transfer_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,consignment_code varchar2(6) -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
    ,maturity_pay_promise varchar2(6) -- 到期无条件支付承诺CC00
    ,txn_ctrct_nb varchar2(135) -- 交易合同编号
    ,remitter_type varchar2(6) -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,remitter_brch_code varchar2(30) -- 出票人组织机构代码
    ,remitter_account varchar2(48) -- 出票人账号
    ,remitter_name varchar2(300) -- 出票人名称
    ,remitter_bank_id varchar2(18) -- 出票人开户行行号
    ,remitter_credit varchar2(5) -- 出票人信用等级
    ,remitter_rating_org varchar2(270) -- 出票人信用评级机构
    ,remitter_rating_maturity varchar2(12) -- 出票人信用评级到期日
    ,payee_type varchar2(6) -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,payee_brch_code varchar2(30) -- 收款人组织机构代码
    ,payee_name varchar2(525) -- 收款人名称
    ,payee_account varchar2(48) -- 收款人账号
    ,payee_bank_id varchar2(18) -- 收款人开户行行号
    ,acceptor_type varchar2(6) -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,acceptor_brch_code varchar2(30) -- 承兑人组织机构代码
    ,acceptor_name varchar2(525) -- 承兑人名称
    ,acceptor_account varchar2(48) -- 承兑人账号
    ,acceptor_bank_id varchar2(18) -- 承兑人开户行行号
    ,acceptor_credit varchar2(5) -- 承兑人信用等级
    ,acceptor_rating_org varchar2(270) -- 承兑人信用评级机构
    ,acceptor_rating_maturity varchar2(12) -- 承兑人信用评级到期日
    ,owner_type varchar2(6) -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,owner_customer_id varchar2(15) -- 票据权利人客户号
    ,owner_brch_code varchar2(30) -- 票据权利人组织机构代码
    ,owner_name varchar2(525) -- 票据权利人名称
    ,owner_account varchar2(48) -- 票据权利人账号
    ,owner_bank_id varchar2(18) -- 票据权利人开户行号
    ,draft_org_status varchar2(9) -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,draft_snd_status varchar2(9) -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,draft_rcv_status varchar2(9) -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,rec_crt_ts varchar2(21) -- 记录插入时间
    ,lock_flag varchar2(2) -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
    ,draft_curr_status varchar2(9) -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,draft_type varchar2(6) -- 票据类型： AC01 银票 AC02 商票
    ,draft_attr varchar2(6) -- DRAFT_ATTR
    ,remark varchar2(768) -- 票据备注
    ,msgid varchar2(60) -- 报文编号
    ,current_status varchar2(15) -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,rpdmk varchar2(6) -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
    ,comrcl_drft_sts varchar2(375) -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,rcrstp varchar2(6) -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,apply_trans_id varchar2(60) -- 申请类
    ,sign_trans_id varchar2(60) -- 签收类业务
    ,is_recourse varchar2(2) -- 是否在追索中： 1 追索中 0 追索完成
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
grant select on ${iol_schema}.bdms_bms_e_draft_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_e_draft_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_e_draft_info is 'ECDS票据信息主表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_e_draft_info.trans_id is '交易ID';
comment on column ${iol_schema}.bdms_bms_e_draft_info.electric_draft_id is '电子票据号码';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_bms_e_draft_info.maturity_date is '票据到期日期';
comment on column ${iol_schema}.bdms_bms_e_draft_info.transfer_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_e_draft_info.consignment_code is '到期无条件支付委托类型： CC00 无条件 CC01 条件';
comment on column ${iol_schema}.bdms_bms_e_draft_info.maturity_pay_promise is '到期无条件支付承诺CC00';
comment on column ${iol_schema}.bdms_bms_e_draft_info.txn_ctrct_nb is '交易合同编号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_type is '出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_brch_code is '出票人组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_bank_id is '出票人开户行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_credit is '出票人信用等级';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_rating_org is '出票人信用评级机构';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remitter_rating_maturity is '出票人信用评级到期日';
comment on column ${iol_schema}.bdms_bms_e_draft_info.payee_type is '收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_info.payee_brch_code is '收款人组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_info.payee_name is '收款人名称';
comment on column ${iol_schema}.bdms_bms_e_draft_info.payee_account is '收款人账号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.payee_bank_id is '收款人开户行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_type is '承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_brch_code is '承兑人组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_bank_id is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_credit is '承兑人信用等级';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_rating_org is '承兑人信用评级机构';
comment on column ${iol_schema}.bdms_bms_e_draft_info.acceptor_rating_maturity is '承兑人信用评级到期日';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_type is '票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_customer_id is '票据权利人客户号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_brch_code is '票据权利人组织机构代码';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_name is '票据权利人名称';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_account is '票据权利人账号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.owner_bank_id is '票据权利人开户行号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_org_status is '票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_snd_status is '票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_rcv_status is '票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.rec_crt_ts is '记录插入时间';
comment on column ${iol_schema}.bdms_bms_e_draft_info.lock_flag is '锁定标志： 0 未锁 1 网银锁 2 本地锁';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_curr_status is '系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_type is '票据类型： AC01 银票 AC02 商票';
comment on column ${iol_schema}.bdms_bms_e_draft_info.draft_attr is 'DRAFT_ATTR';
comment on column ${iol_schema}.bdms_bms_e_draft_info.remark is '票据备注';
comment on column ${iol_schema}.bdms_bms_e_draft_info.msgid is '报文编号';
comment on column ${iol_schema}.bdms_bms_e_draft_info.current_status is '当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.rpdmk is '贴现/转贴现种类： RM00 买断式 RM01 回购式';
comment on column ${iol_schema}.bdms_bms_e_draft_info.comrcl_drft_sts is '票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表';
comment on column ${iol_schema}.bdms_bms_e_draft_info.rcrstp is '追索类型： RT00 拒付追索 RT01 非拒付追索';
comment on column ${iol_schema}.bdms_bms_e_draft_info.apply_trans_id is '申请类';
comment on column ${iol_schema}.bdms_bms_e_draft_info.sign_trans_id is '签收类业务';
comment on column ${iol_schema}.bdms_bms_e_draft_info.is_recourse is '是否在追索中： 1 追索中 0 追索完成';
comment on column ${iol_schema}.bdms_bms_e_draft_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_e_draft_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_e_draft_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_e_draft_info.etl_timestamp is 'ETL处理时间戳';
