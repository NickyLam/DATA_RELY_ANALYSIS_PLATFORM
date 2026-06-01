/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_tran_cfm_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_tran_cfm_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_tran_cfm_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_tran_cfm_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,dtl_cfm_flow_num varchar2(60) -- 明细确认流水号
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,seller_id varchar2(60) -- 销售商编号
    ,bus_cd varchar2(30) -- 业务代码
    ,cfm_dt date -- 确认日期
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,prod_id varchar2(60) -- 产品编号
    ,appl_dt date -- 申请日期
    ,appl_flow_num varchar2(60) -- 申请流水号
    ,init_lot_cfm_dt date -- 原份额确认日期
    ,init_lot_cfm_flow_num varchar2(60) -- 原份额确认流水号
    ,cfm_amt number(30,2) -- 确认金额
    ,cfm_lot number(18,6) -- 确认份额
    ,invest_prft number(30,2) -- 投资收益
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
grant select on ${iml_schema}.evt_finc_tran_cfm_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_finc_tran_cfm_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_finc_tran_cfm_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_tran_cfm_dtl is '理财交易确认明细';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.dtl_cfm_flow_num is '明细确认流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.seller_id is '销售商编号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.init_lot_cfm_dt is '原份额确认日期';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.init_lot_cfm_flow_num is '原份额确认流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.invest_prft is '投资收益';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_tran_cfm_dtl.etl_timestamp is 'ETL处理时间戳';
