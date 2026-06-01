/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_file_int_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_file_int_rat_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_file_int_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_file_int_rat_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,evt_cate_id varchar2(100) -- 事件类别代码
    ,seq_num varchar2(60) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,ped_freq_cd varchar2(30) -- 周期频率代码
    ,tran_dt date -- 交易日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,file_amt number(30,2) -- 靠档金额
    ,file_days number(10) -- 靠档天数
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
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
grant select on ${iml_schema}.agt_dep_acct_file_int_rat_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_file_int_rat_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_file_int_rat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_file_int_rat_h is '存款账户靠档利率历史';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.evt_cate_id is '事件类别代码';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.seq_num is '序号';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.ped_freq_cd is '周期频率代码';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.file_amt is '靠档金额';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.file_days is '靠档天数';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_file_int_rat_h.etl_timestamp is 'ETL处理时间戳';
