/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ups_agt_pay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ups_agt_pay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ups_agt_pay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ups_agt_pay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_no varchar2(60) -- 批次号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,bus_kind_id varchar2(100) -- 业务种类编号
    ,tran_type_cd varchar2(100) -- 交易类型代码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_tm timestamp -- 交易时间
    ,aldy_refund_amt number(30,2) -- 已退款金额
    ,aldy_refund_cnt number(10) -- 已退款次数
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,acpt_pay_instr_cd varchar2(30) -- 收付款指令代码
    ,exc_resv_bank_acct_id varchar2(100) -- 备付金银行账户编号
    ,exc_resv_bank_acct_name varchar2(1000) -- 备付金银行账户名称
    ,payer_acct_org_id varchar2(100) -- 付款方账户所属机构编号
    ,payer_acct_type_cd varchar2(1000) -- 付款方账户类型代码
    ,payer_acct_id varchar2(100) -- 付款方账户编号
    ,payer_acct_name varchar2(1000) -- 付款方账户名称
    ,payer_rsrv_mobile_no varchar2(30) -- 付款方预留手机号
    ,send_org_id varchar2(100) -- 发送机构编号
    ,recver_acct_org_id varchar2(100) -- 收款方账户所属机构编号
    ,recver_acct_id varchar2(100) -- 收款方账户编号
    ,recver_acct_name varchar2(1000) -- 收款方账户名称
    ,recver_acct_type_cd varchar2(30) -- 收款方账户类型代码
    ,sign_agt_id varchar2(100) -- 签约协议编号
    ,mercht_id varchar2(100) -- 商户编号
    ,mercht_cate_cd varchar2(30) -- 商户类别代码
    ,mercht_name varchar2(1000) -- 商户名称
    ,level2_mercht_id varchar2(100) -- 二级商户编号
    ,level2_mercht_cate_cd varchar2(30) -- 二级商户类别代码
    ,level2_mercht_name varchar2(1000) -- 二级商户名称
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,sys_type_cd varchar2(30) -- 系统类型代码
    ,sys_tran_dt date -- 系统交易日期
    ,sys_return_code varchar2(100) -- 系统返回码
    ,sys_return_comnt varchar2(1000) -- 系统返回说明
    ,core_flow_num varchar2(100) -- 核心流水号
    ,core_tran_dt date -- 核心交易日期
    ,core_tran_status_cd varchar2(30) -- 核心交易状态代码
    ,aldy_tran_flg varchar2(10) -- 已转移标志
    ,aldy_adj_entry_flg varchar2(10) -- 已调账标志
    ,aldy_clear_flg varchar2(10) -- 已清算标志
    ,check_entry_status_cd varchar2(30) -- 对账状态代码
    ,clear_batch_no varchar2(60) -- 清算批次号
    ,clear_dt date -- 清算日期
    ,indent_id varchar2(100) -- 订单编号
    ,indent_descb varchar2(2000) -- 订单描述
    ,plat_tran_flow_num varchar2(100) -- 平台交易流水号
    ,plat_tran_dt date -- 平台交易日期
    ,plat_tran_tm timestamp -- 平台交易时间
    ,out_plat_flow_num varchar2(100) -- 外联平台流水号
    ,out_ova_plat_flow_num varchar2(100) -- 外联全局平台流水号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,teller_id varchar2(100) -- 柜员编号
    ,create_tm timestamp -- 创建时间
    ,final_update_tm timestamp -- 最后更新时间
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
grant select on ${iml_schema}.evt_ups_agt_pay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ups_agt_pay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ups_agt_pay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ups_agt_pay_flow is '银联协议支付流水';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.batch_no is '批次号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.bus_kind_id is '业务种类编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.aldy_refund_amt is '已退款金额';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.aldy_refund_cnt is '已退款次数';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.acpt_pay_instr_cd is '收付款指令代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.exc_resv_bank_acct_id is '备付金银行账户编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.exc_resv_bank_acct_name is '备付金银行账户名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.payer_acct_org_id is '付款方账户所属机构编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.payer_acct_type_cd is '付款方账户类型代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.payer_acct_id is '付款方账户编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.payer_acct_name is '付款方账户名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.payer_rsrv_mobile_no is '付款方预留手机号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.send_org_id is '发送机构编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.recver_acct_org_id is '收款方账户所属机构编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.recver_acct_id is '收款方账户编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.recver_acct_name is '收款方账户名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.recver_acct_type_cd is '收款方账户类型代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.mercht_id is '商户编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.mercht_cate_cd is '商户类别代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.mercht_name is '商户名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.level2_mercht_id is '二级商户编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.level2_mercht_cate_cd is '二级商户类别代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.level2_mercht_name is '二级商户名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sys_type_cd is '系统类型代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sys_tran_dt is '系统交易日期';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sys_return_code is '系统返回码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.sys_return_comnt is '系统返回说明';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.core_tran_status_cd is '核心交易状态代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.aldy_tran_flg is '已转移标志';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.aldy_adj_entry_flg is '已调账标志';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.aldy_clear_flg is '已清算标志';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.clear_batch_no is '清算批次号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.indent_id is '订单编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.indent_descb is '订单描述';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.plat_tran_flow_num is '平台交易流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.plat_tran_tm is '平台交易时间';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.out_plat_flow_num is '外联平台流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.out_ova_plat_flow_num is '外联全局平台流水号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.teller_id is '柜员编号';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.create_tm is '创建时间';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ups_agt_pay_flow.etl_timestamp is 'ETL处理时间戳';
