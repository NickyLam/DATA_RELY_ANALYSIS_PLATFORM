/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_coll_tran_dtl_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_coll_tran_dtl_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_coll_tran_dtl_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_coll_tran_dtl_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_batch_no varchar2(100) -- 交易批次号
    ,tran_sub_batch_no varchar2(100) -- 交易子批次号
    ,seq_num varchar2(100) -- 序号
    ,chn_id varchar2(100) -- 渠道编号
    ,mercht_tran_flow_num varchar2(100) -- 商户交易流水号
    ,mercht_tran_dt date -- 商户交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,tran_code varchar2(30) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_amt number(30,2) -- 交易金额
    ,actl_tran_amt number(30,2) -- 实际交易金额
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,pay_acct_id varchar2(100) -- 支付账户编号
    ,pay_acct_name varchar2(500) -- 支付账户名称
    ,pt_type_cd varchar2(100) -- 支付工具类型代码
    ,pay_act_cd varchar2(100) -- 支付动作代码
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,recver_agt_id varchar2(100) -- 收款方协议编号
    ,tran_postsc varchar2(500) -- 交易附言
    ,core_batch_no varchar2(100) -- 核心批次号
    ,core_acct_status_cd varchar2(30) -- 核心账务状态代码
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_req_flow_num varchar2(100) -- 核心请求流水号
    ,core_dt date -- 核心日期
    ,pass_sys_abbr varchar2(500) -- 通道系统简称
    ,plat_return_code varchar2(100) -- 平台返回码
    ,plat_return_code_descb varchar2(1000) -- 平台返回码描述
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,call_sys_id varchar2(100) -- 调用系统编号
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
grant select on ${iml_schema}.evt_coll_tran_dtl_flow to ${icl_schema};
grant select on ${iml_schema}.evt_coll_tran_dtl_flow to ${idl_schema};
grant select on ${iml_schema}.evt_coll_tran_dtl_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_coll_tran_dtl_flow is '代收交易明细流水';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_batch_no is '交易批次号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_sub_batch_no is '交易子批次号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.seq_num is '序号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.mercht_tran_flow_num is '商户交易流水号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.mercht_tran_dt is '商户交易日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.actl_tran_amt is '实际交易金额';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.pay_acct_id is '支付账户编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.pay_acct_name is '支付账户名称';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.pt_type_cd is '支付工具类型代码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.pay_act_cd is '支付动作代码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.recver_agt_id is '收款方协议编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.tran_postsc is '交易附言';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.core_batch_no is '核心批次号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.core_acct_status_cd is '核心账务状态代码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.core_req_flow_num is '核心请求流水号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.core_dt is '核心日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.pass_sys_abbr is '通道系统简称';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.plat_return_code is '平台返回码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.plat_return_code_descb is '平台返回码描述';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.call_sys_id is '调用系统编号';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.fir_create_dt is '首次创建日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.remark is '备注';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_coll_tran_dtl_flow.etl_timestamp is 'ETL处理时间戳';
