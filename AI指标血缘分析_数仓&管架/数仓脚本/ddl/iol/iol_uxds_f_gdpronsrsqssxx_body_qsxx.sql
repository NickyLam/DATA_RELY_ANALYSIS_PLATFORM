/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_gdpronsrsqssxx_body_qsxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,qsxx varchar2(4000) -- 关联标签
    ,zspmmc varchar2(4000) -- 征收品目名称
    ,zsxmmc varchar2(4000) -- 征收项目名称
    ,jkqx varchar2(4000) -- 缴款期限
    ,skssqz varchar2(4000) -- 税款所属期止
    ,zspm_dm varchar2(4000) -- 征收品目代码
    ,ynse varchar2(4000) -- 应纳税额
    ,skssqq varchar2(4000) -- 税款所属期起
    ,zsxm_dm varchar2(4000) -- 征收项目代码
    ,djxh varchar2(4000) -- 登记序号
    ,jmse varchar2(4000) -- 减免税额
    ,jsyj varchar2(4000) -- 计税依据
    ,zsuuid varchar2(4000) -- 征收uuid
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
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx is '广东税局纳税人涉税信息欠税信息';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.qsxx is '关联标签';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.zspmmc is '征收品目名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.zsxmmc is '征收项目名称';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.jkqx is '缴款期限';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.skssqz is '税款所属期止';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.zspm_dm is '征收品目代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.ynse is '应纳税额';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.skssqq is '税款所属期起';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.zsxm_dm is '征收项目代码';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.djxh is '登记序号';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.jmse is '减免税额';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.jsyj is '计税依据';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.zsuuid is '征收uuid';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.rkrq is '入库日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_gdpronsrsqssxx_body_qsxx.etl_timestamp is 'ETL处理时间戳';
