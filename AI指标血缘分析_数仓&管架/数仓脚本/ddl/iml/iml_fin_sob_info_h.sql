/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_sob_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_sob_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.fin_sob_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_sob_info_h(
    sob_id varchar2(100) -- 账套编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_name varchar2(500) -- 账套名称
    ,org_name varchar2(500) -- 机构名称
    ,curr_cd varchar2(30) -- 币种代码
    ,start_use_duran varchar2(20) -- 启用期间
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,curr_acctnt_duran varchar2(20) -- 当前会计期间
    ,aldy_stl_perds number(10) -- 已结账期数
    ,gl_dt date -- 总账日期
    ,realtm_calc_bal_flg varchar2(10) -- 实时计算余额标志
    ,balc_check_flg varchar2(10) -- 平衡检查标志
    ,need_entry_flg varchar2(10) -- 需记账标志
    ,sob_status_cd varchar2(30) -- 账套状态代码
    ,bus_dt date -- 业务日期
    ,acct_dt date -- 账务日期
    ,open_invoice_curr_cd varchar2(30) -- 开票币种代码
    ,sob_type_cd varchar2(30) -- 账套类型代码
    ,entry_cd varchar2(30) -- 记账机制代码
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
grant select on ${iml_schema}.fin_sob_info_h to ${icl_schema};
grant select on ${iml_schema}.fin_sob_info_h to ${idl_schema};
grant select on ${iml_schema}.fin_sob_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_sob_info_h is '账套信息历史';
comment on column ${iml_schema}.fin_sob_info_h.sob_id is '账套编号';
comment on column ${iml_schema}.fin_sob_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.fin_sob_info_h.sob_name is '账套名称';
comment on column ${iml_schema}.fin_sob_info_h.org_name is '机构名称';
comment on column ${iml_schema}.fin_sob_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.fin_sob_info_h.start_use_duran is '启用期间';
comment on column ${iml_schema}.fin_sob_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.fin_sob_info_h.curr_acctnt_duran is '当前会计期间';
comment on column ${iml_schema}.fin_sob_info_h.aldy_stl_perds is '已结账期数';
comment on column ${iml_schema}.fin_sob_info_h.gl_dt is '总账日期';
comment on column ${iml_schema}.fin_sob_info_h.realtm_calc_bal_flg is '实时计算余额标志';
comment on column ${iml_schema}.fin_sob_info_h.balc_check_flg is '平衡检查标志';
comment on column ${iml_schema}.fin_sob_info_h.need_entry_flg is '需记账标志';
comment on column ${iml_schema}.fin_sob_info_h.sob_status_cd is '账套状态代码';
comment on column ${iml_schema}.fin_sob_info_h.bus_dt is '业务日期';
comment on column ${iml_schema}.fin_sob_info_h.acct_dt is '账务日期';
comment on column ${iml_schema}.fin_sob_info_h.open_invoice_curr_cd is '开票币种代码';
comment on column ${iml_schema}.fin_sob_info_h.sob_type_cd is '账套类型代码';
comment on column ${iml_schema}.fin_sob_info_h.entry_cd is '记账机制代码';
comment on column ${iml_schema}.fin_sob_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.fin_sob_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.fin_sob_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.fin_sob_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_sob_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.fin_sob_info_h.etl_timestamp is 'ETL处理时间戳';
