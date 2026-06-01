/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_crdt_org_way_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_crdt_org_way_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_crdt_org_way_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_crdt_org_way_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,bank_id varchar2(100) -- 银行编号
    ,bank_name varchar2(500) -- 银行名称
    ,bank_role_type_cd varchar2(30) -- 成员行银团角色类型代码
    ,agent_flg varchar2(10) -- 代理标志
    ,promis_loan_curr_cd varchar2(30) -- 承贷币种代码
    ,promis_loan_amt number(30,2) -- 承担贷款金额
    ,cotas_name varchar2(500) -- 联系人名称
    ,cont_mode_cd varchar2(30) -- 联系方式
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
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
grant select on ${iml_schema}.agt_loan_crdt_org_way_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_crdt_org_way_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_crdt_org_way_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_crdt_org_way_info_h is '贷款授信组织方式信息历史';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.ser_num is '序列号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.obj_id is '对象编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.bank_id is '成员行行号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.bank_name is '成员行行名';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.bank_role_type_cd is '成员行银团角色类型代码';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.agent_flg is '代理标志';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.promis_loan_curr_cd is '承贷币种代码';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.promis_loan_amt is '承担贷款金额';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.cont_mode_cd is '联系方式';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_crdt_org_way_info_h.etl_timestamp is 'ETL处理时间戳';
