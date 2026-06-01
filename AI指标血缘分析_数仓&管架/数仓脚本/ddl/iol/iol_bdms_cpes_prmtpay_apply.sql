/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_prmtpay_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_prmtpay_apply
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_prmtpay_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_prmtpay_apply(
    id varchar2(60) -- ID
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(18) -- 交易机构编号
    ,product_no varchar2(12) -- 产品号
    ,buss_flag varchar2(3) -- 业务标志： 01 申请 02 签收
    ,apply_date varchar2(12) -- 交易日期
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_id varchar2(60) -- 票据ID
    ,apply_id varchar2(60) -- 解析表ID
    ,draft_amount number(18,2) -- 票据（包）金额
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,prmt_payer_role varchar2(9) -- 提示付款人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
    ,prmt_payer_crt_no varchar2(27) -- 提示付款人社会信息用代码
    ,prmt_payer_name varchar2(675) -- 提示付款人名称
    ,prmt_payer_bank_no varchar2(18) -- 提示付款人开户行号
    ,prmt_payer_brh_no varchar2(15) -- 提示付款人机构代码
    ,recept_brh_id varchar2(15) -- 提示付款人承接机构代码
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,payer_sig_nk varchar2(6) -- 付款行回复标志： SU00 同意 SU01 拒绝
    ,payer_refuse_rsn varchar2(6) -- 付款行拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,status varchar2(9) -- 票据状态
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,settle_result varchar2(5) -- 清算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,cash_role varchar2(9) -- 兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注域
    ,advance_flag varchar2(2) -- 
    ,belong_brh_no varchar2(14) -- 所属票交所机构号/非法人产品
    ,auto_send varchar2(6) -- 是否自动发起YON：1-是、0-否
    ,draft_number varchar2(45) -- 票据（包）号
    ,std_amt number(18,2) -- 标准金额
    ,bned_mtmrk varchar2(6) -- 不得转让标记
    ,other_op varchar2(675) -- 其他处理意见
    ,bt_no varchar2(225) -- 业务批次号
    ,set_amt number(18,2) -- 结算金额
    ,set_mode varchar2(6) -- 结算方式
    ,clr_tp varchar2(6) -- 清算类型
    ,set_date varchar2(12) -- 结算日期
    ,rcv_acct_no varchar2(48) -- 收款人账号
    ,rcv_acct_svcr varchar2(18) -- 收款人行号
    ,deduct_status varchar2(3) -- 扣款状态 00 未扣款 01 扣款成功 02 扣款失败 03 扣款中
    ,cd_range varchar2(38) -- 票据子区间
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
grant select on ${iol_schema}.bdms_cpes_prmtpay_apply to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_prmtpay_apply to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_prmtpay_apply to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_prmtpay_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_prmtpay_apply is '提示付款申请表';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.buss_flag is '业务标志： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.apply_date is '交易日期';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.apply_id is '解析表ID';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.prmt_payer_role is '提示付款人类别： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.prmt_payer_crt_no is '提示付款人社会信息用代码';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.prmt_payer_name is '提示付款人名称';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.prmt_payer_bank_no is '提示付款人开户行号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.prmt_payer_brh_no is '提示付款人机构代码';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.recept_brh_id is '提示付款人承接机构代码';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.payer_sig_nk is '付款行回复标志： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.payer_refuse_rsn is '付款行拒绝原因： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.status is '票据状态';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.settle_result is '清算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.cash_role is '兑付机构角色： CR01 承兑保证行 CR02 贴现保证行 CR03 保证增信行 CR04 贴现行 CR05 承兑行';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.misc is '备注域';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.advance_flag is '';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.belong_brh_no is '所属票交所机构号/非法人产品';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.auto_send is '是否自动发起YON：1-是、0-否';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.std_amt is '标准金额';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.bned_mtmrk is '不得转让标记';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.other_op is '其他处理意见';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.bt_no is '业务批次号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.set_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.set_mode is '结算方式';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.clr_tp is '清算类型';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.set_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.rcv_acct_no is '收款人账号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.rcv_acct_svcr is '收款人行号';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.deduct_status is '扣款状态 00 未扣款 01 扣款成功 02 扣款失败 03 扣款中';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.cd_range is '票据子区间';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_cpes_prmtpay_apply.etl_timestamp is 'ETL处理时间戳';
