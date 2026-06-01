/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_myloan_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_myloan_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_myloan_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_myloan_repay_dtl(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,repay_dt date -- 还款日期
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,dubil_id varchar2(60) -- 借据编号
    ,repay_wdraw_odd_no varchar2(100) -- 还款提现单号
    ,rpbl_nomal_pric number(30,2) -- 应还正常本金
    ,rpbl_ovdue_pric number(30,2) -- 应还逾期本金
    ,rpbl_nomal_int number(30,2) -- 应还正常利息
    ,rpbl_ovdue_int number(30,2) -- 应还逾期利息
    ,rpbl_ovdue_pric_pnlt number(30,2) -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt number(30,2) -- 应还逾期利息罚息
    ,rpbl_tot_amt number(30,2) -- 应还总金额
    ,paid_nomal_pric number(30,2) -- 实还正常本金
    ,paid_ovdue_pric number(30,2) -- 实还逾期本金
    ,paid_nomal_int number(30,2) -- 实还正常利息
    ,paid_ovdue_int number(30,2) -- 实还逾期利息
    ,paid_ovdue_pric_pnlt number(30,2) -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt number(30,2) -- 实还逾期利息罚息
    ,repay_type_cd varchar2(10) -- 还款类型代码
    ,bf_repay_acru_flg varchar2(100) -- 还款前应计标志
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
grant select on ${iml_schema}.evt_myloan_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_myloan_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_myloan_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_myloan_repay_dtl is '网商贷还款明细';
comment on column ${iml_schema}.evt_myloan_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_myloan_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_myloan_repay_dtl.repay_dt is '还款日期';
comment on column ${iml_schema}.evt_myloan_repay_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_myloan_repay_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_myloan_repay_dtl.repay_wdraw_odd_no is '还款提现单号';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_nomal_pric is '应还正常本金';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_ovdue_pric is '应还逾期本金';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_nomal_int is '应还正常利息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_ovdue_int is '应还逾期利息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_ovdue_pric_pnlt is '应还逾期本金罚息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_ovdue_int_pnlt is '应还逾期利息罚息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.rpbl_tot_amt is '应还总金额';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_nomal_pric is '实还正常本金';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_ovdue_pric is '实还逾期本金';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_nomal_int is '实还正常利息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_ovdue_int is '实还逾期利息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_ovdue_pric_pnlt is '实还逾期本金罚息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.paid_ovdue_int_pnlt is '实还逾期利息罚息';
comment on column ${iml_schema}.evt_myloan_repay_dtl.repay_type_cd is '还款类型代码';
comment on column ${iml_schema}.evt_myloan_repay_dtl.bf_repay_acru_flg is '还款前应计标志';
comment on column ${iml_schema}.evt_myloan_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_myloan_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_myloan_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_myloan_repay_dtl.etl_timestamp is 'ETL处理时间戳';
