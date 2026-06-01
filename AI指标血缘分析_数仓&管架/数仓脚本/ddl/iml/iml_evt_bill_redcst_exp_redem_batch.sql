/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_bill_redcst_exp_redem_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_bill_redcst_exp_redem_batch
whenever sqlerror continue none;
drop table ${iml_schema}.evt_bill_redcst_exp_redem_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_redcst_exp_redem_batch(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,exp_redem_batch_ser_num varchar2(100) -- 到期赎回批次序列号
    ,bill_redcst_ser_num varchar2(100) -- 票据再贴现序列号
    ,batch_id varchar2(100) -- 批次编号
    ,bus_dt date -- 业务日期
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,clear_bus_type_cd varchar2(30) -- 清算业务类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,ctr_nt_id varchar2(100) -- 成交单编号
    ,bus_org_id varchar2(100) -- 业务机构编号
    ,hq_org_id varchar2(100) -- 总行机构编号
    ,cap_acct_id varchar2(100) -- 资金账户编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,dealer_id varchar2(100) -- 交易员编号
    ,actl_stl_amt number(30,2) -- 实际结算金额
    ,stl_bill_cnt number(10) -- 结算票据张数
    ,stl_int_paybl number(30,2) -- 结算应付利息
    ,entry_status_cd varchar2(30) -- 记账状态代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,final_modif_operr_id varchar2(100) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
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
grant select on ${iml_schema}.evt_bill_redcst_exp_redem_batch to ${icl_schema};
grant select on ${iml_schema}.evt_bill_redcst_exp_redem_batch to ${idl_schema};
grant select on ${iml_schema}.evt_bill_redcst_exp_redem_batch to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_bill_redcst_exp_redem_batch is '票据再贴现到期赎回批次';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.evt_id is '事件编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.lp_id is '法人编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.exp_redem_batch_ser_num is '到期赎回批次序列号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.bill_redcst_ser_num is '票据再贴现序列号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.batch_id is '批次编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.bus_dt is '业务日期';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.clear_bus_type_cd is '清算业务类型代码';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.prod_id is '产品编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.bus_org_id is '业务机构编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.cap_acct_id is '资金账户编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.dealer_id is '交易员编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.actl_stl_amt is '实际结算金额';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.stl_bill_cnt is '结算票据张数';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.stl_int_paybl is '结算应付利息';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.start_dt is '开始时间';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.end_dt is '结束时间';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.id_mark is '增删标志';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.job_cd is '任务编码';
comment on column ${iml_schema}.evt_bill_redcst_exp_redem_batch.etl_timestamp is 'ETL处理时间戳';
