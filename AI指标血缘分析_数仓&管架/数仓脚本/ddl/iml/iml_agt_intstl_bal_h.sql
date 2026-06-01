/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intstl_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intstl_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intstl_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_bal_h(
    bal_id varchar2(100) -- 余额编号
    ,lp_id varchar2(60) -- 法人编号
    ,agt_id varchar2(250) -- 协议编号
    ,src_agt_id varchar2(100) -- 源协议编号
    ,agt_type_cd varchar2(30) -- 协议类型代码
    ,bus_table_name varchar2(150) -- 业务表名称
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,ext_amt_type varchar2(45) -- 外部金额类型
    ,amt_vp_start_dt date -- 金额有效期开始日期
    ,amt_vp_end_dt date -- 金额有效期结束日期
    ,curr_cd varchar2(30) -- 币种代码
    ,amt number(30,8) -- 金额
    ,cors_amt_src_id varchar2(100) -- 对应金额源编号
    ,froz_id varchar2(100) -- 冻结编号
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
grant select on ${iml_schema}.agt_intstl_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_intstl_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_intstl_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intstl_bal_h is '国结协议余额历史';
comment on column ${iml_schema}.agt_intstl_bal_h.bal_id is '余额编号';
comment on column ${iml_schema}.agt_intstl_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intstl_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intstl_bal_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_intstl_bal_h.agt_type_cd is '协议类型代码';
comment on column ${iml_schema}.agt_intstl_bal_h.bus_table_name is '业务表名称';
comment on column ${iml_schema}.agt_intstl_bal_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_intstl_bal_h.ext_amt_type is '外部金额类型';
comment on column ${iml_schema}.agt_intstl_bal_h.amt_vp_start_dt is '金额有效期开始日期';
comment on column ${iml_schema}.agt_intstl_bal_h.amt_vp_end_dt is '金额有效期结束日期';
comment on column ${iml_schema}.agt_intstl_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_intstl_bal_h.amt is '金额';
comment on column ${iml_schema}.agt_intstl_bal_h.cors_amt_src_id is '对应金额源编号';
comment on column ${iml_schema}.agt_intstl_bal_h.froz_id is '冻结编号';
comment on column ${iml_schema}.agt_intstl_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_intstl_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_intstl_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intstl_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intstl_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intstl_bal_h.etl_timestamp is 'ETL处理时间戳';
