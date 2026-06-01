/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_dpc_draft_trans_info
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
create table ${iol_schema}.bdms_dpc_draft_trans_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_dpc_draft_trans_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_draft_trans_info_op purge;
drop table ${iol_schema}.bdms_dpc_draft_trans_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_draft_trans_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_draft_trans_info where 0=1;

create table ${iol_schema}.bdms_dpc_draft_trans_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_dpc_draft_trans_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_draft_trans_info_cl(
            id -- ID
            ,contract_id -- 业务协议表ID
            ,protocol_no -- 业务编号（协议号）
            ,details_id -- 业务协议明细表ID
            ,draft_id -- 票据表ID
            ,product_no -- 产品码
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
            ,busi_attr_no -- 业务属性号
            ,product_name -- 产品名称
            ,draft_number -- 票据（包）号
            ,draft_amount -- 票据（包）金额
            ,cust_no -- 客户号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,txn_date -- 交易日期
            ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,req_name -- 请求方名称
            ,req_cert_no -- 请求方社会信用代码
            ,req_account -- 请求方账号
            ,req_mem_no -- 请求方会员编码
            ,req_brh_no -- 请求方机构编号
            ,req_bank_no -- 请求方支付系统行号
            ,req_misc -- 请求方备注
            ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,rcv_name -- 接收方名称
            ,rcv_cert_no -- 接收方社会信用代码
            ,rcv_account -- 接收方账号
            ,rcv_mem_no -- 接收方会员编码
            ,rcv_brh_no -- 接收方机构编号
            ,rcv_bank_no -- 接收方支付系统行号
            ,rcv_misc -- 接收方备注
            ,pay_amount -- 实付金额
            ,pay_type -- 付息方式
            ,pay_interest -- 实付利息
            ,payment_date -- 计息到期日
            ,drawee_name -- 付息人名称
            ,drawee_account -- 付息人帐号
            ,drawee_bank_name -- 付息人开户行
            ,repurchase_rate -- 赎回利率
            ,charge -- 手续费
            ,expenses -- 工本费
            ,rpd_mk -- 是否回购式
            ,agent_name -- 代理人名称
            ,rate -- 利率
            ,payer_sale -- 付息比例
            ,buyer_interest -- 买方付息
            ,interest -- 总利息
            ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
            ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_rsn -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,tenor_days -- 剩余期限
            ,settle_amt -- 结算金额
            ,buy_back_date -- 回购到期日
            ,real_back_date -- 实际回购日
            ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
            ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
            ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
            ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,sig_mk -- 签收意见
            ,acct_date -- 记账日期
            ,trans_name -- 交易名称
            ,last_trans_id -- 上一笔交易TRANS_ID
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
            ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_brh_no -- 库存机构号
            ,top_branch_no -- 总行机构号
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,cd_range -- 子票区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
            ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
            ,create_time -- 创建时间
            ,create_by -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_draft_trans_info_op(
            id -- ID
            ,contract_id -- 业务协议表ID
            ,protocol_no -- 业务编号（协议号）
            ,details_id -- 业务协议明细表ID
            ,draft_id -- 票据表ID
            ,product_no -- 产品码
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
            ,busi_attr_no -- 业务属性号
            ,product_name -- 产品名称
            ,draft_number -- 票据（包）号
            ,draft_amount -- 票据（包）金额
            ,cust_no -- 客户号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,txn_date -- 交易日期
            ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,req_name -- 请求方名称
            ,req_cert_no -- 请求方社会信用代码
            ,req_account -- 请求方账号
            ,req_mem_no -- 请求方会员编码
            ,req_brh_no -- 请求方机构编号
            ,req_bank_no -- 请求方支付系统行号
            ,req_misc -- 请求方备注
            ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,rcv_name -- 接收方名称
            ,rcv_cert_no -- 接收方社会信用代码
            ,rcv_account -- 接收方账号
            ,rcv_mem_no -- 接收方会员编码
            ,rcv_brh_no -- 接收方机构编号
            ,rcv_bank_no -- 接收方支付系统行号
            ,rcv_misc -- 接收方备注
            ,pay_amount -- 实付金额
            ,pay_type -- 付息方式
            ,pay_interest -- 实付利息
            ,payment_date -- 计息到期日
            ,drawee_name -- 付息人名称
            ,drawee_account -- 付息人帐号
            ,drawee_bank_name -- 付息人开户行
            ,repurchase_rate -- 赎回利率
            ,charge -- 手续费
            ,expenses -- 工本费
            ,rpd_mk -- 是否回购式
            ,agent_name -- 代理人名称
            ,rate -- 利率
            ,payer_sale -- 付息比例
            ,buyer_interest -- 买方付息
            ,interest -- 总利息
            ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
            ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_rsn -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,tenor_days -- 剩余期限
            ,settle_amt -- 结算金额
            ,buy_back_date -- 回购到期日
            ,real_back_date -- 实际回购日
            ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
            ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
            ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
            ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,sig_mk -- 签收意见
            ,acct_date -- 记账日期
            ,trans_name -- 交易名称
            ,last_trans_id -- 上一笔交易TRANS_ID
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
            ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_brh_no -- 库存机构号
            ,top_branch_no -- 总行机构号
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,cd_range -- 子票区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
            ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
            ,create_time -- 创建时间
            ,create_by -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 业务协议表ID
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 业务编号（协议号）
    ,nvl(n.details_id, o.details_id) as details_id -- 业务协议明细表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.product_no, o.product_no) as product_no -- 产品码
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
    ,nvl(n.busi_attr_no, o.busi_attr_no) as busi_attr_no -- 业务属性号
    ,nvl(n.product_name, o.product_name) as product_name -- 产品名称
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据（包）号
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据（包）金额
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 交易日期
    ,nvl(n.req_type, o.req_type) as req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,nvl(n.req_name, o.req_name) as req_name -- 请求方名称
    ,nvl(n.req_cert_no, o.req_cert_no) as req_cert_no -- 请求方社会信用代码
    ,nvl(n.req_account, o.req_account) as req_account -- 请求方账号
    ,nvl(n.req_mem_no, o.req_mem_no) as req_mem_no -- 请求方会员编码
    ,nvl(n.req_brh_no, o.req_brh_no) as req_brh_no -- 请求方机构编号
    ,nvl(n.req_bank_no, o.req_bank_no) as req_bank_no -- 请求方支付系统行号
    ,nvl(n.req_misc, o.req_misc) as req_misc -- 请求方备注
    ,nvl(n.rcv_type, o.rcv_type) as rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,nvl(n.rcv_name, o.rcv_name) as rcv_name -- 接收方名称
    ,nvl(n.rcv_cert_no, o.rcv_cert_no) as rcv_cert_no -- 接收方社会信用代码
    ,nvl(n.rcv_account, o.rcv_account) as rcv_account -- 接收方账号
    ,nvl(n.rcv_mem_no, o.rcv_mem_no) as rcv_mem_no -- 接收方会员编码
    ,nvl(n.rcv_brh_no, o.rcv_brh_no) as rcv_brh_no -- 接收方机构编号
    ,nvl(n.rcv_bank_no, o.rcv_bank_no) as rcv_bank_no -- 接收方支付系统行号
    ,nvl(n.rcv_misc, o.rcv_misc) as rcv_misc -- 接收方备注
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 实付金额
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 付息方式
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 实付利息
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 计息到期日
    ,nvl(n.drawee_name, o.drawee_name) as drawee_name -- 付息人名称
    ,nvl(n.drawee_account, o.drawee_account) as drawee_account -- 付息人帐号
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付息人开户行
    ,nvl(n.repurchase_rate, o.repurchase_rate) as repurchase_rate -- 赎回利率
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.expenses, o.expenses) as expenses -- 工本费
    ,nvl(n.rpd_mk, o.rpd_mk) as rpd_mk -- 是否回购式
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代理人名称
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.payer_sale, o.payer_sale) as payer_sale -- 付息比例
    ,nvl(n.buyer_interest, o.buyer_interest) as buyer_interest -- 买方付息
    ,nvl(n.interest, o.interest) as interest -- 总利息
    ,nvl(n.move_trs_type, o.move_trs_type) as move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,nvl(n.conf_pay_type, o.conf_pay_type) as conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,nvl(n.conf_pay_add_type, o.conf_pay_add_type) as conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,nvl(n.conf_pay_rst, o.conf_pay_rst) as conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,nvl(n.stop_pay_type, o.stop_pay_type) as stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,nvl(n.stop_pay_rsn, o.stop_pay_rsn) as stop_pay_rsn -- 止付原因
    ,nvl(n.relieve_stp_type, o.relieve_stp_type) as relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,nvl(n.relieve_stp_rsn, o.relieve_stp_rsn) as relieve_stp_rsn -- 解除止付原因
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 剩余期限
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.buy_back_date, o.buy_back_date) as buy_back_date -- 回购到期日
    ,nvl(n.real_back_date, o.real_back_date) as real_back_date -- 实际回购日
    ,nvl(n.buy_back_status, o.buy_back_status) as buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,nvl(n.exchge_status, o.exchge_status) as exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,nvl(n.prmt_result, o.prmt_result) as prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,nvl(n.prmt_refuse_rsn, o.prmt_refuse_rsn) as prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,nvl(n.prmt_stl_rst, o.prmt_stl_rst) as prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,nvl(n.refuse_rsn, o.refuse_rsn) as refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 签收意见
    ,nvl(n.acct_date, o.acct_date) as acct_date -- 记账日期
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 交易名称
    ,nvl(n.last_trans_id, o.last_trans_id) as last_trans_id -- 上一笔交易TRANS_ID
    ,nvl(n.inner_flag, o.inner_flag) as inner_flag -- 是否系统内： 0 否 1 是
    ,nvl(n.trans_status, o.trans_status) as trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 记账机构号
    ,nvl(n.store_brh_no, o.store_brh_no) as store_brh_no -- 库存机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注域
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.product_type, o.product_type) as product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,nvl(n.req_buss_type, o.req_buss_type) as req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,nvl(n.rcv_buss_type, o.rcv_buss_type) as rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,nvl(n.req_dist_tp, o.req_dist_tp) as req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,nvl(n.rcv_dist_tp, o.rcv_dist_tp) as rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_by, o.create_by) as create_by -- 
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
from (select * from ${iol_schema}.bdms_dpc_draft_trans_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_dpc_draft_trans_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.protocol_no <> n.protocol_no
        or o.details_id <> n.details_id
        or o.draft_id <> n.draft_id
        or o.product_no <> n.product_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.busi_type <> n.busi_type
        or o.busi_attr_no <> n.busi_attr_no
        or o.product_name <> n.product_name
        or o.draft_number <> n.draft_number
        or o.draft_amount <> n.draft_amount
        or o.cust_no <> n.cust_no
        or o.trade_direct <> n.trade_direct
        or o.txn_date <> n.txn_date
        or o.req_type <> n.req_type
        or o.req_name <> n.req_name
        or o.req_cert_no <> n.req_cert_no
        or o.req_account <> n.req_account
        or o.req_mem_no <> n.req_mem_no
        or o.req_brh_no <> n.req_brh_no
        or o.req_bank_no <> n.req_bank_no
        or o.req_misc <> n.req_misc
        or o.rcv_type <> n.rcv_type
        or o.rcv_name <> n.rcv_name
        or o.rcv_cert_no <> n.rcv_cert_no
        or o.rcv_account <> n.rcv_account
        or o.rcv_mem_no <> n.rcv_mem_no
        or o.rcv_brh_no <> n.rcv_brh_no
        or o.rcv_bank_no <> n.rcv_bank_no
        or o.rcv_misc <> n.rcv_misc
        or o.pay_amount <> n.pay_amount
        or o.pay_type <> n.pay_type
        or o.pay_interest <> n.pay_interest
        or o.payment_date <> n.payment_date
        or o.drawee_name <> n.drawee_name
        or o.drawee_account <> n.drawee_account
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.repurchase_rate <> n.repurchase_rate
        or o.charge <> n.charge
        or o.expenses <> n.expenses
        or o.rpd_mk <> n.rpd_mk
        or o.agent_name <> n.agent_name
        or o.rate <> n.rate
        or o.payer_sale <> n.payer_sale
        or o.buyer_interest <> n.buyer_interest
        or o.interest <> n.interest
        or o.move_trs_type <> n.move_trs_type
        or o.conf_pay_type <> n.conf_pay_type
        or o.conf_pay_add_type <> n.conf_pay_add_type
        or o.conf_pay_rst <> n.conf_pay_rst
        or o.stop_pay_type <> n.stop_pay_type
        or o.stop_pay_rsn <> n.stop_pay_rsn
        or o.relieve_stp_type <> n.relieve_stp_type
        or o.relieve_stp_rsn <> n.relieve_stp_rsn
        or o.tenor_days <> n.tenor_days
        or o.settle_amt <> n.settle_amt
        or o.buy_back_date <> n.buy_back_date
        or o.real_back_date <> n.real_back_date
        or o.buy_back_status <> n.buy_back_status
        or o.exchge_status <> n.exchge_status
        or o.prmt_result <> n.prmt_result
        or o.prmt_refuse_rsn <> n.prmt_refuse_rsn
        or o.prmt_stl_rst <> n.prmt_stl_rst
        or o.refuse_rsn <> n.refuse_rsn
        or o.sig_mk <> n.sig_mk
        or o.acct_date <> n.acct_date
        or o.trans_name <> n.trans_name
        or o.last_trans_id <> n.last_trans_id
        or o.inner_flag <> n.inner_flag
        or o.trans_status <> n.trans_status
        or o.settle_type <> n.settle_type
        or o.trans_branch_no <> n.trans_branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.store_brh_no <> n.store_brh_no
        or o.top_branch_no <> n.top_branch_no
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.cd_range <> n.cd_range
        or o.product_type <> n.product_type
        or o.req_buss_type <> n.req_buss_type
        or o.rcv_buss_type <> n.rcv_buss_type
        or o.req_dist_tp <> n.req_dist_tp
        or o.rcv_dist_tp <> n.rcv_dist_tp
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_dpc_draft_trans_info_cl(
            id -- ID
            ,contract_id -- 业务协议表ID
            ,protocol_no -- 业务编号（协议号）
            ,details_id -- 业务协议明细表ID
            ,draft_id -- 票据表ID
            ,product_no -- 产品码
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
            ,busi_attr_no -- 业务属性号
            ,product_name -- 产品名称
            ,draft_number -- 票据（包）号
            ,draft_amount -- 票据（包）金额
            ,cust_no -- 客户号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,txn_date -- 交易日期
            ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,req_name -- 请求方名称
            ,req_cert_no -- 请求方社会信用代码
            ,req_account -- 请求方账号
            ,req_mem_no -- 请求方会员编码
            ,req_brh_no -- 请求方机构编号
            ,req_bank_no -- 请求方支付系统行号
            ,req_misc -- 请求方备注
            ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,rcv_name -- 接收方名称
            ,rcv_cert_no -- 接收方社会信用代码
            ,rcv_account -- 接收方账号
            ,rcv_mem_no -- 接收方会员编码
            ,rcv_brh_no -- 接收方机构编号
            ,rcv_bank_no -- 接收方支付系统行号
            ,rcv_misc -- 接收方备注
            ,pay_amount -- 实付金额
            ,pay_type -- 付息方式
            ,pay_interest -- 实付利息
            ,payment_date -- 计息到期日
            ,drawee_name -- 付息人名称
            ,drawee_account -- 付息人帐号
            ,drawee_bank_name -- 付息人开户行
            ,repurchase_rate -- 赎回利率
            ,charge -- 手续费
            ,expenses -- 工本费
            ,rpd_mk -- 是否回购式
            ,agent_name -- 代理人名称
            ,rate -- 利率
            ,payer_sale -- 付息比例
            ,buyer_interest -- 买方付息
            ,interest -- 总利息
            ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
            ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_rsn -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,tenor_days -- 剩余期限
            ,settle_amt -- 结算金额
            ,buy_back_date -- 回购到期日
            ,real_back_date -- 实际回购日
            ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
            ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
            ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
            ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,sig_mk -- 签收意见
            ,acct_date -- 记账日期
            ,trans_name -- 交易名称
            ,last_trans_id -- 上一笔交易TRANS_ID
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
            ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_brh_no -- 库存机构号
            ,top_branch_no -- 总行机构号
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,cd_range -- 子票区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
            ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
            ,create_time -- 创建时间
            ,create_by -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_dpc_draft_trans_info_op(
            id -- ID
            ,contract_id -- 业务协议表ID
            ,protocol_no -- 业务编号（协议号）
            ,details_id -- 业务协议明细表ID
            ,draft_id -- 票据表ID
            ,product_no -- 产品码
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
            ,busi_attr_no -- 业务属性号
            ,product_name -- 产品名称
            ,draft_number -- 票据（包）号
            ,draft_amount -- 票据（包）金额
            ,cust_no -- 客户号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,txn_date -- 交易日期
            ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,req_name -- 请求方名称
            ,req_cert_no -- 请求方社会信用代码
            ,req_account -- 请求方账号
            ,req_mem_no -- 请求方会员编码
            ,req_brh_no -- 请求方机构编号
            ,req_bank_no -- 请求方支付系统行号
            ,req_misc -- 请求方备注
            ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
            ,rcv_name -- 接收方名称
            ,rcv_cert_no -- 接收方社会信用代码
            ,rcv_account -- 接收方账号
            ,rcv_mem_no -- 接收方会员编码
            ,rcv_brh_no -- 接收方机构编号
            ,rcv_bank_no -- 接收方支付系统行号
            ,rcv_misc -- 接收方备注
            ,pay_amount -- 实付金额
            ,pay_type -- 付息方式
            ,pay_interest -- 实付利息
            ,payment_date -- 计息到期日
            ,drawee_name -- 付息人名称
            ,drawee_account -- 付息人帐号
            ,drawee_bank_name -- 付息人开户行
            ,repurchase_rate -- 赎回利率
            ,charge -- 手续费
            ,expenses -- 工本费
            ,rpd_mk -- 是否回购式
            ,agent_name -- 代理人名称
            ,rate -- 利率
            ,payer_sale -- 付息比例
            ,buyer_interest -- 买方付息
            ,interest -- 总利息
            ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
            ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
            ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
            ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
            ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
            ,stop_pay_rsn -- 止付原因
            ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
            ,relieve_stp_rsn -- 解除止付原因
            ,tenor_days -- 剩余期限
            ,settle_amt -- 结算金额
            ,buy_back_date -- 回购到期日
            ,real_back_date -- 实际回购日
            ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
            ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
            ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
            ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
            ,refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
            ,sig_mk -- 签收意见
            ,acct_date -- 记账日期
            ,trans_name -- 交易名称
            ,last_trans_id -- 上一笔交易TRANS_ID
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
            ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_brh_no -- 库存机构号
            ,top_branch_no -- 总行机构号
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注域
            ,cd_range -- 子票区间
            ,product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
            ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
            ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
            ,create_time -- 创建时间
            ,create_by -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 业务协议表ID
    ,o.protocol_no -- 业务编号（协议号）
    ,o.details_id -- 业务协议明细表ID
    ,o.draft_id -- 票据表ID
    ,o.product_no -- 产品码
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.busi_type -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
    ,o.busi_attr_no -- 业务属性号
    ,o.product_name -- 产品名称
    ,o.draft_number -- 票据（包）号
    ,o.draft_amount -- 票据（包）金额
    ,o.cust_no -- 客户号
    ,o.trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,o.txn_date -- 交易日期
    ,o.req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,o.req_name -- 请求方名称
    ,o.req_cert_no -- 请求方社会信用代码
    ,o.req_account -- 请求方账号
    ,o.req_mem_no -- 请求方会员编码
    ,o.req_brh_no -- 请求方机构编号
    ,o.req_bank_no -- 请求方支付系统行号
    ,o.req_misc -- 请求方备注
    ,o.rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,o.rcv_name -- 接收方名称
    ,o.rcv_cert_no -- 接收方社会信用代码
    ,o.rcv_account -- 接收方账号
    ,o.rcv_mem_no -- 接收方会员编码
    ,o.rcv_brh_no -- 接收方机构编号
    ,o.rcv_bank_no -- 接收方支付系统行号
    ,o.rcv_misc -- 接收方备注
    ,o.pay_amount -- 实付金额
    ,o.pay_type -- 付息方式
    ,o.pay_interest -- 实付利息
    ,o.payment_date -- 计息到期日
    ,o.drawee_name -- 付息人名称
    ,o.drawee_account -- 付息人帐号
    ,o.drawee_bank_name -- 付息人开户行
    ,o.repurchase_rate -- 赎回利率
    ,o.charge -- 手续费
    ,o.expenses -- 工本费
    ,o.rpd_mk -- 是否回购式
    ,o.agent_name -- 代理人名称
    ,o.rate -- 利率
    ,o.payer_sale -- 付息比例
    ,o.buyer_interest -- 买方付息
    ,o.interest -- 总利息
    ,o.move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,o.conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,o.conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,o.conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,o.stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,o.stop_pay_rsn -- 止付原因
    ,o.relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,o.relieve_stp_rsn -- 解除止付原因
    ,o.tenor_days -- 剩余期限
    ,o.settle_amt -- 结算金额
    ,o.buy_back_date -- 回购到期日
    ,o.real_back_date -- 实际回购日
    ,o.buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,o.exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,o.prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,o.prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,o.prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,o.refuse_rsn -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,o.sig_mk -- 签收意见
    ,o.acct_date -- 记账日期
    ,o.trans_name -- 交易名称
    ,o.last_trans_id -- 上一笔交易TRANS_ID
    ,o.inner_flag -- 是否系统内： 0 否 1 是
    ,o.trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,o.settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,o.trans_branch_no -- 交易机构号
    ,o.acct_branch_no -- 记账机构号
    ,o.store_brh_no -- 库存机构号
    ,o.top_branch_no -- 总行机构号
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注域
    ,o.cd_range -- 子票区间
    ,o.product_type -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,o.req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,o.rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,o.req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,o.rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,o.create_time -- 创建时间
    ,o.create_by -- 
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
from ${iol_schema}.bdms_dpc_draft_trans_info_bk o
    left join ${iol_schema}.bdms_dpc_draft_trans_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_dpc_draft_trans_info_cl d
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
--truncate table ${iol_schema}.bdms_dpc_draft_trans_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_dpc_draft_trans_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_dpc_draft_trans_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_dpc_draft_trans_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_dpc_draft_trans_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_dpc_draft_trans_info_cl;
alter table ${iol_schema}.bdms_dpc_draft_trans_info exchange partition p_20991231 with table ${iol_schema}.bdms_dpc_draft_trans_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_dpc_draft_trans_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_dpc_draft_trans_info_op purge;
drop table ${iol_schema}.bdms_dpc_draft_trans_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_dpc_draft_trans_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_dpc_draft_trans_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
