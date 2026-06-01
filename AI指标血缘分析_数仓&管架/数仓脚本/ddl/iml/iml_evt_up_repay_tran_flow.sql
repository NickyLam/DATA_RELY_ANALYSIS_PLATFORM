/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_up_repay_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_up_repay_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_up_repay_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_up_repay_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,tran_dt date -- 交易日期
    ,fund_corp_id varchar2(100) -- 基金公司编号
    ,fund_corp_name varchar2(500) -- 基金公司名称
    ,belong_brch_org_id varchar2(100) -- 所属分行机构编号
    ,belong_brch_org_name varchar2(500) -- 所属分行机构名称
    ,tot_amt number(30,2) -- 总额度
    ,td_sucs_amt number(30,2) -- 当天成功金额
    ,td_uno_amt number(30,2) -- 当天未明金额
    ,surp_lmt number(30,2) -- 剩余额度
    ,repayed_amt number(30,2) -- 已还款金额
    ,clarify_status_cd varchar2(30) -- 清分状态代码
    ,valid_flg varchar2(10) -- 有效标志
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
grant select on ${iml_schema}.evt_up_repay_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_up_repay_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_up_repay_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_up_repay_tran_flow is '银联代付还款交易流水';
comment on column ${iml_schema}.evt_up_repay_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_up_repay_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_up_repay_tran_flow.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_up_repay_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_up_repay_tran_flow.fund_corp_id is '基金公司编号';
comment on column ${iml_schema}.evt_up_repay_tran_flow.fund_corp_name is '基金公司名称';
comment on column ${iml_schema}.evt_up_repay_tran_flow.belong_brch_org_id is '所属分行机构编号';
comment on column ${iml_schema}.evt_up_repay_tran_flow.belong_brch_org_name is '所属分行机构名称';
comment on column ${iml_schema}.evt_up_repay_tran_flow.tot_amt is '总额度';
comment on column ${iml_schema}.evt_up_repay_tran_flow.td_sucs_amt is '当天成功金额';
comment on column ${iml_schema}.evt_up_repay_tran_flow.td_uno_amt is '当天未明金额';
comment on column ${iml_schema}.evt_up_repay_tran_flow.surp_lmt is '剩余额度';
comment on column ${iml_schema}.evt_up_repay_tran_flow.repayed_amt is '已还款金额';
comment on column ${iml_schema}.evt_up_repay_tran_flow.clarify_status_cd is '清分状态代码';
comment on column ${iml_schema}.evt_up_repay_tran_flow.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_up_repay_tran_flow.start_dt is '开始时间';
comment on column ${iml_schema}.evt_up_repay_tran_flow.end_dt is '结束时间';
comment on column ${iml_schema}.evt_up_repay_tran_flow.id_mark is '增删标志';
comment on column ${iml_schema}.evt_up_repay_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_up_repay_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_up_repay_tran_flow.etl_timestamp is 'ETL处理时间戳';
