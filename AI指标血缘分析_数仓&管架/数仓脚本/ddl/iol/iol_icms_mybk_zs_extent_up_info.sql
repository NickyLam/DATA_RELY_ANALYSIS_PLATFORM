/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_zs_extent_up_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_zs_extent_up_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_zs_extent_up_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_zs_extent_up_info(
    serialno varchar2(32) -- 流水号
    ,bankcardnumber varchar2(128) -- 银行卡号
    ,devstabilitygrade varchar2(8) -- 最近六个月设备稳定等级
    ,ovdorderamt6mgrade varchar2(8) -- 最近六个月逾期金额等级
    ,profession varchar2(128) -- 职业信息
    ,totpayamt6mgrade varchar2(8) -- 最近六个月支付金额等级
    ,ovdordercnt6mgrade varchar2(8) -- 最近六个月逾期笔数等级
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,repaymentseg varchar2(10) -- 偿债能力
    ,mobilefixedgrade varchar2(8) -- 手机号稳定等级
    ,last6mavgassettotalgrade varchar2(8) -- 最近六个月流动资产价值等级
    ,positivebizcnt1ygrade varchar2(8) -- 最近一年履约等级
    ,riskscore varchar2(8) -- 风险分数
    ,riskseg varchar2(10) -- 风险分层
    ,consumegrade varchar2(8) -- 消费档次
    ,depositbankname varchar2(128) -- 开户行名称
    ,adrstabilitygrade varchar2(8) -- 地址稳定等级
    ,havecarprobgrade varchar2(8) -- 有车概率等级
    ,firstloanlengthgrade varchar2(8) -- 信贷时长等级
    ,havefangprobgrade varchar2(8) -- 有房概率等级
    ,ovdorderdays6mgrade varchar2(8) -- 最近六个月逾期天数等级
    ,repayamt6mgrade varchar2(8) -- 最近六个月还款金额等级
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
grant select on ${iol_schema}.icms_mybk_zs_extent_up_info to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_up_info to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_up_info to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_zs_extent_up_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_zs_extent_up_info is '网商贷终审扩展升级信息';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.serialno is '流水号';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.bankcardnumber is '银行卡号';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.devstabilitygrade is '最近六个月设备稳定等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.ovdorderamt6mgrade is '最近六个月逾期金额等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.profession is '职业信息';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.totpayamt6mgrade is '最近六个月支付金额等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.ovdordercnt6mgrade is '最近六个月逾期笔数等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.repaymentseg is '偿债能力';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.mobilefixedgrade is '手机号稳定等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.last6mavgassettotalgrade is '最近六个月流动资产价值等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.positivebizcnt1ygrade is '最近一年履约等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.riskscore is '风险分数';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.riskseg is '风险分层';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.consumegrade is '消费档次';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.depositbankname is '开户行名称';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.adrstabilitygrade is '地址稳定等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.havecarprobgrade is '有车概率等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.firstloanlengthgrade is '信贷时长等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.havefangprobgrade is '有房概率等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.ovdorderdays6mgrade is '最近六个月逾期天数等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.repayamt6mgrade is '最近六个月还款金额等级';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_zs_extent_up_info.etl_timestamp is 'ETL处理时间戳';
