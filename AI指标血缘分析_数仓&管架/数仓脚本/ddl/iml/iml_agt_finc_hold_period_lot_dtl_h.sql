/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_hold_period_lot_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_hold_period_lot_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_hold_period_lot_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_hold_period_lot_dtl_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_acct_id varchar2(60) -- TA账户编号
    ,prod_id varchar2(30) -- 产品编号
    ,cfm_dt date -- 确认日期
    ,cfm_flow_num varchar2(60) -- 确认流水号
    ,lot_rgst_dt date -- 份额注册日期
    ,forward_dt date -- 下发日期
    ,intnal_cust_id varchar2(30) -- 内部客户编号
    ,ta_cd varchar2(30) -- TA代码
    ,finc_acct_id varchar2(30) -- 理财账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,bank_acct_id varchar2(60) -- 银行账户编号
    ,froz_lot number(30,8) -- 冻结份额
    ,last_redembl_dt date -- 上一次可赎回日期
    ,ta_tot_lot number(30,8) -- TA端总份额
    ,ta_aval_lot number(30,8) -- TA端可用份额
    ,ta_froz_lot number(30,8) -- TA端冻结份额
    ,lot_dtl_flg varchar2(10) -- 份额明细标志
    ,redembl_dt date -- 可赎回日期
    ,acct_status_cd varchar2(10) -- 账户状态代码
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
grant select on ${iml_schema}.agt_finc_hold_period_lot_dtl_h to ${icl_schema};
grant select on ${iml_schema}.agt_finc_hold_period_lot_dtl_h to ${idl_schema};
grant select on ${iml_schema}.agt_finc_hold_period_lot_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_hold_period_lot_dtl_h is '理财持有期份额明细历史';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.ta_acct_id is 'TA账户编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.cfm_flow_num is '确认流水号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.lot_rgst_dt is '份额注册日期';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.forward_dt is '下发日期';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.froz_lot is '冻结份额';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.last_redembl_dt is '上一次可赎回日期';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.ta_tot_lot is 'TA端总份额';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.ta_aval_lot is 'TA端可用份额';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.ta_froz_lot is 'TA端冻结份额';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.lot_dtl_flg is '份额明细标志';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.redembl_dt is '可赎回日期';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_hold_period_lot_dtl_h.etl_timestamp is 'ETL处理时间戳';
