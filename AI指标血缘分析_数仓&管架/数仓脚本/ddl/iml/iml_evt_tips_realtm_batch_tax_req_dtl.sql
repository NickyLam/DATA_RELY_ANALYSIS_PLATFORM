/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tips_realtm_batch_tax_req_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,rgst_dt date -- 登记日期
    ,rgst_flow_num varchar2(60) -- 登记流水号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,impose_org_id varchar2(60) -- 征收机关编号
    ,impose_org_name varchar2(150) -- 征收机关名称
    ,entr_dt date -- 委托日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,coll_cate_cd varchar2(10) -- 经收类别代码
    ,recv_bank_bank_no varchar2(60) -- 收款行行号
    ,recvbl_corp_id varchar2(60) -- 收款单位编号
    ,recvbl_acct_id varchar2(60) -- 收款账户编号
    ,recvbl_corp_name varchar2(150) -- 收款单位名称
    ,pay_bank_bank_no varchar2(60) -- 付款行行号
    ,pay_open_bank_no varchar2(60) -- 付款开户行行号
    ,pay_acct_id varchar2(60) -- 付款账户编号
    ,pay_corp_name varchar2(750) -- 缴款单位名称
    ,tran_amt number(30,2) -- 交易金额
    ,proc_status_cd varchar2(10) -- 处理状态代码
    ,tax_bill_id varchar2(60) -- 税票编号
    ,taxpayer_name varchar2(750) -- 纳税人名称
    ,agt_id varchar2(100) -- 协议编号
    ,check_entry_type_descb varchar2(150) -- 对账类型描述
    ,tax_category_cnt number(10) -- 税种条数
    ,tax_dt varchar2(60) -- 扣税日期
    ,rest_code varchar2(90) -- 处理结果编码
    ,rtn_rcpt_postsc varchar2(150) -- 回执附言
    ,acpt_proc_tm date -- 接受处理时间
    ,check_entry_status_cd varchar2(10) -- 对账状态代码
    ,is_print_flg varchar2(10) -- 是否打印标志
    ,tran_type_cd varchar2(10) -- 交易类型代码
    ,core_flow_num varchar2(60) -- 核心流水号
    ,core_dt varchar2(60) -- 核心日期
    ,host_check_entry_status_cd varchar2(10) -- 主机对账状态代码
    ,mode_pay_cd varchar2(10) -- 支付方式代码
    ,taxpayer_idtfy_id varchar2(60) -- 纳税人识别编号
    ,vouch_id varchar2(100) -- 凭证编号
    ,check_entry_type_cd varchar2(10) -- 对账类型代码
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
grant select on ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl is 'TIPS实时批量扣税请求明细';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.rgst_flow_num is '登记流水号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.impose_org_id is '征收机关编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.impose_org_name is '征收机关名称';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.entr_dt is '委托日期';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.coll_cate_cd is '经收类别代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.recv_bank_bank_no is '收款行行号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.recvbl_corp_id is '收款单位编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.recvbl_corp_name is '收款单位名称';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.pay_bank_bank_no is '付款行行号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.pay_open_bank_no is '付款开户行行号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.pay_corp_name is '缴款单位名称';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tax_bill_id is '税票编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.taxpayer_name is '纳税人名称';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.check_entry_type_descb is '对账类型描述';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tax_category_cnt is '税种条数';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tax_dt is '扣税日期';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.rest_code is '处理结果编码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.rtn_rcpt_postsc is '回执附言';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.acpt_proc_tm is '接受处理时间';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.check_entry_status_cd is '对账状态代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.is_print_flg is '是否打印标志';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.core_dt is '核心日期';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.host_check_entry_status_cd is '主机对账状态代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.taxpayer_idtfy_id is '纳税人识别编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.vouch_id is '凭证编号';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.check_entry_type_cd is '对账类型代码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl.etl_timestamp is 'ETL处理时间戳';
