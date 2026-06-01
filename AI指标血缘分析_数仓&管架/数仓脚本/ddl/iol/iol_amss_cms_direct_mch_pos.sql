/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_direct_mch_pos
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_direct_mch_pos
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_direct_mch_pos purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_direct_mch_pos(
    id number(10,0) -- 
    ,term_no varchar2(16) -- 终端号
    ,js_no varchar2(32) -- 机身号
    ,term_type varchar2(16) -- 终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端
    ,use_city varchar2(16) -- 使用地域，城市编码
    ,term_sn varchar2(64) -- 终端序列号/SN号
    ,product_no varchar2(128) -- 产品型号
    ,producer varchar2(256) -- 生产商
    ,term_address varchar2(256) -- 终端地址
    ,term_status varchar2(22) -- 终端状态：1-启用，2-冻结，3-注销
    ,term_secret varchar2(1024) -- 终端密钥
    ,union_partner varchar2(32) -- 银联商户号
    ,mch_no varchar2(32) -- 商户号
    ,mch_nm varchar2(128) -- 商户名称
    ,channel_id varchar2(32) -- 绑定机构号
    ,aff_channel varchar2(32) -- 所属机构号
    ,channel_nm varchar2(128) -- 绑定机构名称
    ,physics_flag number(4,0) -- 
    ,create_time timestamp -- 
    ,create_user number(10,0) -- 
    ,create_emp varchar2(32) -- 
    ,update_user number(10,0) -- 
    ,update_time timestamp -- 
    ,update_emp varchar2(32) -- 
    ,use_region_code varchar2(32) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amss_cms_direct_mch_pos to ${iml_schema};
grant select on ${iol_schema}.amss_cms_direct_mch_pos to ${icl_schema};
grant select on ${iol_schema}.amss_cms_direct_mch_pos to ${idl_schema};
grant select on ${iol_schema}.amss_cms_direct_mch_pos to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_direct_mch_pos is '直连POS设备表';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.id is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_no is '终端号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.js_no is '机身号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_type is '终端类型：00-POS、01-MIS、15-智能POS、18-mPOS、19-人脸识别终端、22-行业终端、23-非接扫码枪终端、24-非接扫码盒终端、25-手机POS终端';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.use_city is '使用地域，城市编码';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_sn is '终端序列号/SN号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.product_no is '产品型号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.producer is '生产商';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_address is '终端地址';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_status is '终端状态：1-启用，2-冻结，3-注销';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.term_secret is '终端密钥';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.union_partner is '银联商户号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.mch_no is '商户号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.mch_nm is '商户名称';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.channel_id is '绑定机构号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.aff_channel is '所属机构号';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.channel_nm is '绑定机构名称';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.physics_flag is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.create_time is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.create_user is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.create_emp is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.update_user is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.update_time is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.update_emp is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.use_region_code is '';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_direct_mch_pos.etl_timestamp is 'ETL处理时间戳';
