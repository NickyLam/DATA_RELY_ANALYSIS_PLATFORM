/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_cpmtinst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_mpcs_cpmtinst
whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_cpmtinst purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_mpcs_cpmtinst(
    etl_dt date -- 数据日期
    ,instno varchar2(10) -- 机构号
    ,upinstno varchar2(10) -- 上级机构号
    ,instlvl varchar2(1) -- 机构级别
    ,instname varchar2(60) -- 机构名称
    ,instabrname varchar2(60) -- 机构简称
    ,instaddr varchar2(80) -- 机构地址
    ,instenname varchar2(60) -- 机构英文名
    ,instenabrname varchar2(20) -- 机构英文简称
    ,instenaddr varchar2(80) -- 机构英文地址
    ,insttel varchar2(20) -- 机构联系电话
    ,instemail varchar2(60) -- 机构电子邮箱
    ,insttype varchar2(1) -- 机构类型
    ,centflag varchar2(1) -- 机构标识
    ,seqnoprefix varchar2(6) -- 机构
    ,acctinstlvl varchar2(1) -- 清算级别
    ,upacctinst varchar2(10) -- 上级清算机构
    ,bankno varchar2(12) -- 机构行号
    ,citycd varchar2(6) -- 机构城市代码
    ,isleaf varchar2(1) -- 是否网点？
    ,rowstat varchar2(1) -- 状态
    ,upddt varchar2(8) -- 修改日期
    ,updtm varchar2(6) -- 修改时间
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_cpmtinst to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_cpmtinst is '行内机构表';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instno is '机构号';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.upinstno is '上级机构号';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instlvl is '机构级别';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instname is '机构名称';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instabrname is '机构简称';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instaddr is '机构地址';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instenname is '机构英文名';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instenabrname is '机构英文简称';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instenaddr is '机构英文地址';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.insttel is '机构联系电话';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.instemail is '机构电子邮箱';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.insttype is '机构类型';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.centflag is '机构标识';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.seqnoprefix is '机构';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.acctinstlvl is '清算级别';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.upacctinst is '上级清算机构';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.bankno is '机构行号';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.citycd is '机构城市代码';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.isleaf is '是否网点？';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.rowstat is '状态';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.upddt is '修改日期';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.updtm is '修改时间';
comment on column ${idl_schema}.aml_mpcs_cpmtinst.etl_timestamp is '数据处理时间';
