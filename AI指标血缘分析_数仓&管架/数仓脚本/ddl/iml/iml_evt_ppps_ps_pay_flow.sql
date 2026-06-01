/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ppps_ps_pay_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ppps_ps_pay_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ppps_ps_pay_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ppps_ps_pay_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,acpt_pay_instr_cd varchar2(30) -- 收付款指令代码
    ,payer_acct_belong_org_id varchar2(100) -- 付款方账户所属机构编号
    ,batch_no varchar2(60) -- 批次号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,pay_status_cd varchar2(30) -- 支付状态代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_amt number(30,8) -- 交易金额
    ,tran_cate_cd varchar2(30) -- 交易类别代码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,tran_remark varchar2(2000) -- 交易备注
    ,adj_entry_way_cd varchar2(30) -- 调账方式代码
    ,aldy_adj_entry_flg varchar2(10) -- 已调账标志
    ,aldy_clear_flg varchar2(10) -- 已清算标志
    ,aldy_tran_flg varchar2(10) -- 已转移标志
    ,bus_return_code varchar2(100) -- 业务返回码
    ,bus_return_comnt varchar2(500) -- 业务返回说明
    ,bus_return_dt date -- 业务返回日期
    ,check_entry_descb varchar2(500) -- 对账描述
    ,check_entry_status_id varchar2(100) -- 对账状态编号
    ,chn_tran_flow_num varchar2(100) -- 渠道交易流水号
    ,core_flow_num varchar2(100) -- 核心流水号
    ,core_req_flow_num varchar2(100) -- 核心请求流水号
    ,core_resp_code varchar2(100) -- 核心响应码
    ,core_resp_info varchar2(1000) -- 核心响应信息
    ,core_revs_dt date -- 核心冲正日期
    ,core_revs_flow_num varchar2(100) -- 核心冲正流水号
    ,core_tran_dt date -- 核心交易日期
    ,core_tran_status_cd varchar2(30) -- 核心交易状态代码
    ,create_tm timestamp -- 创建时间
    ,final_update_tm timestamp -- 最后更新时间
    ,pay_mercht_abbr varchar2(500) -- 付款商户简称
    ,pay_mercht_id varchar2(100) -- 付款商户编号
    ,pay_mercht_name varchar2(500) -- 付款商户名称
    ,payer_acct_id varchar2(100) -- 付款方账户编号
    ,payer_acct_name varchar2(500) -- 付款方账户名称
    ,payer_acct_type_cd varchar2(30) -- 付款方账户类型代码
    ,plat_tran_dt date -- 平台交易日期
    ,plat_tran_flow_num varchar2(100) -- 平台交易流水号
    ,plat_tran_tm timestamp -- 平台交易时间
    ,recver_acct_belong_org_id varchar2(100) -- 收款方账户所属机构编号
    ,recver_acct_id varchar2(100) -- 收款方账户编号
    ,recver_acct_name varchar2(500) -- 收款方账户名称
    ,recver_acct_type_cd varchar2(30) -- 收款方账户类型代码
    ,recver_agt_id varchar2(100) -- 收款方协议编号
    ,recver_tran_flow_num varchar2(100) -- 收款方交易流水号
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,sys_return_code varchar2(100) -- 系统返回码
    ,sys_return_comnt varchar2(500) -- 系统返回说明
    ,sys_type_cd varchar2(30) -- 系统类型代码
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
grant select on ${iml_schema}.evt_ppps_ps_pay_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ppps_ps_pay_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ppps_ps_pay_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ppps_ps_pay_flow is 'PPPS付款流水';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.acpt_pay_instr_cd is '收付款指令代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.payer_acct_belong_org_id is '付款方账户所属机构编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.batch_no is '批次号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.pay_status_cd is '支付状态代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_cate_cd is '交易类别代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.tran_remark is '交易备注';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.adj_entry_way_cd is '调账方式代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.aldy_adj_entry_flg is '已调账标志';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.aldy_clear_flg is '已清算标志';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.aldy_tran_flg is '已转移标志';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.bus_return_code is '业务返回码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.bus_return_comnt is '业务返回说明';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.bus_return_dt is '业务返回日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.check_entry_descb is '对账描述';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.check_entry_status_id is '对账状态编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.chn_tran_flow_num is '渠道交易流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_req_flow_num is '核心请求流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_resp_code is '核心响应码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_resp_info is '核心响应信息';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_revs_dt is '核心冲正日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_revs_flow_num is '核心冲正流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.core_tran_status_cd is '核心交易状态代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.create_tm is '创建时间';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.pay_mercht_abbr is '付款商户简称';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.pay_mercht_id is '付款商户编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.pay_mercht_name is '付款商户名称';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.payer_acct_id is '付款方账户编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.payer_acct_name is '付款方账户名称';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.payer_acct_type_cd is '付款方账户类型代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.plat_tran_flow_num is '平台交易流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.plat_tran_tm is '平台交易时间';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_acct_belong_org_id is '收款方账户所属机构编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_acct_id is '收款方账户编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_acct_name is '收款方账户名称';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_acct_type_cd is '收款方账户类型代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_agt_id is '收款方协议编号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.recver_tran_flow_num is '收款方交易流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.sys_return_code is '系统返回码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.sys_return_comnt is '系统返回说明';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.sys_type_cd is '系统类型代码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ppps_ps_pay_flow.etl_timestamp is 'ETL处理时间戳';
