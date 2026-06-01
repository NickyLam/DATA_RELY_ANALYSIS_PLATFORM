/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_e_draft_trans
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_e_draft_trans_ex purge;
alter table ${iol_schema}.bdms_bms_e_draft_trans add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_bms_e_draft_trans;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_bms_e_draft_trans_ex nologging
compress
as
select * from ${iol_schema}.bdms_bms_e_draft_trans where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_bms_e_draft_trans_ex(
    id -- ID
    ,edraft_id -- 票据ID
    ,last_trans_id -- 上手交易id
    ,trans_no -- 交易编号
    ,trans_name -- 交易状态
    ,status -- 票据状态
    ,msg_type -- 信息类型： 01 出票登记 02 承兑 03 收票 04 撤票 05 背书 06 贴现 07 贴现赎回 08 转贴现 09 转贴现赎回 10 再贴现 11 再贴现赎回 12 背书保证 13 承兑人保证 14 出票人保证 15 质押 16 质押解除 17 提示付款 18 逾期提示付款 19 追索通知 20 清偿确认 21 追索清偿签收通知 22 网银端照票申请查询
    ,electric_draft_id -- 电子票据号码
    ,req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,req_name -- 请求方名称REQ_NAME
    ,req_brch_code -- 请求方组织机构代码
    ,req_account -- 请求方账号
    ,req_bank_id -- 请求方开户行行号
    ,rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,rcv_name -- 接收方名称
    ,rcv_brch_code -- 接收方组织机构代码
    ,rcv_account -- 接收方账号
    ,rcv_bank_id -- 接收方开户行行号
    ,sign_date -- 签收日期
    ,onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,rate -- 利率
    ,repurchase_rate -- 赎回利率
    ,amount -- 金额
    ,repurchase_amt -- 赎回实付金额
    ,discount_type -- 贴现种类： RM00 买断式 RM01 回购式
    ,repurchase_end_date -- 赎回截止日
    ,repurchase_begin_date -- 赎回开放日
    ,req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,prompt_pay_amt -- 提示付款金额
    ,reject_code -- 拒付代码
    ,reject_info -- 拒付备注信息
    ,overdue_reason -- 逾期原因说明
    ,holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,solutor_date -- 清偿日期
    ,txn_ctrct_nb -- 交易合同编号
    ,invoice_nb -- 发票号码
    ,rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,btch_nb -- 批次号
    ,sign_flag -- 签收状态： 0 拒签 1 签收
    ,reply_flag -- 回复标志： 0 否 1 是
    ,rec_crt_ts -- 记录插入时间
    ,req_agency_bank_id -- 请求方承接行行号
    ,rcv_agency_bank_id -- 接收方承接行行号
    ,guarntr_adr -- 保证人地址
    ,ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,ucondl_prms_mk -- 到期无条件支付承诺
    ,proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,proxy_req -- 代理申请标识： PP00 开户机构代理申请签章 PP01 票据当事人自己签章
    ,credit_rate -- 信用等级
    ,credit_rate_agency -- 评级机构
    ,credit_rate_due_date -- 评级到期日
    ,req_remark -- 请求方备注
    ,rcv_remark -- 接收方备注
    ,aoa_account -- 入账账号
    ,aoa_bank_id -- 入账行号
    ,have_type -- 持票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,have_brch_code -- 持票人组织机构代码
    ,have_name -- 持票人名称
    ,hava_account -- 持票人账号
    ,hava_bank_id -- 持票人开户行号
    ,seq_no -- 支付交易序号
    ,is_lock -- 是否锁定： 0 否 1 是
    ,return_code -- 返回码
    ,return_msg -- 返回信息
    ,is_inner -- 是否系统内： 0 否 1 是
    ,lastbuy_trans_id -- 上手买入交易ID
    ,last_upd_txn_oprid -- 操作柜员
    ,details_id -- 交易明细ID
    ,orgnl_msg_id -- 原报文ID
    ,reserve1 -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,edraft_id -- 票据ID
    ,last_trans_id -- 上手交易id
    ,trans_no -- 交易编号
    ,trans_name -- 交易状态
    ,status -- 票据状态
    ,msg_type -- 信息类型： 01 出票登记 02 承兑 03 收票 04 撤票 05 背书 06 贴现 07 贴现赎回 08 转贴现 09 转贴现赎回 10 再贴现 11 再贴现赎回 12 背书保证 13 承兑人保证 14 出票人保证 15 质押 16 质押解除 17 提示付款 18 逾期提示付款 19 追索通知 20 清偿确认 21 追索清偿签收通知 22 网银端照票申请查询
    ,electric_draft_id -- 电子票据号码
    ,req_type -- 请求方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,req_name -- 请求方名称REQ_NAME
    ,req_brch_code -- 请求方组织机构代码
    ,req_account -- 请求方账号
    ,req_bank_id -- 请求方开户行行号
    ,rcv_type -- 接收方类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,rcv_name -- 接收方名称
    ,rcv_brch_code -- 接收方组织机构代码
    ,rcv_account -- 接收方账号
    ,rcv_bank_id -- 接收方开户行行号
    ,sign_date -- 签收日期
    ,onl_stlm_flag -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,transfer_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,rate -- 利率
    ,repurchase_rate -- 赎回利率
    ,amount -- 金额
    ,repurchase_amt -- 赎回实付金额
    ,discount_type -- 贴现种类： RM00 买断式 RM01 回购式
    ,repurchase_end_date -- 赎回截止日
    ,repurchase_begin_date -- 赎回开放日
    ,req_date -- 申请日期、提示付款、逾期提示付款、追索通知日期
    ,prompt_pay_amt -- 提示付款金额
    ,reject_code -- 拒付代码
    ,reject_info -- 拒付备注信息
    ,overdue_reason -- 逾期原因说明
    ,holder_type -- 追索类型： RT00 拒付追索 RT01 非拒付追索
    ,solutor_date -- 清偿日期
    ,txn_ctrct_nb -- 交易合同编号
    ,invoice_nb -- 发票号码
    ,rcrs_rsn_cd -- 追索理由代码： RC00 承兑人被依法宣告破产 RC01 承兑人因违法被责令终止活动
    ,btch_nb -- 批次号
    ,sign_flag -- 签收状态： 0 拒签 1 签收
    ,reply_flag -- 回复标志： 0 否 1 是
    ,rec_crt_ts -- 记录插入时间
    ,req_agency_bank_id -- 请求方承接行行号
    ,rcv_agency_bank_id -- 接收方承接行行号
    ,guarntr_adr -- 保证人地址
    ,ucondl_consign_mk -- 到期无条件支付委托： CC00 无条件 CC01 条件
    ,ucondl_prms_mk -- 到期无条件支付承诺
    ,proxy_sign -- 代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,proxy_req -- 代理申请标识： PP00 开户机构代理申请签章 PP01 票据当事人自己签章
    ,credit_rate -- 信用等级
    ,credit_rate_agency -- 评级机构
    ,credit_rate_due_date -- 评级到期日
    ,req_remark -- 请求方备注
    ,rcv_remark -- 接收方备注
    ,aoa_account -- 入账账号
    ,aoa_bank_id -- 入账行号
    ,have_type -- 持票人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,have_brch_code -- 持票人组织机构代码
    ,have_name -- 持票人名称
    ,hava_account -- 持票人账号
    ,hava_bank_id -- 持票人开户行号
    ,seq_no -- 支付交易序号
    ,is_lock -- 是否锁定： 0 否 1 是
    ,return_code -- 返回码
    ,return_msg -- 返回信息
    ,is_inner -- 是否系统内： 0 否 1 是
    ,lastbuy_trans_id -- 上手买入交易ID
    ,last_upd_txn_oprid -- 操作柜员
    ,details_id -- 交易明细ID
    ,orgnl_msg_id -- 原报文ID
    ,reserve1 -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_bms_e_draft_trans
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_bms_e_draft_trans exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_e_draft_trans_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_e_draft_trans to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_bms_e_draft_trans_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_e_draft_trans',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);