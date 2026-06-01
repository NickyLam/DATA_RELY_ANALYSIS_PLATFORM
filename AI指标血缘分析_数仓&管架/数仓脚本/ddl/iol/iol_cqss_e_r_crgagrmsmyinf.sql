/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_crgagrmsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_crgagrmsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_crgagrmsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_crgagrmsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,non_rcr_lmt_tot number(38,0) -- 非循环信用额度合计:eb040j01
    ,useds_non_rcr_lmt_tot number(38,0) -- 已使用的非循环信用额度合计:eb040j02
    ,srplsavlsnonrvllmttot number(38,0) -- 剩余可用的非循环额度合计:eb040j03
    ,rcr_lmt_tot number(38,0) -- 循环信用额度合计:eb040j04
    ,used_s_rcr_lmt_tot number(38,0) -- 已使用的循环信用额度合计:eb040j05
    ,srplsavls_rvl_lmt_tot number(38,0) -- 剩余可用的循环额度合计:eb040j06
    ,wthr_cntn_crg_qot varchar2(2) -- 是否包含授信限额:eb040d01
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
grant select on ${iol_schema}.cqss_e_r_crgagrmsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrmsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrmsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_crgagrmsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_crgagrmsmyinf is '授信协议汇总信息';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.non_rcr_lmt_tot is '非循环信用额度合计:eb040j01';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.useds_non_rcr_lmt_tot is '已使用的非循环信用额度合计:eb040j02';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.srplsavlsnonrvllmttot is '剩余可用的非循环额度合计:eb040j03';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.rcr_lmt_tot is '循环信用额度合计:eb040j04';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.used_s_rcr_lmt_tot is '已使用的循环信用额度合计:eb040j05';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.srplsavls_rvl_lmt_tot is '剩余可用的循环额度合计:eb040j06';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.wthr_cntn_crg_qot is '是否包含授信限额:eb040d01';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_crgagrmsmyinf.etl_timestamp is 'ETL处理时间戳';
