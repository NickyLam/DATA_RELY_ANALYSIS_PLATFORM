/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_htes_buss_msg_analysis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_htes_buss_msg_analysis
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_htes_buss_msg_analysis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_buss_msg_analysis(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次表ID
    ,busi_type varchar2(9) -- 业务类型
    ,msg_no varchar2(18) -- 报文编号
    ,buss_flag varchar2(3) -- 业务方向： 01 申请 02 接收 03 通知
    ,draft_number varchar2(45) -- 票据号码
    ,apply_date varchar2(12) -- 业务申请日期
    ,req_type varchar2(6) -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,req_name varchar2(675) -- 请求方名称
    ,req_cert_no varchar2(27) -- 请求方社会信用代码
    ,req_account varchar2(48) -- 请求方账号
    ,req_mem_no varchar2(15) -- 请求方会员编码/业务渠道代码
    ,req_brh_no varchar2(15) -- 请求方机构编号
    ,req_trader_id varchar2(30) -- 请求方交易员ID
    ,req_bank_no varchar2(18) -- 请求方支付系统行号
    ,req_misc varchar2(675) -- 请求方备注
    ,rcv_type varchar2(6) -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,rcv_name varchar2(675) -- 接收方名称
    ,rcv_cert_no varchar2(27) -- 接收方社会信用代码
    ,rcv_account varchar2(48) -- 接收方账号
    ,rcv_mem_no varchar2(15) -- 接收方会员编码/业务渠道代码
    ,rcv_brh_no varchar2(15) -- 接收方机构编号
    ,rcv_trader_id varchar2(30) -- 接收方交易员ID
    ,rcv_misc varchar2(675) -- 接收方备注
    ,buss_occ_dt varchar2(12) -- 业务发生日期
    ,buss_occ_tm varchar2(21) -- 业务发生日期
    ,buss_fns_dt varchar2(12) -- 业务完成日期
    ,buss_fns_tm varchar2(21) -- 业务完成时间
    ,store_brh_no varchar2(14) -- 库存机构代码
    ,move_trs_type varchar2(6) -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type varchar2(6) -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type varchar2(6) -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst varchar2(6) -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_pay_apv_opi varchar2(900) -- 付款确认审批意见
    ,stop_pay_type varchar2(6) -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn varchar2(675) -- 止付原因
    ,relieve_stp_type varchar2(6) -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn varchar2(675) -- 解除止付原因
    ,sign_mk varchar2(6) -- 应答标识： SU00 同意 SU01 拒绝
    ,refuse_reason varchar2(6) -- 拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,refuse_reason_txt varchar2(450) -- 付款拒绝理由
    ,settle_result varchar2(5) -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,send_status varchar2(3) -- 发送方处理状态： 00 未处理 01 已发送 02 收到确认成功 03 收到确认失败 04 已签收 05 已拒绝 06 已清算 07 已清退 08 场务已拒绝
    ,rcv_status varchar2(3) -- 接收方处理状态： 01 未签收 02 已签收 05 已清算 06 已清退 03 已拒绝 04 已确认 07 场务已拒绝
    ,valid_flag varchar2(2) -- 是否有效标志： 0 无效 1 有效
    ,buy_back_type varchar2(8) -- 赎回类型： BBT01 提前赎回 BBT02 逾期赎回
    ,buy_back_reason varchar2(8) -- 赎回事由代码： BBR01 存在风险票据 BBR02 其它情形（需场务审核）
    ,back_deal_opi varchar2(450) -- 发起方处理意见
    ,apv_sign_mk varchar2(6) -- 场务审批结果： SU00 同意 SU01 拒绝
    ,apv_opi varchar2(450) -- 场务审核意见
    ,trans_reason varchar2(450) -- 非交易过户原因
    ,process_code varchar2(14) -- 处理结果码
    ,process_msg varchar2(768) -- 处理结果说明
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,recovery_type varchar2(6) -- 追偿类型： RT01 拒付追偿 RT02 余额不足追偿 BC14 拒付追索 BC15 非拒付追索
    ,sign_deal_opi varchar2(450) -- 签收方处理意见
    ,return_type varchar2(6) -- 退票类型： WT00 主动退票 WT01 创设失败退票
    ,bp_no varchar2(45) -- 票据包编号
    ,cd_range varchar2(38) -- 子票包区间
    ,discount_range varchar2(38) -- 贴现票据子票区间
    ,settle_type varchar2(6) -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,req_buss_type varchar2(6) -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type varchar2(6) -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_dist_tp varchar2(6) -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp varchar2(6) -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,draft_id varchar2(60) -- 票据ID
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,org_range varchar2(38) -- 原票据区间
    ,recohandapp_analysis_id varchar2(60) -- 追索通知NES012的ANALYSIS报文解析表主键ID
    ,data_source varchar2(2) -- 数据来源： 0 网银 1 机构
    ,req_account_name varchar2(675) -- 请求方账号名称
    ,rcv_account_name varchar2(675) -- 接收方账号名称
    ,rcv_bank_no varchar2(18) -- 接收方行号
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 创建时间
    ,proxy_sign varchar2(6) -- 签章标志： PS00开户机构代理回复签章 PS01票据当事人自 己签章
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
grant select on ${iol_schema}.bdms_htes_buss_msg_analysis to ${iml_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_analysis to ${icl_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_analysis to ${idl_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_analysis to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_htes_buss_msg_analysis is '业务报文解析表';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.id is 'ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.busi_type is '业务类型';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.msg_no is '报文编号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buss_flag is '业务方向： 01 申请 02 接收 03 通知';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.apply_date is '业务申请日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_type is '请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_name is '请求方名称';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_cert_no is '请求方社会信用代码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_account is '请求方账号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_mem_no is '请求方会员编码/业务渠道代码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_brh_no is '请求方机构编号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_trader_id is '请求方交易员ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_bank_no is '请求方支付系统行号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_misc is '请求方备注';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_type is '接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_name is '接收方名称';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_cert_no is '接收方社会信用代码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_account is '接收方账号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_mem_no is '接收方会员编码/业务渠道代码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_brh_no is '接收方机构编号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_trader_id is '接收方交易员ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_misc is '接收方备注';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buss_occ_dt is '业务发生日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buss_occ_tm is '业务发生日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buss_fns_dt is '业务完成日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buss_fns_tm is '业务完成时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.store_brh_no is '库存机构代码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.move_trs_type is '库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.conf_pay_type is '付款确认类型： VM01 影像验证 VM02 实物验证';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.conf_pay_add_type is '付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.conf_pay_rst is '付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.conf_pay_apv_opi is '付款确认审批意见';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.stop_pay_type is '止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.stop_pay_rsn is '止付原因';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.relieve_stp_type is '解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.relieve_stp_rsn is '解除止付原因';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.sign_mk is '应答标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.refuse_reason is '拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.refuse_reason_txt is '付款拒绝理由';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.settle_result is '清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.send_status is '发送方处理状态： 00 未处理 01 已发送 02 收到确认成功 03 收到确认失败 04 已签收 05 已拒绝 06 已清算 07 已清退 08 场务已拒绝';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_status is '接收方处理状态： 01 未签收 02 已签收 05 已清算 06 已清退 03 已拒绝 04 已确认 07 场务已拒绝';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.valid_flag is '是否有效标志： 0 无效 1 有效';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buy_back_type is '赎回类型： BBT01 提前赎回 BBT02 逾期赎回';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.buy_back_reason is '赎回事由代码： BBR01 存在风险票据 BBR02 其它情形（需场务审核）';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.back_deal_opi is '发起方处理意见';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.apv_sign_mk is '场务审批结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.apv_opi is '场务审核意见';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.trans_reason is '非交易过户原因';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.process_code is '处理结果码';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.process_msg is '处理结果说明';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.recovery_type is '追偿类型： RT01 拒付追偿 RT02 余额不足追偿 BC14 拒付追索 BC15 非拒付追索';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.sign_deal_opi is '签收方处理意见';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.return_type is '退票类型： WT00 主动退票 WT01 创设失败退票';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.bp_no is '票据包编号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.cd_range is '子票包区间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.discount_range is '贴现票据子票区间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.settle_type is '结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_buss_type is '请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_buss_type is '接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_dist_tp is '请求方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_dist_tp is '接收方识别类型 DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.org_range is '原票据区间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.recohandapp_analysis_id is '追索通知NES012的ANALYSIS报文解析表主键ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.data_source is '数据来源： 0 网银 1 机构';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.req_account_name is '请求方账号名称';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_account_name is '接收方账号名称';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.rcv_bank_no is '接收方行号';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.create_by is '创建人';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.create_time is '创建时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.proxy_sign is '签章标志： PS00开户机构代理回复签章 PS01票据当事人自 己签章';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_analysis.etl_timestamp is 'ETL处理时间戳';
