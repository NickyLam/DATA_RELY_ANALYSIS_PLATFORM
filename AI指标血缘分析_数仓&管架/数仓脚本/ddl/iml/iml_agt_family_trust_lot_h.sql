/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_family_trust_lot_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_family_trust_lot_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_family_trust_lot_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_family_trust_lot_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,ta_cd varchar2(30) -- TA代码
    ,ta_tran_acct_id varchar2(100) -- TA交易账户编号
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,prod_id varchar2(100) -- 产品编号
    ,nv_id varchar2(100) -- 净值编号
    ,lot_type_cd varchar2(30) -- 份额类型代码
    ,lot number(30,2) -- 份额
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
grant select on ${iml_schema}.agt_family_trust_lot_h to ${icl_schema};
grant select on ${iml_schema}.agt_family_trust_lot_h to ${idl_schema};
grant select on ${iml_schema}.agt_family_trust_lot_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_family_trust_lot_h is '代销理财份额历史';
comment on column ${iml_schema}.agt_family_trust_lot_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_family_trust_lot_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.nv_id is '净值编号';
comment on column ${iml_schema}.agt_family_trust_lot_h.lot_type_cd is '份额类型代码';
comment on column ${iml_schema}.agt_family_trust_lot_h.lot is '份额';
comment on column ${iml_schema}.agt_family_trust_lot_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_family_trust_lot_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_family_trust_lot_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_family_trust_lot_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_family_trust_lot_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_family_trust_lot_h.etl_timestamp is 'ETL处理时间戳';
