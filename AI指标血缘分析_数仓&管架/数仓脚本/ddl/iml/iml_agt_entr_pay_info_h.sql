/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_entr_pay_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_entr_pay_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_entr_pay_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_entr_pay_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,pay_flow_num varchar2(100) -- 支付流水号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,pay_ser_num varchar2(100) -- 支付序列号
    ,plat_req_flow_num varchar2(100) -- 平台请求流水号
    ,plat_tran_flow_num varchar2(100) -- 平台交易流水号
    ,plat_tran_dt date -- 平台交易日期
    ,core_flow_num varchar2(100) -- 核心流水号
    ,dtl_flow_num varchar2(100) -- 明细流水号
    ,ghb_cust_flg varchar2(10) -- 本行客户标志
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,mode_pay_cd varchar2(60) -- 支付方式代码
    ,pay_dt date -- 支付日期
    ,actl_pay_dt date -- 实际支付日期
    ,pay_tm timestamp -- 支付时间
    ,tran_in_bank_name varchar2(500) -- 转入行名称
    ,recver_name varchar2(500) -- 收款人名称
    ,recver_open_bank_name varchar2(500) -- 收款人开户行名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recver_addr varchar2(500) -- 收款人地址
    ,curr_cd varchar2(30) -- 币种代码
    ,pay_amt number(30,2) -- 支付金额
    ,pay_status_cd varchar2(36) -- 支付状态代码
    ,cap_usage_descb varchar2(1000) -- 资金用途描述
    ,precon_entr_pay_flg varchar2(10) -- 预约受托支付标志
    ,entr_pay_id varchar2(100) -- 受托支付编号
    ,entr_pay_batch_no varchar2(60) -- 受托支付批次号
    ,entr_pay_seq_num varchar2(60) -- 受托支付序号
    ,entr_pay_tot_id varchar2(100) -- 受托支付汇总编号
    ,onl_entr_pay_status_cd varchar2(30) -- 在线受托支付状态代码
    ,onl_entred_init_tran_plat_flow_num varchar2(100) -- 在线受托原交易平台流水号
    ,onl_entred_stop_pay_tran_flow_num varchar2(100) -- 在线受托止付交易流水号
    ,stop_pay_flow_num varchar2(100) -- 止付流水号
    ,stop_pay_tran_dt date -- 止付交易日期
    ,froz_flow_num varchar2(100) -- 冻结流水号
    ,a_send_tm timestamp -- 重新发送时间
    ,pay_fail_rs_descb varchar2(500) -- 支付失败原因描述
    ,bank_int_acct_flg varchar2(10) -- 行内账户标志
    ,repeat_status_cd varchar2(30) -- 重发状态代码
    ,cfm_status_cd varchar2(30) -- 确认状态代码
    ,move_flg varchar2(160) -- 迁移标志
    ,latest_pay_dt date -- 最迟支付日期
    ,matn_idf_cd varchar2(30) -- 维护标识代码
    ,cross_bor_flg varchar2(10) -- 跨境标志
    ,loan_usage_descb varchar2(500) -- 贷款用途描述
    ,remark varchar2(1000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_entr_pay_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_entr_pay_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_entr_pay_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_entr_pay_info_h is '受托支付信息历史';
comment on column ${iml_schema}.agt_entr_pay_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_flow_num is '支付流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_ser_num is '支付序列号';
comment on column ${iml_schema}.agt_entr_pay_info_h.plat_req_flow_num is '平台请求流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.plat_tran_flow_num is '平台交易流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.core_flow_num is '核心流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.dtl_flow_num is '明细流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.ghb_cust_flg is '本行客户标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_entr_pay_info_h.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_dt is '支付日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.actl_pay_dt is '实际支付日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_tm is '支付时间';
comment on column ${iml_schema}.agt_entr_pay_info_h.tran_in_bank_name is '转入行名称';
comment on column ${iml_schema}.agt_entr_pay_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_entr_pay_info_h.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.agt_entr_pay_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.recver_addr is '收款人地址';
comment on column ${iml_schema}.agt_entr_pay_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_amt is '支付金额';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_status_cd is '支付状态代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.cap_usage_descb is '资金用途描述';
comment on column ${iml_schema}.agt_entr_pay_info_h.precon_entr_pay_flg is '预约受托支付标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.entr_pay_id is '受托支付编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.entr_pay_batch_no is '受托支付批次号';
comment on column ${iml_schema}.agt_entr_pay_info_h.entr_pay_seq_num is '受托支付序号';
comment on column ${iml_schema}.agt_entr_pay_info_h.entr_pay_tot_id is '受托支付汇总编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.onl_entr_pay_status_cd is '在线受托支付状态代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.onl_entred_init_tran_plat_flow_num is '在线受托原交易平台流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.onl_entred_stop_pay_tran_flow_num is '在线受托止付交易流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.stop_pay_flow_num is '止付流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.stop_pay_tran_dt is '止付交易日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.froz_flow_num is '冻结流水号';
comment on column ${iml_schema}.agt_entr_pay_info_h.a_send_tm is '重新发送时间';
comment on column ${iml_schema}.agt_entr_pay_info_h.pay_fail_rs_descb is '支付失败原因描述';
comment on column ${iml_schema}.agt_entr_pay_info_h.bank_int_acct_flg is '行内账户标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.repeat_status_cd is '重发状态代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.cfm_status_cd is '确认状态代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.move_flg is '迁移标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.latest_pay_dt is '最迟支付日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.matn_idf_cd is '维护标识代码';
comment on column ${iml_schema}.agt_entr_pay_info_h.cross_bor_flg is '跨境标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_entr_pay_info_h.remark is '备注';
comment on column ${iml_schema}.agt_entr_pay_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_entr_pay_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_entr_pay_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_entr_pay_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_entr_pay_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_entr_pay_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_entr_pay_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_entr_pay_info_h.etl_timestamp is 'ETL处理时间戳';
