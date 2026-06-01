/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ppps_crdt_class_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ppps_crdt_class_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ppps_crdt_class_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ppps_crdt_class_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_cate_cd varchar2(30) -- 交易类别代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,bus_status_cd varchar2(30) -- 业务状态代码
    ,nostro_cd varchar2(30) -- 往来账代码
    ,chn_id varchar2(100) -- 渠道编号
    ,mercht_tran_flow_num varchar2(100) -- 商户交易流水号
    ,mercht_tran_dt date -- 商户交易日期
    ,tran_amt number(30,2) -- 交易金额
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_aging_type_cd varchar2(30) -- 交易时效类型代码
    ,tran_proc_status_cd varchar2(30) -- 交易处理状态代码
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,realtm_clear_flg varchar2(10) -- 实时清算标志
    ,clear_dt date -- 清算日期
    ,sign_agt_id varchar2(100) -- 签约协议编号
    ,tran_postsc varchar2(500) -- 交易附言
    ,recvbl_cert_type_cd varchar2(30) -- 收款证件类型代码
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_cate_cd varchar2(30) -- 收款账户类别代码
    ,recvbl_acct_belong_sys_cd varchar2(30) -- 收款账户归属系统代码
    ,recvbl_mobile_no varchar2(60) -- 收款手机号码
    ,recvbl_clear_bk_no varchar2(60) -- 收款清算行行号
    ,recvbl_clear_bk_name varchar2(500) -- 收款清算行名称
    ,pay_cert_type_cd varchar2(30) -- 付款证件类型代码
    ,pay_acct_id varchar2(100) -- 付款账户编号
    ,pay_acct_name varchar2(500) -- 付款账户名称
    ,pay_acct_cate_cd varchar2(30) -- 付款账户类别代码
    ,pay_acct_belong_sys_cd varchar2(30) -- 付款账户归属系统代码
    ,pay_bank_clear_bk_num varchar2(60) -- 付款行清算行号
    ,pay_clear_bk_name varchar2(500) -- 付款清算行名称
    ,actl_pay_acct_id varchar2(100) -- 实际付款账户编号
    ,actl_pay_name varchar2(500) -- 实际付款名称
    ,actl_pay_acct_cate_cd varchar2(30) -- 实际付款账户类别代码
    ,actl_pay_acct_belong_sys_cd varchar2(30) -- 实际付款账户归属系统代码
    ,acm_lmt_type_cd varchar2(30) -- 累计限额类型代码
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_acct_status_cd varchar2(30) -- 核心账务状态代码
    ,core_dt date -- 核心日期
    ,call_pass_flow_num varchar2(100) -- 调用通道流水号
    ,pass_sys_abbr varchar2(500) -- 通道系统简称
    ,pass_tran_flow_num varchar2(100) -- 通道交易流水号
    ,pass_init_status_cd varchar2(30) -- 通道原始状态代码
    ,pass_resp_flow_num varchar2(100) -- 通道响应流水号
    ,pass_resp_dt date -- 通道响应日期
    ,pass_resp_status_cd varchar2(30) -- 通道响应状态代码
    ,pass_tran_dt date -- 通道交易日期
    ,pass_cost_fee number(30,2) -- 通道成本费
    ,check_entry_dt date -- 对账日期
    ,check_entry_proc_idf varchar2(10) -- 对账处理标识
    ,check_entry_idf_type_cd varchar2(30) -- 对账标识类型代码
    ,check_entry_rest_descb varchar2(500) -- 对账结果描述
    ,check_entry_proc_dt date -- 对账处理日期
    ,chn_check_entry_code varchar2(60) -- 渠道对账编码
    ,chn_check_entry_dt date -- 渠道对账日期
    ,chn_check_entry_mode_cd varchar2(30) -- 渠道对账模式代码
    ,pass_check_entry_proc_descb varchar2(500) -- 通道对账处理描述
    ,cross_bank_flg varchar2(60) -- 跨行标志
    ,coll_comm_fee_flg varchar2(10) -- 收取手续费标志
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,need_delay_tran_acct_flg varchar2(10) -- 需要延时转账标志
    ,delay_tm varchar2(30) -- 延长时间
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,call_sys_id varchar2(100) -- 调用系统编号
    ,sorc_sys_id varchar2(100) -- 源系统编号
    ,adv_exp_flg varchar2(10) -- 垫支标志
    ,belong_sys_id varchar2(100) -- 归属系统编号
    ,fir_create_dt date -- 首次创建日期
    ,final_update_dt date -- 最后更新日期
    ,remark varchar2(500) -- 备注
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
grant select on ${iml_schema}.evt_ppps_crdt_class_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ppps_crdt_class_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ppps_crdt_class_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ppps_crdt_class_tran_flow is 'PPPS贷记类交易流水';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_cate_cd is '交易类别代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.bus_status_cd is '业务状态代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.nostro_cd is '往来账代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.mercht_tran_flow_num is '商户交易流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.mercht_tran_dt is '商户交易日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_aging_type_cd is '交易时效类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_proc_status_cd is '交易处理状态代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.realtm_clear_flg is '实时清算标志';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.tran_postsc is '交易附言';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_cert_type_cd is '收款证件类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_acct_cate_cd is '收款账户类别代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_acct_belong_sys_cd is '收款账户归属系统代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_mobile_no is '收款手机号码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_clear_bk_no is '收款清算行行号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.recvbl_clear_bk_name is '收款清算行名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_cert_type_cd is '付款证件类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_acct_cate_cd is '付款账户类别代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_acct_belong_sys_cd is '付款账户归属系统代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_bank_clear_bk_num is '付款行清算行号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pay_clear_bk_name is '付款清算行名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.actl_pay_acct_id is '实际付款账户编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.actl_pay_name is '实际付款名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.actl_pay_acct_cate_cd is '实际付款账户类别代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.actl_pay_acct_belong_sys_cd is '实际付款账户归属系统代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.acm_lmt_type_cd is '累计限额类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.core_acct_status_cd is '核心账务状态代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.core_dt is '核心日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.call_pass_flow_num is '调用通道流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_sys_abbr is '通道系统简称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_tran_flow_num is '通道交易流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_init_status_cd is '通道原始状态代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_resp_flow_num is '通道响应流水号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_resp_dt is '通道响应日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_resp_status_cd is '通道响应状态代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_tran_dt is '通道交易日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_cost_fee is '通道成本费';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_entry_proc_idf is '对账处理标识';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_entry_idf_type_cd is '对账标识类型代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_entry_rest_descb is '对账结果描述';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_entry_proc_dt is '对账处理日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.chn_check_entry_code is '渠道对账编码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.chn_check_entry_dt is '渠道对账日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.chn_check_entry_mode_cd is '渠道对账模式代码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.pass_check_entry_proc_descb is '通道对账处理描述';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.cross_bank_flg is '跨行标志';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.coll_comm_fee_flg is '收取手续费标志';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.need_delay_tran_acct_flg is '需要延时转账标志';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.delay_tm is '延长时间';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.call_sys_id is '调用系统编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.sorc_sys_id is '源系统编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.adv_exp_flg is '垫支标志';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.belong_sys_id is '归属系统编号';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.fir_create_dt is '首次创建日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.remark is '备注';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ppps_crdt_class_tran_flow.etl_timestamp is 'ETL处理时间戳';
