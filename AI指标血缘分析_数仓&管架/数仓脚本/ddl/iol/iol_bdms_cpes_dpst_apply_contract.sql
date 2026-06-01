/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_dpst_apply_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_dpst_apply_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_dpst_apply_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_apply_contract(
    id varchar2(60) -- ID
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,contract_no varchar2(60) -- 批次号
    ,busi_date varchar2(12) -- 业务日期
    ,apply_date varchar2(12) -- 存托申请日期
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(15) -- 业务机构号
    ,acct_branch_no varchar2(15) -- 账务机构号
    ,sum_draft_amount number(18,2) -- 存托票据汇总金额
    ,sum_settle_amount number(18,2) -- 存托结算汇总金额
    ,fin_rate_up number(9,6) -- 存托利率上限
    ,fin_rate_down number(9,6) -- 存托利率下限
    ,rate number(9,6) -- 融资利率
    ,apply_id varchar2(30) -- 存托申请单编号
    ,dpst_no varchar2(30) -- 存托单编号
    ,dpst_result varchar2(2) -- 产品创设结果： 0 创设中 1 创设成功 2 创设失败
    ,dpst_status varchar2(8) -- 申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝
    ,settle_date varchar2(12) -- 结算日期
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)
    ,proc_code varchar2(14) -- 返回码
    ,proc_msg varchar2(1152) -- 返回结果
    ,rs_product varchar2(14) -- 存托应答方存托类产品
    ,rs_product_name varchar2(384) -- 存托产品名称
    ,manager_no varchar2(30) -- 客户经理
    ,department_no varchar2(15) -- 部门编号
    ,contract_status varchar2(3) -- 批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,message_status varchar2(3) -- 报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,product_no varchar2(12) -- 产品号
    ,own_pro_no varchar2(14) -- 本方非法人产品号
    ,own_pro_name varchar2(300) -- 本方非法人产品名称
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,settle_status varchar2(5) -- 结算状态： R20 结算成功 R21 结算失败
    ,settle_fail_code varchar2(6) -- 结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败
    ,cust_brh_no varchar2(15) -- 存托应答机构
    ,cust_name varchar2(270) -- 存托应答机构名称
    ,create_person varchar2(15) -- 创建人
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
grant select on ${iol_schema}.bdms_cpes_dpst_apply_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_dpst_apply_contract is '存托申请业务批次表';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.busi_date is '业务日期';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.apply_date is '存托申请日期';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.sum_draft_amount is '存托票据汇总金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.sum_settle_amount is '存托结算汇总金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.fin_rate_up is '存托利率上限';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.fin_rate_down is '存托利率下限';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.rate is '融资利率';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.dpst_no is '存托单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.dpst_result is '产品创设结果： 0 创设中 1 创设成功 2 创设失败';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.dpst_status is '申请单状态： DAP01 申请单已发送 DAP02 申请单待清算 DAP03 申请单清算中 DAP04 申请单清算成功 DAP05 申请单清算失败 DAP06 申请单已终止 DAP07 申请单已作废 DAP08 申请单异常 DAP09 申请单待复核 DAP10 申请单已拒绝';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.settle_mode is '结算方式： ST01 票款对付(DVP) ST02 纯票过户(FOP)';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.proc_code is '返回码';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.proc_msg is '返回结果';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.rs_product is '存托应答方存托类产品';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.rs_product_name is '存托产品名称';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.contract_status is '批次状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.message_status is '报文状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.own_pro_no is '本方非法人产品号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.own_pro_name is '本方非法人产品名称';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.settle_status is '结算状态： R20 结算成功 R21 结算失败';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.settle_fail_code is '结算失败代码： SF00 买方未确认 SF01 卖方未确认 SF02 双方未确认 SF03 资金结算失败 SF04 票据结算失败';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.cust_brh_no is '存托应答机构';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.cust_name is '存托应答机构名称';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.create_person is '创建人';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_contract.etl_timestamp is 'ETL处理时间戳';
