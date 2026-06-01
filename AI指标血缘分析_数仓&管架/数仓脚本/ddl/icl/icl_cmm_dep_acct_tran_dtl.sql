/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_acct_tran_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_tran_dtl(
    init_sub_acct_id varchar2(10) -- 原子户编号
    ,etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,tran_timestamp timestamp(6) -- 交易时间戳
    ,init_tran_timestamp timestamp(6) -- 原交易时间戳
    ,acct_bill_flow_num varchar2(60) -- 账单流水号
    ,ova_flow_num varchar2(60) -- 全局流水号
    ,tran_flg_num varchar2(100) -- 交易标识号
    ,acct_org_id varchar2(60) -- 账户机构编号
    ,dep_sub_acct_id varchar2(60) -- 存款分户编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,sub_acct_id varchar2(60) -- 子户编号
    ,init_dep_sub_acct_id varchar2(60) -- 原分户编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,bus_prod_id varchar2(100) -- 业务产品编号
    ,tran_kind_cd varchar2(30) -- 交易种类代码
    ,elec_tran_kind_cd varchar2(20) -- 电子交易种类代码
    ,tran_status_cd varchar2(20) -- 交易状态代码
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,cash_proj_cd varchar2(10) -- 现金项目代码
    ,tran_vouch_id varchar2(60) -- 交易凭证编号
    ,vouch_kind_cd varchar2(10) -- 凭证种类代码
    ,memo_cd varchar2(10) -- 摘要代码
    ,memo_cd_descb varchar2(500) -- 摘要代码描述
    ,chn_cd varchar2(10) -- 渠道编号
    ,cntpty_inter_acct_id varchar2(60) -- 交易对手分户编号
    ,cntpty_acct_id varchar2(60) -- 交易对手账户编号
    ,cntpty_sub_acct_id varchar2(60) -- 交易对手子账户编号
    ,cntpty_acct_name varchar2(250) -- 交易对手账户名称
    ,cntpty_open_bank_id varchar2(60) -- 交易对手账户开户行编号
    ,cntpty_acct_open_bank_cd varchar2(60) -- 交易对手账户开户行代码
    ,cntpty_open_bank_name varchar2(250) -- 交易对手账户开户行名称
    ,real_cntpty_acct_id varchar2(60) -- 真实交易对手账户编号
    ,real_cntpty_acct_name varchar2(500) -- 真实交易对手账户名称
    ,real_cntpty_fin_inst_cd varchar2(60) -- 真实交易对手金融机构代码
    ,real_cntpty_fin_inst_name varchar2(500) -- 真实交易对手金融机构名称
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_curr_cd varchar2(10) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_bal number(30,2) -- 交易余额
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,entry_teller_id varchar2(60) -- 记帐柜员编号
    ,erase_acct_flg varchar2(10) -- 抹账标志
    ,revs_flg varchar2(10) -- 冲正标志
    ,cash_trans_flg varchar2(10) -- 现转标志
    ,unexp_draw_flg varchar2(10) -- 提前支取标志
    ,beps_unpasew_flg varchar2(10) -- 小额免密标志
    ,bal_chk_flg varchar2(10) -- 勾对标志
    ,cross_bor_tran_flg varchar2(10) -- 跨境交易标志
    ,termn_id varchar2(60) -- 终端编号
    ,tran_cd varchar2(20) -- 交易代码
    ,tran_descb varchar2(100) -- 交易描述
    ,rece_type_cd varchar2(10) -- 回单类型代码
    ,tran_name varchar2(100) -- 交易名称
    ,prpery_sys_code varchar2(200) -- 外围系统编码
    ,rece_id varchar2(60) -- 回单编号
    ,rece_descb_info varchar2(4000) -- 回单描述信息
    ,agent_cust_id varchar2(60) -- 代理人客户编号
    ,agent_name varchar2(400) -- 代理人名称
    ,agent_cert_type_cd varchar2(20) -- 代理人证件类型代码
    ,agent_cert_no varchar2(200) -- 代理人证件号码
    ,agent_gender_cd varchar2(10) -- 代理人性别代码
    ,agent_nation_cd varchar2(10) -- 代理人国籍代码
    ,agent_cert_start_dt date -- 代理人证件开始日
    ,agent_cert_exp_dt date -- 代理人证件到期日
    ,agent_phone varchar2(60) -- 代理人联系电话
    ,agent_licen_issue_autho_site varchar2(500) -- 代理人发证机关所在地
    ,agent_rs varchar2(1000) -- 代理原因
    ,agent_type_cd varchar2(10) -- 代理类型代码
    ,operr_cert_type_cd varchar2(10) -- 经办人证件类型代码
    ,operr_cert_no varchar2(60) -- 经办人证件号码
    ,operr_name varchar2(60) -- 经办人名称
    ,client_ip_addr varchar2(600) -- 交易IP地址
    ,cust_termn_mac_addr varchar2(60) -- 客户终端MAC地址
    ,entry_flg varchar2(10) -- 记账标志
    ,revs_tran_dt date -- 冲正交易日期
    ,revs_tran_flow_num varchar2(60) -- 冲正交易流水号
    ,revs_tran_code varchar2(10) -- 冲正交易码
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
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_acct_tran_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_acct_tran_dtl is '存款账户交易明细';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.init_sub_acct_id is '原子户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_timestamp is '交易时间戳';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.init_tran_timestamp is '原交易时间戳';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.acct_bill_flow_num is '账单流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.ova_flow_num is '全局流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_flg_num is '交易标识号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.acct_org_id is '账户机构编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.dep_sub_acct_id is '存款分户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.sub_acct_id is '子户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.init_dep_sub_acct_id is '原分户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.bus_prod_id is '业务产品编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_kind_cd is '交易种类代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.elec_tran_kind_cd is '电子交易种类代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cash_proj_cd is '现金项目代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_vouch_id is '交易凭证编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.vouch_kind_cd is '凭证种类代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.memo_cd is '摘要代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.memo_cd_descb is '摘要代码描述';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.chn_cd is '渠道编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_inter_acct_id is '交易对手分户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_acct_id is '交易对手账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_sub_acct_id is '交易对手子账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_acct_name is '交易对手账户名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_open_bank_id is '交易对手账户开户行编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_acct_open_bank_cd is '交易对手账户开户行代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cntpty_open_bank_name is '交易对手账户开户行名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.real_cntpty_acct_id is '真实交易对手账户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.real_cntpty_acct_name is '真实交易对手账户名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.real_cntpty_fin_inst_cd is '真实交易对手金融机构代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.real_cntpty_fin_inst_name is '真实交易对手金融机构名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_curr_cd is '交易币种代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_bal is '交易余额';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_teller_id is '交易柜员编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.check_teller_id is '复核柜员编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.auth_teller_id is '授权柜员编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.entry_teller_id is '记帐柜员编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.erase_acct_flg is '抹账标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.revs_flg is '冲正标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cash_trans_flg is '现转标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.unexp_draw_flg is '提前支取标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.beps_unpasew_flg is '小额免密标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.bal_chk_flg is '勾对标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cross_bor_tran_flg is '跨境交易标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.termn_id is '终端编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_cd is '交易代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_descb is '交易描述';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.rece_type_cd is '回单类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.tran_name is '交易名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.prpery_sys_code is '外围系统编码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.rece_id is '回单编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.rece_descb_info is '回单描述信息';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_cust_id is '代理人客户编号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_name is '代理人名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_cert_no is '代理人证件号码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_gender_cd is '代理人性别代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_nation_cd is '代理人国籍代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_cert_start_dt is '代理人证件开始日';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_cert_exp_dt is '代理人证件到期日';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_phone is '代理人联系电话';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_licen_issue_autho_site is '代理人发证机关所在地';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_rs is '代理原因';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.agent_type_cd is '代理类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.operr_cert_no is '经办人证件号码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.operr_name is '经办人名称';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.client_ip_addr is '交易IP地址';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.entry_flg is '记账标志';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.revs_tran_dt is '冲正交易日期';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.revs_tran_flow_num is '冲正交易流水号';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.revs_tran_code is '冲正交易码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_acct_tran_dtl.etl_timestamp is 'ETL处理时间戳';
