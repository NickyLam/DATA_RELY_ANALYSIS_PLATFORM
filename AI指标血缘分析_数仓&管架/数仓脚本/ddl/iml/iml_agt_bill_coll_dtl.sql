/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bill_coll_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bill_coll_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bill_coll_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_coll_dtl(
    agt_id varchar2(60) -- 协议编号
    ,coll_dtl_id varchar2(60) -- 托收明细编号
    ,lp_id varchar2(60) -- 法人编号
    ,batch_id varchar2(60) -- 批次编号
    ,bill_id varchar2(60) -- 票据编号
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,acpt_bank_addr varchar2(1000) -- 承兑行地址
    ,core_entry_acct_num varchar2(250) -- 核心记账账号
    ,entry_dt date -- 记账日期
    ,in_acct_dt date -- 来账日期
    ,in_acct_info_src_name varchar2(150) -- 来账信息来源名称
    ,in_acct_que_flow_num varchar2(250) -- 来账查询流水号
    ,valet_coll_flg varchar2(10) -- 代客托收标志
    ,sugst_payer_name varchar2(375) -- 提示付款人名称
    ,sugst_payer_acct_num varchar2(250) -- 提示付款人账号
    ,sugst_payer_open_bank_no varchar2(60) -- 提示付款人开户行行号
    ,send_out_coll_dt date -- 发出托收日期
    ,sugst_pay_curr_cd varchar2(30) -- 提示付款币种代码
    ,final_modif_operr_id varchar2(30) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
    ,coll_dtl_status_cd varchar2(30) -- 托收明细状态代码
    ,bill_amt number(30,2) -- 票据金额
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
grant select on ${iml_schema}.agt_bill_coll_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_bill_coll_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_bill_coll_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bill_coll_dtl is '票据托收明细';
comment on column ${iml_schema}.agt_bill_coll_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.coll_dtl_id is '托收明细编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.batch_id is '批次编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.bill_id is '票据编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_bill_coll_dtl.acpt_bank_addr is '承兑行地址';
comment on column ${iml_schema}.agt_bill_coll_dtl.core_entry_acct_num is '核心记账账号';
comment on column ${iml_schema}.agt_bill_coll_dtl.entry_dt is '记账日期';
comment on column ${iml_schema}.agt_bill_coll_dtl.in_acct_dt is '来账日期';
comment on column ${iml_schema}.agt_bill_coll_dtl.in_acct_info_src_name is '来账信息来源名称';
comment on column ${iml_schema}.agt_bill_coll_dtl.in_acct_que_flow_num is '来账查询流水号';
comment on column ${iml_schema}.agt_bill_coll_dtl.valet_coll_flg is '代客托收标志';
comment on column ${iml_schema}.agt_bill_coll_dtl.sugst_payer_name is '提示付款人名称';
comment on column ${iml_schema}.agt_bill_coll_dtl.sugst_payer_acct_num is '提示付款人账号';
comment on column ${iml_schema}.agt_bill_coll_dtl.sugst_payer_open_bank_no is '提示付款人开户行行号';
comment on column ${iml_schema}.agt_bill_coll_dtl.send_out_coll_dt is '发出托收日期';
comment on column ${iml_schema}.agt_bill_coll_dtl.sugst_pay_curr_cd is '提示付款币种代码';
comment on column ${iml_schema}.agt_bill_coll_dtl.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.agt_bill_coll_dtl.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.agt_bill_coll_dtl.coll_dtl_status_cd is '托收明细状态代码';
comment on column ${iml_schema}.agt_bill_coll_dtl.bill_amt is '票据金额';
comment on column ${iml_schema}.agt_bill_coll_dtl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_bill_coll_dtl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_bill_coll_dtl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bill_coll_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bill_coll_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bill_coll_dtl.etl_timestamp is 'ETL处理时间戳';
