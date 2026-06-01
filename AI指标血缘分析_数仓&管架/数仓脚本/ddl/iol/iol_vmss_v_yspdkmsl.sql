/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol vmss_v_yspdkmsl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.vmss_v_yspdkmsl
whenever sqlerror continue none;
drop table ${iol_schema}.vmss_v_yspdkmsl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.vmss_v_yspdkmsl(
    tssid number(20) -- 主键
    ,kmdm varchar2(72) -- 科目代码
    ,kmmc varchar2(256) -- 科目名称
    ,qsfx varchar2(512) -- 取数方向
    ,jsff varchar2(512) -- 征税方法
    ,zsxm varchar2(512) -- 征税项目
    ,sl number(8,4) -- 税率
    ,jzjt varchar2(50) -- 即征即退
    ,sfyz varchar2(50) -- 是否预征
    ,qslx varchar2(512) -- 取数类型
    ,remark varchar2(20) -- 对方科目
    ,jym varchar2(60) -- 交易码
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
grant select on ${iol_schema}.vmss_v_yspdkmsl to ${iml_schema};
grant select on ${iol_schema}.vmss_v_yspdkmsl to ${icl_schema};
grant select on ${iol_schema}.vmss_v_yspdkmsl to ${idl_schema};
grant select on ${iol_schema}.vmss_v_yspdkmsl to ${iel_schema};

-- comment
comment on table ${iol_schema}.vmss_v_yspdkmsl is '增值税科目税率表';
comment on column ${iol_schema}.vmss_v_yspdkmsl.tssid is '主键';
comment on column ${iol_schema}.vmss_v_yspdkmsl.kmdm is '科目代码';
comment on column ${iol_schema}.vmss_v_yspdkmsl.kmmc is '科目名称';
comment on column ${iol_schema}.vmss_v_yspdkmsl.qsfx is '取数方向';
comment on column ${iol_schema}.vmss_v_yspdkmsl.jsff is '征税方法';
comment on column ${iol_schema}.vmss_v_yspdkmsl.zsxm is '征税项目';
comment on column ${iol_schema}.vmss_v_yspdkmsl.sl is '税率';
comment on column ${iol_schema}.vmss_v_yspdkmsl.jzjt is '即征即退';
comment on column ${iol_schema}.vmss_v_yspdkmsl.sfyz is '是否预征';
comment on column ${iol_schema}.vmss_v_yspdkmsl.qslx is '取数类型';
comment on column ${iol_schema}.vmss_v_yspdkmsl.remark is '对方科目';
comment on column ${iol_schema}.vmss_v_yspdkmsl.jym is '交易码';
comment on column ${iol_schema}.vmss_v_yspdkmsl.start_dt is '开始时间';
comment on column ${iol_schema}.vmss_v_yspdkmsl.end_dt is '结束时间';
comment on column ${iol_schema}.vmss_v_yspdkmsl.id_mark is '增删标志';
comment on column ${iol_schema}.vmss_v_yspdkmsl.etl_timestamp is 'ETL处理时间戳';
