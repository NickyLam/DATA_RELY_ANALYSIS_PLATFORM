/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intstl_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intstl_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intstl_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intstl_acct(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_prior_level_cd varchar2(30) -- 账户优先级代码
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,acct_bank_id varchar2(100) -- 账户行账户编号
    ,acct_bank_name varchar2(375) -- 账户行账户名称
    ,acct_bank_type_cd varchar2(30) -- 账户行类型代码
    ,acct_bank_party_id varchar2(60) -- 账户行当事人编号
    ,open_org_acct_id varchar2(60) -- 账号开户机构账户编号
    ,open_org_acct_name varchar2(375) -- 账号开户机构账户名称
    ,open_org_acct_type_cd varchar2(30) -- 账号开户机构账户类型代码
    ,open_acct_org_party_id varchar2(60) -- 账号开户机构当事人编号
    ,pos_acct_flg varchar2(30) -- 头寸账户标志
    ,pay_back_flg varchar2(30) -- 偿付标志
    ,del_flg varchar2(30) -- 删除标志
    ,edit_id varchar2(30) -- 版本编号
    ,debit_crdt_dir_cd varchar2(30) -- 借贷方向代码
    ,acct_bank_flg varchar2(30) -- 账户行账号标志
    ,swift_acct_name varchar2(375) -- SWIFT账户名称
    ,hxb_acct_flg varchar2(30) -- 我行账户标志
    ,acct_bank_bic_code varchar2(45) -- 账户行BIC码
    ,inter_bank_acct_id varchar2(100) -- 国际银行账户编号
    ,enty_group_id varchar2(30) -- 实体组编号
    ,acct_num_name_comnt varchar2(375) -- 账号名称说明
    ,acct_usage_type_cd varchar2(30) -- 账户用途类型代码
    ,subj_cd varchar2(30) -- 科目代码
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,belong_org_id varchar2(30) -- 所属机构编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,prod_name varchar2(375) -- 产品名称
    ,fori_exch_acct_char_cd varchar2(60) -- 外汇账户性质代码
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,sub_acct_num varchar2(60) -- 子账号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_intstl_acct to ${icl_schema};
grant select on ${iml_schema}.agt_intstl_acct to ${idl_schema};
grant select on ${iml_schema}.agt_intstl_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intstl_acct is '国结账户';
comment on column ${iml_schema}.agt_intstl_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intstl_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intstl_acct.acct_prior_level_cd is '账户优先级代码';
comment on column ${iml_schema}.agt_intstl_acct.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_intstl_acct.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_id is '账户行账户编号';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_name is '账户行账户名称';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_type_cd is '账户行类型代码';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_party_id is '账户行当事人编号';
comment on column ${iml_schema}.agt_intstl_acct.open_org_acct_id is '账号开户机构账户编号';
comment on column ${iml_schema}.agt_intstl_acct.open_org_acct_name is '账号开户机构账户名称';
comment on column ${iml_schema}.agt_intstl_acct.open_org_acct_type_cd is '账号开户机构账户类型代码';
comment on column ${iml_schema}.agt_intstl_acct.open_acct_org_party_id is '账号开户机构当事人编号';
comment on column ${iml_schema}.agt_intstl_acct.pos_acct_flg is '头寸账户标志';
comment on column ${iml_schema}.agt_intstl_acct.pay_back_flg is '偿付标志';
comment on column ${iml_schema}.agt_intstl_acct.del_flg is '删除标志';
comment on column ${iml_schema}.agt_intstl_acct.edit_id is '版本编号';
comment on column ${iml_schema}.agt_intstl_acct.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_flg is '账户行账号标志';
comment on column ${iml_schema}.agt_intstl_acct.swift_acct_name is 'SWIFT账户名称';
comment on column ${iml_schema}.agt_intstl_acct.hxb_acct_flg is '我行账户标志';
comment on column ${iml_schema}.agt_intstl_acct.acct_bank_bic_code is '账户行BIC码';
comment on column ${iml_schema}.agt_intstl_acct.inter_bank_acct_id is '国际银行账户编号';
comment on column ${iml_schema}.agt_intstl_acct.enty_group_id is '实体组编号';
comment on column ${iml_schema}.agt_intstl_acct.acct_num_name_comnt is '账号名称说明';
comment on column ${iml_schema}.agt_intstl_acct.acct_usage_type_cd is '账户用途类型代码';
comment on column ${iml_schema}.agt_intstl_acct.subj_cd is '科目代码';
comment on column ${iml_schema}.agt_intstl_acct.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_intstl_acct.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_intstl_acct.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.agt_intstl_acct.prod_name is '产品名称';
comment on column ${iml_schema}.agt_intstl_acct.fori_exch_acct_char_cd is '外汇账户性质代码';
comment on column ${iml_schema}.agt_intstl_acct.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_intstl_acct.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_intstl_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_intstl_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_intstl_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_intstl_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intstl_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intstl_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intstl_acct.etl_timestamp is 'ETL处理时间戳';
