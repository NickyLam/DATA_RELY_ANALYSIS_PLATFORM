/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_v_yiy_woklod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_v_yiy_woklod
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_v_yiy_woklod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_yiy_woklod(
    trninr varchar2(12) -- 交易流水号
    ,txn_dt date -- 交易日期
    ,txn_tm varchar2(12) -- 交易时间
    ,blng_org_id varchar2(12) -- 所属机构编号
    ,oper_teller_id varchar2(12) -- 经办柜员编号
    ,oper_teller_name varchar2(60) -- 经办柜员名称
    ,auth_teller_id varchar2(12) -- 授权柜员编号
    ,auth_teller_name varchar2(60) -- 授权柜员名称
    ,txn_num varchar2(9) -- 交易码
    ,txn_desc varchar2(120) -- 交易描述
    ,biz_sys_evt_id varchar2(12) -- 业务系统流水号
    ,bcs_evt_id varchar2(12) -- 核心系统流水号
    ,data_src_cd varchar2(5) -- 系统代码
    ,pay_agt_id varchar2(53) -- 付款账户
    ,rcv_agt_id varchar2(53) -- 收款账户
    ,txn_amt number(18,3) -- 交易金额
    ,etl_dt_ora date -- 数据日期
    ,menuid varchar2(9) -- 柜面菜单码
    ,serv_flag varchar2(3) -- 业务交易类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_v_yiy_woklod to ${iml_schema};
grant select on ${iol_schema}.isbs_v_yiy_woklod to ${icl_schema};
grant select on ${iol_schema}.isbs_v_yiy_woklod to ${idl_schema};
grant select on ${iol_schema}.isbs_v_yiy_woklod to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_v_yiy_woklod is '业务量统计';
comment on column ${iol_schema}.isbs_v_yiy_woklod.trninr is '交易流水号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.txn_dt is '交易日期';
comment on column ${iol_schema}.isbs_v_yiy_woklod.txn_tm is '交易时间';
comment on column ${iol_schema}.isbs_v_yiy_woklod.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.oper_teller_id is '经办柜员编号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.oper_teller_name is '经办柜员名称';
comment on column ${iol_schema}.isbs_v_yiy_woklod.auth_teller_id is '授权柜员编号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.isbs_v_yiy_woklod.txn_num is '交易码';
comment on column ${iol_schema}.isbs_v_yiy_woklod.txn_desc is '交易描述';
comment on column ${iol_schema}.isbs_v_yiy_woklod.biz_sys_evt_id is '业务系统流水号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.bcs_evt_id is '核心系统流水号';
comment on column ${iol_schema}.isbs_v_yiy_woklod.data_src_cd is '系统代码';
comment on column ${iol_schema}.isbs_v_yiy_woklod.pay_agt_id is '付款账户';
comment on column ${iol_schema}.isbs_v_yiy_woklod.rcv_agt_id is '收款账户';
comment on column ${iol_schema}.isbs_v_yiy_woklod.txn_amt is '交易金额';
comment on column ${iol_schema}.isbs_v_yiy_woklod.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.isbs_v_yiy_woklod.menuid is '柜面菜单码';
comment on column ${iol_schema}.isbs_v_yiy_woklod.serv_flag is '业务交易类型';
comment on column ${iol_schema}.isbs_v_yiy_woklod.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_v_yiy_woklod.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_v_yiy_woklod.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_v_yiy_woklod.etl_timestamp is 'ETL处理时间戳';
