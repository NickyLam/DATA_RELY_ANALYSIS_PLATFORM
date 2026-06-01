/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_dpc_draft_trans_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_dpc_draft_trans_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_dpc_draft_trans_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_dpc_draft_trans_info(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 业务协议表ID
    ,protocol_no varchar2(60) -- 业务编号（协议号）
    ,details_id varchar2(60) -- 业务协议明细表ID
    ,draft_id varchar2(60) -- 票据表ID
    ,product_no varchar2(12) -- 产品码
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,busi_type varchar2(5) -- 交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
    ,busi_attr_no varchar2(5) -- 业务属性号
    ,product_name varchar2(150) -- 产品名称
    ,draft_number varchar2(45) -- 票据（包）号
    ,draft_amount number(18,2) -- 票据（包）金额
    ,cust_no varchar2(30) -- 客户号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,txn_date varchar2(12) -- 交易日期
    ,req_type varchar2(6) -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,req_name varchar2(150) -- 请求方名称
    ,req_cert_no varchar2(27) -- 请求方社会信用代码
    ,req_account varchar2(48) -- 请求方账号
    ,req_mem_no varchar2(15) -- 请求方会员编码
    ,req_brh_no varchar2(15) -- 请求方机构编号
    ,req_bank_no varchar2(18) -- 请求方支付系统行号
    ,req_misc varchar2(675) -- 请求方备注
    ,rcv_type varchar2(6) -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,rcv_name varchar2(150) -- 接收方名称
    ,rcv_cert_no varchar2(27) -- 接收方社会信用代码
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_mem_no varchar2(15) -- 接收方会员编码
    ,rcv_brh_no varchar2(15) -- 接收方机构编号
    ,rcv_bank_no varchar2(18) -- 接收方支付系统行号
    ,rcv_misc varchar2(675) -- 接收方备注
    ,pay_amount number(18,2) -- 实付金额
    ,pay_type varchar2(2) -- 付息方式
    ,pay_interest number(18,2) -- 实付利息
    ,payment_date varchar2(12) -- 计息到期日
    ,drawee_name varchar2(270) -- 付息人名称
    ,drawee_account varchar2(48) -- 付息人帐号
    ,drawee_bank_name varchar2(270) -- 付息人开户行
    ,repurchase_rate number(7,6) -- 赎回利率
    ,charge number(12,2) -- 手续费
    ,expenses number(12,2) -- 工本费
    ,rpd_mk varchar2(6) -- 是否回购式
    ,agent_name varchar2(270) -- 代理人名称
    ,rate number(7,6) -- 利率
    ,payer_sale number(8,5) -- 付息比例
    ,buyer_interest number(18,2) -- 买方付息
    ,interest number(18,2) -- 总利息
    ,move_trs_type varchar2(6) -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type varchar2(6) -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type varchar2(6) -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst varchar2(6) -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,stop_pay_type varchar2(6) -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn varchar2(675) -- 止付原因
    ,relieve_stp_type varchar2(6) -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn varchar2(675) -- 解除止付原因
    ,tenor_days number(8,0) -- 剩余期限
    ,settle_amt number(18,2) -- 结算金额
    ,buy_back_date varchar2(12) -- 回购到期日
    ,real_back_date varchar2(12) -- 实际回购日
    ,buy_back_status varchar2(8) -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,exchge_status varchar2(6) -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,prmt_result varchar2(6) -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,prmt_refuse_rsn varchar2(6) -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,prmt_stl_rst varchar2(6) -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,refuse_rsn varchar2(6) -- 付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,sig_mk varchar2(6) -- 签收意见
    ,acct_date varchar2(12) -- 记账日期
    ,trans_name varchar2(75) -- 交易名称
    ,last_trans_id varchar2(60) -- 上一笔交易TRANS_ID
    ,inner_flag varchar2(3) -- 是否系统内： 0 否 1 是
    ,trans_status varchar2(9) -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,settle_type varchar2(2) -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,trans_branch_no varchar2(30) -- 交易机构号
    ,acct_branch_no varchar2(30) -- 记账机构号
    ,store_brh_no varchar2(30) -- 库存机构号
    ,top_branch_no varchar2(30) -- 总行机构号
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注域
    ,cd_range varchar2(38) -- 子票区间
    ,product_type varchar2(6) -- 票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,req_buss_type varchar2(6) -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type varchar2(6) -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_dist_tp varchar2(6) -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp varchar2(6) -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 
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
grant select on ${iol_schema}.bdms_dpc_draft_trans_info to ${iml_schema};
grant select on ${iol_schema}.bdms_dpc_draft_trans_info to ${icl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_trans_info to ${idl_schema};
grant select on ${iol_schema}.bdms_dpc_draft_trans_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_dpc_draft_trans_info is '登记中心票据流转信息表';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.id is 'ID';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.contract_id is '业务协议表ID';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.protocol_no is '业务编号（协议号）';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.details_id is '业务协议明细表ID';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.product_no is '产品码';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.busi_type is '交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.busi_attr_no is '业务属性号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.product_name is '产品名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.cust_no is '客户号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.trade_direct is '交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.txn_date is '交易日期';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_type is '请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_cert_no is '请求方社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_mem_no is '请求方会员编码';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_brh_no is '请求方机构编号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_bank_no is '请求方支付系统行号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_misc is '请求方备注';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_type is '接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_cert_no is '接收方社会信用代码';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_mem_no is '接收方会员编码';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_brh_no is '接收方机构编号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_bank_no is '接收方支付系统行号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_misc is '接收方备注';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.pay_amount is '实付金额';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.pay_type is '付息方式';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.pay_interest is '实付利息';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.payment_date is '计息到期日';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.drawee_name is '付息人名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.drawee_account is '付息人帐号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.drawee_bank_name is '付息人开户行';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.charge is '手续费';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.expenses is '工本费';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rpd_mk is '是否回购式';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.agent_name is '代理人名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rate is '利率';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.payer_sale is '付息比例';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.buyer_interest is '买方付息';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.interest is '总利息';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.move_trs_type is '库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.conf_pay_type is '付款确认类型： VM01 影像验证 VM02 实物验证';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.conf_pay_add_type is '付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.conf_pay_rst is '付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.stop_pay_type is '止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.stop_pay_rsn is '止付原因';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.relieve_stp_type is '解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.relieve_stp_rsn is '解除止付原因';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.buy_back_date is '回购到期日';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.real_back_date is '实际回购日';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.buy_back_status is '回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.exchge_status is '置换状态： ES01 被他票替换 ES02 替换他票';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.prmt_result is '提示付款应答结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.prmt_refuse_rsn is '提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.prmt_stl_rst is '提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.refuse_rsn is '付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.sig_mk is '签收意见';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.acct_date is '记账日期';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.trans_name is '交易名称';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.last_trans_id is '上一笔交易TRANS_ID';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.inner_flag is '是否系统内： 0 否 1 是';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.trans_status is '交易状态： TS0000 无效 TS0001 有效 TS0002 完成';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.settle_type is '结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.trans_branch_no is '交易机构号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.acct_branch_no is '记账机构号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.store_brh_no is '库存机构号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.misc is '备注域';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.product_type is '票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_buss_type is '请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_buss_type is '接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.req_dist_tp is '请求方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.rcv_dist_tp is '接收方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.create_by is '';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_dpc_draft_trans_info.etl_timestamp is 'ETL处理时间戳';
