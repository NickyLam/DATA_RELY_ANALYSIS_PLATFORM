/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_case_program
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_case_program
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_case_program purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_program(
    programno varchar2(64) -- 方案编号
    ,inputdate date -- 登记日期
    ,approvestatus varchar2(12) -- 审批状态
    ,remark varchar2(1000) -- 备注
    ,agencytype varchar2(12) -- 代理类型
    ,agencostsum number(24,6) -- 代理费用总额
    ,bankposition varchar2(12) -- 我行地位
    ,methodtype varchar2(12) -- 方案类型
    ,tmsp varchar2(64) -- 时间戳
    ,inputuserid varchar2(64) -- 登记人编号
    ,updatedate date -- 更新日期
    ,fileno varchar2(64) -- 影像平台编号
    ,agencostpaydesc varchar2(4000) -- 代理费用支付说明
    ,caseno varchar2(64) -- 案件项目编号
    ,agencyteam varchar2(400) -- 代理团队
    ,agencostpayway varchar2(12) -- 代理费用支付方式
    ,acceptunitname varchar2(400) -- 受理单位名称
    ,lawfirmdesc varchar2(4000) -- 拟聘律师事务所简要情况
    ,lawfirmid varchar2(64) -- 律所编号
    ,programserno varchar2(160) -- 方案流水号
    ,deleteflag varchar2(12) -- 删除标识
    ,lawfirmname varchar2(400) -- 律所名称
    ,programname varchar2(1000) -- 方案名称
    ,lawyername varchar2(400) -- 代理律师
    ,updateuserid varchar2(64) -- 更新人编号
    ,casename varchar2(1000) -- 案件项目名称
    ,casedesc varchar2(4000) -- 案例情况详细说明及疑难点
    ,suitrequest varchar2(4000) -- 诉讼请求
    ,suitthink varchar2(4000) -- 诉讼思路
    ,caseprogramstage varchar2(36) -- 程序阶段
    ,inputorgid varchar2(64) -- 登记机构名称编号
    ,updateorgid varchar2(64) -- 更新机构
    ,acceptunitid varchar2(64) -- 受理单位编号
    ,selectiontime date -- 选聘时间
    ,reportflag varchar2(12) -- 是否上报总行
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
grant select on ${iol_schema}.icms_ap_case_program to ${iml_schema};
grant select on ${iol_schema}.icms_ap_case_program to ${icl_schema};
grant select on ${iol_schema}.icms_ap_case_program to ${idl_schema};
grant select on ${iol_schema}.icms_ap_case_program to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_case_program is '案件方案信息表';
comment on column ${iol_schema}.icms_ap_case_program.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_case_program.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_case_program.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_case_program.remark is '备注';
comment on column ${iol_schema}.icms_ap_case_program.agencytype is '代理类型';
comment on column ${iol_schema}.icms_ap_case_program.agencostsum is '代理费用总额';
comment on column ${iol_schema}.icms_ap_case_program.bankposition is '我行地位';
comment on column ${iol_schema}.icms_ap_case_program.methodtype is '方案类型';
comment on column ${iol_schema}.icms_ap_case_program.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_case_program.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_case_program.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_case_program.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_case_program.agencostpaydesc is '代理费用支付说明';
comment on column ${iol_schema}.icms_ap_case_program.caseno is '案件项目编号';
comment on column ${iol_schema}.icms_ap_case_program.agencyteam is '代理团队';
comment on column ${iol_schema}.icms_ap_case_program.agencostpayway is '代理费用支付方式';
comment on column ${iol_schema}.icms_ap_case_program.acceptunitname is '受理单位名称';
comment on column ${iol_schema}.icms_ap_case_program.lawfirmdesc is '拟聘律师事务所简要情况';
comment on column ${iol_schema}.icms_ap_case_program.lawfirmid is '律所编号';
comment on column ${iol_schema}.icms_ap_case_program.programserno is '方案流水号';
comment on column ${iol_schema}.icms_ap_case_program.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_case_program.lawfirmname is '律所名称';
comment on column ${iol_schema}.icms_ap_case_program.programname is '方案名称';
comment on column ${iol_schema}.icms_ap_case_program.lawyername is '代理律师';
comment on column ${iol_schema}.icms_ap_case_program.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_case_program.casename is '案件项目名称';
comment on column ${iol_schema}.icms_ap_case_program.casedesc is '案例情况详细说明及疑难点';
comment on column ${iol_schema}.icms_ap_case_program.suitrequest is '诉讼请求';
comment on column ${iol_schema}.icms_ap_case_program.suitthink is '诉讼思路';
comment on column ${iol_schema}.icms_ap_case_program.caseprogramstage is '程序阶段';
comment on column ${iol_schema}.icms_ap_case_program.inputorgid is '登记机构名称编号';
comment on column ${iol_schema}.icms_ap_case_program.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_case_program.acceptunitid is '受理单位编号';
comment on column ${iol_schema}.icms_ap_case_program.selectiontime is '选聘时间';
comment on column ${iol_schema}.icms_ap_case_program.reportflag is '是否上报总行';
comment on column ${iol_schema}.icms_ap_case_program.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_case_program.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_case_program.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_case_program.etl_timestamp is 'ETL处理时间戳';
