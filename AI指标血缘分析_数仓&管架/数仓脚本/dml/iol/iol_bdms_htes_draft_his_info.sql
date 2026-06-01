/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_draft_his_info
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
drop table ${iol_schema}.bdms_htes_draft_his_info_ex purge;
alter table ${iol_schema}.bdms_htes_draft_his_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_htes_draft_his_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_htes_draft_his_info_ex nologging
compress
as
select * from ${iol_schema}.bdms_htes_draft_his_info where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_htes_draft_his_info_ex(
    id -- ID
    ,msg_type -- 交易类型： 01 承兑登记 02 承兑保证登记 03 贴现前保证 04 贴现前质押 05 贴现前转让背书 06 止付登记 07 解除止付登记 08 贴现等级 09 初始权属登记 10 付款确认 11 库存变更 12 保证增信 13 贴现后质押 14 贴现后保证 15 转贴现交易 16 质押式回购交易 17 买断式回购首期交易 18 买断式回购到期交易 19 再贴现质押式回购交易 20 提示付款交易 21 追偿交易 22 再贴现买断交易 23 非交易过户 24 电票转入 25 提示付款 26 背书存托信息
    ,draft_number -- 票据号码
    ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,req_name -- 请求方名称
    ,req_cert_no -- 请求方社会信用代码
    ,req_account -- 请求方账号
    ,req_mem_no -- 请求方会员编码
    ,req_brh_no -- 请求方机构编号
    ,req_bank_no -- 请求方支付系统行号
    ,req_industry -- 请求方行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,req_corp_scale -- 请求方企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,req_dr_act -- 是否三农企业： 0 否 1 是
    ,req_area -- 地区
    ,req_is_grn -- 是否绿色企业： 0 否 1 是
    ,req_misc -- 请求方备注
    ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,rcv_name -- 接收方名称
    ,rcv_cert_no -- 接收方社会信用代码
    ,rcv_account -- 接收方账号
    ,rcv_mem_no -- 接收方会员编码
    ,rcv_brh_no -- 接收方机构编号
    ,rcv_bank_no -- 接收方支付系统行号
    ,rcv_misc -- 接收方备注
    ,buss_occ_dt -- 业务发生日期
    ,buss_occ_tm -- 业务发生时间
    ,buss_fns_dt -- 业务完成日期
    ,buss_fns_tm -- 业务完成时间
    ,grnt_address -- 保证人地址
    ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_status -- 付款确认状态
    ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn -- 止付原因
    ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn -- 解除止付原因
    ,busi_type -- 业务类型
    ,buy_back_date -- 回购到期日
    ,real_back_date -- 实际回购日
    ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,bp_no -- 票据包编号
    ,cd_range -- 子票包区间
    ,discount_range -- 贴现票据子票区间
    ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,prmt_refuse_other_inf -- 提示付款拒付理由为其他时其他信息
    ,buy_back_other_inf -- 提前和逾期赎回时应答方处理意见
    ,bill_beh_seq -- 票据行为流水号
    ,left_cd_range -- 左子票区间
    ,right_cd_range -- 右子票区间
    ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_account_name -- 请求方账号名称
    ,rcv_account_name -- 接收方账号名称
    ,create_time -- 创建时间
    ,create_by -- 创建人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,msg_type -- 交易类型： 01 承兑登记 02 承兑保证登记 03 贴现前保证 04 贴现前质押 05 贴现前转让背书 06 止付登记 07 解除止付登记 08 贴现等级 09 初始权属登记 10 付款确认 11 库存变更 12 保证增信 13 贴现后质押 14 贴现后保证 15 转贴现交易 16 质押式回购交易 17 买断式回购首期交易 18 买断式回购到期交易 19 再贴现质押式回购交易 20 提示付款交易 21 追偿交易 22 再贴现买断交易 23 非交易过户 24 电票转入 25 提示付款 26 背书存托信息
    ,draft_number -- 票据号码
    ,req_type -- 请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,req_name -- 请求方名称
    ,req_cert_no -- 请求方社会信用代码
    ,req_account -- 请求方账号
    ,req_mem_no -- 请求方会员编码
    ,req_brh_no -- 请求方机构编号
    ,req_bank_no -- 请求方支付系统行号
    ,req_industry -- 请求方行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,req_corp_scale -- 请求方企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,req_dr_act -- 是否三农企业： 0 否 1 是
    ,req_area -- 地区
    ,req_is_grn -- 是否绿色企业： 0 否 1 是
    ,req_misc -- 请求方备注
    ,rcv_type -- 接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,rcv_name -- 接收方名称
    ,rcv_cert_no -- 接收方社会信用代码
    ,rcv_account -- 接收方账号
    ,rcv_mem_no -- 接收方会员编码
    ,rcv_brh_no -- 接收方机构编号
    ,rcv_bank_no -- 接收方支付系统行号
    ,rcv_misc -- 接收方备注
    ,buss_occ_dt -- 业务发生日期
    ,buss_occ_tm -- 业务发生时间
    ,buss_fns_dt -- 业务完成日期
    ,buss_fns_tm -- 业务完成时间
    ,grnt_address -- 保证人地址
    ,move_trs_type -- 库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
    ,conf_pay_type -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,conf_pay_add_type -- 付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_rst -- 付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,conf_status -- 付款确认状态
    ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_rsn -- 止付原因
    ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn -- 解除止付原因
    ,busi_type -- 业务类型
    ,buy_back_date -- 回购到期日
    ,real_back_date -- 实际回购日
    ,buy_back_status -- 回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
    ,exchge_status -- 置换状态： ES01 被他票替换 ES02 替换他票
    ,prmt_result -- 提示付款应答结果： SU00 同意 SU01 拒绝
    ,prmt_refuse_rsn -- 提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,prmt_stl_rst -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,bp_no -- 票据包编号
    ,cd_range -- 子票包区间
    ,discount_range -- 贴现票据子票区间
    ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,req_dist_tp -- 请求方识别类型 DT01 票据账户 DT02 银行账户
    ,rcv_dist_tp -- 接收方识别类型 DT01 票据账户 DT02 银行账户
    ,prmt_refuse_other_inf -- 提示付款拒付理由为其他时其他信息
    ,buy_back_other_inf -- 提前和逾期赎回时应答方处理意见
    ,bill_beh_seq -- 票据行为流水号
    ,left_cd_range -- 左子票区间
    ,right_cd_range -- 右子票区间
    ,req_buss_type -- 请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,rcv_buss_type -- 接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
    ,req_account_name -- 请求方账号名称
    ,rcv_account_name -- 接收方账号名称
    ,create_time -- 创建时间
    ,create_by -- 创建人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_htes_draft_his_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_htes_draft_his_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_htes_draft_his_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_htes_draft_his_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_htes_draft_his_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_htes_draft_his_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);