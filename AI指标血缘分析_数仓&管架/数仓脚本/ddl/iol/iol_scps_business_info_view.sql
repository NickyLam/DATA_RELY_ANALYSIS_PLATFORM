/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_business_info_view
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_business_info_view
whenever sqlerror continue none;
drop table ${iol_schema}.scps_business_info_view purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_business_info_view(
    txn_dt date -- 交易日期
    ,txn_tm varchar2(12) -- 交易时间
    ,blng_org_id varchar2(20) -- 所属机构编号
    ,oper_teller_id varchar2(20) -- 经办柜员编号
    ,oper_teller_name varchar2(200) -- 经办柜员名称
    ,auth_teller_id varchar2(128) -- 授权柜员编号
    ,auth_teller_name varchar2(200) -- 授权柜员名称
    ,txn_num varchar2(36) -- 交易码
    ,txn_desc varchar2(200) -- 交易描述
    ,biz_sys_evt_id varchar2(128) -- 业务系统流水号
    ,bcs_evt_id varchar2(66) -- 核心系统流水号
    ,data_src_cd varchar2(20) -- 系统代码
    ,pay_agt_id varchar2(100) -- 付款账户
    ,rcv_agt_id varchar2(100) -- 收款账户
    ,txm_amt varchar2(80) -- 交易金额
    ,etl_dt_ora date -- 数据日期
    ,menuid varchar2(36) -- 柜面菜单码
    ,eft_flag varchar2(2) -- 金融交易类型
    ,serv_flag varchar2(2) -- 业务交易类型
    ,acct_flag varchar2(2) -- 账户交易类型
    ,ca_flag varchar2(2) -- 现金交易类型
    ,bd_flag varchar2(1) -- 存取款交易类型
    ,inside_outside_flag varchar2(1) -- 行内外标识 1-内 2-外
    ,startdate varchar2(24) -- 授权开始时间
    ,enddate varchar2(24) -- 授权结束时间
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
grant select on ${iol_schema}.scps_business_info_view to ${iml_schema};
grant select on ${iol_schema}.scps_business_info_view to ${icl_schema};
grant select on ${iol_schema}.scps_business_info_view to ${idl_schema};
grant select on ${iol_schema}.scps_business_info_view to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_business_info_view is '营运管理业务量统计';
comment on column ${iol_schema}.scps_business_info_view.txn_dt is '交易日期';
comment on column ${iol_schema}.scps_business_info_view.txn_tm is '交易时间';
comment on column ${iol_schema}.scps_business_info_view.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.scps_business_info_view.oper_teller_id is '经办柜员编号';
comment on column ${iol_schema}.scps_business_info_view.oper_teller_name is '经办柜员名称';
comment on column ${iol_schema}.scps_business_info_view.auth_teller_id is '授权柜员编号';
comment on column ${iol_schema}.scps_business_info_view.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.scps_business_info_view.txn_num is '交易码';
comment on column ${iol_schema}.scps_business_info_view.txn_desc is '交易描述';
comment on column ${iol_schema}.scps_business_info_view.biz_sys_evt_id is '业务系统流水号';
comment on column ${iol_schema}.scps_business_info_view.bcs_evt_id is '核心系统流水号';
comment on column ${iol_schema}.scps_business_info_view.data_src_cd is '系统代码';
comment on column ${iol_schema}.scps_business_info_view.pay_agt_id is '付款账户';
comment on column ${iol_schema}.scps_business_info_view.rcv_agt_id is '收款账户';
comment on column ${iol_schema}.scps_business_info_view.txm_amt is '交易金额';
comment on column ${iol_schema}.scps_business_info_view.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.scps_business_info_view.menuid is '柜面菜单码';
comment on column ${iol_schema}.scps_business_info_view.eft_flag is '金融交易类型';
comment on column ${iol_schema}.scps_business_info_view.serv_flag is '业务交易类型';
comment on column ${iol_schema}.scps_business_info_view.acct_flag is '账户交易类型';
comment on column ${iol_schema}.scps_business_info_view.ca_flag is '现金交易类型';
comment on column ${iol_schema}.scps_business_info_view.bd_flag is '存取款交易类型';
comment on column ${iol_schema}.scps_business_info_view.inside_outside_flag is '行内外标识 1-内 2-外';
comment on column ${iol_schema}.scps_business_info_view.startdate is '授权开始时间';
comment on column ${iol_schema}.scps_business_info_view.enddate is '授权结束时间';
comment on column ${iol_schema}.scps_business_info_view.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scps_business_info_view.etl_timestamp is 'ETL处理时间戳';
