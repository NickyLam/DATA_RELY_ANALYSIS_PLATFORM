/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_forgn_inco_decl_base_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_forgn_inco_decl_base_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_forgn_inco_decl_base_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_forgn_inco_decl_base_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,decl_id varchar2(100) -- 申报编号
    ,temp_decl_flow_num varchar2(100) -- 临时申报流水号
    ,init_enty_id varchar2(100) -- 原始实体编号
    ,edit_id varchar2(100) -- 版本编号
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,modif_rs_descb varchar2(750) -- 变更原因描述
    ,decl_num varchar2(60) -- 申报号码
    ,recver_type_cd varchar2(30) -- 收款人类型代码
    ,indv_id_card_piece_no_code varchar2(60) -- 个人身份证件号码
    ,orgnz_id varchar2(100) -- 组织机构编号
    ,recver_name varchar2(750) -- 收款人名称
    ,payer_name varchar2(750) -- 付款人名称
    ,rev_curr_cd varchar2(30) -- 收入款币种代码
    ,rev_amt number(30) -- 收入款金额
    ,soe_exch_rat number(18,8) -- 结汇汇率
    ,soe_amt number(30) -- 结汇金额
    ,cny_acct_id varchar2(100) -- 人民币账户编号
    ,spot_exch_amt number(30) -- 现汇金额
    ,fx_acct_id varchar2(100) -- 外汇账户编号
    ,other_amt number(30) -- 其他金额
    ,other_acct_id varchar2(100) -- 其它账户编号
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,bank_bus_id varchar2(100) -- 银行业务编号
    ,dom_bank_deduct_curr_cd varchar2(30) -- 国内银行扣费币种代码
    ,dom_bank_deduct_amt number(30) -- 国内银行扣费金额
    ,overs_bank_deduct_curr_cd varchar2(30) -- 国外银行扣费币种代码
    ,overs_bank_deduct_amt number(30) -- 国外银行扣费金额
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
grant select on ${iml_schema}.agt_forgn_inco_decl_base_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_forgn_inco_decl_base_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_forgn_inco_decl_base_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_forgn_inco_decl_base_info_h is '涉外收入申报基础信息历史';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.decl_id is '申报编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.temp_decl_flow_num is '临时申报流水号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.init_enty_id is '原始实体编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.edit_id is '版本编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.modif_rs_descb is '变更原因描述';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.decl_num is '申报号码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.recver_type_cd is '收款人类型代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.indv_id_card_piece_no_code is '个人身份证件号码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.orgnz_id is '组织机构编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.recver_name is '收款人名称';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.payer_name is '付款人名称';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.rev_curr_cd is '收入款币种代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.rev_amt is '收入款金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.soe_exch_rat is '结汇汇率';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.soe_amt is '结汇金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.cny_acct_id is '人民币账户编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.spot_exch_amt is '现汇金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.fx_acct_id is '外汇账户编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.other_amt is '其他金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.other_acct_id is '其它账户编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.bank_bus_id is '银行业务编号';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.dom_bank_deduct_curr_cd is '国内银行扣费币种代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.dom_bank_deduct_amt is '国内银行扣费金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.overs_bank_deduct_curr_cd is '国外银行扣费币种代码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.overs_bank_deduct_amt is '国外银行扣费金额';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_forgn_inco_decl_base_info_h.etl_timestamp is 'ETL处理时间戳';
