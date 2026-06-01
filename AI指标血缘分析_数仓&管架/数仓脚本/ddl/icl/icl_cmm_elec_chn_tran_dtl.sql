/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_elec_chn_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_elec_chn_tran_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_elec_chn_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_elec_chn_tran_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(200) -- 交易流水号
    ,ova_chn_flow_num varchar2(100) -- 全局渠道流水号
    ,core_tran_flow_num varchar2(200) -- 核心交易流水号
    ,sorc_sys_flow_num varchar2(100) -- 源系统流水号
    ,osb_tran_flow_num varchar2(200) -- OSB交易流水号
    ,rela_timing_task_id varchar2(200) -- 关联定时任务编号
    ,chn_cd varchar2(60) -- 渠道编号
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(60) -- 交易时间
    ,core_tran_dt date -- 核心交易日期
    ,tran_type_code varchar2(250) -- 交易类型编码
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_return_code varchar2(250) -- 交易返回码
    ,tran_acct_id varchar2(200) -- 交易账户编号
    ,tran_acct_name varchar2(500) -- 交易账户名称
    ,tran_amt number(30,4) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,elec_chn_user_id varchar2(200) -- 电子渠道用户编号
    ,cust_id varchar2(200) -- 客户编号
    ,termn_ip_addr varchar2(500) -- 终端IP地址
    ,tran_comm_fee number(30,4) -- 交易手续费
    ,termn_mac_addr varchar2(500) -- 终端MAC地址
    ,termn_equip_model varchar2(200) -- 终端设备型号
    ,termn_equip_id varchar2(200) -- 终端设备编号
    ,cntpty_acct_id varchar2(60) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cntpty_acct_open_bank_num varchar2(60) -- 交易对手账户开户行号
    ,cntpty_acct_open_bank_name varchar2(500) -- 交易对手账户开户行名
    ,cntpty_acct_prov_cd varchar2(10) -- 交易对手账户省份代码
    ,cntpty_acct_city_cd varchar2(10) -- 交易对手账户城市代码
    ,memo_cd varchar2(60) -- 摘要代码
    ,memo_descb varchar2(500) -- 摘要描述
    ,tran_batch_no varchar2(60) -- 交易批次号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,camp_emply_id varchar2(60) -- 营销员工编号
    ,olbk_tran_src_cd varchar2(10) -- 网银交易来源代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_elec_chn_tran_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_elec_chn_tran_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_elec_chn_tran_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_elec_chn_tran_dtl is '电子渠道交易明细';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.ova_chn_flow_num is '全局渠道流水号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.core_tran_flow_num is '核心交易流水号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.sorc_sys_flow_num is '源系统流水号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.osb_tran_flow_num is 'OSB交易流水号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.rela_timing_task_id is '关联定时任务编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.chn_cd is '渠道编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_tm is '交易时间';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.core_tran_dt is '核心交易日期';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_type_code is '交易类型编码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_return_code is '交易返回码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_acct_name is '交易账户名称';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.elec_chn_user_id is '电子渠道用户编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.termn_ip_addr is '终端IP地址';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_comm_fee is '交易手续费';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.termn_mac_addr is '终端MAC地址';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.termn_equip_model is '终端设备型号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.termn_equip_id is '终端设备编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_id is '交易对手账户编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_name is '交易对手账户名称';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_open_bank_num is '交易对手账户开户行号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_open_bank_name is '交易对手账户开户行名';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_prov_cd is '交易对手账户省份代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.cntpty_acct_city_cd is '交易对手账户城市代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.memo_cd is '摘要代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.memo_descb is '摘要描述';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_batch_no is '交易批次号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.camp_emply_id is '营销员工编号';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.olbk_tran_src_cd is '网银交易来源代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_elec_chn_tran_dtl.etl_timestamp is 'ETL处理时间戳';
