/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alarmsign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alarmsign_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alarmsign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alarmsign_info(
    signid varchar2(64) -- 预警号
    ,inputdate date -- 登记日期
    ,signtitle varchar2(18) -- 预警主题
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 更新用户
    ,signdescribe varchar2(4000) -- 预警描述
    ,optionvalue varchar2(18) -- 指标项值
    ,signclass varchar2(18) -- 预警CLASS
    ,signname varchar2(200) -- 预警名称
    ,inputuserid varchar2(64) -- 登记人
    ,signtype varchar2(18) -- 预警信号类型(定量指标，定性指标)
    ,signlevel varchar2(18) -- 预警层级(预警信号等级)
    ,updateorgid varchar2(64) -- 更新机构
    ,isratechangecondition varchar2(8) -- 是否触发评级调整的预警信号:no/空-不是yes-是
    ,signoptiontype varchar2(18) -- 预警指标类型
    ,thresholdvalue varchar2(200) -- 阈值
    ,signobjecttype varchar2(18) -- 预警对象类型
    ,judgment varchar2(18) -- 判断关系
    ,updatedate date -- 更新日期
    ,signcusytomertype varchar2(18) -- 客户类型
    ,triggertimes varchar2(200) -- 触发频率
    ,remark varchar2(100) -- 备注
    ,alertinfosource varchar2(32) -- 
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
grant select on ${iol_schema}.icms_alarmsign_info to ${iml_schema};
grant select on ${iol_schema}.icms_alarmsign_info to ${icl_schema};
grant select on ${iol_schema}.icms_alarmsign_info to ${idl_schema};
grant select on ${iol_schema}.icms_alarmsign_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alarmsign_info is '预警信号详情';
comment on column ${iol_schema}.icms_alarmsign_info.signid is '预警号';
comment on column ${iol_schema}.icms_alarmsign_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_alarmsign_info.signtitle is '预警主题';
comment on column ${iol_schema}.icms_alarmsign_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_alarmsign_info.updateuserid is '更新用户';
comment on column ${iol_schema}.icms_alarmsign_info.signdescribe is '预警描述';
comment on column ${iol_schema}.icms_alarmsign_info.optionvalue is '指标项值';
comment on column ${iol_schema}.icms_alarmsign_info.signclass is '预警CLASS';
comment on column ${iol_schema}.icms_alarmsign_info.signname is '预警名称';
comment on column ${iol_schema}.icms_alarmsign_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_alarmsign_info.signtype is '预警信号类型(定量指标，定性指标)';
comment on column ${iol_schema}.icms_alarmsign_info.signlevel is '预警层级(预警信号等级)';
comment on column ${iol_schema}.icms_alarmsign_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_alarmsign_info.isratechangecondition is '是否触发评级调整的预警信号:no/空-不是yes-是';
comment on column ${iol_schema}.icms_alarmsign_info.signoptiontype is '预警指标类型';
comment on column ${iol_schema}.icms_alarmsign_info.thresholdvalue is '阈值';
comment on column ${iol_schema}.icms_alarmsign_info.signobjecttype is '预警对象类型';
comment on column ${iol_schema}.icms_alarmsign_info.judgment is '判断关系';
comment on column ${iol_schema}.icms_alarmsign_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_alarmsign_info.signcusytomertype is '客户类型';
comment on column ${iol_schema}.icms_alarmsign_info.triggertimes is '触发频率';
comment on column ${iol_schema}.icms_alarmsign_info.remark is '备注';
comment on column ${iol_schema}.icms_alarmsign_info.alertinfosource is '';
comment on column ${iol_schema}.icms_alarmsign_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alarmsign_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alarmsign_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alarmsign_info.etl_timestamp is 'ETL处理时间戳';
