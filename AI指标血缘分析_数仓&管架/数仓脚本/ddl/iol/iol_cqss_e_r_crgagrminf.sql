/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_crgagrminf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_crgagrminf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_crgagrminf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_crgagrminf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,crg_agrm_id varchar2(9) -- 授信协议编号:ed060i01
    ,inst_tp varchar2(45) -- 机构类型(业务管理机构类型):ed060d01
    ,mtit_ecd varchar2(192) -- 管理机构编码(业务管理机构代码):ed060i02
    ,entp_cr_crgln_tp varchar2(3) -- 授信额度类型:ed060d02
    ,lmt_rvl_ind varchar2(2) -- 额度循环标志:ed060d03
    ,ccycd varchar2(5) -- 币种代码(币种):ed060d04
    ,crgln number(38,0) -- 授信额度:ed060j01
    ,usd_lmt number(38,0) -- 已用额度:ed060j04
    ,crg_qot number(38,0) -- 授信限额:ed060j03
    ,crg_qot_id varchar2(9) -- 授信限额编号:ed060i03
    ,efdt date -- 生效日期:ed060r01
    ,crg_agrm_tmdt date -- 授信协议终止日期(终止日期):ed060r02
    ,infrpt_dt date -- 信息报告日期:ed060r03
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_e_r_crgagrminf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrminf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrminf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrminf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_crgagrminf is '授信协议信息';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crg_agrm_id is '授信协议编号:ed060i01';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.inst_tp is '机构类型(业务管理机构类型):ed060d01';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.mtit_ecd is '管理机构编码(业务管理机构代码):ed060i02';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.entp_cr_crgln_tp is '授信额度类型:ed060d02';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.lmt_rvl_ind is '额度循环标志:ed060d03';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.ccycd is '币种代码(币种):ed060d04';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crgln is '授信额度:ed060j01';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.usd_lmt is '已用额度:ed060j04';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crg_qot is '授信限额:ed060j03';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crg_qot_id is '授信限额编号:ed060i03';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.efdt is '生效日期:ed060r01';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crg_agrm_tmdt is '授信协议终止日期(终止日期):ed060r02';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.infrpt_dt is '信息报告日期:ed060r03';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_crgagrminf.etl_timestamp is 'ETL处理时间戳';
