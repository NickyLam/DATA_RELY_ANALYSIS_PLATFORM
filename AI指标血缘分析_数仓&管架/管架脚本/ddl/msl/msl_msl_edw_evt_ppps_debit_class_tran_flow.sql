/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_evt_ppps_debit_class_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow(
    etl_dt date
    ,evt_id varchar2(250)
    ,lp_id varchar2(100)
    ,plat_flow_num varchar2(100)
    ,plat_tran_dt date
    ,plat_tran_tm timestamp
    ,prod_id varchar2(100)
    ,adv_flg varchar2(10)
    ,check_entry_idf_type_cd varchar2(30)
    ,check_entry_proc_flg varchar2(10)
    ,check_entry_proc_tm timestamp
    ,check_entry_rest_descb varchar2(500)
    ,check_entry_dt date
    ,check_entry_status_cd varchar2(30)
    ,payer_cust_acct_num varchar2(60)
    ,payer_mobile_no varchar2(60)
    ,payer_acct_num_cate_cd varchar2(30)
    ,payer_acct_num_belong_core_type_cd varchar2(30)
    ,payer_acct_name varchar2(500)
    ,pay_bank_clear_bk_num varchar2(60)
    ,pay_bank_clear_bk_name varchar2(500)
    ,check_teller_id varchar2(100)
    ,core_revs_flow_num varchar2(100)
    ,core_check_entry_rest_descb varchar2(500)
    ,core_tran_flow_num varchar2(100)
    ,core_resp_dt date
    ,core_resp_tm timestamp
    ,fee_type_cd varchar2(30)
    ,tran_remark varchar2(500)
    ,tran_curr_cd varchar2(30)
    ,tran_proc_status_cd varchar2(30)
    ,tran_postsc varchar2(500)
    ,tran_teller_id varchar2(100)
    ,tran_core_acct_status_cd varchar2(30)
    ,tran_org_id varchar2(100)
    ,tran_amt number(30,2)
    ,tran_cate_cd varchar2(30)
    ,tran_batch_id varchar2(100)
    ,tran_clear_dt date
    ,tran_aging_type_cd varchar2(30)
    ,cust_comm_fee number(30,2)
    ,cross_bank_flg varchar2(10)
    ,free_comm_fee_flg varchar2(10)
    ,clear_type_cd varchar2(30)
    ,clear_flow_num varchar2(100)
    ,chn_id varchar2(100)
    ,chn_check_entry_prod_id varchar2(100)
    ,chn_check_entry_mode_cd varchar2(30)
    ,chn_check_entry_dt date
    ,chn_tran_flow_num varchar2(100)
    ,chn_tran_dt date
    ,chn_tran_tm timestamp
    ,chn_tran_comm_fee number(30,2)
    ,chn_comm_fee_entry_flow_num varchar2(100)
    ,ova_flow_num varchar2(100)
    ,realtm_clear_flg varchar2(10)
    ,recver_cust_acct_num varchar2(60)
    ,recver_mobile_no varchar2(60)
    ,recver_acct_num_cate_cd varchar2(30)
    ,recver_acct_num_belong_core_type_cd varchar2(30)
    ,recver_acct_name varchar2(500)
    ,recv_bank_clear_bk_num varchar2(60)
    ,recv_bank_clear_bk_name_name varchar2(500)
    ,comm_fee_collect_status_cd varchar2(30)
    ,auth_teller_id varchar2(100)
    ,caller_sys_id varchar2(100)
    ,pass_cost_fee number(30,2)
    ,pass_check_entry_rest_descb varchar2(500)
    ,pass_tran_flow_num varchar2(100)
    ,pass_tran_dt date
    ,pass_tran_tm timestamp
    ,pass_sys_code varchar2(60)
    ,pass_resp_flow_num varchar2(100)
    ,pass_resp_dt date
    ,pass_resp_tm timestamp
    ,pass_resp_status_cd varchar2(30)
    ,nostro_cd varchar2(30)
    ,sys_comm_flow_num varchar2(100)
    ,bus_proc_status_cd varchar2(30)
    ,bus_type_cd varchar2(30)
    ,aldy_clear_flg varchar2(10)
    ,aldy_refund_flg varchar2(10)
    ,final_update_tm timestamp
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow is 'PPPS借记类交易交互流水';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.evt_id is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.plat_flow_num is '平台流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.plat_tran_dt is '平台交易日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.plat_tran_tm is '平台交易时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.prod_id is '产品编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.adv_flg is '垫资标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_idf_type_cd is '对账标识类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_proc_flg is '对账处理标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_proc_tm is '对账处理时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_rest_descb is '对账结果描述';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_dt is '对账日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_entry_status_cd is '对账状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.payer_cust_acct_num is '付款方客户账号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.payer_mobile_no is '付款方手机号码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.payer_acct_num_cate_cd is '付款方账号类别代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.payer_acct_num_belong_core_type_cd is '付款方账号所属核心类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.payer_acct_name is '付款方账户名称';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pay_bank_clear_bk_num is '付款行清算行号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pay_bank_clear_bk_name is '付款行清算行名称';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.core_revs_flow_num is '核心冲正流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.core_check_entry_rest_descb is '核心对账结果描述';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.core_resp_dt is '核心响应日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.core_resp_tm is '核心响应时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.fee_type_cd is '计费类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_remark is '交易备注';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_proc_status_cd is '交易处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_postsc is '交易附言';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_core_acct_status_cd is '交易核心账务状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_org_id is '交易机构编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_amt is '交易金额';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_cate_cd is '交易类别代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_batch_id is '交易批次编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_clear_dt is '交易清算日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.tran_aging_type_cd is '交易时效类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.cust_comm_fee is '客户手续费';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.cross_bank_flg is '跨行标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.free_comm_fee_flg is '免手续费标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.clear_type_cd is '清算类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.clear_flow_num is '清算流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_id is '渠道编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_check_entry_prod_id is '渠道对账产品编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_check_entry_mode_cd is '渠道对账模式代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_check_entry_dt is '渠道对账日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_tran_flow_num is '渠道交易流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_tran_dt is '渠道交易日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_tran_tm is '渠道交易时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_tran_comm_fee is '渠道交易手续费';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.chn_comm_fee_entry_flow_num is '渠道手续费记账流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.ova_flow_num is '全局流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.realtm_clear_flg is '实时清算标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recver_cust_acct_num is '收款方客户账号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recver_mobile_no is '收款方手机号码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recver_acct_num_cate_cd is '收款方账号类别代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recver_acct_num_belong_core_type_cd is '收款方账号所属核心类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recver_acct_name is '收款方账户名称';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recv_bank_clear_bk_num is '收款行清算行号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.recv_bank_clear_bk_name_name is '收款行清算行名名称';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.comm_fee_collect_status_cd is '手续费计收状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.caller_sys_id is '调用方系统id';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_cost_fee is '通道成本费';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_check_entry_rest_descb is '通道对账结果描述';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_tran_flow_num is '通道交易流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_tran_dt is '通道交易日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_tran_tm is '通道交易时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_sys_code is '通道系统编码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_resp_flow_num is '通道响应流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_resp_dt is '通道响应日期';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_resp_tm is '通道响应时间';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.pass_resp_status_cd is '通道响应状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.nostro_cd is '往来账代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.sys_comm_flow_num is '系统通讯流水号';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.bus_proc_status_cd is '业务处理状态代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.aldy_clear_flg is '已清算标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.aldy_refund_flg is '已退款标志';
comment on column ${msl_schema}.msl_edw_evt_ppps_debit_class_tran_flow.final_update_tm is '最后更新时间';
