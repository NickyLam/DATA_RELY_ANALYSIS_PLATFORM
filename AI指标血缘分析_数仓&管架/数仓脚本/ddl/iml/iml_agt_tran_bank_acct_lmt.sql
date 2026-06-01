/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_tran_bank_acct_lmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_tran_bank_acct_lmt
whenever sqlerror continue none;
drop table ${iml_schema}.agt_tran_bank_acct_lmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tran_bank_acct_lmt(
    agt_id varchar2(250) -- 协议编号
    ,attr_name varchar2(100) -- 属性名称
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,user_seq_num varchar2(60) -- 用户顺序号
    ,attr_val varchar2(2000) -- 属性值
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_tran_bank_acct_lmt to ${icl_schema};
grant select on ${iml_schema}.agt_tran_bank_acct_lmt to ${idl_schema};
grant select on ${iml_schema}.agt_tran_bank_acct_lmt to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_tran_bank_acct_lmt is '交易银行账户限额';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.agt_id is '协议编号';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.attr_name is '属性名称';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.lp_id is '法人编号';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.acct_id is '账户编号';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.cust_id is '客户编号';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.user_seq_num is '用户顺序号';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.attr_val is '属性值';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.start_dt is '开始时间';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.end_dt is '结束时间';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.id_mark is '增删标志';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.job_cd is '任务编码';
comment on column ${iml_schema}.agt_tran_bank_acct_lmt.etl_timestamp is 'ETL处理时间戳';
