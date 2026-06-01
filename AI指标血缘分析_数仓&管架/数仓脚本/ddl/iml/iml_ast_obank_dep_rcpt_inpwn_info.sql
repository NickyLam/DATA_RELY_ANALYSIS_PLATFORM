/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_obank_dep_rcpt_inpwn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,vouch_id varchar2(100) -- 凭证编号
    ,aval_amt number(30,2) -- 可用金额
    ,bank_name varchar2(150) -- 银行名称
    ,bank_rgst_cd varchar2(30) -- 银行注册地代码
    ,ext_rating_dt date -- 外部评级日期
    ,ext_rating_rest_cd varchar2(30) -- 外部评级结果代码
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,dep_term number(30,2) -- 存期
    ,int_rat number(30,2) -- 利率
    ,pric_amt number(30,2) -- 本金金额
    ,curr_cd varchar2(30) -- 币种代码
    ,remark varchar2(4000) -- 备注
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
grant select on ${iml_schema}.ast_obank_dep_rcpt_inpwn_info to ${icl_schema};
grant select on ${iml_schema}.ast_obank_dep_rcpt_inpwn_info to ${idl_schema};
grant select on ${iml_schema}.ast_obank_dep_rcpt_inpwn_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info is '他行存单质押信息';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.vouch_id is '凭证编号';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.aval_amt is '可用金额';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.bank_name is '银行名称';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.bank_rgst_cd is '银行注册地代码';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.ext_rating_dt is '外部评级日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.ext_rating_rest_cd is '外部评级结果代码';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.effect_dt is '生效日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.exp_dt is '到期日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.dep_term is '存期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.int_rat is '利率';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.pric_amt is '本金金额';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.remark is '备注';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_obank_dep_rcpt_inpwn_info.etl_timestamp is 'ETL处理时间戳';
