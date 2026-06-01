/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_ibank_bond_debit_crdt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_ibank_bond_debit_crdt
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_bond_debit_crdt purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_bond_debit_crdt(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,fin_instm_id varchar2(100) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,market_type_id varchar2(60) -- 市场类型编号
    ,obj_id varchar2(60) -- 对象编号
    ,asset_uniq_idf_id varchar2(100) -- 资产唯一标识编号
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,tran_acct_b_name varchar2(250) -- 交易账簿名称
    ,acct_b_attr_cd varchar2(10) -- 账簿属性代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,cntpty_cust_id varchar2(100) -- 交易对手客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(250) -- 投组名称
    ,pric_subj_id varchar2(60) -- 本金科目编号
    ,int_subj_id varchar2(100) -- 利息科目编号
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tran_amt number(38,4) -- 交易金额
    ,exp_stl_amt number(38,4) -- 到期结算金额
    ,debit_crdt_fee_rat number(38,8) -- 借贷费率
    ,debit_crdt_days number(22,0) -- 借贷天数
    ,inpwn_bond_comb varchar2(750) -- 质押债券组合
    ,underly_bond_id varchar2(100) -- 标的债券编号
    ,inpwn_cert_face_lmt number(30,8) -- 质押券面额
    ,acru_int number(30,8) -- 应计利息
    ,int_recvbl number(30,8) -- 应收利息
    ,hold_pos number(30,8) -- 持有仓位
    ,currt_bal number(30,2) -- 当期余额
    ,tran_id varchar2(100) -- 交易编号
    ,tran_clear_acct_id varchar2(256) -- 交易清算账户编号
    ,tran_clear_bank_no varchar2(256) -- 交易清算银行行号
    ,tran_clear_bank_name varchar2(500) -- 交易清算银行行名
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_ibank_bond_debit_crdt to ${idl_schema};
grant select on ${icl_schema}.cmm_ibank_bond_debit_crdt to ${iel_schema};
grant select on ${icl_schema}.cmm_ibank_bond_debit_crdt to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_ibank_bond_debit_crdt is '同业债券借贷';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.ext_secu_acct_id is '外部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.fin_instm_id is '金融工具编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.asset_type_name is '资产类型名称';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.market_type_id is '市场类型编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.obj_id is '对象编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.asset_uniq_idf_id is '资产唯一标识编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.prod_type_cd is '产品类型代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_acct_b_name is '交易账簿名称';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.acct_b_attr_cd is '账簿属性代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.cntpty_cust_id is '交易对手客户编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.pric_subj_id is '本金科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.int_subj_id is '利息科目编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.exp_stl_amt is '到期结算金额';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.debit_crdt_fee_rat is '借贷费率';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.debit_crdt_days is '借贷天数';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.inpwn_bond_comb is '质押债券组合';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.underly_bond_id is '标的债券编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.inpwn_cert_face_lmt is '质押券面额';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.hold_pos is '持有仓位';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_clear_acct_id is '交易清算账户编号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_clear_bank_no is '交易清算银行行号';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.tran_clear_bank_name is '交易清算银行行名';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_ibank_bond_debit_crdt.etl_timestamp is 'ETL处理时间戳';
