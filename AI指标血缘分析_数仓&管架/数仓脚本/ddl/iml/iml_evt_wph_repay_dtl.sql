/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wph_repay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wph_repay_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wph_repay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_repay_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,repay_flow_num varchar2(100) -- 还款流水号
    ,repay_perds number(10) -- 还款期数
    ,tran_dt date -- 交易日期
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,paid_tot number(30,2) -- 实还总额
    ,paid_pric number(30,2) -- 实还本金
    ,paid_int number(30,2) -- 实还利息
    ,paid_pnlt number(30,2) -- 实还罚息
    ,paid_comp_int number(30,2) -- 实还复利
    ,paid_other_fee number(30,2) -- 实还其他费用
    ,repaybl_dt date -- 应还款日期
    ,actl_repay_dt date -- 实际还款日期
    ,ovdue_days number(10) -- 贷款逾期天数
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
grant select on ${iml_schema}.evt_wph_repay_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_wph_repay_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_wph_repay_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wph_repay_dtl is '唯品会还款明细';
comment on column ${iml_schema}.evt_wph_repay_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wph_repay_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wph_repay_dtl.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_wph_repay_dtl.repay_flow_num is '还款流水号';
comment on column ${iml_schema}.evt_wph_repay_dtl.repay_perds is '还款期数';
comment on column ${iml_schema}.evt_wph_repay_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_wph_repay_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_wph_repay_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_tot is '实还总额';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_pric is '实还本金';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_int is '实还利息';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_comp_int is '实还复利';
comment on column ${iml_schema}.evt_wph_repay_dtl.paid_other_fee is '实还其他费用';
comment on column ${iml_schema}.evt_wph_repay_dtl.repaybl_dt is '应还款日期';
comment on column ${iml_schema}.evt_wph_repay_dtl.actl_repay_dt is '实际还款日期';
comment on column ${iml_schema}.evt_wph_repay_dtl.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.evt_wph_repay_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wph_repay_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wph_repay_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wph_repay_dtl.etl_timestamp is 'ETL处理时间戳';
