/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_e_draft_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.bdms_bms_e_draft_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_e_draft_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_e_draft_info_op purge;
drop table ${iol_schema}.bdms_bms_e_draft_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_e_draft_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_e_draft_info where 0=1;

create table ${iol_schema}.bdms_bms_e_draft_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_e_draft_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_e_draft_info_cl(
            id -- ID
            ,trans_id -- 交易ID
            ,electric_draft_id -- 电子票据号码
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
            ,maturity_pay_promise -- 到期无条件支付承诺CC00
            ,txn_ctrct_nb -- 交易合同编号
            ,remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,remitter_brch_code -- 出票人组织机构代码
            ,remitter_account -- 出票人账号
            ,remitter_name -- 出票人名称
            ,remitter_bank_id -- 出票人开户行行号
            ,remitter_credit -- 出票人信用等级
            ,remitter_rating_org -- 出票人信用评级机构
            ,remitter_rating_maturity -- 出票人信用评级到期日
            ,payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,payee_brch_code -- 收款人组织机构代码
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_bank_id -- 收款人开户行行号
            ,acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_brch_code -- 承兑人组织机构代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_id -- 承兑人开户行行号
            ,acceptor_credit -- 承兑人信用等级
            ,acceptor_rating_org -- 承兑人信用评级机构
            ,acceptor_rating_maturity -- 承兑人信用评级到期日
            ,owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,owner_customer_id -- 票据权利人客户号
            ,owner_brch_code -- 票据权利人组织机构代码
            ,owner_name -- 票据权利人名称
            ,owner_account -- 票据权利人账号
            ,owner_bank_id -- 票据权利人开户行号
            ,draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rec_crt_ts -- 记录插入时间
            ,lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
            ,draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_type -- 票据类型： AC01 银票 AC02 商票
            ,draft_attr -- DRAFT_ATTR
            ,remark -- 票据备注
            ,msgid -- 报文编号
            ,current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
            ,comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
            ,apply_trans_id -- 申请类
            ,sign_trans_id -- 签收类业务
            ,is_recourse -- 是否在追索中： 1 追索中 0 追索完成
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_e_draft_info_op(
            id -- ID
            ,trans_id -- 交易ID
            ,electric_draft_id -- 电子票据号码
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
            ,maturity_pay_promise -- 到期无条件支付承诺CC00
            ,txn_ctrct_nb -- 交易合同编号
            ,remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,remitter_brch_code -- 出票人组织机构代码
            ,remitter_account -- 出票人账号
            ,remitter_name -- 出票人名称
            ,remitter_bank_id -- 出票人开户行行号
            ,remitter_credit -- 出票人信用等级
            ,remitter_rating_org -- 出票人信用评级机构
            ,remitter_rating_maturity -- 出票人信用评级到期日
            ,payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,payee_brch_code -- 收款人组织机构代码
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_bank_id -- 收款人开户行行号
            ,acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_brch_code -- 承兑人组织机构代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_id -- 承兑人开户行行号
            ,acceptor_credit -- 承兑人信用等级
            ,acceptor_rating_org -- 承兑人信用评级机构
            ,acceptor_rating_maturity -- 承兑人信用评级到期日
            ,owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,owner_customer_id -- 票据权利人客户号
            ,owner_brch_code -- 票据权利人组织机构代码
            ,owner_name -- 票据权利人名称
            ,owner_account -- 票据权利人账号
            ,owner_bank_id -- 票据权利人开户行号
            ,draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rec_crt_ts -- 记录插入时间
            ,lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
            ,draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_type -- 票据类型： AC01 银票 AC02 商票
            ,draft_attr -- DRAFT_ATTR
            ,remark -- 票据备注
            ,msgid -- 报文编号
            ,current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
            ,comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
            ,apply_trans_id -- 申请类
            ,sign_trans_id -- 签收类业务
            ,is_recourse -- 是否在追索中： 1 追索中 0 追索完成
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 交易ID
    ,nvl(n.electric_draft_id, o.electric_draft_id) as electric_draft_id -- 电子票据号码
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日期
    ,nvl(n.transfer_flag, o.transfer_flag) as transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,nvl(n.consignment_code, o.consignment_code) as consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
    ,nvl(n.maturity_pay_promise, o.maturity_pay_promise) as maturity_pay_promise -- 到期无条件支付承诺CC00
    ,nvl(n.txn_ctrct_nb, o.txn_ctrct_nb) as txn_ctrct_nb -- 交易合同编号
    ,nvl(n.remitter_type, o.remitter_type) as remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.remitter_brch_code, o.remitter_brch_code) as remitter_brch_code -- 出票人组织机构代码
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_bank_id, o.remitter_bank_id) as remitter_bank_id -- 出票人开户行行号
    ,nvl(n.remitter_credit, o.remitter_credit) as remitter_credit -- 出票人信用等级
    ,nvl(n.remitter_rating_org, o.remitter_rating_org) as remitter_rating_org -- 出票人信用评级机构
    ,nvl(n.remitter_rating_maturity, o.remitter_rating_maturity) as remitter_rating_maturity -- 出票人信用评级到期日
    ,nvl(n.payee_type, o.payee_type) as payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.payee_brch_code, o.payee_brch_code) as payee_brch_code -- 收款人组织机构代码
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收款人名称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 收款人账号
    ,nvl(n.payee_bank_id, o.payee_bank_id) as payee_bank_id -- 收款人开户行行号
    ,nvl(n.acceptor_type, o.acceptor_type) as acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.acceptor_brch_code, o.acceptor_brch_code) as acceptor_brch_code -- 承兑人组织机构代码
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_bank_id, o.acceptor_bank_id) as acceptor_bank_id -- 承兑人开户行行号
    ,nvl(n.acceptor_credit, o.acceptor_credit) as acceptor_credit -- 承兑人信用等级
    ,nvl(n.acceptor_rating_org, o.acceptor_rating_org) as acceptor_rating_org -- 承兑人信用评级机构
    ,nvl(n.acceptor_rating_maturity, o.acceptor_rating_maturity) as acceptor_rating_maturity -- 承兑人信用评级到期日
    ,nvl(n.owner_type, o.owner_type) as owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,nvl(n.owner_customer_id, o.owner_customer_id) as owner_customer_id -- 票据权利人客户号
    ,nvl(n.owner_brch_code, o.owner_brch_code) as owner_brch_code -- 票据权利人组织机构代码
    ,nvl(n.owner_name, o.owner_name) as owner_name -- 票据权利人名称
    ,nvl(n.owner_account, o.owner_account) as owner_account -- 票据权利人账号
    ,nvl(n.owner_bank_id, o.owner_bank_id) as owner_bank_id -- 票据权利人开户行号
    ,nvl(n.draft_org_status, o.draft_org_status) as draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.draft_snd_status, o.draft_snd_status) as draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.draft_rcv_status, o.draft_rcv_status) as draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 记录插入时间
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
    ,nvl(n.draft_curr_status, o.draft_curr_status) as draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银票 AC02 商票
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- DRAFT_ATTR
    ,nvl(n.remark, o.remark) as remark -- 票据备注
    ,nvl(n.msgid, o.msgid) as msgid -- 报文编号
    ,nvl(n.current_status, o.current_status) as current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.rpdmk, o.rpdmk) as rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
    ,nvl(n.comrcl_drft_sts, o.comrcl_drft_sts) as comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,nvl(n.rcrstp, o.rcrstp) as rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,nvl(n.apply_trans_id, o.apply_trans_id) as apply_trans_id -- 申请类
    ,nvl(n.sign_trans_id, o.sign_trans_id) as sign_trans_id -- 签收类业务
    ,nvl(n.is_recourse, o.is_recourse) as is_recourse -- 是否在追索中： 1 追索中 0 追索完成
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_e_draft_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_e_draft_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.trans_id <> n.trans_id
        or o.electric_draft_id <> n.electric_draft_id
        or o.draft_amount <> n.draft_amount
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.transfer_flag <> n.transfer_flag
        or o.consignment_code <> n.consignment_code
        or o.maturity_pay_promise <> n.maturity_pay_promise
        or o.txn_ctrct_nb <> n.txn_ctrct_nb
        or o.remitter_type <> n.remitter_type
        or o.remitter_brch_code <> n.remitter_brch_code
        or o.remitter_account <> n.remitter_account
        or o.remitter_name <> n.remitter_name
        or o.remitter_bank_id <> n.remitter_bank_id
        or o.remitter_credit <> n.remitter_credit
        or o.remitter_rating_org <> n.remitter_rating_org
        or o.remitter_rating_maturity <> n.remitter_rating_maturity
        or o.payee_type <> n.payee_type
        or o.payee_brch_code <> n.payee_brch_code
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_id <> n.payee_bank_id
        or o.acceptor_type <> n.acceptor_type
        or o.acceptor_brch_code <> n.acceptor_brch_code
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_bank_id <> n.acceptor_bank_id
        or o.acceptor_credit <> n.acceptor_credit
        or o.acceptor_rating_org <> n.acceptor_rating_org
        or o.acceptor_rating_maturity <> n.acceptor_rating_maturity
        or o.owner_type <> n.owner_type
        or o.owner_customer_id <> n.owner_customer_id
        or o.owner_brch_code <> n.owner_brch_code
        or o.owner_name <> n.owner_name
        or o.owner_account <> n.owner_account
        or o.owner_bank_id <> n.owner_bank_id
        or o.draft_org_status <> n.draft_org_status
        or o.draft_snd_status <> n.draft_snd_status
        or o.draft_rcv_status <> n.draft_rcv_status
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.lock_flag <> n.lock_flag
        or o.draft_curr_status <> n.draft_curr_status
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.remark <> n.remark
        or o.msgid <> n.msgid
        or o.current_status <> n.current_status
        or o.rpdmk <> n.rpdmk
        or o.comrcl_drft_sts <> n.comrcl_drft_sts
        or o.rcrstp <> n.rcrstp
        or o.apply_trans_id <> n.apply_trans_id
        or o.sign_trans_id <> n.sign_trans_id
        or o.is_recourse <> n.is_recourse
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_e_draft_info_cl(
            id -- ID
            ,trans_id -- 交易ID
            ,electric_draft_id -- 电子票据号码
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
            ,maturity_pay_promise -- 到期无条件支付承诺CC00
            ,txn_ctrct_nb -- 交易合同编号
            ,remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,remitter_brch_code -- 出票人组织机构代码
            ,remitter_account -- 出票人账号
            ,remitter_name -- 出票人名称
            ,remitter_bank_id -- 出票人开户行行号
            ,remitter_credit -- 出票人信用等级
            ,remitter_rating_org -- 出票人信用评级机构
            ,remitter_rating_maturity -- 出票人信用评级到期日
            ,payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,payee_brch_code -- 收款人组织机构代码
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_bank_id -- 收款人开户行行号
            ,acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_brch_code -- 承兑人组织机构代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_id -- 承兑人开户行行号
            ,acceptor_credit -- 承兑人信用等级
            ,acceptor_rating_org -- 承兑人信用评级机构
            ,acceptor_rating_maturity -- 承兑人信用评级到期日
            ,owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,owner_customer_id -- 票据权利人客户号
            ,owner_brch_code -- 票据权利人组织机构代码
            ,owner_name -- 票据权利人名称
            ,owner_account -- 票据权利人账号
            ,owner_bank_id -- 票据权利人开户行号
            ,draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rec_crt_ts -- 记录插入时间
            ,lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
            ,draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_type -- 票据类型： AC01 银票 AC02 商票
            ,draft_attr -- DRAFT_ATTR
            ,remark -- 票据备注
            ,msgid -- 报文编号
            ,current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
            ,comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
            ,apply_trans_id -- 申请类
            ,sign_trans_id -- 签收类业务
            ,is_recourse -- 是否在追索中： 1 追索中 0 追索完成
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_e_draft_info_op(
            id -- ID
            ,trans_id -- 交易ID
            ,electric_draft_id -- 电子票据号码
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日期
            ,maturity_date -- 票据到期日期
            ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
            ,maturity_pay_promise -- 到期无条件支付承诺CC00
            ,txn_ctrct_nb -- 交易合同编号
            ,remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,remitter_brch_code -- 出票人组织机构代码
            ,remitter_account -- 出票人账号
            ,remitter_name -- 出票人名称
            ,remitter_bank_id -- 出票人开户行行号
            ,remitter_credit -- 出票人信用等级
            ,remitter_rating_org -- 出票人信用评级机构
            ,remitter_rating_maturity -- 出票人信用评级到期日
            ,payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,payee_brch_code -- 收款人组织机构代码
            ,payee_name -- 收款人名称
            ,payee_account -- 收款人账号
            ,payee_bank_id -- 收款人开户行行号
            ,acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,acceptor_brch_code -- 承兑人组织机构代码
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_id -- 承兑人开户行行号
            ,acceptor_credit -- 承兑人信用等级
            ,acceptor_rating_org -- 承兑人信用评级机构
            ,acceptor_rating_maturity -- 承兑人信用评级到期日
            ,owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
            ,owner_customer_id -- 票据权利人客户号
            ,owner_brch_code -- 票据权利人组织机构代码
            ,owner_name -- 票据权利人名称
            ,owner_account -- 票据权利人账号
            ,owner_bank_id -- 票据权利人开户行号
            ,draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rec_crt_ts -- 记录插入时间
            ,lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
            ,draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,draft_type -- 票据类型： AC01 银票 AC02 商票
            ,draft_attr -- DRAFT_ATTR
            ,remark -- 票据备注
            ,msgid -- 报文编号
            ,current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
            ,comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
            ,rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
            ,apply_trans_id -- 申请类
            ,sign_trans_id -- 签收类业务
            ,is_recourse -- 是否在追索中： 1 追索中 0 追索完成
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.trans_id -- 交易ID
    ,o.electric_draft_id -- 电子票据号码
    ,o.draft_amount -- 票据金额
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 票据到期日期
    ,o.transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,o.consignment_code -- 到期无条件支付委托类型： CC00 无条件 CC01 条件
    ,o.maturity_pay_promise -- 到期无条件支付承诺CC00
    ,o.txn_ctrct_nb -- 交易合同编号
    ,o.remitter_type -- 出票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.remitter_brch_code -- 出票人组织机构代码
    ,o.remitter_account -- 出票人账号
    ,o.remitter_name -- 出票人名称
    ,o.remitter_bank_id -- 出票人开户行行号
    ,o.remitter_credit -- 出票人信用等级
    ,o.remitter_rating_org -- 出票人信用评级机构
    ,o.remitter_rating_maturity -- 出票人信用评级到期日
    ,o.payee_type -- 收款人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.payee_brch_code -- 收款人组织机构代码
    ,o.payee_name -- 收款人名称
    ,o.payee_account -- 收款人账号
    ,o.payee_bank_id -- 收款人开户行行号
    ,o.acceptor_type -- 承兑人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.acceptor_brch_code -- 承兑人组织机构代码
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_bank_id -- 承兑人开户行行号
    ,o.acceptor_credit -- 承兑人信用等级
    ,o.acceptor_rating_org -- 承兑人信用评级机构
    ,o.acceptor_rating_maturity -- 承兑人信用评级到期日
    ,o.owner_type -- 票据权利人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,o.owner_customer_id -- 票据权利人客户号
    ,o.owner_brch_code -- 票据权利人组织机构代码
    ,o.owner_name -- 票据权利人名称
    ,o.owner_account -- 票据权利人账号
    ,o.owner_bank_id -- 票据权利人开户行号
    ,o.draft_org_status -- 票据上一状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.draft_snd_status -- 票据发送人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.draft_rcv_status -- 票据接收人状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.rec_crt_ts -- 记录插入时间
    ,o.lock_flag -- 锁定标志： 0 未锁 1 网银锁 2 本地锁
    ,o.draft_curr_status -- 系统获取到的最新状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.draft_type -- 票据类型： AC01 银票 AC02 商票
    ,o.draft_attr -- DRAFT_ATTR
    ,o.remark -- 票据备注
    ,o.msgid -- 报文编号
    ,o.current_status -- 当前状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.rpdmk -- 贴现/转贴现种类： RM00 买断式 RM01 回购式
    ,o.comrcl_drft_sts -- 票据状态：见【电子商业汇票系统报文格式标准】文档中的票据状态与票据状态编码对照表
    ,o.rcrstp -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,o.apply_trans_id -- 申请类
    ,o.sign_trans_id -- 签收类业务
    ,o.is_recourse -- 是否在追索中： 1 追索中 0 追索完成
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_bms_e_draft_info_bk o
    left join ${iol_schema}.bdms_bms_e_draft_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_e_draft_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_e_draft_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_e_draft_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_e_draft_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_e_draft_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_e_draft_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_e_draft_info_cl;
alter table ${iol_schema}.bdms_bms_e_draft_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_e_draft_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_e_draft_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_e_draft_info_op purge;
drop table ${iol_schema}.bdms_bms_e_draft_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_e_draft_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_e_draft_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
