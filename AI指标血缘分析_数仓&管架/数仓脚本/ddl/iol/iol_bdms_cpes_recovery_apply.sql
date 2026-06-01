/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_recovery_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_recovery_apply
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_recovery_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_recovery_apply(
    id varchar2(60) -- 
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(18) -- 机构号
    ,product_no varchar2(12) -- 产品号
    ,apply_date varchar2(12) -- 申请日期
    ,draft_type varchar2(6) -- 票据类型：AC01-银承 AC02-商承
    ,draft_attr varchar2(6) -- 票据介质：ME01-纸票 ME02-电票
    ,draft_id varchar2(60) -- 票据ID
    ,draft_amount number(18,2) -- 票面金额
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,recoveryrole varchar2(9) -- 追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,recovery_crt_no varchar2(27) -- 追偿人社会信息用代码
    ,recovery_name varchar2(150) -- 追偿人名称
    ,recovery_bank_no varchar2(18) -- 追偿人开户行号
    ,recovery_brh_no varchar2(15) -- 追偿人机构代码
    ,recept_brh_id varchar2(15) -- 追偿人承接机构代码
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,payer_sig_nk varchar2(6) -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,present_date varchar2(12) -- 提示付款日期
    ,present_brh_no varchar2(15) -- 提示付款机构代码
    ,present_sigmk varchar2(6) -- 提示付款应答代码： SU00 同意 SU01 拒绝
    ,pst_refuse_rsn varchar2(6) -- 提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,pst_settle_rst varchar2(5) -- 提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,pst_misc varchar2(675) -- 提示付款备注
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,status varchar2(6) -- 票据状态
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_result varchar2(6) -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,buss_flag varchar2(3) -- 交易方向： 01 申请 02 签收
    ,cash_role varchar2(6) -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,re_recovery_lock_flag varchar2(2) -- 再追偿锁定标识： 0 未锁定 1 已锁定
    ,belong_brh_no varchar2(14) -- 所属票交所机构号/非法人产品
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
grant select on ${iol_schema}.bdms_cpes_recovery_apply to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_apply to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_apply to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_recovery_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_recovery_apply is '追偿申请表';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.id is '';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.apply_date is '申请日期';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.draft_type is '票据类型：AC01-银承 AC02-商承';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.draft_attr is '票据介质：ME01-纸票 ME02-电票';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recoveryrole is '追偿人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recovery_crt_no is '追偿人社会信息用代码';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recovery_name is '追偿人名称';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recovery_bank_no is '追偿人开户行号';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recovery_brh_no is '追偿人机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.recept_brh_id is '追偿人承接机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.payer_sig_nk is '付款行回复标志： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.present_date is '提示付款日期';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.present_brh_no is '提示付款机构代码';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.present_sigmk is '提示付款应答代码： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.pst_refuse_rsn is '提示付款拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.pst_settle_rst is '提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.pst_misc is '提示付款备注';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.status is '票据状态';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.settle_result is '清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.buss_flag is '交易方向： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.cash_role is '兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.re_recovery_lock_flag is '再追偿锁定标识： 0 未锁定 1 已锁定';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.belong_brh_no is '所属票交所机构号/非法人产品';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_recovery_apply.etl_timestamp is 'ETL处理时间戳';
