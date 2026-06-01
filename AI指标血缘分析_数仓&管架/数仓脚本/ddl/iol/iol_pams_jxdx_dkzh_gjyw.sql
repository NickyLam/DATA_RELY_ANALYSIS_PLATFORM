/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dkzh_gjyw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dkzh_gjyw
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dkzh_gjyw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkzh_gjyw(
    jxdxdh number(22,0) -- 贷款绩效对象代号
    ,zhdh varchar2(60) -- 账户代号
    ,zzh varchar2(150) -- 子账号
    ,jjh varchar2(150) -- 借据号
    ,pjh varchar2(150) -- 票据号
    ,cph varchar2(30) -- 产品号
    ,xyzbh varchar2(90) -- 信用证编号
    ,xyzdjbh varchar2(90) -- 信用证单据编号
    ,bz varchar2(5) -- 币种
    ,dkje number(25,4) -- 贷款金额
    ,zrmbhl number(15,7) -- 折人民币汇率
    ,bzjje number(30,4) -- 保证金金额
    ,cdje number(30,4) -- 存单金额
    ,ypbzjbl number(25,4) -- 押品保证金比例
    ,ypbzjblqj varchar2(15) -- 押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,ypbzjblqj1 varchar2(15) -- 一级福费廷对应信用证押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,tjrq number(22,0) -- 数据入库日期
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
grant select on ${iol_schema}.pams_jxdx_dkzh_gjyw to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh_gjyw to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh_gjyw to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzh_gjyw to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dkzh_gjyw is '绩效对象_贷款账户_国际业务';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.jxdxdh is '贷款绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.zzh is '子账号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.jjh is '借据号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.pjh is '票据号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.xyzbh is '信用证编号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.xyzdjbh is '信用证单据编号';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.dkje is '贷款金额';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.zrmbhl is '折人民币汇率';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.bzjje is '保证金金额';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.cdje is '存单金额';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.ypbzjbl is '押品保证金比例';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.ypbzjblqj is '押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.ypbzjblqj1 is '一级福费廷对应信用证押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.tjrq is '数据入库日期';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_dkzh_gjyw.etl_timestamp is 'ETL处理时间戳';
