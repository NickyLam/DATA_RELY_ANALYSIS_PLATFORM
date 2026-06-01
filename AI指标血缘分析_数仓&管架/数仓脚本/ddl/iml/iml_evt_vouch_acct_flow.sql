/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_vouch_acct_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_vouch_acct_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_vouch_acct_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_acct_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,vouch_flow_num varchar2(100) -- 凭证流水号
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,check_teller_id varchar2(100) -- 检查柜员编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,card_no varchar2(60) -- 卡号
    ,base_amt number(30,2) -- 基础金额
    ,curr_cd varchar2(30) -- 币种代码
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,vouch_status_cd varchar2(30) -- 凭证状态代码
    ,vouch_orig_status_cd varchar2(30) -- 凭证原状态代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,chn_id varchar2(100) -- 渠道编号
    ,tran_descb varchar2(500) -- 交易描述
    ,tran_id varchar2(100) -- 交易编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,remark varchar2(500) -- 备注
    ,cancel_rs_cd varchar2(30) -- 作废原因代码
    ,belong_module varchar2(30) -- 所属模块
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_vouch_acct_flow to ${icl_schema};
grant select on ${iml_schema}.evt_vouch_acct_flow to ${idl_schema};
grant select on ${iml_schema}.evt_vouch_acct_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_vouch_acct_flow is '凭证账户流水';
comment on column ${iml_schema}.evt_vouch_acct_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.vouch_flow_num is '凭证流水号';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_vouch_acct_flow.check_teller_id is '检查柜员编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_vouch_acct_flow.card_no is '卡号';
comment on column ${iml_schema}.evt_vouch_acct_flow.base_amt is '基础金额';
comment on column ${iml_schema}.evt_vouch_acct_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_vouch_acct_flow.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_vouch_acct_flow.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_vouch_acct_flow.vouch_status_cd is '凭证状态代码';
comment on column ${iml_schema}.evt_vouch_acct_flow.vouch_orig_status_cd is '凭证原状态代码';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_vouch_acct_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_vouch_acct_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_id is '交易编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_vouch_acct_flow.remark is '备注';
comment on column ${iml_schema}.evt_vouch_acct_flow.cancel_rs_cd is '作废原因代码';
comment on column ${iml_schema}.evt_vouch_acct_flow.belong_module is '所属模块';
comment on column ${iml_schema}.evt_vouch_acct_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_vouch_acct_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_vouch_acct_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_vouch_acct_flow.etl_timestamp is 'ETL处理时间戳';
