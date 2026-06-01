/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_buss_msg_analysis
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
drop table ${iol_schema}.bdms_htes_buss_msg_analysis_ex purge;
alter table ${iol_schema}.bdms_htes_buss_msg_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_htes_buss_msg_analysis truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_htes_buss_msg_analysis_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_buss_msg_analysis where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_htes_buss_msg_analysis_ex(
    id -- ID
    ,contract_id -- 批次表ID
    ,busi_type -- 业务类型
    ,msg_no -- 报文编号
    ,buss_flag -- 业务方向： 01 申请 02 接收 03 通知
    ,draft_number -- 票据号码
    ,apply_date -- 业务申请日期
    ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,req_name -- 请求方名称
    ,req_cert_no -- 请求方社会信用代码
    ,req_account -- 请求方账号
    ,req_mem_no -- 请求方会员编码/业务渠道代码
    ,req_brh_no -- 请求方机构编号
    ,req_trader_id -- 请求方交易员ID
    ,req_bank_no -- 请求方支付系统行号
    ,req_misc -- 请求方备注
    ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,rcv_name -- 接收方名称
    ,rcv_cert_no -- 接收方社会信用代码
    ,rcv_account -- 接收方账号
    ,rcv_mem_no -- 接收方会员编码/业务渠道代码
    ,rcv_brh_no -- 接收方机构编号
    ,rcv_trader_id -- 接收方交易员ID
    ,rcv_misc -- 接收方备注
    ,buss_occ_dt -- 业务发生日期
    ,buss_occ_tm -- 业务发生日期
    ,buss_fns_dt -- 业务完成日期
    ,buss_fns_tm -- 业务完成时间
    ,store_brh_no -- 库存机构代码
    ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_pay_apv_opi -- 付款确认审批意见
    ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn -- 止付原因
    ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn -- 解除止付原因
    ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,refuse_reason -- 拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,refuse_reason_txt -- 付款拒绝理由
    ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,send_status -- 发送方处理状态： 00 未处理 01 已发送 02 收到确认成功 03 收到确认失败 04 已签收 05 已拒绝 06 已清算 07 已清退 08 场务已拒绝
    ,rcv_status -- 接收方处理状态： 01 未签收 02 已签收 05 已清算 06 已清退 03 已拒绝 04 已确认 07 场务已拒绝
    ,valid_flag -- 是否有效标志： 0 无效 1 有效
    ,buy_back_type -- 赎回类型： BBT01 提前赎回 BBT02 逾期赎回
    ,buy_back_reason -- 赎回事由代码： BBR01 存在风险票据 BBR02 其它情形（需场务审核）
    ,back_deal_opi -- 发起方处理意见
    ,apv_sign_mk -- 场务审批结果： SU00 同意 SU01 拒绝
    ,apv_opi -- 场务审核意见
    ,trans_reason -- 非交易过户原因
    ,process_code -- 处理结果码
    ,process_msg -- 处理结果说明
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,recovery_type -- 追偿类型： RT01 拒付追偿 RT02 余额不足追偿 BC14 拒付追索 BC15 非拒付追索
    ,sign_deal_opi -- 签收方处理意见
    ,return_type -- 退票类型： WT00 主动退票 WT01 创设失败退票
    ,bp_no -- 票据包编号
    ,cd_range -- 子票包区间
    ,discount_range -- 贴现票据子票区间
    ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,draft_id -- 票据ID
    ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,org_range -- 原票据区间
    ,recohandapp_analysis_id -- 追索通知NES012的ANALYSIS报文解析表主键ID
    ,data_source -- 数据来源： 0 网银 1 机构
    ,req_account_name -- 请求方账号名称
    ,rcv_account_name -- 接收方账号名称
    ,rcv_bank_no -- 接收方行号
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,proxy_sign -- 签章标志： PS00开户机构代理回复签章 PS01票据当事人自 己签章
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,contract_id -- 批次表ID
    ,busi_type -- 业务类型
    ,msg_no -- 报文编号
    ,buss_flag -- 业务方向： 01 申请 02 接收 03 通知
    ,draft_number -- 票据号码
    ,apply_date -- 业务申请日期
    ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,req_name -- 请求方名称
    ,req_cert_no -- 请求方社会信用代码
    ,req_account -- 请求方账号
    ,req_mem_no -- 请求方会员编码/业务渠道代码
    ,req_brh_no -- 请求方机构编号
    ,req_trader_id -- 请求方交易员ID
    ,req_bank_no -- 请求方支付系统行号
    ,req_misc -- 请求方备注
    ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,rcv_name -- 接收方名称
    ,rcv_cert_no -- 接收方社会信用代码
    ,rcv_account -- 接收方账号
    ,rcv_mem_no -- 接收方会员编码/业务渠道代码
    ,rcv_brh_no -- 接收方机构编号
    ,rcv_trader_id -- 接收方交易员ID
    ,rcv_misc -- 接收方备注
    ,buss_occ_dt -- 业务发生日期
    ,buss_occ_tm -- 业务发生日期
    ,buss_fns_dt -- 业务完成日期
    ,buss_fns_tm -- 业务完成时间
    ,store_brh_no -- 库存机构代码
    ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_pay_apv_opi -- 付款确认审批意见
    ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn -- 止付原因
    ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn -- 解除止付原因
    ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,refuse_reason -- 拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,refuse_reason_txt -- 付款拒绝理由
    ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,send_status -- 发送方处理状态： 00 未处理 01 已发送 02 收到确认成功 03 收到确认失败 04 已签收 05 已拒绝 06 已清算 07 已清退 08 场务已拒绝
    ,rcv_status -- 接收方处理状态： 01 未签收 02 已签收 05 已清算 06 已清退 03 已拒绝 04 已确认 07 场务已拒绝
    ,valid_flag -- 是否有效标志： 0 无效 1 有效
    ,buy_back_type -- 赎回类型： BBT01 提前赎回 BBT02 逾期赎回
    ,buy_back_reason -- 赎回事由代码： BBR01 存在风险票据 BBR02 其它情形（需场务审核）
    ,back_deal_opi -- 发起方处理意见
    ,apv_sign_mk -- 场务审批结果： SU00 同意 SU01 拒绝
    ,apv_opi -- 场务审核意见
    ,trans_reason -- 非交易过户原因
    ,process_code -- 处理结果码
    ,process_msg -- 处理结果说明
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,recovery_type -- 追偿类型： RT01 拒付追偿 RT02 余额不足追偿 BC14 拒付追索 BC15 非拒付追索
    ,sign_deal_opi -- 签收方处理意见
    ,return_type -- 退票类型： WT00 主动退票 WT01 创设失败退票
    ,bp_no -- 票据包编号
    ,cd_range -- 子票包区间
    ,discount_range -- 贴现票据子票区间
    ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,draft_id -- 票据ID
    ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,org_range -- 原票据区间
    ,recohandapp_analysis_id -- 追索通知NES012的ANALYSIS报文解析表主键ID
    ,data_source -- 数据来源： 0 网银 1 机构
    ,req_account_name -- 请求方账号名称
    ,rcv_account_name -- 接收方账号名称
    ,rcv_bank_no -- 接收方行号
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,proxy_sign -- 签章标志： PS00开户机构代理回复签章 PS01票据当事人自 己签章
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_htes_buss_msg_analysis
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_htes_buss_msg_analysis exchange partition p_${batch_date} with table ${iol_schema}.bdms_htes_buss_msg_analysis_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_htes_buss_msg_analysis to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_htes_buss_msg_analysis_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_htes_buss_msg_analysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);