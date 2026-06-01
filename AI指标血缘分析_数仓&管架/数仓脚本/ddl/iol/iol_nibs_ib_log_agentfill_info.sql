/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_agentfill_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_agentfill_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_agentfill_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_agentfill_info(
    channeldate date -- 渠道日期
    ,chan_biz_seq_num varchar2(64) -- 渠道流水号
    ,tx_seq_num varchar2(33) -- 业务流水号
    ,orig_tx_seq_num varchar2(33) -- 原交易业务流水号（交易订单号）
    ,orig_core_tran_flow_num varchar2(33) -- 原交易全局流水号
    ,blip_id varchar2(255) -- 影像批次号
    ,isagent varchar2(2) -- 是否代办
    ,agent_person_name varchar2(200) -- 代办人名称
    ,agent_person_cert_type_cd varchar2(4) -- 代办人证件类型
    ,agent_person_cert_num varchar2(60) -- 代办人证件号码
    ,agent_person_tel_num varchar2(30) -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd varchar2(3) -- 代办人国籍
    ,agent_gender_cd varchar2(1) -- 代办人性别
    ,agent_career_typeone_code varchar2(10) -- 代办人职业-分类1代码
    ,agent_career_typeone varchar2(100) -- 代办人职业-分类1名称
    ,agent_career_typetwo_code varchar2(10) -- 代办人职业-分类2代码
    ,agent_career_typetwo varchar2(100) -- 代办人职业-分类2名称
    ,agent_career_cd varchar2(255) -- 代办人职业（详细说明）
    ,agent_person_provincecode varchar2(10) -- 代办人联系地址-省代码
    ,agent_person_province varchar2(100) -- 代办人联系地址-省名称
    ,agent_person_citycode varchar2(10) -- 代办人联系地址-市代码
    ,agent_person_city varchar2(100) -- 代办人联系地址-市名称
    ,agent_person_countycode varchar2(10) -- 代办人联系地址-区代码
    ,agent_person_county varchar2(100) -- 代办人联系地址-区名称
    ,agent_person_contact_adr varchar2(512) -- 代办人联系地址（详细地址）
    ,agent_person_auth_adr varchar2(512) -- 代办人发证机关地址
    ,agent_person_start_dt varchar2(8) -- 代办人证件开始日期
    ,agent_person_end_dt varchar2(8) -- 代办人证件到期日期
    ,agent_type varchar2(1) -- 代理人类型（1-普通代理；2-监护代理；3-经办人办理）
    ,agent_person_reason varchar2(256) -- 代办理由
    ,agent_person_networkchk_serno varchar2(36) -- 代办人联网核查流水号
    ,agent_person_networkchk_ret varchar2(4) -- 代办人联网核查结果
    ,agent_person_faceident_res varchar2(8) -- 代办人人脸识别结果
    ,agent_person_faceident_score varchar2(8) -- 代办人人脸识别分数
    ,agent_person_handchk_ret varchar2(3) -- 代办人手工审定结果 1-通过 2-强制通过 3-不通过
    ,note1 varchar2(100) -- 备用1
    ,note2 varchar2(200) -- 备用2
    ,orig_channeldate date -- 原交易渠道日期
    ,org_num varchar2(12) -- 机构编号
    ,teller_num varchar2(30) -- 柜员编号
    ,channeltime date -- 渠道时间
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
grant select on ${iol_schema}.nibs_ib_log_agentfill_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_agentfill_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_agentfill_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_agentfill_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_agentfill_info is '代理人补录登记簿';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.channeldate is '渠道日期';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.chan_biz_seq_num is '渠道流水号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.tx_seq_num is '业务流水号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.orig_tx_seq_num is '原交易业务流水号（交易订单号）';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.orig_core_tran_flow_num is '原交易全局流水号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.blip_id is '影像批次号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.isagent is '是否代办';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_name is '代办人名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_cert_type_cd is '代办人证件类型';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_cert_num is '代办人证件号码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_tel_num is '代办人手机号或代办人电话号码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_nation_cd is '代办人国籍';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_gender_cd is '代办人性别';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_career_typeone_code is '代办人职业-分类1代码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_career_typeone is '代办人职业-分类1名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_career_typetwo_code is '代办人职业-分类2代码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_career_typetwo is '代办人职业-分类2名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_career_cd is '代办人职业（详细说明）';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_provincecode is '代办人联系地址-省代码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_province is '代办人联系地址-省名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_citycode is '代办人联系地址-市代码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_city is '代办人联系地址-市名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_countycode is '代办人联系地址-区代码';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_county is '代办人联系地址-区名称';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_contact_adr is '代办人联系地址（详细地址）';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_auth_adr is '代办人发证机关地址';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_start_dt is '代办人证件开始日期';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_end_dt is '代办人证件到期日期';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_type is '代理人类型（1-普通代理；2-监护代理；3-经办人办理）';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_reason is '代办理由';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_networkchk_serno is '代办人联网核查流水号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_networkchk_ret is '代办人联网核查结果';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_faceident_res is '代办人人脸识别结果';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_faceident_score is '代办人人脸识别分数';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.agent_person_handchk_ret is '代办人手工审定结果 1-通过 2-强制通过 3-不通过';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.orig_channeldate is '原交易渠道日期';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.org_num is '机构编号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.teller_num is '柜员编号';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.channeltime is '渠道时间';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_agentfill_info.etl_timestamp is 'ETL处理时间戳';
