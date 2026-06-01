/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_overs_remit_decl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_overs_remit_decl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_overs_remit_decl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_overs_remit_decl_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,decl_id varchar2(100) -- 申报编号
    ,temp_decl_flow_id varchar2(100) -- 临时申报流水编号
    ,init_enty_id varchar2(100) -- 原始实体编号
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,modif_rs_comnt varchar2(750) -- 变更原因说明
    ,decl_num varchar2(100) -- 申报号码
    ,recver_permt_cty_rg_cd varchar2(30) -- 收款人常驻国家和地区代码
    ,pay_type_cd varchar2(30) -- 付款类型代码
    ,tran_id_1 varchar2(100) -- 交易编号1
    ,tran_amt_1 number(30,2) -- 交易金额1
    ,tran_postsc_1 varchar2(750) -- 交易附言1
    ,tran_id_2 varchar2(100) -- 交易编号2
    ,tran_amt_2 number(30,2) -- 交易金额2
    ,tran_postsc_2 varchar2(750) -- 交易附言2
    ,unbond_cargo_inco_flg varchar2(10) -- 保税货物项下收入标志
    ,decl_ps_name varchar2(750) -- 申报人名称
    ,decl_ps_tel_num varchar2(60) -- 申报人电话号码
    ,decl_dt date -- 申报日期
    ,bus_id varchar2(100) -- 业务编号
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
grant select on ${iml_schema}.agt_overs_remit_decl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_overs_remit_decl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_overs_remit_decl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_overs_remit_decl_info_h is '境外汇款申报信息历史';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.decl_id is '申报编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.temp_decl_flow_id is '临时申报流水编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.init_enty_id is '原始实体编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.modif_rs_comnt is '变更原因说明';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.decl_num is '申报号码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.recver_permt_cty_rg_cd is '收款人常驻国家和地区代码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.pay_type_cd is '付款类型代码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_id_1 is '交易编号1';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_amt_1 is '交易金额1';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_postsc_1 is '交易附言1';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_id_2 is '交易编号2';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_amt_2 is '交易金额2';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.tran_postsc_2 is '交易附言2';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.unbond_cargo_inco_flg is '保税货物项下收入标志';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.decl_ps_name is '申报人名称';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.decl_ps_tel_num is '申报人电话号码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.decl_dt is '申报日期';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_overs_remit_decl_info_h.etl_timestamp is 'ETL处理时间戳';
