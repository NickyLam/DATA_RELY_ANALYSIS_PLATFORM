/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_myloan_provi_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_myloan_provi_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_myloan_provi_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_provi_dtl(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,int_accr_dt date -- 计息日期
    ,acru_non_acru_flg varchar2(10) -- 应计非应计标志
    ,ovdue_int_bal number(30,6) -- 逾期利息余额
    ,loan_pnlt_day_int_rat number(18,8) -- 贷款罚息日利率
    ,nomal_int number(30,6) -- 正常利息
    ,ovdue_pric_pnlt number(30,6) -- 逾期本金罚息
    ,ovdue_int_pnlt number(30,6) -- 逾期利息罚息
    ,nomal_pric_bal number(30,6) -- 正常本金余额
    ,ovdue_pric_bal number(30,6) -- 逾期本金余额
    ,loan_actl_day_int_rat number(18,8) -- 贷款实际日利率
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_myloan_provi_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_myloan_provi_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_myloan_provi_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_myloan_provi_dtl is '网商贷计提明细';
comment on column ${iml_schema}.agt_myloan_provi_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_myloan_provi_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_myloan_provi_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_myloan_provi_dtl.int_accr_dt is '计息日期';
comment on column ${iml_schema}.agt_myloan_provi_dtl.acru_non_acru_flg is '应计非应计标志';
comment on column ${iml_schema}.agt_myloan_provi_dtl.ovdue_int_bal is '逾期利息余额';
comment on column ${iml_schema}.agt_myloan_provi_dtl.loan_pnlt_day_int_rat is '贷款罚息日利率';
comment on column ${iml_schema}.agt_myloan_provi_dtl.nomal_int is '正常利息';
comment on column ${iml_schema}.agt_myloan_provi_dtl.ovdue_pric_pnlt is '逾期本金罚息';
comment on column ${iml_schema}.agt_myloan_provi_dtl.ovdue_int_pnlt is '逾期利息罚息';
comment on column ${iml_schema}.agt_myloan_provi_dtl.nomal_pric_bal is '正常本金余额';
comment on column ${iml_schema}.agt_myloan_provi_dtl.ovdue_pric_bal is '逾期本金余额';
comment on column ${iml_schema}.agt_myloan_provi_dtl.loan_actl_day_int_rat is '贷款实际日利率';
comment on column ${iml_schema}.agt_myloan_provi_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_myloan_provi_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_myloan_provi_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_myloan_provi_dtl.etl_timestamp is 'ETL处理时间戳';
