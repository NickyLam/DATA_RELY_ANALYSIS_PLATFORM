/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_supv_acct_sign_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_supv_acct_sign_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_supv_acct_sign_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_supv_acct_sign_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sys_id varchar2(100) -- 系统编号
    ,supv_acct_id varchar2(100) -- 监管账户编号
    ,sign_dt date -- 签约日期
    ,supv_acct_name varchar2(750) -- 监管账户名称
    ,supv_status_cd varchar2(30) -- 监管状态代码
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,open_acct_dt date -- 开户日期
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,open_bank_name varchar2(750) -- 开户行名称
    ,proj_name varchar2(750) -- 项目名称
    ,corp_name varchar2(750) -- 单位名称
    ,cotas_name varchar2(750) -- 联系人名称
    ,cotas_tel varchar2(450) -- 联系人电话
    ,rels_dt date -- 解约日期
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,send_status_cd varchar2(30) -- 发送状态代码
    ,oper_rest_cd varchar2(30) -- 操作结果代码
    ,return_info_desc varchar2(750) -- 返回信息描述
    ,final_modif_tm timestamp -- 最后修改时间
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,check_org_id varchar2(100) -- 复核机构编号
    ,check_teller_id varchar2(100) -- 复核柜员编号
    ,auth_org_id varchar2(100) -- 授权机构编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,prpery_flow_num varchar2(100) -- 外围流水号
    ,sys_in_flow_num varchar2(100) -- 系统内流水号
    ,remark varchar2(750) -- 备注
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
grant select on ${iml_schema}.evt_supv_acct_sign_flow to ${icl_schema};
grant select on ${iml_schema}.evt_supv_acct_sign_flow to ${idl_schema};
grant select on ${iml_schema}.evt_supv_acct_sign_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_supv_acct_sign_flow is '监管账户签约流水';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.sys_id is '系统编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.supv_acct_id is '监管账户编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.sign_dt is '签约日期';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.supv_acct_name is '监管账户名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.supv_status_cd is '监管状态代码';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.open_acct_dt is '开户日期';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.open_bank_name is '开户行名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.proj_name is '项目名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.corp_name is '单位名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.cotas_name is '联系人名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.cotas_tel is '联系人电话';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.rels_dt is '解约日期';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.send_status_cd is '发送状态代码';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.oper_rest_cd is '操作结果代码';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.return_info_desc is '返回信息描述';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.final_modif_tm is '最后修改时间';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.check_org_id is '复核机构编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.check_teller_id is '复核柜员编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.auth_org_id is '授权机构编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.prpery_flow_num is '外围流水号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.sys_in_flow_num is '系统内流水号';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.remark is '备注';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_supv_acct_sign_flow.etl_timestamp is 'ETL处理时间戳';
