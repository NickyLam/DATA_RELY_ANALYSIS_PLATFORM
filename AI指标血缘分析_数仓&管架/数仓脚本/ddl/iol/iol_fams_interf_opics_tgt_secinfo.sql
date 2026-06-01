/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_interf_opics_tgt_secinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_interf_opics_tgt_secinfo
whenever sqlerror continue none;
drop table ${iol_schema}.fams_interf_opics_tgt_secinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_interf_opics_tgt_secinfo(
    secid varchar2(20) -- 债券代码
    ,couprate_8 number(18,8) -- 票面利率
    ,ratecode varchar2(7) -- 利率代码
    ,spreadrate_8 number(18,8) -- 附加固定利率
    ,ccy varchar2(50) -- 币种
    ,descr varchar2(210) -- 描述
    ,basis varchar2(50) -- 利息基本代码
    ,issuer varchar2(10) -- 发行者
    ,intpaycycle varchar2(4) -- 支付利息周期
    ,product varchar2(6) -- 产品
    ,prodtype varchar2(50) -- 业务类型
    ,ratebasic varchar2(50) -- 计息基础actual/actuala/aactual/365a/365actual/360a/360
    ,couponspecies varchar2(50) -- 息票品种贴现dis零息zco附息npv到期一次还本付息iam
    ,interestrate varchar2(50) -- 利率类型固定利率fi浮动利率fl
    ,issdate date -- 发行日
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,lstmntdate date -- 更新时间
    ,facevalue number(20,4) -- 面值
    ,issueprice number(20,4) -- 发行价格
    ,intpayrule varchar2(50) -- 利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d
    ,schecalrule varchar2(50) -- 付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd
    ,firstrateday date -- 首次付息日
    ,workdayrule varchar2(10) -- 营业日准则向后next向前last调整的向后adjust不调整un
    ,ratevaluetype varchar2(50) -- 基准利率生效方式付息后生效f当期生效d指定条件生效z
    ,ratevalueperiod varchar2(50) -- 利率生效时期:计息期有效q计息年度有效y
    ,ratevaluecdtn varchar2(50) -- 利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q
    ,ratevaluedays number(8) -- 生效条件时间差
    ,issueamt number(20,4) -- 发行总额
    ,sectype varchar2(6) -- 债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10
    ,effectflag varchar2(50) -- 有效标识
    ,sn varchar2(255) -- 
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
grant select on ${iol_schema}.fams_interf_opics_tgt_secinfo to ${iml_schema};
grant select on ${iol_schema}.fams_interf_opics_tgt_secinfo to ${icl_schema};
grant select on ${iol_schema}.fams_interf_opics_tgt_secinfo to ${idl_schema};
grant select on ${iol_schema}.fams_interf_opics_tgt_secinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_interf_opics_tgt_secinfo is 'OPICS债券基本信息表';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.secid is '债券代码';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.couprate_8 is '票面利率';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratecode is '利率代码';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.spreadrate_8 is '附加固定利率';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ccy is '币种';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.descr is '描述';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.basis is '利息基本代码';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.issuer is '发行者';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.intpaycycle is '支付利息周期';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.product is '产品';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.prodtype is '业务类型';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratebasic is '计息基础actual/actuala/aactual/365a/365actual/360a/360';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.couponspecies is '息票品种贴现dis零息zco附息npv到期一次还本付息iam';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.interestrate is '利率类型固定利率fi浮动利率fl';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.issdate is '发行日';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.vdate is '起息日';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.mdate is '到期日';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.lstmntdate is '更新时间';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.facevalue is '面值';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.issueprice is '发行价格';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.intpayrule is '利息分配方式(只针对固定利率债券)平均分配j按实际天数分配d';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.schecalrule is '付息生成规则(即付息计划推算方法)起息日向后vf到期日向前mb首次付息日fd';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.firstrateday is '首次付息日';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.workdayrule is '营业日准则向后next向前last调整的向后adjust不调整un';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratevaluetype is '基准利率生效方式付息后生效f当期生效d指定条件生效z';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratevalueperiod is '利率生效时期:计息期有效q计息年度有效y';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratevaluecdtn is '利率生效条件基准利率变动后固定间隔时间生效h付息前指定日期的有效基准利率q';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.ratevaluedays is '生效条件时间差';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.issueamt is '发行总额';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.sectype is '债券类型国债00政策性金融债01央行票据02普通金融债03普通企业债04公司债05中期06短期融资券07次级债票据08地方政府债券09资产支持证券10';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.effectflag is '有效标识';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.sn is '';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.start_dt is '开始时间';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.end_dt is '结束时间';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.id_mark is '增删标志';
comment on column ${iol_schema}.fams_interf_opics_tgt_secinfo.etl_timestamp is 'ETL处理时间戳';
