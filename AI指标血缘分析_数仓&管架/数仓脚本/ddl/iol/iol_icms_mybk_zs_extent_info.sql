/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_zs_extent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_zs_extent_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_zs_extent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_zs_extent_info(
    serialno varchar2(32) -- 流水号
    ,adrstabilitydays varchar2(10) -- 地址稳定天数
    ,last6mavgassettotal varchar2(10) -- 最近六个月流动资产均值
    ,iszmfraudflag varchar2(10) -- 是否芝麻欺诈关注清单
    ,xfdcindex varchar2(10) -- 消费档次
    ,zmscore number(22) -- 芝麻评分
    ,migtflag varchar2(80) -- 
    ,repaymentseg varchar2(10) -- 偿债能力
    ,authfinlast6mcnt varchar2(10) -- 最近六个主动查询(芝麻信用)金融机构数
    ,ovdordercnt6m varchar2(10) -- 最近六个月逾期总笔数
    ,authfinlast1mcnt varchar2(10) -- 最近一个月主动查询(芝麻信用)金融机构数
    ,totpayamt6m varchar2(10) -- 最近六个支付总金额
    ,positivebizcnt1y varchar2(10) -- 最近一年履约场景数
    ,mobilefixeddays varchar2(10) -- 手机号稳定天数
    ,alilast6mtradetotal varchar2(10) -- 付宝交易笔数
    ,havecarflag varchar2(10) -- 是否有车
    ,profession varchar2(128) -- 职业信息
    ,iszmattentionflag varchar2(10) -- 是否芝麻行业关注名单
    ,authfinlast3mcnt varchar2(10) -- 最近三个主动查询(芝麻信用)金融机构数
    ,ovdorderamt6m varchar2(10) -- 最近六个月逾期总金额
    ,bankcardnumber varchar2(128) -- 银行卡号
    ,havefangflag varchar2(10) -- 是否有房
    ,depositbankname varchar2(128) -- 开户行名称
    ,riskseg varchar2(10) -- 风险分层
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
grant select on ${iol_schema}.icms_mybk_zs_extent_info to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_info to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_info to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_zs_extent_info is '网商贷终审扩展信息';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.serialno is '流水号';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.adrstabilitydays is '地址稳定天数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.last6mavgassettotal is '最近六个月流动资产均值';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.iszmfraudflag is '是否芝麻欺诈关注清单';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.xfdcindex is '消费档次';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.zmscore is '芝麻评分';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.migtflag is '';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.repaymentseg is '偿债能力';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.authfinlast6mcnt is '最近六个主动查询(芝麻信用)金融机构数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.ovdordercnt6m is '最近六个月逾期总笔数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.authfinlast1mcnt is '最近一个月主动查询(芝麻信用)金融机构数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.totpayamt6m is '最近六个支付总金额';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.positivebizcnt1y is '最近一年履约场景数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.mobilefixeddays is '手机号稳定天数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.alilast6mtradetotal is '付宝交易笔数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.havecarflag is '是否有车';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.profession is '职业信息';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.iszmattentionflag is '是否芝麻行业关注名单';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.authfinlast3mcnt is '最近三个主动查询(芝麻信用)金融机构数';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.ovdorderamt6m is '最近六个月逾期总金额';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.bankcardnumber is '银行卡号';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.havefangflag is '是否有房';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.depositbankname is '开户行名称';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.riskseg is '风险分层';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_zs_extent_info.etl_timestamp is 'ETL处理时间戳';
