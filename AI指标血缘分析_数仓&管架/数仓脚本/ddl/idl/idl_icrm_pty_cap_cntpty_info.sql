/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_pty_cap_cntpty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_pty_cap_cntpty_info
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_pty_cap_cntpty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_pty_cap_cntpty_info(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,dept_id varchar2(60) -- 部门编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_abbr varchar2(500) -- 交易对手简称
    ,cntpty_fname varchar2(500) -- 交易对手全称
    ,cntpty_en_abbr varchar2(500) -- 交易对手英文简称
    ,cntpty_en_name varchar2(500) -- 交易对手英文名称
    ,elec_cert_name varchar2(100) -- 电子证书名称
    ,elec_cert_id varchar2(60) -- 电子证书编号
    ,elec_cert_flg varchar2(10) -- 电子证书标志
    ,intnal_rating_level_cd varchar2(10) -- 内部评级等级代码
    ,cotas_name varchar2(100) -- 联系人名称
    ,tel_num varchar2(60) -- 电话号码
    ,fax_num varchar2(60) -- 传真号码
    ,issuer_flg varchar2(10) -- 发行人标志
    ,issuer_id varchar2(60) -- 发行人编号
    ,guartor_flg varchar2(10) -- 担保人标志
    ,guartor_id varchar2(60) -- 担保人编号
    ,fin_inst_flg varchar2(10) -- 金融机构标志
    ,trust_org_flg varchar2(10) -- 托管机构标志
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,elec_ibank_no varchar2(60) -- 电子联行号
    ,pay_bk_bank_no varchar2(60) -- 支付行行号
    ,swift_id varchar2(30) -- SWIFT编号
    ,cust_id varchar2(100) -- 客户编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_pty_cap_cntpty_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_pty_cap_cntpty_info is '资金交易对手信息';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.dept_id is '部门编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cntpty_abbr is '交易对手简称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cntpty_fname is '交易对手全称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cntpty_en_abbr is '交易对手英文简称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cntpty_en_name is '交易对手英文名称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.elec_cert_name is '电子证书名称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.elec_cert_id is '电子证书编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.elec_cert_flg is '电子证书标志';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.intnal_rating_level_cd is '内部评级等级代码';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cotas_name is '联系人名称';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.tel_num is '电话号码';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.fax_num is '传真号码';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.issuer_flg is '发行人标志';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.issuer_id is '发行人编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.guartor_flg is '担保人标志';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.guartor_id is '担保人编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.fin_inst_flg is '金融机构标志';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.trust_org_flg is '托管机构标志';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.indus_type_cd is '行业类型代码';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.elec_ibank_no is '电子联行号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.pay_bk_bank_no is '支付行行号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.swift_id is 'SWIFT编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.cust_id is '客户编号';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_pty_cap_cntpty_info.etl_timestamp is '数据处理时间';
