/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1b_dci_i_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1b_dci_i_trans
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1b_dci_i_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1b_dci_i_trans(
    cust_id varchar2(32) -- 客户号
    ,trans_count number(20) -- 交易笔数（笔）
    ,trans_sum_amt number(30,6) -- 交易金额（元）
    ,count_c number(20) -- 转入笔数（笔）
    ,sum_c_amt number(30,6) -- 转入金额（元）
    ,count_d number(20) -- 转出笔数（笔）
    ,sum_d_amt number(30,6) -- 转出金额（元）
    ,c_opp_name_1 varchar2(200) -- 转入交易对手1
    ,c_opp_name_amt_1 number(30,6) -- 转入对手1涉及金额
    ,c_opp_name_2 varchar2(200) -- 转入交易对手2
    ,c_opp_name_amt_2 number(30,6) -- 转入对手2涉及金额
    ,c_opp_name_3 varchar2(200) -- 转入交易对手3
    ,c_opp_name_amt_3 number(30,6) -- 转入交易对手3涉及金额
    ,c_opp_name_4 varchar2(200) -- 转入交易对手4
    ,c_opp_name_amt_4 number(30,6) -- 转入对手4涉及金额
    ,c_opp_name_5 varchar2(200) -- 转入交易对手5
    ,c_opp_name_amt_5 number(30,6) -- 转入对手5涉及金额
    ,d_opp_name_1 varchar2(200) -- 转出交易对手1
    ,d_opp_name_amt_1 number(30,6) -- 转出对手1涉及金额
    ,d_opp_name_2 varchar2(200) -- 转出交易对手2
    ,d_opp_name_amt_2 number(30,6) -- 转出对手2涉及金额
    ,d_opp_name_3 varchar2(200) -- 转出交易对手3
    ,d_opp_name_amt_3 number(30,6) -- 转出交易对手3涉及金额
    ,d_opp_name_4 varchar2(200) -- 转出交易对手4
    ,d_opp_name_amt_4 number(30,6) -- 转出对手4涉及金额
    ,d_opp_name_5 varchar2(200) -- 转出交易对手5
    ,d_opp_name_amt_5 number(30,6) -- 转出对手5涉及金额
    ,begin_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amls_t1b_dci_i_trans to ${iml_schema};
grant select on ${iol_schema}.amls_t1b_dci_i_trans to ${icl_schema};
grant select on ${iol_schema}.amls_t1b_dci_i_trans to ${idl_schema};
grant select on ${iol_schema}.amls_t1b_dci_i_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1b_dci_i_trans is '对私客户的交易流水分析';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.cust_id is '客户号';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.trans_count is '交易笔数（笔）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.trans_sum_amt is '交易金额（元）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.count_c is '转入笔数（笔）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.sum_c_amt is '转入金额（元）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.count_d is '转出笔数（笔）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.sum_d_amt is '转出金额（元）';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_1 is '转入交易对手1';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_amt_1 is '转入对手1涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_2 is '转入交易对手2';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_amt_2 is '转入对手2涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_3 is '转入交易对手3';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_amt_3 is '转入交易对手3涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_4 is '转入交易对手4';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_amt_4 is '转入对手4涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_5 is '转入交易对手5';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.c_opp_name_amt_5 is '转入对手5涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_1 is '转出交易对手1';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_amt_1 is '转出对手1涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_2 is '转出交易对手2';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_amt_2 is '转出对手2涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_3 is '转出交易对手3';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_amt_3 is '转出交易对手3涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_4 is '转出交易对手4';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_amt_4 is '转出对手4涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_5 is '转出交易对手5';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.d_opp_name_amt_5 is '转出对手5涉及金额';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.begin_dt is '开始日期';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.end_dt is '结束日期';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t1b_dci_i_trans.etl_timestamp is 'ETL处理时间戳';
