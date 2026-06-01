/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_tips_trea_cap_tran_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_tips_trea_cap_tran_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tips_trea_cap_tran_info_h(
    cap_type_descb varchar2(375) -- 资金类型描述
    ,payer_acct_id varchar2(60) -- 付款人账户编号
    ,payer_name varchar2(375) -- 付款人名称
    ,pay_bank_bank_no varchar2(100) -- 付款行行号
    ,pay_bank_bank_name varchar2(750) -- 付款行行名称
    ,recver_acct_id varchar2(60) -- 收款人账户编号
    ,recver_name varchar2(375) -- 收款人名称
    ,recv_bank_bank_no varchar2(100) -- 收款行行号
    ,recv_bank_bank_name varchar2(750) -- 收款行行名称
    ,postsc varchar2(750) -- 附言
    ,modif_org_id varchar2(60) -- 变更机构编号
    ,modif_dt date -- 变更日期
    ,modif_tm date -- 变更时间
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
grant select on ${iml_schema}.ref_tips_trea_cap_tran_info_h to ${icl_schema};
grant select on ${iml_schema}.ref_tips_trea_cap_tran_info_h to ${idl_schema};
grant select on ${iml_schema}.ref_tips_trea_cap_tran_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_tips_trea_cap_tran_info_h is 'TIPS国库资金划拨信息历史';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.cap_type_descb is '资金类型描述';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.payer_acct_id is '付款人账户编号';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.payer_name is '付款人名称';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.pay_bank_bank_no is '付款行行号';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.pay_bank_bank_name is '付款行行名称';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.recver_acct_id is '收款人账户编号';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.recv_bank_bank_no is '收款行行号';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.recv_bank_bank_name is '收款行行名称';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.postsc is '附言';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.modif_org_id is '变更机构编号';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.modif_tm is '变更时间';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_tips_trea_cap_tran_info_h.etl_timestamp is 'ETL处理时间戳';
