/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_acct_unpaid_prft_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_acct_unpaid_prft_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_acct_unpaid_prft_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_acct_unpaid_prft_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,ta_tran_acct_id varchar2(100) -- TA交易账户编号
    ,prod_id varchar2(100) -- 产品编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,seller_id varchar2(100) -- 销售商编号
    ,cfm_dt date -- 确认日期
    ,unpaid_prft number(30,8) -- 未付收益
    ,froz_unpaid_prft number(30,2) -- 冻结未付收益
    ,td_add_unpaid_prft number(30,2) -- 当天新增未付收益
    ,lot_bal number(30,2) -- 份额余额
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
grant select on ${iml_schema}.agt_finc_acct_unpaid_prft_h to ${icl_schema};
grant select on ${iml_schema}.agt_finc_acct_unpaid_prft_h to ${idl_schema};
grant select on ${iml_schema}.agt_finc_acct_unpaid_prft_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_acct_unpaid_prft_h is '理财账户未付收益历史';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.seller_id is '销售商编号';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.froz_unpaid_prft is '冻结未付收益';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.td_add_unpaid_prft is '当天新增未付收益';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.lot_bal is '份额余额';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_acct_unpaid_prft_h.etl_timestamp is 'ETL处理时间戳';
