/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lon_post_modif_cntpty_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lon_post_modif_cntpty_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_modif_cntpty_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,obj_id varchar2(100) -- 对象编号
    ,on_acct_id varchar2(100) -- 挂账编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_bank_no varchar2(60) -- 交易对手行号
    ,cntpty_bank_name varchar2(500) -- 交易对手行名称
    ,tran_amt number(30,2) -- 交易金额
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
grant select on ${iml_schema}.agt_lon_post_modif_cntpty_appl to ${icl_schema};
grant select on ${iml_schema}.agt_lon_post_modif_cntpty_appl to ${idl_schema};
grant select on ${iml_schema}.agt_lon_post_modif_cntpty_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lon_post_modif_cntpty_appl is '贷后变更交易对手申请';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.obj_id is '对象编号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.on_acct_id is '挂账编号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.cntpty_bank_no is '交易对手行号';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.cntpty_bank_name is '交易对手行名称';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lon_post_modif_cntpty_appl.etl_timestamp is 'ETL处理时间戳';
