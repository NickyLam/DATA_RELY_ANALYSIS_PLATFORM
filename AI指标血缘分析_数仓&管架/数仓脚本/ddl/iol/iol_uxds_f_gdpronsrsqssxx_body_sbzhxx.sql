/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_sbzhxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,jkrq varchar2(4000) -- 缴款日期
    ,skzl_dm varchar2(4000) -- 税款种类代码
    ,zspmmc varchar2(4000) -- 征收品目名称
    ,spuuid varchar2(4000) -- 税票uuid
    ,zsxmmc varchar2(4000) -- 征收项目名称
    ,pzhm varchar2(4000) -- 票证号码
    ,jkqx varchar2(4000) -- 缴款期限
    ,skssqz varchar2(4000) -- 税款所属期止
    ,zspm_dm varchar2(4000) -- 征收品目代码
    ,skzlmc varchar2(4000) -- 税款种类名称
    ,sl_1 varchar2(4000) -- 税率
    ,skssqq varchar2(4000) -- 税款所属期起
    ,sbzhxx varchar2(4000) -- 关联标签
    ,sjje varchar2(4000) -- 实缴金额
    ,zsxm_dm varchar2(4000) -- 征收项目代码
    ,djxh varchar2(4000) -- 登记序号
    ,jsyj varchar2(4000) -- 计税依据
    ,dzsphm varchar2(4000) -- 电子税票号码
    ,rkrq varchar2(4000) -- 入库日期
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
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx is '广东税局纳税人涉税信息征收缴款信息';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.jkrq is '缴款日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.skzl_dm is '税款种类代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.zspmmc is '征收品目名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.spuuid is '税票uuid';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.zsxmmc is '征收项目名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.pzhm is '票证号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.jkqx is '缴款期限';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.skssqz is '税款所属期止';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.zspm_dm is '征收品目代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.skzlmc is '税款种类名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.sl_1 is '税率';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.skssqq is '税款所属期起';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.sbzhxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.sjje is '实缴金额';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.zsxm_dm is '征收项目代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.jsyj is '计税依据';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.dzsphm is '电子税票号码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.rkrq is '入库日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_sbzhxx.etl_timestamp is 'ETL处理时间戳';
