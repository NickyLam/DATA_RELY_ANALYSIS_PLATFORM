/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_cptys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_cptys
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_cptys purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_cptys(
    cptys_id number -- 交易对手ID
    ,aspclient_id number -- 部门ID
    ,cptys_shortname varchar2(384) -- 交易对手简称
    ,cptys_name varchar2(384) -- 交易对手全称
    ,cptys_name2 varchar2(384) -- 交易对手名称2
    ,name_src varchar2(30) -- 电子证书名称
    ,key_src varchar2(30) -- 数字证书号
    ,islink_src varchar2(2) -- 是否连接电子证书
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbolconfig_id number -- 数据源配置ID
    ,label varchar2(96) -- 其他系统代号
    ,rating_level number(2,0) -- 内部评级
    ,field1 varchar2(150) -- 扩展字段1
    ,field2 varchar2(150) -- 扩展字段2
    ,field3 varchar2(150) -- 扩展字段3
    ,counterparty_ename varchar2(384) -- 交易对手英文名称
    ,counterparty_short_ename varchar2(384) -- 交易对手英文简称
    ,contact_name varchar2(90) -- 联系人姓名
    ,telephone varchar2(30) -- 电话
    ,fax varchar2(30) -- 传真
    ,is_issuer varchar2(2) -- 是否是发行人
    ,is_bank varchar2(2) -- 是否是金融机构
    ,is_guarantee varchar2(2) -- 是否是担保人
    ,is_custody varchar2(2) -- 是否是托管机构
    ,customer_type_code varchar2(30) -- 行业类别code
    ,customer_type_name varchar2(90) -- 行业类别name
    ,parent number -- 母公司id
    ,ex_code varchar2(96) -- 电子联行号
    ,ex_account varchar2(96) -- 大额支付系统号
    ,swift_code varchar2(96) -- swift电文代号
    ,ref_issuer_id varchar2(60) -- 发行人/担保人ID
    ,issuer_name varchar2(96) -- 发行人/担保人中文名
    ,cfets_member_attr varchar2(384) -- 是否外汇会员
    ,master_short_cname varchar2(1500) -- 主机构中文短名
    ,master_cfets_id varchar2(150) -- 主机构本币会员id
    ,master_cnty_seq varchar2(17) -- 主机构系统交易对手编号
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
grant select on ${iol_schema}.ctms_tbs_vs_cptys to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_cptys to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_cptys to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_cptys to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_cptys is '交易对手视图';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.cptys_shortname is '交易对手简称';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.cptys_name is '交易对手全称';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.cptys_name2 is '交易对手名称2';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.name_src is '电子证书名称';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.key_src is '数字证书号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.islink_src is '是否连接电子证书';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.datasymbolconfig_id is '数据源配置ID';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.label is '其他系统代号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.rating_level is '内部评级';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.field1 is '扩展字段1';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.field2 is '扩展字段2';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.field3 is '扩展字段3';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.counterparty_ename is '交易对手英文名称';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.counterparty_short_ename is '交易对手英文简称';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.contact_name is '联系人姓名';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.telephone is '电话';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.fax is '传真';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.is_issuer is '是否是发行人';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.is_bank is '是否是金融机构';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.is_guarantee is '是否是担保人';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.is_custody is '是否是托管机构';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.customer_type_code is '行业类别code';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.customer_type_name is '行业类别name';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.parent is '母公司id';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.ex_code is '电子联行号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.ex_account is '大额支付系统号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.swift_code is 'swift电文代号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.ref_issuer_id is '发行人/担保人ID';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.issuer_name is '发行人/担保人中文名';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.cfets_member_attr is '是否外汇会员';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.master_short_cname is '主机构中文短名';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.master_cfets_id is '主机构本币会员id';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.master_cnty_seq is '主机构系统交易对手编号';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_cptys.etl_timestamp is 'ETL处理时间戳';
