/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_ibank_cntpty_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_ibank_cntpty_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_ibank_cntpty_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_cntpty_info(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_party_id varchar2(60) -- 源当事人编号
    ,org_id varchar2(60) -- 机构编号
    ,super_org_id varchar2(60) -- 上级机构编号
    ,party_name varchar2(750) -- 当事人名称
    ,party_fname varchar2(750) -- 当事人全称
    ,party_alias varchar2(750) -- 当事人别名
    ,party_pinyin varchar2(750) -- 当事人拼音
    ,en_name varchar2(750) -- 英文名称
    ,en_fname varchar2(750) -- 英文全称
    ,status_cd varchar2(30) -- 状态代码
    ,found_dt date -- 成立日期
    ,bus_lics_num varchar2(60) -- 营业执照号码
    ,party_cd_cert_id varchar2(60) -- 当事人代码证编号
    ,fin_lics_id varchar2(60) -- 金融许可证编号
    ,dc_pay_sys_bank_no varchar2(60) -- 本币支付系统行号
    ,fcurr_pay_sys_bank_no varchar2(100) -- 外币支付系统行号
    ,rgst varchar2(150) -- 注册地
    ,party_cls_descb varchar2(375) -- 当事人分类描述
    ,party_type_cd varchar2(30) -- 当事人类型代码
    ,cust_id varchar2(60) -- 客户编号
    ,mar_maker_flg varchar2(30) -- 做市商标志
    ,spv_flg varchar2(30) -- SPV标志
    ,matn_org_id varchar2(60) -- 维护机构编号
    ,matn_org_name varchar2(750) -- 维护机构名称
    ,rwa_cust_cls_name varchar2(750) -- RWA客户分类名称
    ,org_cls_cd varchar2(30) -- 机构分类代码
    ,org_lev_cd varchar2(30) -- 机构级别代码
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
grant select on ${iml_schema}.pty_ibank_cntpty_info to ${icl_schema};
grant select on ${iml_schema}.pty_ibank_cntpty_info to ${idl_schema};
grant select on ${iml_schema}.pty_ibank_cntpty_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_ibank_cntpty_info is '同业交易对手信息';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.src_party_id is '源当事人编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.org_id is '机构编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.super_org_id is '上级机构编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_name is '当事人名称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_fname is '当事人全称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_alias is '当事人别名';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_pinyin is '当事人拼音';
comment on column ${iml_schema}.pty_ibank_cntpty_info.en_name is '英文名称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.en_fname is '英文全称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.status_cd is '状态代码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.found_dt is '成立日期';
comment on column ${iml_schema}.pty_ibank_cntpty_info.bus_lics_num is '营业执照号码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_cd_cert_id is '当事人代码证编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.fin_lics_id is '金融许可证编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.dc_pay_sys_bank_no is '本币支付系统行号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.fcurr_pay_sys_bank_no is '外币支付系统行号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.rgst is '注册地';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_cls_descb is '当事人分类描述';
comment on column ${iml_schema}.pty_ibank_cntpty_info.party_type_cd is '当事人类型代码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.cust_id is '客户编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.mar_maker_flg is '做市商标志';
comment on column ${iml_schema}.pty_ibank_cntpty_info.spv_flg is 'SPV标志';
comment on column ${iml_schema}.pty_ibank_cntpty_info.matn_org_id is '维护机构编号';
comment on column ${iml_schema}.pty_ibank_cntpty_info.matn_org_name is '维护机构名称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.rwa_cust_cls_name is 'RWA客户分类名称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.org_cls_cd is '机构分类代码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.org_lev_cd is '机构级别代码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.create_dt is '创建日期';
comment on column ${iml_schema}.pty_ibank_cntpty_info.update_dt is '更新日期';
comment on column ${iml_schema}.pty_ibank_cntpty_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_ibank_cntpty_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_ibank_cntpty_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_ibank_cntpty_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_ibank_cntpty_info.etl_timestamp is 'ETL处理时间戳';
