/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_cst_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_cst_inf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_cst_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_cst_inf(
    cif_ecifno varchar2(32) -- 全行统一客户号
    ,cif_ctftyp varchar2(4) -- 证件类型
    ,cif_ctfno varchar2(60) -- 证件号码
    ,cif_namecn varchar2(600) -- 客户名称（中文）
    ,cif_nameen varchar2(100) -- 客户名称(英文)
    ,cif_groupflag varchar2(1) -- 0：非集团客户，1：集团客户（默认为0）
    ,cif_custflag varchar2(1) -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
    ,cif_srclevel varchar2(1) -- 0：查询版，1：普通版（默认为:1）
    ,cif_address varchar2(600) -- 企业地址
    ,cif_feeaccount varchar2(38) -- 收费账号
    ,cif_feecurrency varchar2(3) -- 收费账号币种，默认“CNY”
    ,cif_zipcode varchar2(6) -- 邮政编码
    ,cif_phone varchar2(32) -- 电话
    ,cif_fax varchar2(32) -- 传真
    ,cif_email varchar2(50) -- Email
    ,cif_opentime varchar2(14) -- 开户时间
    ,cif_lastupdatetime varchar2(14) -- 最后更新时间
    ,cif_stt varchar2(1) -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
    ,cif_remark varchar2(255) -- 状态备注
    ,cif_orgid varchar2(60) -- 组织机构代码
    ,cif_legalname varchar2(120) -- 法人代表名称
    ,cif_legalcerttype varchar2(4) -- 法人证件类型
    ,cif_legalcertno varchar2(32) -- 法人证件号码
    ,cif_legalphone varchar2(30) -- 法人电话号码
    ,cif_rmcode varchar2(32) -- 客户经理编号
    ,cif_openbranch varchar2(20) -- 开户分行
    ,cif_opendept varchar2(20) -- 开户网点
    ,cif_businessnode varchar2(20) -- 业务归属网点
    ,cif_openteller varchar2(20) -- 开户操作员号
    ,cif_cashcontrolflag varchar2(1) -- 现金控制标识(默认为：0)
    ,cif_legalcardenddate varchar2(20) -- 法人证件到期日
    ,supplychainflag varchar2(1) -- 供应链系统标识
    ,cif_mobilebank_open varchar2(1) -- 签约银企通，1:是 0:否
    ,cif_mobilebank_opentime varchar2(14) -- 签约银企通时间
    ,cif_canceloatime varchar2(14) -- OA注销时间
    ,cif_oldaono varchar2(14) -- 原OA编号
    ,cif_expense_account varchar2(56) -- OA报销关联账户
    ,cif_cloudshield_open varchar2(1) -- 云盾开通标志(0:注销;1:开通)
    ,cif_cloudshield_opentime varchar2(14) -- 云盾开通时间
    ,cif_openchannel varchar2(5) -- 操作员新增渠道
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_cst_inf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_cst_inf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_cst_inf to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_cst_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_cst_inf is '企业信息表';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_ctftyp is '证件类型';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_ctfno is '证件号码';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_namecn is '客户名称（中文）';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_nameen is '客户名称(英文)';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_groupflag is '0：非集团客户，1：集团客户（默认为0）';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_custflag is '0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_srclevel is '0：查询版，1：普通版（默认为:1）';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_address is '企业地址';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_feeaccount is '收费账号';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_feecurrency is '收费账号币种，默认“CNY”';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_zipcode is '邮政编码';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_phone is '电话';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_fax is '传真';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_email is 'Email';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_opentime is '开户时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_lastupdatetime is '最后更新时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_stt is '0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_remark is '状态备注';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_orgid is '组织机构代码';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_legalname is '法人代表名称';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_legalcerttype is '法人证件类型';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_legalcertno is '法人证件号码';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_legalphone is '法人电话号码';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_rmcode is '客户经理编号';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_openbranch is '开户分行';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_opendept is '开户网点';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_businessnode is '业务归属网点';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_openteller is '开户操作员号';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_cashcontrolflag is '现金控制标识(默认为：0)';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_legalcardenddate is '法人证件到期日';
comment on column ${iol_schema}.tbps_cpr_cst_inf.supplychainflag is '供应链系统标识';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_mobilebank_open is '签约银企通，1:是 0:否';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_mobilebank_opentime is '签约银企通时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_canceloatime is 'OA注销时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_oldaono is '原OA编号';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_expense_account is 'OA报销关联账户';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_cloudshield_open is '云盾开通标志(0:注销;1:开通)';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_cloudshield_opentime is '云盾开通时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.cif_openchannel is '操作员新增渠道';
comment on column ${iol_schema}.tbps_cpr_cst_inf.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_cst_inf.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_cst_inf.etl_timestamp is 'ETL处理时间戳';
