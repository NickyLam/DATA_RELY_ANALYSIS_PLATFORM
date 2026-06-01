/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_guaranteeslip
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_guaranteeslip
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_guaranteeslip purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_guaranteeslip(
    clrid varchar2(32) -- 押品编号
    ,guaranteeslipno varchar2(60) -- 保单号码
    ,issuercode varchar2(100) -- 发行人代码
    ,issuername varchar2(100) -- 发行人名称
    ,insurancekind varchar2(2) -- 保险险种
    ,startdate date -- 起始日期
    ,enddate date -- 截止日期
    ,yearlimit number(24,6) -- 已投保年限(年)
    ,insuranceamount number(24,6) -- 保险金额
    ,policyholder varchar2(100) -- 投保人名称
    ,beneficiary varchar2(100) -- 受益人名称
    ,cancelprice number(24,6) -- 解约退保价值
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_finance_guaranteeslip to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_guaranteeslip to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_guaranteeslip to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_guaranteeslip to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_guaranteeslip is '金融质押品之保单信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.guaranteeslipno is '保单号码';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.issuercode is '发行人代码';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.issuername is '发行人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.insurancekind is '保险险种';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.startdate is '起始日期';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.enddate is '截止日期';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.yearlimit is '已投保年限(年)';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.insuranceamount is '保险金额';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.policyholder is '投保人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.beneficiary is '受益人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.cancelprice is '解约退保价值';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_guaranteeslip.etl_timestamp is 'ETL处理时间戳';
