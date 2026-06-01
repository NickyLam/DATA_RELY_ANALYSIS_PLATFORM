/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ab_largecash_regi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ab_largecash_regi
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ab_largecash_regi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ab_largecash_regi(
    tid varchar2(64) -- 由柜员号+系统时间yyyymmddhhmmsssss+五位随机字母组成
    ,trantime timestamp -- 交易时间
    ,globalseqno varchar2(66) -- 全局流水号
    ,coreseqno varchar2(128) -- 核心流水
    ,acctna varchar2(160) -- 户名
    ,acctno varchar2(100) -- 卡号
    ,withdrawaluse varchar2(8) -- 款型来源（取款用途）
    ,description varchar2(480) -- 说明
    ,crcycd varchar2(20) -- 币种
    ,tranam number(20,2) -- 交易金额
    ,trandate date -- 交易日期
    ,updatedate date -- 修改日期
    ,brchno varchar2(24) -- 归属机构编号
    ,userid varchar2(16) -- 交易柜员编号
    ,upuserid varchar2(16) -- 修改柜员编号
    ,custtp varchar2(2) -- 客户类型 1 个人客户 2 企业客户
    ,servtp varchar2(12) -- 渠道编号
    ,resernumber varchar2(40) -- 大额取现预约号
    ,inducategory varchar2(12) -- 行业门类
    ,indubig varchar2(12) -- 行业大类
    ,indumedium varchar2(12) -- 行业中类
    ,indusmall varchar2(12) -- 行业小类
    ,businesstype varchar2(2) -- 业务类型（1-现金存款2-现金取款）
    ,savetoamsum number(20,2) -- 转存金额汇总
    ,spectp varchar2(2) -- 账户类型
    ,agnttg varchar2(2) -- 是否代办
    ,agidtp varchar2(8) -- 代办人证件类型
    ,agidno varchar2(120) -- 代办人证件号码
    ,agcuna varchar2(400) -- 代办人名称
    ,transq varchar2(66) -- 业务流水号
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
grant select on ${iol_schema}.nibs_ab_largecash_regi to ${iml_schema};
grant select on ${iol_schema}.nibs_ab_largecash_regi to ${icl_schema};
grant select on ${iol_schema}.nibs_ab_largecash_regi to ${idl_schema};
grant select on ${iol_schema}.nibs_ab_largecash_regi to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ab_largecash_regi is '大额现金取款登记表';
comment on column ${iol_schema}.nibs_ab_largecash_regi.tid is '由柜员号+系统时间yyyymmddhhmmsssss+五位随机字母组成';
comment on column ${iol_schema}.nibs_ab_largecash_regi.trantime is '交易时间';
comment on column ${iol_schema}.nibs_ab_largecash_regi.globalseqno is '全局流水号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.coreseqno is '核心流水';
comment on column ${iol_schema}.nibs_ab_largecash_regi.acctna is '户名';
comment on column ${iol_schema}.nibs_ab_largecash_regi.acctno is '卡号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.withdrawaluse is '款型来源（取款用途）';
comment on column ${iol_schema}.nibs_ab_largecash_regi.description is '说明';
comment on column ${iol_schema}.nibs_ab_largecash_regi.crcycd is '币种';
comment on column ${iol_schema}.nibs_ab_largecash_regi.tranam is '交易金额';
comment on column ${iol_schema}.nibs_ab_largecash_regi.trandate is '交易日期';
comment on column ${iol_schema}.nibs_ab_largecash_regi.updatedate is '修改日期';
comment on column ${iol_schema}.nibs_ab_largecash_regi.brchno is '归属机构编号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.userid is '交易柜员编号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.upuserid is '修改柜员编号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.custtp is '客户类型 1 个人客户 2 企业客户';
comment on column ${iol_schema}.nibs_ab_largecash_regi.servtp is '渠道编号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.resernumber is '大额取现预约号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.inducategory is '行业门类';
comment on column ${iol_schema}.nibs_ab_largecash_regi.indubig is '行业大类';
comment on column ${iol_schema}.nibs_ab_largecash_regi.indumedium is '行业中类';
comment on column ${iol_schema}.nibs_ab_largecash_regi.indusmall is '行业小类';
comment on column ${iol_schema}.nibs_ab_largecash_regi.businesstype is '业务类型（1-现金存款2-现金取款）';
comment on column ${iol_schema}.nibs_ab_largecash_regi.savetoamsum is '转存金额汇总';
comment on column ${iol_schema}.nibs_ab_largecash_regi.spectp is '账户类型';
comment on column ${iol_schema}.nibs_ab_largecash_regi.agnttg is '是否代办';
comment on column ${iol_schema}.nibs_ab_largecash_regi.agidtp is '代办人证件类型';
comment on column ${iol_schema}.nibs_ab_largecash_regi.agidno is '代办人证件号码';
comment on column ${iol_schema}.nibs_ab_largecash_regi.agcuna is '代办人名称';
comment on column ${iol_schema}.nibs_ab_largecash_regi.transq is '业务流水号';
comment on column ${iol_schema}.nibs_ab_largecash_regi.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ab_largecash_regi.etl_timestamp is 'ETL处理时间戳';
