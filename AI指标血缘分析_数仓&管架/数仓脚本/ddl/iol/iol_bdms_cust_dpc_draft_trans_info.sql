/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cust_dpc_draft_trans_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cust_dpc_draft_trans_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_dpc_draft_trans_info(
    id varchar2(60) -- ID
    ,draft_id varchar2(60) -- 票据表ID
    ,apply_id varchar2(60) -- 签收表ID
    ,product_no varchar2(12) -- 产品码
    ,draft_attr varchar2(2) -- 票据介质： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银承 2 商承
    ,busi_type varchar2(5) -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
    ,busi_attr_no varchar2(5) -- 业务属性号
    ,product_name varchar2(150) -- 产品名称
    ,product_type varchar2(6) -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,draft_number varchar2(45) -- 票据（包）号
    ,cd_range varchar2(38) -- 子票区间
    ,draft_amount number(18,2) -- 票据（包）金额
    ,buss_flag varchar2(8) -- 业务方向： 01 申请 02 接收 03 通知
    ,txn_date varchar2(12) -- 交易日期
    ,req_buss_type varchar2(6) -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,req_name varchar2(270) -- 请求方名称
    ,req_cert_no varchar2(27) -- 请求方社会信用代码
    ,req_dist_tp varchar2(6) -- 请求方识别类型： DT01 票据账户 DT02 银行账户
    ,req_account varchar2(48) -- 请求方账号
    ,req_bank_no varchar2(18) -- 请求方开户行行号
    ,req_mem_no varchar2(15) -- 请求方会员代码
    ,req_brh_no varchar2(15) -- 请求方机构代码
    ,req_misc varchar2(675) -- 请求方备注
    ,rcv_buss_type varchar2(6) -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,rcv_name varchar2(270) -- 接收方名称
    ,rcv_cert_no varchar2(27) -- 接收方社会信用代码
    ,rcv_dist_tp varchar2(6) -- 接收方识别类型： DT01 票据账户 DT02 银行账户
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_bank_no varchar2(18) -- 接收方开户行行号
    ,rcv_mem_no varchar2(15) -- 接收方会员代码
    ,rcv_brh_no varchar2(15) -- 接收方机构代码
    ,rcv_misc varchar2(675) -- 接收方备注
    ,rate number(7,6) -- 贴现利率
    ,pay_amount number(18,2) -- 贴现实付金额
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,sttlm_mk varchar2(6) -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,back_begin_date varchar2(12) -- 贴现赎回开放日
    ,back_end_date varchar2(12) -- 贴现赎回截止日
    ,back_rate number(7,6) -- 赎回利率
    ,back_amt number(18,2) -- 赎回金额
    ,trade_conct_no varchar2(225) -- 交易合同编号
    ,invc_nb varchar2(225) -- 发票号码
    ,btch_nb varchar2(675) -- 批次号
    ,aoa_account varchar2(48) -- 入账账号
    ,aoa_bank_no varchar2(18) -- 入账行号
    ,sign_mk varchar2(6) -- 应答标识： SU00 同意 SU01 拒绝
    ,sign_date varchar2(12) -- 签收日期
    ,refuse_reason_code varchar2(6) -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
    ,refuse_remark varchar2(675) -- 拒付备注信息
    ,recovery_type varchar2(6) -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
    ,pay_type varchar2(2) -- 付息方式
    ,pay_interest number(18,2) -- 实付利息
    ,payment_date varchar2(12) -- 计息到期日
    ,interest_payer_name varchar2(270) -- 付息人名称
    ,interest_payer_account varchar2(48) -- 付息人帐号
    ,interest_payer_bank_name varchar2(270) -- 付息人开户行行名
    ,charge number(12,2) -- 手续费
    ,expenses number(12,2) -- 工本费
    ,agent_name varchar2(270) -- 代理人名称
    ,payer_sale number(8,5) -- 付息比例
    ,buyer_interest number(18,2) -- 买方付息
    ,interest number(18,2) -- 总利息
    ,stop_pay_type varchar2(6) -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn varchar2(675) -- 止付原因
    ,relieve_stp_type varchar2(6) -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn varchar2(675) -- 解除止付原因
    ,tenor_days number(8,0) -- 剩余期限
    ,settle_amt number(18,2) -- 结算金额
    ,inner_flag varchar2(3) -- 是否系统内： 0 否 1 是
    ,trans_status varchar2(9) -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,msg_status varchar2(3) -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,process_code varchar2(36) -- 报文处理码
    ,process_msg varchar2(1200) -- 报文处理信息
    ,settle_result varchar2(6) -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,settle_date varchar2(12) -- 结算日期
    ,settle_type varchar2(6) -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,create_opr varchar2(15) -- 创建人
    ,create_time varchar2(21) -- 创建时间
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(384) -- 备注域
    ,reserve1 varchar2(450) -- 备用字段1
    ,reserve2 varchar2(450) -- 备用字段2
    ,reserve3 varchar2(450) -- 备用字段3
    ,req_account_name varchar2(675) -- 请求方账号名称
    ,rcv_account_name varchar2(675) -- 接收方账号名称
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
grant select on ${iol_schema}.bdms_cust_dpc_draft_trans_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_trans_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_trans_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cust_dpc_draft_trans_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cust_dpc_draft_trans_info is '企业登记中心票据流转信息表';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.id is 'ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.apply_id is '签收表ID';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.product_no is '产品码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.draft_attr is '票据介质： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.draft_type is '票据类型： 1 银承 2 商承';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.busi_type is '交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.busi_attr_no is '业务属性号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.product_name is '产品名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.product_type is '票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.buss_flag is '业务方向： 01 申请 02 接收 03 通知';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.txn_date is '交易日期';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_buss_type is '请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_cert_no is '请求方社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_dist_tp is '请求方识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_bank_no is '请求方开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_mem_no is '请求方会员代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_brh_no is '请求方机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_misc is '请求方备注';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_buss_type is '接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_cert_no is '接收方社会信用代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_dist_tp is '接收方识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_bank_no is '接收方开户行行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_mem_no is '接收方会员代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_brh_no is '接收方机构代码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_misc is '接收方备注';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rate is '贴现利率';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.pay_amount is '贴现实付金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.sttlm_mk is '线上清算标记： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.back_begin_date is '贴现赎回开放日';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.back_end_date is '贴现赎回截止日';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.back_rate is '赎回利率';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.back_amt is '赎回金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.trade_conct_no is '交易合同编号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.invc_nb is '发票号码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.btch_nb is '批次号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.aoa_account is '入账账号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.aoa_bank_no is '入账行号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.sign_mk is '应答标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.sign_date is '签收日期';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.refuse_reason_code is '拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.refuse_remark is '拒付备注信息';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.recovery_type is '追偿类型： BC14 拒付追索 BC15 非拒付追索';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.pay_type is '付息方式';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.pay_interest is '实付利息';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.payment_date is '计息到期日';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.interest_payer_name is '付息人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.interest_payer_account is '付息人帐号';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.interest_payer_bank_name is '付息人开户行行名';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.charge is '手续费';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.expenses is '工本费';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.agent_name is '代理人名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.payer_sale is '付息比例';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.buyer_interest is '买方付息';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.interest is '总利息';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.stop_pay_type is '止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.stop_pay_rsn is '止付原因';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.relieve_stp_type is '解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.relieve_stp_rsn is '解除止付原因';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.inner_flag is '是否系统内： 0 否 1 是';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.trans_status is '交易状态： TS0000 无效 TS0001 有效 TS0002 完成';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.msg_status is '报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.process_code is '报文处理码';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.process_msg is '报文处理信息';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.settle_result is '结算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.settle_type is '结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.create_opr is '创建人';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.misc is '备注域';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.reserve3 is '备用字段3';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.req_account_name is '请求方账号名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.rcv_account_name is '接收方账号名称';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cust_dpc_draft_trans_info.etl_timestamp is 'ETL处理时间戳';
