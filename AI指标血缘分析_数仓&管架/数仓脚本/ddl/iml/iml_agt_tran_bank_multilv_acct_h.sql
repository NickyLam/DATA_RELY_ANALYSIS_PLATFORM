/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_tran_bank_multilv_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_tran_bank_multilv_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_tran_bank_multilv_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tran_bank_multilv_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_b_id varchar2(100) -- 账簿编号
    ,level1_acct_b_id varchar2(100) -- 一级账簿编号
    ,level2_acct_b_id varchar2(100) -- 二级账簿编号
    ,level3_acct_b_id varchar2(100) -- 三级账簿编号
    ,acct_b_name varchar2(500) -- 账簿名称
    ,acct_b_lev varchar2(30) -- 账簿级别
    ,bind_stl_acct_flg varchar2(10) -- 绑定结算账户标志
    ,stl_card_acct_id varchar2(100) -- 结算卡账户编号
    ,super_acct_b_id varchar2(100) -- 上级账簿编号
    ,create_tm date -- 创建时间
    ,acct_b_valid_flg varchar2(10) -- 账簿有效标志
    ,acct_b_bal number(30,2) -- 账簿余额
    ,sign_parent_acct_id varchar2(100) -- 签约母账户编号
    ,stl_card_status_cd varchar2(60) -- 结算卡状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_tran_bank_multilv_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_tran_bank_multilv_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_tran_bank_multilv_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_tran_bank_multilv_acct_h is '交易银行多级账簿历史';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.level1_acct_b_id is '一级账簿编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.level2_acct_b_id is '二级账簿编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.level3_acct_b_id is '三级账簿编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.acct_b_name is '账簿名称';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.acct_b_lev is '账簿级别';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.bind_stl_acct_flg is '绑定结算账户标志';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.stl_card_acct_id is '结算卡账户编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.super_acct_b_id is '上级账簿编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.create_tm is '创建时间';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.acct_b_valid_flg is '账簿有效标志';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.acct_b_bal is '账簿余额';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.sign_parent_acct_id is '签约母账户编号';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.stl_card_status_cd is '结算卡状态代码';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_tran_bank_multilv_acct_h.etl_timestamp is 'ETL处理时间戳';
