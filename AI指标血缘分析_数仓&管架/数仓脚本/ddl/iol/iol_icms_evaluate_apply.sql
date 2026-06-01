/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_evaluate_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_evaluate_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_evaluate_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_evaluate_apply(
    serialno varchar2(32) -- 流水号
    ,evaluateresult2 varchar2(18) -- 分行评级结果
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,taskno varchar2(32) -- 内评流水号
    ,raterisklevel varchar2(20) -- 内评客户评级
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,havescorecard varchar2(10) -- 是否有打分卡
    ,inputdate varchar2(24) -- 登记日期
    ,evaluatetype varchar2(18) -- 评级类型
    ,customername varchar2(100) -- 客户名
    ,evaluateresult1 varchar2(18) -- 支行评级结果
    ,nrrstatus varchar2(10) -- 内评评级状态
    ,evaluateresult3 varchar2(18) -- 总行评级结果
    ,ratelimitamt number(24,6) -- 内评限额
    ,isnrrapply varchar2(1) -- 授信批复内评评级
    ,ratebegindate varchar2(10) -- 评级核定日
    ,modeltype varchar2(18) -- 模型类型
    ,attribute1 varchar2(32) -- 属性一
    ,updatetime varchar2(20) -- 更新时间
    ,isnewcus varchar2(10) -- 是否新客户
    ,attribute3 varchar2(32) -- 属性三
    ,relobjectno varchar2(32) -- 关联对象号
    ,attribute2 varchar2(32) -- 属性二
    ,rateenddate varchar2(10) -- 评级到期日
    ,customerid varchar2(32) -- 客户号
    ,remark varchar2(300) -- 备注
    ,effectflag varchar2(10) -- 生效标志
    ,relobjecttype varchar2(32) -- 关联对象类型
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
grant select on ${iol_schema}.icms_evaluate_apply to ${iml_schema};
grant select on ${iol_schema}.icms_evaluate_apply to ${icl_schema};
grant select on ${iol_schema}.icms_evaluate_apply to ${idl_schema};
grant select on ${iol_schema}.icms_evaluate_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_evaluate_apply is '风险分类申请表';
comment on column ${iol_schema}.icms_evaluate_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_evaluate_apply.evaluateresult2 is '分行评级结果';
comment on column ${iol_schema}.icms_evaluate_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_evaluate_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_evaluate_apply.taskno is '内评流水号';
comment on column ${iol_schema}.icms_evaluate_apply.raterisklevel is '内评客户评级';
comment on column ${iol_schema}.icms_evaluate_apply.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_evaluate_apply.havescorecard is '是否有打分卡';
comment on column ${iol_schema}.icms_evaluate_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_evaluate_apply.evaluatetype is '评级类型';
comment on column ${iol_schema}.icms_evaluate_apply.customername is '客户名';
comment on column ${iol_schema}.icms_evaluate_apply.evaluateresult1 is '支行评级结果';
comment on column ${iol_schema}.icms_evaluate_apply.nrrstatus is '内评评级状态';
comment on column ${iol_schema}.icms_evaluate_apply.evaluateresult3 is '总行评级结果';
comment on column ${iol_schema}.icms_evaluate_apply.ratelimitamt is '内评限额';
comment on column ${iol_schema}.icms_evaluate_apply.isnrrapply is '授信批复内评评级';
comment on column ${iol_schema}.icms_evaluate_apply.ratebegindate is '评级核定日';
comment on column ${iol_schema}.icms_evaluate_apply.modeltype is '模型类型';
comment on column ${iol_schema}.icms_evaluate_apply.attribute1 is '属性一';
comment on column ${iol_schema}.icms_evaluate_apply.updatetime is '更新时间';
comment on column ${iol_schema}.icms_evaluate_apply.isnewcus is '是否新客户';
comment on column ${iol_schema}.icms_evaluate_apply.attribute3 is '属性三';
comment on column ${iol_schema}.icms_evaluate_apply.relobjectno is '关联对象号';
comment on column ${iol_schema}.icms_evaluate_apply.attribute2 is '属性二';
comment on column ${iol_schema}.icms_evaluate_apply.rateenddate is '评级到期日';
comment on column ${iol_schema}.icms_evaluate_apply.customerid is '客户号';
comment on column ${iol_schema}.icms_evaluate_apply.remark is '备注';
comment on column ${iol_schema}.icms_evaluate_apply.effectflag is '生效标志';
comment on column ${iol_schema}.icms_evaluate_apply.relobjecttype is '关联对象类型';
comment on column ${iol_schema}.icms_evaluate_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_evaluate_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_evaluate_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_evaluate_apply.etl_timestamp is 'ETL处理时间戳';
