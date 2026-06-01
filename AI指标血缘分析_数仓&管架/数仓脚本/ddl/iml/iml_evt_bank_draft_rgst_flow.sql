/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bank_draft_rgst_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bank_draft_rgst_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bank_draft_rgst_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bank_draft_rgst_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,midgrod_flow_num varchar2(100) -- 中台流水号
    ,tran_dt date -- 交易日期
    ,bill_id varchar2(100) -- 票据编号
    ,draw_dt date -- 出票日期
    ,payer_acct_id varchar2(100) -- 付款人账户编号
    ,payer_name varchar2(750) -- 付款人名称
    ,proc_org_id varchar2(100) -- 受理机构编号
    ,draft_type_cd varchar2(30) -- 汇票类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,draw_amt number(30,2) -- 出票金额
    ,cash_bk_bank_no varchar2(60) -- 兑付行行号
    ,cash_bank_name varchar2(750) -- 兑付行名称
    ,recver_name varchar2(750) -- 收款人名称
    ,recver_acct_id varchar2(100) -- 收款人账户编号
    ,cap_usage_cd varchar2(30) -- 资金用途代码
    ,postsc varchar2(750) -- 附言
    ,draft_status_cd varchar2(30) -- 汇票状态代码
    ,draft_src_cd varchar2(30) -- 汇票来源代码
    ,final_holder_open_bank_no varchar2(60) -- 最后持票人开户行行号
    ,final_holder_acct_id varchar2(100) -- 最后持票人账户编号
    ,final_holder_name varchar2(750) -- 最后持票人名称
    ,proc_dt date -- 受理日期
    ,proc_flow_num varchar2(100) -- 受理流水号
    ,proc_teller_id varchar2(100) -- 受理柜员编号
    ,amt_auth_teller_id varchar2(100) -- 金额授权柜员编号
    ,matn_entra_teller_id varchar2(100) -- 维护入场柜员编号
    ,matn_enter_acct_auth_teller_id varchar2(100) -- 维护入账授权柜员编号
    ,print_teller_id varchar2(100) -- 打印柜员编号
    ,print_cnt number(10) -- 打印次数
    ,cash_dt date -- 兑付日期
    ,cash_amt number(30,2) -- 兑付金额
    ,msg_id varchar2(100) -- 报文编号
    ,entr_dt date -- 委托日期
    ,process_cd varchar2(90) -- 处理码
    ,loss_stop_pay_dt date -- 挂失止付日期
    ,loss_stop_pay_teller_id varchar2(100) -- 挂失止付柜员编号
    ,unloss_or_revo_stop_pay_dt date -- 解挂或撤销止付日期
    ,unloss_or_revo_stop_pay_teller_id varchar2(100) -- 解挂或撤销止付柜员编号
    ,loss_applit_cert_type_cd varchar2(30) -- 挂失申请人证件类型代码
    ,loss_applit_cert_no varchar2(60) -- 挂失申请人证件号码
    ,loss_operr_name varchar2(750) -- 挂失经办人名称
    ,loss_operr_cont_addr varchar2(750) -- 挂失经办人联系地址
    ,loss_operr_phone varchar2(90) -- 挂失经办人联系电话
    ,lost_reason varchar2(750) -- 丧失理由
    ,lost_dt date -- 丧失日期
    ,lost_site_descb varchar2(750) -- 丧失地点描述
    ,unloss_applit_cert_type_cd varchar2(30) -- 解挂申请人证件类型代码
    ,unloss_applit_cert_no varchar2(60) -- 解挂申请人证件号码
    ,unloss_operr_name varchar2(750) -- 解挂经办人名称
    ,unloss_operr_cont_addr varchar2(750) -- 解挂经办人联系地址
    ,unloss_operr_phone varchar2(90) -- 解挂经办人联系电话
    ,unloss_rest_descb varchar2(750) -- 解挂处理结果描述
    ,stop_pay_proof_cate varchar2(45) -- 止付证明类别
    ,stop_pay_proof_id varchar2(100) -- 止付证明编号
    ,stop_pay_rs_descb varchar2(750) -- 止付原因描述
    ,stop_pay_exec_org varchar2(375) -- 止付执行机关
    ,stop_pay_exec_person_name varchar2(750) -- 止付执行人员名称
    ,stop_pay_cert_type_cd varchar2(30) -- 止付证件类型代码
    ,stop_pay_cert_no varchar2(60) -- 止付证件号码
    ,revo_stop_pay_proof_cate_cd varchar2(30) -- 撤销止付证明类别代码
    ,revo_stop_pay_proof_id varchar2(100) -- 撤销止付证明编号
    ,revo_stop_pay_rs_descb varchar2(750) -- 撤销止付原因描述
    ,revo_stop_pay_exec_org varchar2(375) -- 撤销止付执行机关
    ,revo_stop_pay_exec_person_name varchar2(750) -- 撤销止付执行人员名称
    ,revo_stop_pay_cert_type_cd varchar2(30) -- 撤销止付证件类型代码
    ,revo_stop_pay_cert_no varchar2(60) -- 撤销止付证件号码
    ,issue_draft_charge_way_cd varchar2(30) -- 签发汇票收费方式代码
    ,charge_flg varchar2(10) -- 收费标志
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,remit_tran_fee_amt number(30,2) -- 汇划费用金额
    ,todos_amt number(30,2) -- 工本费金额
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_bank_draft_rgst_flow to ${icl_schema};
grant select on ${iml_schema}.evt_bank_draft_rgst_flow to ${idl_schema};
grant select on ${iml_schema}.evt_bank_draft_rgst_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bank_draft_rgst_flow is '银行汇票登记流水';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.midgrod_flow_num is '中台流水号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.bill_id is '票据编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.draw_dt is '出票日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.payer_name is '付款人名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.proc_org_id is '受理机构编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.draft_type_cd is '汇票类型代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.draw_amt is '出票金额';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.cash_bk_bank_no is '兑付行行号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.cash_bank_name is '兑付行名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.recver_name is '收款人名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.cap_usage_cd is '资金用途代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.postsc is '附言';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.draft_status_cd is '汇票状态代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.draft_src_cd is '汇票来源代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.final_holder_open_bank_no is '最后持票人开户行行号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.final_holder_acct_id is '最后持票人账户编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.final_holder_name is '最后持票人名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.proc_dt is '受理日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.proc_flow_num is '受理流水号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.proc_teller_id is '受理柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.amt_auth_teller_id is '金额授权柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.matn_entra_teller_id is '维护入场柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.matn_enter_acct_auth_teller_id is '维护入账授权柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.print_teller_id is '打印柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.print_cnt is '打印次数';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.cash_dt is '兑付日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.cash_amt is '兑付金额';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.msg_id is '报文编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.entr_dt is '委托日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.process_cd is '处理码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_stop_pay_dt is '挂失止付日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_stop_pay_teller_id is '挂失止付柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_or_revo_stop_pay_dt is '解挂或撤销止付日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_or_revo_stop_pay_teller_id is '解挂或撤销止付柜员编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_applit_cert_type_cd is '挂失申请人证件类型代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_applit_cert_no is '挂失申请人证件号码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_operr_name is '挂失经办人名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_operr_cont_addr is '挂失经办人联系地址';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.loss_operr_phone is '挂失经办人联系电话';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.lost_reason is '丧失理由';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.lost_dt is '丧失日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.lost_site_descb is '丧失地点描述';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_applit_cert_type_cd is '解挂申请人证件类型代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_applit_cert_no is '解挂申请人证件号码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_operr_name is '解挂经办人名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_operr_cont_addr is '解挂经办人联系地址';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_operr_phone is '解挂经办人联系电话';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.unloss_rest_descb is '解挂处理结果描述';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_proof_cate is '止付证明类别';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_proof_id is '止付证明编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_rs_descb is '止付原因描述';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_exec_org is '止付执行机关';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_exec_person_name is '止付执行人员名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_cert_type_cd is '止付证件类型代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.stop_pay_cert_no is '止付证件号码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_proof_cate_cd is '撤销止付证明类别代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_proof_id is '撤销止付证明编号';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_rs_descb is '撤销止付原因描述';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_exec_org is '撤销止付执行机关';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_exec_person_name is '撤销止付执行人员名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_cert_type_cd is '撤销止付证件类型代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.revo_stop_pay_cert_no is '撤销止付证件号码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.issue_draft_charge_way_cd is '签发汇票收费方式代码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.charge_flg is '收费标志';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.remit_tran_fee_amt is '汇划费用金额';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.todos_amt is '工本费金额';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bank_draft_rgst_flow.etl_timestamp is 'ETL处理时间戳';
