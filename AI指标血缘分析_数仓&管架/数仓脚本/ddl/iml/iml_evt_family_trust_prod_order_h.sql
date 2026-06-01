/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_family_trust_prod_order_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_family_trust_prod_order_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_family_trust_prod_order_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_family_trust_prod_order_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,indent_flow_num varchar2(100) -- 订单流水号
    ,prod_id varchar2(100) -- 产品编号
    ,party_id varchar2(250) -- 当事人编号
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,tran_acct_num varchar2(60) -- 交易账号
    ,tran_tm timestamp -- 交易时间
    ,cntpty_name varchar2(750) -- 托管行名称
    ,cntpty_acct_id varchar2(100) -- 托管账户编号
    ,cntpty_ibank_no varchar2(100) -- 托管行联行号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
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
grant select on ${iml_schema}.evt_family_trust_prod_order_h to ${icl_schema};
grant select on ${iml_schema}.evt_family_trust_prod_order_h to ${idl_schema};
grant select on ${iml_schema}.evt_family_trust_prod_order_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_family_trust_prod_order_h is '家族信托产品订单历史';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.indent_flow_num is '订单流水号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.prod_id is '产品编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.party_id is '当事人编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.tran_acct_num is '交易账号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.cntpty_name is '托管行名称';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.cntpty_acct_id is '托管账户编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.cntpty_ibank_no is '托管行联行号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_family_trust_prod_order_h.etl_timestamp is 'ETL处理时间戳';
