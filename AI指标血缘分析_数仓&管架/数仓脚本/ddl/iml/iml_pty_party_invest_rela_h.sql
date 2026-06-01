/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_invest_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_invest_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_invest_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_invest_rela_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,rela_party_id varchar2(60) -- 关联当事人编号
    ,party_rela_type_cd varchar2(80) -- 关联关系类型代码
    ,legal_rep varchar2(100) -- 法人代表
    ,curr_cd varchar2(10) -- 币种代码
    ,actl_amt number(30,2) -- 对外投资金额
    ,invest_ratio number(18,6) -- 投资比例
    ,invest_situ_type_cd varchar2(30) -- 投资情况类型代码
    ,invest_dt date -- 投资日期
    ,resp_bid_cap_lmt number(30,6) -- 应投资金额
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
grant select on ${iml_schema}.pty_party_invest_rela_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_invest_rela_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_invest_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_invest_rela_h is '当事人投资关系历史';
comment on column ${iml_schema}.pty_party_invest_rela_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_invest_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_invest_rela_h.rela_party_id is '关联当事人编号';
comment on column ${iml_schema}.pty_party_invest_rela_h.party_rela_type_cd is '关联关系类型代码';
comment on column ${iml_schema}.pty_party_invest_rela_h.legal_rep is '法人代表';
comment on column ${iml_schema}.pty_party_invest_rela_h.curr_cd is '币种代码';
comment on column ${iml_schema}.pty_party_invest_rela_h.actl_amt is '对外投资金额';
comment on column ${iml_schema}.pty_party_invest_rela_h.invest_ratio is '投资比例';
comment on column ${iml_schema}.pty_party_invest_rela_h.invest_situ_type_cd is '投资情况类型代码';
comment on column ${iml_schema}.pty_party_invest_rela_h.invest_dt is '投资日期';
comment on column ${iml_schema}.pty_party_invest_rela_h.resp_bid_cap_lmt is '应投资金额';
comment on column ${iml_schema}.pty_party_invest_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_invest_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_invest_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_invest_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_invest_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_invest_rela_h.etl_timestamp is 'ETL处理时间戳';
