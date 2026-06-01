/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_fund_adv_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_fund_adv_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_fund_adv_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fund_adv_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,intnal_brch_id varchar2(100) -- 内部分行编号
    ,tran_dt date -- 交易日期
    ,recv_org_id varchar2(100) -- 收单机构编号
    ,seq_num varchar2(60) -- 序号
    ,agt_corp_id varchar2(100) -- 协议单位编号
    ,clear_acct_id varchar2(100) -- 清算账户编号
    ,clear_intnal_acct_id varchar2(100) -- 清算内部账户编号
    ,clear_intnal_acct_name varchar2(750) -- 清算内部账户名称
    ,clear_dt date -- 清算日期
    ,stl_mode_descb varchar2(750) -- 结算模式描述
    ,tot_e_amt number(30,2) -- 总额度
    ,used_lmt number(30,2) -- 已使用额度
    ,comm_fee_amt number(30,2) -- 手续费金额
    ,unionpay_sucs_amt number(30,2) -- 银联成功金额
    ,tot number(30,2) -- 总笔数
    ,tot_amt number(30,2) -- 总金额
    ,sucs_cnt number(30,2) -- 成功笔数
    ,sucs_tot_amt number(30,2) -- 成功总金额
    ,fail_cnt number(30,2) -- 失败笔数
    ,fail_amt number(30,2) -- 失败金额
    ,not_tran_cnt number(30,2) -- 未明交易笔数
    ,not_tran_amt number(30,2) -- 未明交易金额
    ,payfan_repay_amt number(30,2) -- 代付还款金额
    ,bus_cfm_amt number(30,2) -- 业务确认金额
    ,cfm_ps_id varchar2(100) -- 确认人编号
    ,cfm_status_cd varchar2(30) -- 确认状态代码
    ,actl_remit_acct_amt number(30,2) -- 实际划账金额
    ,aldy_remit_acct_flg varchar2(10) -- 划账状态代码
    ,core_flow_num varchar2(100) -- 核心流水号
    ,err_descb varchar2(750) -- 错误描述
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
grant select on ${iml_schema}.evt_fund_adv_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_fund_adv_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_fund_adv_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_fund_adv_tran_flow is '基金垫资交易流水';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.intnal_brch_id is '内部分行编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.recv_org_id is '收单机构编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.seq_num is '序号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.agt_corp_id is '协议单位编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.clear_acct_id is '清算账户编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.clear_intnal_acct_id is '清算内部账户编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.clear_intnal_acct_name is '清算内部账户名称';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.stl_mode_descb is '结算模式描述';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.tot_e_amt is '总额度';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.used_lmt is '已使用额度';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.comm_fee_amt is '手续费金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.unionpay_sucs_amt is '银联成功金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.tot is '总笔数';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.tot_amt is '总金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.sucs_cnt is '成功笔数';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.sucs_tot_amt is '成功总金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.fail_cnt is '失败笔数';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.fail_amt is '失败金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.not_tran_cnt is '未明交易笔数';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.not_tran_amt is '未明交易金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.payfan_repay_amt is '代付还款金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.bus_cfm_amt is '业务确认金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.cfm_ps_id is '确认人编号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.cfm_status_cd is '确认状态代码';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.actl_remit_acct_amt is '实际划账金额';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.aldy_remit_acct_flg is '划账状态代码';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.core_flow_num is '核心流水号';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.err_descb is '错误描述';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_fund_adv_tran_flow.etl_timestamp is 'ETL处理时间戳';
