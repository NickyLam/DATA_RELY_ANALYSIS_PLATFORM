/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_buy_back_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_buy_back_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_buy_back_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_back_contract(
    id varchar2(60) -- 
    ,apply_id varchar2(60) -- APPLY表ID
    ,contract_no varchar2(60) -- 批次号
    ,org_contract_id varchar2(60) -- 原质押式对话报价业务批次ID
    ,org_credit_status varchar2(3) -- 原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,product_no varchar2(12) -- 产品号
    ,buss_flag varchar2(3) -- 业务类型： 01 申请 02 签收
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(18) -- 机构号
    ,apply_date varchar2(12) -- 业务申请日期
    ,brh_name varchar2(150) -- 本方机构名称
    ,brh_no varchar2(14) -- 本方机构号
    ,adver_brh_name varchar2(300) -- 交易对手名称
    ,adver_brh_no varchar2(14) -- 交易对手机构号
    ,adver_bank_no varchar2(18) -- 交易对手行行号
    ,adver_pro_no varchar2(14) -- 交易对手非法人产品
    ,deal_no varchar2(30) -- 成交单编号
    ,buy_back_type varchar2(8) -- 赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回
    ,buy_back_reason varchar2(8) -- 赎回事由： BBR01 存在风险票据 BBR02 其它情形
    ,buy_back_result varchar2(2) -- 赎回结果： 0 未完成 1 成功 2 失败
    ,req_deal_opi varchar2(225) -- 赎回发起方处理意见
    ,sign_deal_opi varchar2(225) -- 赎回签收方处理意见
    ,req_misc varchar2(675) -- 赎回发起方备注
    ,sign_misc varchar2(675) -- 赎回签收方备注
    ,apv_sign_mk varchar2(6) -- 场务处理结果： SU00 同意 SU01 拒绝
    ,apv_opi varchar2(225) -- 场务处理意见
    ,sign_mk varchar2(6) -- 应答标识： SU00 同意 SU01 拒绝
    ,err_code varchar2(30) -- 错误码
    ,err_mesg varchar2(384) -- 错误原因
    ,department_no varchar2(30) -- 所属部门号
    ,manage_no varchar2(30) -- 客户经理号
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,sum_amount number(18,2) -- 票据总额
    ,sum_count number(8,0) -- 票据张数
    ,org_buy_back_amount number(18,2) -- 原业务回购金额
    ,settle_amount number(18,2) -- 首期结算金额
    ,buy_back_settle_amount number(18,2) -- 赎回结算金额
    ,buy_back_rate number(7,6) -- 回购利率
    ,org_pay_interest number(18,2) -- 原业务应付利息
    ,buy_back_pay_interest number(18,2) -- 赎回应付利息
    ,buy_back_yield_rate number(13,6) -- 回购收益率
    ,org_settle_date varchar2(12) -- 原业务首期结算日
    ,org_due_settle_date varchar2(12) -- 原业务到期结算日
    ,credit_status varchar2(3) -- 额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,valid_flag varchar2(3) -- 有效标识： 0 无效 1 有效
    ,message_status varchar2(3) -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,created_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_cpes_buy_back_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_buy_back_contract is '提前和逾期赎回申请批次表';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.id is '';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.apply_id is 'APPLY表ID';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_contract_id is '原质押式对话报价业务批次ID';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_credit_status is '原业务额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buss_flag is '业务类型： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.apply_date is '业务申请日期';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.brh_name is '本方机构名称';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.brh_no is '本方机构号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.adver_brh_name is '交易对手名称';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.adver_brh_no is '交易对手机构号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.adver_bank_no is '交易对手行行号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.adver_pro_no is '交易对手非法人产品';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.deal_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_type is '赎回类别： BBT01 提前赎回 BBT02 逾期赎回 BBT03 部分逾期赎回';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_reason is '赎回事由： BBR01 存在风险票据 BBR02 其它情形';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_result is '赎回结果： 0 未完成 1 成功 2 失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.req_deal_opi is '赎回发起方处理意见';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.sign_deal_opi is '赎回签收方处理意见';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.req_misc is '赎回发起方备注';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.sign_misc is '赎回签收方备注';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.apv_sign_mk is '场务处理结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.apv_opi is '场务处理意见';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.sign_mk is '应答标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.err_mesg is '错误原因';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.department_no is '所属部门号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.manage_no is '客户经理号';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_buy_back_amount is '原业务回购金额';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.settle_amount is '首期结算金额';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_settle_amount is '赎回结算金额';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_rate is '回购利率';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_pay_interest is '原业务应付利息';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_pay_interest is '赎回应付利息';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.buy_back_yield_rate is '回购收益率';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_settle_date is '原业务首期结算日';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.org_due_settle_date is '原业务到期结算日';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.credit_status is '额度占用状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.valid_flag is '有效标识： 0 无效 1 有效';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.message_status is '报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_buy_back_contract.etl_timestamp is 'ETL处理时间戳';
