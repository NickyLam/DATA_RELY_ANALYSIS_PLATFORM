/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_recovery_hand_agreepay
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_recovery_hand_agreepay
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_recovery_hand_agreepay purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_recovery_hand_agreepay(
    id varchar2(60) -- 主键
    ,buss_flag varchar2(3) -- 交易方向： 01 申请 02 签收
    ,product_no varchar2(12) -- 产品号
    ,draft_id varchar2(60) -- 同意清偿票据ID
    ,hand_apply_id varchar2(60) -- 贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID
    ,pub_apply_id varchar2(60) -- 报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID
    ,recovery_type varchar2(6) -- 追索类型： BC14 拒付追索 BC15 非拒付追索
    ,draft_number varchar2(45) -- 票据（包）号
    ,cd_range varchar2(38) -- 同意清偿区间
    ,draft_amount number(18,2) -- 同意清偿金额
    ,recovery_buss_type varchar2(6) -- 追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,recovery_name varchar2(675) -- 追索人名称
    ,recovery_cert_no varchar2(48) -- 追索人社会信息用代码
    ,recovery_dist_tp varchar2(6) -- 追索人识别类型： DT01 票据账户 DT02 银行账户
    ,recovery_account varchar2(48) -- 追索人账号
    ,recovery_brh_no varchar2(14) -- 追索人(开户)机构代码
    ,recovery_bank_no varchar2(18) -- 追索人(开户)行号
    ,recovery_notice_date varchar2(12) -- 追索通知日期
    ,recovery_notice_misc varchar2(675) -- 追索通知备注
    ,recovery_backmisc varchar2(675) -- 追索人撤销说明
    ,recovery_sign_date varchar2(12) -- 追索人应答日期
    ,recovery_sign_mk varchar2(6) -- 追索人应答标识： SU00 同意 SU01 拒绝
    ,recovery_sign_misc varchar2(675) -- 追索人应答备注
    ,berecovered_buss_type varchar2(6) -- 被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,berecovered_name varchar2(675) -- 被追索人名称
    ,berecovered_cert_no varchar2(48) -- 被追索人社会信息用代码
    ,berecovered_dist_tp varchar2(6) -- 被追索人识别类型： DT01 票据账户 DT02 银行账户
    ,berecovered_account varchar2(48) -- 被追索人账号
    ,berecovered_brh_no varchar2(14) -- 被追索人(开户)机构代码
    ,berecovered_agree_date varchar2(12) -- 被追索人同意清偿的申请日期
    ,berecovered_agree_misc varchar2(675) -- 被追索人同意清偿备注
    ,berecovered_agree_number number(12) -- 被追索人同意清偿子票据张数
    ,berecovered_settle_account varchar2(48) -- 被追索人结算账号
    ,berecovered_settle_bank_no varchar2(18) -- 被追索人结算行号
    ,berecovered_backmisc varchar2(675) -- 被追索人撤销说明
    ,settle_type varchar2(6) -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,clear_type varchar2(6) -- 清算类型： CT01 全额清算 CT02 净额清算
    ,settle_date varchar2(12) -- 被追索人同意清偿日期（结算日期）
    ,deal_status varchar2(3) -- 处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,err_code varchar2(14) -- 错误码
    ,err_msg varchar2(1200) -- 错误信息
    ,branch_no varchar2(15) -- 行内机构号
    ,belong_brh_no varchar2(14) -- 所属票交所机构号/非法人产品
    ,top_branch_no varchar2(15) -- 行内总行机构号
    ,create_opr varchar2(15) -- 创建人
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,recovery_mem_no varchar2(9) -- 追索人渠道代码
    ,berecovered_mem_no varchar2(9) -- 被追索人渠道代码
    ,recovery_range varchar2(38) -- 追索通知区间
    ,recovery_amount number(18,2) -- 追索通知金额
    ,recovery_account_name varchar2(675) -- 追索人账户名称
    ,recovery_settle_account_name varchar2(675) -- 追索人结算账户名称
    ,recovery_settle_account varchar2(48) -- 追索人结算账号
    ,recovery_settle_brh_no varchar2(14) -- 追索人结算账户机构代码
    ,recovery_bt_no varchar2(675) -- 追索人业务批次号
    ,berecovered_account_name varchar2(675) -- 被追索人账户名称
    ,berecovered_settle_account_nam varchar2(675) -- 被追索人结算账户名称
    ,berecovered_settle_brh_no varchar2(14) -- 被追索人结算账户机构代码
    ,berecovered_bt_no varchar2(675) -- 被追索人业务批次号
    ,settle_amount number(18,2) -- 结算金额
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
grant select on ${iol_schema}.bdms_cpes_recovery_hand_agreepay to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_hand_agreepay to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_hand_agreepay to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_hand_agreepay to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_recovery_hand_agreepay is '贴现前手动追索同意清偿表';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.id is '主键';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.buss_flag is '交易方向： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.draft_id is '同意清偿票据ID';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.hand_apply_id is '贴现前手动追索申请表CPES_RECOVERY_HAND_APPLY的ID';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.pub_apply_id is '报文公共签收表HTES_PREDISCOUNT_PUB_APPLY的ID';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_type is '追索类型： BC14 拒付追索 BC15 非拒付追索';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.cd_range is '同意清偿区间';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.draft_amount is '同意清偿金额';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_buss_type is '追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_name is '追索人名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_cert_no is '追索人社会信息用代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_dist_tp is '追索人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_account is '追索人账号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_brh_no is '追索人(开户)机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_bank_no is '追索人(开户)行号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_notice_date is '追索通知日期';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_notice_misc is '追索通知备注';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_backmisc is '追索人撤销说明';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_sign_date is '追索人应答日期';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_sign_mk is '追索人应答标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_sign_misc is '追索人应答备注';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_buss_type is '被追索人业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_name is '被追索人名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_cert_no is '被追索人社会信息用代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_dist_tp is '被追索人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_account is '被追索人账号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_brh_no is '被追索人(开户)机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_agree_date is '被追索人同意清偿的申请日期';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_agree_misc is '被追索人同意清偿备注';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_agree_number is '被追索人同意清偿子票据张数';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_settle_account is '被追索人结算账号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_settle_bank_no is '被追索人结算行号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_backmisc is '被追索人撤销说明';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.settle_type is '结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.clear_type is '清算类型： CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.settle_date is '被追索人同意清偿日期（结算日期）';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.deal_status is '处理状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.branch_no is '行内机构号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.belong_brh_no is '所属票交所机构号/非法人产品';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.top_branch_no is '行内总行机构号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.create_opr is '创建人';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_mem_no is '追索人渠道代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_mem_no is '被追索人渠道代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_range is '追索通知区间';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_amount is '追索通知金额';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_account_name is '追索人账户名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_settle_account_name is '追索人结算账户名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_settle_account is '追索人结算账号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_settle_brh_no is '追索人结算账户机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.recovery_bt_no is '追索人业务批次号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_account_name is '被追索人账户名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_settle_account_nam is '被追索人结算账户名称';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_settle_brh_no is '被追索人结算账户机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.berecovered_bt_no is '被追索人业务批次号';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.settle_amount is '结算金额';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_cpes_recovery_hand_agreepay.etl_timestamp is 'ETL处理时间戳';
