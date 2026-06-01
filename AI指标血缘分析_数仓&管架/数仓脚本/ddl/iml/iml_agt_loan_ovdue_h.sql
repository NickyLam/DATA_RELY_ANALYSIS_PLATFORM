/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_ovdue_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_ovdue_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_ovdue_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_ovdue_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,pric_ovdue_days number(10) -- 本金逾期天数
    ,int_ovdue_days number(10) -- 利息逾期天数
    ,ovdue_pric number(30,2) -- 逾期本金
    ,ovdue_int number(30,8) -- 逾期利息
    ,ovdue_pric_pnlt number(30,8) -- 逾期本金罚息
    ,ovdue_int_pnlt number(30,8) -- 逾期利息罚息
    ,pric_turn_ovdue_dt date -- 本金转逾期日期
    ,int_turn_ovdue_dt date -- 利息转逾期日期
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
grant select on ${iml_schema}.agt_loan_ovdue_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_ovdue_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_ovdue_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_ovdue_h is '贷款逾期历史';
comment on column ${iml_schema}.agt_loan_ovdue_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_ovdue_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_ovdue_h.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_loan_ovdue_h.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_loan_ovdue_h.ovdue_pric is '逾期本金';
comment on column ${iml_schema}.agt_loan_ovdue_h.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_loan_ovdue_h.ovdue_pric_pnlt is '逾期本金罚息';
comment on column ${iml_schema}.agt_loan_ovdue_h.ovdue_int_pnlt is '逾期利息罚息';
comment on column ${iml_schema}.agt_loan_ovdue_h.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${iml_schema}.agt_loan_ovdue_h.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${iml_schema}.agt_loan_ovdue_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_ovdue_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_ovdue_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_ovdue_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_ovdue_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_ovdue_h.etl_timestamp is 'ETL处理时间戳';
