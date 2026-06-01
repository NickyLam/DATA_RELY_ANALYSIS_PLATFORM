/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_proce_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_proce_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_proce_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_apply(
    applyno varchar2(64) -- 破产权利申报编号
    ,declareamt number(24,6) -- 申报金额
    ,declaredate date -- 申报日期
    ,firmamt number(24,6) -- 认定金额
    ,saveflag varchar2(12) -- 保存状态
    ,remark varchar2(1000) -- 备注
    ,updateuserid varchar2(64) -- 更新人编号
    ,caseno varchar2(64) -- 关联案件项目编号
    ,firmdate date -- 认定日期
    ,description varchar2(2000) -- 文字描述
    ,ispledge varchar2(12) -- 是否有抵质押
    ,inputuserid varchar2(64) -- 登记人编号
    ,bankappearratio number(24,6) -- 我行债权比例
    ,tmsp varchar2(64) -- 时间戳
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputdate date -- 登记日期
    ,pledgeamt number(24,6) -- 抵质押金额
    ,appearratio number(24,6) -- 债权比例
    ,updateorgid varchar2(64) -- 更新机构编号
    ,appearid varchar2(64) -- 债权申报人编号
    ,updatedate date -- 更新日期
    ,appearname varchar2(400) -- 债权申报人
    ,caseprogramstage varchar2(36) -- 程序阶段信息
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
grant select on ${iol_schema}.icms_ap_proce_apply to ${iml_schema};
grant select on ${iol_schema}.icms_ap_proce_apply to ${icl_schema};
grant select on ${iol_schema}.icms_ap_proce_apply to ${idl_schema};
grant select on ${iol_schema}.icms_ap_proce_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_proce_apply is '破产权利申报信息表';
comment on column ${iol_schema}.icms_ap_proce_apply.applyno is '破产权利申报编号';
comment on column ${iol_schema}.icms_ap_proce_apply.declareamt is '申报金额';
comment on column ${iol_schema}.icms_ap_proce_apply.declaredate is '申报日期';
comment on column ${iol_schema}.icms_ap_proce_apply.firmamt is '认定金额';
comment on column ${iol_schema}.icms_ap_proce_apply.saveflag is '保存状态';
comment on column ${iol_schema}.icms_ap_proce_apply.remark is '备注';
comment on column ${iol_schema}.icms_ap_proce_apply.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_ap_proce_apply.caseno is '关联案件项目编号';
comment on column ${iol_schema}.icms_ap_proce_apply.firmdate is '认定日期';
comment on column ${iol_schema}.icms_ap_proce_apply.description is '文字描述';
comment on column ${iol_schema}.icms_ap_proce_apply.ispledge is '是否有抵质押';
comment on column ${iol_schema}.icms_ap_proce_apply.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_ap_proce_apply.bankappearratio is '我行债权比例';
comment on column ${iol_schema}.icms_ap_proce_apply.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_proce_apply.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ap_proce_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_proce_apply.pledgeamt is '抵质押金额';
comment on column ${iol_schema}.icms_ap_proce_apply.appearratio is '债权比例';
comment on column ${iol_schema}.icms_ap_proce_apply.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_ap_proce_apply.appearid is '债权申报人编号';
comment on column ${iol_schema}.icms_ap_proce_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_proce_apply.appearname is '债权申报人';
comment on column ${iol_schema}.icms_ap_proce_apply.caseprogramstage is '程序阶段信息';
comment on column ${iol_schema}.icms_ap_proce_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_proce_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_proce_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_proce_apply.etl_timestamp is 'ETL处理时间戳';
