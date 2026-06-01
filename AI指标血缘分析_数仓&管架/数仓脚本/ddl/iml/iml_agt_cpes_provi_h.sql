/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cpes_provi_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cpes_provi_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cpes_provi_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cpes_provi_h(
    provi_mtbl_id varchar2(60) -- 计提主表编号
    ,lp_id varchar2(60) -- 法人编号
    ,hq_org_id varchar2(60) -- 总行机构编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,batch_id varchar2(60) -- 批次编号
    ,agt_id varchar2(60) -- 协议编号
    ,dtl_id varchar2(60) -- 明细编号
    ,bill_id varchar2(60) -- 票据编号
    ,bus_prod_id varchar2(60) -- 业务产品编号
    ,interest number(30,2) -- 利息
    ,provi_start_dt date -- 计提开始日期
    ,provi_end_dt date -- 计提结束日期
    ,actl_end_provi_dt date -- 实际结束计提日期
    ,provi_dt date -- 计提日期
    ,int_accr_exp_dt date -- 计息到期日期
    ,int_accr_days number(10) -- 计息天数
    ,provied_int number(30,2) -- 已计提利息
    ,surp_int number(30,2) -- 剩余利息
    ,daily_provi_amt number(30,2) -- 每日计提金额
    ,provi_bus_type_cd varchar2(60) -- 计提业务类型代码
    ,provi_status_cd varchar2(10) -- 计提状态代码
    ,provi_excep_cd varchar2(10) -- 计提异常代码
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号

    ,bill_num varchar2(60) -- 票据号码
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
grant select on ${iml_schema}.agt_cpes_provi_h to ${icl_schema};
grant select on ${iml_schema}.agt_cpes_provi_h to ${idl_schema};
grant select on ${iml_schema}.agt_cpes_provi_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cpes_provi_h is '票交所计提历史';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_mtbl_id is '计提主表编号';
comment on column ${iml_schema}.agt_cpes_provi_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cpes_provi_h.hq_org_id is '总行机构编号';
comment on column ${iml_schema}.agt_cpes_provi_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_cpes_provi_h.batch_id is '批次编号';
comment on column ${iml_schema}.agt_cpes_provi_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cpes_provi_h.dtl_id is '明细编号';
comment on column ${iml_schema}.agt_cpes_provi_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_cpes_provi_h.bus_prod_id is '业务产品编号';
comment on column ${iml_schema}.agt_cpes_provi_h.interest is '利息';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_start_dt is '计提开始日期';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_end_dt is '计提结束日期';
comment on column ${iml_schema}.agt_cpes_provi_h.actl_end_provi_dt is '实际结束计提日期';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_dt is '计提日期';
comment on column ${iml_schema}.agt_cpes_provi_h.int_accr_exp_dt is '计息到期日期';
comment on column ${iml_schema}.agt_cpes_provi_h.int_accr_days is '计息天数';
comment on column ${iml_schema}.agt_cpes_provi_h.provied_int is '已计提利息';
comment on column ${iml_schema}.agt_cpes_provi_h.surp_int is '剩余利息';
comment on column ${iml_schema}.agt_cpes_provi_h.daily_provi_amt is '每日计提金额';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_bus_type_cd is '计提业务类型代码';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_status_cd is '计提状态代码';
comment on column ${iml_schema}.agt_cpes_provi_h.provi_excep_cd is '计提异常代码';
comment on column ${iml_schema}.agt_cpes_provi_h.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_cpes_provi_h.bill_sub_intrv_id is '票据子区间号
';
comment on column ${iml_schema}.agt_cpes_provi_h.bill_num is '票据号码';
comment on column ${iml_schema}.agt_cpes_provi_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cpes_provi_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cpes_provi_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cpes_provi_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cpes_provi_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cpes_provi_h.etl_timestamp is 'ETL处理时间戳';
