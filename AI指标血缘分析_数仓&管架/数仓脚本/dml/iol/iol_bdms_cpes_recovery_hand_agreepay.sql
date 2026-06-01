/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_recovery_hand_agreepay
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
drop table ${iol_schema}.bdms_cpes_recovery_hand_agreepay_ex purge;
alter table ${iol_schema}.bdms_cpes_recovery_hand_agreepay add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_cpes_recovery_hand_agreepay;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_cpes_recovery_hand_agreepay_ex nologging
compress
as
select * from ${iol_schema}.bdms_cpes_recovery_hand_agreepay where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_cpes_recovery_hand_agreepay_ex(
    id -- 主键
    ,buss_flag -- 交易方向： 01 申请 02 签收
    ,product_no -- 产品号
    ,draft_id -- 同意清偿票据ID
    ,hand_apply_id -- 贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID
    ,pub_apply_id -- 报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID
    ,recovery_type -- 追索类型： BC14 拒付追索 BC15 非拒付追索
    ,draft_number -- 票据（包）号
    ,cd_range -- 同意清偿区间
    ,draft_amount -- 同意清偿金额
    ,recovery_buss_type -- 追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,recovery_name -- 追索人名称
    ,recovery_cert_no -- 追索人社会信息用代码
    ,recovery_dist_tp -- 追索人识别类型： DT01 票据账户 DT02 银行账户
    ,recovery_account -- 追索人账号
    ,recovery_brh_no -- 追索人(开户)机构代码
    ,recovery_bank_no -- 追索人(开户)行号
    ,recovery_notice_date -- 追索通知日期
    ,recovery_notice_misc -- 追索通知备注
    ,recovery_backmisc -- 追索人撤销说明
    ,recovery_sign_date -- 追索人应答日期
    ,recovery_sign_mk -- 追索人应答标识： SU00 同意 SU01 拒绝
    ,recovery_sign_misc -- 追索人应答备注
    ,berecovered_buss_type -- 被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,berecovered_name -- 被追索人名称
    ,berecovered_cert_no -- 被追索人社会信息用代码
    ,berecovered_dist_tp -- 被追索人识别类型： DT01 票据账户 DT02 银行账户
    ,berecovered_account -- 被追索人账号
    ,berecovered_brh_no -- 被追索人(开户)机构代码
    ,berecovered_agree_date -- 被追索人同意清偿的申请日期
    ,berecovered_agree_misc -- 被追索人同意清偿备注
    ,berecovered_agree_number -- 被追索人同意清偿子票据张数
    ,berecovered_settle_account -- 被追索人结算账号
    ,berecovered_settle_bank_no -- 被追索人结算行号
    ,berecovered_backmisc -- 被追索人撤销说明
    ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,settle_date -- 被追索人同意清偿日期（结算日期）
    ,deal_status -- 处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,err_code -- 错误码
    ,err_msg -- 错误信息
    ,branch_no -- 行内机构号
    ,belong_brh_no -- 所属票交所机构号/非法人产品
    ,top_branch_no -- 行内总行机构号
    ,create_opr -- 创建人
    ,last_upd_opr -- 最后操作人
    ,last_upd_time -- 最后修改时间
    ,recovery_mem_no -- 追索人渠道代码
    ,berecovered_mem_no -- 被追索人渠道代码
    ,recovery_range -- 追索通知区间
    ,recovery_amount -- 追索通知金额
    ,recovery_account_name -- 追索人账户名称
    ,recovery_settle_account_name -- 追索人结算账户名称
    ,recovery_settle_account -- 追索人结算账号
    ,recovery_settle_brh_no -- 追索人结算账户机构代码
    ,recovery_bt_no -- 追索人业务批次号
    ,berecovered_account_name -- 被追索人账户名称
    ,berecovered_settle_account_nam -- 被追索人结算账户名称
    ,berecovered_settle_brh_no -- 被追索人结算账户机构代码
    ,berecovered_bt_no -- 被追索人业务批次号
    ,settle_amount -- 结算金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键
    ,buss_flag -- 交易方向： 01 申请 02 签收
    ,product_no -- 产品号
    ,draft_id -- 同意清偿票据ID
    ,hand_apply_id -- 贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID
    ,pub_apply_id -- 报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID
    ,recovery_type -- 追索类型： BC14 拒付追索 BC15 非拒付追索
    ,draft_number -- 票据（包）号
    ,cd_range -- 同意清偿区间
    ,draft_amount -- 同意清偿金额
    ,recovery_buss_type -- 追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,recovery_name -- 追索人名称
    ,recovery_cert_no -- 追索人社会信息用代码
    ,recovery_dist_tp -- 追索人识别类型： DT01 票据账户 DT02 银行账户
    ,recovery_account -- 追索人账号
    ,recovery_brh_no -- 追索人(开户)机构代码
    ,recovery_bank_no -- 追索人(开户)行号
    ,recovery_notice_date -- 追索通知日期
    ,recovery_notice_misc -- 追索通知备注
    ,recovery_backmisc -- 追索人撤销说明
    ,recovery_sign_date -- 追索人应答日期
    ,recovery_sign_mk -- 追索人应答标识： SU00 同意 SU01 拒绝
    ,recovery_sign_misc -- 追索人应答备注
    ,berecovered_buss_type -- 被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,berecovered_name -- 被追索人名称
    ,berecovered_cert_no -- 被追索人社会信息用代码
    ,berecovered_dist_tp -- 被追索人识别类型： DT01 票据账户 DT02 银行账户
    ,berecovered_account -- 被追索人账号
    ,berecovered_brh_no -- 被追索人(开户)机构代码
    ,berecovered_agree_date -- 被追索人同意清偿的申请日期
    ,berecovered_agree_misc -- 被追索人同意清偿备注
    ,berecovered_agree_number -- 被追索人同意清偿子票据张数
    ,berecovered_settle_account -- 被追索人结算账号
    ,berecovered_settle_bank_no -- 被追索人结算行号
    ,berecovered_backmisc -- 被追索人撤销说明
    ,settle_type -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,clear_type -- 清算类型： CT01 全额清算 CT02 净额清算
    ,settle_date -- 被追索人同意清偿日期（结算日期）
    ,deal_status -- 处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,err_code -- 错误码
    ,err_msg -- 错误信息
    ,branch_no -- 行内机构号
    ,belong_brh_no -- 所属票交所机构号/非法人产品
    ,top_branch_no -- 行内总行机构号
    ,create_opr -- 创建人
    ,last_upd_opr -- 最后操作人
    ,last_upd_time -- 最后修改时间
    ,recovery_mem_no -- 追索人渠道代码
    ,berecovered_mem_no -- 被追索人渠道代码
    ,recovery_range -- 追索通知区间
    ,recovery_amount -- 追索通知金额
    ,recovery_account_name -- 追索人账户名称
    ,recovery_settle_account_name -- 追索人结算账户名称
    ,recovery_settle_account -- 追索人结算账号
    ,recovery_settle_brh_no -- 追索人结算账户机构代码
    ,recovery_bt_no -- 追索人业务批次号
    ,berecovered_account_name -- 被追索人账户名称
    ,berecovered_settle_account_nam -- 被追索人结算账户名称
    ,berecovered_settle_brh_no -- 被追索人结算账户机构代码
    ,berecovered_bt_no -- 被追索人业务批次号
    ,settle_amount -- 结算金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_cpes_recovery_hand_agreepay
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_cpes_recovery_hand_agreepay exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_recovery_hand_agreepay_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_recovery_hand_agreepay to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_cpes_recovery_hand_agreepay_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_recovery_hand_agreepay',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);