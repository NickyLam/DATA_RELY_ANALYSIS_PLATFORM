/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_report_overdue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_report_overdue
whenever sqlerror continue none;
drop table ${iol_schema}.icms_report_overdue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_report_overdue(
    xh varchar2(200) -- 序号
    ,pcrq varchar2(32) -- 批次日期
    ,lb varchar2(1000) -- 类别
    ,bjylxzdyqts varchar2(32) -- 本金与利息最大逾期天数
    ,khmc varchar2(1000) -- 客户名称
    ,jbjg varchar2(1000) -- 经办机构
    ,ssjt varchar2(1000) -- 所属集团
    ,ywpz varchar2(1000) -- 业务品种
    ,zhye varchar2(64) -- 整户余额(单位：元)
    ,zhckye varchar2(64) -- 整户敞口余额(单位：元)
    ,yqywye varchar2(64) -- 逾期业务余额(单位：元)
    ,wjfl varchar2(1000) -- 五级分类
    ,yqqsr varchar2(32) -- 逾期起始日
    ,bjzdyqts varchar2(32) -- 本金最大逾期天数
    ,lxzdyqts varchar2(32) -- 利息最大逾期天数
    ,yqbjje varchar2(64) -- 逾期本金金额(单位：元)
    ,yqlxje varchar2(64) -- 逾期利息金额(单位：元)
    ,yswslx varchar2(64) -- 应收未收利息(单位：元)
    ,faxje varchar2(64) -- 复息金额(单位：元)
    ,fuxje varchar2(64) -- 罚息金额(单位：元)
    ,hj varchar2(64) -- 合计(单位：元)
    ,yqdqtrq varchar2(32) -- 逾期达7天日期
    ,yqdsltrq varchar2(32) -- 逾期达30天日期
    ,yqdjltrq varchar2(32) -- 逾期达90天日期
    ,yqdeqltrq varchar2(32) -- 逾期达270天日期
    ,yqdslltrq varchar2(32) -- 逾期达360天日期
    ,sjrq varchar2(32) -- 数据日期
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,ylcs1 varchar2(4000) -- 参数1
    ,ylcs2 varchar2(4000) -- 参数2
    ,ylcs3 varchar2(4000) -- 参数3
    ,ylcs4 varchar2(4000) -- 参数4
    ,ylcs5 varchar2(4000) -- 参数5
    ,ylcs6 varchar2(4000) -- 参数6
    ,ylcs7 varchar2(4000) -- 参数7
    ,ylcs8 varchar2(4000) -- 参数8
    ,ylcs9 varchar2(4000) -- 参数9
    ,ylcs10 varchar2(4000) -- 参数10
    ,ylcs11 varchar2(4000) -- 参数11
    ,ylcs12 varchar2(4000) -- 参数12
    ,ylcs13 varchar2(4000) -- 参数13
    ,ylcs14 varchar2(4000) -- 参数14
    ,ylcs15 varchar2(4000) -- 参数15
    ,ylcs16 varchar2(4000) -- 参数16
    ,ylcs17 varchar2(4000) -- 参数17
    ,ylcs18 varchar2(4000) -- 参数18
    ,ylcs19 varchar2(4000) -- 参数19
    ,ylcs20 varchar2(4000) -- 参数20
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
grant select on ${iol_schema}.icms_report_overdue to ${iml_schema};
grant select on ${iol_schema}.icms_report_overdue to ${icl_schema};
grant select on ${iol_schema}.icms_report_overdue to ${idl_schema};
grant select on ${iol_schema}.icms_report_overdue to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_report_overdue is '逾期报表';
comment on column ${iol_schema}.icms_report_overdue.xh is '序号';
comment on column ${iol_schema}.icms_report_overdue.pcrq is '批次日期';
comment on column ${iol_schema}.icms_report_overdue.lb is '类别';
comment on column ${iol_schema}.icms_report_overdue.bjylxzdyqts is '本金与利息最大逾期天数';
comment on column ${iol_schema}.icms_report_overdue.khmc is '客户名称';
comment on column ${iol_schema}.icms_report_overdue.jbjg is '经办机构';
comment on column ${iol_schema}.icms_report_overdue.ssjt is '所属集团';
comment on column ${iol_schema}.icms_report_overdue.ywpz is '业务品种';
comment on column ${iol_schema}.icms_report_overdue.zhye is '整户余额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.zhckye is '整户敞口余额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.yqywye is '逾期业务余额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.wjfl is '五级分类';
comment on column ${iol_schema}.icms_report_overdue.yqqsr is '逾期起始日';
comment on column ${iol_schema}.icms_report_overdue.bjzdyqts is '本金最大逾期天数';
comment on column ${iol_schema}.icms_report_overdue.lxzdyqts is '利息最大逾期天数';
comment on column ${iol_schema}.icms_report_overdue.yqbjje is '逾期本金金额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.yqlxje is '逾期利息金额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.yswslx is '应收未收利息(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.faxje is '复息金额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.fuxje is '罚息金额(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.hj is '合计(单位：元)';
comment on column ${iol_schema}.icms_report_overdue.yqdqtrq is '逾期达7天日期';
comment on column ${iol_schema}.icms_report_overdue.yqdsltrq is '逾期达30天日期';
comment on column ${iol_schema}.icms_report_overdue.yqdjltrq is '逾期达90天日期';
comment on column ${iol_schema}.icms_report_overdue.yqdeqltrq is '逾期达270天日期';
comment on column ${iol_schema}.icms_report_overdue.yqdslltrq is '逾期达360天日期';
comment on column ${iol_schema}.icms_report_overdue.sjrq is '数据日期';
comment on column ${iol_schema}.icms_report_overdue.inputuserid is '登记人';
comment on column ${iol_schema}.icms_report_overdue.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_report_overdue.inputdate is '登记日期';
comment on column ${iol_schema}.icms_report_overdue.ylcs1 is '参数1';
comment on column ${iol_schema}.icms_report_overdue.ylcs2 is '参数2';
comment on column ${iol_schema}.icms_report_overdue.ylcs3 is '参数3';
comment on column ${iol_schema}.icms_report_overdue.ylcs4 is '参数4';
comment on column ${iol_schema}.icms_report_overdue.ylcs5 is '参数5';
comment on column ${iol_schema}.icms_report_overdue.ylcs6 is '参数6';
comment on column ${iol_schema}.icms_report_overdue.ylcs7 is '参数7';
comment on column ${iol_schema}.icms_report_overdue.ylcs8 is '参数8';
comment on column ${iol_schema}.icms_report_overdue.ylcs9 is '参数9';
comment on column ${iol_schema}.icms_report_overdue.ylcs10 is '参数10';
comment on column ${iol_schema}.icms_report_overdue.ylcs11 is '参数11';
comment on column ${iol_schema}.icms_report_overdue.ylcs12 is '参数12';
comment on column ${iol_schema}.icms_report_overdue.ylcs13 is '参数13';
comment on column ${iol_schema}.icms_report_overdue.ylcs14 is '参数14';
comment on column ${iol_schema}.icms_report_overdue.ylcs15 is '参数15';
comment on column ${iol_schema}.icms_report_overdue.ylcs16 is '参数16';
comment on column ${iol_schema}.icms_report_overdue.ylcs17 is '参数17';
comment on column ${iol_schema}.icms_report_overdue.ylcs18 is '参数18';
comment on column ${iol_schema}.icms_report_overdue.ylcs19 is '参数19';
comment on column ${iol_schema}.icms_report_overdue.ylcs20 is '参数20';
comment on column ${iol_schema}.icms_report_overdue.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_report_overdue.etl_timestamp is 'ETL处理时间戳';
