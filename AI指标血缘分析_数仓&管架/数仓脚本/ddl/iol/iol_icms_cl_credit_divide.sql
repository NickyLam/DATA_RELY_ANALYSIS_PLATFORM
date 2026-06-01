/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_divide
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_divide
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_divide purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_divide(
    inputuserid varchar2(64) -- 登记人
    ,ifexclusivecredit varchar2(2) -- 是否专属
    ,dividetype varchar2(64) -- 切分类型:机构/产品/客户
    ,nominalamount number(24,6) -- 切分名义金额
    ,occupynominalamount number(24,6) -- 占用名义金额
    ,availableriskexposuresum number(24,6) -- 一般风险可用敞口金额
    ,updateorgid varchar2(64) -- 更新机构
    ,objectname varchar2(2000) -- 切分对象的名称
    ,updatedate timestamp -- 更新日期
    ,availablenominalsum number(24,6) -- 可用名义金额
    ,recyclable varchar2(2) -- 可循环标志
    ,occupyexposureamount number(24,6) -- 占用敞口金额
    ,lowriskexposuresum number(24,6) -- 类低风险敞口金额
    ,parentdivideno varchar2(64) -- 上层控制编号
    ,inputorgid varchar2(64) -- 登记机构
    ,divideno varchar2(64) -- 控制编号
    ,creditno varchar2(64) -- 额度系统业务编号
    ,updateuserid varchar2(64) -- 更新人
    ,availableexposuresum number(24,6) -- 可用敞口金额
    ,objectno varchar2(2000) -- 切分对象的编号
    ,riskexposuresum number(24,6) -- 一般敞口金额
    ,availablelowriskexposuresum number(24,6) -- 类低风险可用敞口金额
    ,dividecurrency varchar2(64) -- 切分币种
    ,exposureamount number(24,6) -- 切分敞口金额
    ,inputdate timestamp -- 登记日期
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
grant select on ${iol_schema}.icms_cl_credit_divide to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_divide to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_divide to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_divide to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_divide is '额度切分';
comment on column ${iol_schema}.icms_cl_credit_divide.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_divide.ifexclusivecredit is '是否专属';
comment on column ${iol_schema}.icms_cl_credit_divide.dividetype is '切分类型:机构/产品/客户';
comment on column ${iol_schema}.icms_cl_credit_divide.nominalamount is '切分名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide.occupynominalamount is '占用名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide.availableriskexposuresum is '一般风险可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_credit_divide.objectname is '切分对象的名称';
comment on column ${iol_schema}.icms_cl_credit_divide.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_credit_divide.availablenominalsum is '可用名义金额';
comment on column ${iol_schema}.icms_cl_credit_divide.recyclable is '可循环标志';
comment on column ${iol_schema}.icms_cl_credit_divide.occupyexposureamount is '占用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.lowriskexposuresum is '类低风险敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.parentdivideno is '上层控制编号';
comment on column ${iol_schema}.icms_cl_credit_divide.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_divide.divideno is '控制编号';
comment on column ${iol_schema}.icms_cl_credit_divide.creditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_divide.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_credit_divide.availableexposuresum is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.objectno is '切分对象的编号';
comment on column ${iol_schema}.icms_cl_credit_divide.riskexposuresum is '一般敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.availablelowriskexposuresum is '类低风险可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.dividecurrency is '切分币种';
comment on column ${iol_schema}.icms_cl_credit_divide.exposureamount is '切分敞口金额';
comment on column ${iol_schema}.icms_cl_credit_divide.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_divide.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_credit_divide.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_credit_divide.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_credit_divide.etl_timestamp is 'ETL处理时间戳';
