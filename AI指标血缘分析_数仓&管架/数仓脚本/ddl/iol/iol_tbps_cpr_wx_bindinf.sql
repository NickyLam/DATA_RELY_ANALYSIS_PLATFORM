/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_wx_bindinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_wx_bindinf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_wx_bindinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_wx_bindinf(
    cwb_openid varchar2(150) -- OPENID
    ,cwb_openacc varchar2(2) -- 公众号(2:公司微信公众号;1:交易银行微信)
    ,cwb_accno varchar2(48) -- 卡号/账号
    ,cwb_acctype varchar2(12) -- 账号类型(1:网银账户)
    ,cwb_userctftype varchar2(12) -- 证件类型
    ,cwb_userctfno varchar2(45) -- 证件号
    ,cwb_userno varchar2(60) -- 操作员ID(网银顺序号)
    ,cwb_username varchar2(90) -- 操作员姓名
    ,cwb_phone varchar2(17) -- 操作员电话
    ,cwb_cstno varchar2(45) -- 企业客户号(ECIF号)
    ,cwb_ctftype varchar2(15) -- 企业证件类型
    ,cwb_ctfno varchar2(60) -- 企业证件号
    ,cwb_bindstatus varchar2(2) -- 绑定状态（0失败 1正常 2未绑定 3异常）
    ,cwb_firsttime varchar2(21) -- 首次绑定时间
    ,cwb_updatetime varchar2(21) -- 更新时间
    ,cwb_channel varchar2(5) -- 渠道(GSW:公司微信公众号)
    ,cwb_remark1 varchar2(21) -- 预留字段1
    ,cwb_remark2 varchar2(75) -- 预留字段2
    ,cwb_remark3 varchar2(771) -- 预留字段3
    ,cwb_show varchar2(2) -- 切换显示 0:不显示，1:显示
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
grant select on ${iol_schema}.tbps_cpr_wx_bindinf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_wx_bindinf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_wx_bindinf to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_wx_bindinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_wx_bindinf is '公司微信用户注册表';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_openid is 'OPENID';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_openacc is '公众号(2:公司微信公众号;1:交易银行微信)';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_accno is '卡号/账号';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_acctype is '账号类型(1:网银账户)';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_userctftype is '证件类型';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_userctfno is '证件号';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_userno is '操作员ID(网银顺序号)';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_username is '操作员姓名';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_phone is '操作员电话';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_cstno is '企业客户号(ECIF号)';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_ctftype is '企业证件类型';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_ctfno is '企业证件号';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_bindstatus is '绑定状态（0失败 1正常 2未绑定 3异常）';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_firsttime is '首次绑定时间';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_updatetime is '更新时间';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_channel is '渠道(GSW:公司微信公众号)';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_remark1 is '预留字段1';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_remark2 is '预留字段2';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_remark3 is '预留字段3';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.cwb_show is '切换显示 0:不显示，1:显示';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbps_cpr_wx_bindinf.etl_timestamp is 'ETL处理时间戳';
