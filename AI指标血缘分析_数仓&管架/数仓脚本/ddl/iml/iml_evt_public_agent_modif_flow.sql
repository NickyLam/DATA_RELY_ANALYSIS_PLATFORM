/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_public_agent_modif_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_public_agent_modif_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_public_agent_modif_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_public_agent_modif_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,modif_flow_num varchar2(100) -- 修改流水号
    ,modif_dt date -- 修改日期
    ,unify_info_que_flow_num varchar2(100) -- 统一信息查询流水号
    ,init_tran_dt date -- 原交易日期
    ,init_tran_bus_flow_num varchar2(100) -- 原交易业务流水号
    ,init_tran_ova_flow_num varchar2(100) -- 原交易全局流水号
    ,blip_batch_no varchar2(500) -- 影像批次号
    ,agent_flg varchar2(10) -- 代办标志
    ,public_agent_type_cd varchar2(30) -- 代办人类型代码
    ,public_agent_name varchar2(500) -- 代办人名称
    ,agent_reason_descb varchar2(500) -- 代办理由描述
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,cont_num varchar2(60) -- 联系号码
    ,nation_cd varchar2(30) -- 国籍代码
    ,gender_cd varchar2(30) -- 性别代码
    ,career_cd_one varchar2(30) -- 职业代码一
    ,career_descb_one varchar2(500) -- 职业描述一
    ,career_cd_two varchar2(30) -- 职业代码二
    ,career_descb_two varchar2(500) -- 职业描述二
    ,career_dtl_comnt varchar2(500) -- 职业详细说明
    ,cont_addr_prov_cd varchar2(30) -- 联系地址-省级代码
    ,cont_addr_prov_name varchar2(500) -- 联系地址-省级名称
    ,cont_addr_city_cd varchar2(30) -- 联系地址-市级代码
    ,cont_addr_city_name varchar2(500) -- 联系地址-市级名称
    ,cont_addr_rg_cd varchar2(30) -- 联系地址-区级代码
    ,cont_addr_rg_name varchar2(500) -- 联系地址-区级名称
    ,cont_addr varchar2(500) -- 联系地址
    ,licen_issue_autho_addr varchar2(1000) -- 发证机关地址
    ,cert_start_dt date -- 证件开始日期
    ,cert_exp_dt date -- 证件到期日期
    ,netw_vrfction_flow_num varchar2(100) -- 联网核查流水号
    ,netw_vrfction_rest_cd varchar2(30) -- 联网核查结果代码
    ,netw_vrfction_rule_rest_cd varchar2(30) -- 联网核查手工审定结果代码
    ,face_recn_rest_cd varchar2(30) -- 人脸识别结果代码
    ,face_recn_score varchar2(10) -- 人脸识别分数
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
grant select on ${iml_schema}.evt_public_agent_modif_flow to ${icl_schema};
grant select on ${iml_schema}.evt_public_agent_modif_flow to ${idl_schema};
grant select on ${iml_schema}.evt_public_agent_modif_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_public_agent_modif_flow is '代办人信息修改登记流水';
comment on column ${iml_schema}.evt_public_agent_modif_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.modif_flow_num is '修改流水号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.modif_dt is '修改日期';
comment on column ${iml_schema}.evt_public_agent_modif_flow.unify_info_que_flow_num is '统一信息查询流水号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.evt_public_agent_modif_flow.init_tran_bus_flow_num is '原交易业务流水号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.init_tran_ova_flow_num is '原交易全局流水号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.blip_batch_no is '影像批次号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.agent_flg is '代办标志';
comment on column ${iml_schema}.evt_public_agent_modif_flow.public_agent_type_cd is '代办人类型代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.public_agent_name is '代办人名称';
comment on column ${iml_schema}.evt_public_agent_modif_flow.agent_reason_descb is '代办理由描述';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_num is '联系号码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.nation_cd is '国籍代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.gender_cd is '性别代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.career_cd_one is '职业代码一';
comment on column ${iml_schema}.evt_public_agent_modif_flow.career_descb_one is '职业描述一';
comment on column ${iml_schema}.evt_public_agent_modif_flow.career_cd_two is '职业代码二';
comment on column ${iml_schema}.evt_public_agent_modif_flow.career_descb_two is '职业描述二';
comment on column ${iml_schema}.evt_public_agent_modif_flow.career_dtl_comnt is '职业详细说明';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_prov_cd is '联系地址-省级代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_prov_name is '联系地址-省级名称';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_city_cd is '联系地址-市级代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_city_name is '联系地址-市级名称';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_rg_cd is '联系地址-区级代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr_rg_name is '联系地址-区级名称';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cont_addr is '联系地址';
comment on column ${iml_schema}.evt_public_agent_modif_flow.licen_issue_autho_addr is '发证机关地址';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cert_start_dt is '证件开始日期';
comment on column ${iml_schema}.evt_public_agent_modif_flow.cert_exp_dt is '证件到期日期';
comment on column ${iml_schema}.evt_public_agent_modif_flow.netw_vrfction_flow_num is '联网核查流水号';
comment on column ${iml_schema}.evt_public_agent_modif_flow.netw_vrfction_rest_cd is '联网核查结果代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.netw_vrfction_rule_rest_cd is '联网核查手工审定结果代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.face_recn_rest_cd is '人脸识别结果代码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.face_recn_score is '人脸识别分数';
comment on column ${iml_schema}.evt_public_agent_modif_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_public_agent_modif_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_public_agent_modif_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_public_agent_modif_flow.etl_timestamp is 'ETL处理时间戳';
