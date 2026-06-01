/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_public_agent_rgst_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_public_agent_rgst_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_public_agent_rgst_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_public_agent_rgst_dtl(
    evt_id varchar2(250) -- 事件编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_name varchar2(500) -- 账户名称
    ,tran_cd varchar2(30) -- 交易码
    ,agent_evt_cate_id varchar2(100) -- 代办事件类别编号
    ,tran_amt number(30,2) -- 交易金额
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,bus_vouch_no varchar2(60) -- 业务凭证号码
    ,cust_id varchar2(100) -- 客户编号
    ,public_agent_name varchar2(500) -- 代办人名称
    ,public_agent_cust_id varchar2(100) -- 代办人客户编号
    ,public_agent_cert_no varchar2(60) -- 代办人证件号码
    ,public_agent_cert_type_cd varchar2(30) -- 代办人证件类型代码
    ,public_agent_licen_issue_autho_cty_rg_cd varchar2(30) -- 代办人发证机关国家和地区代码
    ,public_agent_cert_effect_dt date -- 代办人证件生效日期
    ,public_agent_cert_invalid_dt date -- 代办人证件失效日期
    ,public_agent_tel_num varchar2(60) -- 交易代办人联系电话
    ,agent_reason varchar2(500) -- 代办理由
    ,public_agent_rela varchar2(250) -- 代办人关系
    ,tran_tm timestamp -- 交易时间
    ,agent_vrif_emply_a_id varchar2(100) -- 代办核实员工A编号
    ,agent_vrif_emply_b_id varchar2(100) -- 代办核实员工B编号
    ,vrif_ps_tel_num varchar2(60) -- 被核实人电话号码
    ,vrif_tm timestamp -- 核实时间
    ,vrif_rest varchar2(250) -- 核实结果
    ,agent_idf_cd varchar2(30) -- 代理标识代码
    ,public_agent_flg varchar2(10) -- 代办人标志
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
grant select on ${iml_schema}.evt_public_agent_rgst_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_public_agent_rgst_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_public_agent_rgst_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_public_agent_rgst_dtl is '代办人登记明细';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.cust_acct_num is '客户账号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.sub_acct_num is '子账号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.acct_name is '账户名称';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_cd is '交易码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.agent_evt_cate_id is '代办事件类别编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.bus_vouch_no is '业务凭证号码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_name is '代办人名称';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_cust_id is '代办人客户编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_cert_no is '代办人证件号码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_cert_type_cd is '代办人证件类型代码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_licen_issue_autho_cty_rg_cd is '代办人发证机关国家和地区代码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_cert_effect_dt is '代办人证件生效日期';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_cert_invalid_dt is '代办人证件失效日期';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_tel_num is '交易代办人联系电话';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.agent_reason is '代办理由';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_rela is '代办人关系';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.agent_vrif_emply_a_id is '代办核实员工A编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.agent_vrif_emply_b_id is '代办核实员工B编号';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.vrif_ps_tel_num is '被核实人电话号码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.vrif_tm is '核实时间';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.vrif_rest is '核实结果';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.agent_idf_cd is '代理标识代码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.public_agent_flg is '代办人标志';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_public_agent_rgst_dtl.etl_timestamp is 'ETL处理时间戳';
