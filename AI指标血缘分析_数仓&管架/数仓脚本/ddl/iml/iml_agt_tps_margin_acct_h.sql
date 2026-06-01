/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_tps_margin_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_tps_margin_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_tps_margin_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tps_margin_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,open_dt date -- 开户日期
    ,broker_cd varchar2(30) -- 券商代码
    ,secu_cap_acct_id varchar2(100) -- 证券资金账户编号
    ,asset_bal number(30,2) -- 资产余额
    ,margin_status varchar2(45) -- 保证金状态
    ,rgst_dt date -- 登记日期
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,cust_name varchar2(300) -- 客户名称
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
grant select on ${iml_schema}.agt_tps_margin_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_tps_margin_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_tps_margin_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_tps_margin_acct_h is '第三方存管保证金账户历史';
comment on column ${iml_schema}.agt_tps_margin_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_tps_margin_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_tps_margin_acct_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_tps_margin_acct_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_tps_margin_acct_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_tps_margin_acct_h.open_dt is '开户日期';
comment on column ${iml_schema}.agt_tps_margin_acct_h.broker_cd is '券商代码';
comment on column ${iml_schema}.agt_tps_margin_acct_h.secu_cap_acct_id is '证券资金账户编号';
comment on column ${iml_schema}.agt_tps_margin_acct_h.asset_bal is '资产余额';
comment on column ${iml_schema}.agt_tps_margin_acct_h.margin_status is '保证金状态';
comment on column ${iml_schema}.agt_tps_margin_acct_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_tps_margin_acct_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_tps_margin_acct_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_tps_margin_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_tps_margin_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_tps_margin_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_tps_margin_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_tps_margin_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_tps_margin_acct_h.etl_timestamp is 'ETL处理时间戳';
