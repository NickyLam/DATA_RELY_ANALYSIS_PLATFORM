/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_int_rat_para_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_int_rat_para_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_int_rat_para_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_int_rat_para_h(
    int_rat_id varchar2(100) -- 利率编号
    ,int_rat_name varchar2(500) -- 利率名称
    ,curr_cd varchar2(30) -- 币种代码
    ,effect_dt date -- 生效日期
    ,int_rat_ped_corp varchar2(250) -- 利率周期单位
    ,int_rat_ped_cd varchar2(30) -- 利率周期代码
    ,int_rat number(18,8) -- 利率
    ,status_cd varchar2(30) -- 状态代码
    ,int_rat_corp_cd varchar2(30) -- 利率单位代码
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,modif_dt date -- 变更日期
    ,lp_id varchar2(100) -- 法人编号
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
grant select on ${iml_schema}.agt_loan_int_rat_para_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_int_rat_para_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_int_rat_para_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_int_rat_para_h is '贷款利率参数历史';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat_id is '利率编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat_name is '利率名称';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat_ped_corp is '利率周期单位';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat_ped_cd is '利率周期代码';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat is '利率';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.int_rat_corp_cd is '利率单位代码';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_int_rat_para_h.etl_timestamp is 'ETL处理时间戳';
