/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_draft_centre_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_draft_centre_trans
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_draft_centre_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_draft_centre_trans(
    id varchar2(60) -- 
    ,draft_id varchar2(60) -- 票据id
    ,contract_id varchar2(60) -- 协议id
    ,details_id varchar2(60) -- 清单id
    ,protocol_no varchar2(60) -- 业务编号（协议号）
    ,product_no varchar2(30) -- 产品代码
    ,trans_name varchar2(225) -- 交易状态
    ,trans_no varchar2(30) -- 交易编号
    ,draft_number varchar2(45) -- 票据号码
    ,txn_date varchar2(12) -- 交易日期
    ,req_name varchar2(270) -- 请求方名称
    ,req_brch_code varchar2(15) -- 请求方组织机构代码
    ,req_account varchar2(48) -- 请求方帐号
    ,req_bank_id varchar2(18) -- 请求方开户行行号
    ,rcv_name varchar2(270) -- 接收方名称
    ,rcv_brch_code varchar2(45) -- 接收方组织机构代码
    ,rcv_account varchar2(48) -- 接收方帐号
    ,rcv_bank_id varchar2(18) -- 接收方开户行行号
    ,rate number(9,6) -- 贴现利率
    ,draft_amount number(18,2) -- 金额
    ,interest number(18,2) -- 总利息
    ,buyer_interest number(18,2) -- 买方付息
    ,pay_amount number(18,2) -- 实付金额
    ,busi_type varchar2(6) -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
    ,pay_type varchar2(2) -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,payer_name varchar2(270) -- 付息人名称
    ,payer_account varchar2(48) -- 付息人帐号
    ,payer_bank_name varchar2(270) -- 付息人开户行
    ,payer_sale number(8,5) -- 付息比例
    ,agent_name varchar2(270) -- 代理人名称
    ,trans_branch_no varchar2(30) -- 交易机构号
    ,acct_branch_no varchar2(30) -- 记账机构号
    ,store_branch_no varchar2(30) -- 实物保管机构号
    ,repurchase_date varchar2(12) -- 赎回日
    ,cust_no varchar2(30) -- 客户号
    ,charge number(12,2) -- 手续费
    ,expenses number(12,2) -- 工本费
    ,seq_no varchar2(60) -- 历史序号
    ,last_operator_no varchar2(45) -- 最后修改操作员id
    ,last_txn_date timestamp -- 最后修改时间
    ,acceptor_bank_no varchar2(18) -- 承兑行行号
    ,tmp_status varchar2(18) -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
    ,sttlm_mk varchar2(6) -- 线上清算标识： sm00 线上清算 sm01 线下清算
    ,status varchar2(30) -- 票据状态
    ,inner_flag varchar2(3) -- 是否系统内： 0 否 1 是
    ,rpd_mk varchar2(6) -- 是否回购式： 0 否 1 是
    ,rate_end_date varchar2(12) -- 计息到期日
    ,is_lock varchar2(2) -- 锁标志： 0 否 1 是
    ,last_trans_id varchar2(60) -- 上一笔买入id
    ,end_smt_flag varchar2(8) -- 不得转让标记： em00 可再转让 em01 不得转让
    ,repurchase_end_date varchar2(12) -- 赎回截止日
    ,repurchase_rate number(18,2) -- 赎回利率
    ,repurchase_begin_date varchar2(12) -- 赎回开放日
    ,storage_flag varchar2(2) -- 
    ,buy_type varchar2(9) -- 买入类型
    ,reserve1 varchar2(150) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,reserve3 varchar2(150) -- 备注3
    ,busi_branch_no varchar2(30) -- 
    ,del_flag varchar2(3) -- 
    ,register_status varchar2(23) -- 登记状态： 00 初始 10 登记发送中 20 登记成功
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
grant select on ${iol_schema}.bdms_bms_draft_centre_trans to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_trans to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_trans to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_draft_centre_trans is '票据交易信息表';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.id is '';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.draft_id is '票据id';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.contract_id is '协议id';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.details_id is '清单id';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.protocol_no is '业务编号（协议号）';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.product_no is '产品代码';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.trans_name is '交易状态';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.trans_no is '交易编号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.txn_date is '交易日期';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.req_brch_code is '请求方组织机构代码';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.req_account is '请求方帐号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.req_bank_id is '请求方开户行行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rcv_brch_code is '接收方组织机构代码';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rcv_account is '接收方帐号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rcv_bank_id is '接收方开户行行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rate is '贴现利率';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.draft_amount is '金额';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.interest is '总利息';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.buyer_interest is '买方付息';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.pay_amount is '实付金额';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.busi_type is '业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.pay_type is '付息方式： 1 买方付息 2 卖方付息 3 协议付息';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.payer_name is '付息人名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.payer_account is '付息人帐号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.payer_bank_name is '付息人开户行';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.payer_sale is '付息比例';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.agent_name is '代理人名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.trans_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.acct_branch_no is '记账机构号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.store_branch_no is '实物保管机构号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.repurchase_date is '赎回日';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.cust_no is '客户号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.charge is '手续费';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.expenses is '工本费';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.seq_no is '历史序号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.last_operator_no is '最后修改操作员id';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.last_txn_date is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.acceptor_bank_no is '承兑行行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.tmp_status is '处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.sttlm_mk is '线上清算标识： sm00 线上清算 sm01 线下清算';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.status is '票据状态';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.inner_flag is '是否系统内： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rpd_mk is '是否回购式： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.rate_end_date is '计息到期日';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.is_lock is '锁标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.last_trans_id is '上一笔买入id';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.end_smt_flag is '不得转让标记： em00 可再转让 em01 不得转让';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.repurchase_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.repurchase_begin_date is '赎回开放日';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.storage_flag is '';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.buy_type is '买入类型';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.busi_branch_no is '';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.del_flag is '';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.register_status is '登记状态： 00 初始 10 登记发送中 20 登记成功';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_draft_centre_trans.etl_timestamp is 'ETL处理时间戳';
