/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_zjbk_inctrctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_zjbk_inctrctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_zjbk_inctrctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_zjbk_inctrctinfo(
    infrectype varchar2(3) -- 信息记录类型
    ,contractcode varchar2(60) -- 授信协议标识码
    ,rptdate varchar2(32) -- 信息报告日期
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,name varchar2(100) -- 受信人姓名
    ,idtype varchar2(4) -- 受信人证件类型
    ,idnum varchar2(20) -- 受信人证件号码
    ,mngmtorgcode varchar2(14) -- 业务管理机构代码
    ,ctrctcertrelsgmt_updflag varchar2(2) -- 共同受信人信息段上报标志
    ,creditlimsgmt_updflag varchar2(2) -- 额度信息段上报标志
    ,brernm varchar2(32) -- 共同受信人个数
    ,ctrctcertreldata varchar2(2000) -- 共同受信人信息段
    ,creditlimtype varchar2(2) -- 授信额度类型
    ,limloopflg varchar2(1) -- 额度循环标志
    ,creditlim varchar2(32) -- 授信额度
    ,cy varchar2(3) -- 币种
    ,coneffdate varchar2(32) -- 额度生效日期
    ,conexpdate varchar2(32) -- 额度到期日期
    ,constatus varchar2(1) -- 额度状态
    ,creditrest varchar2(32) -- 授信限额
    ,creditrestcode varchar2(60) -- 授信限额编号
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
grant select on ${iol_schema}.icms_tmp_zjbk_inctrctinfo to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inctrctinfo to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inctrctinfo to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_zjbk_inctrctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_zjbk_inctrctinfo is '人行征信文件中间数据-个人授信协议信息记录表';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.contractcode is '授信协议标识码';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.name is '受信人姓名';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.idtype is '受信人证件类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.idnum is '受信人证件号码';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.ctrctcertrelsgmt_updflag is '共同受信人信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.creditlimsgmt_updflag is '额度信息段上报标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.brernm is '共同受信人个数';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.ctrctcertreldata is '共同受信人信息段';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.creditlimtype is '授信额度类型';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.limloopflg is '额度循环标志';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.creditlim is '授信额度';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.cy is '币种';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.coneffdate is '额度生效日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.conexpdate is '额度到期日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.constatus is '额度状态';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.creditrest is '授信限额';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.creditrestcode is '授信限额编号';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_zjbk_inctrctinfo.etl_timestamp is 'ETL处理时间戳';
