/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_prmtpay_apply
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
drop table ${iol_schema}.bdms_cpes_prmtpay_apply_ex purge;
alter table ${iol_schema}.bdms_cpes_prmtpay_apply add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_cpes_prmtpay_apply;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_cpes_prmtpay_apply_ex nologging
compress
as
select * from ${iol_schema}.bdms_cpes_prmtpay_apply where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_cpes_prmtpay_apply_ex(
    id -- ID
    ,top_branch_no -- 总行机构号
    ,branch_no -- 交易机构编号
    ,product_no -- 产品号
    ,buss_flag -- 业务标志： 01 申请 02 签收
    ,apply_date -- 交易日期
    ,draft_type -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,draft_id -- 票据ID
    ,apply_id -- 解析表ID
    ,draft_amount -- 票据（包）金额
    ,remit_date -- 出票日
    ,maturity_date -- 到期日
    ,prmt_payer_role -- 提示付款人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,prmt_payer_crt_no -- 提示付款人社会信息用代码
    ,prmt_payer_name -- 提示付款人名称
    ,prmt_payer_bank_no -- 提示付款人开户行号
    ,prmt_payer_brh_no -- 提示付款人机构代码
    ,recept_brh_id -- 提示付款人承接机构代码
    ,payer_bank_no -- 付款行行号
    ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,payer_refuse_rsn -- 付款行拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,status -- 票据状态
    ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,err_code -- 错误码
    ,err_msg -- 错误信息
    ,last_upd_opr -- 最后操作人
    ,last_upd_time -- 最后修改时间
    ,misc -- 备注域
    ,advance_flag -- 
    ,belong_brh_no -- 所属票交所机构号/非法人产品
    ,auto_send -- 是否自动发起YON：1-是、0-否
    ,draft_number -- 票据（包）号
    ,std_amt -- 标准金额
    ,bned_mtmrk -- 不得转让标记
    ,other_op -- 其他处理意见
    ,bt_no -- 业务批次号
    ,set_amt -- 结算金额
    ,set_mode -- 结算方式
    ,clr_tp -- 清算类型
    ,set_date -- 结算日期
    ,rcv_acct_no -- 收款人账号
    ,rcv_acct_svcr -- 收款人行号
    ,deduct_status -- 扣款状态 00 未扣款 01 扣款成功 02 扣款失败 03 扣款中
    ,cd_range -- 票据子区间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,top_branch_no -- 总行机构号
    ,branch_no -- 交易机构编号
    ,product_no -- 产品号
    ,buss_flag -- 业务标志： 01 申请 02 签收
    ,apply_date -- 交易日期
    ,draft_type -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,draft_id -- 票据ID
    ,apply_id -- 解析表ID
    ,draft_amount -- 票据（包）金额
    ,remit_date -- 出票日
    ,maturity_date -- 到期日
    ,prmt_payer_role -- 提示付款人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,prmt_payer_crt_no -- 提示付款人社会信息用代码
    ,prmt_payer_name -- 提示付款人名称
    ,prmt_payer_bank_no -- 提示付款人开户行号
    ,prmt_payer_brh_no -- 提示付款人机构代码
    ,recept_brh_id -- 提示付款人承接机构代码
    ,payer_bank_no -- 付款行行号
    ,payer_sig_nk -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,payer_refuse_rsn -- 付款行拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,deal_status -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,status -- 票据状态
    ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_result -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,cash_role -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,err_code -- 错误码
    ,err_msg -- 错误信息
    ,last_upd_opr -- 最后操作人
    ,last_upd_time -- 最后修改时间
    ,misc -- 备注域
    ,advance_flag -- 
    ,belong_brh_no -- 所属票交所机构号/非法人产品
    ,auto_send -- 是否自动发起YON：1-是、0-否
    ,draft_number -- 票据（包）号
    ,std_amt -- 标准金额
    ,bned_mtmrk -- 不得转让标记
    ,other_op -- 其他处理意见
    ,bt_no -- 业务批次号
    ,set_amt -- 结算金额
    ,set_mode -- 结算方式
    ,clr_tp -- 清算类型
    ,set_date -- 结算日期
    ,rcv_acct_no -- 收款人账号
    ,rcv_acct_svcr -- 收款人行号
    ,deduct_status -- 扣款状态 00 未扣款 01 扣款成功 02 扣款失败 03 扣款中
    ,cd_range -- 票据子区间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_cpes_prmtpay_apply
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_cpes_prmtpay_apply exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_prmtpay_apply_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_prmtpay_apply to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_cpes_prmtpay_apply_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_prmtpay_apply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);