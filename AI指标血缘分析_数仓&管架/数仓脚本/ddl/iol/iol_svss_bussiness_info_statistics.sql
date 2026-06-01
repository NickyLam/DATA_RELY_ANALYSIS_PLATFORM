/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svss_bussiness_info_statistics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svss_bussiness_info_statistics
whenever sqlerror continue none;
drop table ${iol_schema}.svss_bussiness_info_statistics purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_bussiness_info_statistics(
    id varchar2(48) -- ID
    ,txn_dt date -- 交易日期
    ,txn_tm varchar2(48) -- 交易时间
    ,blng_org_id varchar2(48) -- 所属机构编号
    ,oper_teller_id varchar2(48) -- 经办柜员编号
    ,oper_teller_name varchar2(150) -- 经办柜员名称
    ,auth_teller_id varchar2(30) -- 授权柜员编号
    ,auth_teller_name varchar2(150) -- 授权柜员名称
    ,txn_num number(22,0) -- 交易码
    ,txn_desc varchar2(768) -- 交易描述
    ,biz_sys_evt_id varchar2(48) -- 业务系统流水号
    ,bcs_evt_id varchar2(48) -- 核心系统流水号
    ,data_src_cd varchar2(6) -- 系统代码
    ,pay_agt_id varchar2(45) -- 付款账户
    ,rcv_agt_id varchar2(45) -- 收款账户
    ,txn_amt varchar2(150) -- 交易金额
    ,etl_dt_ora date -- 数据日期
    ,menuid varchar2(48) -- 柜面菜单码
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
grant select on ${iol_schema}.svss_bussiness_info_statistics to ${iml_schema};
grant select on ${iol_schema}.svss_bussiness_info_statistics to ${icl_schema};
grant select on ${iol_schema}.svss_bussiness_info_statistics to ${idl_schema};
grant select on ${iol_schema}.svss_bussiness_info_statistics to ${iel_schema};

-- comment
comment on table ${iol_schema}.svss_bussiness_info_statistics is '验印系统-业务量统计';
comment on column ${iol_schema}.svss_bussiness_info_statistics.id is 'ID';
comment on column ${iol_schema}.svss_bussiness_info_statistics.txn_dt is '交易日期';
comment on column ${iol_schema}.svss_bussiness_info_statistics.txn_tm is '交易时间';
comment on column ${iol_schema}.svss_bussiness_info_statistics.blng_org_id is '所属机构编号';
comment on column ${iol_schema}.svss_bussiness_info_statistics.oper_teller_id is '经办柜员编号';
comment on column ${iol_schema}.svss_bussiness_info_statistics.oper_teller_name is '经办柜员名称';
comment on column ${iol_schema}.svss_bussiness_info_statistics.auth_teller_id is '授权柜员编号';
comment on column ${iol_schema}.svss_bussiness_info_statistics.auth_teller_name is '授权柜员名称';
comment on column ${iol_schema}.svss_bussiness_info_statistics.txn_num is '交易码';
comment on column ${iol_schema}.svss_bussiness_info_statistics.txn_desc is '交易描述';
comment on column ${iol_schema}.svss_bussiness_info_statistics.biz_sys_evt_id is '业务系统流水号';
comment on column ${iol_schema}.svss_bussiness_info_statistics.bcs_evt_id is '核心系统流水号';
comment on column ${iol_schema}.svss_bussiness_info_statistics.data_src_cd is '系统代码';
comment on column ${iol_schema}.svss_bussiness_info_statistics.pay_agt_id is '付款账户';
comment on column ${iol_schema}.svss_bussiness_info_statistics.rcv_agt_id is '收款账户';
comment on column ${iol_schema}.svss_bussiness_info_statistics.txn_amt is '交易金额';
comment on column ${iol_schema}.svss_bussiness_info_statistics.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.svss_bussiness_info_statistics.menuid is '柜面菜单码';
comment on column ${iol_schema}.svss_bussiness_info_statistics.start_dt is '开始时间';
comment on column ${iol_schema}.svss_bussiness_info_statistics.end_dt is '结束时间';
comment on column ${iol_schema}.svss_bussiness_info_statistics.id_mark is '增删标志';
comment on column ${iol_schema}.svss_bussiness_info_statistics.etl_timestamp is 'ETL处理时间戳';
