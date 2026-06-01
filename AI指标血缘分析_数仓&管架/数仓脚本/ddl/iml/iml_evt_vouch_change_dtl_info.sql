/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_vouch_change_dtl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_vouch_change_dtl_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_vouch_change_dtl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_change_dtl_info(
    evt_id varchar2(250) -- 事件编号
    ,vouch_change_id varchar2(100) -- 凭证更换编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,new_card_num varchar2(60) -- 新卡号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,init_vouch_type_cd varchar2(30) -- 原凭证类型代码
    ,new_vouch_type_cd varchar2(30) -- 新凭证类型代码
    ,new_vouch_no varchar2(60) -- 新凭证号码
    ,loss_id varchar2(100) -- 挂失编号
    ,vouch_no varchar2(60) -- 凭证号码
    ,vouch_modif_type_cd varchar2(30) -- 凭证变更类型代码
    ,change_rs varchar2(500) -- 更换原因
    ,ba_auth_teller_id varchar2(100) -- 银承授权柜员编号
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,lmt_id varchar2(100) -- 限制编号
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
grant select on ${iml_schema}.evt_vouch_change_dtl_info to ${icl_schema};
grant select on ${iml_schema}.evt_vouch_change_dtl_info to ${idl_schema};
grant select on ${iml_schema}.evt_vouch_change_dtl_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_vouch_change_dtl_info is '凭证更换明细信息';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.vouch_change_id is '凭证更换编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.acct_id is '账户编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.cust_id is '客户编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.new_card_num is '新卡号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.init_vouch_type_cd is '原凭证类型代码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.new_vouch_type_cd is '新凭证类型代码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.new_vouch_no is '新凭证号码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.loss_id is '挂失编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.vouch_no is '凭证号码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.vouch_modif_type_cd is '凭证变更类型代码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.change_rs is '更换原因';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.ba_auth_teller_id is '银承授权柜员编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.lmt_id is '限制编号';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_vouch_change_dtl_info.etl_timestamp is 'ETL处理时间戳';
