/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_agt_saving_prod_dmic_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl(
    etl_dt date -- 数据日期   
    ,agt_id varchar2(60) -- 协议编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,dtl_seq_num number(10) -- 明细序号   
    ,liab_acct_num varchar2(60) -- 负债账号   
    ,acct_name varchar2(250) -- 账户名称   
    ,bal_name_field varchar2(100) -- 余额名称字段   
    ,tran_amt number(30,2) -- 交易金额   
    ,bal number(30,2) -- 余额   
    ,cust_acct_num varchar2(60) -- 客户账号   
    ,acct_num_seq_num varchar2(30) -- 账号序号   
    ,prod_id varchar2(60) -- 产品编号   
    ,debit_crdt_flg varchar2(10) -- 借贷标志   
    ,tran_curr_cd varchar2(10) -- 交易币种代码   
    ,ec_flg varchar2(10) -- 钞汇标志   
    ,prod_belong_obj_cd varchar2(10) -- 产品所属对象代码   
    ,cash_trans_cd varchar2(10) -- 现转代码   
    ,cntpty_fin_inst_type_cd varchar2(10) -- 对方金融机构类型代码   
    ,rec_status_cd varchar2(10) -- 记录状态代码   
    ,dep_term varchar2(10) -- 存期代码   
    ,vouch_kind_cd varchar2(10) -- 凭证种类代码   
    ,vouch_batch_no varchar2(60) -- 凭证批号   
    ,vouch_seq_num varchar2(30) -- 凭证序号   
    ,tran_chn varchar2(10) -- 交易渠道代码   
    ,ext_tran_code varchar2(10) -- 外部交易码   
    ,intnal_tran_code varchar2(10) -- 内部交易码   
    ,tran_org_id varchar2(60) -- 交易机构编号   
    ,tran_acct_instit_id varchar2(60) -- 交易账务机构编号   
    ,open_acct_org_id varchar2(60) -- 开户机构编号   
    ,acct_acct_instit_id varchar2(60) -- 账户账务机构编号   
    ,operr_id varchar2(60) -- 操作员编号   
    ,cntpty_cust_acct_num varchar2(60) -- 对方客户账号   
    ,cntpty_acct_name varchar2(250) -- 对方账户名称   
    ,cntpty_fin_inst_name varchar2(100) -- 对方金融机构名称   
    ,cntpty_acct_open_bank_num varchar2(60) -- 交易对手账户开户行号   
    ,teller_flow_num varchar2(60) -- 柜员流水号   
    ,trast_dt date -- 办理日期   
    ,trast_tm varchar2(10) -- 办理时间   
    ,host_dt date -- 主机日期   
    ,revs_cd varchar2(10) -- 冲正代码   
    ,brevs_flg varchar2(10) -- 被冲正标志   
    ,wa_init_dt date -- 错账原日期   
    ,wa_init_teller_flow_num varchar2(60) -- 错账原柜员流水号   
    ,tran_proc_char varchar2(10) -- 交易处理性质   
    ,matn_teller_id varchar2(60) -- 维护柜员编号   
    ,matn_org_id varchar2(60) -- 维护机构编号   
    ,matn_dt date -- 维护日期   
    ,matn_tm varchar2(10) -- 维护时间   
    ,update_tm_stamp timestamp -- 更新时间戳   
    ,memo_id varchar2(60) -- 摘要编号   
    ,memo_descb varchar2(100) -- 摘要描述   
    ,cntpty_acct_num varchar2(60) -- 对方账号   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl is '储蓄产品户动账交易明细';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.agt_id is '协议编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.dtl_seq_num is '明细序号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.liab_acct_num is '负债账号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.acct_name is '账户名称';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.bal_name_field is '余额名称字段';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.bal is '余额';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cust_acct_num is '客户账号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.acct_num_seq_num is '账号序号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.prod_id is '产品编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.debit_crdt_flg is '借贷标志';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_curr_cd is '交易币种代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.ec_flg is '钞汇标志';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.prod_belong_obj_cd is '产品所属对象代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cash_trans_cd is '现转代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_fin_inst_type_cd is '对方金融机构类型代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.rec_status_cd is '记录状态代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.dep_term is '存期代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.vouch_kind_cd is '凭证种类代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.vouch_batch_no is '凭证批号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.vouch_seq_num is '凭证序号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_chn is '交易渠道代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.ext_tran_code is '外部交易码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.intnal_tran_code is '内部交易码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_acct_instit_id is '交易账务机构编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.acct_acct_instit_id is '账户账务机构编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.operr_id is '操作员编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_cust_acct_num is '对方客户账号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_acct_name is '对方账户名称';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_fin_inst_name is '对方金融机构名称';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_acct_open_bank_num is '交易对手账户开户行号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.teller_flow_num is '柜员流水号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.trast_dt is '办理日期';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.trast_tm is '办理时间';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.host_dt is '主机日期';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.revs_cd is '冲正代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.brevs_flg is '被冲正标志';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.wa_init_dt is '错账原日期';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.wa_init_teller_flow_num is '错账原柜员流水号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.tran_proc_char is '交易处理性质';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.matn_teller_id is '维护柜员编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.matn_org_id is '维护机构编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.matn_dt is '维护日期';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.matn_tm is '维护时间';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.update_tm_stamp is '更新时间戳';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.memo_id is '摘要编号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.memo_descb is '摘要描述';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.cntpty_acct_num is '对方账号';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.aml_agt_saving_prod_dmic_tran_dtl.etl_timestamp is '数据处理时间';