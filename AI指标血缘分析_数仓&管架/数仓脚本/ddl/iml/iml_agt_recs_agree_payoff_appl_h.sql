/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_recs_agree_payoff_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_recs_agree_payoff_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_recs_agree_payoff_appl_h(
    appl_id varchar2(60) -- 申请编号
    ,lp_id varchar2(60) -- 法人编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,bill_curr_cd varchar2(10) -- 票据币种代码
    ,bill_amt number(30,2) -- 票据金额
    ,agree_payoff_dt date -- 同意清偿日期
    ,agree_payoff_curr_cd varchar2(10) -- 同意清偿币种代码
    ,agree_payoff_amt number(30,2) -- 同意清偿金额
    ,agree_payoff_ps_cate_cd varchar2(10) -- 同意清偿人类别代码
    ,agree_payoff_ps_name varchar2(375) -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd varchar2(60) -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id varchar2(60) -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no varchar2(30) -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no varchar2(30) -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd varchar2(30) -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd varchar2(10) -- 追索同意清偿状态代码
    ,entry_status_cd varchar2(10) -- 记账状态代码
    ,entry_dt date -- 记账日期
    ,recv_dt date -- 签收日期
    ,recv_opinion_type_cd varchar2(10) -- 签收意见类型代码
    ,revo_dt date -- 撤销日期
    ,send_out_recs_rgst_b_id varchar2(60) -- 发出追索登记簿编号
    ,final_modif_teller_id varchar2(60) -- 最后修改柜员编号
    ,final_modif_teller_tm timestamp -- 最后修改柜员时间
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
grant select on ${iml_schema}.agt_recs_agree_payoff_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_recs_agree_payoff_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_recs_agree_payoff_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_recs_agree_payoff_appl_h is '追索同意清偿申请历史';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.bill_num is '票据号码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.bill_curr_cd is '票据币种代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.bill_amt is '票据金额';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_dt is '同意清偿日期';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_curr_cd is '同意清偿币种代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_amt is '同意清偿金额';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_cate_cd is '同意清偿人类别代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_name is '同意清偿人名称';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_orgnz_cd is '同意清偿人组织机构代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_acct_id is '同意清偿人账户编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_open_bank_no is '同意清偿人开户行行号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.agree_payoff_ps_udtake_bk_bank_no is '同意清偿人承接行行号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.payoff_appl_initor_cd is '清偿申请发起端代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.recs_agree_payoff_status_cd is '追索同意清偿状态代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.entry_status_cd is '记账状态代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.entry_dt is '记账日期';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.recv_dt is '签收日期';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.recv_opinion_type_cd is '签收意见类型代码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.revo_dt is '撤销日期';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.send_out_recs_rgst_b_id is '发出追索登记簿编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.final_modif_teller_tm is '最后修改柜员时间';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_recs_agree_payoff_appl_h.etl_timestamp is 'ETL处理时间戳';
