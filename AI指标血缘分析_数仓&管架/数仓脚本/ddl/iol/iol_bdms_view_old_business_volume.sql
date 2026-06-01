/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_view_old_business_volume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_view_old_business_volume
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_view_old_business_volume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_view_old_business_volume(
    txn_dt date -- 交易日期
    ,txn_tm varchar2(150) -- 交易时间
    ,blng_org_id varchar2(150) -- 所属机构编号
    ,oper_teller_id varchar2(150) -- 经办柜员编号
    ,oper_teller_name varchar2(150) -- 经办柜员名称
    ,auth_teller_id varchar2(150) -- 授权柜员编号
    ,auth_teller_name varchar2(150) -- 授权柜员名称
    ,txn_num varchar2(150) -- 交易码
    ,txn_desc varchar2(150) -- 交易描述
    ,biz_sys_evt_id varchar2(150) -- 业务系统流水号
    ,bcs_evt_id varchar2(150) -- 核心系统流水号
    ,data_src_cd varchar2(150) -- 系统代码
    ,pay_agt_id varchar2(150) -- 付款账户
    ,rcv_agt_id varchar2(150) -- 收款账户
    ,txn_amt number(22,0) -- 交易金额
    ,etl_dt_ora varchar2(150) -- 数据日期
    ,menuid varchar2(150) -- 柜面菜单码
    ,eft_flag varchar2(150) -- 金融交易类型
    ,serv_flag varchar2(150) -- 业务交易类型
    ,acct_flag varchar2(150) -- 账户交易类型
    ,ca_flag varchar2(150) -- 现金交易类型
    ,bd_flag varchar2(150) -- 存取款交易类型
    ,start_tm varchar2(20) -- 交易开始时间
    ,end_tm varchar2(20) -- 交易结束时间
    ,role_name varchar2(45) -- 经办柜员岗位
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_view_old_business_volume to ${iml_schema};
grant select on ${iol_schema}.bdms_view_old_business_volume to ${icl_schema};
grant select on ${iol_schema}.bdms_view_old_business_volume to ${idl_schema};
grant select on ${iol_schema}.bdms_view_old_business_volume to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_view_old_business_volume is '纸票业务交易量';
comment on column ${iol_schema}.bdms_view_old_business_volume.txn_dt is '交易日期';
comment on column ${iol_schema}.bdms_view_old_business_volume.txn_tm is '交易时间';
comment on column ${iol_schema}.bdms_view_old_business_volume.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.bdms_view_old_business_volume.oper_teller_id is '经办柜员编号';
comment on column ${iol_schema}.bdms_view_old_business_volume.oper_teller_name is '经办柜员名称';
comment on column ${iol_schema}.bdms_view_old_business_volume.auth_teller_id is '授权柜员编号';
comment on column ${iol_schema}.bdms_view_old_business_volume.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.bdms_view_old_business_volume.txn_num is '交易码';
comment on column ${iol_schema}.bdms_view_old_business_volume.txn_desc is '交易描述';
comment on column ${iol_schema}.bdms_view_old_business_volume.biz_sys_evt_id is '业务系统流水号';
comment on column ${iol_schema}.bdms_view_old_business_volume.bcs_evt_id is '核心系统流水号';
comment on column ${iol_schema}.bdms_view_old_business_volume.data_src_cd is '系统代码';
comment on column ${iol_schema}.bdms_view_old_business_volume.pay_agt_id is '付款账户';
comment on column ${iol_schema}.bdms_view_old_business_volume.rcv_agt_id is '收款账户';
comment on column ${iol_schema}.bdms_view_old_business_volume.txn_amt is '交易金额';
comment on column ${iol_schema}.bdms_view_old_business_volume.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.bdms_view_old_business_volume.menuid is '柜面菜单码';
comment on column ${iol_schema}.bdms_view_old_business_volume.eft_flag is '金融交易类型';
comment on column ${iol_schema}.bdms_view_old_business_volume.serv_flag is '业务交易类型';
comment on column ${iol_schema}.bdms_view_old_business_volume.acct_flag is '账户交易类型';
comment on column ${iol_schema}.bdms_view_old_business_volume.ca_flag is '现金交易类型';
comment on column ${iol_schema}.bdms_view_old_business_volume.bd_flag is '存取款交易类型';
comment on column ${iol_schema}.bdms_view_old_business_volume.start_tm is '交易开始时间';
comment on column ${iol_schema}.bdms_view_old_business_volume.end_tm is '交易结束时间';
comment on column ${iol_schema}.bdms_view_old_business_volume.role_name is '经办柜员岗位';
comment on column ${iol_schema}.bdms_view_old_business_volume.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_view_old_business_volume.etl_timestamp is 'ETL处理时间戳';
