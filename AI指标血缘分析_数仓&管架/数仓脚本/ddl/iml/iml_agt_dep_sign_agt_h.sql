/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_sign_agt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_sign_agt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_sign_agt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_sign_agt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,sign_agt_id varchar2(250) -- 签约协议编号
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,sign_agt_type_cd varchar2(30) -- 签约协议类型代码
    ,agt_layered_flg varchar2(10) -- 协议分层标志
    ,agt_key_type_cd varchar2(30) -- 协议键类型代码
    ,agt_key varchar2(250) -- 协议键值
    ,agt_amt number(30,2) -- 协议金额
    ,sign_main_prod_id varchar2(100) -- 签约主产品编号
    ,sign_chn_id varchar2(100) -- 签约渠道编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,agt_sign_dt date -- 协议签约日期
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,valid_dt date -- 有效日期
    ,invalid_dt date -- 失效日期
    ,sign_agt_status_cd varchar2(30) -- 签约协议状态代码
    ,allow_clos_acct_flg varchar2(10) -- 允许销户标志
    ,cust_acct_num varchar2(60) -- 客户账号
    ,acct_prod_id varchar2(100) -- 账户产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_name varchar2(500) -- 账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,cust_abbr varchar2(500) -- 客户简称
    ,sign_cntpty_acct_id varchar2(100) -- 签约对手账户编号
    ,rels_org_id varchar2(100) -- 解约机构编号
    ,rels_chn_id varchar2(100) -- 解约渠道编号
    ,rels_dt date -- 解约日期
    ,rels_teller_id varchar2(100) -- 解约柜员编号
    ,tran_sign_dt date -- 交易签约日期
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,auto_scd_sign_flg varchar2(10) -- 自动续签标志
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
grant select on ${iml_schema}.agt_dep_sign_agt_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_sign_agt_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_sign_agt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_sign_agt_h is '存款签约协议历史';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_agt_type_cd is '签约协议类型代码';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_layered_flg is '协议分层标志';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_key_type_cd is '协议键类型代码';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_key is '协议键值';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_amt is '协议金额';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_main_prod_id is '签约主产品编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_chn_id is '签约渠道编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.agt_sign_dt is '协议签约日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.valid_dt is '有效日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_agt_status_cd is '签约协议状态代码';
comment on column ${iml_schema}.agt_dep_sign_agt_h.allow_clos_acct_flg is '允许销户标志';
comment on column ${iml_schema}.agt_dep_sign_agt_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.acct_prod_id is '账户产品编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_dep_sign_agt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.cust_abbr is '客户简称';
comment on column ${iml_schema}.agt_dep_sign_agt_h.sign_cntpty_acct_id is '签约对手账户编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.rels_org_id is '解约机构编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.rels_chn_id is '解约渠道编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.rels_teller_id is '解约柜员编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.tran_sign_dt is '交易签约日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_sign_agt_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_sign_agt_h.auto_scd_sign_flg is '自动续签标志';
comment on column ${iml_schema}.agt_dep_sign_agt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_sign_agt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_sign_agt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_sign_agt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_sign_agt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_sign_agt_h.etl_timestamp is 'ETL处理时间戳';
