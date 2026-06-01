/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_sugst_pay_appl_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_sugst_pay_appl_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_sugst_pay_appl_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sugst_pay_appl_evt(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(60) -- 申请流水号
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,org_id varchar2(100) -- 机构编号
    ,prod_id varchar2(100) -- 产品编号
    ,appl_tran_type_cd varchar2(30) -- 申请交易类型代码
    ,appl_dt date -- 申请日期
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,bill_med_cd varchar2(30) -- 票据介质代码
    ,bill_id varchar2(100) -- 票据编号
    ,fac_val_amt number(30,2) -- 票面金额
    ,draw_dt date -- 出票日期
    ,exp_dt date -- 到期日期
    ,sugst_payer_cate_cd varchar2(30) -- 提示付款人类别代码
    ,sugst_payer_soci_crdt_cd varchar2(30) -- 提示付款人社会信用代码
    ,sugst_payer_name varchar2(750) -- 提示付款人名称
    ,sugst_payer_open_bank_num varchar2(60) -- 提示付款人开户行号
    ,sugst_payer_org_cd varchar2(30) -- 提示付款人机构代码
    ,pay_bank_no varchar2(60) -- 付款行行号
    ,pay_bank_reply_cd varchar2(30) -- 付款行回复代码
    ,pay_bank_refuse_rs_cd varchar2(30) -- 付款行拒绝原因代码
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,bill_status_cd varchar2(30) -- 票据状态代码
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,clear_rest_cd varchar2(30) -- 清算结果代码
    ,cash_org_role_type_cd varchar2(30) -- 兑付机构角色类型代码
    ,err_cd varchar2(90) -- 错误码
    ,modif_teller_id varchar2(100) -- 修改柜员编号
    ,final_modif_tm varchar2(20) -- 最后修改时间
    ,final_modif_dt date -- 最后修改日期
    ,recver_acct_num varchar2(60) -- 收款人账号
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
grant select on ${iml_schema}.evt_sugst_pay_appl_evt to ${icl_schema};
grant select on ${iml_schema}.evt_sugst_pay_appl_evt to ${idl_schema};
grant select on ${iml_schema}.evt_sugst_pay_appl_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_sugst_pay_appl_evt is '提示付款申请事件';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.org_id is '机构编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.prod_id is '产品编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.appl_tran_type_cd is '申请交易类型代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.bill_med_cd is '票据介质代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.bill_id is '票据编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.fac_val_amt is '票面金额';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.draw_dt is '出票日期';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.exp_dt is '到期日期';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.sugst_payer_cate_cd is '提示付款人类别代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.sugst_payer_soci_crdt_cd is '提示付款人社会信用代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.sugst_payer_name is '提示付款人名称';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.sugst_payer_open_bank_num is '提示付款人开户行号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.sugst_payer_org_cd is '提示付款人机构代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.pay_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.pay_bank_reply_cd is '付款行回复代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.pay_bank_refuse_rs_cd is '付款行拒绝原因代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.bill_status_cd is '票据状态代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.clear_rest_cd is '清算结果代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.cash_org_role_type_cd is '兑付机构角色类型代码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.err_cd is '错误码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.modif_teller_id is '修改柜员编号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.recver_acct_num is '收款人账号';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_sugst_pay_appl_evt.etl_timestamp is 'ETL处理时间戳';
