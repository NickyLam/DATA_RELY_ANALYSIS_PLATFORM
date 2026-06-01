/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_impoversee_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_impoversee_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_impoversee_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_impoversee_info(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(64) -- 客户编号
    ,validstatus varchar2(10) -- 状态010有效020失效
    ,updatedate date -- 更新日期
    ,delflag varchar2(10) -- 删除标志(1-已删除)
    ,inputdate date -- 申请日期
    ,customername varchar2(200) -- 客户名称
    ,logofftype varchar2(10) -- 退出方式
    ,validdate date -- 生效日期
    ,otherinreason varchar2(800) -- 其他进入原因
    ,delorgid varchar2(64) -- 删除机构
    ,migtflag varchar2(80) -- 
    ,passlevel varchar2(10) -- 批准机构级别010总行批准020分行批准
    ,capacitytype varchar2(10) -- 认定方式010直接认定020流程认定
    ,currentprocessstatus varchar2(10) -- 当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认
    ,approvebusinesssum number(24,6) -- 申请时批复授信金额
    ,approvestatus varchar2(10) -- 审批状态
    ,isimpcustomerflag varchar2(10) -- 是否为重点监测客户
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(12) -- 登记机构编号
    ,addflag varchar2(10) -- 新增标志010人工新增020批量新增
    ,inreason varchar2(1300) -- 进入原因
    ,passorgid varchar2(64) -- 批准机构
    ,risklevel varchar2(10) -- 风险级别
    ,updateuserid varchar2(64) -- 更新人编号
    ,inapplybusinessbalance number(24,6) -- 进入时授信余额
    ,quitereason varchar2(1500) -- 退出原因
    ,deluserid varchar2(64) -- 删除用户
    ,currentapplytype varchar2(10) -- 当前申请类型：ApplyIn-申请进入ApplyOut-申请退出
    ,updateorgid varchar2(64) -- 更新机构编号
    ,inapproveexposuresum number(24,6) -- 进入时批复敞口金额
    ,levelmanage varchar2(32) -- 层级管理010总行020分行030支行/团队
    ,relativeserailno varchar2(32) -- 关联的申请流水
    ,inapplyexposurebalance number(24,6) -- 进入时敞口余额
    ,logoffdescript varchar2(1500) -- 退出措施
    ,manageuserid varchar2(64) -- 管户人
    ,passuserid varchar2(64) -- 批准人
    ,quitedate date -- 退出日期
    ,inapprovebusinesssum number(24,6) -- 进入时批复授信金额
    ,manageorgid varchar2(32) -- 管户机构
    ,deldate date -- 删除日期
    ,approveexposuresum number(24,6) -- 申请时批复敞口金额
    ,customertype varchar2(32) -- 客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户
    ,applybusinessbalance number(24,6) -- 申请时授信余额
    ,applyexposurebalance number(24,6) -- 申请时敞口余额
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
grant select on ${iol_schema}.icms_impoversee_info to ${iml_schema};
grant select on ${iol_schema}.icms_impoversee_info to ${icl_schema};
grant select on ${iol_schema}.icms_impoversee_info to ${idl_schema};
grant select on ${iol_schema}.icms_impoversee_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_impoversee_info is '重点监测客户名单表';
comment on column ${iol_schema}.icms_impoversee_info.serialno is '流水号';
comment on column ${iol_schema}.icms_impoversee_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_impoversee_info.validstatus is '状态010有效020失效';
comment on column ${iol_schema}.icms_impoversee_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_impoversee_info.delflag is '删除标志(1-已删除)';
comment on column ${iol_schema}.icms_impoversee_info.inputdate is '申请日期';
comment on column ${iol_schema}.icms_impoversee_info.customername is '客户名称';
comment on column ${iol_schema}.icms_impoversee_info.logofftype is '退出方式';
comment on column ${iol_schema}.icms_impoversee_info.validdate is '生效日期';
comment on column ${iol_schema}.icms_impoversee_info.otherinreason is '其他进入原因';
comment on column ${iol_schema}.icms_impoversee_info.delorgid is '删除机构';
comment on column ${iol_schema}.icms_impoversee_info.migtflag is '';
comment on column ${iol_schema}.icms_impoversee_info.passlevel is '批准机构级别010总行批准020分行批准';
comment on column ${iol_schema}.icms_impoversee_info.capacitytype is '认定方式010直接认定020流程认定';
comment on column ${iol_schema}.icms_impoversee_info.currentprocessstatus is '当前流程状态：ToFinished-待完成ToConfirm-待确认HasConfirm-已确认';
comment on column ${iol_schema}.icms_impoversee_info.approvebusinesssum is '申请时批复授信金额';
comment on column ${iol_schema}.icms_impoversee_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_impoversee_info.isimpcustomerflag is '是否为重点监测客户';
comment on column ${iol_schema}.icms_impoversee_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_impoversee_info.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_impoversee_info.addflag is '新增标志010人工新增020批量新增';
comment on column ${iol_schema}.icms_impoversee_info.inreason is '进入原因';
comment on column ${iol_schema}.icms_impoversee_info.passorgid is '批准机构';
comment on column ${iol_schema}.icms_impoversee_info.risklevel is '风险级别';
comment on column ${iol_schema}.icms_impoversee_info.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_impoversee_info.inapplybusinessbalance is '进入时授信余额';
comment on column ${iol_schema}.icms_impoversee_info.quitereason is '退出原因';
comment on column ${iol_schema}.icms_impoversee_info.deluserid is '删除用户';
comment on column ${iol_schema}.icms_impoversee_info.currentapplytype is '当前申请类型：ApplyIn-申请进入ApplyOut-申请退出';
comment on column ${iol_schema}.icms_impoversee_info.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_impoversee_info.inapproveexposuresum is '进入时批复敞口金额';
comment on column ${iol_schema}.icms_impoversee_info.levelmanage is '层级管理010总行020分行030支行/团队';
comment on column ${iol_schema}.icms_impoversee_info.relativeserailno is '关联的申请流水';
comment on column ${iol_schema}.icms_impoversee_info.inapplyexposurebalance is '进入时敞口余额';
comment on column ${iol_schema}.icms_impoversee_info.logoffdescript is '退出措施';
comment on column ${iol_schema}.icms_impoversee_info.manageuserid is '管户人';
comment on column ${iol_schema}.icms_impoversee_info.passuserid is '批准人';
comment on column ${iol_schema}.icms_impoversee_info.quitedate is '退出日期';
comment on column ${iol_schema}.icms_impoversee_info.inapprovebusinesssum is '进入时批复授信金额';
comment on column ${iol_schema}.icms_impoversee_info.manageorgid is '管户机构';
comment on column ${iol_schema}.icms_impoversee_info.deldate is '删除日期';
comment on column ${iol_schema}.icms_impoversee_info.approveexposuresum is '申请时批复敞口金额';
comment on column ${iol_schema}.icms_impoversee_info.customertype is '客户类型01公司客户02集团客户03个人客户0310个人客户0320个体经营户';
comment on column ${iol_schema}.icms_impoversee_info.applybusinessbalance is '申请时授信余额';
comment on column ${iol_schema}.icms_impoversee_info.applyexposurebalance is '申请时敞口余额';
comment on column ${iol_schema}.icms_impoversee_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_impoversee_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_impoversee_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_impoversee_info.etl_timestamp is 'ETL处理时间戳';
