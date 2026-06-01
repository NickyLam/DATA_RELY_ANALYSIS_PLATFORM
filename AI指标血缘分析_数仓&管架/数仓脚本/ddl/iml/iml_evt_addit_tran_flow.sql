/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_addit_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_addit_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_addit_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_addit_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,addit_prod_id varchar2(100) -- 附加险产品编号
    ,bank_id varchar2(100) -- 银行编号
    ,ta_cd varchar2(30) -- TA代码
    ,main_prod_id varchar2(100) -- 主险产品编号
    ,insure_shares varchar2(45) -- 投保份数
    ,insure_amt number(30,8) -- 投保金额
    ,insu_benef_lmt number(30,8) -- 保险金额
    ,insure_mode_pay_cd varchar2(30) -- 保险支付方式代码
    ,pay_years varchar2(45) -- 缴费年限
    ,guar_tenor_type_cd varchar2(30) -- 保障期限类型代码
    ,guar_year_term varchar2(45) -- 保障年期
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
grant select on ${iml_schema}.evt_addit_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_addit_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_addit_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_addit_tran_flow is '附加险交易流水';
comment on column ${iml_schema}.evt_addit_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_addit_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_addit_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_addit_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_addit_tran_flow.addit_prod_id is '附加险产品编号';
comment on column ${iml_schema}.evt_addit_tran_flow.bank_id is '银行编号';
comment on column ${iml_schema}.evt_addit_tran_flow.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_addit_tran_flow.main_prod_id is '主险产品编号';
comment on column ${iml_schema}.evt_addit_tran_flow.insure_shares is '投保份数';
comment on column ${iml_schema}.evt_addit_tran_flow.insure_amt is '投保金额';
comment on column ${iml_schema}.evt_addit_tran_flow.insu_benef_lmt is '保险金额';
comment on column ${iml_schema}.evt_addit_tran_flow.insure_mode_pay_cd is '保险支付方式代码';
comment on column ${iml_schema}.evt_addit_tran_flow.pay_years is '缴费年限';
comment on column ${iml_schema}.evt_addit_tran_flow.guar_tenor_type_cd is '保障期限类型代码';
comment on column ${iml_schema}.evt_addit_tran_flow.guar_year_term is '保障年期';
comment on column ${iml_schema}.evt_addit_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_addit_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_addit_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_addit_tran_flow.etl_timestamp is 'ETL处理时间戳';
