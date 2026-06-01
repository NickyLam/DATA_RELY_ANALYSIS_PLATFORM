/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_handle_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_handle_approve
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_handle_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_handle_approve(
    serialno varchar2(64) -- 流水号
    ,programno varchar2(64) -- 方案编号
    ,riskassetlist varchar2(2000) -- 风险资产清单
    ,programname varchar2(400) -- 方案名称
    ,deleteflag varchar2(12) -- 删除标识
    ,approveinputdate date -- 批复录入日期
    ,approveuserid varchar2(64) -- 批复录入人
    ,approveorgid varchar2(64) -- 批复机构
    ,customerid varchar2(64) -- 方案涉及借款人编号
    ,certid varchar2(18) -- 借款人证件号码
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,branchbank varchar2(160) -- 分支行
    ,remark varchar2(4000) -- 备注
    ,summarize varchar2(4000) -- 方案综述
    ,approvecontent varchar2(4000) -- 批复内容
    ,approvestatus varchar2(36) -- 审批状态
    ,certtype varchar2(4) -- 借款人证件类型
    ,handletype varchar2(36) -- 处置类型
    ,inputuserid varchar2(64) -- 登记人
    ,customername varchar2(100) -- 方案涉及借款人名称
    ,planno varchar2(64) -- 处置编号
    ,updateuserid varchar2(64) -- 更新人
    ,approveserialno varchar2(64) -- 详细批复编号
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_ap_handle_approve to ${iml_schema};
grant select on ${iol_schema}.icms_ap_handle_approve to ${icl_schema};
grant select on ${iol_schema}.icms_ap_handle_approve to ${idl_schema};
grant select on ${iol_schema}.icms_ap_handle_approve to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_handle_approve is '问题资产审批表';
comment on column ${iol_schema}.icms_ap_handle_approve.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_handle_approve.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_handle_approve.riskassetlist is '风险资产清单';
comment on column ${iol_schema}.icms_ap_handle_approve.programname is '方案名称';
comment on column ${iol_schema}.icms_ap_handle_approve.deleteflag is '删除标识';
comment on column ${iol_schema}.icms_ap_handle_approve.approveinputdate is '批复录入日期';
comment on column ${iol_schema}.icms_ap_handle_approve.approveuserid is '批复录入人';
comment on column ${iol_schema}.icms_ap_handle_approve.approveorgid is '批复机构';
comment on column ${iol_schema}.icms_ap_handle_approve.customerid is '方案涉及借款人编号';
comment on column ${iol_schema}.icms_ap_handle_approve.certid is '借款人证件号码';
comment on column ${iol_schema}.icms_ap_handle_approve.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_handle_approve.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_handle_approve.branchbank is '分支行';
comment on column ${iol_schema}.icms_ap_handle_approve.remark is '备注';
comment on column ${iol_schema}.icms_ap_handle_approve.summarize is '方案综述';
comment on column ${iol_schema}.icms_ap_handle_approve.approvecontent is '批复内容';
comment on column ${iol_schema}.icms_ap_handle_approve.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_ap_handle_approve.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_ap_handle_approve.handletype is '处置类型';
comment on column ${iol_schema}.icms_ap_handle_approve.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_handle_approve.customername is '方案涉及借款人名称';
comment on column ${iol_schema}.icms_ap_handle_approve.planno is '处置编号';
comment on column ${iol_schema}.icms_ap_handle_approve.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_handle_approve.approveserialno is '详细批复编号';
comment on column ${iol_schema}.icms_ap_handle_approve.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_handle_approve.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_handle_approve.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_handle_approve.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_handle_approve.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_handle_approve.etl_timestamp is 'ETL处理时间戳';
