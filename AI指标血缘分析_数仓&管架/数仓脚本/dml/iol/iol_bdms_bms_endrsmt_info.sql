/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_endrsmt_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.bdms_bms_endrsmt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_endrsmt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_endrsmt_info_op purge;
drop table ${iol_schema}.bdms_bms_endrsmt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_endrsmt_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.bdms_bms_endrsmt_info where 0=1;

create table ${iol_schema}.bdms_bms_endrsmt_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.bdms_bms_endrsmt_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.bdms_bms_endrsmt_info_op(
        id -- ID
        ,draft_id -- 票据ID
        ,electric_draft_id -- 电子票据号码
        ,draft_amount -- 票据金额
        ,remit_date -- 出票日期
        ,maturity_date -- 到期日
        ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
        ,draft_type -- 票据类型： AC01 银票 AC02 商票
        ,req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,req_name -- 请求方名称
        ,req_brch_code -- 请求方组织机构代码
        ,req_account -- 请求方账号
        ,req_bank_id -- 请求方开户行行号
        ,rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,rcv_name -- 接收方名称
        ,rcv_brch_code -- 接收方组织机构代码
        ,rcv_account -- 接收方账号
        ,rcv_bank_id -- 接收方开户行行号
        ,sign_date -- 签收日期
        ,req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
        ,req_remark -- 请求方备注
        ,rcv_remark -- 接收方备注
        ,return_code -- 返回码
        ,return_msg -- 返回信息
        ,repurchase_end_date -- 赎回截止日
        ,repurchase_begin_date -- 赎回开放日
        ,onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,discount_type -- 贴现种类： RM00 买断式 RM01 回购式
        ,reject_code -- 拒付代码
        ,reject_info -- 拒付备注信息
        ,holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
        ,solutor_date -- 清偿日期
        ,endrsmt_type -- 背书类型
        ,reserve1 -- 保留字段1
        ,reserve2 -- 保留字段1
        ,reserve3 -- 保留字段1
        ,assusigneraa_ddra_ddr -- 保证人地址
        ,trans_no -- 交易编号
        ,trans_name -- 交易名称
        ,presentation_flag -- PRESENTATION_FLAG
        ,ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
        ,ucondl_prms_mk -- 到期无条件支付承诺
        ,txn_ctrct_nb -- 交易合同编号
        ,invoice_nb -- 发票号码
        ,btch_nb -- 批次号
        ,proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,proxy_req -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,credit_rate -- 信用等级
        ,credit_rate_agency -- 评级机构
        ,credit_rate_due_date -- 评级到期日
        ,rate -- 利率
        ,rel_amount -- 贴现实付金额
        ,repurchase_rate -- 赎回利率
        ,repurchase_amt -- 赎回实付金额
        ,req_recept_bank -- 申请方承接行行号
        ,prompt_pay_amt -- 提示付款金额
        ,overdue_reason -- 逾期原因说明
        ,rcrs_amount -- 追索金额
        ,solutor_amount -- 清偿金额
        ,rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
        ,rcv_recept_bank -- 接收方承接行行号
        ,aoa_account -- 入账账号
        ,aoa_bank_id -- 入账行号
        ,create_time -- 创建时间
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- ID
    ,n.draft_id -- 票据ID
    ,n.electric_draft_id -- 电子票据号码
    ,n.draft_amount -- 票据金额
    ,n.remit_date -- 出票日期
    ,n.maturity_date -- 到期日
    ,n.transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,n.draft_type -- 票据类型： AC01 银票 AC02 商票
    ,n.req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,n.req_name -- 请求方名称
    ,n.req_brch_code -- 请求方组织机构代码
    ,n.req_account -- 请求方账号
    ,n.req_bank_id -- 请求方开户行行号
    ,n.rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,n.rcv_name -- 接收方名称
    ,n.rcv_brch_code -- 接收方组织机构代码
    ,n.rcv_account -- 接收方账号
    ,n.rcv_bank_id -- 接收方开户行行号
    ,n.sign_date -- 签收日期
    ,n.req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,n.req_remark -- 请求方备注
    ,n.rcv_remark -- 接收方备注
    ,n.return_code -- 返回码
    ,n.return_msg -- 返回信息
    ,n.repurchase_end_date -- 赎回截止日
    ,n.repurchase_begin_date -- 赎回开放日
    ,n.onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,n.discount_type -- 贴现种类： RM00 买断式 RM01 回购式
    ,n.reject_code -- 拒付代码
    ,n.reject_info -- 拒付备注信息
    ,n.holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,n.solutor_date -- 清偿日期
    ,n.endrsmt_type -- 背书类型
    ,n.reserve1 -- 保留字段1
    ,n.reserve2 -- 保留字段1
    ,n.reserve3 -- 保留字段1
    ,n.assusigneraa_ddra_ddr -- 保证人地址
    ,n.trans_no -- 交易编号
    ,n.trans_name -- 交易名称
    ,n.presentation_flag -- PRESENTATION_FLAG
    ,n.ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,n.ucondl_prms_mk -- 到期无条件支付承诺
    ,n.txn_ctrct_nb -- 交易合同编号
    ,n.invoice_nb -- 发票号码
    ,n.btch_nb -- 批次号
    ,n.proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,n.proxy_req -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,n.credit_rate -- 信用等级
    ,n.credit_rate_agency -- 评级机构
    ,n.credit_rate_due_date -- 评级到期日
    ,n.rate -- 利率
    ,n.rel_amount -- 贴现实付金额
    ,n.repurchase_rate -- 赎回利率
    ,n.repurchase_amt -- 赎回实付金额
    ,n.req_recept_bank -- 申请方承接行行号
    ,n.prompt_pay_amt -- 提示付款金额
    ,n.overdue_reason -- 逾期原因说明
    ,n.rcrs_amount -- 追索金额
    ,n.solutor_amount -- 清偿金额
    ,n.rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,n.rcv_recept_bank -- 接收方承接行行号
    ,n.aoa_account -- 入账账号
    ,n.aoa_bank_id -- 入账行号
    ,n.create_time -- 创建时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_bms_endrsmt_info_bk o
    right join (select * from ${itl_schema}.bdms_bms_endrsmt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        o.draft_id <> n.draft_id
        or o.electric_draft_id <> n.electric_draft_id
        or o.draft_amount <> n.draft_amount
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.transfer_flag <> n.transfer_flag
        or o.draft_type <> n.draft_type
        or o.req_type <> n.req_type
        or o.req_name <> n.req_name
        or o.req_brch_code <> n.req_brch_code
        or o.req_account <> n.req_account
        or o.req_bank_id <> n.req_bank_id
        or o.rcv_type <> n.rcv_type
        or o.rcv_name <> n.rcv_name
        or o.rcv_brch_code <> n.rcv_brch_code
        or o.rcv_account <> n.rcv_account
        or o.rcv_bank_id <> n.rcv_bank_id
        or o.sign_date <> n.sign_date
        or o.req_date <> n.req_date
        or o.req_remark <> n.req_remark
        or o.rcv_remark <> n.rcv_remark
        or o.return_code <> n.return_code
        or o.return_msg <> n.return_msg
        or o.repurchase_end_date <> n.repurchase_end_date
        or o.repurchase_begin_date <> n.repurchase_begin_date
        or o.onl_stlm_flag <> n.onl_stlm_flag
        or o.discount_type <> n.discount_type
        or o.reject_code <> n.reject_code
        or o.reject_info <> n.reject_info
        or o.holder_type <> n.holder_type
        or o.solutor_date <> n.solutor_date
        or o.endrsmt_type <> n.endrsmt_type
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.assusigneraa_ddra_ddr <> n.assusigneraa_ddra_ddr
        or o.trans_no <> n.trans_no
        or o.trans_name <> n.trans_name
        or o.presentation_flag <> n.presentation_flag
        or o.ucondl_consign_mk <> n.ucondl_consign_mk
        or o.ucondl_prms_mk <> n.ucondl_prms_mk
        or o.txn_ctrct_nb <> n.txn_ctrct_nb
        or o.invoice_nb <> n.invoice_nb
        or o.btch_nb <> n.btch_nb
        or o.proxy_sign <> n.proxy_sign
        or o.proxy_req <> n.proxy_req
        or o.credit_rate <> n.credit_rate
        or o.credit_rate_agency <> n.credit_rate_agency
        or o.credit_rate_due_date <> n.credit_rate_due_date
        or o.rate <> n.rate
        or o.rel_amount <> n.rel_amount
        or o.repurchase_rate <> n.repurchase_rate
        or o.repurchase_amt <> n.repurchase_amt
        or o.req_recept_bank <> n.req_recept_bank
        or o.prompt_pay_amt <> n.prompt_pay_amt
        or o.overdue_reason <> n.overdue_reason
        or o.rcrs_amount <> n.rcrs_amount
        or o.solutor_amount <> n.solutor_amount
        or o.rcrs_rsn_cd <> n.rcrs_rsn_cd
        or o.rcv_recept_bank <> n.rcv_recept_bank
        or o.aoa_account <> n.aoa_account
        or o.aoa_bank_id <> n.aoa_bank_id
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_endrsmt_info_cl(
            id -- ID
        ,draft_id -- 票据ID
        ,electric_draft_id -- 电子票据号码
        ,draft_amount -- 票据金额
        ,remit_date -- 出票日期
        ,maturity_date -- 到期日
        ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
        ,draft_type -- 票据类型： AC01 银票 AC02 商票
        ,req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,req_name -- 请求方名称
        ,req_brch_code -- 请求方组织机构代码
        ,req_account -- 请求方账号
        ,req_bank_id -- 请求方开户行行号
        ,rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,rcv_name -- 接收方名称
        ,rcv_brch_code -- 接收方组织机构代码
        ,rcv_account -- 接收方账号
        ,rcv_bank_id -- 接收方开户行行号
        ,sign_date -- 签收日期
        ,req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
        ,req_remark -- 请求方备注
        ,rcv_remark -- 接收方备注
        ,return_code -- 返回码
        ,return_msg -- 返回信息
        ,repurchase_end_date -- 赎回截止日
        ,repurchase_begin_date -- 赎回开放日
        ,onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,discount_type -- 贴现种类： RM00 买断式 RM01 回购式
        ,reject_code -- 拒付代码
        ,reject_info -- 拒付备注信息
        ,holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
        ,solutor_date -- 清偿日期
        ,endrsmt_type -- 背书类型
        ,reserve1 -- 保留字段1
        ,reserve2 -- 保留字段1
        ,reserve3 -- 保留字段1
        ,assusigneraa_ddra_ddr -- 保证人地址
        ,trans_no -- 交易编号
        ,trans_name -- 交易名称
        ,presentation_flag -- PRESENTATION_FLAG
        ,ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
        ,ucondl_prms_mk -- 到期无条件支付承诺
        ,txn_ctrct_nb -- 交易合同编号
        ,invoice_nb -- 发票号码
        ,btch_nb -- 批次号
        ,proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,proxy_req -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,credit_rate -- 信用等级
        ,credit_rate_agency -- 评级机构
        ,credit_rate_due_date -- 评级到期日
        ,rate -- 利率
        ,rel_amount -- 贴现实付金额
        ,repurchase_rate -- 赎回利率
        ,repurchase_amt -- 赎回实付金额
        ,req_recept_bank -- 申请方承接行行号
        ,prompt_pay_amt -- 提示付款金额
        ,overdue_reason -- 逾期原因说明
        ,rcrs_amount -- 追索金额
        ,solutor_amount -- 清偿金额
        ,rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
        ,rcv_recept_bank -- 接收方承接行行号
        ,aoa_account -- 入账账号
        ,aoa_bank_id -- 入账行号
        ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_endrsmt_info_op(
            id -- ID
        ,draft_id -- 票据ID
        ,electric_draft_id -- 电子票据号码
        ,draft_amount -- 票据金额
        ,remit_date -- 出票日期
        ,maturity_date -- 到期日
        ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
        ,draft_type -- 票据类型： AC01 银票 AC02 商票
        ,req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,req_name -- 请求方名称
        ,req_brch_code -- 请求方组织机构代码
        ,req_account -- 请求方账号
        ,req_bank_id -- 请求方开户行行号
        ,rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
        ,rcv_name -- 接收方名称
        ,rcv_brch_code -- 接收方组织机构代码
        ,rcv_account -- 接收方账号
        ,rcv_bank_id -- 接收方开户行行号
        ,sign_date -- 签收日期
        ,req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
        ,req_remark -- 请求方备注
        ,rcv_remark -- 接收方备注
        ,return_code -- 返回码
        ,return_msg -- 返回信息
        ,repurchase_end_date -- 赎回截止日
        ,repurchase_begin_date -- 赎回开放日
        ,onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,discount_type -- 贴现种类： RM00 买断式 RM01 回购式
        ,reject_code -- 拒付代码
        ,reject_info -- 拒付备注信息
        ,holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
        ,solutor_date -- 清偿日期
        ,endrsmt_type -- 背书类型
        ,reserve1 -- 保留字段1
        ,reserve2 -- 保留字段1
        ,reserve3 -- 保留字段1
        ,assusigneraa_ddra_ddr -- 保证人地址
        ,trans_no -- 交易编号
        ,trans_name -- 交易名称
        ,presentation_flag -- PRESENTATION_FLAG
        ,ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
        ,ucondl_prms_mk -- 到期无条件支付承诺
        ,txn_ctrct_nb -- 交易合同编号
        ,invoice_nb -- 发票号码
        ,btch_nb -- 批次号
        ,proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,proxy_req -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
        ,credit_rate -- 信用等级
        ,credit_rate_agency -- 评级机构
        ,credit_rate_due_date -- 评级到期日
        ,rate -- 利率
        ,rel_amount -- 贴现实付金额
        ,repurchase_rate -- 赎回利率
        ,repurchase_amt -- 赎回实付金额
        ,req_recept_bank -- 申请方承接行行号
        ,prompt_pay_amt -- 提示付款金额
        ,overdue_reason -- 逾期原因说明
        ,rcrs_amount -- 追索金额
        ,solutor_amount -- 清偿金额
        ,rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
        ,rcv_recept_bank -- 接收方承接行行号
        ,aoa_account -- 入账账号
        ,aoa_bank_id -- 入账行号
        ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_id -- 票据ID
    ,o.electric_draft_id -- 电子票据号码
    ,o.draft_amount -- 票据金额
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 到期日
    ,o.transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,o.draft_type -- 票据类型： AC01 银票 AC02 商票
    ,o.req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.req_name -- 请求方名称
    ,o.req_brch_code -- 请求方组织机构代码
    ,o.req_account -- 请求方账号
    ,o.req_bank_id -- 请求方开户行行号
    ,o.rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.rcv_name -- 接收方名称
    ,o.rcv_brch_code -- 接收方组织机构代码
    ,o.rcv_account -- 接收方账号
    ,o.rcv_bank_id -- 接收方开户行行号
    ,o.sign_date -- 签收日期
    ,o.req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,o.req_remark -- 请求方备注
    ,o.rcv_remark -- 接收方备注
    ,o.return_code -- 返回码
    ,o.return_msg -- 返回信息
    ,o.repurchase_end_date -- 赎回截止日
    ,o.repurchase_begin_date -- 赎回开放日
    ,o.onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,o.discount_type -- 贴现种类： RM00 买断式 RM01 回购式
    ,o.reject_code -- 拒付代码
    ,o.reject_info -- 拒付备注信息
    ,o.holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,o.solutor_date -- 清偿日期
    ,o.endrsmt_type -- 背书类型
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段1
    ,o.reserve3 -- 保留字段1
    ,o.assusigneraa_ddra_ddr -- 保证人地址
    ,o.trans_no -- 交易编号
    ,o.trans_name -- 交易名称
    ,o.presentation_flag -- PRESENTATION_FLAG
    ,o.ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,o.ucondl_prms_mk -- 到期无条件支付承诺
    ,o.txn_ctrct_nb -- 交易合同编号
    ,o.invoice_nb -- 发票号码
    ,o.btch_nb -- 批次号
    ,o.proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,o.proxy_req -- 代理申请标识 PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,o.credit_rate -- 信用等级
    ,o.credit_rate_agency -- 评级机构
    ,o.credit_rate_due_date -- 评级到期日
    ,o.rate -- 利率
    ,o.rel_amount -- 贴现实付金额
    ,o.repurchase_rate -- 赎回利率
    ,o.repurchase_amt -- 赎回实付金额
    ,o.req_recept_bank -- 申请方承接行行号
    ,o.prompt_pay_amt -- 提示付款金额
    ,o.overdue_reason -- 逾期原因说明
    ,o.rcrs_amount -- 追索金额
    ,o.solutor_amount -- 清偿金额
    ,o.rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,o.rcv_recept_bank -- 接收方承接行行号
    ,o.aoa_account -- 入账账号
    ,o.aoa_bank_id -- 入账行号
    ,o.create_time -- 创建时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_bms_endrsmt_info_bk o
    left join ${iol_schema}.bdms_bms_endrsmt_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_endrsmt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_endrsmt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_endrsmt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_endrsmt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_endrsmt_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_endrsmt_info_cl;
alter table ${iol_schema}.bdms_bms_endrsmt_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_endrsmt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_endrsmt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_endrsmt_info_op purge;
drop table ${iol_schema}.bdms_bms_endrsmt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_endrsmt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_endrsmt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
