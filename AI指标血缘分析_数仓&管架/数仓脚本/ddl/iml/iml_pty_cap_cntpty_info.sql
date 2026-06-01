/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cap_cntpty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cap_cntpty_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cap_cntpty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cap_cntpty_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,dept_id varchar2(60) -- 部门编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_abbr varchar2(750) -- 交易对手简称
    ,cntpty_fname varchar2(750) -- 交易对手全称
    ,cntpty_en_abbr varchar2(750) -- 交易对手英文简称
    ,cntpty_en_name varchar2(750) -- 交易对手英文名称
    ,elec_cert_name varchar2(150) -- 电子证书名称
    ,elec_cert_id varchar2(60) -- 电子证书编号
    ,elec_cert_flg varchar2(10) -- 电子证书标志
    ,intnal_rating_level_cd varchar2(10) -- 内部评级等级代码
    ,cotas_name varchar2(150) -- 联系人名称
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
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.pty_cap_cntpty_info to ${icl_schema};
grant select on ${iml_schema}.pty_cap_cntpty_info to ${idl_schema};
grant select on ${iml_schema}.pty_cap_cntpty_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cap_cntpty_info is '资金交易对手信息';
comment on column ${iml_schema}.pty_cap_cntpty_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.dept_id is '部门编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.cntpty_abbr is '交易对手简称';
comment on column ${iml_schema}.pty_cap_cntpty_info.cntpty_fname is '交易对手全称';
comment on column ${iml_schema}.pty_cap_cntpty_info.cntpty_en_abbr is '交易对手英文简称';
comment on column ${iml_schema}.pty_cap_cntpty_info.cntpty_en_name is '交易对手英文名称';
comment on column ${iml_schema}.pty_cap_cntpty_info.elec_cert_name is '电子证书名称';
comment on column ${iml_schema}.pty_cap_cntpty_info.elec_cert_id is '电子证书编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.elec_cert_flg is '电子证书标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.intnal_rating_level_cd is '内部评级等级代码';
comment on column ${iml_schema}.pty_cap_cntpty_info.cotas_name is '联系人名称';
comment on column ${iml_schema}.pty_cap_cntpty_info.tel_num is '电话号码';
comment on column ${iml_schema}.pty_cap_cntpty_info.fax_num is '传真号码';
comment on column ${iml_schema}.pty_cap_cntpty_info.issuer_flg is '发行人标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.issuer_id is '发行人编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.guartor_flg is '担保人标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.guartor_id is '担保人编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.fin_inst_flg is '金融机构标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.trust_org_flg is '托管机构标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.pty_cap_cntpty_info.elec_ibank_no is '电子联行号';
comment on column ${iml_schema}.pty_cap_cntpty_info.pay_bk_bank_no is '支付行行号';
comment on column ${iml_schema}.pty_cap_cntpty_info.swift_id is 'SWIFT编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.cust_id is '客户编号';
comment on column ${iml_schema}.pty_cap_cntpty_info.create_dt is '创建日期';
comment on column ${iml_schema}.pty_cap_cntpty_info.update_dt is '更新日期';
comment on column ${iml_schema}.pty_cap_cntpty_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_cap_cntpty_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_cap_cntpty_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cap_cntpty_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cap_cntpty_info.etl_timestamp is 'ETL处理时间戳';
