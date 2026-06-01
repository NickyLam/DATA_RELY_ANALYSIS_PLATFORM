/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_acp_pd_repay_dtl_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_acp_pd_repay_dtl_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_acp_pd_repay_dtl_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acp_pd_repay_dtl_flow(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,pd_num varchar2(60) -- 期次号
    ,inst_status_cd varchar2(20) -- 分期状态代码
    ,repay_type_cd varchar2(10) -- 还款类型代码
    ,repay_tm timestamp -- 还款时间
    ,paid_tot_amt number(30,6) -- 实还总金额
    ,paid_nomal_pric number(30,6) -- 实还正常本金
    ,paid_int number(30,6) -- 实还利息
    ,paid_ovdue_pric_pnlt number(30,6) -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt number(30,6) -- 实还逾期利息罚息
    ,intnal_carr_flg varchar2(10) -- 内部结转标志
    ,dubil_type_cd varchar2(10) -- 借据类型代码
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
grant select on ${iml_schema}.evt_acp_pd_repay_dtl_flow to ${icl_schema};
grant select on ${iml_schema}.evt_acp_pd_repay_dtl_flow to ${idl_schema};
grant select on ${iml_schema}.evt_acp_pd_repay_dtl_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_acp_pd_repay_dtl_flow is '花呗期次还款明细流水';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.pd_num is '期次号';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.inst_status_cd is '分期状态代码';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.repay_tm is '还款时间';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.paid_tot_amt is '实还总金额';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.paid_nomal_pric is '实还正常本金';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.paid_int is '实还利息';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.paid_ovdue_pric_pnlt is '实还逾期本金罚息';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.paid_ovdue_int_pnlt is '实还逾期利息罚息';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.intnal_carr_flg is '内部结转标志';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.dubil_type_cd is '借据类型代码';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_acp_pd_repay_dtl_flow.etl_timestamp is 'ETL处理时间戳';
