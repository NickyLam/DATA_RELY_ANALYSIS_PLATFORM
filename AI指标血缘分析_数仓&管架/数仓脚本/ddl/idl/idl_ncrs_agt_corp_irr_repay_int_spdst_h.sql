/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ncrs_agt_corp_irr_repay_int_spdst_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h
whenever sqlerror continue none;
drop table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h(
    etl_dt date -- 数据日期
    ,agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,exec_dt date -- 执行日期
    ,curr_cd varchar2(30) -- 币种代码
    ,value_dt date -- 起息日期
    ,acru_nomal_pric number(30,2) -- 应计正常本金
    ,curr_issue_recvbl_pric number(30,2) -- 本期应收本金
    ,curr_issue_int_recvbl number(30,2) -- 本期应收利息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h is '公司不规则还款利息试算历史';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.etl_dt is '数据日期';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.agt_id is '协议编号';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.lp_id is '法人编号';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.dubil_id is '借据编号';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.exec_dt is '执行日期';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.curr_cd is '币种代码';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.value_dt is '起息日期';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.acru_nomal_pric is '应计正常本金';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.curr_issue_recvbl_pric is '本期应收本金';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.curr_issue_int_recvbl is '本期应收利息';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.start_dt is '开始时间';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.end_dt is '结束时间';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.id_mark is '增删标志';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.src_table_name is '源表名称';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.job_cd is '任务编码';
comment on column ${idl_schema}.ncrs_agt_corp_irr_repay_int_spdst_h.etl_timestamp is 'ETL处理时间戳';