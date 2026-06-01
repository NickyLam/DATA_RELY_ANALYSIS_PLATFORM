/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ftp_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ftp_register
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ftp_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_register(
    ord_id varchar2(75) -- 审批单号
    ,ftp_code varchar2(30) -- 方案编号 年月日+3位序列号
    ,ftp_name varchar2(300) -- 方案名称
    ,type varchar2(150) -- 方案类别
    ,spread number(16,2) -- ftp点差(bp)
    ,start_date varchar2(15) -- 起始日
    ,end_date varchar2(15) -- 终止日
    ,remark varchar2(450) -- 内容说明
    ,opreator varchar2(30) -- 登记用户
    ,reg_date varchar2(15) -- 登记日期
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
grant select on ${iol_schema}.ibms_ttrd_ftp_register to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_register to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_register to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ftp_register is 'FTP活动方案审批单';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.ord_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.ftp_code is '方案编号 年月日+3位序列号';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.ftp_name is '方案名称';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.type is '方案类别';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.spread is 'ftp点差(bp)';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.start_date is '起始日';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.end_date is '终止日';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.remark is '内容说明';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.opreator is '登记用户';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.reg_date is '登记日期';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_ftp_register.etl_timestamp is 'ETL处理时间戳';
