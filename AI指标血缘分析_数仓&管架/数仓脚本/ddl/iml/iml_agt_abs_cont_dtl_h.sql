/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_abs_cont_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_abs_cont_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_abs_cont_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_cont_dtl_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,asset_bag_cont_dtl_seq_num varchar2(60) -- 资产包合同明细序号
    ,asset_bag_cont_id varchar2(100) -- 资产包合同编号
    ,loan_num varchar2(60) -- 贷款号
    ,distr_flow_num varchar2(100) -- 放款流水号
    ,prod_id varchar2(100) -- 产品编号
    ,dubil_id varchar2(100) -- 借据编号
    ,curr_cd varchar2(30) -- 币种代码
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,bal number(30,2) -- 余额
    ,asset_acct_status_cd varchar2(30) -- 资产账户状态代码
    ,issue_batch_no varchar2(60) -- 发行批次号
    ,issue_flow_num varchar2(100) -- 发行流水号
    ,issue_convt_prem number(30,2) -- 发行折溢价
    ,issue_revo_batch_no varchar2(60) -- 发行撤销批次号
    ,circl_buy_flg varchar2(10) -- 循环购买标志
    ,circl_buy_batch_no varchar2(60) -- 循环购买批次号
    ,circl_buy_flow_num varchar2(100) -- 循环购买流水号
    ,circl_buy_dt date -- 循环购买日期
    ,revo_pkg_batch_no varchar2(60) -- 撤包批次号
    ,revo_pkg_tran_flow_num varchar2(100) -- 撤包交易流水号
    ,revo_tran_ref_no varchar2(60) -- 撤销交易参考号
    ,redem_tran_flow_num varchar2(100) -- 赎回交易流水号
    ,redem_batch_no varchar2(60) -- 赎回批次号
    ,redem_convt_prem number(30,2) -- 赎回折溢价
    ,pkg_batch_no varchar2(60) -- 封包批次号
    ,pkg_flow_num varchar2(100) -- 封包流水号
    ,pkg_tran_dt date -- 封包交易日期
    ,tran_code_descb varchar2(500) -- 交易码描述
    ,final_modif_dt date -- 最后修改日期
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.agt_abs_cont_dtl_h to ${icl_schema};
grant select on ${iml_schema}.agt_abs_cont_dtl_h to ${idl_schema};
grant select on ${iml_schema}.agt_abs_cont_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_abs_cont_dtl_h is '资产转让合同明细历史';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.asset_bag_cont_dtl_seq_num is '资产包合同明细序号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.asset_bag_cont_id is '资产包合同编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.distr_flow_num is '放款流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.bal is '余额';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.asset_acct_status_cd is '资产账户状态代码';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.issue_batch_no is '发行批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.issue_flow_num is '发行流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.issue_convt_prem is '发行折溢价';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.issue_revo_batch_no is '发行撤销批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.circl_buy_flg is '循环购买标志';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.circl_buy_batch_no is '循环购买批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.circl_buy_flow_num is '循环购买流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.circl_buy_dt is '循环购买日期';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.revo_pkg_batch_no is '撤包批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.revo_pkg_tran_flow_num is '撤包交易流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.revo_tran_ref_no is '撤销交易参考号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.redem_tran_flow_num is '赎回交易流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.redem_batch_no is '赎回批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.redem_convt_prem is '赎回折溢价';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.pkg_batch_no is '封包批次号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.pkg_flow_num is '封包流水号';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.pkg_tran_dt is '封包交易日期';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.tran_code_descb is '交易码描述';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_abs_cont_dtl_h.etl_timestamp is 'ETL处理时间戳';
