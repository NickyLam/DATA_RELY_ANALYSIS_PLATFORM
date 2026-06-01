/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_redsct_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_redsct_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_redsct_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_contract(
    id varchar2(60) -- 
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,deal_no varchar2(30) -- 成交单编号
    ,quote_no varchar2(26) -- 报价单编号
    ,ref_apply_no varchar2(15) -- 申请单修改关联号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(18) -- 机构号
    ,recept_brh_id varchar2(15) -- 承接行机构代码
    ,apply_date varchar2(12) -- 业务申请日期
    ,busi_type varchar2(8) -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,trader_id varchar2(15) -- 交易员ID
    ,cfm_trader_id varchar2(15) -- 确认人ID
    ,pbc_brh_no varchar2(15) -- 人行机构代码
    ,acpt_user_id varchar2(15) -- 人行机构受理人用户ID
    ,acpt_user_name varchar2(150) -- 人行机构受理人名称
    ,acpt_user_note varchar2(450) -- 受理审核人审批意见
    ,complete_user_id varchar2(15) -- 人行机构复核人用户ID
    ,complete_user_name varchar2(150) -- 人行机构复核人名称
    ,complete_user_note varchar2(450) -- 复核人审批意见
    ,approval_user_id varchar2(15) -- 人行机构审批人用户ID
    ,approval_user_name varchar2(150) -- 人行机构审批人名称
    ,approval_user_note varchar2(450) -- 审批人审批意见
    ,draft_type varchar2(6) -- 票据类型：AC01-银承 AC02-商承
    ,draft_attr varchar2(6) -- 票据介质：ME01-纸票 ME02-电票
    ,sum_count number(8,0) -- 票据张数
    ,sum_amount number(18,2) -- 票据总额
    ,buy_back_amt number(18,2) -- 回购金额
    ,tenor_days number(8,0) -- 持票期限
    ,clear_speed varchar2(6) -- 清算速度： CS00 T+0 CS01 T+1
    ,clear_type varchar2(6) -- 清算类型： CT01 全额清算 CT02 净额清算
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,settle_amt number(18,2) -- 结算金额
    ,due_settle_amt number(18,2) -- 到期结算金额
    ,settle_date varchar2(12) -- 结算日期
    ,due_settle_date varchar2(12) -- 到期结算日期
    ,rate number(7,6) -- 再贴现利率
    ,pay_interest number(18,2) -- 应付利息
    ,department_no varchar2(15) -- 部门编号
    ,manager_no varchar2(30) -- 客户经理
    ,approve_result varchar2(6) -- 审批结果： SU00 同意 SU01 拒绝
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,settle_status varchar2(6) -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,created_by varchar2(45) -- 创建人
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,status varchar2(3) -- id
    ,due_pay_interest number(18,2) -- 到期应付利息
    ,own_pro_no varchar2(14) -- 本方非法人产品
    ,own_pro_name varchar2(150) -- 本方非法人产品名称
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
grant select on ${iol_schema}.bdms_cpes_redsct_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_redsct_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_redsct_contract is '再贴现批次信息表';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.id is '';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.deal_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.ref_apply_no is '申请单修改关联号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.recept_brh_id is '承接行机构代码';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.apply_date is '业务申请日期';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.busi_type is '业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.trader_id is '交易员ID';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.cfm_trader_id is '确认人ID';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.pbc_brh_no is '人行机构代码';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.acpt_user_id is '人行机构受理人用户ID';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.acpt_user_name is '人行机构受理人名称';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.acpt_user_note is '受理审核人审批意见';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.complete_user_id is '人行机构复核人用户ID';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.complete_user_name is '人行机构复核人名称';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.complete_user_note is '复核人审批意见';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.approval_user_id is '人行机构审批人用户ID';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.approval_user_name is '人行机构审批人名称';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.approval_user_note is '审批人审批意见';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.draft_type is '票据类型：AC01-银承 AC02-商承';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.draft_attr is '票据介质：ME01-纸票 ME02-电票';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.buy_back_amt is '回购金额';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.tenor_days is '持票期限';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.clear_speed is '清算速度： CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.clear_type is '清算类型： CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.settle_mode is '结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.due_settle_amt is '到期结算金额';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.due_settle_date is '到期结算日期';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.rate is '再贴现利率';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.approve_result is '审批结果： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.message_status is '报文处理状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.settle_status is '结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.status is 'id';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.due_pay_interest is '到期应付利息';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.own_pro_no is '本方非法人产品';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.own_pro_name is '本方非法人产品名称';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_redsct_contract.etl_timestamp is 'ETL处理时间戳';
