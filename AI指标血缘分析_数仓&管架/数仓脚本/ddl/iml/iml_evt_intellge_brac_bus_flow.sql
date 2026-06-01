/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_intellge_brac_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_intellge_brac_bus_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_intellge_brac_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intellge_brac_bus_flow(
    evt_id varchar2(250) -- 事件编号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,lp_id varchar2(100) -- 法人编号
    ,chn_dt date -- 渠道日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,ups_flow_num varchar2(200) -- 上游流水号
    ,sys_flow_num varchar2(200) -- 系统流水号
    ,serv_flow_num varchar2(100) -- 服务流水号
    ,plat_flow_num varchar2(200) -- 平台流水号
    ,sorc_sys_id varchar2(100) -- 源系统编号
    ,chn_id varchar2(100) -- 渠道编号
    ,chn_tm timestamp -- 渠道时间
    ,chn_ip_addr varchar2(1000) -- 渠道IP地址
    ,chn_tran_code varchar2(100) -- 渠道交易编码
    ,chn_tran_name varchar2(500) -- 渠道交易名称
    ,tran_type_cd varchar2(200) -- 交易类型代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_org_name varchar2(500) -- 交易机构名称
    ,high_low_teller_flg varchar2(10) -- 高低柜标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_teller_name varchar2(500) -- 交易柜员姓名
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,auth_teller_name varchar2(500) -- 授权柜员姓名
    ,teller_belong_org_id varchar2(100) -- 柜员所属机构编号
    ,camp_emply_id varchar2(100) -- 营销员工编号
    ,auth_flow_num varchar2(200) -- 授权流水号
    ,auth_mode_cd varchar2(30) -- 授权模式代码
    ,long_flow_tran_flg varchar2(10) -- 长流程交易标志
    ,cust_type varchar2(30) -- 客户类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(200) -- 证件号码
    ,acct_id varchar2(100) -- 账户编号
    ,acct_num_name varchar2(500) -- 账号名称
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,cash_trans_flg varchar2(10) -- 现转标志
    ,cust_netw_vrfction_rest_cd varchar2(2500) -- 客户联网核查结果代码
    ,face_recn_rest_cd varchar2(30) -- 人脸识别结果代码
    ,face_recn_score number(10,2) -- 人脸识别分数
    ,cntpty_cate_cd varchar2(30) -- 交易对手类别代码
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,cntpty_cust_acct_num varchar2(200) -- 交易对手客户账号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,agent_flg varchar2(10) -- 代理标志
    ,agent_name varchar2(500) -- 代办人名称
    ,agent_cert_type_cd varchar2(30) -- 代办人证件类型代码
    ,agent_cert_no varchar2(200) -- 代办人证件号码
    ,agent_cont_num varchar2(60) -- 代办人联系号码
    ,agent_nation_cd varchar2(30) -- 代办人国籍代码
    ,agent_gender_cd varchar2(30) -- 代办人性别代码
    ,agent_career_cd varchar2(1000) -- 代办人职业代码
    ,agent_licen_issue_autho_addr varchar2(2000) -- 代办人发证机关地址
    ,agent_cont_addr varchar2(1500) -- 代办人联系地址
    ,agent_cert_start_dt date -- 代办人证件开始日期
    ,agent_cert_exp_dt date -- 交易代办人证件到期日期
    ,agent_netw_vrfction_rest_cd varchar2(30) -- 代办人联网核查结果代码
    ,agent_face_recn_rest_cd varchar2(30) -- 代办人人脸识别结果代码
    ,agent_face_recn_score number(10,2) -- 代办人人脸识别分数
    ,agent_rs_descb varchar2(1000) -- 代办原因描述
    ,vouch_matrl_qtty number(30) -- 凭证资料数量
    ,blend_way_cd varchar2(30) -- 勾兑方式代码
    ,blend_status_cd varchar2(30) -- 勾兑状态代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,tran_effect_dt date -- 交易开始时间
    ,tran_invalid_dt date -- 交易结束时间
    ,descb varchar2(1000) -- 描述
    ,bus_apv_flow_num varchar2(60) -- 业务审批流水号
    ,rela_bus_flow_num varchar2(200) -- 关联业务流水号
    ,high_risk_flg varchar2(30) -- 高风险标志
    ,manual_blend_flg varchar2(100) -- 手工勾兑标志
    ,spcs_turn_loc_flg varchar2(100) -- 后援中心转本地标志
    ,brch_init_appl_loc_flg varchar2(100) -- 分行主动申请本地标志
    ,spcs_appl_flg varchar2(100) -- 后援申请撤退标志
    ,blip_scene_code varchar2(100) -- 影像场景码
    ,blip_id varchar2(600) -- 影像编号
    ,app_num varchar2(100) -- 应用编号
    ,once_fin_serv_flg varchar2(10) -- 一次性金融服务标志
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
grant select on ${iml_schema}.evt_intellge_brac_bus_flow to ${icl_schema};
grant select on ${iml_schema}.evt_intellge_brac_bus_flow to ${idl_schema};
grant select on ${iml_schema}.evt_intellge_brac_bus_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_intellge_brac_bus_flow is '智能网点业务流水';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.ups_flow_num is '上游流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.serv_flow_num is '服务流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.plat_flow_num is '平台流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.sorc_sys_id is '源系统编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_tm is '渠道时间';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_ip_addr is '渠道IP地址';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_tran_code is '渠道交易编码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.chn_tran_name is '渠道交易名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_org_name is '交易机构名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.high_low_teller_flg is '高低柜标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_teller_name is '交易柜员姓名';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.auth_teller_name is '授权柜员姓名';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.teller_belong_org_id is '柜员所属机构编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.camp_emply_id is '营销员工编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.auth_flow_num is '授权流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.auth_mode_cd is '授权模式代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.long_flow_tran_flg is '长流程交易标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cust_type is '客户类型代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cert_no is '证件号码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.acct_num_name is '账号名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.debit_crdt_flg is '借贷标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cash_trans_flg is '现转标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cust_netw_vrfction_rest_cd is '客户联网核查结果代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.face_recn_rest_cd is '人脸识别结果代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.face_recn_score is '人脸识别分数';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cntpty_cate_cd is '交易对手类别代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cntpty_cust_acct_num is '交易对手客户账号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_flg is '代理标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_name is '代办人名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cert_type_cd is '代办人证件类型代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cert_no is '代办人证件号码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cont_num is '代办人联系号码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_nation_cd is '代办人国籍代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_gender_cd is '代办人性别代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_career_cd is '代办人职业代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_licen_issue_autho_addr is '代办人发证机关地址';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cont_addr is '代办人联系地址';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cert_start_dt is '代办人证件开始日期';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_cert_exp_dt is '交易代办人证件到期日期';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_netw_vrfction_rest_cd is '代办人联网核查结果代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_face_recn_rest_cd is '代办人人脸识别结果代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_face_recn_score is '代办人人脸识别分数';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.agent_rs_descb is '代办原因描述';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.vouch_matrl_qtty is '凭证资料数量';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.blend_way_cd is '勾兑方式代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.blend_status_cd is '勾兑状态代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_effect_dt is '交易开始时间';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.tran_invalid_dt is '交易结束时间';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.descb is '描述';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.bus_apv_flow_num is '业务审批流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.rela_bus_flow_num is '关联业务流水号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.high_risk_flg is '高风险标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.manual_blend_flg is '手工勾兑标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.spcs_turn_loc_flg is '后援中心转本地标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.brch_init_appl_loc_flg is '分行主动申请本地标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.spcs_appl_flg is '后援申请撤退标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.blip_scene_code is '影像场景码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.blip_id is '影像编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.app_num is '应用编号';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.once_fin_serv_flg is '一次性金融服务标志';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_intellge_brac_bus_flow.etl_timestamp is 'ETL处理时间戳';
