/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_bill_info_tb
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
drop table ${iol_schema}.scps_bp_bill_info_tb_ex purge;
alter table ${iol_schema}.scps_bp_bill_info_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scps_bp_bill_info_tb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scps_bp_bill_info_tb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_bill_info_tb where 0=1;

insert /*+ append */ into ${iol_schema}.scps_bp_bill_info_tb_ex(
    id -- 唯一主键
    ,process_inst_id -- 
    ,main_flow_id -- 
    ,accept_no -- 受理号
    ,root_accept_no -- 根受理号
    ,scan_seq_no -- 流水号
    ,tr_date -- 交易日期（yyyy-MM-dd）
    ,accept_time -- 受理时间(yyyy-MM-dd HH:mm:ss)
    ,user_id -- 交易柜员编号
    ,charge_id -- 授权柜员号
    ,br_code -- 记账机构号
    ,biz_code -- 业务编码(600009-同城提出借记 600010-同城提出贷记 609001-同城提入借记 609002-同城提入贷记 609021-深圳同城提入)
    ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场（广州结算中心提出业务才有）
    ,biz_type -- 1-正常业务、2-退票业务
    ,voucher_code -- 凭证代码 773-银行汇票 780-支票 786-结算业务委托书 998-银行本票 999-其它
    ,voucher_no -- 凭证号码
    ,bill_date -- 出票日期 格式yyyyMMdd
    ,cust_no -- 客户编号(本行付款人时才有)
    ,custname -- 客户名称
    ,curr_code -- 币种
    ,drawee_name -- 交易对手名称
    ,drawee_acct_no -- 交易对手账号
    ,drawee_bk_no -- 付款行名号
    ,drawee_bk_name -- 付款行名称
    ,drawee_addr -- 付款人地址
    ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
    ,payee_name -- 收款人名称
    ,payee_acct_no -- 收款人账号
    ,payee_bk_no -- 收款行行号
    ,payee_bk_name -- 收款行名称
    ,payee_addr -- 收款人地址
    ,trn_amt -- 交易金额 例如100.00
    ,purpose -- 用途（附言）
    ,memocd -- 摘要码
    ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,tr_state -- 交易状态 00-待复核 01-待确定 02-待清算 03-已扎差 04-已清算 05-已退票待清算 06-行内退票 07-已暂缓   08-已冲正 09-已入账 10-记账失败 11-复核通过 12-复核失败 13-发送人行失败 14-人行拒绝 15-他行退票 16-已退票   17-待重发 18-已重发 深圳同城提出票据：全票环节提交成功后，状态改为：01-待确定，后续接到推送状态转换为：     Z：初始登记  --> 11-复核通过     1：中台记账成功 --> 01-待确定     2：中台记账失败 -->  10-记账失败  （终态）     //推送以下状态     3：发送人行成功  待清算--> 02-待清算     4：发送人行失败--> 13-发送人行失败     5：人行拒绝--> 14-人行拒绝     O：已扎差--> 03-已扎差     T：已清算--> 04-已清算    （终态）     6：他行退票--> 15-他行退票     7：已冲正 （发送人行失败，人行拒绝，他行退票后已做冲账处理）-->08-已冲正 （终态） 深圳同城提回：30-扣款成功 31-扣款失败 32-退票成功 33-退票失败 34-退票发往人行成功(未收到人行确认)
    ,tr_state_msg -- 交易状态消息
    ,submit_state -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,tally_send_seqno -- 记账报文流水号
    ,tally_host_seqno -- 记账核心交易流水
    ,tally_host_date -- 记账核心交易日期
    ,pay_send_seqno -- 支付报文流水号
    ,pay_send_date -- 支付报文交易日期
    ,pay_host_seqno -- 支付主机流水号
    ,pay_host_date -- 支付主机交易日期
    ,pay_businesstrace -- 支付业务序号
    ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,batch_count -- 批量笔数1-99
    ,batch_is_sync_ete -- 批量处理是否同步受理中心0-否 1-是
    ,split_count -- 拆分笔数
    ,trn_amt_ch -- 交易金额(大写)
    ,ticket_count -- 票据张数
    ,endorser_num -- 背书人数
    ,endorsers -- 背书清单，背书人之间使用分号;分隔
    ,pay_date -- 提示付款日期 格式yyyyMMdd
    ,pay_password -- 支付密码
    ,tax_bill_flag -- 税票标记 0-否 1-是
    ,auto_seal_batch_no -- 自动验印批次号
    ,ret_type -- 退票类型 1-行内退票 2-我行退票
    ,confirm_batch_no -- 提出确认批次号
    ,clear_date -- 清算日期，格式为yyyyMMdd
    ,bill_seq_no -- 同城提入主交易流水号
    ,acct_query_msg -- 主账户查询信息
    ,acct_br_code -- 账号开户机构
    ,acct_stat -- 账号状态 0-关闭 1-正常 2-账户挂失
    ,acct_amt_stat -- 账号余额信息 0-余额充足 1-余额不足
    ,bill_flag -- 借贷标志[D：借 C：贷]
    ,ret_scan_seq_no -- 关联流水
    ,clear_change_no -- 清算场次 1-9
    ,inacct_state -- 收妥入账记账状态[0-未记账 1-记账成功 2 -退客户帐成功]
    ,inacct_submit_state -- 收妥入账业务提交状态 0-未提交，1-处理中 2-提交成功
    ,inacct_send_seqno -- 收妥入账记账报文流水号
    ,inacct_host_seqno -- 收妥入账记账核心交易流水
    ,inacct_host_date -- 收妥入账记账核心交易日期
    ,reversed_user_id -- 冲正柜员号
    ,reversed_time -- 冲正时间
    ,reversed_submit_state -- 冲正提交状态 0-未提交，1-处理中 2-提交成功
    ,reversed_send_seqno -- 冲正报文流水号
    ,reversed_host_seqno -- 冲正核心交易流水
    ,reversed_host_date -- 冲正核心交易日期
    ,reversed_reason -- 冲正原因
    ,inacct_user_id -- 收妥入账记账柜员
    ,out_confirm_userid -- 提出确认操作柜员
    ,out_confirm_chargeid -- 提出确认授权柜员
    ,out_confirm_time -- 提出确认时间
    ,check_user_id -- 复核柜员
    ,check_time -- 复核时间(yyyy-MM-dd HH:mm:ss)
    ,reversed_charge_id -- 冲正授权柜员号
    ,return_reason -- 退票理由
    ,proxy_drawee_bk_no -- 代理付款行号
    ,inacct_charge_id -- 收妥入账授权柜员号
    ,inacct_time -- 收妥入账时间
    ,delay_inacct_user_id -- 暂缓入账柜员
    ,delay_inacct_charge_id -- 暂缓入账授权柜员号
    ,delay_inacct_time -- 暂缓入账时间
    ,cancel_delay_user_id -- 取消暂缓入账柜员
    ,cancel_delay_charge_id -- 取消暂缓入账授权柜员号
    ,cancel_delay_time -- 取消暂缓入账时间
    ,micr -- 磁码交易码
    ,trade_date -- 交换日期
    ,ref_batch_accept_no -- 原批量受理号
    ,ref_batch_scan_seq_no -- 原批量流水号
    ,in_bk_no -- 提入行号
    ,in_bk_name -- 提入行名称
    ,out_bk_no -- 提出行行号
    ,out_bk_name -- 提出行名称
    ,trade_round -- 交换场次
    ,bill_in_order -- 提入顺序号
    ,txcd -- 业务种类
    ,billnd -- 票据标识 0 无纸质票据业务 1 纸质票据业务
    ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,suspend_acct_acctpno -- 挂账受理号
    ,start_way -- 提入业务发起方式[1-导入 2-扫描]
    ,return_reason_desc -- 退票理由描述
    ,tran_br_code -- 交易机构
    ,trade_bank_code -- 交换行号
    ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,odrtfg -- 是否触发透支业务 0- 否1- 是
    ,odrtam -- 透支金额
    ,is_special_submit -- 是否特殊提交 0、空-否  1-是
    ,inacct_flag -- 入账标识 0-否  1-是
    ,vouch_group -- 业务场景凭证组合
    ,doc_id -- 影像批次号
    ,model_code -- 影像模型
    ,busi_start_date -- 影像上传时间
    ,bank_no -- 银行号
    ,system_no -- 系统号
    ,trans_no -- 服务码
    ,user_no -- 用户号
    ,organ_no -- 机构号
    ,channel -- 渠道
    ,scene_code -- 业务场景码
    ,trans_id -- 业务场景种类编号
    ,glob_seq_num -- 全局流水号
    ,succ_total -- 成功笔数
    ,total -- 总笔数
    ,total_amt -- 总金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 唯一主键
    ,process_inst_id -- 
    ,main_flow_id -- 
    ,accept_no -- 受理号
    ,root_accept_no -- 根受理号
    ,scan_seq_no -- 流水号
    ,tr_date -- 交易日期（yyyy-MM-dd）
    ,accept_time -- 受理时间(yyyy-MM-dd HH:mm:ss)
    ,user_id -- 交易柜员编号
    ,charge_id -- 授权柜员号
    ,br_code -- 记账机构号
    ,biz_code -- 业务编码(600009-同城提出借记 600010-同城提出贷记 609001-同城提入借记 609002-同城提入贷记 609021-深圳同城提入)
    ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场（广州结算中心提出业务才有）
    ,biz_type -- 1-正常业务、2-退票业务
    ,voucher_code -- 凭证代码 773-银行汇票 780-支票 786-结算业务委托书 998-银行本票 999-其它
    ,voucher_no -- 凭证号码
    ,bill_date -- 出票日期 格式yyyyMMdd
    ,cust_no -- 客户编号(本行付款人时才有)
    ,custname -- 客户名称
    ,curr_code -- 币种
    ,drawee_name -- 交易对手名称
    ,drawee_acct_no -- 交易对手账号
    ,drawee_bk_no -- 付款行名号
    ,drawee_bk_name -- 付款行名称
    ,drawee_addr -- 付款人地址
    ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
    ,payee_name -- 收款人名称
    ,payee_acct_no -- 收款人账号
    ,payee_bk_no -- 收款行行号
    ,payee_bk_name -- 收款行名称
    ,payee_addr -- 收款人地址
    ,trn_amt -- 交易金额 例如100.00
    ,purpose -- 用途（附言）
    ,memocd -- 摘要码
    ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,tr_state -- 交易状态 00-待复核 01-待确定 02-待清算 03-已扎差 04-已清算 05-已退票待清算 06-行内退票 07-已暂缓   08-已冲正 09-已入账 10-记账失败 11-复核通过 12-复核失败 13-发送人行失败 14-人行拒绝 15-他行退票 16-已退票   17-待重发 18-已重发 深圳同城提出票据：全票环节提交成功后，状态改为：01-待确定，后续接到推送状态转换为：     Z：初始登记  --> 11-复核通过     1：中台记账成功 --> 01-待确定     2：中台记账失败 -->  10-记账失败  （终态）     //推送以下状态     3：发送人行成功  待清算--> 02-待清算     4：发送人行失败--> 13-发送人行失败     5：人行拒绝--> 14-人行拒绝     O：已扎差--> 03-已扎差     T：已清算--> 04-已清算    （终态）     6：他行退票--> 15-他行退票     7：已冲正 （发送人行失败，人行拒绝，他行退票后已做冲账处理）-->08-已冲正 （终态） 深圳同城提回：30-扣款成功 31-扣款失败 32-退票成功 33-退票失败 34-退票发往人行成功(未收到人行确认)
    ,tr_state_msg -- 交易状态消息
    ,submit_state -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,tally_send_seqno -- 记账报文流水号
    ,tally_host_seqno -- 记账核心交易流水
    ,tally_host_date -- 记账核心交易日期
    ,pay_send_seqno -- 支付报文流水号
    ,pay_send_date -- 支付报文交易日期
    ,pay_host_seqno -- 支付主机流水号
    ,pay_host_date -- 支付主机交易日期
    ,pay_businesstrace -- 支付业务序号
    ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,batch_count -- 批量笔数1-99
    ,batch_is_sync_ete -- 批量处理是否同步受理中心0-否 1-是
    ,split_count -- 拆分笔数
    ,trn_amt_ch -- 交易金额(大写)
    ,ticket_count -- 票据张数
    ,endorser_num -- 背书人数
    ,endorsers -- 背书清单，背书人之间使用分号;分隔
    ,pay_date -- 提示付款日期 格式yyyyMMdd
    ,pay_password -- 支付密码
    ,tax_bill_flag -- 税票标记 0-否 1-是
    ,auto_seal_batch_no -- 自动验印批次号
    ,ret_type -- 退票类型 1-行内退票 2-我行退票
    ,confirm_batch_no -- 提出确认批次号
    ,clear_date -- 清算日期，格式为yyyyMMdd
    ,bill_seq_no -- 同城提入主交易流水号
    ,acct_query_msg -- 主账户查询信息
    ,acct_br_code -- 账号开户机构
    ,acct_stat -- 账号状态 0-关闭 1-正常 2-账户挂失
    ,acct_amt_stat -- 账号余额信息 0-余额充足 1-余额不足
    ,bill_flag -- 借贷标志[D：借 C：贷]
    ,ret_scan_seq_no -- 关联流水
    ,clear_change_no -- 清算场次 1-9
    ,inacct_state -- 收妥入账记账状态[0-未记账 1-记账成功 2 -退客户帐成功]
    ,inacct_submit_state -- 收妥入账业务提交状态 0-未提交，1-处理中 2-提交成功
    ,inacct_send_seqno -- 收妥入账记账报文流水号
    ,inacct_host_seqno -- 收妥入账记账核心交易流水
    ,inacct_host_date -- 收妥入账记账核心交易日期
    ,reversed_user_id -- 冲正柜员号
    ,reversed_time -- 冲正时间
    ,reversed_submit_state -- 冲正提交状态 0-未提交，1-处理中 2-提交成功
    ,reversed_send_seqno -- 冲正报文流水号
    ,reversed_host_seqno -- 冲正核心交易流水
    ,reversed_host_date -- 冲正核心交易日期
    ,reversed_reason -- 冲正原因
    ,inacct_user_id -- 收妥入账记账柜员
    ,out_confirm_userid -- 提出确认操作柜员
    ,out_confirm_chargeid -- 提出确认授权柜员
    ,out_confirm_time -- 提出确认时间
    ,check_user_id -- 复核柜员
    ,check_time -- 复核时间(yyyy-MM-dd HH:mm:ss)
    ,reversed_charge_id -- 冲正授权柜员号
    ,return_reason -- 退票理由
    ,proxy_drawee_bk_no -- 代理付款行号
    ,inacct_charge_id -- 收妥入账授权柜员号
    ,inacct_time -- 收妥入账时间
    ,delay_inacct_user_id -- 暂缓入账柜员
    ,delay_inacct_charge_id -- 暂缓入账授权柜员号
    ,delay_inacct_time -- 暂缓入账时间
    ,cancel_delay_user_id -- 取消暂缓入账柜员
    ,cancel_delay_charge_id -- 取消暂缓入账授权柜员号
    ,cancel_delay_time -- 取消暂缓入账时间
    ,micr -- 磁码交易码
    ,trade_date -- 交换日期
    ,ref_batch_accept_no -- 原批量受理号
    ,ref_batch_scan_seq_no -- 原批量流水号
    ,in_bk_no -- 提入行号
    ,in_bk_name -- 提入行名称
    ,out_bk_no -- 提出行行号
    ,out_bk_name -- 提出行名称
    ,trade_round -- 交换场次
    ,bill_in_order -- 提入顺序号
    ,txcd -- 业务种类
    ,billnd -- 票据标识 0 无纸质票据业务 1 纸质票据业务
    ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,suspend_acct_acctpno -- 挂账受理号
    ,start_way -- 提入业务发起方式[1-导入 2-扫描]
    ,return_reason_desc -- 退票理由描述
    ,tran_br_code -- 交易机构
    ,trade_bank_code -- 交换行号
    ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,odrtfg -- 是否触发透支业务 0- 否1- 是
    ,odrtam -- 透支金额
    ,is_special_submit -- 是否特殊提交 0、空-否  1-是
    ,inacct_flag -- 入账标识 0-否  1-是
    ,vouch_group -- 业务场景凭证组合
    ,doc_id -- 影像批次号
    ,model_code -- 影像模型
    ,busi_start_date -- 影像上传时间
    ,bank_no -- 银行号
    ,system_no -- 系统号
    ,trans_no -- 服务码
    ,user_no -- 用户号
    ,organ_no -- 机构号
    ,channel -- 渠道
    ,scene_code -- 业务场景码
    ,trans_id -- 业务场景种类编号
    ,glob_seq_num -- 全局流水号
    ,succ_total -- 成功笔数
    ,total -- 总笔数
    ,total_amt -- 总金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scps_bp_bill_info_tb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scps_bp_bill_info_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_bill_info_tb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_bill_info_tb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scps_bp_bill_info_tb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_bill_info_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);