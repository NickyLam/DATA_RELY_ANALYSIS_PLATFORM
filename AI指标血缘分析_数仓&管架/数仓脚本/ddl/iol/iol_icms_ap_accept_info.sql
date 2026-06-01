/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_accept_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_accept_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_accept_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_accept_info(
    acceptno varchar2(64) -- 受理编号
    ,clearingdate date -- 清算组成立日期
    ,bankruptdefendantid varchar2(2000) -- 破产被申请人编号
    ,thirdparty varchar2(2000) -- 第三人
    ,overseeresult varchar2(1000) -- 立案审查结果
    ,acceptorg varchar2(400) -- 受理仲裁机构
    ,remark varchar2(1000) -- 备注
    ,accuserids varchar2(2000) -- 原告编号
    ,defendant varchar2(2000) -- 被告
    ,refuseacceptdate date -- 不予受理日期
    ,clearingmember varchar2(1000) -- 清算组成员
    ,acceptcourt varchar2(400) -- 受理法院
    ,bankruptcyflag varchar2(12) -- 是否破产
    ,defendantids varchar2(2000) -- 被告人编号
    ,thirdpartyids varchar2(2000) -- 第三人编号
    ,legaliinstruments varchar2(2000) -- 起诉状
    ,updateorgid varchar2(64) -- 更新机构编号
    ,acceptflag varchar2(2) -- 是否受理
    ,caseprogramstage varchar2(36) -- 程序阶段
    ,inadmissibleruling varchar2(2000) -- 不予受理裁定
    ,tmsp varchar2(64) -- 时间戳
    ,accuser varchar2(2000) -- 原告
    ,inputorgid varchar2(64) -- 登记机构编号
    ,acceptdate date -- 受理日期
    ,bankruptdefendant varchar2(2000) -- 破产被申请人
    ,inputuserid varchar2(64) -- 登记人编号
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,retrialdecision varchar2(2000) -- 再审裁定书
    ,bankruptcyapplicant varchar2(2000) -- 破产申请人
    ,caseid varchar2(400) -- 案号
    ,applydate date -- 申请日期
    ,arbaccinstrumen varchar2(2000) -- 仲裁受理文书
    ,caseno varchar2(64) -- 关联案件项目编号
    ,saveflag varchar2(2) -- 受理信息表保存状态
    ,fileno varchar2(64) -- 影像平台编号
    ,acceptnotice varchar2(2000) -- 受理通知书
    ,retrialtype varchar2(64) -- 再审类型
    ,dishonestyflag varchar2(12) -- 是否“失信被执行人名单”
    ,highcostflag varchar2(12) -- 是否“限制高消费名单”
    ,updateuserid varchar2(64) -- 更新人编号
    ,operateusername varchar2(400) -- 指定破产管理人名称
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
grant select on ${iol_schema}.icms_ap_accept_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_accept_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_accept_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_accept_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_accept_info is '受理信息表';
comment on column ${iol_schema}.icms_ap_accept_info.acceptno is '受理编号';
comment on column ${iol_schema}.icms_ap_accept_info.clearingdate is '清算组成立日期';
comment on column ${iol_schema}.icms_ap_accept_info.bankruptdefendantid is '破产被申请人编号';
comment on column ${iol_schema}.icms_ap_accept_info.thirdparty is '第三人';
comment on column ${iol_schema}.icms_ap_accept_info.overseeresult is '立案审查结果';
comment on column ${iol_schema}.icms_ap_accept_info.acceptorg is '受理仲裁机构';
comment on column ${iol_schema}.icms_ap_accept_info.remark is '备注';
comment on column ${iol_schema}.icms_ap_accept_info.accuserids is '原告编号';
comment on column ${iol_schema}.icms_ap_accept_info.defendant is '被告';
comment on column ${iol_schema}.icms_ap_accept_info.refuseacceptdate is '不予受理日期';
comment on column ${iol_schema}.icms_ap_accept_info.clearingmember is '清算组成员';
comment on column ${iol_schema}.icms_ap_accept_info.acceptcourt is '受理法院';
comment on column ${iol_schema}.icms_ap_accept_info.bankruptcyflag is '是否破产';
comment on column ${iol_schema}.icms_ap_accept_info.defendantids is '被告人编号';
comment on column ${iol_schema}.icms_ap_accept_info.thirdpartyids is '第三人编号';
comment on column ${iol_schema}.icms_ap_accept_info.legaliinstruments is '起诉状';
comment on column ${iol_schema}.icms_ap_accept_info.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_accept_info.acceptflag is '是否受理';
comment on column ${iol_schema}.icms_ap_accept_info.caseprogramstage is '程序阶段';
comment on column ${iol_schema}.icms_ap_accept_info.inadmissibleruling is '不予受理裁定';
comment on column ${iol_schema}.icms_ap_accept_info.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_accept_info.accuser is '原告';
comment on column ${iol_schema}.icms_ap_accept_info.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_accept_info.acceptdate is '受理日期';
comment on column ${iol_schema}.icms_ap_accept_info.bankruptdefendant is '破产被申请人';
comment on column ${iol_schema}.icms_ap_accept_info.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_accept_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_accept_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_accept_info.retrialdecision is '再审裁定书';
comment on column ${iol_schema}.icms_ap_accept_info.bankruptcyapplicant is '破产申请人';
comment on column ${iol_schema}.icms_ap_accept_info.caseid is '案号';
comment on column ${iol_schema}.icms_ap_accept_info.applydate is '申请日期';
comment on column ${iol_schema}.icms_ap_accept_info.arbaccinstrumen is '仲裁受理文书';
comment on column ${iol_schema}.icms_ap_accept_info.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_accept_info.saveflag is '受理信息表保存状态';
comment on column ${iol_schema}.icms_ap_accept_info.fileno is '影像平台编号';
comment on column ${iol_schema}.icms_ap_accept_info.acceptnotice is '受理通知书';
comment on column ${iol_schema}.icms_ap_accept_info.retrialtype is '再审类型';
comment on column ${iol_schema}.icms_ap_accept_info.dishonestyflag is '是否“失信被执行人名单”';
comment on column ${iol_schema}.icms_ap_accept_info.highcostflag is '是否“限制高消费名单”';
comment on column ${iol_schema}.icms_ap_accept_info.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_accept_info.operateusername is '指定破产管理人名称';
comment on column ${iol_schema}.icms_ap_accept_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_accept_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_accept_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_accept_info.etl_timestamp is 'ETL处理时间戳';
