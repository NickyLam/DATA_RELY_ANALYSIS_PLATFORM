/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_af_spot_check_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_af_spot_check_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_af_spot_check_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_af_spot_check_record(
    serialno varchar2(64) -- 流水号
    ,applyno varchar2(64) -- 关联方流水号
    ,customerid varchar2(64) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 关联对象编号
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,signtime date -- 签到时间
    ,signaddress varchar2(300) -- 签到地址
    ,attendeeid varchar2(200) -- 到场用户Id集合
    ,peersremark varchar2(4000) -- 同行人员备注
    ,remark varchar2(4000) -- 图片拍摄备注说明
    ,tasktype varchar2(2) -- 任务模式 1-信贷任务模式 2-展业新建任务模式
    ,workandsigndistance number(22,6) -- 签到地址与办公地距离
    ,registerandsigndistance number(22,6) -- 签到地址与注册地距离
    ,ispresent varchar2(2) -- 分配角色是否到场(code:YesNo)
    ,signreason varchar2(4000) -- 签到原因说明
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
grant select on ${iol_schema}.icms_af_spot_check_record to ${iml_schema};
grant select on ${iol_schema}.icms_af_spot_check_record to ${icl_schema};
grant select on ${iol_schema}.icms_af_spot_check_record to ${idl_schema};
grant select on ${iol_schema}.icms_af_spot_check_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_af_spot_check_record is '现场检查记录表';
comment on column ${iol_schema}.icms_af_spot_check_record.serialno is '流水号';
comment on column ${iol_schema}.icms_af_spot_check_record.applyno is '关联方流水号';
comment on column ${iol_schema}.icms_af_spot_check_record.customerid is '客户编号';
comment on column ${iol_schema}.icms_af_spot_check_record.customername is '客户名称';
comment on column ${iol_schema}.icms_af_spot_check_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_af_spot_check_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_af_spot_check_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_af_spot_check_record.objecttype is '对象类型';
comment on column ${iol_schema}.icms_af_spot_check_record.objectno is '关联对象编号';
comment on column ${iol_schema}.icms_af_spot_check_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_af_spot_check_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_af_spot_check_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_af_spot_check_record.signtime is '签到时间';
comment on column ${iol_schema}.icms_af_spot_check_record.signaddress is '签到地址';
comment on column ${iol_schema}.icms_af_spot_check_record.attendeeid is '到场用户Id集合';
comment on column ${iol_schema}.icms_af_spot_check_record.peersremark is '同行人员备注';
comment on column ${iol_schema}.icms_af_spot_check_record.remark is '图片拍摄备注说明';
comment on column ${iol_schema}.icms_af_spot_check_record.tasktype is '任务模式 1-信贷任务模式 2-展业新建任务模式';
comment on column ${iol_schema}.icms_af_spot_check_record.workandsigndistance is '签到地址与办公地距离';
comment on column ${iol_schema}.icms_af_spot_check_record.registerandsigndistance is '签到地址与注册地距离';
comment on column ${iol_schema}.icms_af_spot_check_record.ispresent is '分配角色是否到场(code:YesNo)';
comment on column ${iol_schema}.icms_af_spot_check_record.signreason is '签到原因说明';
comment on column ${iol_schema}.icms_af_spot_check_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_af_spot_check_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_af_spot_check_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_af_spot_check_record.etl_timestamp is 'ETL处理时间戳';
