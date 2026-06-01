/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_bank_coll_comm_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_bank_coll_comm_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_bank_coll_comm_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_bank_coll_comm_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,comm_dt date -- 佣金日期
    ,logic_card_no varchar2(100) -- 逻辑卡号
    ,dubil_id varchar2(100) -- 借据编号
    ,ovdue_days number(10) -- 贷款逾期天数
    ,repay_dt date -- 还款日期
    ,repay_amt number(30,2) -- 还款金额
    ,syn_id varchar2(100) -- 银团编号
    ,bank_id varchar2(100) -- 银行编号
    ,bank_contri_ratio number(18,6) -- 银行出资比例
    ,outsourc_fee_rat number(18,6) -- 委外费率
    ,outsourc_fee number(30,2) -- 委外费用
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
grant select on ${iml_schema}.evt_wld_bank_coll_comm_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wld_bank_coll_comm_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wld_bank_coll_comm_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_bank_coll_comm_flow is '微粒贷银行催收佣金流水';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.ser_num is '序列号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.comm_dt is '佣金日期';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.logic_card_no is '逻辑卡号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.repay_amt is '还款金额';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.syn_id is '银团编号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.bank_id is '银行编号';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.outsourc_fee_rat is '委外费率';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.outsourc_fee is '委外费用';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_bank_coll_comm_flow.etl_timestamp is 'ETL处理时间戳';
