/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_divide_serial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_divide_serial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_divide_serial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_divide_serial(
    creditno varchar2(64) -- 额度系统业务编号
    ,inputuserid varchar2(64) -- 登记人
    ,dividecurrency varchar2(64) -- 切分币种
    ,exposureamount number(24,6) -- 切分敞口金额
    ,occupyexposureamount number(24,6) -- 占用敞口金额
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,dividetype varchar2(64) -- 切分类型:机构/产品/客户
    ,parentdivideno varchar2(64) -- 上层控制编号
    ,divideno varchar2(64) -- 控制编号
    ,nominalamount number(24,6) -- 切分名义金额
    ,occupynominalamount number(24,6) -- 占用名义金额
    ,objectno varchar2(2000) -- 切分对象的编号
    ,objectname varchar2(2000) -- 切分对象的名称
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate timestamp -- 更新日期
    ,serialno varchar2(64) -- 流水号
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
grant select on ${iol_schema}.icms_cl_credit_divide_serial to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_divide_serial to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_divide_serial to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_divide_serial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_divide_serial is '额度切分流水';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.creditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.dividecurrency is '切分币种';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.exposureamount is '切分敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.occupyexposureamount is '占用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.dividetype is '切分类型:机构/产品/客户';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.parentdivideno is '上层控制编号';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.divideno is '控制编号';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.nominalamount is '切分名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.occupynominalamount is '占用名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.objectno is '切分对象的编号';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.objectname is '切分对象的名称';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_credit_divide_serial.etl_timestamp is 'ETL处理时间戳';
