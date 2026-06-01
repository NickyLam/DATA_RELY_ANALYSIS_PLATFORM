/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ibank_payfan_rgst_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ibank_payfan_rgst_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_payfan_rgst_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_inr varchar2(45) -- 交易INR
    ,rela_table_name varchar2(750) -- 关联表名称
    ,rela_tab_inr varchar2(45) -- 关联表INR
    ,tran_id varchar2(100) -- 交易编号
    ,ths_tm_payfan_pric number(30,8) -- 本次代付本金
    ,ths_tm_payfan_int number(30,8) -- 本次代付利息
    ,ths_tm_payfan_pnlt number(30,8) -- 本次代付罚息
    ,payfan_value_dt date -- 代付起息日期
    ,payfan_exp_dt date -- 代付到期日期
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,curr_cd varchar2(30) -- 币种代码
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,payfan_pnlt_int_rat number(18,8) -- 代付罚息利率
    ,entry_amt number(30,8) -- 记账金额
    ,int_adj_amt number(30,2) -- 利息调整金额
    ,pnlt_adj_amt number(30,2) -- 罚息调整金额
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,dubil_id varchar2(100) -- 借据编号
    ,pay_cont_id varchar2(100) -- 付款合同编号
    ,applit_cust_id varchar2(100) -- 申请人客户编号
    ,final_coll_flg varchar2(10) -- 最后一次归集标志
    ,belong_org_id varchar2(100) -- 所属机构编号
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
grant select on ${iml_schema}.agt_ibank_payfan_rgst_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_ibank_payfan_rgst_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_ibank_payfan_rgst_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ibank_payfan_rgst_info_h is '同业代付登记信息历史';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.tran_inr is '交易INR';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.rela_table_name is '关联表名称';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.rela_tab_inr is '关联表INR';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.tran_id is '交易编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.ths_tm_payfan_pric is '本次代付本金';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.ths_tm_payfan_int is '本次代付利息';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.ths_tm_payfan_pnlt is '本次代付罚息';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.payfan_value_dt is '代付起息日期';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.payfan_exp_dt is '代付到期日期';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.payfan_pnlt_int_rat is '代付罚息利率';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.entry_amt is '记账金额';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.int_adj_amt is '利息调整金额';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.pnlt_adj_amt is '罚息调整金额';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.pay_cont_id is '付款合同编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.applit_cust_id is '申请人客户编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.final_coll_flg is '最后一次归集标志';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ibank_payfan_rgst_info_h.etl_timestamp is 'ETL处理时间戳';
