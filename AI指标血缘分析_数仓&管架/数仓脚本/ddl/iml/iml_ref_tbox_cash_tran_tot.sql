/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tbox_cash_tran_tot
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tbox_cash_tran_tot
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tbox_cash_tran_tot purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tbox_cash_tran_tot(
    tran_flow_num varchar2(100) -- 转移流水号
    ,lp_id varchar2(100) -- 法人编号
    ,curr_cd varchar2(30) -- 币种代码
    ,mutil_curr_flg varchar2(10) -- 残损币标志
    ,tot_amt number(30,2) -- 汇总金额
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
grant select on ${iml_schema}.ref_tbox_cash_tran_tot to ${icl_schema};
grant select on ${iml_schema}.ref_tbox_cash_tran_tot to ${idl_schema};
grant select on ${iml_schema}.ref_tbox_cash_tran_tot to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tbox_cash_tran_tot is '尾箱现金转移汇总';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.tran_flow_num is '转移流水号';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.lp_id is '法人编号';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.mutil_curr_flg is '残损币标志';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.tot_amt is '汇总金额';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tbox_cash_tran_tot.etl_timestamp is 'ETL处理时间戳';
