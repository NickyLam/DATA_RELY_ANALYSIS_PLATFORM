/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_myloan_repay_inst_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_myloan_repay_inst_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_myloan_repay_inst_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_myloan_repay_inst_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,pd_num varchar2(60) -- 期次号
    ,repay_dt date -- 还款日期
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,dubil_id varchar2(60) -- 借据编号
    ,repay_wdraw_odd_no varchar2(100) -- 还款提现单号
    ,repay_amt_type_cd varchar2(10) -- 还款金额类型代码
    ,rpbl_nomal_pric number(30,6) -- 应还正常本金
    ,rpbl_nomal_int number(30,6) -- 应还正常利息
    ,rpbl_ovdue_pric_pnlt number(30,6) -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt number(30,6) -- 应还逾期利息罚息
    ,paid_tot_amt number(30,6) -- 实还总金额
    ,paid_pric number(30,6) -- 实还本金
    ,paid_int number(30,6) -- 实还利息
    ,paid_ovdue_pric_pnlt number(30,6) -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt number(30,6) -- 实还逾期利息罚息
    ,bf_repay_acru_non_acru_flg varchar2(100) -- 还款前应计非应计标志
    ,modif_bf_status_cd varchar2(100) -- 变更前状态代码
    ,wrt_off_flg varchar2(10) -- 核销标志
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
grant select on ${iml_schema}.evt_myloan_repay_inst_flow to ${icl_schema};
grant select on ${iml_schema}.evt_myloan_repay_inst_flow to ${idl_schema};
grant select on ${iml_schema}.evt_myloan_repay_inst_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_myloan_repay_inst_flow is '网商贷还款分期流水';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.pd_num is '期次号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.repay_wdraw_odd_no is '还款提现单号';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.repay_amt_type_cd is '还款金额类型代码';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.rpbl_nomal_pric is '应还正常本金';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.rpbl_nomal_int is '应还正常利息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.rpbl_ovdue_pric_pnlt is '应还逾期本金罚息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.rpbl_ovdue_int_pnlt is '应还逾期利息罚息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.paid_tot_amt is '实还总金额';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.paid_pric is '实还本金';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.paid_int is '实还利息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.paid_ovdue_pric_pnlt is '实还逾期本金罚息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.paid_ovdue_int_pnlt is '实还逾期利息罚息';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.bf_repay_acru_non_acru_flg is '还款前应计非应计标志';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.modif_bf_status_cd is '变更前状态代码';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.wrt_off_flg is '核销标志';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_myloan_repay_inst_flow.etl_timestamp is 'ETL处理时间戳';
