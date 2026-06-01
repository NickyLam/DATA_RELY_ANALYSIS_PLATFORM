/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a20tsafeboxfileinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a20tsafeboxfileinf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a20tsafeboxfileinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a20tsafeboxfileinf(
    insertdt varchar2(12) -- 登记日期
    ,inserttm varchar2(9) -- 登记时间
    ,filename varchar2(150) -- 文件名
    ,totalnum number(22) -- 总笔数
    ,sucnum number(22) -- 成功笔数
    ,failnum number(22) -- 失败笔数
    ,status varchar2(2) -- 状态 f-全部失败;s-全部成功;m-部分成功
    ,fill varchar2(75) -- 处理结果描述
    ,bgintm varchar2(30) -- 文件处理开始时间
    ,edntm varchar2(30) -- 文件处理结束时间
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
grant select on ${iol_schema}.mpcs_a20tsafeboxfileinf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxfileinf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxfileinf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxfileinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a20tsafeboxfileinf is '保管箱开关箱明细文件处理表';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.insertdt is '登记日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.inserttm is '登记时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.filename is '文件名';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.totalnum is '总笔数';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.sucnum is '成功笔数';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.failnum is '失败笔数';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.status is '状态 f-全部失败;s-全部成功;m-部分成功';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.fill is '处理结果描述';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.bgintm is '文件处理开始时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.edntm is '文件处理结束时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxfileinf.etl_timestamp is 'ETL处理时间戳';
