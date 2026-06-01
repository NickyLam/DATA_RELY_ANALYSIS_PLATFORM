/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_business_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_business_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_business_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_business_log(
    tx_seq_num varchar2(66) -- 业务流水号(交易订单号)
    ,core_tran_flow_num varchar2(66) -- 全局流水号
    ,chan_biz_seq_num varchar2(120) -- 渠道方系统流水号
    ,p_biz_seq_num varchar2(128) -- 协同平台流水号
    ,backserialnum varchar2(128) -- 后台流水号
    ,custserialnum varchar2(70) -- 客户服务流水号
    ,sys_num varchar2(12) -- 系统编号
    ,app_num varchar2(12) -- 应用编号
    ,chan_num varchar2(12) -- 渠道编号
    ,channeldate date -- 渠道日期
    ,channeltime date -- 渠道时间
    ,channelip varchar2(800) -- 渠道ip
    ,channelmac varchar2(60) -- mac地址
    ,oidinfo varchar2(100) -- 交易终端编号
    ,channeltrancode varchar2(64) -- 渠道交易码
    ,channeltranname varchar2(400) -- 渠道交易名称
    ,channeltrantype varchar2(100) -- 交易类型
    ,tx_org_num varchar2(24) -- 交易机构编号
    ,tx_org_name varchar2(400) -- 交易机构名称
    ,teller_flag varchar2(4) -- 高低柜标识
    ,tx_teller_num varchar2(16) -- 交易柜员编号
    ,tx_teller_name varchar2(400) -- 柜员名称
    ,auth_tel_num varchar2(16) -- 授权柜员编号
    ,auth_tel_name varchar2(400) -- 授权柜员名称
    ,auth_flow_num varchar2(128) -- 授权流水号
    ,auth_mould varchar2(20) -- 授权模式
    ,islangtran varchar2(8) -- 是否长流程交易
    ,markworknum varchar2(60) -- 营销工号
    ,cust_type_cd varchar2(2) -- 客户类型
    ,cust_num varchar2(32) -- 客户编号
    ,cn_name varchar2(400) -- 客户名称
    ,cert_type_cd varchar2(8) -- 证件类型
    ,cert_num varchar2(120) -- 证件号码
    ,acct_num varchar2(100) -- 账户编号
    ,acct_name varchar2(400) -- 账号名称
    ,tx_curr_cd varchar2(6) -- 交易币种
    ,tx_amt number(20,2) -- 交易金额
    ,debit_crdt_ind varchar2(2) -- 借贷标志
    ,cash_trans_flg varchar2(2) -- 现转标志
    ,networkchkserno varchar2(72) -- 联网核查流水号
    ,networkchkresult varchar2(2048) -- 联网核查结果
    ,faceidentresult varchar2(16) -- 人脸识别结果
    ,faceidentscore varchar2(8) -- 人脸识别分数
    ,cntpty_type_cd varchar2(10) -- 交易对手类别
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,tx_cntpty_acct_num varchar2(100) -- 交易对手账号
    ,tx_cntpty_name varchar2(400) -- 交易对手名称
    ,isagent varchar2(4) -- 是否代理 0-否 1-是
    ,agent_person_name varchar2(400) -- 代办人名称
    ,agent_person_cert_type_cd varchar2(8) -- 代办人证件类型
    ,agent_person_cert_num varchar2(120) -- 代办人证件号码
    ,agent_person_tel_num varchar2(60) -- 代办人手机号或代办人电话号码
    ,agent_person_nation_cd varchar2(6) -- 代办人国籍
    ,agent_gender_cd varchar2(2) -- 代办人性别
    ,agent_career_typeone_code varchar2(20) -- 代办人职业-分类1代码
    ,agent_career_typetwo_code varchar2(20) -- 代办人职业-分类2代码
    ,agent_career_typeone varchar2(200) -- 代办人职业-分类1名称
    ,agent_career_typetwo varchar2(200) -- 代办人职业-分类2名称
    ,agent_career_cd varchar2(510) -- 代办人职业（详细说明）
    ,agent_person_provincecode varchar2(20) -- 代办人联系地址-省代码
    ,agent_person_citycode varchar2(20) -- 代办人联系地址-市代码
    ,agent_person_countycode varchar2(20) -- 代办人联系地址-区代码
    ,agent_person_province varchar2(200) -- 代办人联系地址-省名称
    ,agent_person_city varchar2(200) -- 代办人联系地址-市名称
    ,agent_person_county varchar2(200) -- 代办人联系地址-区名称
    ,agent_person_auth_adr varchar2(1024) -- 代办人发证机关地址
    ,agent_person_contact_adr varchar2(1024) -- 代办人联系地址（详细地址）
    ,agent_person_start_dt date -- 代办人证件开始日期
    ,agent_person_end_dt date -- 代办人证件到期日期
    ,agent_person_networkchk_serno varchar2(72) -- 代办人联网核查流水号
    ,agent_person_networkchk_ret varchar2(8) -- 代办人联网核查结果
    ,agent_person_faceident_res varchar2(8) -- 代办人人脸识别结果
    ,agent_person_faceident_score varchar2(8) -- 代办人人脸识别分数
    ,agent_person_reason varchar2(512) -- 代办理由
    ,vouchernum number(5) -- 凭证资料数量
    ,blendingstatu varchar2(2) -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，
    ,blendingtype varchar2(2) -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,p_workdate date -- 协同平台工作日期
    ,p_worktime date -- 协同平台工作时间
    ,transtate varchar2(4) -- 交易状态 s-成功 f-失败
    ,returncode varchar2(40) -- 返回码
    ,returndesc varchar2(1024) -- 返回描述
    ,remark varchar2(1000) -- 备注
    ,purpose varchar2(1000) -- 用途
    ,coredate date -- 核心日期
    ,apporveno varchar2(60) -- 业务审批单号
    ,reunique_seq_num varchar2(66) -- 关联业务流水号
    ,note1 varchar2(1024) -- 备用1
    ,keybusiness varchar2(20) -- 重点业务标识
    ,note2 varchar2(1024) -- 备用2
    ,blendingdesc varchar2(2048) -- 勾兑说明
    ,biz_scene varchar2(64) -- 影像场景码
    ,blip_id varchar2(510) -- 影像编号
    ,financeflag varchar2(2) -- 一次性金融服务标识|N-否 Y-是
    ,attachorgan varchar2(12) -- 柜员所属机构
    ,transtarttime date -- 交易开始时间
    ,tranendtime date -- 交易结束时间
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
grant select on ${iol_schema}.nibs_ib_log_business_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_business_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_business_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_business_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_business_log is '业务流水表';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.nibs_ib_log_business_log.core_tran_flow_num is '全局流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.chan_biz_seq_num is '渠道方系统流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.p_biz_seq_num is '协同平台流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.backserialnum is '后台流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.custserialnum is '客户服务流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.sys_num is '系统编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.app_num is '应用编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.chan_num is '渠道编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.channeldate is '渠道日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.channeltime is '渠道时间';
comment on column ${iol_schema}.nibs_ib_log_business_log.channelip is '渠道ip';
comment on column ${iol_schema}.nibs_ib_log_business_log.channelmac is 'mac地址';
comment on column ${iol_schema}.nibs_ib_log_business_log.oidinfo is '交易终端编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.channeltrancode is '渠道交易码';
comment on column ${iol_schema}.nibs_ib_log_business_log.channeltranname is '渠道交易名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.channeltrantype is '交易类型';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_org_num is '交易机构编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_org_name is '交易机构名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.teller_flag is '高低柜标识';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_teller_num is '交易柜员编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_teller_name is '柜员名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.auth_tel_num is '授权柜员编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.auth_tel_name is '授权柜员名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.auth_flow_num is '授权流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.auth_mould is '授权模式';
comment on column ${iol_schema}.nibs_ib_log_business_log.islangtran is '是否长流程交易';
comment on column ${iol_schema}.nibs_ib_log_business_log.markworknum is '营销工号';
comment on column ${iol_schema}.nibs_ib_log_business_log.cust_type_cd is '客户类型';
comment on column ${iol_schema}.nibs_ib_log_business_log.cust_num is '客户编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.cn_name is '客户名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.cert_type_cd is '证件类型';
comment on column ${iol_schema}.nibs_ib_log_business_log.cert_num is '证件号码';
comment on column ${iol_schema}.nibs_ib_log_business_log.acct_num is '账户编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.acct_name is '账号名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_curr_cd is '交易币种';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_amt is '交易金额';
comment on column ${iol_schema}.nibs_ib_log_business_log.debit_crdt_ind is '借贷标志';
comment on column ${iol_schema}.nibs_ib_log_business_log.cash_trans_flg is '现转标志';
comment on column ${iol_schema}.nibs_ib_log_business_log.networkchkserno is '联网核查流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.networkchkresult is '联网核查结果';
comment on column ${iol_schema}.nibs_ib_log_business_log.faceidentresult is '人脸识别结果';
comment on column ${iol_schema}.nibs_ib_log_business_log.faceidentscore is '人脸识别分数';
comment on column ${iol_schema}.nibs_ib_log_business_log.cntpty_type_cd is '交易对手类别';
comment on column ${iol_schema}.nibs_ib_log_business_log.cntpty_id is '交易对手编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_cntpty_acct_num is '交易对手账号';
comment on column ${iol_schema}.nibs_ib_log_business_log.tx_cntpty_name is '交易对手名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.isagent is '是否代理 0-否 1-是';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_name is '代办人名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_cert_type_cd is '代办人证件类型';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_cert_num is '代办人证件号码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_tel_num is '代办人手机号或代办人电话号码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_nation_cd is '代办人国籍';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_gender_cd is '代办人性别';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_career_typeone_code is '代办人职业-分类1代码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_career_typetwo_code is '代办人职业-分类2代码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_career_typeone is '代办人职业-分类1名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_career_typetwo is '代办人职业-分类2名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_career_cd is '代办人职业（详细说明）';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_provincecode is '代办人联系地址-省代码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_citycode is '代办人联系地址-市代码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_countycode is '代办人联系地址-区代码';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_province is '代办人联系地址-省名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_city is '代办人联系地址-市名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_county is '代办人联系地址-区名称';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_auth_adr is '代办人发证机关地址';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_contact_adr is '代办人联系地址（详细地址）';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_start_dt is '代办人证件开始日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_end_dt is '代办人证件到期日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_networkchk_serno is '代办人联网核查流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_networkchk_ret is '代办人联网核查结果';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_faceident_res is '代办人人脸识别结果';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_faceident_score is '代办人人脸识别分数';
comment on column ${iol_schema}.nibs_ib_log_business_log.agent_person_reason is '代办理由';
comment on column ${iol_schema}.nibs_ib_log_business_log.vouchernum is '凭证资料数量';
comment on column ${iol_schema}.nibs_ib_log_business_log.blendingstatu is '勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，';
comment on column ${iol_schema}.nibs_ib_log_business_log.blendingtype is '勾兑方式 0-手动，1-自动，2-手动+自动';
comment on column ${iol_schema}.nibs_ib_log_business_log.p_workdate is '协同平台工作日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.p_worktime is '协同平台工作时间';
comment on column ${iol_schema}.nibs_ib_log_business_log.transtate is '交易状态 s-成功 f-失败';
comment on column ${iol_schema}.nibs_ib_log_business_log.returncode is '返回码';
comment on column ${iol_schema}.nibs_ib_log_business_log.returndesc is '返回描述';
comment on column ${iol_schema}.nibs_ib_log_business_log.remark is '备注';
comment on column ${iol_schema}.nibs_ib_log_business_log.purpose is '用途';
comment on column ${iol_schema}.nibs_ib_log_business_log.coredate is '核心日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.apporveno is '业务审批单号';
comment on column ${iol_schema}.nibs_ib_log_business_log.reunique_seq_num is '关联业务流水号';
comment on column ${iol_schema}.nibs_ib_log_business_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_business_log.keybusiness is '重点业务标识';
comment on column ${iol_schema}.nibs_ib_log_business_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_business_log.blendingdesc is '勾兑说明';
comment on column ${iol_schema}.nibs_ib_log_business_log.biz_scene is '影像场景码';
comment on column ${iol_schema}.nibs_ib_log_business_log.blip_id is '影像编号';
comment on column ${iol_schema}.nibs_ib_log_business_log.financeflag is '一次性金融服务标识|N-否 Y-是';
comment on column ${iol_schema}.nibs_ib_log_business_log.attachorgan is '柜员所属机构';
comment on column ${iol_schema}.nibs_ib_log_business_log.transtarttime is '交易开始时间';
comment on column ${iol_schema}.nibs_ib_log_business_log.tranendtime is '交易结束时间';
comment on column ${iol_schema}.nibs_ib_log_business_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_business_log.etl_timestamp is 'ETL处理时间戳';
