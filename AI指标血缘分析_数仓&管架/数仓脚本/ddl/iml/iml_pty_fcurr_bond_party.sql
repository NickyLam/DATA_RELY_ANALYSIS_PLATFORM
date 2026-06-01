/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_fcurr_bond_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_fcurr_bond_party
whenever sqlerror continue none;
drop table ${iml_schema}.pty_fcurr_bond_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fcurr_bond_party(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,super_party_id varchar2(100) -- 上级当事人编号
    ,dc_elec_cert_id varchar2(100) -- 本币电子证书编号
    ,status_cd varchar2(30) -- 状态代码
    ,lp_name varchar2(750) -- 法人名称
    ,tel_num varchar2(60) -- 电话号码
    ,fax_num varchar2(60) -- 传真号码
    ,cust_id varchar2(100) -- 客户编号
    ,intnal_crdt_rating_id varchar2(100) -- 内部信用评级编号
    ,intnal_crdt_rating_name varchar2(750) -- 内部信用评级名称
    ,ibank_no varchar2(100) -- 联行号
    ,lg_pay_sys_bank_no varchar2(100) -- 大额支付系统行号
    ,issuer_id varchar2(100) -- 发行人编号
    ,issuer_flg varchar2(30) -- 发行人标志
    ,fin_inst_flg varchar2(30) -- 金融机构标志
    ,guartor_flg varchar2(30) -- 担保人标志
    ,trust_org_flg varchar2(30) -- 托管机构标志
    ,dc_mem_cd varchar2(60) -- 本币会员代码
    ,mem_src_cd varchar2(30) -- 会员来源代码
    ,parent_corp_flg varchar2(30) -- 母公司标志
    ,parent_corp_group_id varchar2(100) -- 母公司群组编号
    ,org_id varchar2(100) -- 机构编号
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
grant select on ${iml_schema}.pty_fcurr_bond_party to ${icl_schema};
grant select on ${iml_schema}.pty_fcurr_bond_party to ${idl_schema};
grant select on ${iml_schema}.pty_fcurr_bond_party to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_fcurr_bond_party is '外币债当事人';
comment on column ${iml_schema}.pty_fcurr_bond_party.party_id is '当事人编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.lp_id is '法人编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.super_party_id is '上级当事人编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.dc_elec_cert_id is '本币电子证书编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.status_cd is '状态代码';
comment on column ${iml_schema}.pty_fcurr_bond_party.lp_name is '法人名称';
comment on column ${iml_schema}.pty_fcurr_bond_party.tel_num is '电话号码';
comment on column ${iml_schema}.pty_fcurr_bond_party.fax_num is '传真号码';
comment on column ${iml_schema}.pty_fcurr_bond_party.cust_id is '客户编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.intnal_crdt_rating_id is '内部信用评级编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.intnal_crdt_rating_name is '内部信用评级名称';
comment on column ${iml_schema}.pty_fcurr_bond_party.ibank_no is '联行号';
comment on column ${iml_schema}.pty_fcurr_bond_party.lg_pay_sys_bank_no is '大额支付系统行号';
comment on column ${iml_schema}.pty_fcurr_bond_party.issuer_id is '发行人编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.issuer_flg is '发行人标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.fin_inst_flg is '金融机构标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.guartor_flg is '担保人标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.trust_org_flg is '托管机构标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.dc_mem_cd is '本币会员代码';
comment on column ${iml_schema}.pty_fcurr_bond_party.mem_src_cd is '会员来源代码';
comment on column ${iml_schema}.pty_fcurr_bond_party.parent_corp_flg is '母公司标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.parent_corp_group_id is '母公司群组编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.org_id is '机构编号';
comment on column ${iml_schema}.pty_fcurr_bond_party.create_dt is '创建日期';
comment on column ${iml_schema}.pty_fcurr_bond_party.update_dt is '更新日期';
comment on column ${iml_schema}.pty_fcurr_bond_party.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_fcurr_bond_party.id_mark is '增删标志';
comment on column ${iml_schema}.pty_fcurr_bond_party.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_fcurr_bond_party.job_cd is '任务编码';
comment on column ${iml_schema}.pty_fcurr_bond_party.etl_timestamp is 'ETL处理时间戳';
