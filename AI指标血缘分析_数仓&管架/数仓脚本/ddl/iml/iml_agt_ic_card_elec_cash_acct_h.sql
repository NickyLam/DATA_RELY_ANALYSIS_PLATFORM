/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ic_card_elec_cash_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ic_card_elec_cash_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ic_card_elec_cash_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ic_card_elec_cash_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,card_no varchar2(60) -- 卡号
    ,card_ser_num varchar2(60) -- 卡序列号
    ,app_idf varchar2(60) -- 应用标识符
    ,elec_cash_acct_status_cd varchar2(30) -- 电子现金账户状态代码
    ,elec_cash_acct_curr_cd varchar2(30) -- 电子现金账户币种代码
    ,elec_cash_acct_bal number(30,2) -- 电子现金账户余额
    ,elec_cash_bal_uplmi number(30,2) -- 电子现金余额上限
    ,elec_cash_sig_tran_lmt number(30,2) -- 电子现金单笔交易限额
    ,acm_load_amt number(30,2) -- 累计圈存金额
    ,app_effect_dt date -- 应用生效日期
    ,app_invalid_dt date -- 应用失效日期
    ,elec_cash_acct_open_acct_dt date -- 电子现金账户开户日期
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,acct_name varchar2(500) -- 账户名称
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_flow_num varchar2(100) -- 销户流水号
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
grant select on ${iml_schema}.agt_ic_card_elec_cash_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_ic_card_elec_cash_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_ic_card_elec_cash_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ic_card_elec_cash_acct_h is 'IC卡电子现金账户历史';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.card_no is '卡号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.card_ser_num is '卡序列号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.app_idf is '应用标识符';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_acct_status_cd is '电子现金账户状态代码';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_acct_curr_cd is '电子现金账户币种代码';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_acct_bal is '电子现金账户余额';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_bal_uplmi is '电子现金余额上限';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_sig_tran_lmt is '电子现金单笔交易限额';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.acm_load_amt is '累计圈存金额';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.app_effect_dt is '应用生效日期';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.app_invalid_dt is '应用失效日期';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.elec_cash_acct_open_acct_dt is '电子现金账户开户日期';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.clos_acct_flow_num is '销户流水号';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ic_card_elec_cash_acct_h.etl_timestamp is 'ETL处理时间戳';
